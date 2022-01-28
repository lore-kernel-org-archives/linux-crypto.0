Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44C0C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346445AbiA1G0c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:26:32 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60610 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346443AbiA1G0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:26:31 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKiL-0001Am-Gq; Fri, 28 Jan 2022 17:26:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:26:29 +1100
Date:   Fri, 28 Jan 2022 17:26:29 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Siming Wan <siming.wan@intel.com>,
        Xin Zeng <xin.zeng@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: Re: [PATCH] crypto: qat - fix access to PFVF interrupt registers for
 GEN4
Message-ID: <YfOMlQQPQhByCnce@gondor.apana.org.au>
References: <20220118103515.51374-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118103515.51374-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 18, 2022 at 10:35:15AM +0000, Giovanni Cabiddu wrote:
> The logic that detects, enables and disables pfvf interrupts was
> expecting a single CSR per VF. Instead, the source and mask register are
> two registers with a bit per VF.
> Due to this, the driver is reading and setting reserved CSRs and not
> masking the correct source of interrupts.
> 
> Fix the access to the source and mask register for QAT GEN4 devices by
> removing the outer loop in adf_gen4_get_vf2pf_sources(),
> adf_gen4_enable_vf2pf_interrupts() and
> adf_gen4_disable_vf2pf_interrupts() and changing the helper macros
> ADF_4XXX_VM2PF_SOU and ADF_4XXX_VM2PF_MSK.
> 
> Fixes: a9dc0d966605 ("crypto: qat - add PFVF support to the GEN4 host driver")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Co-developed-by: Siming Wan <siming.wan@intel.com>
> Signed-off-by: Siming Wan <siming.wan@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 42 ++++---------------
>  1 file changed, 9 insertions(+), 33 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
