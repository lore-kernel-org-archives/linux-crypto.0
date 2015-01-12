From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto: Add support for 192 & 256 bit keys to AESNI RFC4106 -
 resubmission
Date: Mon, 12 Jan 2015 17:06:51 +1100
Message-ID: <20150112060651.GA9726@gondor.apana.org.au>
References: <Pine.WNT.4.64.1501112342160.7768@Fly3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
	Timothy.McCaffrey@Unisys.com,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: Timothy McCaffrey <timcaffrey420@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54317 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbALGHR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2015 01:07:17 -0500
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.64.1501112342160.7768@Fly3>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 11, 2015 at 11:48:08PM -0500, Timothy McCaffrey wrote:
>
> This patch has been tested with Sandy Bridge and Haswell processors.  With 128
> bit keys and input buffers > 512 bytes a slight performance degradation was
> noticed (~1%).  For input buffers of less than 512 bytes there was no
> performance impact.  Compared to 128 bit keys, 256 bit key size performance
> is approx. .5 cycles per byte slower on Sandy Bridge, and .37 cycles per 
> byte slower on Haswell (vs. SSE code).

Thanks Tim!

While I think your patch should definitely be applied to the
current GCM implementation, longer term I'd like to see some
justification why we're adding these optimisations in the form
of gcm-aesni rather than ghash-avx and ctr-aesni.

Is there any reason why these optimisations can't be added to
the standalone ghash or ctr(aes)? Or for that matter is there
some fundamental synergy that I'm not seeing that you would only
get by putting these into gcm-aesni?

If the answers are no and no, then I'd like to see all these
optimisations migrated over to ghash and ctr(aes) and then we
can simply remove gcm-aesni.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
