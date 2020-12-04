Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0ECC4361A
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 07:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D66322581
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 07:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgLDHEq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:04:46 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60918 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgLDHEq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 02:04:46 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kl58J-0006Uq-Hu; Fri, 04 Dec 2020 18:04:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Dec 2020 18:03:59 +1100
Date:   Fri, 4 Dec 2020 18:03:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] crypto: hisilicon/sec - add new type of sqe for
 Kunpeng930
Message-ID: <20201204070359.GA26438@gondor.apana.org.au>
References: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
 <1606357086-9785-3-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606357086-9785-3-git-send-email-liulongfang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 26, 2020 at 10:18:03AM +0800, Longfang Liu wrote:
>
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
> index 0e933e7..712176b 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
> @@ -211,6 +219,167 @@ struct sec_sqe {
>  	struct sec_sqe_type2 type2;
>  };
>  
> +#pragma pack(4)

Please don't use pragma pack.  Instead add the attributes as
needed to each struct or member.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
