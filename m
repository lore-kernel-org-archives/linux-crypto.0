Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A544C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367742071F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfKVOIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:08:00 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37828 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVOIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 09:08:00 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY9bL-00028J-1W; Fri, 22 Nov 2019 22:07:59 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY9bJ-0002zv-Kp; Fri, 22 Nov 2019 22:07:57 +0800
Date:   Fri, 22 Nov 2019 22:07:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH 2/3] s390/crypto: Rework on paes implementation
Message-ID: <20191122140757.mbpnasimvnhke3k2@gondor.apana.org.au>
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-3-freude@linux.ibm.com>
 <20191122081338.6bdjevtyttpdzzwl@gondor.apana.org.au>
 <87e9dbee-4024-602c-7717-051df3ac644d@linux.ibm.com>
 <20191122104259.ofodwadrgszdxuto@gondor.apana.org.au>
 <bd21bf85-7bfc-afd6-270b-272bd0fa553a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd21bf85-7bfc-afd6-270b-272bd0fa553a@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 22, 2019 at 02:38:30PM +0100, Harald Freudenberger wrote:
>
> The pkey is in fact a encrypted key + a verification pattern for the
> encrypted key used. It gets invalid when this encryption key changes.
> The encryption key changes when the LPAR is re-activated so for
> example on suspend/resume or an Linux running as kvm guest
> gets relocated. So this happens very rarely.

I see.  Is there any way of you finding out that the key has been
invalidated apart from trying out the crypto and having it fail?

Ideally you'd have a global counter that gets incremented everytime
an invalidation occurs.  You can then regenerate your key if its
generation counter differs from the current global counter.

Also when the crypto fails due to an invalid key you're currently
calling skcipher_walk_done with zero.  This is wrong as the done
function must be called with a positive value or an error.  In
some cases this can cause a crash in scatterwalk.

IOW you should just repeat the crypto operation after regenerating
the key rather than looping around again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
