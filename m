Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F74C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 03:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiCIDYQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 22:24:15 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43131C900
        for <linux-crypto@vger.kernel.org>; Tue,  8 Mar 2022 19:23:17 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nRmux-0002yF-B3; Wed, 09 Mar 2022 14:23:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Mar 2022 15:23:15 +1200
Date:   Wed, 9 Mar 2022 15:23:15 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - resolve warnings reported by clang
Message-ID: <Yigdo69j5QtShaj5@gondor.apana.org.au>
References: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 04, 2022 at 06:03:53PM +0000, Giovanni Cabiddu wrote:
> Resolve minor issues reported by clang, when compiling the driver with
> W=2, and by scan-build.
> 
> Giovanni Cabiddu (3):
>   crypto: qat - remove unneeded assignment
>   crypto: qat - fix initialization of pfvf cap_msg structures
>   crypto: qat - fix initialization of pfvf rts_map_msg structures
> 
>  drivers/crypto/qat/qat_common/adf_gen4_pfvf.c   | 2 +-
>  drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
