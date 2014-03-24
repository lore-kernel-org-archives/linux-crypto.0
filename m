From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 0/3] crypto: x86/sha1 - regression and other fixes
Date: Mon, 24 Mar 2014 21:19:44 +0100
Message-ID: <201403242119.44692.marex@denx.de>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:33552 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaCXUgZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 16:36:25 -0400
In-Reply-To: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, March 24, 2014 at 05:10:36 PM, Mathias Krause wrote:
> The recent addition of the AVX2 variant of the SHA1 hash function wrongly
> disabled the AVX variant by introducing a flaw in the feature test. Fixed
> in patch 1.
> 
> The alignment calculations of the AVX2 assembler implementation are
> questionable, too. Especially the page alignment of the stack pointer is
> broken in multiple ways. Fixed in patch 2. In patch 3 another issue for
> code alignment is fixed.
> 
> Please apply!

Nice,

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
