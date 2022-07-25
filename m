Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23633C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiGYQvo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiGYQvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9F91D0CD
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE2F61335
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42F2C341CE;
        Mon, 25 Jul 2022 16:51:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mDLPBw1G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658767899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=22CxmZdXpJu6JrRTMoV2Dy7SVbqDOus6U00qu/Ti6MM=;
        b=mDLPBw1GzW175CQRiaKqG9jEQqy4BuRSVkd22sDkRytDhgal6JQepY12lSdB9xUunNpITI
        UJfc8mJ2bFdXcCx/sKX4FUti53jzAD/ZpIz/xop8AQyTEH9zaglVh/LiJ/x0ue0XADGUnm
        yhZv51h2c1iZDZ845Bd5ug4UlxtRJRg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cb71a268 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 16:51:38 +0000 (UTC)
Date:   Mon, 25 Jul 2022 18:51:36 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Rich Felker <dalias@libc.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        libc-alpha@sourceware.org, Yann Droneaud <ydroneaud@opteya.com>,
        jann@thejh.net, Michael@phoronix.com,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt7KGOgV7JfPUtol@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <878rohp2ll.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Florian,

On Mon, Jul 25, 2022 at 06:40:54PM +0200, Florian Weimer wrote:
> The core issue is that on some kernels/architectures, reading from
> /dev/urandom can degrade to GRND_INSECURE (approximately), and while the
> result is likely still unpredictable, not everyone would label that as a
> CSPRNG.

On some old kernels (though I think not all?), you can poll on
/dev/random. This isn't perfect, as the ancient "non blocking pool"
initialized after the "blocking pool", but it's not too imperfect
either. Take a look at the previously linked random-util.c.

> If we document arc4random as a CSPRNG, this means that we would have to
> ditch the fallback code and abort the process if the getrandom system
> call is not available: when reading from /dev/urandom as a fallback, we
> have no way of knowing if we are in any of the impacted execution
> environments.  Based on your other comments, it seems that you are
> interested in such fallbacks, too, but I don't think you can actually
> have both (CSPRNG + fallback).
> 
> And then there is the certification issue.  We really want applications
> that already use OpenSSL for other cryptography to use RAND_bytes
> instead of arc4random.  Likewise for GNUTLS and gnutls_rnd.  What should
> authors of those cryptographic libraries?  That's less clear, and really
> depends on the constraints they operate in (e.g., they may target only a
> subset of architectures and kernel versions).

I think all of this is yet another indication that there are some major
things to work out -- should we block or not? is buffering safe? is the
interface correct? -- and so we should just back out the arc4random
commit until this has been explored a bit more. We're not gaining
anything from rushing this, especially as a "source code compatibility"
thing, if there's not even agreement between OSes on what the function
does inside.

Jason

PS: please try to keep linux-crypto@vger.kernel.org CC'd. I've been
bouncing these manually when not, but it's hard to keep up with that.
