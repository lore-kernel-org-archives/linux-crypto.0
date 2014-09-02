From: behanw@converseincode.com
Subject: [PATCH RFC 5/6] apparmor: LLVMLinux: Remove VLAIS
Date: Tue,  2 Sep 2014 15:32:32 -0700
Message-ID: <1409697153-7006-6-git-send-email-behanw@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
	john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
	=?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>,
	Mark Charlebois <charlebm@gmail.com>
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent. This is the original VLAIS struct.

struct {
	struct shash_desc shash;
	char ctx[crypto_shash_descsize(apparmor_tfm)];
} desc;

This patch instead allocates the appropriate amount of memory using an
char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared =
with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that ca=
n
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long =
long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 security/apparmor/crypto.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index 532471d..62b32e7 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -32,10 +32,9 @@ unsigned int aa_hash_size(void)
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void=
 *start,
 			 size_t len)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(apparmor_tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(apparmor_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	int error =3D -ENOMEM;
 	u32 le32_version =3D cpu_to_le32(version);
=20
@@ -46,19 +45,19 @@ int aa_calc_profile_hash(struct aa_profile *profile=
, u32 version, void *start,
 	if (!profile->hash)
 		goto fail;
=20
-	desc.shash.tfm =3D apparmor_tfm;
-	desc.shash.flags =3D 0;
+	shash->tfm =3D apparmor_tfm;
+	shash->flags =3D 0;
=20
-	error =3D crypto_shash_init(&desc.shash);
+	error =3D crypto_shash_init(shash);
 	if (error)
 		goto fail;
-	error =3D crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
+	error =3D crypto_shash_update(shash, (u8 *) &le32_version, 4);
 	if (error)
 		goto fail;
-	error =3D crypto_shash_update(&desc.shash, (u8 *) start, len);
+	error =3D crypto_shash_update(shash, (u8 *) start, len);
 	if (error)
 		goto fail;
-	error =3D crypto_shash_final(&desc.shash, profile->hash);
+	error =3D crypto_shash_final(shash, profile->hash);
 	if (error)
 		goto fail;
=20
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
