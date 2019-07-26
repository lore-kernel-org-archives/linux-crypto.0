Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A64C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8173C20823
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfGZMTr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:19:47 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:36333 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:19:47 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 09711240007;
        Fri, 26 Jul 2019 12:19:39 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:19:38 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Message-ID: <20190726121938.GC3235@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 05, 2019 at 08:49:22AM +0200, Pascal van Leeuwen wrote:
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Could you provide a commit message, explaining briefly what the patch is
doing?

> @@ -199,6 +201,15 @@ static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
>  		goto badkey;
>  
>  	/* Encryption key */
> +	if (ctx->alg == SAFEXCEL_3DES) {
> +		flags = crypto_aead_get_flags(ctfm);
> +		err = __des3_verify_key(&flags, keys.enckey);
> +		crypto_aead_set_flags(ctfm, flags);

You could use directly des3_verify_key() which does exactly this.

> +struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
> +	.type = SAFEXCEL_ALG_TYPE_AEAD,

You either missed to fill .engines member of this struct, or this series
is based on another one not merged yet.

> +	.alg.aead = {
> +		.setkey = safexcel_aead_setkey,
> +		.encrypt = safexcel_aead_encrypt_3des,
> +		.decrypt = safexcel_aead_decrypt_3des,
> +		.ivsize = DES3_EDE_BLOCK_SIZE,
> +		.maxauthsize = SHA1_DIGEST_SIZE,
> +		.base = {
> +			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
> +			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",

You could drop "_ede" here, or s/_/-/.

Apart from those small comments, the patch looks good.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
