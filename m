From: "Thomas D." <whissi@whissi.de>
Subject: Broken userspace crypto in linux-4.1.18
Date: Wed, 17 Feb 2016 15:04:41 +0100
Message-ID: <56C47DF9.6030704@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: dvyukov@google.com,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, sasha.levin@oracle.com
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

something is broken with crypto in linux-4.1.18.

On my system I have two disks (sda and sdb), both encrypted with LUKS
(cipher=aes-xts-plain64).

My rootfs resides encrypted on sda2 (sda1 is an unencrypted boot
partition).
sdb has one full encrypted partition (sdb1) mounted in "/backup".

After I upgraded from linux-4.1.17 to linux-4.1.18 and rebooted I noticed
that my encrypted rootfs was opened successfully (must be my initramfs)
however opening sdb1 with key file failed:

>  * Setting up dm-crypt mappings ...
>  *   backupVault using:   open /dev/sdb1 backupVault ...
> Failed to setup dm-crypt key mapping for device /dev/sdb1.
> Check that kernel supports aes-xts-plain64 cipher (check syslog for more info).
>  * failure running cryptsetup
>  [ !! ]
>  * Failed to setup dm-crypt devices
>  [ !! ]
>  * ERROR: dmcrypt failed to start

Calling cryptsetup from terminal with debug option showed

> Failed to setup dm-crypt key mapping for device /dev/sdb1.
> Check that kernel supports aes-xts-plain64 cipher (check syslog for more info).
> Command failed with code 22: Invalid argument
> # cryptsetup 1.7.0 processing "cryptsetup --verbose --debug --key-file /etc/backupVault.key luksOpen /dev/sdb1 backupVault"
> # Running command open.
> # Locking memory.
> # Installing SIGINT/SIGTERM handler.
> # Unblocking interruption on signal.
> # Allocating crypt device /dev/sdb1 context.
> # Trying to open and read device /dev/sdb1 with direct-io.
> # Initialising device-mapper backend library.
> # Trying to load LUKS1 crypt type from device /dev/sdb1.
> # Crypto backend (gcrypt 1.6.5) initialized in cryptsetup library version 1.7.0.
> # Detected kernel Linux 4.1.18 x86_64.
> # Reading LUKS header of size 1024 from device /dev/sdb1
> # Key length 64, device size 10483679 sectors, header size 4036 sectors.
> # Timeout set to 0 miliseconds.
> # Password retry count set to 3.
> # Password verification disabled.
> # Iteration time set to 2000 miliseconds.
> # Password retry count set to 1.
> # Activating volume backupVault [keyslot -1] using keyfile /etc/backupVault.key.
> # dm version   OF   [16384] (*1)
> # dm versions   OF   [16384] (*1)
> # Detected dm-crypt version 1.14.1, dm-ioctl version 4.31.0.
> # Device-mapper backend running with UDEV support disabled.
> # dm status backupVault  OF   [16384] (*1)
> # File descriptor passphrase entry requested.
> # Trying to open key slot 0 [ACTIVE].
> # Reading key slot 0 area.
> # Userspace crypto wrapper cannot use aes-xts-plain64 (-22).
> # Releasing crypt device /dev/sdb1 context.
> # Releasing device-mapper backend.
> # Unlocking memory.

dmesg/syslog never showed an error.


Calling `cryptsetup benchmark` shows (notice the "N/A"):

> # Tests are approximate using memory only (no storage IO).
> PBKDF2-sha1       647269 iterations per second for 256-bit key
> PBKDF2-sha256     832203 iterations per second for 256-bit key
> PBKDF2-sha512     576140 iterations per second for 256-bit key
> PBKDF2-ripemd160  379918 iterations per second for 256-bit key
> PBKDF2-whirlpool  264791 iterations per second for 256-bit key
> #  Algorithm | Key |  Encryption |  Decryption
>      aes-cbc   128b           N/A           N/A
>  serpent-cbc   128b           N/A           N/A
>  twofish-cbc   128b           N/A           N/A
>      aes-cbc   256b           N/A           N/A
>  serpent-cbc   256b           N/A           N/A
>  twofish-cbc   256b           N/A           N/A
>      aes-xts   256b           N/A           N/A
>  serpent-xts   256b           N/A           N/A
>  twofish-xts   256b           N/A           N/A
>      aes-xts   512b           N/A           N/A
>  serpent-xts   512b           N/A           N/A
>  twofish-xts   512b           N/A           N/A


Comparing /proc/crypto between 4.1.17 and 4.1.18:

