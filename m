From: Megha Dey <megha.dey@linux.intel.com>
Subject: SHA1-MB algorithm broken on latest kernel
Date: Thu, 12 May 2016 16:31:06 -0700
Message-ID: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbcELXZ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 19:25:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
 
When booting latest kernel with the CONFIG_CRYPTO_SHA1_MB enabled, I
observe a panic.
 
After having a quick look, on reverting the following patches, I am able
to complete the booting process.
aec4d0e301f17bb143341c82cc44685b8af0b945
8691ccd764f9ecc69a6812dfe76214c86ac9ba06
68874ac3304ade7ed5ebb12af00d6b9bbbca0a16
 
Of the 3 patches, aec4d0e301f17bb143341c82cc44685b8af0b945 seems wrong.
The r10 to r15 registers are used in sha1_x8_avx2.S, which is called
from sha1_mb_mgr_flush_avx2.S.
 
I do not think the functionality of the SHA1-MB crypto algorithm has
been tested after applying these changes. (I am not sure if any of the
other crypto algorithms have been affected by these changes).
 
Thanks,
Megha
