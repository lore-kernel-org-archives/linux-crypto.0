From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: (none)
Date: Wed, 1 Jun 2016 15:05:49 +0800
Message-ID: <20160601070549.GA380@gondor.apana.org.au>
References: <20160601045943.GA31881@gondor.apana.org.au>
 <3022334.qkucHDndN1@tauon.atsec.com>
 <20160601061947.GA32424@gondor.apana.org.au>
 <CAH8yC8==HPONkYSoPaa9E0b4+SKnbPEPeQatBUqc_HzJbD8DAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55016 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbcFAHFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 03:05:53 -0400
Content-Disposition: inline
In-Reply-To: <CAH8yC8==HPONkYSoPaa9E0b4+SKnbPEPeQatBUqc_HzJbD8DAA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:59:21AM -0400, Jeffrey Walton wrote:
> 
> $ cat /proc/modules | egrep -i '(via|padlock|rng)'
> padlock_sha 16384 0 - Live 0x00000000
> padlock_aes 16384 0 - Live 0x00000000
> via_cputemp 16384 0 - Live 0x00000000
> hwmon_vid 16384 1 via_cputemp, Live 0x00000000
> via_rng 16384 0 - Live 0x00000000
> i2c_viapro 16384 0 - Live 0x00000000
> pata_via 16384 0 - Live 0x00000000
> sata_via 16384 2 - Live 0x00000000

OK, by default hwrng entropy is not fed into /dev/random.

You need to enable it by hand by setting default_quality on the
rng-core module to a non-zero value.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
