From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] crypto: zbewalgo_stat_combination[] can be static
Date: Fri, 23 Mar 2018 17:36:39 +0800
Message-ID: <20180323093639.GA54803@lkp-wsx02>
References: <1B59F77F-1AD8-484A-BA18-255502527323@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1B59F77F-1AD8-484A-BA18-255502527323@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Fixes: 7ba8785b6091 ("crypto: add zBeWalgo to crypto-api")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 zbewalgo.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/zbewalgo/zbewalgo.c b/lib/zbewalgo/zbewalgo.c
index ef922bc2..323dce4 100644
--- a/lib/zbewalgo/zbewalgo.c
+++ b/lib/zbewalgo/zbewalgo.c
@@ -67,8 +67,8 @@
 #include "bitshuffle.h"
 #include "huffman.h"
 
-atomic64_t zbewalgo_stat_combination[256];
-atomic64_t zbewalgo_stat_count[256];
+static atomic64_t zbewalgo_stat_combination[256];
+static atomic64_t zbewalgo_stat_count[256];
 
 unsigned long zbewalgo_max_output_size;
 
@@ -76,8 +76,8 @@ unsigned long zbewalgo_max_output_size;
  * all currently available combination sequences of algorithms
  */
 struct zbewalgo_combination
-	zbewalgo_combinations[ZBEWALGO_COMBINATION_MAX_ACTIVE];
-u8 zbewalgo_combinations_count;
+static 	zbewalgo_combinations[ZBEWALGO_COMBINATION_MAX_ACTIVE];
+static u8 zbewalgo_combinations_count;
 
 /*
  * maximum required wrkmem for compression and decompression for each instance
@@ -89,19 +89,19 @@ static u32 zbewalgo_wrkmem_size;
  * compression can be aborted if the data is smaller than this threshold to
  * speed up the algorithm.
  */
-u16 zbewalgo_early_abort_size;
+static u16 zbewalgo_early_abort_size;
 
 /*
  * each cpu has its own independent compression history to avoid locks
  */
-struct zbewalgo_main_data __percpu *zbewalgo_main_data_ptr;
+static struct zbewalgo_main_data __percpu *zbewalgo_main_data_ptr;
 
 /*
  * all available algorithms
  */
 struct zbewalgo_alg
-	zbewalgo_base_algorithms[ZBEWALGO_MAX_BASE_ALGORITHMS];
-u8 zbewalgo_base_algorithms_count;
+static 	zbewalgo_base_algorithms[ZBEWALGO_MAX_BASE_ALGORITHMS];
+static u8 zbewalgo_base_algorithms_count;
 
 /*
  * returns the required size of wrkmem for compression and decompression
