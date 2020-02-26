Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602BBC4BA24
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 22:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F00F21D7E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582755465;
	bh=cs+KD5MTlL+9h4Tj3lAJWI9MH0tgnD0DmNQnuZrw/9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BkrVkbIKE8D1RSFBEnpVnnxslKHj7FZbc3XRJDBJeAx1VZdPnrWKJYOKtF10P0vpG
	 GQs5//NgltKsEVhjQo6JIAc5eS0fa0zopnJwyS5Bz5qs8TScZWocZrp71IymM5k0bj
	 zig0TEOQIRZus3oi0q56bfEdoX0eXQv/nbu9xtzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBZWRo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbgBZWRo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 17:17:44 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7702072D;
        Wed, 26 Feb 2020 22:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582755463;
        bh=cs+KD5MTlL+9h4Tj3lAJWI9MH0tgnD0DmNQnuZrw/9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAebMMviU1D71LPXnPss901gxpWeddvg5oFWeaWscNgSXKScZnKkl2Dw9x39ynyOG
         QmpkTRir9i88Bu7uB45IQ0SkYdFKHAzxqgQy4R6/Mi0MFma4i1a/cj2K591KSfyOgG
         mCSzF8p+g5KzQHhHWKmt7G6rV/26BKVg8kbF6Tk8=
Date:   Wed, 26 Feb 2020 14:17:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] crypto: testmgr - use generic algs making test vecs
Message-ID: <20200226221742.GA135806@gmail.com>
References: <20200225154834.25108-1-gilad@benyossef.com>
 <20200225154834.25108-2-gilad@benyossef.com>
 <20200225194551.GA114977@gmail.com>
 <CAOtvUMeWB=MiYfzkrPjOctOufKJ8Q81E3m6bq8GJY-enbG6Qjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMeWB=MiYfzkrPjOctOufKJ8Q81E3m6bq8GJY-enbG6Qjg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 26, 2020 at 04:42:45PM +0200, Gilad Ben-Yossef wrote:
> 
> The impetus to write this patch came from my experience debugging a
> test failure with the ccree driver.
> At some point while tweaking around I got into a situation where the
> test was succeeding (that is, declaring the message inauthentic) not
> because the mutation was being detected but because the generation of
> the origin was producing a bogus ICV.

That's being fixed by your patch 2/2 though, right?

> At that point it seemed to me that it would be safer to "isolate" the
> original AEAD messages generation from the code that was being teste.
> 
> > We could also just move test_aead_inauthentic_inputs() to below
> > test_aead_vs_generic_impl() so that it runs last.
> 
> This would probably be better, although I think that this stage also
> generates inauthentic messages from time to time, no?

That's correct, but in test_aead_vs_generic_impl() the generic implementation is
used to generate the test vectors.

> At any rate, I don't have strong feelings about it either way. I defer
> to your judgment whether it is worth it to add a fallback to use the
> same implementation and fix what needs fixing or drop the patch
> altogether if you think this isn't worth the trouble - just let me
> know.

I just want to avoid adding complexity that isn't worthwhile.
Beyond your patch 2, how about we just do:

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 79b431545249a9..2ab48d4d317250 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2564,11 +2564,11 @@ static int test_aead_extra(const char *driver,
 		goto out;
 	}
 
-	err = test_aead_inauthentic_inputs(ctx);
+	err = test_aead_vs_generic_impl(ctx);
 	if (err)
 		goto out;
 
-	err = test_aead_vs_generic_impl(ctx);
+	err = test_aead_inauthentic_inputs(ctx);
 out:
 	kfree(ctx->vec.key);
 	kfree(ctx->vec.iv);


Then the dedicated tests for inauthentic inputs wouldn't be run until the fuzz
tests vs. generic have already passed.

- Eric
