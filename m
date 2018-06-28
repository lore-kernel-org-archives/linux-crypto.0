From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] crypto: ccree: cc_update_ctr() can be static
Date: Thu, 28 Jun 2018 19:42:37 +0800
Message-ID: <20180628114237.GA119685@athens>
References: <1530171175-31960-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530171175-31960-4-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Fixes: 27646566a1a0 ("crypto: ccree: fix iv handling")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 cc_cipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 3af44a5..958ced3 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -596,7 +596,7 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 /*
  * Update a CTR-AES 128 bit counter
  */
-void cc_update_ctr(u8 *ctr, unsigned int increment)
+static void cc_update_ctr(u8 *ctr, unsigned int increment)
 {
 	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
 	    IS_ALIGNED((unsigned long)ctr, 8)) {
