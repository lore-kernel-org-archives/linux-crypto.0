From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Tue, 31 Dec 2013 19:57:43 +0800
Message-ID: <20131231115743.GA17120@gondor.apana.org.au>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>, hpa@zytor.com
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50763 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3LaL5s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Dec 2013 06:57:48 -0500
Content-Disposition: inline
In-Reply-To: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 30, 2013 at 03:52:24PM +0200, Andy Shevchenko wrote:
> It seems commit d764593a "crypto: aesni - AVX and AVX2 version of AESNI-GCM
> encode and decode" breaks a build on x86_32 since it's designed only for
> x86_64. This patch makes a compilation unit conditional to CONFIG_64BIT and
> functions usage to CONFIG_X86_64.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
