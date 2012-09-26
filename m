From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
Date: Wed, 26 Sep 2012 12:55:16 -0400 (EDT)
Message-ID: <20120926.125516.829958573312746035.davem@davemloft.net>
References: <cover.1348599489.git.tim.c.chen@linux.intel.com>
	<1348609808.9977.205.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, hpa@zytor.com,
	wajdi.k.feghali@intel.com, james.guilford@intel.com,
	david.m.cote@intel.com, suresh.b.siddha@intel.com,
	chaohong.guo@intel.com, austin_zhang@linux.intel.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: tim.c.chen@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45193 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2IZQzY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Sep 2012 12:55:24 -0400
In-Reply-To: <1348609808.9977.205.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Tue, 25 Sep 2012 14:50:08 -0700

> This patch series optimized CRC32C calculations with PCLMULQDQ
> instruction for crc32c-intel module.  It speeds up the original
> implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
> more.  The tcrypt module was enhanced for doing speed test
> on crc32c calculations.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Great work.

I intend to do something nearly identical on sparc64 since we have
similar instructions in the form of "xmulx" and "xmulxhi" which return
the lower and upper 64-bits (respectively) of a XOR multiply.
