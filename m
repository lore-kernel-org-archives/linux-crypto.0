From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Wed, 9 Jan 2013 15:45:52 -0600
Message-ID: <20130109154552.4163137574bb7de915017e21@freescale.com>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
	<20130105182556.87853b23jydihzk0@www.dalek.fi>
	<065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Garg Vakul-B16394 <B16394@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:59171
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab3AIVtD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jan 2013 16:49:03 -0500
In-Reply-To: <065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 5 Jan 2013 17:14:13 +0000
Garg Vakul-B16394 <B16394@freescale.com> wrote:

> > From: Jussi Kivilinna [mailto:jussi.kivilinna@mbnet.fi]
> > Sent: Saturday, January 05, 2013 9:56 PM
> > 
> > Quoting Vakul Garg <vakul@freescale.com>:
> > 
> > > This allows to test & run multiple parallel crypto ahash contexts.
> > > Each of the test vector under the ahash speed test template is started
> > > under a separate kthread.
> > 
> > Why you want to do this? 
>  
> In its current form, we cannot test multiple simultaneous crypto sessions with tcrypt.
> Crypto offload hardware accelerators are usually capable of handling multiple session in parallel.
> This patch allows to load such hardware.

tcrypt can currently test offload engines with multiple
single-session async requests.  So to test multiple _session_
requests, why isn't the change to tcrypt simply to alternate keys
in the request loop, as opposed to what this patch does, i.e.
adding separate kthreads?  The number of sessions/keys to alternate
can be added as a module parameter.

> Even if offload accelerators are not present, multiple crypto sessions can execute in parallel on Multicore.

I think that's more in the area of PCRYPT.

> > Does not this change make tcrypt give
> > inconsistent results?
> > 
> 
> Based on kernel scheduling of threads, this change can make tcrypt give varying results in different runs.
> For consistent results, we can use existing synchronous mode crypto sessions.

see above.  I'm not sure, but I think multithreading tcrypt should
be left to the parallel crypto engine (PCRYPT) and Software async
crypto daemon (CRYPTD).

Kim
