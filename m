Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45180C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1865F61151
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhHPCo6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Aug 2021 22:44:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53060 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhHPCo6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Aug 2021 22:44:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mFSby-0002zU-RT; Mon, 16 Aug 2021 10:44:26 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mFSbw-0002eg-OE; Mon, 16 Aug 2021 10:44:24 +0800
Date:   Mon, 16 Aug 2021 10:44:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sachinp@linux.vnet.ibm.com,
        Stephan Mueller <smueller@chronox.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] crypto: DRBG - select SHA512
Message-ID: <20210816024424.GA10184@gondor.apana.org.au>
References: <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
 <20210716081411.GA2062@gondor.apana.org.au>
 <YRft/tuKE6MjHhY7@zn.tnic>
 <20210816020735.GA10021@gondor.apana.org.au>
 <20210816044514.Horde.WAvjInneMUMGu0ryEZHgrQ8@messagerie.c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816044514.Horde.WAvjInneMUMGu0ryEZHgrQ8@messagerie.c-s.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 16, 2021 at 04:45:14AM +0200, Christophe Leroy wrote:
>
> The fixes tag has a problem it seems. Should be corrected before pushing.

It's too late for that.  This commit is at the base of many other
subsequent changes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
