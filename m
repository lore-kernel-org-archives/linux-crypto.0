From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 0/2] Parallel crypto/IPsec v7
Date: Fri, 18 Dec 2009 13:20:14 +0100
Message-ID: <20091218122014.GX15653@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:33356 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZLRMrA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Dec 2009 07:47:00 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds the 'pcrypt' parallel crypto template. With this template it
is possible to process the crypto requests of a transform in parallel without
getting request reorder. This is in particular interesting for IPsec.

The parallel crypto template is based on the 'padata' generic
parallelization/serialization method. With this method data objects can
be processed in parallel, starting at some given point.
The parallelized data objects return after serialization in the order as
they were before the parallelization. In the case of IPsec, this makes it
possible to run the expensive parts in parallel without getting packet
reordering.

IPsec forwarding tests with two quad core machines (Intel Core 2 Quad Q6600)
and an EXFO FTB-400 packet blazer showed the following results:

On all tests I used smp_affinity to pin the interrupts of the network cards
to different cpus.

linux-2.6.33-rc1 (64 bit)
Packetsize: 1420 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 325 Mbit/s
unidirectional throughput without packet loss: 325 Mbit/s

linux-2.6.33-rc1 (64 bit)
Packetsize: 128 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 100 Mbit/s
unidirectional throughput without packet loss: 125 Mbit/s


linux-2.6.33-rc1 with padata/pcrypt (64 bit)
Packetsize: 1420 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 650 Mbit/s
unidirectional throughput without packet loss: 850  Mbit/s

linux-2.6.33-rc1 with padata/pcrypt (64 bit)
Packetsize: 128 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 100 Mbit/s
unidirectional throughput without packet loss: 125 Mbit/s


So the performance win on big packets is quite good. But on small packets
the troughput results with and without the workqueue based parallelization
are amost the same on my testing environment.

Changes from v6:

- Rework padata to use workqueues instead of softirqs for
  parallelization/serialization

- Add a cyclic sequence number pattern, makes the reset of the padata
  serialization logic on sequence number overrun superfluous.

- Adapt pcrypt to the changed padata interface.

- Rebased to linux-2.6.33-rc1

Steffen
