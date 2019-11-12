Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4B9C17441
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C0820650
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfKLJhH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 04:37:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42010 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfKLJhH (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 12 Nov 2019 04:37:07 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iUSbi-0005bw-GB; Tue, 12 Nov 2019 17:37:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iUSbi-00083c-BA; Tue, 12 Nov 2019 17:37:06 +0800
Date:   Tue, 12 Nov 2019 17:37:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: sun4i-ss - Fix 64-bit size_t warnings
Message-ID: <20191112093706.zzo6le5sj5vm47hb@gondor.apana.org.au>
References: <20191112023834.l7mbyrlhhaxgpbdp@gondor.apana.org.au>
 <20191112093527.GB18647@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112093527.GB18647@Red>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 10:35:27AM +0100, Corentin Labbe wrote:
>
> Note that the driver is within !64BIT, so that compiling on 64-bit should not be doable/an issue, but removing this conditionnal could be a good point.

Right.  I'm trying to get rid of the !64BIT dependency which is why
I ran into these warnings.

> Furthermore, I just tested compiling on 64BIT and there are the same warnings on sun4i-ss-hash.c.
> I will send a subsequent patch for it.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
