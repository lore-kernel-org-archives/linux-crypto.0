Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF6BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiI3GQ0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiI3GP4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:15:56 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2BC7B1E0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 23:15:54 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe9JQ-00A58f-1e; Fri, 30 Sep 2022 16:15:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 14:15:52 +0800
Date:   Fri, 30 Sep 2022 14:15:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Adam Guerin <adam.guerin@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2] crypto: qat - add limit to linked list parsing
Message-ID: <YzaJmMXh/BL5IEbf@gondor.apana.org.au>
References: <20220921090923.213968-1-adam.guerin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921090923.213968-1-adam.guerin@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 21, 2022 at 10:09:24AM +0100, Adam Guerin wrote:
> adf_copy_key_value_data() copies data from userland to kernel, based on
> a linked link provided by userland. If userland provides a circular
> list (or just a very long one) then it would drive a long loop where
> allocation occurs in every loop. This could lead to low memory conditions.
> Adding a limit to stop endless loop.
> 
> Signed-off-by: Adam Guerin <adam.guerin@intel.com>
> Co-developed-by: Ciunas Bennett <ciunas.bennett@intel.com>
> Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v2: improved patch based off feedback from ML
> drivers/crypto/qat/qat_common/adf_ctl_drv.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
