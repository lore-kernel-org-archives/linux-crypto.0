From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 02/11] dm integrity: Remove VLA usage
Date: Wed, 20 Jun 2018 12:03:59 -0700
Message-ID: <20180620190408.45104-3-keescook@chromium.org>
References: <20180620190408.45104-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620190408.45104-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this uses
the new SHASH_MAX_DIGESTSIZE from the crypto layer to allocate the upper
bounds on stack usage.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-integrity.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 86438b2f10dd..d057b41f8690 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -521,7 +521,12 @@ static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result
 		}
 		memset(result + size, 0, JOURNAL_MAC_SIZE - size);
 	} else {
-		__u8 digest[size];
+		__u8 digest[SHASH_MAX_DIGESTSIZE];
+
+		if (WARN_ON(size > sizeof(digest))) {
+			dm_integrity_io_error(ic, "digest_size", -EINVAL);
+			goto err;
+		}
 		r = crypto_shash_final(desc, digest);
 		if (unlikely(r)) {
 			dm_integrity_io_error(ic, "crypto_shash_final", r);
@@ -1244,7 +1249,7 @@ static void integrity_metadata(struct work_struct *w)
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[ic->tag_size + extra_space];
+		char checksums_onstack[SHASH_MAX_DIGESTSIZE];
 		unsigned sectors_to_process = dio->range.n_sectors;
 		sector_t sector = dio->range.logical_sector;
 
@@ -1253,8 +1258,14 @@ static void integrity_metadata(struct work_struct *w)
 
 		checksums = kmalloc((PAGE_SIZE >> SECTOR_SHIFT >> ic->sb->log2_sectors_per_block) * ic->tag_size + extra_space,
 				    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
-		if (!checksums)
+		if (!checksums) {
 			checksums = checksums_onstack;
+			if (WARN_ON(extra_space &&
+				    digest_size > sizeof(checksums_onstack))) {
+				r = -EINVAL;
+				goto error;
+			}
+		}
 
 		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
 			unsigned pos;
@@ -1466,7 +1477,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)];
+					char checksums_onstack[max(SHASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
@@ -1516,7 +1527,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				if (ic->internal_hash) {
 					unsigned digest_size = crypto_shash_digestsize(ic->internal_hash);
 					if (unlikely(digest_size > ic->tag_size)) {
-						char checksums_onstack[digest_size];
+						char checksums_onstack[SHASH_MAX_DIGESTSIZE];
 						integrity_sector_checksum(ic, logical_sector, (char *)js, checksums_onstack);
 						memcpy(journal_entry_tag(ic, je), checksums_onstack, ic->tag_size);
 					} else
@@ -1937,7 +1948,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)];
+					char test_tag[max(SHASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
-- 
2.17.1
