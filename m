From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] Crypto: Add SHA-3 hash algorithm
Date: Thu, 16 Jun 2016 18:24:20 +0200
Message-ID: <1469618.GoqEiobQFD@positron.chronox.de>
References: <1465983719-8313-1-git-send-email-raveendra.padasalagi@broadcom.com> <1704146.ryraC2p2Bb@tauon.atsec.com> <CAAFb_vqubPdy4g0NsM02JaUN-YL8V17kYbVMHWSTv9CByZ3XRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
	Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36680 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbcFPQY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 12:24:28 -0400
In-Reply-To: <CAAFb_vqubPdy4g0NsM02JaUN-YL8V17kYbVMHWSTv9CByZ3XRA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. Juni 2016, 21:39:17 schrieb Raveendra Padasalagi:

Hi Raveendra,

> I need some clarification to address your comment
> 
> "Shouldn't there be a priority here?"
> 
> What I know regarding priority value for an algorithm
> is higher the priority value it will be get selected for execution.
> 
> For example, let's say for software implementation of the algorithm if
> priority value
> is specified as 100 and hardware driver implementation of the same
> algorithm uses
> the priority value of 300 then hardware algo is what selected for execution.
> 
> I just had a look at priority value specified for other hash
> algorithm's and none of the
> software implementation specify any value, So it will be 0.
> 
> I think it's okay to not to specify any priority value for software
> implementation,
> as hardware implementation can use non zero value if it needs higher
> priority.
> 
> What's your opinion ?

You are fully correct.

To be in line with the other hashes, maybe let us leave it at 0. I was 
thinking about "backend" ciphers that should never ever be selected (like the 
Intel AES-NI examples) which should have a lower prio than any other cipher. 
But then, they have unique cra_names, so it does not really matter :-)

Ciao
Stephan
