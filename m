Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69014C6FA94
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 10:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiIPKyK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 06:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiIPKxx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 06:53:53 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1BAAFAFC
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:37:11 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZ8iX-005Gwg-1W; Fri, 16 Sep 2022 20:37:06 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Sep 2022 18:37:04 +0800
Date:   Fri, 16 Sep 2022 18:37:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH 0/3] crypto: qat - fix DMA mappings
Message-ID: <YyRR0KglVVuo05rm@gondor.apana.org.au>
References: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 09, 2022 at 11:49:11AM +0100, Giovanni Cabiddu wrote:
> This set fixes a set of issues related to an improper use of the DMA
> APIs reported when CONFIG_DMA_API_DEBUG is selected and by the static
> analyzer Smatch.
> 
> The first patch fixes an overlapping DMA mapping which occurs when
> in-place operations that share the same buffers but a different
> scatterlist structure are sent to the implementations of aead and
> skcipher in the QAT driver.
> The second commit reverts a patch that attempted to fix a warning
> reported by Smatch. This improperly reduced the mapping size for the
> region of memory used to store the input and output parameters that are
> passed to the FW for performing the RSA and DH algorithms.
> The last patch properly fixes the issues that the reverted commit
> attempted to fix.
> 
> Damian Muszynski (2):
>   crypto: qat - fix DMA transfer direction
>   crypto: qat - use reference to structure in dma_map_single()
> 
> Giovanni Cabiddu (1):
>   Revert "crypto: qat - reduce size of mapped region"
> 
>  drivers/crypto/qat/qat_common/qat_algs.c      | 18 +++++++++-----
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 24 +++++++++----------
>  2 files changed, 24 insertions(+), 18 deletions(-)
> 
> -- 
> 2.37.1

All applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
