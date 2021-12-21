Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B3EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 00:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhLUAwz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 19:52:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhLUAwy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 19:52:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A70F0B81053
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 00:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4631CC36AE5;
        Tue, 21 Dec 2021 00:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640047972;
        bh=6IDG0mgHFF93SsPMA0I+4PedGwuEJ/h4cLj9+IIPZso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DB6vYu3DFtUFUGT0hfThVDZNyF9HUAtD/YVkXN/+n9DZ6wbKLSlU9GQOc5THZRLN2
         pnxAuq3HdS1Q2GxN3HZOK3bZ1trkywuuNLBrUAg8g0jVRzvMa8YTBOUoRUJmTzKLfG
         jEJ23XD5pEZToDz6M7oGgtzxT6IMDBkD2resGznluDSmjdWFOJGwfRYrqO8+kh3LQc
         qgbmzOGfXY93d3jqkk6NDtgC9arezMgQXUPOg85lvq0pXw8Qx3FFD2SNUcyHgX0yvT
         LDKQkfxy5w2I8taJve5d/yXv4oT59Y2qPplXgUj9nJv6c4w4OmUTgaRztKOQMzOG7s
         sIhE0fO0OsuCA==
Date:   Mon, 20 Dec 2021 16:52:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208044037.GA11399@gondor.apana.org.au>
        <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 20 Dec 2021 16:11:25 -0800 Jakub Kicinski wrote:
> On Mon, 20 Dec 2021 15:03:43 -0800 Jakub Kicinski wrote:
> > Hm, I'm benchmarking things now and it appears to be a regression
> > introduced somewhere around 5.11 / 5.12. I don't see the memcpy 
> > eating 20% of performance on 5.10. Bisection time.  
> 
> 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
> 
> is what introduced the regression.

Something like this?

---->8-----------

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 20 Dec 2021 16:29:26 -0800
Subject: [PATCH] x86/aesni: don't require alignment

Looks like we take care of the meta-data (key, iv etc.) alignment
anyway and data can safely be unaligned. In fact we were feeding
unaligned data into crypto routines up until commit 83c83e658863 
("crypto: aesni - refactor scatterlist processing") switched to 
use the full skcipher API.

This fixes 21% performance regression in kTLS.

Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
(and running thru various kTLS packets).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e09f4672dd38..41901ba9d3a2 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 }, {
@@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct generic_gcmaes_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 } };
-- 
2.31.1

