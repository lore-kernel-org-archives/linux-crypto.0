Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CB1C07E9D
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Sep 2022 08:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiIXITu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Sep 2022 04:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiIXITS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Sep 2022 04:19:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E97810044;
        Sat, 24 Sep 2022 01:18:08 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oc0MP-007wfF-1O; Sat, 24 Sep 2022 18:18:06 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Sep 2022 16:18:04 +0800
Date:   Sat, 24 Sep 2022 16:18:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     y00501072 <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/qm - fix the qos value initialization
Message-ID: <Yy69PE/XR/B5GXXA@gondor.apana.org.au>
References: <20220917100345.37296-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220917100345.37296-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 17, 2022 at 10:03:45AM +0000, y00501072 wrote:
> From: Kai Ye <yekai13@huawei.com>
> 
> The default qos value is not initialized when sriov is repeatedly enabled
> and disabled. So add the vf qos value initialized in the sriov enable
> process.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
