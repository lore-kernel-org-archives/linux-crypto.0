Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9068CC64EC4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Mar 2023 03:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCHDqa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Mar 2023 22:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCHDq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2023 22:46:29 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2682E4487;
        Tue,  7 Mar 2023 19:46:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pZkkk-001YTl-Tm; Wed, 08 Mar 2023 11:46:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Mar 2023 11:46:10 +0800
Date:   Wed, 8 Mar 2023 11:46:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     lionel.debieve@foss.st.com
Cc:     'Linus Walleij' <linus.walleij@linaro.org>,
        'Li kunyu' <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v6 PATCH 0/7] crypto: stm32 - Save and restore between each
 request
Message-ID: <ZAgFAtrp3ptq9Ym7@gondor.apana.org.au>
References: <Y/3FYZJeLE7DVPBf@gondor.apana.org.au>
 <Y/3IA4OjmUmjMgh1@gondor.apana.org.au>
 <Y/3N6zFOZeehJQ/p@gondor.apana.org.au>
 <CACRpkdZ3rCsOWqooNkPL6m7vZ2Z2Frh2sdxruKhrS0t3QHcSKw@mail.gmail.com>
 <Y/6sCC2nH0FcD6kJ@gondor.apana.org.au>
 <CACRpkdYN-SDfxXKLt3HWGVkWb3V1rABwvWuytwDrzfTqm81fNA@mail.gmail.com>
 <ZAA8doNUjYmTRScB@gondor.apana.org.au>
 <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
 <ZAVu/XHbL9IR5D3h@gondor.apana.org.au>
 <009901d950fc$7e0f68a0$7a2e39e0$@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009901d950fc$7e0f68a0$7a2e39e0$@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 07, 2023 at 02:55:29PM +0100, lionel.debieve@foss.st.com wrote:
>
> The issue about the context management relies on a question I've get time to
> ask you. There is no internal test purpose (using test manager) that really
> show the need of a hash update that needs to be "self-content". We've seen

Indeed this functionality is sorely missed.  It shouldn't be hard
to implement, because simply hashing two different requests
interleaved with each other should show the problem:

init(A) => update(A) => init(B) => update(B) => final(A) => final(B)

> the issue using openssl use cases that is not using import/export.
> I'm wondering to understand the real need of import/export in the framework
> if the request must be safe itself?

The hash state is normally stored in the request context.  The
import/export functions let you save a copy of the state for
subsequent processing.  The request could then be freed after
the export and re-allocated prior to import, or in other contexts
the request could be reused for a completely different hash in
the time being (init/update/final).

> >From hardware point of view, it is a penalty to wait for completion to save
> the context after each request. I understand the need of multiple hash
> request in // but I was wondering that it can be managed by the
> import/export, but it seems I was wrong. The penalty of the context saving
> will impact all hash requests where, in a runtime context is probably not
> the most important use case.

Oh of course we try to avoid unnecessary savings/restoring as much
as we can.  That's why we encourage users to use finup/digest as
much as possible, in which case there may be be no need to save and
restore at all.

However, if the user has to do a partial update through the update
function, then we have to save the state.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
