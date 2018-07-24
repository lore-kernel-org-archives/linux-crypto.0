From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 10/18] x86/power/64: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:28 -0700
Message-ID: <20180724164936.37477-11-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	linux-wireless@vger.kernel.org,
	Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
	Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
	x86@kernel.org, qat-linux@intel.com, Ingo Molnar <mingo@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	drbd-dev@lists.linbit.com, Rabin Vincent <rabinv@axis.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	linux-block@vger.kernel.org, Josh Poimboeuf
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
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

In the quest to remove all stack VLA usage from the kernel[1], this
removes the discouraged use of AHASH_REQUEST_ON_STACK by switching to
shash directly and allocating the descriptor in heap memory (which should
be fine: the tfm has already been allocated there too).

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/x86/power/hibernate_64.c | 36 ++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 67ccf64c8bd8..f8e3b668d20b 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -233,29 +233,35 @@ struct restore_data_record {
  */
 static int get_e820_md5(struct e820_table *table, void *buf)
 {
-	struct scatterlist sg;
-	struct crypto_ahash *tfm;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
 	int size;
 	int ret = 0;
 
-	tfm = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(tfm))
 		return -ENOMEM;
 
-	{
-		AHASH_REQUEST_ON_STACK(req, tfm);
-		size = offsetof(struct e820_table, entries) + sizeof(struct e820_entry) * table->nr_entries;
-		ahash_request_set_tfm(req, tfm);
-		sg_init_one(&sg, (u8 *)table, size);
-		ahash_request_set_callback(req, 0, NULL, NULL);
-		ahash_request_set_crypt(req, &sg, buf, size);
-
-		if (crypto_ahash_digest(req))
-			ret = -EINVAL;
-		ahash_request_zero(req);
+	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
+		       GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto free_tfm;
 	}
-	crypto_free_ahash(tfm);
 
+	desc->tfm = tfm;
+	desc->flags = 0;
+
+	size = offsetof(struct e820_table, entries) +
+		sizeof(struct e820_entry) * table->nr_entries;
+
+	if (crypto_shash_digest(desc, (u8 *)table, size, buf))
+		ret = -EINVAL;
+
+	kzfree(desc);
+
+free_tfm:
+	crypto_free_shash(tfm);
 	return ret;
 }
 
-- 
2.17.1
