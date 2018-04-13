From: David Wang <davidwang@zhaoxin.com>
Subject: [PATCH] hwrng: via-rng - support new Centaur CPU
Date: Fri, 13 Apr 2018 15:03:03 +0800
Message-ID: <1523602983-3418-1-git-send-email-davidwang@zhaoxin.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <brucechang@via-alliance.com>, <cooperyan@zhaoxin.com>,
        <qiyuanwang@zhaoxin.com>, <benjaminpan@viatech.com>,
        <lukelin@viacpu.com>, <timguo@zhaoxin.com>,
        David Wang <davidwang@zhaoxin.com>
To: <mpm@selenic.com>, <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <grehkg@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

New Centaur CPU(Family > 6) supprt Random Number Generator, but can't
support MSR_VIA_RNG. Just like VIA Nano.

Signed-off-by: David Wang <davidwang@zhaoxin.com>
---
 drivers/char/hw_random/via-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index d1f5bb5..d9448b1 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -135,7 +135,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * is always enabled if CPUID rng_en is set.  There is no
 	 * RNG configuration like it used to be the case in this
 	 * register */
-	if ((c->x86 == 6) && (c->x86_model >= 0x0f)) {
+	if (((c->x86 == 6) && (c->x86_model >= 0x0f))  || (c->x86 > 6)){
 		if (!boot_cpu_has(X86_FEATURE_XSTORE_EN)) {
 			pr_err(PFX "can't enable hardware RNG "
 				"if XSTORE is not enabled\n");
-- 
1.9.1
