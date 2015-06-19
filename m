From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 272/278] drivers/crypto/marvell/hash.c:356:48:
 sparse: incorrect type in assignment (different base types)
Date: Sat, 20 Jun 2015 03:18:06 +0800
Message-ID: <201506200304.mHQtsB1J%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-crypto@vger.kernel.org
To: Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:27548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbbFSTS5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 15:18:57 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   2df6bb5d8b22bc06a6ea83e8b2a6bcf3bb445304
commit: 7aeef693d18d359134f47bf7b6621ec303b570f9 [272/278] crypto: marvell/cesa - add MD5 support
reproduce:
  # apt-get install sparse
  git checkout 7aeef693d18d359134f47bf7b6621ec303b570f9
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/marvell/hash.c:206:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:206:17:    expected void *to
   drivers/crypto/marvell/hash.c:206:17:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/hash.c:220:77: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/hash.c:220:77:    expected void *buf
   drivers/crypto/marvell/hash.c:220:77:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:248:33: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:248:33:    expected void const *from
   drivers/crypto/marvell/hash.c:248:33:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/hash.c:254:68: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:254:68:    expected unsigned char [usertype] *buf
   drivers/crypto/marvell/hash.c:254:68:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:269:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:269:9:    expected void *to
   drivers/crypto/marvell/hash.c:269:9:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:309:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:309:9:    expected void *to
   drivers/crypto/marvell/hash.c:309:9:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/hash.c:341:32: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/hash.c:341:32:    expected restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:341:32:    got unsigned int
   drivers/crypto/marvell/hash.c:356:50: sparse: cast from restricted __be32
>> drivers/crypto/marvell/hash.c:356:48: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/hash.c:356:48:    expected restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:356:48:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:358:50:    expected unsigned int [unsigned] [usertype] val
   drivers/crypto/marvell/hash.c:358:50:    got restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:384:35: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:384:35:    expected unsigned int [unsigned] val
   drivers/crypto/marvell/hash.c:384:35:    got restricted __be32 <noident>
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:494:59: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:494:59:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:494:59:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:530:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:530:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:530:51:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:616:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:616:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:616:51:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/hash.c:677:57: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:677:57:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:677:57:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1169:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1172:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1172:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1172:34: sparse: cast to restricted __be32

vim +356 drivers/crypto/marvell/hash.c

   303		struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
   304		struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
   305		struct mv_cesa_engine *engine = sreq->base.engine;
   306	
   307		sreq->offset = 0;
   308		mv_cesa_adjust_op(engine, &creq->op_tmpl);
 > 309		memcpy(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
   310	}
   311	
   312	static void mv_cesa_ahash_step(struct crypto_async_request *req)
   313	{
   314		struct ahash_request *ahashreq = ahash_request_cast(req);
   315		struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
   316	
   317		if (creq->req.base.type == CESA_DMA_REQ)
   318			mv_cesa_dma_step(&creq->req.dma.base);
   319		else
   320			mv_cesa_ahash_std_step(ahashreq);
   321	}
   322	
   323	static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
   324	{
   325		struct ahash_request *ahashreq = ahash_request_cast(req);
   326		struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
   327		struct mv_cesa_engine *engine = creq->req.base.engine;
   328		unsigned int digsize;
   329		int ret, i;
   330	
   331		if (creq->req.base.type == CESA_DMA_REQ)
   332			ret = mv_cesa_dma_process(&creq->req.dma.base, status);
   333		else
   334			ret = mv_cesa_ahash_std_process(ahashreq, status);
   335	
   336		if (ret == -EINPROGRESS)
   337			return ret;
   338	
   339		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
   340		for (i = 0; i < digsize / 4; i++)
   341			creq->state[i] = readl(engine->regs + CESA_IVDIG(i));
   342	
   343		if (creq->cache_ptr)
   344			sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
   345					   creq->cache,
   346					   creq->cache_ptr,
   347					   ahashreq->nbytes - creq->cache_ptr);
   348	
   349		if (creq->last_req) {
   350			for (i = 0; i < digsize / 4; i++) {
   351				/*
   352				 * Hardware provides MD5 digest in a different
   353				 * endianness than SHA-1 and SHA-256 ones.
   354				 */
   355				if (digsize == MD5_DIGEST_SIZE)
 > 356					creq->state[i] = cpu_to_le32(creq->state[i]);
   357				else
   358					creq->state[i] = cpu_to_be32(creq->state[i]);
   359			}

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
