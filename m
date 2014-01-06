From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 06 Jan 2014 09:57:03 -0800
Message-ID: <1389031023.2624.21.camel@schen9-DESK>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1389030119.2624.19.camel@schen9-DESK>
	 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbaAFR5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 12:57:03 -0500
In-Reply-To: <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-01-06 at 09:45 -0800, H. Peter Anvin wrote:
> Can the code be adjusted to compile for 32 bit x86 or is that pointless?
> 

Code was optimized for wide registers.  So it is only meant for x86_64.

Tim

> Tim Chen <tim.c.chen@linux.intel.com> wrote:
> >
> >
> >On Mon, 2013-12-30 at 15:52 +0200, Andy Shevchenko wrote:
> >> It seems commit d764593a "crypto: aesni - AVX and AVX2 version of
> >AESNI-GCM
> >> encode and decode" breaks a build on x86_32 since it's designed only
> >for
> >> x86_64. This patch makes a compilation unit conditional to
> >CONFIG_64BIT and
> >> functions usage to CONFIG_X86_64.
> >
> >Thanks for catching and fixing it.
> >
> >Tim
> >> 
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
