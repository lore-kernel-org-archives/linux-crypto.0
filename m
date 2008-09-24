From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Wed, 24 Sep 2008 21:00:34 +0400
Message-ID: <20080924170032.GA5190@2ka.mipt.ru>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de> <48DA6D7D.80705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dimitri Puzin <max@psycast.de>, linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:47329 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYIXRBe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2008 13:01:34 -0400
Content-Disposition: inline
In-Reply-To: <48DA6D7D.80705@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patrick.

On Wed, Sep 24, 2008 at 06:40:29PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> There are a few known problems left in the HIFN driver that I have
> patches for but unfortunately didn't manage to clean them up and
> submit them yet.
> 
> Looking at my queue, what's still broken is roughly:
> 
>    [HIFN]: Have HW invalidate src and dest descriptors after processing
>   
>    The descriptors need to be invalidated after processing for ring
>    cleanup to work properly and to avoid using an old destination
>    descriptor when the src and cmd descriptors are already set up
>    and the dst descriptor isn't.
>   
>    Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> That one is actually probably OK but I didn't send it upstream yet because
> I didn't finish all follow-up patches that depend on how this works.
> 
> Further:
> 
>    [HIFN]: Fix DMA setup
> 
> without a changelog :) IIRC the problem is that HIFN sets up each
> DMA descriptor for the full request length, even though it should
> only cover on SG entry. The result is memory corruption.

Can not tell without patch itself, but code operates on the number of
bytes provided from the higher levels, not full dma size (0x3ff bytes).

>    [HIFN]: Don't copy src sg list
> 
> also without a changelog. I think this one was just an optimization,
> the source descriptors don't have alignment or size restrictions and
> thus we don't need to linearize it first.

Also can not say for sure, but there should not be src linearization,
instead we copy data from src to aligned dst and then perform crypto
processin in place, and then copy data back.

>    [HIFN]: Fix request context corruption
>   
>    HIFN uses the transform context to store per-request data, which breaks
>    when more than one request is outstanding. Move per request members from
>    struct hifn_context to a new struct hifn_request_context and convert
>    the code to use this.

Its per-tfm, so things like key and iv are ok, and others should only be
accessed under the lock, but there may be problems.

> and:
>  
>    [HIFN]: Fix queue processing
> 
> again without a changelog. The problem this patch fixed was missing crypto
> backlog handling, causing crashes with dm_crypt under load.

Yup, that's messy :)

> If someone is interested in picking this up I could send my old patches,
> I probably won't manage to do it myself in the next time.

Please do, if they work for you, we can just apply them, but I would
like first to check them out.

Thank you!

-- 
	Evgeniy Polyakov
