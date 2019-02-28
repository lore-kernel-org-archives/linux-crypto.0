Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C47C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 201FF20842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfB1Gah (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:30:37 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39846 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1Gah (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:30:37 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFDE-0005lX-11; Thu, 28 Feb 2019 14:30:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFDB-0001e0-Kw; Thu, 28 Feb 2019 14:30:29 +0800
Date:   Thu, 28 Feb 2019 14:30:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chengguang Xu <cgxu519@gmx.com>
Cc:     horia.geanta@nxp.com, aymen.sghaier@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam - remove redundant likely/unlikely
 annotation
Message-ID: <20190228063029.twbik6t7iw534lz2@gondor.apana.org.au>
References: <20190220104918.32637-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220104918.32637-1-cgxu519@gmx.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 06:49:18PM +0800, Chengguang Xu wrote:
> unlikely has already included in IS_ERR(), so just
> remove redundant likely/unlikely annotation.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> v1->v2:
> - Fix subject typo and format.
> 
>  drivers/crypto/caam/caamalg_qi.c | 6 +++---
>  drivers/crypto/caam/qi.c         | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
