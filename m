From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: ahash alg that does not implement import/export failed to register
Date: Fri, 18 Dec 2015 17:31:34 -0800
Message-ID: <1450488694.30844.11.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	"; linux-crypto" <linux-crypto@vger.kernel.org>,
	"megha.dey" <megha.dey@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:30717 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbbLSBbm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Dec 2015 20:31:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

There are some ahash algorithms like x86's sha1-mb and
ghash that failed to register because of the newly added
check of non-zero statesize from commit 8996eafd.  But
since there are algorithms that do not implement an import or
export, there is no state required for them.  Wonder if the check
should be modified to something like:

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c1dc8d..f512183 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -544,7 +544,10 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
        struct crypto_alg *base = &alg->halg.base;
 
        if (alg->halg.digestsize > PAGE_SIZE / 8 ||
-           alg->halg.statesize > PAGE_SIZE / 8 ||
+           alg->halg.statesize > PAGE_SIZE / 8)
+               return -EINVAL;
+
+       if ((alg->import || alg->export) &&
            alg->halg.statesize == 0)
                return -EINVAL;

Thanks.

Tim
