From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: [QUESTION] multi-core, multi-crypto,  ipsec/udp out of order.
Date: Fri, 30 May 2014 14:22:17 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC30807AE1@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27519 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaE3OWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 10:22:20 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi! Herbert:

  In a system of multi cpu core, with multiple crypto hardware, different irq for each, is it possible the udp receive get out of order for the same tfm?
 
Let us say, of the same tfm, driver distributes requests to any available crypto hardware.  For the same tfm, driver re-sequences response before complete callout to the same arrival sequence of the requests. The complete callout is running at tasklet level of the system.

Each irq is assigned to a different irq affinity cpu core to improve the performance. Therefore the iprecv and ipsec processing can be done by multiple cpu cores at the same time for the same tfm/udp.

I am seeing the following -   if I assign irq affinity to different cpu cores, iperf server of udp session displays receive out of order message. If I assign them to the same core, or take default, then message stops. The assignment is done by hand while the system is running, by updating  /proc/irq/xxx/smp_affinity, where xxx is the irq number. This scenario is very repeatable. 

We are on linux-3.10.

Does it make sense?

Regards,

Chemin
