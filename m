Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4279EECAAD5
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 10:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiIBKTQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiIBKTO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 06:19:14 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53032BCCFD
        for <linux-crypto@vger.kernel.org>; Fri,  2 Sep 2022 03:19:13 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU3lW-000KgO-Cf; Fri, 02 Sep 2022 20:19:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 18:19:10 +0800
Date:   Fri, 2 Sep 2022 18:19:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] Crypto: Fix dma_map_sg error check
Message-ID: <YxHYnnECfa2rlbrn@gondor.apana.org.au>
References: <20220825072421.29020-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825072421.29020-1-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 25, 2022 at 09:24:15AM +0200, Jack Wang wrote:
> Hi, all,
> 
> While working on a bugfix on RTRS[1], I noticed there are quite a few other
> drivers have the same problem, due to the fact dma_map_sg return 0 on error,
> not like most of the cases, return negative value for error.
> 
> I "grep -A 5 dma_map_sg' in kernel tree, and audit/fix the one I feel is buggy,
> hence this patchset. As suggested by Christoph Hellwig, I now send the patches per
> subsystem, this is for crypto subsystem.
> 
> Thanks!
> 
> [1] https://lore.kernel.org/linux-rdma/20220818105355.110344-1-haris.iqbal@ionos.com/T/#t
> 
> 
> Jack Wang (6):
>   crypto: gemin: Fix error check for dma_map_sg
>   crypto: sahara: Fix error check for dma_map_sg
>   crypto: qce: Fix dma_map_sg error check
>   crypto: amlogic: Fix dma_map_sg error check
>   crypto: allwinner: Fix dma_map_sg error check
>   crypto: ccree: Fix dma_map_sg error check
> 
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 +++---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 2 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 4 ++--
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 2 +-
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 6 +++---
>  drivers/crypto/ccree/cc_buffer_mgr.c                | 2 +-
>  drivers/crypto/gemini/sl3516-ce-cipher.c            | 6 +++---
>  drivers/crypto/qce/aead.c                           | 4 ++--
>  drivers/crypto/qce/sha.c                            | 8 +++++---
>  drivers/crypto/qce/skcipher.c                       | 8 ++++----
>  drivers/crypto/sahara.c                             | 4 ++--
>  11 files changed, 27 insertions(+), 25 deletions(-)

These patches have already been applied to cryptodev.  However,
upon further reflection I have decided to revert two of the patches
which actually made the code less robust.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
