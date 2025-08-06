#!/usr/bin/env python3
import sys
from lxml import etree

def run_xslt_transformation(xml_file, xslt_file, output_file=None):
    """Run XSLT transformation and return the result"""
    try:
        # Parse XML and XSLT files
        xml_doc = etree.parse(xml_file)
        xslt_doc = etree.parse(xslt_file)
        
        # Create transformer
        transform = etree.XSLT(xslt_doc)
        
        # Apply transformation
        result = transform(xml_doc)
        
        # Print result
        print(f"\n=== Transformation: {xslt_file} ===")
        print(etree.tostring(result, pretty_print=True, encoding='unicode'))
        
        # Save to file if output_file is specified
        if output_file:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(etree.tostring(result, pretty_print=True, encoding='unicode'))
            print(f"Result saved to: {output_file}")
            
        return result
        
    except Exception as e:
        print(f"Error processing {xslt_file}: {e}")
        return None

def main():
    xml_file = "OrganizationalStructure.xml"
    
    # List of XSLT files to process
    xslt_files = [
        "OrgStruct_3.1.1.xslt",
        "OrgStruct_3.1.2.xslt", 
        "OrgStruct_4.1.1.xslt",
        "OrgStruct_4.1.2.xslt",
        "OrgStruct_5.1.1.xslt",
        "OrgStruct_5.1.2.xslt"
    ]
    
    print("Running XSLT Transformations on OrganizationalStructure.xml")
    print("=" * 60)
    
    for xslt_file in xslt_files:
        try:
            run_xslt_transformation(xml_file, xslt_file)
        except FileNotFoundError:
            print(f"File not found: {xslt_file}")
        except Exception as e:
            print(f"Error processing {xslt_file}: {e}")
        
        print("\n" + "-" * 60)

if __name__ == "__main__":
    main() 