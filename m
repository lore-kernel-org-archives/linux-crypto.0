From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] crypto: talitos: Avoid excessive loops in softirq context
Date: Fri, 12 Sep 2014 09:39:12 +0200
Message-ID: <CAGXE3d-EiYmJQfEwS9VeR3-5vePNzc2+N20hQTw0vY8FKhJYRA@mail.gmail.com>
References: <1410338087-5317-1-git-send-email-helmut.schaa@googlemail.com>
	<20140911194918.9ea4795f7bb3f9d6e32490eb@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34435 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaILHjM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Sep 2014 03:39:12 -0400
Received: by mail-ie0-f176.google.com with SMTP id ar1so400689iec.7
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2014 00:39:12 -0700 (PDT)
In-Reply-To: <20140911194918.9ea4795f7bb3f9d6e32490eb@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 12, 2014 at 2:49 AM, Kim Phillips
<kim.phillips@freescale.com> wrote:
> On Wed, 10 Sep 2014 10:34:47 +0200
> Helmut Schaa <helmut.schaa@googlemail.com> wrote:
>
>> The talitos driver can cause starvation of other softirqs and as such
>> it can also cause rcu stalls like:
> ...
>> Work around this by processing a maximum amount of 16 finished requests
>> and rescheduling the done-tasklet if any work is left.
>> This allows other softirqs to run.
>
> 16 sounds rather arbitrary, and application-dependent - talitos'
> FIFO size is 24.

Yep, 16 is arbitrary, I can also do "fifo_len" if you prefer?

> IIRC, netdev's NAPI can be refactored out of just being able to work
> on network devices, and be made to apply to crypto devices, too.  In
> fact, some old Freescale hacks of this nature have improved
> performance.  Can we do something like refactor NAPI instead?

That would indeed be nice but sounds like quite some more work and
I won't have time to do so. Especially since my system was taken down
completely by the talitos tasklet under some circumstances. If there is
any work going on in that regard I'd be fine with just dropping that patch
(and carrying it myself until the refactoring is done).

Regards,
Helmut
