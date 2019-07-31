Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F9DC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18E520693
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfGaMcc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:32:32 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60847 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387639AbfGaMcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 08:32:32 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 62F84E0009;
        Wed, 31 Jul 2019 12:32:29 +0000 (UTC)
Date:   Wed, 31 Jul 2019 14:32:28 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: inside-secure: Remove redundant DES ECB & CBC
 keysize check
Message-ID: <20190731123228.GD3579@kwain>
References: <1564553454-25955-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564553454-25955-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Jul 31, 2019 at 08:10:54AM +0200, Pascal van Leeuwen wrote:
> This patch removes a DES key size check that is redundant as it is already
> performed by the crypto API itself due to min_keysize = max_keysize.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 56dc8f9..d52b8ff 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -1188,11 +1188,6 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
>  	u32 tmp[DES_EXPKEY_WORDS];
>  	int ret;
>  
> -	if (len != DES_KEY_SIZE) {
> -		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
> -
>  	ret = des_ekey(tmp, key);
>  	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
>  		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
