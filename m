From: Octavian Purdila <opurdila@ixiacom.com>
Subject: Re: ESP hardware acceleration
Date: Tue, 15 Sep 2009 17:54:15 +0300
Message-ID: <200909151754.15716.opurdila@ixiacom.com>
References: <4AAF945F.8060501@siganos.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Alex Badea <abadea@ixiacom.com>,
	ddogaru@ixiacom.com
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:5691 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754370AbZIOO4p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 10:56:45 -0400
In-Reply-To: <4AAF945F.8060501@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 15 September 2009 16:19:27 you wrote:
> Hi,
> 
> We are using linux-2.6.28 and we would like to hardware accelerate the
> NETKEY IPsec traffic. We are using strongswan for the upper layers.
> 
> I understand that strongswan uses the Linux/NETKEY IPsec implementation,
> which in turn, uses the Linux Scatterlist Crypto API for all its
> cryptographic work. To hardware accelerate IPsec, I need to write a
> "Linux Scatterlist Crypto API" driver for my hardware accelerator and
> register it with the linux kernel.
> 
> What I would like to know is:
> 1) does the xfrm/ESP implementation support asynchronous/parallel packet
> operation?
> 2) If yes, does it support it in both directions (tx/rx)?
> 
> Our hardware supports a queue packets for processing and we would like
> to utilise that, to keep the hardware as busy as possible i.e. we would
> like to be able to send multiple packets to the hardware engine for
> encryption/hashing and then receive multiple acknowledgements that the
> packets are ready.
> 

Hi Dimitrios,

AFAK, the crypto interface is asynchronous but the hashing interface (as used 
in IPSec) is synchronous.

There are two patches I've recently seen on the list, one for converting to 
async hashing and one for parallel crypto/ipsec which will probably get in 
2.6.32.

However, I think that the best results for hw accel will be obtained if you 
accelerate the AEAD interface.

Speaking of hw accel, we are also playing with it and we got moderately good 
results. We are now running into two major software bottlenecks: memcpy 
(because of the copy required by TCP traffic) and CRC computation.

To solve the first issue we were thinking of extending the ESP implementation 
to create two scatter-gather lists / skbs, one which will be used as the 
source and once which will be used as the destination. This will allow to 
offload the memcpy operation to hardware.

We will soon start working on this - after a bit of stabilization we need to 
do and we will start pestering you crypto wizards with questions /  patches, 
but in the meanwhile, if you have any advice on this topic we will greatly 
appreciate it :)

Thanks!
tavi
