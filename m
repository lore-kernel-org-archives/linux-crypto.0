From: Amos Kong <akong@redhat.com>
Subject: [PATCH v5 REPOST 5/6] hw_random: don't double-check old_rng.
Date: Mon,  8 Dec 2014 16:50:39 +0800
Message-ID: <1418028640-4891-6-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, m@bues.ch,
	mpm@selenic.com, amit.shah@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 067270b..a9286bf 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -476,14 +476,13 @@ int hwrng_register(struct hwrng *rng)
 	}
 
 	old_rng = current_rng;
+	err = 0;
 	if (!old_rng) {
 		err = hwrng_init(rng);
 		if (err)
 			goto out_unlock;
 		set_current_rng(rng);
-	}
-	err = 0;
-	if (!old_rng) {
+
 		err = register_miscdev();
 		if (err) {
 			drop_current_rng();
-- 
1.9.3
