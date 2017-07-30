From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [ANNOUNCE] libkcapi v0.14.0 released
Date: Sun, 30 Jul 2017 19:42:09 +0200
Message-ID: <2673642.xK4bl3LvRT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60834 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754169AbdG3RmM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2017 13:42:12 -0400
Received: from positron.chronox.de (mail.eperm.de [89.247.134.16])
        by mail.eperm.de (Postfix) with ESMTPA id 4E445181607D
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2017 19:42:10 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The Linux kernel exports a network interface of type AF_ALG to allow user 
space to utilize the kernel crypto API. libkcapi uses this network interface 
and exports an easy to use API so that a developer does not need to consider 
the low-level network interface handling. 

The library does not implement any low level cipher algorithms. All consumer 
requests are sent to the kernel for processing. Results from the kernel crypto 
API are returned to the consumer via the library API.

The kernel interface and therefore this library can be used by unprivileged 
processes.

The library code archive also provides a drop-in replacement for the command 
line tools of sha*sum, fipscheck/fipshmac and sha512hmac.

The source code and the documentation is available at [1].

[1] http://www.chronox.de/libkcapi.html

Changes 0.14.0
 * AIO: fix tracking of completed IOCBs
 * speed-test: fix AEAD handling
 * speed-test: fix time calculation
 * compiler now warns a user of deprecated API calls
 * AIO: handle kernel errors for algif_skcipher gracefully
 * AIO: using multiple IOCB if algif_aead interface supports it
 * ASYM: add PKCS1 tests
 * AIO: add ASYM AIO support
 * AIO: fix AEAD AIO fallback
 * AIO: add AIO fallback testing
 * replace enforcement of symmetric cipher limits with a log message only
   (the underlying kernel implementations should catch any errors)
 * add fuzzing tests
 * use autotools build system as provided by Georges Savoundararadj with
   additional considerations from Marcin Nowakowski (thanks a lot)
 * ALG_MAX_PAGES restriction is gone with current AF_ALG interface
 * add HKDF (RFC5869)
 * add apps/kcapi-rng
 * add support for multiple accepts where the caller maintains the opfd
 * fix memleak in error case in PBKDF
 * add multithreaded symmetric cipher tests
 * enable full AIO support for kernels 4.13 and higher (fallback AIO
   implementation using synchronous support for earlier kernels) -- this
   is due to the broken AIO support for earlier kernels
 * Add tests for the AAD copy operation to be supported for kernel 4.13

Ciao
Stephan
