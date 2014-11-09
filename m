From: Stephan Mueller <smueller@chronox.de>
Subject: libkcapi: First release of kernel crypto API userspace library
Date: Sun, 09 Nov 2014 02:18:28 +0100
Message-ID: <1800633.p8UcYzvYGX@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	cryptography@metzdowd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54295 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKIBSf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Nov 2014 20:18:35 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S5F0C> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 9 Nov 2014 02:18:31 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The Linux kernel exports a Netlink interface of type AF_ALG to allow user
space to utilize the kernel crypto API.

libkcapi uses this Netlink interface and exports easy to use APIs so that
a developer does not need to consider the low-level Netlink interface 
handling. Its first release is available at [1].

The library does not implement any cipher algorithms. All consumer requests
are sent to the kernel for processing. Results from the kernel crypto API
are returned to the consumer via the library API.

The kernel interface and therefore this library can be used by unprivileged
processes. As the library is small, it may even be included directly into a 
consuming application instead of using it as a shared library.

The library together with the kernel allows the use of symmetric ciphers as 
well as message digests and keyed message digests. Patches are prepared for 
submission to LKML to allow AEAD ciphers and RNGs to be used from userspace.

[1] http://www.chronox.de/libkcapi.html

-- 
Ciao
Stephan
