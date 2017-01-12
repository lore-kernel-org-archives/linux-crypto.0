From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH 1/4] n2rng: limit error spewage when self-test fails
Date: Thu, 12 Jan 2017 10:52:46 -0800
Message-ID: <1484247169-245086-2-git-send-email-shannon.nelson@oracle.com>
References: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If the self-test fails, it probably won't actually suddenly
start working.  Currently, this causes an endless spew of
error messages on the console and in the logs, so this patch
adds a limiter to the test.

Reported-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Signed-off-by: Shannon Nelson <shannon.nelson@oracle.com>
---
 drivers/char/hw_random/n2-drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 3b06c1d..102560f 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -589,6 +589,7 @@ static void n2rng_work(struct work_struct *work)
 {
 	struct n2rng *np = container_of(work, struct n2rng, work.work);
 	int err = 0;
+	static int retries = 4;
 
 	if (!(np->flags & N2RNG_FLAG_CONTROL)) {
 		err = n2rng_guest_check(np);
@@ -606,7 +607,9 @@ static void n2rng_work(struct work_struct *work)
 		dev_info(&np->op->dev, "RNG ready\n");
 	}
 
-	if (err && !(np->flags & N2RNG_FLAG_SHUTDOWN))
+	if (--retries == 0)
+		dev_err(&np->op->dev, "Self-test retries failed, RNG not ready\n");
+	else if (err && !(np->flags & N2RNG_FLAG_SHUTDOWN))
 		schedule_delayed_work(&np->work, HZ * 2);
 }
 
-- 
1.7.1
