Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836F4C2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF6720882
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfL0Kgx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 05:36:53 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60164 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfL0Kgx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 05:36:53 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikmzD-0007Iu-S5; Fri, 27 Dec 2019 18:36:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikmzB-0005lE-HJ; Fri, 27 Dec 2019 18:36:49 +0800
Date:   Fri, 27 Dec 2019 18:36:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     clabbe.montjoie@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: allwinner - remove unneeded semicolon
Message-ID: <20191227103649.n6rrwp3sr3z3vozs@gondor.apana.org.au>
References: <20191216105704.9841-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216105704.9841-1-chenzhou10@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 16, 2019 at 06:57:04PM +0800, Chen Zhou wrote:
> Fixes coccicheck warning:
> 
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:558:52-53: Unneeded semicolon
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
