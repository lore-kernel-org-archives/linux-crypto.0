From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: How to use Linux Crypto API when we already registered with
	Hardware Crypto API
Date: Tue, 12 Jan 2010 22:22:07 +1100
Message-ID: <20100112112207.GA31676@gondor.apana.org.au>
References: <197D517E3C8D504283188E2A751290E86F05A366E2@IRVEXCHCCR02.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Bhaskara Peela <bhaskara.peela@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56344 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651Ab0ALLWO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 06:22:14 -0500
Content-Disposition: inline
In-Reply-To: <197D517E3C8D504283188E2A751290E86F05A366E2@IRVEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bhaskara Peela <bhaskara.peela@broadcom.com> wrote:
> 
> I am using 2.6.30 kernel.  I have registered some IPSec crypto/auth algorithms(ex: 3DES/MD5) supported by hardware with linux.  I want to verify the hardware crypto/authentication output with that of linux Crypto API.  To do this, I want to send same kind of IPSec packet to hardware crypto engine and linux Crypto API and compare the output.
> 
> I know, I can do this, by building two images one with hardware acceleration and one without it.   But, I want to do this run time so that it can be fast and i can use single image.  Can you suggest a way to do this in esp4.c ?

If you build your driver as a module, then you can easily switch
between it and the software implementation by loading/unloading
the module.

Of course, for verification purposes you don't even need to do
this as the self-test mechanism kicks in as soon as you register
your driver.

So just check /proc/crypto or dmesg after your driver is loaded.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
