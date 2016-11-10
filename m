From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 11/11] Kbuild: enable -Wmaybe-uninitialized warnings by
 default
Date: Thu, 10 Nov 2016 17:44:54 +0100
Message-ID: <20161110164454.293477-12-arnd@arndb.de>
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

Previously the warnings were added back at the W=1 level and above,
this now turns them on again by default, assuming that we have addressed
all warnings and again have a clean build for v4.10.

I found a number of new warnings in linux-next already and submitted
bugfixes for those. Hopefully they are caught by the 0day builder
in the future as soon as this patch is merged.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please check if there are any remaining warnings with this
patch before applying.

The one known issue right now is commit 32cb7d27e65d ("iio:
maxim_thermocouple: detect invalid storage size in read()"), which
is currently in linux-next but not yet in mainline.

There are a couple of warnings that I get with randconfig builds,
and I have submitted patches for all of them at some point and
will follow up on them to make sure they get addressed eventually.
---
 scripts/Makefile.extrawarn | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 7fc2c5a..7c321a6 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -60,8 +60,6 @@ endif
 KBUILD_CFLAGS += $(warning)
 else
 
-KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
-
 ifeq ($(cc-name),clang)
 KBUILD_CFLAGS += $(call cc-disable-warning, initializer-overrides)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-value)
-- 
2.9.0
