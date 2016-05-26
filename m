From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 2/5] lib/digsig: digsig_verify_rsa(): return -EINVAL if modulo length is zero
Date: Thu, 26 May 2016 23:19:52 +0200
Message-ID: <1464297595-24032-3-git-send-email-nicstange@gmail.com>
References: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, if digsig_verify_rsa() detects that the modulo's length is zero,
i.e. mlen == 0, it returns -ENOMEM which doesn't really fit here.

Make digsig_verify_rsa() return -EINVAL upon mlen == 0.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/digsig.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index a121cbc..55b8b2f 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -114,13 +114,15 @@ static int digsig_verify_rsa(struct key *key,
 		datap += remaining;
 	}
 
-	err = -ENOMEM;
-
 	mblen = mpi_get_nbits(pkey[0]);
 	mlen = DIV_ROUND_UP(mblen, 8);
 
-	if (mlen == 0)
+	if (mlen == 0) {
+		err = -EINVAL;
 		goto err;
+	}
+
+	err = -ENOMEM;
 
 	out1 = kzalloc(mlen, GFP_KERNEL);
 	if (!out1)
-- 
2.8.2
