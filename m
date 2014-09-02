From: behanw@converseincode.com
Subject: [PATCH RFC 3/6] crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
Date: Tue,  2 Sep 2014 15:32:30 -0700
Message-ID: <1409697153-7006-4-git-send-email-behanw@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
	john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). This patch instead allocates the appropriate amount of=
 memory
using an char array.

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
Cc: pageexec@freemail.hu
---
 lib/libcrc32c.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index b3131f5..03f2cf3 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -41,20 +41,20 @@ static struct crypto_shash *tfm;
=20
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
+	u32 *ctx =3D (u32 *)shash_desc_ctx(shash);
 	int err;
=20
-	desc.shash.tfm =3D tfm;
-	desc.shash.flags =3D 0;
-	*(u32 *)desc.ctx =3D crc;
+	shash->tfm =3D tfm;
+	shash->flags =3D 0;
+	*ctx =3D crc;
=20
-	err =3D crypto_shash_update(&desc.shash, address, length);
+	err =3D crypto_shash_update(shash, address, length);
 	BUG_ON(err);
=20
-	return *(u32 *)desc.ctx;
+	return *ctx;
 }
=20
 EXPORT_SYMBOL(crc32c);
--=20
1.9.1
