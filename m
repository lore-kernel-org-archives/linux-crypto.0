Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0A0C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 12:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A05208CC
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 12:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfKSMxm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 07:53:42 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51260 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfKSMxl (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 19 Nov 2019 07:53:41 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iX30i-0005W3-QP; Tue, 19 Nov 2019 20:53:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iX30f-000520-LP; Tue, 19 Nov 2019 20:53:33 +0800
Date:   Tue, 19 Nov 2019 20:53:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@google.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: pcrypt - forbid recursive instantiation
Message-ID: <20191119125333.xzfvclo2aiycvjsn@gondor.apana.org.au>
References: <20190920043556.GP2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920043556.GP2879@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 20, 2019 at 06:35:56AM +0200, Steffen Klassert wrote:
>
> Fix this by making pcrypt forbid instantiation if pcrypt appears in the
> underlying ->cra_driver_name or if an underlying algorithm needs a
> fallback.  This is somewhat of a hack, but it's a simple fix that should
> be sufficient to prevent the deadlock.

This still doesn't resolve the case where pcrypt is used in a
non-transparent fashion, e.g., through a fallback.  Note that
even adding a NEED_FALLBACK flag won't fix this as you can construct
an instance on top of a NEED_FALLBACK algorithm that itself does
not need a fallback.

Anyway I decided to change pcrypt to use a set of queues per
instance rather than globally and it should resolve the problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
