Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8263DC169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DD1721917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfBHHsq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:48:46 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34250 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:48:46 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0tt-0000qc-Sm; Fri, 08 Feb 2019 15:48:41 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0tt-0002U0-IW; Fri, 08 Feb 2019 15:48:41 +0800
Date:   Fri, 8 Feb 2019 15:48:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drag <ofir.drang@arm.com>
Subject: Re: [PATCH] MAINTAINERS: crypto: ccree: remove co-maintainer
Message-ID: <20190208074841.5pkmbe7qu3sglxrh@gondor.apana.org.au>
References: <20190207134415.311-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207134415.311-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 07, 2019 at 03:44:15PM +0200, Gilad Ben-Yossef wrote:
> The best-laid plans of mice and men often go awry.
> Remove Yael C. as co-maintainer as she moved on to other endeavours.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
