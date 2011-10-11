From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC]: do_xor_speed Broken on UML do to jiffies
Date: Tue, 11 Oct 2011 02:13:21 +0200
Message-ID: <4E938A21.70708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Williams <dan.j.williams@intel.com>, Herbert Xu
	<herbert@gondor.hengli.com.au>, "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, l
Return-path: <user-mode-linux-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=user-mode-linux-devel>
List-Post: <mailto:user-mode-linux-devel@lists.sourceforge.net>
List-Help: <mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: user-mode-linux-devel-bounces@lists.sourceforge.net
List-Id: linux-crypto.vger.kernel.org


Remember that hang I reported a while back on UML. Well
I'm at it again, and it still hangs and I found why.

I have dprinted jiffies and it never advances during the
loop at do_xor_speed. Therefor it is stuck in an endless
loop. I have also dprinted current_kernel_time() and it
returns the same constant value as well.

Note that it does usually work on UML, only during
the modprobe of xor.ko while that test is running, it is broken.
It looks like some lucking is preventing the clock from ticking.

However ktime_get_ts does work for me so I changed the code
as below, so I can work. See how I put several safety
guards, to never get hangs again.
And I think my time based approach is more accurate then
previous system.

UML guys please investigate the jiffies issue? what is
xor.ko not doing right?

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 crypto/xor.c |   46 +++++++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index b75182d..65433f5 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -62,37 +62,45 @@ static struct xor_block_template *template_list;
 static void
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
-	int speed;
-	unsigned long now;
-	int i, count, max;
+	unsigned speed, count;
+	u64 ns_begin;
+	u64 ns_end;
+	struct timespec ts;
+
 
 	tmpl->next = template_list;
 	template_list = tmpl;
 
 	/*
-	 * Count the number of XORs done during a whole jiffy, and use
+	 * Count the number of XORs done during 10 miliseconds, and use
 	 * this to calculate the speed of checksumming.  We use a 2-page
 	 * allocation to have guaranteed color L1-cache layout.
 	 */
-	max = 0;
-	for (i = 0; i < 5; i++) {
-		now = jiffies;
-		count = 0;
-		while (jiffies == now) {
-			mb(); /* prevent loop optimzation */
-			tmpl->do_2(BENCH_SIZE, b1, b2);
-			mb();
-			count++;
-			mb();
-		}
-		if (count > max)
-			max = count;
+	ktime_get_ts(&ts);
+	ns_begin = timespec_to_ns(&ts);
+	count = 0;
+	while (count < 4000000L) {
+		mb(); /* prevent loop optimzation */
+		tmpl->do_2(BENCH_SIZE, b1, b2);
+		mb();
+		count++;
+		mb();
+
+		ktime_get_ts(&ts);
+		ns_end = timespec_to_ns(&ts);
+		/* Test for 10 miliseconds */
+		if ((ns_end - ns_begin) > NSEC_PER_SEC / 100)
+			break;
 	}
 
-	speed = max * (HZ * BENCH_SIZE / 1024);
+	ns_end -= ns_begin;
+	if (ns_end > 0)
+		speed = BENCH_SIZE / 1024 * count * NSEC_PER_SEC / ns_end;
+	else
+		speed = 17;
 	tmpl->speed = speed;
 
-	printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
+	printk(KERN_INFO "   %-10s: %5u.%03u MB/sec\n", tmpl->name,
 	       speed / 1000, speed % 1000);
 }
 
-- 
1.7.2.3


------------------------------------------------------------------------------
All the data continuously generated in your IT infrastructure contains a
definitive record of customers, application performance, security
threats, fraudulent activity and more. Splunk takes this data and makes
sense of it. Business sense. IT sense. Common sense.
http://p.sf.net/sfu/splunk-d2d-oct
