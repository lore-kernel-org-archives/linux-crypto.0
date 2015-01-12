From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: Crypto: Add support for 192 & 256 bit keys to AESNI RFC4106 -
 resubmission
Date: Mon, 12 Jan 2015 10:26:49 -0800
Message-ID: <1421087209.2399.14.camel@schen9-desk2.jf.intel.com>
References: <Pine.WNT.4.64.1501112342160.7768@Fly3>
	 <20150112060651.GA9726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Timothy McCaffrey <timcaffrey420@gmail.com>,
	linux-crypto@vger.kernel.org, Timothy.McCaffrey@Unisys.com,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbbALS1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2015 13:27:07 -0500
In-Reply-To: <20150112060651.GA9726@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2015-01-12 at 17:06 +1100, Herbert Xu wrote:
> On Sun, Jan 11, 2015 at 11:48:08PM -0500, Timothy McCaffrey wrote:
> >
> > This patch has been tested with Sandy Bridge and Haswell processors.  With 128
> > bit keys and input buffers > 512 bytes a slight performance degradation was
> > noticed (~1%).  For input buffers of less than 512 bytes there was no
> > performance impact.  Compared to 128 bit keys, 256 bit key size performance
> > is approx. .5 cycles per byte slower on Sandy Bridge, and .37 cycles per 
> > byte slower on Haswell (vs. SSE code).
> 
> Thanks Tim!
> 
> While I think your patch should definitely be applied to the
> current GCM implementation, longer term I'd like to see some
> justification why we're adding these optimisations in the form
> of gcm-aesni rather than ghash-avx and ctr-aesni.
> 
> Is there any reason why these optimisations can't be added to
> the standalone ghash or ctr(aes)? Or for that matter is there
> some fundamental synergy that I'm not seeing that you would only
> get by putting these into gcm-aesni?

Herbert,

To quote Vinod who wrote the original gcm-aesni code, the reason to
combine the ghash and ctr(aes) is as follow:

"AES-GCM gets a lot of performance due to a fine-grained stitching of
AES with GHASH. Depending on the uarch, a majority of the GHASH
computation can be hidden within the AES."

Adding Vinod also to this mail thread.

Tim

> 
> If the answers are no and no, then I'd like to see all these
> optimisations migrated over to ghash and ctr(aes) and then we
> can simply remove gcm-aesni.
> 
> Cheers,
