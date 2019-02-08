Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A5CC169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07FC421917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfBHHp0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:45:26 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34162 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:45:26 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0qf-0000iz-Ut; Fri, 08 Feb 2019 15:45:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0qc-0002Qz-Mx; Fri, 08 Feb 2019 15:45:18 +0800
Date:   Fri, 8 Feb 2019 15:45:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christopher Diaz Riveros <chrisadr@gentoo.org>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch-next] crypto: testmgr - use kmemdup
Message-ID: <20190208074518.tmag56p75bvxfr6v@gondor.apana.org.au>
References: <20190129000118.15923-1-chrisadr@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129000118.15923-1-chrisadr@gentoo.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 28, 2019 at 07:01:18PM -0500, Christopher Diaz Riveros wrote:
> Fixes coccinnelle alerts:
> 
> /crypto/testmgr.c:2112:13-20: WARNING opportunity for kmemdup
> /crypto/testmgr.c:2130:13-20: WARNING opportunity for kmemdup
> /crypto/testmgr.c:2152:9-16: WARNING opportunity for kmemdup
> 
> Signed-off-by: Christopher Diaz Riveros <chrisadr@gentoo.org>
> ---
>  crypto/testmgr.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
