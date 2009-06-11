From: arm-kernel@ml.breakpoint.cc
Subject: Add support for the crypto engine on Orion5X
Date: Thu, 11 Jun 2009 16:03:16 +0200
Message-ID: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, nico@cam.org,
	herbert@gondor.apana.org.au
To: linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52137 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbZFKODU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 10:03:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series contains support for crypto engine which can be found on
a few Marvell SoC. The crypto driver currently uses dmac_flush_range() to
flush the result back to phys mem. This hack goes away once I've implemented
DMA support. The alternative temporary solution  would be to use
flush_kernel_dcache_page().

The driver was tested against dm-crypt on my QNAP TS-209 with no problems
so far. Here are some numbers:

Native, no crypto at all
~~~~~~~~~~~~~~~~~~~~~~~~
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 5.67222 s, 18.5 MB/s

The crypto driver with flush_kernel_dcache_page()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|AES-ECB-128
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 31.3831 s, 3.3 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 30.6151 s, 3.4 MB/s
|
|AES-ECB-256
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 32.8273 s, 3.2 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 31.301 s, 3.3 MB/s
|
|AES-CBC-128
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 41.9262 s, 2.5 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 39.2683 s, 2.7 MB/s
|
|AES-CBC-256
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 37.599 s, 2.8 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 36.4306 s, 2.9 MB/s

The crypto driver with dmac_flush_range()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|AES-CBC-256
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 31.3163 s, 3.3 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 29.9738 s, 3.5 MB/s
|
|AES-ECB-128
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 23.6008 s, 4.4 MB/s
|
|# dd if=file bs=1048576 of=/dev/null
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 22.9579 s, 4.6 MB/s

Pure software
~~~~~~~~~~~~~
|AES-CBC-128
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 54.6493 s, 1.9 MB/s
|
|AES-CBC-256
|# dd if=/dev/zero of=file bs=1048576 count=100
|100+0 records in
|100+0 records out
|104857600 bytes (105 MB) copied, 64.3429 s, 1.6 MB/s


Sebastian
