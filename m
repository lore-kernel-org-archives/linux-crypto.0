From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Tue, 7 Jan 2014 09:30:38 +0800
Message-ID: <20140107013038.GA11416@gondor.apana.org.au>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1389030119.2624.19.camel@schen9-DESK>
 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
 <1389031023.2624.21.camel@schen9-DESK>
 <52CAEF55.5090308@zytor.com>
 <1389031855.2624.26.camel@schen9-DESK>
 <20140106202640.GB17863@pd.tnic>
 <52CB1E45.6060204@zytor.com>
 <1389051546.2624.31.camel@schen9-DESK>
 <52CB3F3F.5070105@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34765 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAGBbF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 20:31:05 -0500
Content-Disposition: inline
In-Reply-To: <52CB3F3F.5070105@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 06, 2014 at 03:41:51PM -0800, H. Peter Anvin wrote:
> On 01/06/2014 03:39 PM, Tim Chen wrote:
> > 
> > Will renaming the file to aesni_intel_avx-x86_64.S make things clearer
> > now?
> > 
> > Tim
> 
> Yes.
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> Herbert, can you pick it up?

Sure I'll apply this patch.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
