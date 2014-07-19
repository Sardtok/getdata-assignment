# Code Book for Samsung Dataset

This is a code book describing the variables stored in the tidy
datasets. Note that there is not a full description of all variables
of the full dataset.

## Variable naming scheme

For readability (this boils down to personal preferences) I have used
Pascal case, which is similar to camelCase, but with the first
character capitalized as well. In addition, I've separated each word
and axis by dots, which should help readability even more.

The two first columns: Subject and Activity, identify the subject
whose measurements were taken, and which activity they were performing
when those measurements were taken. The subjects are anonymous, and as
such only a number is used to identify each subject.

There are two domains of interest: the time and frequency domains. The
domain of a measurement is indicated by the variable starting with
either Time.Domain or Frequency.Domain. The time domain signals were
captured at constant rate of 50 Hz and filtered with median and low
pass filters. The frequency domain is the result of applying fast
fourier transforms to the signals.

The signals are separated into two categories: Body movements and the
acceleration of gravity. If a signal is a measurement of body
movements, the domain is immediately followed by Body. If the signal
is a gravity measurement, the domain is immediately followed by
Gravity. The gravity and body signals were separated using a low pass
filter.

The signal category is then followed by a function name: Mean.Of,
Standard.Deviation.Of, or Mean.Of.Frequency.Of. Mean.Of indicates that
the signal has been averaged. Standard.Deviation.Of indicates the
standard deviation. Mean.Of.Frequency.Of is a mean frequency
calculated by a weighted average, but there is no standard deviation
for these measures.

The function name is then followed by a sensor: Acceleration or Gyro,
either prefixed by Magnitude.Of or followed by the axis of the
measurement. Acceleration indicates that the data comes from an
accelerometer. Gyro indicates that the data comes from a gyro. If they
are prefixed with Magnitude.Of, it means that this is the magnitude of
the 3-axial vector, otherwise it is followed by In.X, In.Y, or In.Z
indicating which axis the measurement is for.

Additionally the word Jerk, may be interleaved after the sensor name,
but before the axis name. This indicates that the signal has been
derived in time, to obtain "jerk signals" (i.e. measurement of jerking
motions/fast changes in motion).

## Example names

Time.Domain.Body.Mean.Of.Acceleration.In.X - Mean of body acceleration
along the X axis in the time domain (i.e. without a fast fourier
transform).

Frequency.Domain.Body.Standard.Deviation.Of.Magnitude.Of.Gyro.Jerk -
The standard deviation of the magnitude of the derived signals from
the gyro with a fast fourier transform.

## Full dataset variables

There are several more variables in the full dataset. These also have
cleaned up names, although are not stored by default. These names are
not covered here, but hopefully should be readable. Also see the
features_info.txt of the original dataset to learn more of the
variables, which should also indicate the meaning of these additional
variables, should you choose to insert saving of the full dataset.
