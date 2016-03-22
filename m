From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 08/14] lib/mpi: mpi_read_buffer(): fix buffer overflow
Date: Tue, 22 Mar 2016 13:12:42 +0100
Message-ID: <1458648768-1469-9-git-send-email-nicstange@gmail.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35903 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbcCVMOH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:14:07 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, mpi_read_buffer() writes full limbs to the output buffer
and moves memory around to purge leading zero limbs afterwards.

However, with

  commit 9cbe21d8f89d ("lib/mpi: only require buffers as big as needed for
                        the integer")

the caller is only required to provide a buffer large enough to hold the
result without the leading zeros.

This might result in a buffer overflow for small MP numbers with leading
zeros.

Fix this by coping the result to its final destination within the output
buffer and not copying the leading zeros at all.

Fixes: 9cbe21d8f89d ("lib/mpi: only require buffers as big as needed for
                      the integer")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index a999ee1..d995a4c 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -201,16 +201,9 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 #else
 #error please implement for this limb size.
 #endif
-		memcpy(p, &alimb, BYTES_PER_MPI_LIMB);
-		p += BYTES_PER_MPI_LIMB;
-		if (lzeros > 0) {
-			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
-			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-				+ lzeros;
-			*limb1 = *limb2;
-			p -= lzeros;
-			lzeros -= sizeof(alimb);
-		}
+		memcpy(p, (u8 *)&alimb + lzeros, BYTES_PER_MPI_LIMB - lzeros);
+		p += BYTES_PER_MPI_LIMB - lzeros;
+		lzeros = 0;
 	}
 	return 0;
 }
-- 
2.7.4
