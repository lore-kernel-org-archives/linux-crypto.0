From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara: Use dmam_alloc_coherent
Date: Wed, 19 Aug 2015 23:11:32 +0800
Message-ID: <20150819151132.GA20201@gondor.apana.org.au>
References: <20150818060605.GA29208@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55239 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbbHSPLg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 11:11:36 -0400
Content-Disposition: inline
In-Reply-To: <20150818060605.GA29208@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 18, 2015 at 11:36:05AM +0530, Vaishali Thakkar wrote:
> This patch moves the data allocated using dma_alloc_coherent to the
> corresponding managed interface. To be compatible with the change,
> various gotos are replaced with direct returns and unneeded labels
> are dropped.
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
