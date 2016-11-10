From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 07/11] [media] rc: print correct variable for z8f0811
Date: Thu, 10 Nov 2016 17:44:50 +0100
Message-ID: <20161110164454.293477-8-arnd@arndb.de>
References: <20161110164454.293477-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Sean Young <sean@mess.org>,
 Trond Myklebust <trond.myklebust@primarydata.com>, linux-s390@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
 Sebastian Ott <sebott@linux.vnet.ibm.com>,
 Russell King <linux@armlinux.org.uk>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Ilya Dryomov <idryomov@gmail.com>, linux-snps-arc@lists.infradead.org,
 linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 linux-kbuild@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
 Michal Marek <mmarek@suse.com>, nios2-dev@lists.rocketboards.org,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>,
 "Luis R . Rodriguez" <mcgrof@kernel.org>, linux-crypto@vger.kernel.org,
 Martin Schwidefsky <schwidefsky@de.ibm.com>, Ley Foon Tan <lftan@altera.com>,
 Andrew Morton <akpm@linux-found
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161110164454.293477-1-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

A recent rework accidentally left a debugging printk untouched
while changing the meaning of the variables, leading to an
uninitialized variable being printed:

drivers/media/i2c/ir-kbd-i2c.c: In function 'get_key_haup_common':
drivers/media/i2c/ir-kbd-i2c.c:62:2: error: 'toggle' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This prints the correct one instead, as we did before the patch.

Fixes: 00bb820755ed ("[media] rc: Hauppauge z8f0811 can decode RC6")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ir-kbd-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I submitted this repeatedly as it is a v4.9 regression, but
I never saw a reply for it.

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index f95a6bc..cede397 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -118,7 +118,7 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 			*protocol = RC_TYPE_RC6_MCE;
 			dev &= 0x7f;
 			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
-						toggle, vendor, dev, code);
+						*ptoggle, vendor, dev, code);
 		} else {
 			*ptoggle = 0;
 			*protocol = RC_TYPE_RC6_6A_32;
-- 
2.9.0
