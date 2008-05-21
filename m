From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc
	mode
Date: Wed, 21 May 2008 16:09:38 -0400
Message-ID: <20080521200938.GA29631@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3851 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668AbYEUUJz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 16:09:55 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch to add checking of DES3 test vectors using CBC mode.  FIPS-1402-2
compliance mandates that any supported mode of oepration must include a self
test.  This satisfies that requirement for cbc(des_ebe).  Tested successfully by
me

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


tcrypt.c |    5 +++++
1 file changed, 5 insertions(+)


diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..ca7d37b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1180,6 +1180,11 @@ static void do_test(void)
 		test_cipher("ecb(des3_ede)", DECRYPT, des3_ede_dec_tv_template,
 			    DES3_EDE_DEC_TEST_VECTORS);
 
+		test_cipher("cbc(des3_ede)", ENCRYPT, des3_ede_enc_tv_template,
+			    DES3_EDE_ENC_TEST_VECTORS);
+		test_cipher("cbc(des3_ede)", DECRYPT, des3_ede_dec_tv_template,
+			    DES3_EDE_DEC_TEST_VECTORS);
+
 		test_hash("md4", md4_tv_template, MD4_TEST_VECTORS);
 
 		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
