Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DC2C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJULev (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiJULe3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:34:29 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7725599;
        Fri, 21 Oct 2022 04:34:22 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqHQ-004dk4-PE; Fri, 21 Oct 2022 19:34:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:34:13 +0800
Date:   Fri, 21 Oct 2022 19:34:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] nitrox: avoid double free on error path in
 nitrox_sriov_init()
Message-ID: <Y1KDtUdjmEVRKPt9@gondor.apana.org.au>
References: <20220928102505.39709-1-n.petrova@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928102505.39709-1-n.petrova@fintech.ru>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 28, 2022 at 01:25:05PM +0300, Natalia Petrova wrote:
> If alloc_workqueue() fails in nitrox_mbox_init() it deallocates
> ndev->iov.vfdev and returns error code, but then nitrox_sriov_init()
> calls nitrox_sriov_cleanup() where ndev->iov.vfdev is deallocated
> again.
> 
> Fix this by nulling ndev->iov.vfdev after the first deallocation.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_mbx.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
