Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797D8C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 00:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5178C207F7
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 00:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHMA7D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 20:59:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54384 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgHMA7D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 20:59:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k61a8-0001ZK-0b; Thu, 13 Aug 2020 10:59:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Aug 2020 10:59:00 +1000
Date:   Thu, 13 Aug 2020 10:58:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH v2 3/3] drivers: crypto: add the Virtual Function driver
 for OcteonTX2 CPT
Message-ID: <20200813005859.GC24593@gondor.apana.org.au>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-4-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596809360-12597-4-git-send-email-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 07, 2020 at 07:39:20PM +0530, Srujana Challa wrote:
>
> +static inline int is_any_alg_used(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(otx2_cpt_skciphers); i++)
> +		if (refcount_read(&otx2_cpt_skciphers[i].base.cra_refcnt) != 1)
> +			return true;
> +	for (i = 0; i < ARRAY_SIZE(otx2_cpt_aeads); i++)
> +		if (refcount_read(&otx2_cpt_aeads[i].base.cra_refcnt) != 1)
> +			return true;
> +	return false;
> +}

This is racy as there is nothing stopping new users from coming in
after you've finished the test.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
