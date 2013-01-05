From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Sat, 5 Jan 2013 17:14:13 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
 <20130105182556.87853b23jydihzk0@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:56301
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab3AEROT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2013 12:14:19 -0500
In-Reply-To: <20130105182556.87853b23jydihzk0@www.dalek.fi>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Jussi Kivilinna [mailto:jussi.kivilinna@mbnet.fi]
> Sent: Saturday, January 05, 2013 9:56 PM
> To: Garg Vakul-B16394
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
> parallel.
> 
> Quoting Vakul Garg <vakul@freescale.com>:
> 
> > This allows to test & run multiple parallel crypto ahash contexts.
> > Each of the test vector under the ahash speed test template is started
> > under a separate kthread.
> 
> Why you want to do this? 
 
In its current form, we cannot test multiple simultaneous crypto sessions with tcrypt.
Crypto offload hardware accelerators are usually capable of handling multiple session in parallel.
This patch allows to load such hardware.
Even if offload accelerators are not present, multiple crypto sessions can execute in parallel on Multicore.

> Does not this change make tcrypt give
> inconsistent results?
> 

Based on kernel scheduling of threads, this change can make tcrypt give varying results in different runs.
For consistent results, we can use existing synchronous mode crypto sessions.
