Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A980CC2D0C8
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7965B206DA
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577767436;
	bh=Damv19VXLyaT1Htnt50UiVcnrVnRvBNZYwxTUDwfTqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AEVCw2n13L+VsT6lEBO0a9jEOerlfofaTcHoqCF2qUzS2KbgFZPP9mf/1LpHQK5li
	 +oHRQ4xlEnO6Gnn4HcNfqAwiM2qg1HKS5GY7Q/tR2B13wVbCpluWD0xx1HR2npR9gY
	 NsRMFLTQ1JI6E9L651pZ8qx9yhSI+yqkMNhH0G/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfLaEnz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 23:43:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfLaEnz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 23:43:55 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5366206D9;
        Tue, 31 Dec 2019 04:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577767435;
        bh=Damv19VXLyaT1Htnt50UiVcnrVnRvBNZYwxTUDwfTqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=za5yRxmSe6FHDzTpKPD85+AtyXpiTFFdSeG4//eCdYQ/JbgiMcHb/LuXK292GESkc
         o6gMMgmjF4aWq6kRxJZFnv5bcOgj1Kr20p4yES9YMBaGaoVecwoeS2d+w9SmmAsLYs
         /57qSG7GjYdZZagyzIVRzhMvTcyRvaobjZVClQWU=
Date:   Mon, 30 Dec 2019 22:43:52 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>
Subject: Re: [PATCH 2/8] crypto: artpec6 - return correct error code for
 failed setkey()
Message-ID: <20191231044352.GB180988@zzz.localdomain>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231031938.241705-3-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Cc the people with Cc tags in the patch, who I accidentally didn't Cc...
 Original message was
 https://lkml.kernel.org/linux-crypto/20191231031938.241705-3-ebiggers@kernel.org/]

On Mon, Dec 30, 2019 at 09:19:32PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ->setkey() is supposed to retun -EINVAL for invalid key lengths, not -1.
> 
> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index 4b20606983a4..22ebe40f09f5 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -1251,7 +1251,7 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
>  
>  	if (len != 16 && len != 24 && len != 32) {
>  		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -1;
> +		return -EINVAL;
>  	}
>  
>  	ctx->key_length = len;
> -- 
> 2.24.1
> 
