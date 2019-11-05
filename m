Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5793EC17461
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3573B21D7C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbfKENVf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:21:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33350 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388753AbfKENVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 08:21:35 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iRym3-00063F-H8; Tue, 05 Nov 2019 21:21:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iRym2-0000nm-1v; Tue, 05 Nov 2019 21:21:30 +0800
Date:   Tue, 5 Nov 2019 21:21:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org, ard.biesheuvel@kernel.org
Subject: Re: [PATCH 0/6] crypto: omap: fix extra tests with crypto manager
Message-ID: <20191105132129.p2xykf53ni3lbf4t@gondor.apana.org.au>
References: <20191105123759.25053-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105123759.25053-1-t-kristo@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 05, 2019 at 02:37:53PM +0200, Tero Kristo wrote:
> Hi,
> 
> This series applies on top of [1] and [2] to fix the remaining crypto
> manager extra test failures.
> 
> Tested with crypto manager self tests, tcrypto, and an ipsec test
> with strongswan.
> 
> -Tero
> 
> [1] https://patchwork.kernel.org/cover/11195515/
> [2] https://patchwork.kernel.org/cover/11213525/

Please merge all three patch series into one and repost.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
