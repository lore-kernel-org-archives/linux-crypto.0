Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31907C636D4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 01:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjBCBiD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 20:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjBCBiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 20:38:02 -0500
X-Greylist: delayed 1974 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 17:38:00 PST
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B7B83CF;
        Thu,  2 Feb 2023 17:38:00 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pNkVf-006ynE-OX; Fri, 03 Feb 2023 09:05:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Feb 2023 09:04:59 +0800
Date:   Fri, 3 Feb 2023 09:04:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 01, 2023 at 03:59:44PM +0000, Giovanni Cabiddu wrote:
.
> @@ -435,8 +435,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
>  	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
>  		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
>  					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
> -		keylen = round_up(keylen, 16);
>  		memcpy(cd->ucs_aes.key, key, keylen);
> +		keylen = round_up(keylen, 16);

Now cd->ucs_aes.key contains potentially unitialised data, should
we zero them?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
