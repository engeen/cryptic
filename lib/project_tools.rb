module ProjectTools
  
public

  def self.parse_emails(emails)
    valid_emails, invalid_emails = [], []
    unless emails.nil?
      emails.split(/, ?/).each do |full_email|
        unless full_email.blank?
          if index = full_email.index(/\<.+\>/)
            email = full_email.match(/\<.*\>/)[0].gsub(/[\<\>]/, "").strip
            name  = full_email[0..index-1].split(" ")
            fname = name.first
            lname = name[1..name.size] * " "
          else
            email = full_email.strip
            #your choice, what the string could be... only mail, only name?
          end
          email = email.delete("<").delete(">")
          email_address = EmailVeracity::Address.new(email)

          if email_address.valid?
            valid_emails << { :email => email, :lname => lname, :fname => fname} 
          else
            invalid_emails << { :email => email, :lname => lname, :fname => fname}
          end
        end
      end                    
    end
    return valid_emails, invalid_emails 
  end
  
  
end