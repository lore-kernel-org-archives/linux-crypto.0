Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB31EC4708D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F8661005
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhE1H25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 03:28:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50320 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235932AbhE1H24 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 03:28:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lmWtr-0003hD-Hm; Fri, 28 May 2021 15:27:19 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lmWtr-00020e-CT; Fri, 28 May 2021 15:27:19 +0800
Date:   Fri, 28 May 2021 15:27:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for Qualcomm crypto drivers
Message-ID: <20210528072719.GL7392@gondor.apana.org.au>
References: <20210521025844.1239294-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521025844.1239294-1-thara.gopinath@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 20, 2021 at 10:58:44PM -0400, Thara Gopinath wrote:
> There is no maintainer for Qualcomm crypto drivers and we are seeing more
> development in this area. Add myself as the maintainer so that I can help
> in reviewing the changes submitted to these drivers.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
