From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] The IXP4xx crypto driver should select CRYPTO_AUTHENC
Date: Sun, 13 Jul 2008 20:12:39 +0800
Message-ID: <20080713121239.GA20542@gondor.apana.org.au>
References: <12158073023807-git-send-email-kaloz@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, chohnstaedt@innominate.com
To: Imre Kaloz <kaloz@openwrt.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58127 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752872AbYGMMMq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Jul 2008 08:12:46 -0400
Content-Disposition: inline
In-Reply-To: <12158073023807-git-send-email-kaloz@openwrt.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 11, 2008 at 08:15:02PM +0000, Imre Kaloz wrote:
> Without CRYPTO_AUTHENC the driver fails to build:
> drivers/built-in.o: In function `ixp_module_init':
> ixp4xx_crypto.c:(.init.text+0x3250): undefined reference to `crypto_aead_type'
> 
> Signed-off-by: Imre Kaloz <kaloz@openwrt.org>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
