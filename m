From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Fri, 1 Apr 2016 10:08:16 +0200
Message-ID: <20160401080815.GJ3347@gauss.secunet.com>
References: <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
 <20160304070525.GA3347@gauss.secunet.com>
 <56E73285.5000702@alliedtelesis.co.nz>
 <20160315122801.GB3347@gauss.secunet.com>
 <20160322105318.GS3347@gauss.secunet.com>
 <56FC3F3D.2000408@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:43289 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbcDAIIV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Apr 2016 04:08:21 -0400
Content-Disposition: inline
In-Reply-To: <56FC3F3D.2000408@alliedtelesis.co.nz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 30, 2016 at 09:04:03PM +0000, Mark McKinstry wrote:
> I've tested this patch in our scenario and I can confirm that it still 
> fixes all of our issues.

I've applied the patch to the ipsec tree now.
Thanks for testing!
