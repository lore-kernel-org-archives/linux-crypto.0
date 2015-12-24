From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v5 2/3] integrity: convert digsig to akcipher api
Date: Wed, 23 Dec 2015 19:13:45 -0800
Message-ID: <20151224031345.23625.72589.stgit@tstruk-mobl1>
References: <20151224031334.23625.431.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151224031334.23625.431.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Convert asymmetric_verify to akcipher api.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 security/integrity/Kconfig             |    1 +
 security/integrity/digsig_asymmetric.c |   10 +++-------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 73c457b..f0b2463 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -36,6 +36,7 @@ config INTEGRITY_ASYMMETRIC_KEYS
         select ASYMMETRIC_KEY_TYPE
         select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
         select PUBLIC_KEY_ALGO_RSA
+        select CRYPTO_RSA
         select X509_CERTIFICATE_PARSER
 	help
 	  This option enables digital signature verification using
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 4fec181..5629372 100644
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
+	pks.s = hdr->sig;
+	pks.s_size = siglen;
+	ret = verify_signature(key, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;
