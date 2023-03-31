Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBFEC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 10:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCaKL7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 06:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCaKK6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 06:10:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336892291C;
        Fri, 31 Mar 2023 03:06:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1piBdm-00AlZk-B0; Fri, 31 Mar 2023 18:05:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Mar 2023 18:05:50 +0800
Date:   Fri, 31 Mar 2023 18:05:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto - img-hash: Depend on OF and silence compile
 test warning
Message-ID: <ZCawfhD05h37HLk0@gondor.apana.org.au>
References: <20230326085027.4759-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230326085027.4759-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 26, 2023 at 10:50:27AM +0200, Krzysztof Kozlowski wrote:
> The driver is specific to OF platforms (can match only via OF table),
> thus add dependency on CONFIG_OF.  Mark the of_device_id table as
> unused.  This also fixes W=1 warning:
> 
>   drivers/crypto/img-hash.c:930:34: error: ‘img_hash_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

...

> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> index fe93d19e3044..2be364d9f592 100644
> --- a/drivers/crypto/img-hash.c
> +++ b/drivers/crypto/img-hash.c
> @@ -927,7 +927,7 @@ static void img_hash_done_task(unsigned long data)
>  	img_hash_finish_req(hdev->req, err);
>  }
>  
> -static const struct of_device_id img_hash_match[] = {
> +static const struct of_device_id img_hash_match[] __maybe_unused = {
>  	{ .compatible = "img,hash-accelerator" },
>  	{}
>  };

I have applied this hunk as it renders the Kconfig change unnecessary.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
