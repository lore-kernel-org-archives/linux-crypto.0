From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: aesni-intel - Fixed build error on x86-32
Date: Mon, 29 Nov 2010 08:36:08 +0800
Message-ID: <20101129003608.GA14734@gondor.apana.org.au>
References: <20101127083524.GC2364@gondor.apana.org.au> <1290969588-30200-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Huang Ying <ying.huang@intel.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56765 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0K2AgL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Nov 2010 19:36:11 -0500
Content-Disposition: inline
In-Reply-To: <1290969588-30200-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 28, 2010 at 07:39:48PM +0100, Mathias Krause wrote:
> Herbert, thanks for merge but the AES-GCM code merged meanwhile made the x86-32
> bit version break on build. The following patch fixes this (now compile tested
> on x86-64, too):
> 
> Exclude AES-GCM code for x86-32 due to heavy usage of 64-bit registers
> not available on x86-32.
> 
> While at it, fixed unregister order in aesni_exit().
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patch applied.  Thanks Mathias!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
