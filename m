From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Thu, 9 Jan 2014 17:03:03 +0800
Message-ID: <20140109090302.GA11622@gondor.apana.org.au>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1389030119.2624.19.camel@schen9-DESK>
 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
 <1389031023.2624.21.camel@schen9-DESK>
 <52CAEF55.5090308@zytor.com>
 <1389031855.2624.26.camel@schen9-DESK>
 <20140106202640.GB17863@pd.tnic>
 <52CB1E45.6060204@zytor.com>
 <1389051546.2624.31.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46657 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaAIJDb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jan 2014 04:03:31 -0500
Content-Disposition: inline
In-Reply-To: <1389051546.2624.31.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 06, 2014 at 03:39:06PM -0800, Tim Chen wrote:
> On Mon, 2014-01-06 at 13:21 -0800, H. Peter Anvin wrote:
> > On 01/06/2014 12:26 PM, Borislav Petkov wrote:
> > > On Mon, Jan 06, 2014 at 10:10:55AM -0800, Tim Chen wrote:
> > >> Yes, the code is in the file named aesni_intel_avx.S. So it should be
> > >> clear that the code is meant for x86_64.
> > > 
> > > How do you deduce aesni_intel_avx.S is meant for x86_64 only from the
> > > name?
> > > 
> > > Shouldn't it be called aesni_intel_avx-x86_64.S, as is the naming
> > > convention in arch/x86/crypto/
> > > 
> > 
> > Quite.
> > 
> > 	-hpa
> > 
> > 
> 
> Will renaming the file to aesni_intel_avx-x86_64.S make things clearer
> now?
> 
> Tim
> 
> ---cut---here---
> 
> >From 41656afcbd63ccb92357d4937a75629499f4fd4f Mon Sep 17 00:00:00 2001
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Date: Mon, 6 Jan 2014 07:23:52 -0800
> Subject: [PATCH] crypto: Rename aesni-intel_avx.S to indicate it only
>  supports x86_64
> To: Herbert Xu <herbert@gondor.apana.org.au>, H. Peter Anvin <hpa@zytor.com>
> Cc: Borislav Petkov <bp@alien8.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-crypto@vger.kernel.org
> 
> We rename aesni-intel_avx.S to aesni-intel_avx-x86_64.S to indicate
> that it is only used by x86_64 architecture.

Hmm, where is the signed-off-by line? Please resend.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
