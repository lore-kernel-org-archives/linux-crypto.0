From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 1/4] generic sha_update and sha_final for s390
Date: Mon, 3 Mar 2008 23:05:24 +0100
Message-ID: <20080303220524.GA30074@Chamillionaire.breakpoint.cc>
References: <1204561183.6025.51.camel@localhost.localdomain>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33706 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYCCWFb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2008 17:05:31 -0500
Content-Disposition: inline
In-Reply-To: <1204561183.6025.51.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Jan Glauber | 2008-03-03 17:19:43 [+0100]:

>Index: cryptodev-2.6/arch/s390/crypto/Makefile
>===================================================================
>--- cryptodev-2.6.orig/arch/s390/crypto/Makefile
>+++ cryptodev-2.6/arch/s390/crypto/Makefile
>@@ -2,8 +2,8 @@
> # Cryptographic API
> #
> 
>-obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o
>-obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o
>+obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o sha_common.o
>+obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o sha_common.o
So this is a little trick to avoid select in Kconfig? nice :)

> obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o des_check_key.o
> obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
> obj-$(CONFIG_S390_PRNG) += prng.o
>Index: cryptodev-2.6/arch/s390/crypto/sha.h
>===================================================================
>--- /dev/null
>+++ cryptodev-2.6/arch/s390/crypto/sha.h
>@@ -0,0 +1,34 @@
>+/*
>+ * Cryptographic API.
>+ *
>+ * s390 generic implementation of the SHA Secure Hash Algorithms.
>+ *
>+ * Copyright IBM Corp. 2007
Just a nitpick: shouldn't this be the year you wrote the code? I really
don't know.

Sebastian
