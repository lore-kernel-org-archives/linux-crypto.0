From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sun4i-ss Fix a possible driver hang with ciphers
Date: Thu, 10 Sep 2015 17:26:54 +0800
Message-ID: <20150910092654.GB28753@gondor.apana.org.au>
References: <1441801627-31820-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxime.ripard@free-electrons.com,
	linux-arm-kernel@lists.infradead.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39316 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbIJJ1C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 05:27:02 -0400
Content-Disposition: inline
In-Reply-To: <1441801627-31820-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 09, 2015 at 02:27:07PM +0200, LABBE Corentin wrote:
> The sun4i_ss_opti_poll function cipher data until the output miter have
> a length of 0.
> If the crypto API client, give more SGs than necessary this could result
> in an infinite loop.
> Fix it by checking for remaining bytes, just like sun4i_ss_cipher_poll().
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
