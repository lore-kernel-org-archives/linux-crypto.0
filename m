Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C3BC32772
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 11:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347439AbiHSLBd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 07:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348415AbiHSLBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 07:01:30 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBDF5CDD;
        Fri, 19 Aug 2022 04:01:24 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzkX-00CpcP-Uw; Fri, 19 Aug 2022 21:01:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 19:01:13 +0800
Date:   Fri, 19 Aug 2022 19:01:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhuo Chen <chenzhuo.1@bytedance.com>
Cc:     wangzhou1@hisilicon.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] crypto: hisilicon - Remove
 pci_aer_clear_nonfatal_status() call
Message-ID: <Yv9teZcrpM7D70xq@gondor.apana.org.au>
References: <20220802032937.27117-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802032937.27117-1-chenzhuo.1@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 02, 2022 at 11:29:37AM +0800, Zhuo Chen wrote:
> Calls to pci_cleanup_aer_uncorrect_error_status() have already been
> removed after commit 62b36c3ea664 ("PCI/AER: Remove
> pci_cleanup_aer_uncorrect_error_status() calls"). But in commit
> 6c6dd5802c2d ("crypto: hisilicon/qm - add controller reset interface")
> pci_aer_clear_nonfatal_status() was used again, so remove it in
> this patch.
> 
> note: pci_cleanup_aer_uncorrect_error_status() was renamed to
> pci_aer_clear_nonfatal_status() in commit 894020fdd88c
> ("PCI/AER: Rationalize error status register clearing")
> 
> Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
