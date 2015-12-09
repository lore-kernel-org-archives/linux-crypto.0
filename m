From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/2] integrity: convert digsig to akcipher api
Date: Wed, 09 Dec 2015 15:52:37 -0800
Message-ID: <20151209235237.11783.8959.stgit@tstruk-mobl1>
References: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Convert asymmetric_verify to akcipher api.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 security/integrity/digsig_asymmetric.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 4fec181..55f4830 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -92,13 +92,9 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.pkey_hash_algo = hdr->hash_algo;
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
-	pks.nr_mpi = 1;
-	pks.rsa.s = mpi_read_raw_data(hdr->sig, siglen);
-
-	if (pks.rsa.s)
-		ret = verify_signature(key, &pks);
-
-	mpi_free(pks.rsa.s);
+	pks.s = sig;
+	pks.s_size = siglen;
+	ret = verify_signature(key, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;
