From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Thu, 25 Feb 2016 12:21:42 +0100
Message-ID: <20160225112142.GO316@gauss.secunet.com>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:58444 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbcBYLVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2016 06:21:46 -0500
Content-Disposition: inline
In-Reply-To: <56CE22A3.7030702@alliedtelesis.co.nz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 24, 2016 at 09:37:39PM +0000, Mark McKinstry wrote:
> On 19/02/16 01:19, Steffen Klassert wrote:
> > On Thu, Feb 18, 2016 at 01:40:00AM +0000, Mark McKinstry wrote:
> >> This patch fixes our issue, thanks. In our scenario the tunnel path MTU
> >> now gets updated so that subsequent large packets sent over the tunnel
> >> get fragmented correctly.
> > I've applied this patch to the ipsec tree now.
> > Thanks for testing!
> I spoke too soon. Upon further testing with this patch we have found it 
> causes
> a skt buffer leak. This is problematic for us and can cause memory 
> exhaustion in
> one of our test scenarios that has an IPv4 IPsec tunnel over a PPP link. 
> Also
> the patch's -EMSGSIZE return value appears to be invalid because vti_xmit()
> should be returning a type netdev_tx_t (NETDEV_TX_OK etc). It looks to 
> me that
> this patch should really be doing a goto tx_error rather than doing an early
> return with -EMSGSIZE. This would result in the skt buffer being freed,
> NETDEV_TX_OK being returned (thus indicating vti_xmit() "took care of 
> packet"),
> and the tx_errors counter being incremented (which seems like a reasonable
> thing to do).

Yes, you are right here. 

> 
> I think the original IPv6 patch probably has the same issues, and could be
> causing a DOS attack vulnerability in recent Linux releases.

We need to fix both, ipv4 and ipv6. I'll care for it,
thanks for the report.
