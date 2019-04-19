Return-Path: <SRS0=LFue=SV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE76C282DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FF120449
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfDSSiH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:38:07 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38234 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728396AbfDSSiC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Apr 2019 14:38:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hHMS7-00041y-0N; Fri, 19 Apr 2019 13:52:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hHMS2-0005E8-LE; Fri, 19 Apr 2019 13:52:42 +0800
Date:   Fri, 19 Apr 2019 13:52:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 5/7] crypto: gcm - fix incompatibility between "gcm"
 and "gcm_base"
Message-ID: <20190419055242.xxctizd4g4ggv432@gondor.apana.org.au>
References: <20190410064635.11813-6-ebiggers@kernel.org>
 <20190418140006.x3aaja7vvntu6p5p@gondor.apana.org.au>
 <20190418184145.GB1827@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418184145.GB1827@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 11:41:46AM -0700, Eric Biggers wrote:
>
> I'm not necessarily opposed to doing this, but if we're assuming that untested,
> arbitrarily broken algorithms may be registered with the crypto API under any
> name, "ghash" could easily still be broken even if it declares a 16-byte digest
> size.  Verifying the digest size is just an extra sanity check; we're really
> still relying on the implementation to be correct.  (Same for the ccm patch.)

The check is not so much for the purpose of producing the correct
output for the given algorithm, since as you correctly stated that
would rely on the correctness of the underlying algorithm.  It is
more about not crashing when the underlying algorithm has a geometry
that is completely different (e.g., by overwriting the digest
buffer).

Come to think of it, perhaps we should check the geometry of
algorithms even when self-tests are compiled out.  That way these
checks could be replaced by a simple name check.

This would be good anyway because the self-tests may indeed crash
if an algorithm with an incorrect geometry is used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
