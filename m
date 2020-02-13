Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8556C352A3
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 05:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 821BB20873
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 05:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgBMFF5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 00:05:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36038 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgBMFF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 00:05:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j26hG-0002hc-Jz; Thu, 13 Feb 2020 13:05:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j26hE-0000t3-D0; Thu, 13 Feb 2020 13:05:52 +0800
Date:   Thu, 13 Feb 2020 13:05:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200213050552.b5fkkravjirsey5y@gondor.apana.org.au>
References: <20200206085442.GA5585@Red>
 <20200207065719.GA8284@sol.localdomain>
 <20200207104659.GA10979@Red>
 <20200208085713.ftuqxhatk6iioz7e@gondor.apana.org.au>
 <20200211192118.GA24059@Red>
 <20200212020628.7grnopgwm6shn3hi@gondor.apana.org.au>
 <20200212185749.GA9886@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212185749.GA9886@Red>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 07:57:49PM +0100, Corentin Labbe wrote:
>
> I just found the problem, it happen with ARM CE which has a bigger state_size (sha256_ce_state) of 4bytes.
> 
> Since my driver didnt use statesize at all, I detect this on cra_init() like this:
> if (algt->alg.hash.halg.statesize < crypto_ahash_statesize(op->fallback_tfm))
> 	algt->alg.hash.halg.statesize = crypto_ahash_statesize(op->fallback_tfm);

Thanks for finding this.

I think this can be fixed by simply adding export/imort functions
that exported the sha state without the extra finalize field which
is never used for the exported state (it's only used as an internal
function parameter).

We should also add some tests to ensure that shash SHA algorithms
all use the same geometry for export/import.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
