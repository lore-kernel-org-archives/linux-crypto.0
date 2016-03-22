From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 04/14] lib/mpi: mpi_write_sgl(): fix out-of-bounds stack access
Date: Tue, 22 Mar 2016 13:12:38 +0100
Message-ID: <1458648768-1469-5-git-send-email-nicstange@gmail.com>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36833 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbcCVMOB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:14:01 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Within the copying loop in mpi_write_sgl(), we have

  if (lzeros) {
    mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
    mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
                               + lzeros;
    *limb1 = *limb2;
    ...
  }

where p points past the end of alimb2 which lives on the stack and contains
the current limb in BE order.

The purpose of the above is to shift the non-zero bytes of alimb2 to its
beginning in memory, i.e. to skip its leading zero bytes.

However, limb2 points somewhere into the middle of alimb2 and thus, reading
*limb2 pulls in lzero bytes from somewhere.

Indeed, KASAN splats:

  BUG: KASAN: stack-out-of-bounds in mpi_write_to_sgl+0x4e3/0x6f0
                                      at addr ffff8800cb04f601
  Read of size 8 by task systemd-udevd/391
  page:ffffea00032c13c0 count:0 mapcount:0 mapping:   (null) index:0x0
  flags: 0x3fff8000000000()
  page dumped because: kasan: bad access detected
  CPU: 3 PID: 391 Comm: systemd-udevd Tainted: G  B  L
                                              4.5.0-next-20160316+ #12
  [...]
  Call Trace:
   [<ffffffff8194889e>] dump_stack+0xdc/0x15e
   [<ffffffff819487c2>] ? _atomic_dec_and_lock+0xa2/0xa2
   [<ffffffff814892b5>] ? __dump_page+0x185/0x330
   [<ffffffff8150ffd6>] kasan_report_error+0x5e6/0x8b0
   [<ffffffff814724cd>] ? kzfree+0x2d/0x40
   [<ffffffff819c5bce>] ? mpi_free_limb_space+0xe/0x20
   [<ffffffff819c469e>] ? mpi_powm+0x37e/0x16f0
   [<ffffffff815109f1>] kasan_report+0x71/0xa0
   [<ffffffff819c0353>] ? mpi_write_to_sgl+0x4e3/0x6f0
   [<ffffffff8150ed34>] __asan_load8+0x64/0x70
   [<ffffffff819c0353>] mpi_write_to_sgl+0x4e3/0x6f0
   [<ffffffff819bfe70>] ? mpi_set_buffer+0x620/0x620
   [<ffffffff819c0e6f>] ? mpi_cmp+0xbf/0x180
   [<ffffffff8186e282>] rsa_verify+0x202/0x260

What's more, since lzeros can be anything from 1 to sizeof(mpi_limb_t)-1,
the above will cause unaligned accesses which is bad on non-x86 archs.

Fix the issue, by preparing the starting point p for the upcoming copy
operation instead of shifting the source memory, i.e. alimb2.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 78ec4e1..b05d390 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -403,15 +403,11 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 #error please implement for this limb size.
 #endif
 		if (lzeros) {
-			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
-			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-				+ lzeros;
-			*limb1 = *limb2;
 			y = lzeros;
 			lzeros = 0;
 		}
 
-		p = p - sizeof(alimb);
+		p = p - sizeof(alimb) + y;
 
 		for (x = 0; x < sizeof(alimb) - y; x++) {
 			if (!buf_len) {
-- 
2.7.4
