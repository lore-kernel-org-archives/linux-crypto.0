From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 2/2] crypto: mcryptd - use list_first_entry_or_null()
Date: Mon, 16 Nov 2015 22:37:15 +0800
Message-ID: <d6b0e641f72c3f72a759a7266dd103dcd0b19886.1447684469.git.geliangtang@163.com>
References: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
In-Reply-To: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
References: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Simplify mcryptd_opportunistic_flush() with list_first_entry_or_null().

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 crypto/mcryptd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index fe5b495a..f78d4fc 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -128,13 +128,9 @@ static void mcryptd_opportunistic_flush(void)
 	flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
 	while (single_task_running()) {
 		mutex_lock(&flist->lock);
-		if (list_empty(&flist->list)) {
-			mutex_unlock(&flist->lock);
-			return;
-		}
-		cstate = list_entry(flist->list.next,
+		cstate = list_first_entry_or_null(&flist->list,
 				struct mcryptd_alg_cstate, flush_list);
-		if (!cstate->flusher_engaged) {
+		if (!cstate || !cstate->flusher_engaged) {
 			mutex_unlock(&flist->lock);
 			return;
 		}
-- 
2.5.0
