From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH linux-next] crypto: cvm_encrypt() can be static
Date: Fri, 23 Jun 2017 21:10:55 +0800
Message-ID: <20170623131055.GA78777@lkp-sbx04>
References: <201706232123.X4uTYxbf%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201706232123.X4uTYxbf%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cptvf_algs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 443c362..4303674 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -222,12 +222,12 @@ static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc)
 		return -EINPROGRESS;
 }
 
-int cvm_encrypt(struct ablkcipher_request *req)
+static int cvm_encrypt(struct ablkcipher_request *req)
 {
 	return cvm_enc_dec(req, true);
 }
 
-int cvm_decrypt(struct ablkcipher_request *req)
+static int cvm_decrypt(struct ablkcipher_request *req)
 {
 	return cvm_enc_dec(req, false);
 }
