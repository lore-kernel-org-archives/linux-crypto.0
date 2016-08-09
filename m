From: Stephan Mueller <smueller@chronox.de>
Subject: Re: FIPS mode: modprobe: ERROR: could not insert 'drbg'
Date: Tue, 09 Aug 2016 19:52:46 +0200
Message-ID: <2671088.6l5BeQPtPO@positron.chronox.de>
References: <D3CF7065.28F3%tsarangi@trustwave.com> <1699099.iu8Xr4xQ6X@tauon.atsec.com> <D3CF7805.2937%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34420 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbcHIRww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 13:52:52 -0400
In-Reply-To: <D3CF7805.2937%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 17:11:09 CEST schrieb Tapas Sarangi:

Hi Tapas, Herbert,

> Hi Stephan,
> 
> Thanks. I have already tried that. ‘drbg’ module is loaded fine in a
> non-fips mode. Here are output from some commands.

There is something strange going on. I have to compile the DRBG statically. 
When booting the kernel with fips=1 (of course after changing the key size to 
2k or 3k in certs/x509.genkey), the DRBG does not show up in /proc/crypto nor 
can I find testmgr entries about the DRBG.

When I reboot the kernel without fips=1, all works as expected.

When I create a copy of the drbg.c code and have it compiled as a module to 
ensure it is signed, I can insmod it and the testmgr successfully tests it.

Note, with fips=1, my kernel crashes randomly somewhere in the elf loading 
code -- I guess it is because there is no stdrng.

> 
> I see that at some point you had a patch to use CONFIG_CRYPTO_LRNG. I am
> not using that, could that be a problem ?

Nope, this LRNG is something completely different -- it is my proposal to 
replace the current /dev/random and /dev/urandom implementation as documented 
in [1].

[1] http://www.chronox.de/lrng.html

Ciao
Stephan
