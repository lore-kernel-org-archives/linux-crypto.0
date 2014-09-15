From: behanw@converseincode.com
Subject: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove
	use of VLAIS in crypto code
Date: Mon, 15 Sep 2014 00:30:23 -0700
Message-ID: <1410766234-1634-2-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
        qat-linux@intel.com, d.kasatkin@samsung.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        torvalds@linux-foundation.org, linux-ima-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, serge@hallyn.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Add a macro which replaces the use of a Variable Length Array In Struct (VLAIS)
with a C99 compliant equivalent. This macro instead allocates the appropriate
amount of memory using an char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/crypto/hash.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a391955..541125b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -58,6 +58,11 @@ struct shash_desc {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+#define SHASH_DESC_ON_STACK(shash, tfm)				  \
+	char __desc[sizeof(struct shash_desc) +                   \
+		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+	struct shash_desc *shash = (struct shash_desc *)__desc
+
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
-- 
1.9.1
