From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Sat, 19 Jan 2013 15:01:19 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B94161931@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
 <20130105182556.87853b23jydihzk0@www.dalek.fi>
 <065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130119015457.1386129jh3k4firk@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:43782
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab3ASPB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 10:01:27 -0500
In-Reply-To: <20130119015457.1386129jh3k4firk@www.dalek.fi>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Jussi Kivilinna [mailto:jussi.kivilinna@mbnet.fi]
> Sent: Saturday, January 19, 2013 5:25 AM
> To: Garg Vakul-B16394
> Cc: linux-crypto@vger.kernel.org
> Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
> parallel.
> 
> Quoting Garg Vakul-B16394 <B16394@freescale.com>:
> 
> >
> >> Does not this change make tcrypt give inconsistent results?
> >>
> >
> > Based on kernel scheduling of threads, this change can make tcrypt
> > give varying results in different runs.
> > For consistent results, we can use existing synchronous mode crypto
> sessions.
> 
> But one cannot get consistent results for asynchronous software
> implementations after this patch.

Should we launch threads optionally based on module argument (in both synchronous and async mode)?
This would preserve existing tcrypt behavior.
 

> 
> -Jussi
> 
> 
