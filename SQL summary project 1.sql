USE Hospital

---Q (1)

--Firts Solution
SELECT p.Name AS 'Physician_Name'
FROM Physician p
wHERE p.EmployeeID in (SELECT Undergoes.Physician FROM Undergoes WHERE Undergoes.or_procedure NOT IN  (SELECT treatment FROM Trained_In WHERE Trained_In.Physician=Undergoes.Physician))

--Second Solution
CREATE VIEW Unqualified AS
SELECT u.or_procedure,u.Physician
FROM Undergoes u
EXCEPT
SELECT t.Treatment,t.Physician
FROM Trained_In t
--execute this:
SELECT p.Name AS 'Physician_Name'
FROM Physician p , unqualified un
WHERE p.EmployeeID=un.Physician

------------------------------------------------------------------------------------------------------------------
--Q (2)

--First Solution
SELECT p.name AS 'Physician_Name'
FROM Physician p
WHERE p.EmployeeID IN (SELECT Undergoes.Physician FROM Undergoes WHERE Undergoes.or_procedure IN (SELECT treatment FROM Trained_In WHERE Trained_In.Physician=Undergoes.Physician AND Undergoes.DateUndergoes>Trained_In.CertificationExpires))

 --Second Solution 
CREATE VIEW Qualified AS
SELECT u.or_procedure,u.Physician
FROM Undergoes u
INTERSECT
SELECT t.Treatment,t.Physician
FROM Trained_In t
--execute this:
SELECT p.Name AS 'Physician_Name'
FROM Physician p , qualified qu ,Undergoes un, Trained_In t
WHERE p.EmployeeID=qu.Physician AND p.EmployeeID=un.Physician AND p.EmployeeID=t.Physician
AND un.DateUndergoes>t.CertificationExpires

----------------------------------------------------------------------------------------------------------------------------

--Q (3)

SELECT p.Name as 'Patient_Name',phy.Name as'Physician_Name',nu.Name as'Nurse_Name',a.Start_time,a.End_time,a.ExaminationRoom,pcp_nm.name as 'Primary_Physician'
FROM Appointment a JOIN Patient p
ON a.Patient=p.SSN JOIN physician phy ON  a.Physician=phy.EmployeeID left join nurse nu ON a.PrepNurse=nu.EmployeeID 
join pcp_nm ON pcp_nm.pcp=p.PCP
WHERE phy.Name<>pcp_nm.name

CREATE VIEW Pcp_nm AS
SELECT p.PCP,phy.Name
FROM Patient p,Physician phy
WHERE p.PCP=phy.EmployeeID
----------------------------------------------------------------------------------------------------------------------------

--Q (4)

SELECT s.StayID , s.Patient AS ' Patient_Id_From_Stay',un.Patient AS 'Patient_Id_From_Undergoes'
FROM Undergoes un JOIN Stay s
ON un.Stay=s.StayID
WHERE un.Patient<>s.Patient
-----------------------------------------------------------------------------------------------------------------------------

--Q (5)

SELECT nu.name AS 'Nurse_Name'
FROM Nurse nu 
WHERE nu.EmployeeID IN (SELECT oc.Nurse FROM On_Call oc 
WHERE oc.BlockCode = (SELECT ro.BlockCode FROM Room ro WHERE ro.BlockFloor=oc.BlockFloor AND ro.RoomNumber='123'))

------------------------------------------------------------------------------------------------------------------------------

--Q (6)

SELECT ExaminationRoom,COUNT(AppointmentID) AS 'Number_Of_Appointments'
FROM Appointment
GROUP BY ExaminationRoom
------------------------------------------------------------------------------------------------------------------------------

--Q (7) 

SELECT p.Name AS 'Patient_Name'
FROM Patient p JOIN Prescribes pr
ON p.SSN=pr.Patient
WHERE p.pcp=pr.Physician

------------------------------------------------------------------------------------------------------------------------------

--Q (8)

SELECT p.Name AS 'Patient_Name'
FROM Patient p
WHERE p.SSN IN (SELECT un.Patient FROM Undergoes un WHERE un.or_procedure IN (SELECT op.Code  FROM or_procedure op WHERE op.Cost>'5000'))
--------------------------------------------------------------------------------------------------------------------------------

--Q (9) 

SELECT name_patient.Patient_Name,number_appointment.Num_Of_Appointment
FROM (SELECT a.Patient AS 'Id_Patient'  , COUNT(a.AppointmentID) AS 'Num_Of_Appointment'
FROM Appointment a 
GROUP BY a.Patient
HAVING COUNT(a.AppointmentID) >= 2) number_appointment
JOIN (SELECT p.SSN AS 'Idd_Patient', p.name AS 'Patient_Name' FROM Patient p ) name_patient
ON number_appointment.id_patient =name_patient.idd_patient
----------------------------------------------------------------------------------------------------------------------------------

-- Q (10)

SELECT p.Name AS 'Patient Name'
FROM Patient p
WHERE p.pcp NOT IN  (SELECT d.Head FROM Department d)
---------------------------------------------------------------------------------------------------------------------------------