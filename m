From: Michael Davidson <md@google.com>
Subject: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Thu, 16 Mar 2017 17:15:19 -0700
Message-ID: <20170317001520.85223-7-md@google.com>
References: <20170317001520.85223-1-md@google.com>
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        Michael Davidson <md@google.com>
To: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace a variable length array in a struct by allocating
the memory for the entire struct in a char array on the stack.

Signed-off-by: Michael Davidson <md@google.com>
---
 drivers/md/raid10.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 063c43d83b72..158ebdff782c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4654,11 +4654,10 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	/* Use sync reads to get the blocks from somewhere else */
 	int sectors = r10_bio->sectors;
 	struct r10conf *conf = mddev->private;
-	struct {
-		struct r10bio r10_bio;
-		struct r10dev devs[conf->copies];
-	} on_stack;
-	struct r10bio *r10b = &on_stack.r10_bio;
+	char on_stack_r10_bio[sizeof(struct r10bio) +
+			      conf->copies * sizeof(struct r10dev)]
+			      __aligned(__alignof__(struct r10bio));
+	struct r10bio *r10b = (struct r10bio *)on_stack_r10_bio;
 	int slot = 0;
 	int idx = 0;
 	struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
-- 
2.12.0.367.g23dc2f6d3c-goog

