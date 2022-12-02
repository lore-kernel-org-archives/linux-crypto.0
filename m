Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0502BC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 10:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiLBKTQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiLBKTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 05:19:10 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED7ACCFE3;
        Fri,  2 Dec 2022 02:19:08 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p138D-003CBO-0z; Fri, 02 Dec 2022 18:18:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Dec 2022 18:18:57 +0800
Date:   Fri, 2 Dec 2022 18:18:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     giovanni.cabiddu@intel.com, davem@davemloft.net,
        marco.chiappero@intel.com, tomaszx.kowalik@intel.com,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - fix error return code in adf_probe
Message-ID: <Y4nREStki30yYxI9@gondor.apana.org.au>
References: <1669030054-9605-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669030054-9605-1-git-send-email-wangyufen@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 21, 2022 at 07:27:34PM +0800, Wang Yufen wrote:
> Fix to return a negative error code -EINVAL instead of 0.
> 
> Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/crypto/qat/qat_4xxx/adf_drv.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
