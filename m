From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree
 binding for ERA information."
Date: Thu, 13 Dec 2012 04:04:37 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B94141389@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1354870649-3656-1-git-send-email-vakul@freescale.com>
 <C38A27FC-51EF-44F3-8474-33162DE1A272@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37972 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab2LMEEm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2012 23:04:42 -0500
In-Reply-To: <C38A27FC-51EF-44F3-8474-33162DE1A272@kernel.crashing.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Kumar

This has been applied to: 

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.

Regards

Vakul

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, December 13, 2012 3:00 AM
> To: Garg Vakul-B16394
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@ozlabs.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: Re: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree
> binding for ERA information."
> 
> 
> On Dec 7, 2012, at 2:57 AM, Vakul Garg wrote:
> 
> > This reverts commit a2c0911c09190125f52c9941b9d187f601c2f7be.
> >
> > Signed-off-by: Vakul Garg <vakul@freescale.com>
> > ---
> > Instead of adding SEC era information in crypto node's compatible, a
> > new property 'fsl,sec-era' is being introduced into crypto node.
> >
> > .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 ++---
> > 1 files changed, 2 insertions(+), 3 deletions(-)
> 
> What tree do you think this has been applied to?
> 
> - k
