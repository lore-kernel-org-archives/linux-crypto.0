Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AA2C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F2020693
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfCVNE5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:04:57 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49526 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731293AbfCVNEz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:04:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7Jqt-0006Lp-Ao; Fri, 22 Mar 2019 21:04:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7Jqt-0005g8-5G; Fri, 22 Mar 2019 21:04:51 +0800
Date:   Fri, 22 Mar 2019 21:04:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Kconfig - fix typos AEGSI -> AEGIS
Message-ID: <20190322130451.vn37nnh74rjf5ajq@gondor.apana.org.au>
References: <20190315074725.31253-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315074725.31253-1-omosnace@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 15, 2019 at 08:47:25AM +0100, Ondrej Mosnacek wrote:
> Spotted while reviewind patches from Eric Biggers.
> 
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  crypto/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
