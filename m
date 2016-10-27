From: Stephan Mueller <smueller@chronox.de>
Subject: [ANNOUNCE] libkcapi v0.12.0 released
Date: Thu, 27 Oct 2016 03:54:39 +0200
Message-ID: <2974976.xU0nDqBFOZ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47024 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbcJ0Byt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 21:54:49 -0400
Received: from positron.chronox.de (rrcs-97-79-174-130.sw.biz.rr.com [97.79.174.130])
        by mail.eperm.de (Postfix) with ESMTPA id ABFE7181607F
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2016 03:54:45 +0200 (CEST)
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

Ciao
Stephan
