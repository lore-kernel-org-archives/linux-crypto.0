From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH] hw_random: Improve description of the ->read() interface
Date: Thu, 18 Aug 2016 13:37:21 +0100
Message-ID: <1471523841-30469-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37156 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbcHRMhq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Aug 2016 08:37:46 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so29895830wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2016 05:37:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, very few RNG drivers support single byte reads using the
->read() interface. Of the 14 drivers in drivers/char/hw_random that
support this interface only three of these actually support max == 1.
The other behaviours vary between return 0, return 2, return 4 and return
-EIO).

This is not a problem in practice because the core hw_random code never
performs a read shorter than 16 bytes. The documentation for this function
already contrains the alignment of the buffer pointer, so let's also
guarantee that the buffer is at least as large as its alignment.

This constraint is intended to be the weakest guarantee neccessary to
allow driver writers to safely simplify their code.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/hw_random.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 4f7d8f4b1e9a..34a0dc18f327 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -29,7 +29,9 @@
  *			Returns the number of lower random bytes in "data".
  *			Must not be NULL.    *OBSOLETE*
  * @read:		New API. drivers can fill up to max bytes of data
- *			into the buffer. The buffer is aligned for any type.
+ *			into the buffer. The buffer is aligned for any type
+ *			and max is guaranteed to be >= to that alignment
+ *			(either 4 or 8 depending on architecture).
  * @priv:		Private data, for use by the RNG driver.
  * @quality:		Estimation of true entropy in RNG's bitstream
  *			(per mill).
--
2.7.4
