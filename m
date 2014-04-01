From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto:master 60/60]
 arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted
 __be64
Date: Tue, 1 Apr 2014 20:48:24 +0800
Message-ID: <20140401124824.GA13642@gondor.apana.org.au>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
 <CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	kbuild test robot <fengguang.wu@intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53016 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaDAMs2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2014 08:48:28 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 01, 2014 at 02:37:20PM +0200, Ard Biesheuvel wrote:
> On 1 April 2014 13:23, kbuild test robot <fengguang.wu@intel.com> wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> > head:   8ceee72808d1ae3fb191284afc2257a2be964725
> > commit: 8ceee72808d1ae3fb191284afc2257a2be964725 [60/60] crypto: ghash-clmulni-intel - use C implementation for setkey()
> > reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted __be64
> >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:72:25: sparse: cast to restricted __be64
> >
> 
> Sigh.
> 
> The sparse warnings /without/ the be64 casts are even worse.
> 
> The obvious fix is not to use a be128 for the key, as it is obviously
> an opaque type that just represents a byte array.
> So, Herbert, if you prefer, I can rework this patch to use be128
> instead of u128 inside struct ghash_ctx, but it will have some fallout
> throughout the file. Or instead, we cast to '__force __be64',
> basically just telling sparse to shut up ...

I'll add the __force to shut it up.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
