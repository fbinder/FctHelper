classdef FctHelper < handle
    % This class is a set of useful functions providing scientific
    % colormaps based on the publication of Fabio Crameri
    % (https://www.fabiocrameri.ch/colourmaps/), handling timestamps,
    % searching for files with a specific extension and simplifying the
    % usage of the tiled layout plot.

    % Public properties
    properties
        colors;
        colorMaps;
        timeFormat = 'yyyy-MM-dd HH:mm:ss';
    end

    % Public methods
    methods
        % Constructor
        function obj = FctHelper()
            % Add all libs contents to search path
            fileLocation = fileparts(mfilename('fullpath'));
            addpath(obj.FullFilePath('libs\', fileLocation));
            addpath(obj.FullFilePath('libs\ColorMaps\', fileLocation));

            % Load all Colormaps 
            greyRedColormap = load('greyRedColormap.mat');
            obj.colorMaps.greyRedColormap = greyRedColormap.greyRedColormap;
            greenWhiteBlueColormap = load('greenWhiteBlueColormap.mat');
            obj.colorMaps.greenWhiteBlueColormap = greenWhiteBlueColormap.greenWhiteBlueColormap;
            greenWhiteRedColormap = load('greenWhiteRedColormap.mat');
            obj.colorMaps.greenWhiteRedColormap = greenWhiteRedColormap.greenWhiteRedColormap;
            greenYellowRedColormap = load('greenYellowRedColormap.mat');
            obj.colorMaps.greenYellowRedColormap = greenYellowRedColormap.greenYellowRedColormap;
            brightgreyColormap = load('brightgreyColormap.mat');
            obj.colorMaps.brightgreyColormap = brightgreyColormap.brightgreyColormap;
            fauColormap = load('fauColormap.mat');
            obj.colorMaps.fauColormap = fauColormap.fauColormap;
            whiteRedColormap = load('whiteRedColormap.mat');
            obj.colorMaps.whiteRedColormap = whiteRedColormap.whiteRedColormap;
            romaColormap = load('romaColormap.mat');
            obj.colorMaps.romaColormap = romaColormap.romaColormap;
            bamoColormap = load('bamoColormap.mat');
            obj.colorMaps.bamoColormap = bamoColormap.bamoColormap;
            batlowColormap = load('batlowColormap.mat');
            obj.colorMaps.batlowColormap = batlowColormap.batlowColormap;
            osloColormap = load('osloColormap.mat');
            obj.colorMaps.osloColormap = osloColormap.osloColormap;
            vikColormap = load('vikColormap.mat');
            obj.colorMaps.vikColormap = vikColormap.vikColormap;

            % Define colors
            obj.colors.cBlack = [0.0000, 0.0000, 0.0000];
            obj.colors.cWhite = [1.0000, 1.0000, 1.0000];
            obj.colors.cYellow = [1.0000, 1.0000, 0.0000];
            obj.colors.cfauBlue = [0.0706, 0.1922, 0.3961];
            obj.colors.cfauGrey = [0.6000, 0.6000, 0.6000];
            obj.colors.ctmLightBlue = [0.5333, 0.8000, 0.9333];
            obj.colors.ctmBlueGreenish = [0.2667, 0.6667, 0.6000];
            obj.colors.ctmDarkGreen = [0.0667, 0.4667, 0.2000];
            obj.colors.ctmDarkBlue = [0.2000, 0.1333, 0.5333];
            obj.colors.ctmOcher = [0.8667, 0.8000, 0.4667];
            obj.colors.ctmLime = [0.6000, 0.6000, 0.2000];
            obj.colors.ctmLightPink = [0.8000, 0.4000, 0.4667];
            obj.colors.ctmDeepPurple = [0.5333, 0.1333, 0.3333];
            obj.colors.ctmViolet = [0.6667, 0.2667, 0.6000];
            obj.colors.ctmLightGrey = [0.8667, 0.8667, 0.8667];
        end

        % Fct: Returns the index of a timetable time closest to a provided
        % time
        function searchIdx = FindTimeIndex(~, timeTable, searchTime, timeFormat)
            if ~isdatetime(searchTime)
                searchTime = datetime(searchTime, "InputFormat", timeFormat);
            end
            if ~isdatetime(timeTable)
                timeTable = datetime(timeTable, "InputFormat", timeFormat);
            end
            timeDifference = searchTime - timeTable;
            timeDifference = abs(timeDifference);
            [~, searchIdx] = min(timeDifference);
        end

        % Fct: Returns the string of number with a given precision
        function returnString = NumStrPrecision(~, number, precision)
            returnString = num2str(number,['%.',num2str(precision)','f']);
        end

        % Fct: Returns the content of a table within a table
        function content = TableInTable(~, tableOfTables, index)
            try
                content = tableOfTables{:,index};
            catch
                content = tableOfTables{index,:};
            end
            content = content{:};
        end

        % Fct: Returns a file list of all files with the same extension
        % within a given folder
        function fileList = FileListByExtension(~, folder, extension)
            if ~isstring(folder) || ~isstring(extension)
                folder = convertCharsToStrings(folder);
                extension = convertCharsToStrings(extension);
            end
            fileListStruct = dir(fullfile(folder + "\*" + extension));
            fileList = struct2table(fileListStruct);
            fileList = table(convertCharsToStrings(fileList.folder) + "\" + convertCharsToStrings(fileList.name));
            fileList.Properties.VariableNames = {'FileName'};
        end

        % Fct: Create a tiled layout with narrow borders
        function handle = CreateTiledLayoutPlot(~, rows, colums)
            handle = tiledlayout(rows, colums, 'Padding', 'none', 'TileSpacing', 'compact');
            nexttile;
        end

        % Fct: Get colors evenly distributed of colormap
        function colors = GetColormapColors(~, nrOfColors, colorMap)
            [availableColors, ~] = size(colorMap);
            colorIdx = linspace(1, availableColors, nrOfColors);
            colorIdx = floor(colorIdx);
            colors = colorMap(colorIdx,:);
        end

        % Fct: Get current screen size
        function [width, height] = GetScreenSize(~)
            screenSize = get(0,'ScreenSize');
            width = screenSize(3);
            height = screenSize(4);
        end

        % Fct: Combine full file path
        function fullFilePath = FullFilePath(~, filename, filepath)
            if(filepath(end) ~= '\')
                filepath = [filepath, '\'];
            end
            fullFilePath = [filepath, filename];
        end

        % Fct: Resize tiled layout
        function ResizeTiledLayout(obj, widthPx, heightPx, fontSize)
            [screenWidth, screenHeight] = obj.GetScreenSize();
            cf = gcf();
            % With MATLAB R2022a also this is viable:
            % fontsize(fig, 12, 'points');
            % fontsize(ax, 12, 'points');
            set(findall(gcf,'-property','FontSize'), 'FontSize', fontSize);
            cf.Position = [screenWidth/2 - widthPx/2, screenHeight/2 - heightPx/2, widthPx, heightPx];
        end

        % Fct: Get a timestamp for display messages
        function ExtDisp(~, msg)
            disp(">> " + string(datetime('now', 'TimeZone', 'UTC', 'Format', 'dd.MM.yyyy HH:mm:ss')) + " (UTC+0): " + msg);
        end
    end
end

