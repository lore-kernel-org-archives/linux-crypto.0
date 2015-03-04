From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 3/5] crypto: talitos: Fix off-by-one and use all
 hardware slots
Date: Tue, 3 Mar 2015 18:35:31 -0600
Message-ID: <20150303183531.312a8d332b1b776764a15a47@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-4-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
	Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:48843
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754161AbbCDAku (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 19:40:50 -0500
In-Reply-To: <1425388897-5434-4-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue,  3 Mar 2015 08:21:35 -0500
Martin Hicks <mort@bork.org> wrote:

> The submission count was off by one.
> 
> Signed-off-by: Martin Hicks <mort@bork.org>
> ---
sadly, this directly contradicts:

commit 4b24ea971a93f5d0bec34bf7bfd0939f70cfaae6
Author: Vishnu Suresh <Vishnu@freescale.com>
Date:   Mon Oct 20 21:06:18 2008 +0800

    crypto: talitos - Preempt overflow interrupts off-by-one fix

My guess is your request submission pattern differs from that of
Vishnu's (probably IPSec and/or tcrypt), or later h/w versions have
gotten better about dealing with channel near-overflow conditions.
Either way, I'd prefer we not do this: it might break others, and
I'm guessing doesn't improve performance _that_ much?

If it does, we could risk it and restrict it to SEC versions 3.3 and
above maybe?  Not sure what to do here exactly, barring digging up
and old 2.x SEC and testing.

Kim

p.s. I checked, Vishnu isn't with Freescale anymore, so I can't
cc him.
