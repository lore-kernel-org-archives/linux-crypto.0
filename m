From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v4 2/4] crypto: testmgr - Add test for LRW
	counter wrap-around
Date: Thu, 13 Sep 2018 10:51:32 +0200
Message-ID: <20180913085134.11694-3-omosnace@redhat.com>
References: <20180913085134.11694-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180913085134.11694-1-omosnace@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

This patch adds a test vector for lrw(aes) that triggers wrap-around of
the counter, which is a tricky corner case.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/testmgr.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 0b3d7cadbe93..47629cb1efd3 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -13145,6 +13145,27 @@ static const struct cipher_testvec aes_lrw_tv_template[] = {
 		.ctext	= "\x5b\x90\x8e\xc1\xab\xdd\x67\x5f"
 			  "\x3d\x69\x8a\x95\x53\xc8\x9c\xe5",
 		.len	= 16,
+	}, { /* Test counter wrap-around, modified from LRW-32-AES 1 */
+		.key    = "\x45\x62\xac\x25\xf8\x28\x17\x6d"
+			  "\x4c\x26\x84\x14\xb5\x68\x01\x85"
+			  "\x25\x8e\x2a\x05\xe7\x3e\x9d\x03"
+			  "\xee\x5a\x83\x0c\xcc\x09\x4c\x87",
+		.klen   = 32,
+		.iv     = "\xff\xff\xff\xff\xff\xff\xff\xff"
+			  "\xff\xff\xff\xff\xff\xff\xff\xff",
+		.ptext	= "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x41\x42\x43\x44\x45\x46"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x41\x42\x43\x44\x45\x46"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x41\x42\x43\x44\x45\x46",
+		.ctext	= "\x47\x90\x50\xf6\xf4\x8d\x5c\x7f"
+			  "\x84\xc7\x83\x95\x2d\xa2\x02\xc0"
+			  "\xda\x7f\xa3\xc0\x88\x2a\x0a\x50"
+			  "\xfb\xc1\x78\x03\x39\xfe\x1d\xe5"
+			  "\xf1\xb2\x73\xcd\x65\xa3\xdf\x5f"
+			  "\xe9\x5d\x48\x92\x54\x63\x4e\xb8",
+		.len	= 48,
 	}, {
 /* http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
 		.key    = "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
-- 
2.17.1
