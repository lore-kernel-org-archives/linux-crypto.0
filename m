From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 00/16] crypto user configuration api
Date: Thu, 11 Aug 2011 13:26:03 +0200
Message-ID: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:34390 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1HKLZc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:25:32 -0400
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

It is possible to update the priority of an algorithm by doing

crconf update driver "cbc(aes-generic)" type 4 priority 200

this updates the priority of this and all subsequent algorithms.

Finally it is possible to print the instantiated crypto algorithms
similar to /proc/crypto by doing

crconf show all

This prints the algorithm informations of all instantiated algorithms
as long as the information fits into a netlink message.

Steffen
