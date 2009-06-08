From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 0/5] Parallel IPsec v4
Date: Mon, 8 Jun 2009 09:07:49 +0200
Message-ID: <20090608070749.GR20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58175 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZFHHFW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 03:05:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds the 'pcrypt' parallel crypto template. With this template it
is possible to process the crypto requests of a transform in parallel without
getting request reorder. This is in particular interesting for IPsec.

The parallel crypto template is based on a generic parallelization/serialization
method. This method uses the remote softirq invocation infrastructure for
parallelization and serialization. With this method data objects can be
processed in parallel, starting at some given point.
After doing some expensive operations in parallel, it is possible to serialize
again. The parallelized data objects return after serialization in the order as
they were before the parallelization. In the case of IPsec, this makes it
possible to run the expensive parts in parallel without getting packet
reordering.

Changes from v3:

- The generic aead wrapper is dropped.

- tcrypt is extended to test algorithms by name. So it is possible to
  instantiate pcrypt by doing e.g.:
  modprobe tcrypt alg="pcrypt(authenc(hmac(sha1),cbc(aes)))" type=3

Changes from v2:

- The xfrm netlink configuration code is dropped,
  this will be an extra patchset.

- Add generic aead wrapper interface to be able to wrap an aead algorithm
  with an arbitrary crypto template. 

- Convert pcrypt to use the generic aead wrapper.

- Add support for aead algorithms to eseqiv.

- Add support for the pcrypt aead wrapper to authenc. It's now possible to
  choose for pcrypt as the default authenc wrapper with a module parameter.

- Patchset applies to linux-2.6 git current.

Changes from v1:

- cpu_chainiv is dropped, pcrypt uses eseqiv as it's IV generator now.

- Add a xfrm netlink message to be able to choose for pcrypt from userspace.

- Use pcrypt just if it is selected from userspace.

- Patchset applies to 2.6.30-rc3

Steffen
