From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 04/11] nios2: fix timer initcall return value
Date: Thu, 10 Nov 2016 17:44:47 +0100
Message-ID: <20161110164454.293477-5-arnd@arndb.de>
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

When called more than twice, the nios2_time_init() function
return an uninitialized value, as detected by gcc -Wmaybe-uninitialized

arch/nios2/kernel/time.c: warning: 'ret' may be used uninitialized in this function

This makes it return '0' here, matching the comment above the
function.

Acked-by: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/nios2/kernel/time.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
index d9563dd..746bf5c 100644
--- a/arch/nios2/kernel/time.c
+++ b/arch/nios2/kernel/time.c
@@ -324,6 +324,7 @@ static int __init nios2_time_init(struct device_node *timer)
 		ret = nios2_clocksource_init(timer);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-- 
2.9.0