> --- proc_crypto_4.1.17	2016-02-17 01:40:02.028647072 +0100
> +++ proc_crypto_4.1.18	2016-02-17 01:20:26.049998773 +0100
> @@ -1,158 +1,8 @@
> -name         : __xts-twofish-avx
> -driver       : cryptd(__driver-xts-twofish-avx)
> -module       : kernel
> -priority     : 50
> -refcnt       : 1
> -selftest     : passed
> -internal     : yes
> -type         : ablkcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 32
> -max keysize  : 64
> -ivsize       : 16
> -geniv        : <default>
> -
> -name         : xts(twofish)
> -driver       : xts-twofish-avx
> -module       : kernel
> -priority     : 400
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : givcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 32
> -max keysize  : 64
> -ivsize       : 16
> -geniv        : eseqiv
> -
> -name         : __xts-serpent-avx
> -driver       : cryptd(__driver-xts-serpent-avx)
> -module       : kernel
> -priority     : 50
> -refcnt       : 1
> -selftest     : passed
> -internal     : yes
> -type         : ablkcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 0
> -max keysize  : 64
> -ivsize       : 16
> -geniv        : <default>
> -
> -name         : xts(serpent)
> -driver       : xts-serpent-avx
> -module       : kernel
> -priority     : 500
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : givcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 0
> -max keysize  : 64
> -ivsize       : 16
> -geniv        : eseqiv
> -
> -name         : __cbc-twofish-avx
> -driver       : cryptd(__driver-cbc-twofish-avx)
> -module       : kernel
> -priority     : 50
> -refcnt       : 1
> -selftest     : passed
> -internal     : yes
> -type         : ablkcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 0
> -geniv        : <default>
> -
> -name         : cbc(twofish)
> -driver       : cbc-twofish-avx
> -module       : kernel
> -priority     : 400
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : givcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 16
> -geniv        : eseqiv
> -
> -name         : __cbc-serpent-avx
> -driver       : cryptd(__driver-cbc-serpent-avx)
> -module       : kernel
> -priority     : 50
> -refcnt       : 1
> -selftest     : passed
> -internal     : yes
> -type         : ablkcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 0
> -max keysize  : 32
> -ivsize       : 0
> -geniv        : <default>
> -
> -name         : cbc(serpent)
> -driver       : cbc-serpent-avx
> -module       : kernel
> -priority     : 500
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : givcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 0
> -max keysize  : 32
> -ivsize       : 16
> -geniv        : eseqiv
> -
> -name         : __cbc-aes-aesni
> -driver       : cryptd(__driver-cbc-aes-aesni)
> -module       : kernel
> -priority     : 50
> -refcnt       : 1
> -selftest     : passed
> -internal     : yes
> -type         : ablkcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 0
> -geniv        : <default>
> -
> -name         : cbc(aes)
> -driver       : cbc-aes-aesni
> -module       : kernel
> -priority     : 400
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : givcipher
> -async        : yes
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 16
> -geniv        : eseqiv
> -
>  name         : __xts-aes-aesni
>  driver       : cryptd(__driver-xts-aes-aesni)
>  module       : kernel
>  priority     : 50
> -refcnt       : 3
> +refcnt       : 2
>  selftest     : passed
>  internal     : yes
>  type         : ablkcipher
> @@ -167,7 +17,7 @@
>  driver       : xts-aes-aesni
>  module       : kernel
>  priority     : 400
> -refcnt       : 3
> +refcnt       : 2
>  selftest     : passed
>  internal     : no
>  type         : givcipher
> @@ -1524,7 +1374,7 @@
>  driver       : xts-aes-aesni
>  module       : kernel
>  priority     : 400
> -refcnt       : 3
> +refcnt       : 2
>  selftest     : passed
>  internal     : no
>  type         : ablkcipher
> @@ -1554,7 +1404,7 @@
>  driver       : __driver-xts-aes-aesni
>  module       : kernel
>  priority     : 0
> -refcnt       : 3
> +refcnt       : 2
>  selftest     : passed
>  internal     : yes
>  type         : blkcipher

However I am using the same kernel configuration :)


After I bisect the kernel I found the following bad commit:

> commit 0571ba52a19e18a1c20469454231eef681cb1310
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Dec 30 11:47:53 2015 +0800
> 
>     crypto: af_alg - Disallow bind/setkey/... after accept(2)
> 
>     [ Upstream commit c840ac6af3f8713a71b4d2363419145760bd6044 ]
> 
>     Each af_alg parent socket obtained by socket(2) corresponds to a
>     tfm object once bind(2) has succeeded.  An accept(2) call on that
>     parent socket creates a context which then uses the tfm object.
> 
>     Therefore as long as any child sockets created by accept(2) exist
>     the parent socket must not be modified or freed.
> 
>     This patch guarantees this by using locks and a reference count
>     on the parent socket.  Any attempt to modify the parent socket will
>     fail with EBUSY.


bisect log:

> Bisecting: 114 revisions left to test after this (roughly 7 steps)
> [3a1e81ad84e4d880b00ecf7ad8d03b9b772ddfa7] crypto: algif_hash - Fix race condition in hash_check_key
> Bisecting: 56 revisions left to test after this (roughly 6 steps)
> [d6341753c418d3699948290d8c0b9d9dc78bd209] udf: Prevent buffer overrun with multi-byte characters
> Bisecting: 28 revisions left to test after this (roughly 5 steps)
> [13aedd784b84cb7d8a3bb835941d80e99f5c796e] dmaengine: dw: fix cyclic transfer setup
> Bisecting: 14 revisions left to test after this (roughly 4 steps)
> [664ecf4f243bac17065cd9878790d40a592e2f3d] zram/zcomp: use GFP_NOIO to allocate streams
> Bisecting: 7 revisions left to test after this (roughly 3 steps)
> [0571ba52a19e18a1c20469454231eef681cb1310] crypto: af_alg - Disallow bind/setkey/... after accept(2)
> Bisecting: 3 revisions left to test after this (roughly 2 steps)
> [2c641f5b0c8e87d43235ce39890bcc4d0c7cd2fb] memcg: only free spare array when readers are done
> Bisecting: 1 revision left to test after this (roughly 1 step)
> [0e19e24c3fe0abde8e2c5f4543616a251ccea6bf] kernel/panic.c: turn off locks debug before releasing console lock
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [bc24ac15b0746172a8f603171352aa54abcf7c78] printk: do cond_resched() between lines while outputting to consoles
> 0571ba52a19e18a1c20469454231eef681cb1310 is the first bad commit


-Thomas
