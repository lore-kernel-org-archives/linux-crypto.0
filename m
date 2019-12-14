Return-Path: <SRS0=D8v3=2E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A331C43603
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 08:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 115DB24656
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 08:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfLNI4U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Dec 2019 03:56:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:38846 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfLNI4U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Dec 2019 03:56:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ig3Dh-0004BO-R7; Sat, 14 Dec 2019 16:56:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ig3Dd-0005sE-1S; Sat, 14 Dec 2019 16:56:09 +0800
Date:   Sat, 14 Dec 2019 16:56:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jason@zx2c4.com, martin@strongswan.org, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
Message-ID: <20191214085608.b53yiogf432zxyw7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213032849.GC1109@sol.localdomain>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
>
> Now, it's possible that the performance gain outweighs this, and I too would
> like to have the C implementation of Poly1305 be faster.  So if you'd like to
> argue for the performance gain, fine, and if there's a significant performance
> gain I don't have an objection.  But I'm not sure why you're at the same time
> trying to argue that *adding* an extra implementation somehow makes the code
> easier to audit and doesn't add complexity...

Right.  We need the numbers not because we're somehow attached
to the existing code, but we need them to show that we should
carry the burden of having two C implementations, 32-bit vs 64-bit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
