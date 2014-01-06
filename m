From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 6 Jan 2014 21:26:40 +0100
Message-ID: <20140106202640.GB17863@pd.tnic>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1389030119.2624.19.camel@schen9-DESK>
 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
 <1389031023.2624.21.camel@schen9-DESK>
 <52CAEF55.5090308@zytor.com>
 <1389031855.2624.26.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:42605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbaAFVTZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 16:19:25 -0500
Content-Disposition: inline
In-Reply-To: <1389031855.2624.26.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 06, 2014 at 10:10:55AM -0800, Tim Chen wrote:
> Yes, the code is in the file named aesni_intel_avx.S. So it should be
> clear that the code is meant for x86_64.

How do you deduce aesni_intel_avx.S is meant for x86_64 only from the
name?

Shouldn't it be called aesni_intel_avx-x86_64.S, as is the naming
convention in arch/x86/crypto/

?


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
