Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B569C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 03:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E38206EE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 03:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576638230;
	bh=A+InG/zx4k/YG4uRsvxBJkv3/P7BlJR0sRQZa1hcnVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bn5n0TLufn4xPfifgbR0QBvAf6zJOtWgxICwH98M1petZqJgwfdrT6PCZNUUtq08X
	 42EQBCXrQjmlvrvcll/PpWjbDtTpshoBJSBgLoDauNHn7PqvXHaBkLS6ZN4+0z83ym
	 aBlzPPPShzKKx+RybbMxnFbCLTZVoneJCA+LV0oQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfLRDDt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 22:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfLRDDt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 22:03:49 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E59B206D8;
        Wed, 18 Dec 2019 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576638229;
        bh=A+InG/zx4k/YG4uRsvxBJkv3/P7BlJR0sRQZa1hcnVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p4kq2e5gtR8UuUvPcQD9QMXuR2cZ0yicnQPASMMlY+aeobzs16lZuhafziJ570PRR
         XDBpPnc5QmE14JuUcfiZjeUz9RcfDmEU2TN9KJH0W/OQN8Lv7z95y3BvJrK2din2/i
         AHEJY57QvMFyOJrJLZ0gmQbeytPKWxOyH4gujrX8=
Date:   Tue, 17 Dec 2019 19:03:47 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH crypto-next v6 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
Message-ID: <20191218030347.GC3636@sol.localdomain>
References: <20191217174445.188216-1-Jason@zx2c4.com>
 <20191217174445.188216-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217174445.188216-2-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 17, 2019 at 06:44:43PM +0100, Jason A. Donenfeld wrote:
> diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
> index 21edbd8c99fb..6488e8b8379c 100644
> --- a/crypto/poly1305_generic.c
> +++ b/crypto/poly1305_generic.c
> @@ -31,6 +31,29 @@ static int crypto_poly1305_init(struct shash_desc *desc)
>  	return 0;
>  }
>  
> +static unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
> +					       const u8 *src, unsigned int srclen)
> +{
> +	if (!dctx->sset) {
> +		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
> +			poly1305_core_setkey((struct poly1305_core_key *)dctx->r, src);

Seems this should be using a union, so that all these casts to a different
struct type (which is normally undefined behavior) aren't needed.

- Eric
