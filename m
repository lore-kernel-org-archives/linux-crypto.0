From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Thu, 18 Feb 2016 13:19:16 +0100
Message-ID: <20160218121915.GH316@gauss.secunet.com>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:36593 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426301AbcBRMTV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2016 07:19:21 -0500
Content-Disposition: inline
In-Reply-To: <56C520F0.4050309@alliedtelesis.co.nz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 18, 2016 at 01:40:00AM +0000, Mark McKinstry wrote:
> This patch fixes our issue, thanks. In our scenario the tunnel path MTU 
> now gets updated so that subsequent large packets sent over the tunnel 
> get fragmented correctly.

I've applied this patch to the ipsec tree now.
Thanks for testing!
