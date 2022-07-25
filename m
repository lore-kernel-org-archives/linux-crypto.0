Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E41BC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiGYXGR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 19:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiGYXGQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 19:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9D213F23
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E816142E
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 23:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD52AC341C6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 23:06:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=libc.org header.i=@libc.org header.b="NhjeFJF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libc.org; s=20210105;
        t=1658790372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SB4KTdSkXPi/bTr8S5rSUPOkMtDOp8QOMJ8QIRrQICw=;
        b=NhjeFJF4B46cavCCuslhSwuS0htf+zuiox6jVZfkzsGEqSZ3uurYk0rjX4wspgPyLCeDpS
        PDbEyTtG5GvM2M/8cLISmLh3dZ9GWW+MGXreYTHu1DSpec89X+tVeuGDwgOijTZhkVA6gk
        bKqzrv6Sfy8KlqNMUfeYgon9H3laWgE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f0920b05 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 23:06:12 +0000 (UTC)
Date:   Mon, 25 Jul 2022 13:44:30 -0400
From:   Rich Felker <dalias@libc.org>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Michael@phoronix.com, jann@thejh.net, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220725174430.GI7074@brightrain.aerifal.cx>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rohp2ll.fsf@oldenburg.str.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 06:40:54PM +0200, Florian Weimer via Libc-alpha wrote:
> * Rich Felker:
> 
> > On Sat, Jul 23, 2022 at 02:39:29PM -0300, Adhemerval Zanella Netto via Libc-alpha wrote:
> >> On 23/07/22 13:25, Jason A. Donenfeld wrote:
> >> > Firstly, for what use cases does this actually help? As of recent
> >> > changes to the Linux kernels -- now backported all the way to 4.9! --
> >> > getrandom() and /dev/urandom are extremely fast and operate over per-cpu
> >> > states locklessly. Sure you avoid a syscall by doing that in userspace,
> >> > but does it really matter? Who exactly benefits from this?
> >> 
> >> Mainly performance, since glibc both export getrandom and getentropy. 
> >> There were some discussion on maillist and we also decided to explicit
> >> state this is not a CSRNG on our documentation.
> >
> > This is an extreme documentation/specification bug that *hurts*
> > portability and security. The core contract of the historical
> > arc4random function is that it *is* a CSPRNG. Having a function by
> > that name that's allowed not to be one means now all software using it
> > has to add detection for the broken glibc variant.
> >
> > If the glibc implementation has flaws that actually make it not a
> > CSPRNG, this absolutely needs to be fixed. Not doing so is
> > irresponsible and will set everyone back a long ways.
> 
> The core issue is that on some kernels/architectures, reading from
> /dev/urandom can degrade to GRND_INSECURE (approximately), and while the
> result is likely still unpredictable, not everyone would label that as a
> CSPRNG.

Then don't fallback to /dev/urandom. It's not even a failsafe fallback
anyway (ENFILE, EMFILE, sandboxes, etc.) so it can't safely be used
here. Instead use SYS_sysctl and poll for entropy_avail, looping until
it's ready. AFAICT this works reliably on all kernels as far back as
glibc supports (assuming nothing idiotic like intentionally patching
or configuring out random support, but then it's PEBKAC error, as no
distros did this).

Rich
