From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC PATCH] crypto: Alchemy AES engine driver
Date: Fri, 7 May 2010 10:34:31 +0200
Message-ID: <20100507083430.GB29286@Chamillionaire.breakpoint.cc>
References: <1273161045-21945-1-git-send-email-manuel.lauss@gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Linux-MIPS <linux-mips@linux-mips.org>,
	Manuel Lauss <manuel.lauss@gmail.com>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57660 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915Ab0EGIee (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 May 2010 04:34:34 -0400
Content-Disposition: inline
In-Reply-To: <1273161045-21945-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Manuel Lauss | 2010-05-06 17:50:45 [+0200]:

A brief look.
>lightly "tested" with the tcrypt module on Au1200;  I have no idea whether
>it really works correctly:
>
># modprobe alchemy-aes
>alg: skcipher: setkey failed on test 2 for ecb-aes-alchemy: flags=200000
># modprobe tcrypt mode=10
>alg: skcipher: setkey failed on test 3 for cbc-aes-alchemy: flags=0
>alg: skcipher: Failed to load transform for cbc(aes): -2
>alg: skcipher: Failed to load transform for cbc(aes): -2
>tcrypt: one or more tests failed!
>FATAL: Error inserting tcrypt (/lib/modules/2.6.34-rc6-db1200-00214-g9f84af9/kernel/crypto/tcrypt.ko): Unknown symbol in module, or unknown parameter (see dmesg)

>The error in "test 3 for cbc-aes-alchemy" probably comes from the inability
>to process keys larger than 128 bits.
You have to fix this, you have to be able to handle other keys as well.
In case your hardware does not support it, you have to handle this in
software. Look at the geode driver, via  or s390. All of them have
fallbacks for. If you fail the self test, you driver will no be used
afaik.

>Please have a look.
> Thanks!
>
>diff --git a/drivers/crypto/alchemy-aes.c b/drivers/crypto/alchemy-aes.c
>new file mode 100644
>index 0000000..14e8ace
>--- /dev/null
>+++ b/drivers/crypto/alchemy-aes.c
>+static int __init alchemy_aes_load(void)
>+{
>+	/* FIXME: hier sollte auch noch der PRId des prozessors getestet
>+	 * werden; Au1210 (0x0503xxxx) und einige Au1300 haben lt. Daten-
>+	 * blatt keine AES engine.
>+	 */
You German right? You should handle this in SoC code. So if you figure
out, that you have an engine here you add the device. If you don't have
it you don't do it and the probe call won't be called. Also the module
won't be loaded by udev.

>+	/* need to do 8bit accesses to memory to get correct data */
>+	__alchemy_aes_memid = au1xxx_ddma_add_device(&alchemy_aes_mem_dbdev);
>+	if (!__alchemy_aes_memid)
>+		return -ENODEV;
What does it do? You don't want to add devices here. If you need
something additional do it in SoC code and pass it via platform_data.

>+
>+	return platform_driver_register(&alchemy_aes_driver);
>+}
>+

Sebastian
