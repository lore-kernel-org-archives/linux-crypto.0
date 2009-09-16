From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/3] augment the testmgr code to set TEST_MODE flag on
	all rng instances
Date: Wed, 16 Sep 2009 12:13:39 -0400
Message-ID: <20090916161339.GE11163@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbZIPQNh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 12:13:37 -0400
Content-Disposition: inline
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

patch 2/3: Update testmgr code to place any rng it tests in TEST_MODE

This patch instructs the testmgr code to place all rng allocations that it makes
into test mode, so that in the event that it has internal mechanisms that may
affect the testing of the RNG, they won't affect the outcome of the test they
are preforming.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 testmgr.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6d5b746..89ea8c1 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1470,6 +1470,8 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 		return PTR_ERR(rng);
 	}
 
+	crypto_rng_set_flags(rng, CRYPTO_RNG_TEST_MODE);
+
 	err = test_cprng(rng, desc->suite.cprng.vecs, desc->suite.cprng.count);
 
 	crypto_free_rng(rng);
