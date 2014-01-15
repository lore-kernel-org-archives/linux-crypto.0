From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Wed, 15 Jan 2014 11:43:24 +0800
Message-ID: <20140115034323.GC13556@gondor.apana.org.au>
References: <1389030119.2624.19.camel@schen9-DESK>
 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
 <1389031023.2624.21.camel@schen9-DESK>
 <52CAEF55.5090308@zytor.com>
 <1389031855.2624.26.camel@schen9-DESK>
 <20140106202640.GB17863@pd.tnic>
 <52CB1E45.6060204@zytor.com>
 <1389051546.2624.31.camel@schen9-DESK>
 <20140109090302.GA11622@gondor.apana.org.au>
 <1389286662.2624.32.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37407 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaAODoE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 22:44:04 -0500
Content-Disposition: inline
In-Reply-To: <1389286662.2624.32.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 09, 2014 at 08:57:42AM -0800, Tim Chen wrote:
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
> ---
>  arch/x86/crypto/Makefile                                        | 2 +-
>  arch/x86/crypto/{aesni-intel_avx.S => aesni-intel_avx-x86_64.S} | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename arch/x86/crypto/{aesni-intel_avx.S => aesni-intel_avx-x86_64.S} (100%)
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
