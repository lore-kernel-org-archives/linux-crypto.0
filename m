From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v7 0/2] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 17 Oct 2017 13:28:22 +0200
Message-ID: <20171017112824.10231-1-k.konieczny@partner.samsung.com>
References: <CGME20171017112845eucas1p2f760753a372a15eafba4fd3368520eb0@eucas1p2.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

First patch cleans up spaces in defines, second adds HASH support for Exynos.
Changes:

version 7:
- fix ifdef into if(IS_ENABLED()) as suggested by Krzysztof Kozlowski

version 6:
- fixes suggested by Vladimir Zapolskiy: change HASH_OP enum into bool, fix
  comments, change int into unsigned int in several functions, change some
  functions to return void, remove unnecessary parentheses in s5p_hash_import,
  replace rctx with ctx for request context, drop some dd vars and use tctx->dd
  instead, simplify s5p_hash_rx, s5p_hash_copy_result and s5p_hash_set_flow,
  change int final into bool final, reoder some declarations, split patch into
  two
- rewrite and fix while loop in s5p_hash_copy_sg_lists
- rewrite while loop in s5p_hash_prepare_sgs

version 5:
- fix suggested by Krzysztof Kozlowski: change defines HASH_OP into enum, fix
  comments

version 4:
- fixes suggested by Krzysztof Kozlowski: reformat comments, convert context
  flags into two bool vars, drop SSS_ALIGNED, change name of SSS_DMA_ALIGN and
  SSS_DMA_ALIGN_MASK, split assignments into separate lines, use IS_ENABLED in
  place of ifdef, remove sss_hash_algs_info and simplify register and deregister
  HASH algs

version 3:
- many fixes suggested by Krzysztof Kozlowski: comments, uppercases in const,
  remove unused defines, remove unused variable bs, constify aes_variant,
  remove global var use_hash, remove WARN_ON, improve hash_import(),
  change goto label into 'out' in s5p_hash_handle_queue(), reorder variable
  declarations, add spinlock to protect clearing HASH_FLAGS_BUSY
- simplify code: replace one-line functions s5p_hash_update_req(),
  s5p_hash_final_req() with call to s5p_hash_xmit_dma(), and delete them
- replace call to s5p_hash_hw_init() into s5p_ahash_dma_init() and delete it
- fix clearing shash flag CRYPTO_TFM_REQ_MAY_SLEEP
- fix s5p_hash_set_flow()

version 2:
- change patch format so number of lines drops
- change in Kconfig as suggested by Krzysztof Kozlowski, add
	EXYNOS_HASH subsection
- change #ifndef EXYNOS_RNG into #ifdef CRYPTO_DEV_EXYNOS_HASH
- remove style fixups in aes, as they should go in separate patch
- remove FLOW_LOG, FLOW_DUMP macros and its uses
- remove #if 0 ... endif
- remove unused function hash_wait and its defines
- fix compiler warning in dev_dbg
- remove some comments
- other minor fixes in comments

Kamil Konieczny (2):
  change spaces into tabs in defines
  Add HASH support for Exynos

 drivers/crypto/Kconfig   |   14 +
 drivers/crypto/s5p-sss.c | 1597 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 1506 insertions(+), 105 deletions(-)

-- 
2.14.1.536.g6867272d5b56
