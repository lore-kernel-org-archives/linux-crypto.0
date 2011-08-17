From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 00/15] crypto user configuration api
Date: Wed, 17 Aug 2011 14:08:59 +0200
Message-ID: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41214 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1HQMIC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:08:02 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds a netlink based user configuration API for the crypto
layer, similar to the configuration API of xfrm.

The patchset is based on the current cryptodev-2.6 tree and also available
at branch 'crypto-user-config-api' of

git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-stk.git

A userspace tool that makes use of the configuration API is temporarily
available at

http://www.kernel.org/pub/linux/kernel/people/klassert/crconf/ 

With this it is possible to instantiate certain algorithms by doing

crconf add driver "cbc(aes-generic)" type 4

or

crconf add driver "cbc(aes-generic)" type 4 priority 100

To remove a (form templates build and unused) algorithm with all subsequent
algorithms do

crconf del driver "cbc(aes-generic)" type 4

Finally it is possible to print the instantiated crypto algorithms
similar to /proc/crypto by doing

crconf show all

This prints the algorithm informations of all instantiated algorithms
as long as the information fits into a netlink message.

Changes from v1:

- Removed the priority update functions.
- Fix algorithm information printing when build as module.
- Update the crconf tool according to the kernel changes.

Steffen
