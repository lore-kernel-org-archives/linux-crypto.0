From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 0/3] ima: use asynchronous hash API for hash calculation
Date: Thu, 19 Jun 2014 18:20:37 +0300
Message-ID: <cover.1403191191.git.d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30404 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbaFSPV3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jun 2014 11:21:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depending on the IMA policy, it might require to measure huge amount of files.
It may be very important to speedup hash calculation or to reduce (bettery)
energy required to do it. Currently IMA uses synchronous hash API (shash)
which is CPU based. CPU based hash calculation is very CPU intensive and on the
battery powered device will be also high energy consuming.

Many platforms provide cryptographic acceleration modules which allow speedup
and/or reduce energy consumption, and provide ansyhchronous way to calculate
hashes. Defacto way to implement drivers for such accelerators is using
asynchronous hash API (ahash).

The first patch adds use of ahash API to IMA. Performance of using HW
acceleration depends very much on amount of data to hash and it depends
on particular HW. It is usually inefficient for small data due to HW
initialization overhead. In order to make it possible to optimize performance
for particular system, the patch provides kernel parameter 'ima_ahash_size=size'
which allows to specify optimal data size when start using ahash. By default
ahash is dsiabled until non-zero value to 'ima_ahash_size' is provided.

Second patch introduces multi-page buffers which makes HW acceleration more
efficient. It adds kernel parameter to specify buffer size to use.

Third patch introduces double-buffering which allows to readahead next portion
of data for hashing while calculating the hash.

- Dmitry

Dmitry Kasatkin (3):
  ima: use ahash API for file hash calculation
  ima: introduce multi-page collect buffers
  ima: provide double buffering for hash calculation

 Documentation/kernel-parameters.txt |   6 +
 security/integrity/ima/ima_crypto.c | 282 +++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 3 deletions(-)

-- 
1.9.1
