Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A217BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 08:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiDOInH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351456AbiDOImk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 04:42:40 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717598EB6B;
        Fri, 15 Apr 2022 01:40:04 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nfHUc-003EXs-Lt; Fri, 15 Apr 2022 18:39:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Apr 2022 16:39:50 +0800
Date:   Fri, 15 Apr 2022 16:39:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     giovanni.cabiddu@intel.com, davem@davemloft.net,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - stop using iommu_present()
Message-ID: <YlkvVssU6P7vrHUU@gondor.apana.org.au>
References: <ef01fbd7d2c60d56a0b8e8847a08ccb3ee5132af.1649161511.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef01fbd7d2c60d56a0b8e8847a08ccb3ee5132af.1649161511.git.robin.murphy@arm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 05, 2022 at 01:25:11PM +0100, Robin Murphy wrote:
> Even if an IOMMU might be present for some PCI segment in the system,
> that doesn't necessarily mean it provides translation for the device
> we care about. Replace iommu_present() with a more appropriate check.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/crypto/qat/qat_common/adf_sriov.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
