Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC34C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA662085B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgIYIMA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:12:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53236 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbgIYIMA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:12:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLipd-00074k-DQ; Fri, 25 Sep 2020 18:11:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:11:53 +1000
Date:   Fri, 25 Sep 2020 18:11:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - remove unnecessary mutex_init()
Message-ID: <20200925081153.GF6381@gondor.apana.org.au>
References: <20200916062121.190541-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916062121.190541-1-miaoqinglang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 02:21:21PM +0800, Qinglang Miao wrote:
> The mutex adf_ctl_lock is initialized statically. It is
> unnecessary to initialize by mutex_init().
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
