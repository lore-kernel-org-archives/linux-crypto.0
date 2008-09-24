From: Patrick McHardy <kaber@trash.net>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Wed, 24 Sep 2008 18:40:29 +0200
Message-ID: <48DA6D7D.80705@trash.net>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
To: Dimitri Puzin <max@psycast.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41979 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYIXQkz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2008 12:40:55 -0400
In-Reply-To: <48D93028.20903@psycast.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitri Puzin wrote:
> With this patch applied it still doesn't work as expected. The overflow
> messages are gone however syslog shows
> [  120.924266] hifn0: abort: c: 0, s: 1, d: 0, r: 0.
> when doing cryptsetup luksFormat as in original e-mail. At this point
> cryptsetup hangs and can't be killed with -SIGKILL. I've attached
> SysRq-t dump of this condition.

There are a few known problems left in the HIFN driver that I have
patches for but unfortunately didn't manage to clean them up and
submit them yet.

Looking at my queue, what's still broken is roughly:

    [HIFN]: Have HW invalidate src and dest descriptors after processing
   
    The descriptors need to be invalidated after processing for ring
    cleanup to work properly and to avoid using an old destination
    descriptor when the src and cmd descriptors are already set up
    and the dst descriptor isn't.
   
    Signed-off-by: Patrick McHardy <kaber@trash.net>

That one is actually probably OK but I didn't send it upstream yet because
I didn't finish all follow-up patches that depend on how this works.

Further:

    [HIFN]: Fix DMA setup

without a changelog :) IIRC the problem is that HIFN sets up each
DMA descriptor for the full request length, even though it should
only cover on SG entry. The result is memory corruption.

    [HIFN]: Don't copy src sg list

also without a changelog. I think this one was just an optimization,
the source descriptors don't have alignment or size restrictions and
thus we don't need to linearize it first.

    [HIFN]: Fix request context corruption
   
    HIFN uses the transform context to store per-request data, which breaks
    when more than one request is outstanding. Move per request members from
    struct hifn_context to a new struct hifn_request_context and convert
    the code to use this.

and:
  
    [HIFN]: Fix queue processing

again without a changelog. The problem this patch fixed was missing crypto
backlog handling, causing crashes with dm_crypt under load.

If someone is interested in picking this up I could send my old patches,
I probably won't manage to do it myself in the next time.

