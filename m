Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04E9CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbjJTFwk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJTFwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:52:40 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B2CA
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:52:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiQz-0097Y9-OF; Fri, 20 Oct 2023 13:52:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:52:39 +0800
Date:   Fri, 20 Oct 2023 13:52:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Subject: Re: [PATCH] crypto: qat - fix double free during reset
Message-ID: <ZTIVp0FQIBhPfd3/@gondor.apana.org.au>
References: <20231009122723.35136-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009122723.35136-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 09, 2023 at 01:27:19PM +0100, Giovanni Cabiddu wrote:
> From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> 
> There is no need to free the reset_data structure if the recovery is
> unsuccessful and the reset is synchronous. The function
> adf_dev_aer_schedule_reset() handles the cleanup properly. Only
> asynchronous resets require such structure to be freed inside the reset
> worker.
> 
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
