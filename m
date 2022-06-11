Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CDAC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jun 2022 21:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiFKVE5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jun 2022 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFKVE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jun 2022 17:04:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DE93E5DE
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jun 2022 14:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8956EB80B48
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jun 2022 21:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54148C34116;
        Sat, 11 Jun 2022 21:04:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FYzLitTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654981484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFecTmRBbM0Dgzg/OqgSH12fzke409zK6seno7xeqEs=;
        b=FYzLitTIfaY3vN0auPZJKQG0z0q+/R4nQ1zHUyNVeHsLDqMjz0qg/rOFnyNbrWIusagtWi
        zUXn/FlZLzHE43a3ev4z/DBre7Zu+fw8zWR9Uj9F9S7Rr1dVzrK95EzUsBgULqWyGNWcLr
        hU9OasDUONPiTsk0JV8vw7ONDXqgkk8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id efe6da43 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 21:04:44 +0000 (UTC)
Date:   Sat, 11 Jun 2022 23:04:41 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Biggers <ebiggers@google.com>,
        David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: blake2b_compress_one_generic() stack use with gcc-12
Message-ID: <YqUDaR2ywTdHr+re@zx2c4.com>
References: <CAHk-=wjxqgeG2op+=W9sqgsWqCYnavC+SRfVyopu9-31S6xw+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjxqgeG2op+=W9sqgsWqCYnavC+SRfVyopu9-31S6xw+Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Linus,

On Sat, Jun 11, 2022 at 12:24:29PM -0700, Linus Torvalds wrote:
> So this is a "Help me, Obi-Wan Kenobi. You're my only hope" email.
> 
> Anybody got any ideas?

The way to fix this is by re-rolling the rounds:

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 6704c0355889..ac50c3086f6b 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -89,18 +89,9 @@ static void blake2b_compress_one_generic(struct blake2b_state *S,
 	v[14] = BLAKE2B_IV6 ^ S->f[0];
 	v[15] = BLAKE2B_IV7 ^ S->f[1];

-	ROUND(0);
-	ROUND(1);
-	ROUND(2);
-	ROUND(3);
-	ROUND(4);
-	ROUND(5);
-	ROUND(6);
-	ROUND(7);
-	ROUND(8);
-	ROUND(9);
-	ROUND(10);
-	ROUND(11);
+	for (i = 0; i < 12; ++i)
+		ROUND(i);
+
 #ifdef CONFIG_CC_IS_CLANG
 #pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
 #endif

The good thing about doing this is that it makes the function smaller,
so it fits easier into cache. The bad thing is that it means the
blake2b_sigma array can't be inlined, so you have accesses into that,
which means overall worse performance if called repeatedly (which maybe
it is? This is only used for btrfs disk hashing afaik). BLAKE2 is
actually 12 different permutations, rather than one, which is partially
how they got away with reducing the number of rounds from the original
BLAKE SHA-3 finalist. But without fancy permutation SIMD instructions,
it also means you're left with this trade off in the generic C code.

However, getting back to the actual issue you pointed out, this seems
like an odd gcc 12 issue. Or perhaps it's some aspect of the inliner
there? I noticed that on gcc 11, the above patch increases the frame
size from 416 to 704. But on gcc 12 it decreases it from 2632 to 680.
Huh.

Jason
