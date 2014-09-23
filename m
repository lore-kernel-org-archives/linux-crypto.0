From: behanw@converseincode.com
Subject: [PATCH v4 01/12] crypto: LLVMLinux: Add macro to remove use of VLAIS in crypto code
Date: Mon, 22 Sep 2014 21:42:06 -0700
Message-ID: <1411447337-22362-2-git-send-email-behanw@converseincode.com>
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
	Behan Webster <behanw@converseincode.com>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirqus@gmail.com>
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Behan Webster <behanw@converseincode.com>

Add a macro which replaces the use of a Variable Length Array In Struct=
 (VLAIS)
with a C99 compliant equivalent. This macro instead allocates the appro=
priate
amount of memory using an char array.

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

If you want to get to the ctx at the end of the shash_desc as before yo=
u can do
so using shash_desc_ctx(shash)

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Micha=C5=82 Miros=C5=82aw <mirqus@gmail.com>
---
 include/crypto/hash.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a391955..74b13ec 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -58,6 +58,11 @@ struct shash_desc {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
=20
+#define SHASH_DESC_ON_STACK(shash, ctx)				  \
+	char __##shash##_desc[sizeof(struct shash_desc) +	  \
+		crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
+	struct shash_desc *shash =3D (struct shash_desc *)__##shash##_desc
+
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
