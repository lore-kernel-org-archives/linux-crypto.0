From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 1/5] Add LZO compression support to the kernel
Date: Wed, 28 Feb 2007 19:13:24 +0000
Message-ID: <1172690004.16062.136.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, herbert@gondor.apana.org.au
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add LZO1X compression/decompression support to the kernel.

This is based on the standard userspace lzo library, particularly 
minilzo with the headers much trimmed down and simplified for kernel
use. Its structured so that it should still diff with the userspace
version for ease of future updating.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/lzo.h |   63 +
 lib/Kconfig         |    5 
 lib/Makefile        |    1 
 lib/lzo/Makefile    |    3 
 lib/lzo/lzoconf.h   |  186 +++++
 lib/lzo/lzodefs.h   |  463 +++++++++++++
 lib/lzo/lzointf.c   |   37 +
 lib/lzo/minilzo.c   | 1771
++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 2529 insertions(+)

http://folks.o-hand.com/richard/lzo/lzo_kernel.patch
(since it exceeds the file size limit for LKML)

I can email inline if anyone prefers it that way.


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
