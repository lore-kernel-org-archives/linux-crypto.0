Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF280C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6C5D2081B
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfBVMAf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:00:35 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54834 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVMAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:00:35 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9VI-0000bZ-IG; Fri, 22 Feb 2019 20:00:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9VI-0007Dh-EU; Fri, 22 Feb 2019 20:00:32 +0800
Date:   Fri, 22 Feb 2019 20:00:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto: test that CBC and CTR update the IV
Message-ID: <20190222120032.t4ej6j5tajopk6j6@gondor.apana.org.au>
References: <20190214080355.8112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214080355.8112-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 14, 2019 at 12:03:49AM -0800, Eric Biggers wrote:
> Hello,
> 
> This series makes the crypto self-tests test that all CBC and CTR
> implementations update req->iv to contain the IV for the next block.
> This apparently has been a requirement for a long time, but it wasn't
> actually tested for.
> 
> With this series applied, all self-tests pass on x86_64, arm32, and
> arm64.  But I'm not able to test hardware drivers, so possibly some of
> them will fail and still need to be fixed.
> 
> Eric Biggers (6):
>   crypto: testmgr - remove extra bytes from 3DES-CTR IVs
>   crypto: testmgr - support checking skcipher output IV
>   crypto: testmgr - add iv_out to all CBC test vectors
>   crypto: testmgr - add iv_out to all CTR test vectors
>   crypto: arm64/aes-blk - update IV after partial final CTR block
>   crypto: arm/aes-ce - update IV after partial final CTR block
> 
>  arch/arm/crypto/aes-ce-core.S |  26 ++++----
>  arch/arm64/crypto/aes-modes.S |   3 +-
>  crypto/testmgr.c              |   6 +-
>  crypto/testmgr.h              | 111 +++++++++++++++++++++++++++++++---
>  4 files changed, 120 insertions(+), 26 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
