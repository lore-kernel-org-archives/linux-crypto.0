Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C08C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F892074B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgG2G26 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:28:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58584 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgG2G26 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 02:28:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0faA-0003nK-KV; Wed, 29 Jul 2020 16:28:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Jul 2020 16:28:54 +1000
Date:   Wed, 29 Jul 2020 16:28:54 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v3 PATCH 12/31] crypto: arm64/chacha - Add support for chaining
Message-ID: <20200729062854.GA9013@gondor.apana.org.au>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0JtB-0006Np-A3@fornost.hmeau.com>
 <CAMj1kXFj9-+LCbrLT3VSY_nq3MsyRigFhBEkf9BCosH-UJ+YsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFj9-+LCbrLT3VSY_nq3MsyRigFhBEkf9BCosH-UJ+YsQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 29, 2020 at 09:16:55AM +0300, Ard Biesheuvel wrote:
>
> Only state[12] needs to be preserved, since it contains the block
> counter. Everything else in the state can be derived from the IV.
> 
> So by doing the init unconditionally, and overriding state[12] to the
> captured value (if it exists), we can get rid of the redundant copy of
> state, which also avoids inconsistencies if IV and state are out of
> sync.

Good point.  In fact we could try to put the counter back into
the IV just like CTR.  Let me have a play with this to see what
it would look like.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
