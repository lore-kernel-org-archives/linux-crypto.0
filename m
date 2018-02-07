From: Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Wed, 7 Feb 2018 09:35:51 +0530
Message-ID: <CANAwSgRXFWC=kU+ZtDbGq5v9Ym60EKi-fdjWGuDG9F2JCfw6cw@mail.gmail.com>
References: <CGME20180205174022eucas1p101e8339284c1f0ac8f40f70c24de1c1f@eucas1p1.samsung.com>
 <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
 <CANAwSgTO5_mL9GEYrXDJyKakY3JTeF+VxbCTuHczAvfVY0zUsg@mail.gmail.com> <b3b0b170-f10b-fb8a-74f9-b6aa0cb41980@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <b3b0b170-f10b-fb8a-74f9-b6aa0cb41980@partner.samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Kamil

On 6 February 2018 at 22:40, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> On 06.02.2018 17:48, Anand Moon wrote:
>> Hi Kamil,
>>
>> Thanks for providing the fix to this issue.
>>
>> On 5 February 2018 at 23:10, Kamil Konieczny
>> <k.konieczny@partner.samsung.com> wrote:
>>>
>>> In AES-ECB mode crypt is done with key only, so any use of IV
>>> can cause kernel Oops, as reported by Anand Moon.
>>
>> If possible could you avoid the name in commit message.
>
> This is added after '---' line, so it will not appear in commit message.
>

I know about '---' delimiter, but to be precise this will be part of
commit message.

>>> Fixed it by using IV only in AES-CBC and AES-CTR.
>>>
>>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>>> Reported-by: Anand Moon <linux.amoon@gmail.com>
>>
>> [snip]
>>
>> Please add my. Tested on Odroid HC2
>>
>> Tested-by: Anand Moon <linux.amoon@gmail.com>
>
> This will add you name in commit message,
> additionally with 'Reported-by:' line.
>
>> Below are the result at my end.
>>
>> aes-cbc-essiv:sha256 (128 bit key)
>> WRITE:
>> 100+0 records in
>> 100+0 records out
>> 838860800 bytes (839 MB, 800 MiB) copied, 11.7225 s, 71.6 MB/s
>> [...]
>
> is it from 'cryptsetup benchmark' ? benchmark did not cause oops.
> Please test with luksFormat, ie. use
>
> cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
>   --cipher aes-cbc-essiv:sha256 -h sha256 -s 128 /tmp/test.bin
>
[snip]

Below is the out put of aes-cbc-essiv:sha256 and aes-ctr-plain

root@odroid:~# fallocate -l 128MiB /tmp/test.bin
root@odroid:~# dd if=/dev/urandom of=/tmp/testkey.key bs=128 count=1
1+0 records in
1+0 records out
128 bytes copied, 0.000231043 s, 554 kB/s
root@odroid:~# sync
root@odroid:~# cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
>   --cipher aes-cbc-essiv:sha256 -h sha256 -s 128 /tmp/test.bin
# cryptsetup 1.6.6 processing "cryptsetup luksFormat --debug -q -d
/tmp/testkey.key --cipher aes-cbc-essiv:sha256 -h sha256 -s 128
/tmp/test.bin"
# Running command luksFormat.
# Locking memory.
# Installing SIGINT/SIGTERM handler.
# Unblocking interruption on signal.
# Allocating crypt device /tmp/test.bin context.
# Trying to open and read device /tmp/test.bin.
# Initialising device-mapper backend library.
# Timeout set to 0 miliseconds.
# Iteration time set to 1000 miliseconds.
# File descriptor passphrase entry requested.
# Formatting device /tmp/test.bin as type LUKS1.
# Crypto backend (gcrypt 1.6.5) initialized.
# Detected kernel Linux 4.15.0-xu4krck armv7l.
# Topology info for /tmp/test.bin not supported, using default offset
1048576 bytes.
# Checking if cipher aes-cbc-essiv:sha256 is usable.
# Using userspace crypto wrapper to access keyslot area.
# Generating LUKS header version 1 using hash sha256, aes,
cbc-essiv:sha256, MK 16 bytes
# KDF pbkdf2, hash sha256: 160824 iterations per second.
# Data offset 2048, UUID fe5c0d54-9add-4454-a4cd-98eed8f2b75c, digest
iterations 19625
# Updating LUKS header of size 1024 on device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Reading LUKS header of size 1024 from device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Adding new keyslot -1 using volume key.
# Calculating data for key slot 0
# KDF pbkdf2, hash sha256: 161220 iterations per second.
# Key slot 0 use 78720 password iterations.
# Using hash sha256 for AF in key slot 0, 4000 stripes
# Updating key slot 0 [0x1000] area.
# Using userspace crypto wrapper to access keyslot area.
# Key slot 0 was enabled in LUKS header.
# Updating LUKS header of size 1024 on device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Reading LUKS header of size 1024 from device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Releasing crypt device /tmp/test.bin context.
# Releasing device-mapper backend.
# Unlocking memory.
Command successful.
root@odroid:~#
root@odroid:~#
root@odroid:~# fallocate -l 128MiB /tmp/test.bin
root@odroid:~# dd if=/dev/urandom of=/tmp/testkey.key bs=128 count=1
1+0 records in
1+0 records out
128 bytes copied, 0.000324001 s, 395 kB/s
root@odroid:~# sync
root@odroid:~# cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
>   --cipher aes-ctr-plain -h sha256 -s 128 /tmp/test.bin
# cryptsetup 1.6.6 processing "cryptsetup luksFormat --debug -q -d
/tmp/testkey.key --cipher aes-ctr-plain -h sha256 -s 128
/tmp/test.bin"
# Running command luksFormat.
# Locking memory.
# Installing SIGINT/SIGTERM handler.
# Unblocking interruption on signal.
# Allocating crypt device /tmp/test.bin context.
# Trying to open and read device /tmp/test.bin.
# Initialising device-mapper backend library.
# Timeout set to 0 miliseconds.
# Iteration time set to 1000 miliseconds.
# File descriptor passphrase entry requested.
# Formatting device /tmp/test.bin as type LUKS1.
# Crypto backend (gcrypt 1.6.5) initialized.
# Detected kernel Linux 4.15.0-xu4krck armv7l.
# Topology info for /tmp/test.bin not supported, using default offset
1048576 bytes.
# Checking if cipher aes-ctr-plain is usable.
# Using userspace crypto wrapper to access keyslot area.
# Generating LUKS header version 1 using hash sha256, aes, ctr-plain,
MK 16 bytes
# KDF pbkdf2, hash sha256: 162217 iterations per second.
# Data offset 2048, UUID 3e2b2e4a-a908-4228-b2a1-746e163e8e7e, digest
iterations 19750
# Updating LUKS header of size 1024 on device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Reading LUKS header of size 1024 from device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Adding new keyslot -1 using volume key.
# Calculating data for key slot 0
# KDF pbkdf2, hash sha256: 160234 iterations per second.
# Key slot 0 use 78239 password iterations.
# Using hash sha256 for AF in key slot 0, 4000 stripes
# Updating key slot 0 [0x1000] area.
# Using userspace crypto wrapper to access keyslot area.
# Key slot 0 was enabled in LUKS header.
# Updating LUKS header of size 1024 on device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Reading LUKS header of size 1024 from device /tmp/test.bin
# Key length 16, device size 262144 sectors, header size 1029 sectors.
# Releasing crypt device /tmp/test.bin context.
# Releasing device-mapper backend.
# Unlocking memory.
Command successful.

Best Regards
-Anand
