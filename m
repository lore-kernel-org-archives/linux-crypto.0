Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4236EC64EC4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Mar 2023 10:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCIKmF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Mar 2023 05:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCIKlh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2023 05:41:37 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA424E8CE8
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2023 02:40:15 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paDgX-0025XO-E3; Thu, 09 Mar 2023 18:39:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Mar 2023 18:39:45 +0800
Date:   Thu, 9 Mar 2023 18:39:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] crypto: qat - change size of status variable
Message-ID: <ZAm3cSjNderM7gzn@gondor.apana.org.au>
References: <20230309113306.4008-1-meadhbh.fitzpatrick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309113306.4008-1-meadhbh.fitzpatrick@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 09, 2023 at 11:33:06AM +0000, Meadhbh Fitzpatrick wrote:
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
> index b533984906ec..726b71d2a4a8 100644
> --- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
> @@ -183,7 +183,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
>  	int consumed, produced;
>  	s8 cmp_err, xlt_err;
>  	int res = -EBADMSG;
> -	int status;
> +	s8 status;

Sorry, but this makes no sense.  Why are these s8's to begin
with? It doesn't look like you even allow negative values.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
