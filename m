From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Tue, 10 Jun 2014 09:36:16 +0200
Message-ID: <5396B570.80608@gmail.com>
References: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com> <1402311551-19564-2-git-send-email-clabbe.montjoie@gmail.com> <CAGb2v65NdYrY3N0Oi8f7NtdWJYoiR0HnTk7n6hmG44BnDbZoyA@mail.gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-sunxi <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
 Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
 Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 "maxime.ripard" <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
 Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
 Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
 devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
 linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans De Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBB6HK3KOAKGQEM42TJTA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <CAGb2v65NdYrY3N0Oi8f7NtdWJYoiR0HnTk7n6hmG44BnDbZoyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On 06/10/14 08:53, Chen-Yu Tsai wrote:
> Hi,
> 
> On Mon, Jun 9, 2014 at 6:59 PM, LABBE Corentin
> <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/crypto/sunxi-ss/Makefile               |  16 ++
>>  drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c | 118 ++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c  | 130 +++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c  | 118 ++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-cipher.c      | 362 +++++++++++++++++++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-cipher.h      |   8 +
>>  drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c    |  69 +++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c   |  69 +++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-hash.c        | 228 ++++++++++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss-hash.h        |   9 +
>>  drivers/crypto/sunxi-ss/sunxi-ss-rng.c         | 115 ++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss.c             | 190 +++++++++++++
>>  drivers/crypto/sunxi-ss/sunxi-ss.h             | 161 +++++++++++
>>  13 files changed, 1593 insertions(+)
>>  create mode 100644 drivers/crypto/sunxi-ss/Makefile
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.h
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-rng.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.c
>>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.h
>>
>> diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
>> new file mode 100644
>> index 0000000..de4556b
>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss/Makefile
>> @@ -0,0 +1,16 @@
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss.o
>> +
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG) += sunxi-ss-rng.o
>> +
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_DES) += sunxi-ss-des.o
>> +sunxi-ss-des-y += sunxi-ss-cipher-des.o sunxi-ss-cipher.o
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_3DES) += sunxi-ss-3des.o
>> +sunxi-ss-3des-y += sunxi-ss-cipher-3des.o sunxi-ss-cipher.o
>> +
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_AES) += sunxi-ss-aes.o
>> +sunxi-ss-aes-y += sunxi-ss-cipher-aes.o sunxi-ss-cipher.o
> 
> I just tried building Hans' (CC-ed) sunxi-devel branch, which
> includes this series, with all the Security System options enabled.
> 
> It doesn't build:
> 
>   LD      drivers/crypto/sunxi-ss/built-in.o
> drivers/crypto/sunxi-ss/sunxi-ss-3des.o: In function `sunxi_cipher_init':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:24:
> multiple definition of `sunxi_cipher_init'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:24:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-3des.o: In function `sunxi_des_poll':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:218:
> multiple definition of `sunxi_des_poll'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:218:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-3des.o: In function `sunxi_aes_poll':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:33:
> multiple definition of `sunxi_aes_poll'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:33:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-3des.o: In function `sunxi_cipher_exit':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:29:
> multiple definition of `sunxi_cipher_exit'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:29:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-aes.o: In function `sunxi_cipher_init':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:24:
> multiple definition of `sunxi_cipher_init'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:24:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-aes.o: In function `sunxi_des_poll':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:218:
> multiple definition of `sunxi_des_poll'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:218:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-aes.o: In function `sunxi_aes_poll':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:33:
> multiple definition of `sunxi_aes_poll'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:33:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-aes.o: In function `sunxi_cipher_exit':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:29:
> multiple definition of `sunxi_cipher_exit'
> drivers/crypto/sunxi-ss/sunxi-ss-des.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c:29:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-sha1.o: In function `sunxi_hash_init':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:7:
> multiple definition of `sunxi_hash_init'
> drivers/crypto/sunxi-ss/sunxi-ss-md5.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:7:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-sha1.o: In function `sunxi_hash_finup':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:204:
> multiple definition of `sunxi_hash_finup'
> drivers/crypto/sunxi-ss/sunxi-ss-md5.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:204:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-sha1.o: In function `sunxi_hash_digest':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:216:
> multiple definition of `sunxi_hash_digest'
> drivers/crypto/sunxi-ss/sunxi-ss-md5.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:216:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-sha1.o: In function `sunxi_hash_update':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:44:
> multiple definition of `sunxi_hash_update'
> drivers/crypto/sunxi-ss/sunxi-ss-md5.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:44:
> first defined here
> drivers/crypto/sunxi-ss/sunxi-ss-sha1.o: In function `sunxi_hash_final':
> /home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:115:
> multiple definition of `sunxi_hash_final'
> drivers/crypto/sunxi-ss/sunxi-ss-md5.o:/home/wens/sunxi/linux/drivers/crypto/sunxi-ss/sunxi-ss-hash.c:115:
> first defined here
> scripts/Makefile.build:397: recipe for target
> 'drivers/crypto/sunxi-ss/built-in.o' failed
> make[3]: *** [drivers/crypto/sunxi-ss/built-in.o] Error 1
> scripts/Makefile.build:465: recipe for target 'drivers/crypto/sunxi-ss' failed
> make[2]: *** [drivers/crypto/sunxi-ss] Error 2
> scripts/Makefile.build:465: recipe for target 'drivers/crypto' failed
> make[1]: *** [drivers/crypto] Error 2
> Makefile:878: recipe for target 'drivers' failed
> make: *** [drivers] Error 2
> 
> 
> What's seems to be happening is that sunxi-ss-cipher.c is
> being compiled and included multiple times, once for each
> different cipher.
> 
> So sunxi-ss-cipher-{aes,3des,des}.o all have a copy of
> sunxi-ss-cipher.c compiled in. And during the link phase,
> the linker finds multiple definitions and fails.
> 
> What would probably work is have a common Kconfig option
> such as CONFIG_CRYPTO_DEV_SUNXI_SS_CIPHER, have each cipher
> Kconfig option select this one, and have this option trigger
> the build of the common functions.
> 
>> +
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_MD5) += sunxi-ss-md5.o
>> +sunxi-ss-md5-y += sunxi-ss-hash.o sunxi-ss-hash-md5.o
>> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1) += sunxi-ss-sha1.o
>> +sunxi-ss-sha1-y += sunxi-ss-hash.o sunxi-ss-hash-sha1.o
> 
> Same goes for the hash part. sunxi-ss-hash.c included twice,
> once for md5 and once for sha1.
> 
> [snip]
> 
> Note that I only tried statically linked builds, not modules.
> 
> 
> Cheers
> ChenYu
> 

Thanks for your reports, I forgot to test with static kernel.
I will send an updated patch soon.

Regards
