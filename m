Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A313C2D0EE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC985206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgC0Eyh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 00:54:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57066 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgC0Eyh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 00:54:37 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jHh0f-0000C0-K5; Fri, 27 Mar 2020 15:54:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2020 15:54:21 +1100
Date:   Fri, 27 Mar 2020 15:54:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: ccree - remove duplicated include from
 cc_aead.c
Message-ID: <20200327045421.GB19912@gondor.apana.org.au>
References: <20200318020040.175704-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318020040.175704-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 18, 2020 at 02:00:40AM +0000, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/ccree/cc_aead.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
