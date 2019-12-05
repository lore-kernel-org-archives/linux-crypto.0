Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006ABC2D0BF
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4C9E2245C
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfLEE1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 23:27:10 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50956 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbfLEE1K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 23:27:10 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1icijM-0007Cz-Tg; Thu, 05 Dec 2019 12:27:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1icijM-0007VK-4x; Thu, 05 Dec 2019 12:27:08 +0800
Date:   Thu, 5 Dec 2019 12:27:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v3 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191205042708.m2b2zimzzikfemif@gondor.apana.org.au>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
 <20191205040442.GB1158@sol.localdomain>
 <20191205042357.ycvn5lwyu7yksafq@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205042357.ycvn5lwyu7yksafq@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 05, 2019 at 12:23:57PM +0800, Herbert Xu wrote:
> On Wed, Dec 04, 2019 at 08:04:42PM -0800, Eric Biggers wrote:
> >
> > This logic doesn't make sense to me either.  It's supposed to be looking for a
> > "test larval", not a "request larval", right?  But it seems that larval->mask is
> > always 0 for "test larvals", so the flags check will never do anything...
> 
> No we only care about request larvals.  Test larvals always have
> a non-null adult set so they are irrelevant.

Scratch that.  You're right we only care about test larvals and
if we wanted to check the flags we need to drill down to the
actual tested algorithm using larval->adult.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
