Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFF1C19F2D
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Aug 2022 18:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245196AbiHISX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Aug 2022 14:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346352AbiHISVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Aug 2022 14:21:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B3D30F71;
        Tue,  9 Aug 2022 11:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 884EFB8191D;
        Tue,  9 Aug 2022 18:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20EC433D7;
        Tue,  9 Aug 2022 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660068423;
        bh=mpQMti49pYC6uBbppBC/68xa8KuEYFFq6Y5tSKu+5mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZadcVQXJ9mw3zLTMpkx8f1L3zlsqF20OvMzoQHigrCCWEy0RaZ3/XCRqLe8ZgSPFu
         K0X1GkXznnvFdqyMHE3a+y+/5BxyFN9Z6oS+O8ZI9D77335EQN1V6cCQYwcLwn55CP
         0LcqDNKId2qi+BY85LS4HTTVke2Tl74g/gvn7eGbJx/woH5axDs844USYZZjggK4uq
         Vq1jf81XApEo6pHWuUuFgMgLYfc0kDFqdbzQj34XRW9UdAuXm9bi1xvwWZeg4OeMcj
         dxyl80lTEhEo52EdRYxbIzHiWfQAcGhapk5nuOyIBg5IE8m6QeUyhva6R31mF5fye4
         h6TmVJb+ZY7Mw==
Date:   Tue, 9 Aug 2022 18:07:01 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dong Chuanjian <chuanjian@nfschina.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@nfschina.com
Subject: Re: [PATCH] crypto/drbg.c:remove unnecessary (void*) conversions
Message-ID: <YvKiRWzWyATdEwGP@gmail.com>
References: <20220809091452.5264-1-chuanjian@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091452.5264-1-chuanjian@nfschina.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 09, 2022 at 05:14:52PM +0800, Dong Chuanjian wrote:
>  	struct crypto_cipher *tfm =
> -		(struct crypto_cipher *)drbg->priv_data;
> +		drbg->priv_data;

Might as well join this into one line.

>  
>  	crypto_cipher_setkey(tfm, key, (drbg_keylen(drbg)));
>  }
> @@ -1828,7 +1828,7 @@ static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
>  			  const struct drbg_string *in)
>  {
>  	struct crypto_cipher *tfm =
> -		(struct crypto_cipher *)drbg->priv_data;
> +		drbg->priv_data;

Likewise.

- Eric
