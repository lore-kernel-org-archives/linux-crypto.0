From: behanw@converseincode.com
Subject: [PATCH v4 11/12] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
Date: Mon, 22 Sep 2014 21:42:16 -0700
Message-ID: <1411447337-22362-12-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com,
	d.kasatkin@samsung.com, james.l.morris@oracle.com,
	john.griffin@intel.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
	thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
	torvalds@linux-foundation.org,
	Behan Webster <behanw@converseincode.com>, tglx@linutronix.de
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Behan Webster <behanw@converseincode.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent. This patch allocates the appropriate amount of me=
mory
using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: tglx@linutronix.de
---
 security/integrity/ima/ima_crypto.c | 47 +++++++++++++++--------------=
--------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/i=
ma/ima_crypto.c
index 0bd7328..e35f5d9 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -380,17 +380,14 @@ static int ima_calc_file_hash_tfm(struct file *fi=
le,
 	loff_t i_size, offset =3D 0;
 	char *rbuf;
 	int rc, read =3D 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm);
=20
-	desc.shash.tfm =3D tfm;
-	desc.shash.flags =3D 0;
+	shash->tfm =3D tfm;
+	shash->flags =3D 0;
=20
 	hash->length =3D crypto_shash_digestsize(tfm);
=20
-	rc =3D crypto_shash_init(&desc.shash);
+	rc =3D crypto_shash_init(shash);
 	if (rc !=3D 0)
 		return rc;
=20
@@ -420,7 +417,7 @@ static int ima_calc_file_hash_tfm(struct file *file=
,
 			break;
 		offset +=3D rbuf_len;
=20
-		rc =3D crypto_shash_update(&desc.shash, rbuf, rbuf_len);
+		rc =3D crypto_shash_update(shash, rbuf, rbuf_len);
 		if (rc)
 			break;
 	}
@@ -429,7 +426,7 @@ static int ima_calc_file_hash_tfm(struct file *file=
,
 	kfree(rbuf);
 out:
 	if (!rc)
-		rc =3D crypto_shash_final(&desc.shash, hash->digest);
+		rc =3D crypto_shash_final(shash, hash->digest);
 	return rc;
 }
=20
@@ -487,18 +484,15 @@ static int ima_calc_field_array_hash_tfm(struct i=
ma_field_data *field_data,
 					 struct ima_digest_data *hash,
 					 struct crypto_shash *tfm)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm);
 	int rc, i;
=20
-	desc.shash.tfm =3D tfm;
-	desc.shash.flags =3D 0;
+	shash->tfm =3D tfm;
+	shash->flags =3D 0;
=20
 	hash->length =3D crypto_shash_digestsize(tfm);
=20
-	rc =3D crypto_shash_init(&desc.shash);
+	rc =3D crypto_shash_init(shash);
 	if (rc !=3D 0)
 		return rc;
=20
@@ -508,7 +502,7 @@ static int ima_calc_field_array_hash_tfm(struct ima=
_field_data *field_data,
 		u32 datalen =3D field_data[i].len;
=20
 		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) !=3D 0) {
-			rc =3D crypto_shash_update(&desc.shash,
+			rc =3D crypto_shash_update(shash,
 						(const u8 *) &field_data[i].len,
 						sizeof(field_data[i].len));
 			if (rc)
@@ -518,13 +512,13 @@ static int ima_calc_field_array_hash_tfm(struct i=
ma_field_data *field_data,
 			data_to_hash =3D buffer;
 			datalen =3D IMA_EVENT_NAME_LEN_MAX + 1;
 		}
-		rc =3D crypto_shash_update(&desc.shash, data_to_hash, datalen);
+		rc =3D crypto_shash_update(shash, data_to_hash, datalen);
 		if (rc)
 			break;
 	}
=20
 	if (!rc)
-		rc =3D crypto_shash_final(&desc.shash, hash->digest);
+		rc =3D crypto_shash_final(shash, hash->digest);
=20
 	return rc;
 }
@@ -565,15 +559,12 @@ static int __init ima_calc_boot_aggregate_tfm(cha=
r *digest,
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc, i;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm);
=20
-	desc.shash.tfm =3D tfm;
-	desc.shash.flags =3D 0;
+	shash->tfm =3D tfm;
+	shash->flags =3D 0;
=20
-	rc =3D crypto_shash_init(&desc.shash);
+	rc =3D crypto_shash_init(shash);
 	if (rc !=3D 0)
 		return rc;
=20
@@ -581,10 +572,10 @@ static int __init ima_calc_boot_aggregate_tfm(cha=
r *digest,
 	for (i =3D TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
-		rc =3D crypto_shash_update(&desc.shash, pcr_i, TPM_DIGEST_SIZE);
+		rc =3D crypto_shash_update(shash, pcr_i, TPM_DIGEST_SIZE);
 	}
 	if (!rc)
-		crypto_shash_final(&desc.shash, digest);
+		crypto_shash_final(shash, digest);
 	return rc;
 }
=20
--=20
1.9.1
