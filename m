Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B34C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 09:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiFQJUx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 05:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiFQJUw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 05:20:52 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3300C5BD3C;
        Fri, 17 Jun 2022 02:20:50 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o289h-008Bxe-LO; Fri, 17 Jun 2022 19:20:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jun 2022 17:20:42 +0800
Date:   Fri, 17 Jun 2022 17:20:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qianweili@huawei.com, shenyang39@huawei.com
Subject: Re: [PATCH] MAINTAINERS: update HiSilicon ZIP and QM maintainers
Message-ID: <YqxHaoV4ZJK8LCJY@gondor.apana.org.au>
References: <20220609025639.3280804-1-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609025639.3280804-1-wangzhou1@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 09, 2022 at 02:56:39AM +0000, Zhou Wang wrote:
> This patch splits QM and ZIP in MAINTAINERS, then add Weili Qian for QM
> driver and Yang Shen for ZIP driver. This patch adds missing Kconfig and
> Makefile files as well.
> 
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>  MAINTAINERS | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
