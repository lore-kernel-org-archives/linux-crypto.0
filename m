Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2FEC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Oct 2021 02:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E547361207
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Oct 2021 02:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhJFCfZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Oct 2021 22:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhJFCfY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Oct 2021 22:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4C8A611CC;
        Wed,  6 Oct 2021 02:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633487613;
        bh=rGBV9oCijeB0Pmnbqd6PA+nWxxlxjjJ47RWuIo5ESt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Krsq1A0OQj56CHdu3TVRXoV+lNfRqIc5M2vh7Gh6epRSRvsJhEeBaTuksMgtnZgB7
         NbKDFfKRdq0cMgtfjFkh35+bkKmLVX4ifFQ8a1dJE9ZRxjLAbnxxKxtpKLNKmO5WCb
         5QB6chWz6SOd8IT1AvWMG0Ihq/YyrKZUG8K2TgwP3NFhzzHY7XotegsO2mFE5O7Y36
         hUecQe0jw1ugSVQNM8DpLVk1afTVd+bri3qgrF/CzcmAHylawvbWorlhzWFwlbGn5e
         QaDro2qaM8GojHNctTItelQ5TqwojYWg6kf98JlsMmCmkrlgU1rQzwOfINNhR4le82
         GStuKKEd/UZ9w==
Date:   Tue, 5 Oct 2021 19:33:28 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YV0K+EbrAqDdw2vp@archlinux-ax161>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003002801.GA5435@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 03, 2021 at 08:28:01AM +0800, Herbert Xu wrote:
> On Fri, Oct 01, 2021 at 11:01:59AM -0700, Nathan Chancellor wrote:
> >
> > I have attached the Kconfig file that I used to reproduce it. It is
> > still reproducible for me at your latest commit in cryptodev
> > (e42dff467ee688fe6b5a083f1837d06e3b27d8c0) with that exact command that
> > I gave you.
> > 
> > It is possible that it could be crypto_boot_test_finished?
> 
> I don't think that's the issue because algapi already depends on
> api.  However, the softdep on cryptomgr in api looks suspicious,
> as it would always introduce a loop.  Can you try removing that
> softdep from api.c and see if the problem resolves it self?

I assume this is the diff you mean? This does not resolve the issue. My
apologies if I am slow to respond, I am on vacation until the middle of
next week.

Cheers,
Nathan

diff --git a/crypto/api.c b/crypto/api.c
index ee5991fe11f8..e3e87c37f996 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -646,4 +646,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");
