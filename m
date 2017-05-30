From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 14/27] Drivers: ccree: ssi_fips_data.h - align block
 comments
Date: Tue, 30 May 2017 18:13:46 +1200
Message-ID: <20170530061346.13629-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_fips_data.h | 93 +++++++++++++++++------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_data.h b/drivers/staging/ccree/ssi_fips_data.h
index a4b78f1b4d48..fa6bf41c27e5 100644
--- a/drivers/staging/ccree/ssi_fips_data.h
+++ b/drivers/staging/ccree/ssi_fips_data.h
@@ -15,53 +15,52 @@
  */
 
 /*
-The test vectors were taken from:
-
-* AES
-NIST Special Publication 800-38A 2001 Edition
-Recommendation for Block Cipher Modes of Operation
-http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
-Appendix F: Example Vectors for Modes of Operation of the AES
-
-* AES CTS
-Advanced Encryption Standard (AES) Encryption for Kerberos 5
-February 2005
-https://tools.ietf.org/html/rfc3962#appendix-B
-B.  Sample Test Vectors
-
-* AES XTS
-http://csrc.nist.gov/groups/STM/cavp/#08
-http://csrc.nist.gov/groups/STM/cavp/documents/aes/XTSTestVectors.zip
-
-* AES CMAC
-http://csrc.nist.gov/groups/STM/cavp/index.html#07
-http://csrc.nist.gov/groups/STM/cavp/documents/mac/cmactestvectors.zip
-
-* AES-CCM
-http://csrc.nist.gov/groups/STM/cavp/#07
-http://csrc.nist.gov/groups/STM/cavp/documents/mac/ccmtestvectors.zip
-
-* AES-GCM
-http://csrc.nist.gov/groups/STM/cavp/documents/mac/gcmtestvectors.zip
-
-* Triple-DES
-NIST Special Publication 800-67 January 2012
-Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Cipher
-http://csrc.nist.gov/publications/nistpubs/800-67-Rev1/SP-800-67-Rev1.pdf
-APPENDIX B: EXAMPLE OF TDEA FORWARD AND INVERSE CIPHER OPERATIONS
-and
-http://csrc.nist.gov/groups/STM/cavp/#01
-http://csrc.nist.gov/groups/STM/cavp/documents/des/tdesmct_intermediate.zip
-
-* HASH
-http://csrc.nist.gov/groups/STM/cavp/#03
-http://csrc.nist.gov/groups/STM/cavp/documents/shs/shabytetestvectors.zip
-
-* HMAC
-http://csrc.nist.gov/groups/STM/cavp/#07
-http://csrc.nist.gov/groups/STM/cavp/documents/mac/hmactestvectors.zip
-
-*/
+ * The test vectors were taken from:
+ *
+ * * AES
+ * NIST Special Publication 800-38A 2001 Edition
+ * Recommendation for Block Cipher Modes of Operation
+ * http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
+ * Appendix F: Example Vectors for Modes of Operation of the AES
+ *
+ * * AES CTS
+ * Advanced Encryption Standard (AES) Encryption for Kerberos 5
+ * February 2005
+ * https://tools.ietf.org/html/rfc3962#appendix-B
+ * B.  Sample Test Vectors
+ *
+ * * AES XTS
+ * http://csrc.nist.gov/groups/STM/cavp/#08
+ * http://csrc.nist.gov/groups/STM/cavp/documents/aes/XTSTestVectors.zip
+ *
+ * * AES CMAC
+ * http://csrc.nist.gov/groups/STM/cavp/index.html#07
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/cmactestvectors.zip
+ *
+ * * AES-CCM
+ * http://csrc.nist.gov/groups/STM/cavp/#07
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/ccmtestvectors.zip
+ *
+ * * AES-GCM
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/gcmtestvectors.zip
+ *
+ * * Triple-DES
+ * NIST Special Publication 800-67 January 2012
+ * Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Cipher
+ * http://csrc.nist.gov/publications/nistpubs/800-67-Rev1/SP-800-67-Rev1.pdf
+ * APPENDIX B: EXAMPLE OF TDEA FORWARD AND INVERSE CIPHER OPERATIONS
+ * and
+ * http://csrc.nist.gov/groups/STM/cavp/#01
+ * http://csrc.nist.gov/groups/STM/cavp/documents/des/tdesmct_intermediate.zip
+ *
+ * * HASH
+ * http://csrc.nist.gov/groups/STM/cavp/#03
+ * http://csrc.nist.gov/groups/STM/cavp/documents/shs/shabytetestvectors.zip
+ *
+ * * HMAC
+ * http://csrc.nist.gov/groups/STM/cavp/#07
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/hmactestvectors.zip
+ */
 
 /* NIST AES */
 #define AES_128_BIT_KEY_SIZE    16
-- 
2.13.0
