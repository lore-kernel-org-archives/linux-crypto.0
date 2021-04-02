Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DA5C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 09:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0656112E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 09:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhDBJsg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:48:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33770 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhDBJsg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 05:48:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lSGPl-0003Wm-T5; Fri, 02 Apr 2021 20:48:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Apr 2021 20:48:29 +1100
Date:   Fri, 2 Apr 2021 20:48:29 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 0/4] crypto: hisilicon/zip - support new 'sqe' type in
 Kunpeng930
Message-ID: <20210402094829.GH24509@gondor.apana.org.au>
References: <1616830128-46827-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616830128-46827-1-git-send-email-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 27, 2021 at 03:28:44PM +0800, Yang Shen wrote:
> In Kunpeng930, some field meanings in 'sqe' are changed, so driver need to
> distinguish the type on different platform.
> 
> To avoid checking the platform everytime when driver fills the 'sqe', add a
> struct 'hisi_zip_sqe_ops' to describe the 'sqe' operations. The driver only
> need to choose the 'ops' once when call 'hisi_zip_acomp_init'.
> 
> v1 -> v2:
> * fix a sparse warning
> 
> Yang Shen (4):
>   crypto: hisilicon/zip - adjust functions location
>   crypto: hisilicon/zip - add comments for 'hisi_zip_sqe'
>   crypto: hisilicon/zip - initialize operations about 'sqe' in
>     'acomp_alg.init'
>   crypto: hisilicon/zip - support new 'sqe' type in Kunpeng930
> 
>  drivers/crypto/hisilicon/zip/zip.h        |  46 +-
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 706 +++++++++++++++++-------------
>  2 files changed, 438 insertions(+), 314 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
