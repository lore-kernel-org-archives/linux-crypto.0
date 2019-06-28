Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE325C4646D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8362086D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561698739;
	bh=IRQGF8vAku7wB0SAw6ssV5177l87E59zx30lN1xJdPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=APYQ+vzyrkeCXe8ECkMAd48V54DQKW2dOB9DOm+gZsSZjuJvZkmH8lfhxSQ5cpgaX
	 6we0UdRGkLvh9HrVEwG0+95pyRQIKqyRZn7owIBLSFQv0gjk94KPB0LzT3czt2ztp1
	 kzuCF8W8Oy0/X2Hr8wGozolk7Yfr8T3l0pnx1EA8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfF1FMP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfF1FMO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:12:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DAA206E0;
        Fri, 28 Jun 2019 05:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561698733;
        bh=IRQGF8vAku7wB0SAw6ssV5177l87E59zx30lN1xJdPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zfm+2ze2ffcgNtvKC4TDK1/DIgMftGdqZnopkhvBrlbGxgLjqfU4oMBgvg9kihoZy
         G6NVPWVjnswQFT9vHeCEibGN2qyDccdua7kxlBKp1wXQy3RhuGw958WxwFutCsl/sK
         bQWBSK8Keb8nZZRdNv6Nvcg255T7iJXgHJFBaFKk=
Date:   Thu, 27 Jun 2019 22:12:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        t-kristo@ti.com, linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 06/10] crypto: sa2ul: Add hmac(sha256)cbc(aes)
 AEAD Algo support
Message-ID: <20190628051211.GF673@sol.localdomain>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-7-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628042745.28455-7-j-keerthy@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 09:57:41AM +0530, Keerthy wrote:
> Add aead support for hmac(sha256)cbc(aes) algorithm. Authenticated
> encryption (AE) and authenticated encryption with associated data
> (AEAD) is a form of encryption which simultaneously provides
> confidentiality, integrity, and authenticity assurances on the data.
> 
> hmac(sha256) has a digest size of 32 bytes is used for authetication
> and AES in CBC mode is used in conjunction for encryption/decryption.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/crypto/sa2ul.c | 92 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 1a1bd882e0d2..9c9008e21867 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -271,6 +271,42 @@ void sa_hmac_sha1_get_pad(const u8 *key, u16 key_sz, u32 *ipad, u32 *opad)
>  		opad[i] = cpu_to_be32(opad[i]);
>  }
>  
> +void sha256_init(u32 *buf)

This needs to be static.

> +static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
> +				     const u8 *key, unsigned int keylen)
> +{
> +	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
> +	struct crypto_authenc_keys keys;
> +	int ret = 0, key_idx;
> +
> +	ret = crypto_authenc_extractkeys(&keys, key, keylen);
> +	if (ret)
> +		return ret;
> +
> +	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
> +	key_idx = (keys.enckeylen >> 3) - 2;

Where do you validate the key length?

- Eric
