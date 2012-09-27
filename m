From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 3/3 v2] Added speed test in tcrypt for crc32c
Date: Thu, 27 Sep 2012 15:44:24 -0700
Message-ID: <1348785864.17632.18.camel@schen9-DESK>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Min Li <min.a.li@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1348784343.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds a test case in tcrypt to perform speed test for
crc32c checksum calculation.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 581081d..6deb77f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1437,6 +1437,10 @@ static int do_test(int m)
 		test_hash_speed("ghash-generic", sec, hash_speed_template_16);
 		if (mode > 300 && mode < 400) break;
 
+	case 319:
+		test_hash_speed("crc32c", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
-- 
1.7.7.6
