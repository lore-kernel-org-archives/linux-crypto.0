From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 0/7] crypto: PCLMULQDQ accelerated GHASH
Date: Thu, 11 Jun 2009 15:10:23 +0800
Message-ID: <1244704223.5320.123.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZFKHKX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

This patchset adds PCLMULQDQ accelerated GHASH. Because conversion from
crypto_hash to crypto_shash has not been done, this patchset is not
intended to be merged now.

Please take a look at the general design.

Best Regards,
Huang Ying

