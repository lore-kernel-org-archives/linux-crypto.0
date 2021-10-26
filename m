Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61335C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A61D60F46
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhJZIib (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 04:38:31 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:33879 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhJZIib (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 04:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635237186;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DNWzDFjYlq2z1lfo6feM5SnahPemPY53FnBM9PiiNoQ=;
    b=Fuk/CG4k2vVUlZ0s3+R7E9n2BDulVJ9IF6n6DJYCqAsUf7o1AgJYQbx2cuERaZU2eN
    S+kjHJpG7Yxkor5AG2JXzUoMI3E97EKk7OcR0nZ8Nvm+/VGek3e5JItsOF6B5kDy+MIT
    7pZcEqTiVxTupdzX//Ga2SkMb+vVOoIp6UuOs6PSPGZo50SL8lg1kV9N8QOjwKTIQ6SL
    3IVuT07YO1gOg3DHB7l2VjcFAc8z9r8MDjv4Fci66nY7o1Fg9QPOUN2svgNiPPrXaRvl
    EfW1QHhmIcX7hScHsSCidlq47Diw4pKxtLzF1nWxmo7Zu49pAxcJJxzY+OeNtY8JIyw3
    8rkg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q8X51ym
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 10:33:05 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/6] crypto: DRBG - improve 'nopr' reseeding
Date:   Tue, 26 Oct 2021 10:33:05 +0200
Message-ID: <2120606.3HGXcN3vsr@positron.chronox.de>
In-Reply-To: <20211025092525.12805-1-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:19 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Hi all,
> 
> this patchset aims at (hopefully) improving the DRBG code related to
> reseeding from get_random_bytes() a bit:

Thanks for sharing your patches.

> - Replace the asynchronous random_ready_callback based DRBG reseeding
>   logic with a synchronous solution leveraging rng_is_initialized().

Could you please help me why replacing an async method with a sync method is 
helpful? Which problems do you see with the async method that are alleviated 
with the swtich to the sync method? In general, an async method is more 
powerful, though it requires a bit more code.

>   This
>   move simplifies the code IMO and, as a side-effect, would enable DRBG
>   users to rely on wait_for_random_bytes() to sync properly with
>   drbg_generate(), if desired. Implemented by patches 1-5/6.
> - Make the 'nopr' DRBGs to reseed themselves every 5min from
>   get_random_bytes(). This achieves at least kind of a partial prediction
>   resistance over the time domain at almost no extra cost. Implemented
>   by patch 6/6, the preceding patches in this series are a prerequisite
>   for this.

Just as a side note not against your ideas and patches, but in general: IMHO 
it is a failure of all of us that the quite sensitive (re)seeding of RNGs and 
entropy management is handled in multiple places in the kernel - and each case 
only handles a subset of considerations around that topic. Note, (re)seeding 
may be needed in other occasions than the elapse of a timer or the reaching of 
maximum number of generate operations. Seeding belongs to a central place 
where it is done right once and usable for differnent RNGs as proposed with my 
LRNG patch set and the published todo list to get rid of the entire seeding 
logic in the DRBG code base.

That said, your patch of adding the timer-based reseeding seems appropriate 
and thus should be considered for the current code base.

Ciao
Stephan


