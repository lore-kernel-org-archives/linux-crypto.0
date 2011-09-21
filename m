From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 00/17] crypto user configuration api
Date: Wed, 21 Sep 2011 10:58:55 +0200
Message-ID: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:38933 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1IUI67 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 04:58:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds a netlink based user configuration API for the crypto
layer, similar to the configuration API of xfrm.

The patchset is based on the current cryptodev-2.6 tree.

A userspace tool that makes use of the configuration API is available at

https://sourceforge.net/projects/crconf/files/crconf-pre1.tar.gz

With this it is possible to instantiate certain algorithms by doing

crconf add driver "cbc(aes-generic)" type 4

or

crconf add driver "cbc(aes-generic)" type 4 priority 100

To remove a (form templates build and unused) algorithm with all subsequent
algorithms do

crconf del driver "cbc(aes-generic)" type 4

It is possible to update the priority of an algorithm by doing

crconf update driver "cbc(aes-generic)" type 4 priority 200

this updates the priority of this algorithm and removes all algorithms
on top.

Finally it is possible to print the instantiated crypto algorithms
similar to /proc/crypto by doing

crconf show all

This prints the algorithm informations of all instantiated algorithms
as long as the information fits into a netlink message.

Changes from v1:

- Removed the priority update functions.
- Fix algorithm information printing when build as module.
- Update the crconf tool according to the kernel changes.

Changes from v2:

- Use one structure for creating and basic querying of algorithms.
- Send the algorithm flags to userspace, so the userspace can
  check for things like passed selftest, async algorithms etc.
- Update the crconf tool according to the kernel changes.
- Add the priority update functions back. We need to be able to update
  the priority of algorithms, as we can't delete core algorithms like
  aes-generic. When we update the priority of an algorithm, we remove
  all algorithms on top.

Steffen
