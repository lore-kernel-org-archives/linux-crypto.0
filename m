From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 06/11] dm verity fec: Remove VLA usage
Date: Mon, 25 Jun 2018 14:10:21 -0700
Message-ID: <20180625211026.15819-7-keescook@chromium.org>
References: <20180625211026.15819-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180625211026.15819-1-keescook@chromium.org>
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
uses the newly defined max digest size macro. Also adds a sanity-check
at use-time.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-verity-fec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 684af08d0747..fe5cfd1a5fa5 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -212,12 +212,15 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	struct dm_verity_fec_io *fio = fec_io(io);
 	u64 block, ileaved;
 	u8 *bbuf, *rs_block;
-	u8 want_digest[v->digest_size];
+	u8 want_digest[AHASH_MAX_DIGESTSIZE];
 	unsigned n, k;
 
 	if (neras)
 		*neras = 0;
 
+	if (WARN_ON(v->digest_size > sizeof(want_digest)))
+		return -EINVAL;
+
 	/*
 	 * read each of the rsn data blocks that are part of the RS block, and
 	 * interleave contents to available bufs
-- 
2.17.1
