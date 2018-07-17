From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 06/11] dm verity fec: Remove VLA usage
Date: Mon, 16 Jul 2018 21:21:45 -0700
Message-ID: <20180717042150.37761-7-keescook@chromium.org>
References: <20180717042150.37761-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717042150.37761-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
uses the newly defined max digest size macro. Also adds a sanity-check
at use-time.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

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
