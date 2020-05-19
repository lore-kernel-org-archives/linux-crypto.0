Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719D6C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 04:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F940206C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 04:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgESEii (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 00:38:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53996 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgESEii (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 00:38:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jau1G-00043S-Dh; Tue, 19 May 2020 14:38:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 May 2020 14:38:22 +1000
Date:   Tue, 19 May 2020 14:38:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>, Nick Terrell <terrelln@fb.com>,
        Chris Mason <clm@fb.com>
Cc:     linux-crypto@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] lib/xxhash: make xxh{32,64}_update() return void
Message-ID: <20200519043822.GA26368@gondor.apana.org.au>
References: <20200502063423.1052614-1-ebiggers@kernel.org>
 <20200515191516.GD1009@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515191516.GD1009@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 15, 2020 at 12:15:16PM -0700, Eric Biggers wrote:
> On Fri, May 01, 2020 at 11:34:23PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The return value of xxh64_update() is pointless and confusing, since an
> > error is only returned for input==NULL.  But the callers must ignore
> > this error because they might pass input=NULL, length=0.
> > 
> > Likewise for xxh32_update().
> > 
> > Just make these functions return void.
> > 
> > Cc: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > lib/xxhash.c doesn't actually have a maintainer, but probably it makes
> > sense to take this through the crypto tree, alongside the other patch I
> > sent to return void in lib/crypto/sha256.c.
> 
> Herbert, are you planning to apply this patch?

It looks like Chris Mason added this originally.  Chris, are you
OK with this patch and if so do you want to take it or shall I
push it through the crypto tree?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
