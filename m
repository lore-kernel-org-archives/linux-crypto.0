Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFEEC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0BF23977
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbhANGrQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 01:47:16 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42168 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANGrQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 01:47:16 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwOv-00087c-Ru; Thu, 14 Jan 2021 17:46:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:46:33 +1100
Date:   Thu, 14 Jan 2021 17:46:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - configure arbiter mapping based on engines
 enabled
Message-ID: <20210114064633.GC12584@gondor.apana.org.au>
References: <20210104165546.6686-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104165546.6686-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 04:55:46PM +0000, Giovanni Cabiddu wrote:
> From: Wojciech Ziemba <wojciech.ziemba@intel.com>
> 
> The hardware specific function adf_get_arbiter_mapping() modifies
> the static array thrd_to_arb_map to disable mappings for AEs
> that are disabled. This static array is used for each device
> of the same type. If the ae mask is not identical for all devices
> of the same type then the arbiter mapping returned by
> adf_get_arbiter_mapping() may be wrong.
> 
> This patch fixes this problem by ensuring the static arbiter
> mapping is unchanged and the device arbiter mapping is re-calculated
> each time based on the static mapping.
> 
> Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 14 ++--------
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 17 +++--------
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 27 ++++--------------
>  .../crypto/qat/qat_common/adf_accel_devices.h |  3 +-
>  .../crypto/qat/qat_common/adf_hw_arbiter.c    |  8 ++----
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 28 +++----------------
>  6 files changed, 20 insertions(+), 77 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
