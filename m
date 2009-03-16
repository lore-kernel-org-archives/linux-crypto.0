From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 0/4] Parallel IPsec
Date: Mon, 16 Mar 2009 12:49:40 +0100
Message-ID: <20090316114940.GN13998@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:52460 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZCPMN5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2009 08:13:57 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds the 'pcrypt' parallel crypto template. With this template it
is possible to process the crypto requests of a transform in parallel without
getting request reorder. This is in particular interesting for IPsec.

I posted a first network based version to the netdev list some time ago. The
discussion can be found here:
http://lwn.net/Articles/309029/

The parallel crypto template is based on a generic parallelization/serialization
method. This method uses the remote softirq invocation infrastructure for
parallelization and serialization. With this method data objects can be
processed in parallel, starting at some given point.
After doing some expensive operations in parallel, it is possible to serialize
again. The parallelized data objects return after serialization in the order as
they were before the parallelization. In the case of IPsec, this makes it
possible to run the expensive parts in parallel without getting packet
reordering.

I did forwarding tests with two quad core machines (Intel Core 2 Quad Q6600)
and an EXFO FTB-400 packet blazer.
Unfortunately the thoughput tests are not that meaningful as long as we don't
use the new reentrant ahash/shash interface, because the lock in authenc_hash
serializes the requests. As soon as this work stabilize I'll start to convert
authenc to ahash if nobody else did it in between.

The results of the troughput tests are as follows:

cryptodev-2.6
Packetsize: 1420 byte
Encryption: aes192-sha1
bidirectional throughput: 2 x 132 Mbit/s
unidirectional throughput: 260 Mbit/s

cryptodev-2.6 + pcrypt (authenc) parallelization:
Packetsize: 1420 byte
Encryption: aes192-sha1
bidirectional throughput: 2 x 320 Mbit/s
unidirectional throughput: 493 Mbit/s

To reduce the hold time of the lock in authenc_hash I did the same tests again
with aes192-digest_null:

cryptodev-2.6
Packetsize: 1420 byte
Encryption: aes192-digest_null
bidirectional throughput: 2 x 243 Mbit/s
unidirectional throughput: 480 Mbit/s

cryptodev-2.6 + pcrypt (authenc) parallelization:
Packetsize: 1420 byte
Encryption: aes192-digest_null
bidirectional throughput: 2 x 592 Mbit/s
unidirectional throughput: 936 Mbit/s

Steffen
