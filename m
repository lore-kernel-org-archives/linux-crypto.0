Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8B9C83006
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 08:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB2D21D79
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 08:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="rYM07iRw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgD3IQD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgD3IQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 04:16:03 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FA5C035494
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2020 01:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588234559;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=N/X1yHgcAwzpNEaixXj7pjLLUEtCJYiXYX1zXTZkYl8=;
        b=rYM07iRwbNMj/p2Ks5d6IA4dM0b5Hbld5Qab0AHaEtMIh1U6BkV+H2t5m5Z40Yl80L
        woagynx4Tr3yOhDoPRAePBI5vX0LoIhe02Py4EUCyo8HAZLhOM6/Pfo/RMLIUS/eSQnG
        WZA7WLDWxh3/lAzrSr1kaESg8lfX6Okry+4ts+Ad3/Vkd8mXrPDChTOVc/okp8Efh8Je
        N7O+uKXPmeI3XYtSfWvIbnbsboUyQcJfmzydJO2OE0hbj1odoafmWlviBTWRlkc+PxER
        K7pwaTk9NVZ+u8OUqo5avx2UZ54wmLNTY6NvrjhdHNzFVBXiRHpndw5se/2VyOm2/EJn
        lqZQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSfJdtJ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w3U8FujWg
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 30 Apr 2020 10:15:56 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: drbg - fix error return code in drbg_alloc_state()
Date:   Thu, 30 Apr 2020 10:15:56 +0200
Message-ID: <4688335.RcRiWGvq7B@tauon.chronox.de>
In-Reply-To: <20200430081353.112449-1-weiyongjun1@huawei.com>
References: <20200430081353.112449-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 30. April 2020, 10:13:53 CEST schrieb Wei Yongjun:

Hi Wei,

> Fix to return negative error code -ENOMEM from the kzalloc error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: db07cd26ac6a ("crypto: drbg - add FIPS 140-2 CTRNG for noise source")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  crypto/drbg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index e57901d8545b..37526eb8c5d5 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1306,8 +1306,10 @@ static inline int drbg_alloc_state(struct drbg_state
> *drbg) if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
>  		drbg->prev = kzalloc(drbg_sec_strength(drbg->core->flags),
>  				     GFP_KERNEL);
> -		if (!drbg->prev)
> +		if (!drbg->prev) {
> +			ret = -ENOMEM;
>  			goto fini;
> +		}
>  		drbg->fips_primed = false;
>  	}

Thank you

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


