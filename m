From: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: [RFC PATCH] crypto: Alchemy AES engine driver
Date: Fri, 7 May 2010 10:51:37 +0200
Message-ID: <r2zf861ec6f1005070151oda24db2dra284b487c47ecbbf@mail.gmail.com>
References: <1273161045-21945-1-git-send-email-manuel.lauss@gmail.com>
	 <20100507083430.GB29286@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Linux-MIPS <linux-mips@linux-mips.org>,
	Manuel Lauss <manuel.lauss@gmail.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0EGIvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 May 2010 04:51:40 -0400
Received: by fxm10 with SMTP id 10so592400fxm.19
        for <linux-crypto@vger.kernel.org>; Fri, 07 May 2010 01:51:38 -0700 (PDT)
In-Reply-To: <20100507083430.GB29286@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sebastian,

>># modprobe alchemy-aes
>>alg: skcipher: setkey failed on test 2 for ecb-aes-alchemy: flags=3D2=
00000
>># modprobe tcrypt mode=3D10
>>alg: skcipher: setkey failed on test 3 for cbc-aes-alchemy: flags=3D0
>>alg: skcipher: Failed to load transform for cbc(aes): -2
>>alg: skcipher: Failed to load transform for cbc(aes): -2
>>tcrypt: one or more tests failed!
>>FATAL: Error inserting tcrypt (/lib/modules/2.6.34-rc6-db1200-00214-g=
9f84af9/kernel/crypto/tcrypt.ko): Unknown symbol in module, or unknown =
parameter (see dmesg)
>
>>The error in "test 3 for cbc-aes-alchemy" probably comes from the ina=
bility
>>to process keys larger than 128 bits.
> You have to fix this, you have to be able to handle other keys as wel=
l.
> In case your hardware does not support it, you have to handle this in
> software. Look at the geode driver, via =A0or s390. All of them have
> fallbacks for. If you fail the self test, you driver will no be used
> afaik.

Ah, I wondered what those were used for.  I'll fix the driver to use th=
em
as well.   Interestingly the algos provided are marked as tested in
/proc/crypto though.  I assumed the cryptoapi knows that the hw algo
can't handle these keylengths (it didn't even call the setkeys callback
before throwing the error) and fall back on software aes instead.


>>diff --git a/drivers/crypto/alchemy-aes.c b/drivers/crypto/alchemy-ae=
s.c
>>new file mode 100644
>>index 0000000..14e8ace
>>--- /dev/null
>>+++ b/drivers/crypto/alchemy-aes.c
>>+static int __init alchemy_aes_load(void)
>>+{
>>+ =A0 =A0 =A0/* FIXME: hier sollte auch noch der PRId des prozessors =
getestet
>>+ =A0 =A0 =A0 * werden; Au1210 (0x0503xxxx) und einige Au1300 haben l=
t. Daten-
>>+ =A0 =A0 =A0 * blatt keine AES engine.
>>+ =A0 =A0 =A0 */
> You German right? You should handle this in SoC code. So if you figur=
e
> out, that you have an engine here you add the device. If you don't ha=
ve
> it you don't do it and the probe call won't be called. Also the modul=
e
> won't be loaded by udev.

Hm, I'll think about it.


>>+ =A0 =A0 =A0/* need to do 8bit accesses to memory to get correct dat=
a */
>>+ =A0 =A0 =A0__alchemy_aes_memid =3D au1xxx_ddma_add_device(&alchemy_=
aes_mem_dbdev);
>>+ =A0 =A0 =A0if (!__alchemy_aes_memid)
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENODEV;
> What does it do? You don't want to add devices here. If you need
> something additional do it in SoC code and pass it via platform_data.

The dbdma code needs templates to get the memory access width right,
this adds a template for use with the AES engine.  Every instance could
use the same template that's why it's registered in the module_init cal=
lback.
(see drivers/mmc/au1xmmc.c for instance;  yes this is a workaround for
a shortcoming of the alchemy dbdma framework).

Thanks!
        Manuel Lauss
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
