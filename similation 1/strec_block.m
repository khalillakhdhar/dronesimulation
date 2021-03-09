 
    

classdef strec_block < handle
    properties
	indice_bloc                
	donnee_block                  
	precedent_key          
	crypt   
    time_cryp
	poin_mem                
    end   
    methods 
	function obj = strec_block(indice_bloc,donnee_block,precedent_key)  
        
        obj.time_cryp='timeeee';
	    if nargin == 2       
	      obj.indice_bloc = indice_bloc ;
	      obj.donnee_block = donnee_block ;             

	    elseif nargin == 3                     
	      obj.indice_bloc = indice_bloc ;
	      obj.donnee_block = donnee_block ;
	      obj.precedent_key = precedent_key;
        end
         
	end
       function str = getCombined(obj)    
	    str = strcat(num2str(obj.indice_bloc),obj.precedent_key,strjoin(obj.donnee_block));
       end
     end
end