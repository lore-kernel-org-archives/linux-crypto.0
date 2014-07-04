From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 0/3] ima: use asynchronous hash API for hash calculation
Date: Fri, 04 Jul 2014 15:05:25 +0300
Message-ID: <cover.1404475462.git.d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12801 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGDMGr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2014 08:06:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depending on the IMA policy, it might require to measure huge amount of files.
It may be very important to speedup hash calculation or to reduce (battery)
energy required to do it. Currently IMA uses synchronous hash API (shash)
which is CPU based. CPU based hash calculation is very CPU intensive and on the
battery powered device will be also high energy consuming.

Many platforms provide cryptographic acceleration modules which allow speedup
and/or reduce energy consumption, and provide asynchronous way to calculate
hashes. Defacto way to implement drivers for such accelerators is using
asynchronous hash API (ahash).

The first patch adds use of ahash API to IMA. Performance of using HW
acceleration depends very much on amount of data to hash and it depends
on particular HW. It is usually inefficient for small data due to HW
initialization overhead. In order to make it possible to optimize performance
for particular system, the patch provides kernel module parameter
'ima.ahash_minsize=<min_file_size>', which allows to specify optimal file size
when start using ahash. By default ahash is disabled until non-zero value
is specified.

Second patch introduces multi-page buffers which makes HW acceleration more
efficient. It provides 'ima.ahash_bufsize=<bufsize>' module parameter to
specify buffer size. Buffer is 4k if parameter is unspecified.

Third patch introduces double-buffering which allows to readahead next portion
of data for hashing while calculating the hash.

Changes in v3:
- kernel parameters replaced with module parameters
- more clear comments and function descriptions
- pr_crit replaced with pr_crit_ratelimited

Changes in v2:
- ima_ahash_size and ima_ahash_bufsize were combined as ima_ahash
- ahash pre-allocation moved out from __init code to be able to use
  ahash crypto modules. Ahash allocated once on the first use.
- hash calculation falls back to sahsh if ahash allocation/calculation fails
- complex initialization separated from variable declaration
- improved comments

- Dmitry

Dmitry Kasatkin (3):
  ima: use ahash API for file hash calculation
  ima: introduce multi-page collect buffers
  ima: provide double buffering for hash calculation

 Documentation/kernel-parameters.txt |  17 ++
 security/integrity/ima/ima_crypto.c | 312 +++++++++++++++++++++++++++++++++++-
 2 files changed, 326 insertions(+), 3 deletions(-)

-- 
1.9.1
