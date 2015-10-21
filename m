From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/10] KEYS: Add identifier pointers to public_key_signature
 struct
Date: Wed, 21 Oct 2015 16:14:03 +0100
Message-ID: <20151021151403.4583.6160.stgit@warthog.procyon.org.uk>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add key identifier pointers to public_key_signature struct so that they can
be used to retain the identifier of the key to be used to verify the
signature in both PKCS#7 and X.509.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |    2 ++
 include/crypto/public_key.h         |    1 +
 2 files changed, 3 insertions(+)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e537aaeafdbf..f5b4824b7c77 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -72,6 +72,8 @@ void public_key_free(struct public_key *key,
 	}
 
 	if (sig) {
+		for (i = 0; i < ARRAY_SIZE(sig->auth_ids); i++)
+			kfree(sig->auth_ids[i]);
 		for (i = 0; i < ARRAY_SIZE(sig->mpi); i++)
 			mpi_free(sig->mpi[i]);
 		kfree(sig->digest);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index a3f8f8268e23..ed86bfb23e89 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -76,6 +76,7 @@ struct public_key {
  * Public key cryptography signature data
  */
 struct public_key_signature {
+	struct asymmetric_key_id *auth_ids[2];
 	u8 *digest;
 	u8 digest_size;			/* Number of bytes in digest */
 	u8 nr_mpi;			/* Occupancy of mpi[] */
