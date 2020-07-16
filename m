Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D2FC433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23D220739
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGPL4C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 07:56:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40148 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgGPL4B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 07:56:01 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw2US-0008Tj-DJ; Thu, 16 Jul 2020 21:55:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 21:55:52 +1000
Date:   Thu, 16 Jul 2020 21:55:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meng Yu <yumeng18@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] crypto: hisilicon/hpre bugfix - misc fixes
Message-ID: <20200716115552.GG31166@gondor.apana.org.au>
References: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 10, 2020 at 03:40:40PM +0800, Meng Yu wrote:
> Bugfix: crypto: hisilicon/hpre - modify the macros, add a switch in
>     sriov_configure, unified debugfs interface, and disable
>     hardware FLR.
> 
> Hui Tang (2):
>   crypto: hisilicon/hpre - HPRE_OVERTIME_THRHLD can be written by
>     debugfs
>   crypto: hisilicon/hpre - disable FLR triggered by hardware
> 
> Meng Yu (4):
>   crypto: hisilicon/hpre - Init the value of current_q of debugfs
>   crypto: hisilicon/hpre - Modify the Macro definition and format
>   crypto: hisilicon/hpre - Add a switch in sriov_configure
>   crypto: hisilicon/hpre - update debugfs interface parameters
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 111 +++++++++++++++++-------------
>  1 file changed, 62 insertions(+), 49 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
