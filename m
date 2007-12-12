From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [2.6 patch] crypto/geode-aes.c: add __dev{init,exit} annotations
Date: Wed, 12 Dec 2007 10:43:08 +0800
Message-ID: <20071212024308.GA21320@gondor.apana.org.au>
References: <20071211221949.GB14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jordan Crouse <jordan.crouse@amd.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1369 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbXLLCnW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Dec 2007 21:43:22 -0500
Content-Disposition: inline
In-Reply-To: <20071211221949.GB14204@stusta.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 11, 2007 at 11:19:50PM +0100, Adrian Bunk wrote:
> This patch adds __dev{init,exit} annotations.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to cryptodev.  Thanks Adrian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
