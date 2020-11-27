Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46356C64E7B
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 05:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA72921D7F
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 05:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbgK0Fln (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 00:41:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33280 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389241AbgK0Fln (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 00:41:43 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiWVa-0000NL-3z; Fri, 27 Nov 2020 16:41:27 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 16:41:26 +1100
Date:   Fri, 27 Nov 2020 16:41:26 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     "Jason A. Donenfeld" <zx2c4@kernel.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Samuel Neves <sneves@dei.uc.pt>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/blake2s - Move selftest prototype into header
 file
Message-ID: <20201127054125.GA23521@gondor.apana.org.au>
References: <202011131622.l3VLezRW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011131622.l3VLezRW-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 04:02:28PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> commit: 66d7fb94e4ffe5acc589e0b2b4710aecc1f07a28 crypto: blake2s - generic C library implementation and selftest
> date:   12 months ago
> config: parisc-randconfig-r003-20201113 (attached as .config)
> compiler: hppa-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66d7fb94e4ffe5acc589e0b2b4710aecc1f07a28
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 66d7fb94e4ffe5acc589e0b2b4710aecc1f07a28
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> lib/crypto/blake2s-selftest.c:566:13: warning: no previous prototype for 'blake2s_selftest' [-Wmissing-prototypes]
>      566 | bool __init blake2s_selftest(void)
>          |             ^~~~~~~~~~~~~~~~
> 
> vim +/blake2s_selftest +566 lib/crypto/blake2s-selftest.c
> 
>    565	
>  > 566	bool __init blake2s_selftest(void)

---8<---
This patch fixes a missing prototype warning on blake2s_selftest.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 74ff77032e52..6e376ae6b6b5 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -16,6 +16,8 @@ void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
 void blake2s_compress_arch(struct blake2s_state *state,const u8 *block,
 			   size_t nblocks, const u32 inc);
 
+bool blake2s_selftest(void);
+
 static inline void blake2s_set_lastblock(struct blake2s_state *state)
 {
 	state->f[0] = -1;
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 41025a30c524..6a4b6b78d630 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -17,8 +17,6 @@
 #include <linux/bug.h>
 #include <asm/unaligned.h>
 
-bool blake2s_selftest(void);
-
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
 	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
