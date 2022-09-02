Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00F4C38145
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 11:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiIBLCI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 07:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiIBLCH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 07:02:07 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EB2A2DB6;
        Fri,  2 Sep 2022 04:02:06 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU4R1-000LQZ-Od; Fri, 02 Sep 2022 21:02:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 19:02:03 +0800
Date:   Fri, 2 Sep 2022 19:02:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        wangzhou1@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix missing put dfx access
Message-ID: <YxHiq6BTC0Zf0w+H@gondor.apana.org.au>
References: <20220827102737.8634-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827102737.8634-1-qianweili@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 27, 2022 at 06:27:37PM +0800, Weili Qian wrote:
> In function qm_cmd_write(), if function returns from
> branch 'atomic_read(&qm->status.flags) == QM_STOP',
> the got dfx access is forgotten to put.
> 
> Fixes: 607c191b371d ("crypto: hisilicon - support runtime PM for accelerator device")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
