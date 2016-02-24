From: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Wed, 24 Feb 2016 21:37:39 +0000
Message-ID: <56CE22A3.7030702@alliedtelesis.co.nz>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:55413 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbcBXVhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 16:37:48 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DBF4F8070D
	for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2016 10:37:41 +1300 (NZDT)
In-Reply-To: <20160218121915.GH316@gauss.secunet.com>
Content-Language: en-US
Content-ID: <486AFA2BC4F95D459DF6BD342144075E@atlnz.lc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19/02/16 01:19, Steffen Klassert wrote:
> On Thu, Feb 18, 2016 at 01:40:00AM +0000, Mark McKinstry wrote:
>> This patch fixes our issue, thanks. In our scenario the tunnel path MTU
>> now gets updated so that subsequent large packets sent over the tunnel
>> get fragmented correctly.
> I've applied this patch to the ipsec tree now.
> Thanks for testing!
I spoke too soon. Upon further testing with this patch we have found it 
causes
a skt buffer leak. This is problematic for us and can cause memory 
exhaustion in
one of our test scenarios that has an IPv4 IPsec tunnel over a PPP link. 
Also
the patch's -EMSGSIZE return value appears to be invalid because vti_xmit()
should be returning a type netdev_tx_t (NETDEV_TX_OK etc). It looks to 
me that
this patch should really be doing a goto tx_error rather than doing an early
return with -EMSGSIZE. This would result in the skt buffer being freed,
NETDEV_TX_OK being returned (thus indicating vti_xmit() "took care of 
packet"),
and the tx_errors counter being incremented (which seems like a reasonable
thing to do).

I think the original IPv6 patch probably has the same issues, and could be
causing a DOS attack vulnerability in recent Linux releases. If this patch's
code gets hit for every received packet then the box's memory will soon be
exhausted - e.g. a rogue device sends a stream of largish pkts through a box
with a vti interface, and ignores every ICMPV6_PKT_TOOBIG pkt sent back 
to it.
