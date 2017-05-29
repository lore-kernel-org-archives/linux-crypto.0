From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v2 1/4] crypto: ecc - add privkey generation support
Date: Mon, 29 May 2017 11:56:55 +0200
Message-ID: <1712750.5bvosCThh4@tauon.chronox.de>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com> <6869489.T5IFoD8UlO@tauon.chronox.de> <f8e3cae5-d431-85e2-8d87-6624058d52ea@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, marcel@holtmann.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59826 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751011AbdE2J46 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:56:58 -0400
In-Reply-To: <f8e3cae5-d431-85e2-8d87-6624058d52ea@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 29. Mai 2017, 11:47:48 CEST schrieb Tudor Ambarus:

Hi Tudor,

> > Hm, there should be no blocking for the DRBG to initialize.
> > 
> > What happens if you compile that as a module and insmod it at runtime?
> 
> We will have a nop:
> 
> #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> 
> /* a perfect nop */
> int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
> {
> 	printk(KERN_ERR "no op in alg_test");
> 	return 0;
> }
> 
> #else
> ...
> #endif
> 
> If I further mangle it and change #ifdef with #ifndef then the tests are
> passing.

Can you please enable the testmgr in the kernel config and compile the DH/ECDH 
code as a module. Then I would insmod the dh/ecdh kernel module to see whether 
the self tests work or not.

Note, if you use the calls of crypto_get_default_rng and friends, the DRBG 
must be present in the kernel at the time of calling. I.e. if you statically 
compile dh/ecdh but compile the RNG support as a module, the RNG will not load 
during self test. If you compile dh/ecdh as a module, the RNG can stay as a 
module.

Ciao
Stephan
