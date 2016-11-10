From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 05/11] s390: pci: don't print uninitialized data for
 debugging
Date: Thu, 10 Nov 2016 17:44:48 +0100
Message-ID: <20161110164454.293477-6-arnd@arndb.de>
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

gcc correctly warns about an incorrect use of the 'pa' variable
in case we pass an empty scatterlist to __s390_dma_map_sg:

arch/s390/pci/pci_dma.c: In function '__s390_dma_map_sg':
arch/s390/pci/pci_dma.c:309:13: warning: 'pa' may be used uninitialized in this function [-Wmaybe-uninitialized]

This adds a bogus initialization to the function to sanitize
the debug output.  I would have preferred a solution without
the initialization, but I only got the report from the
kbuild bot after turning on the warning again, and didn't
manage to reproduce it myself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/pci/pci_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 7350c8b..6b2f72f 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -423,7 +423,7 @@ static int __s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	dma_addr_t dma_addr_base, dma_addr;
 	int flags = ZPCI_PTE_VALID;
 	struct scatterlist *s;
-	unsigned long pa;
+	unsigned long pa = 0;
 	int ret;
 
 	size = PAGE_ALIGN(size);
-- 
2.9.0
