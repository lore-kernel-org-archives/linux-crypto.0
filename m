Return-Path: <SRS0=O2m6=RK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D3BC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 08:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D54920675
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 08:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfCGI0Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 03:26:16 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:55284 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfCGI0P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 03:26:15 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h1oLz-000495-GF; Thu, 07 Mar 2019 16:26:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h1oLx-0006Ae-9S; Thu, 07 Mar 2019 16:26:09 +0800
Date:   Thu, 7 Mar 2019 16:26:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: Re: [PATCH RESEND v3] crypto: caam - add missing put_device() call
Message-ID: <20190307082609.fj3thwpg5ggoxmn7@gondor.apana.org.au>
References: <20190301171925.22650-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190301171925.22650-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 01, 2019 at 07:19:25PM +0200, Horia Geantă wrote:
> From: Wen Yang <yellowriver2010@hotmail.com>
> 
> The of_find_device_by_node() takes a reference to the underlying device
> structure, we should release that reference.
> 
> Fixes: 35af64038623 ("crypto: caam - Check for CAAM block presence before registering with crypto layer")
> Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>
> ---
> 
> Looks like previous versions, for some unknown reason, did not reach
> the mailing lists.
> 
> Resending v3 with the addition of a 2nd Fixes and Reviewed-by tags,
> cf. https://lkml.org/lkml/2019/2/11/383
> 
>  drivers/crypto/caam/caamalg.c    | 12 +++++++-----
>  drivers/crypto/caam/caamalg_qi.c | 11 ++++++++---
>  drivers/crypto/caam/caamhash.c   | 18 +++++++++++-------
>  drivers/crypto/caam/caampkc.c    | 14 ++++++++++----
>  drivers/crypto/caam/caamrng.c    | 22 ++++++++++++++--------
>  5 files changed, 50 insertions(+), 27 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
