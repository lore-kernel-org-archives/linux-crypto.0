Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B375FC4740A
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 23:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C81D222C0
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfJEXWu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 19:22:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:61483 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJEXWu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 19:22:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 16:22:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="392661069"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 05 Oct 2019 16:22:47 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGtNv-000AUl-2e; Sun, 06 Oct 2019 07:22:47 +0800
Date:   Sun, 6 Oct 2019 07:22:13 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 3/53]
 drivers/crypto/inside-secure/safexcel_hash.c:366:64: sparse: sparse: invalid
 assignment: ^=
Message-ID: <201910060712.zWd3lClS%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   4fd7d7befdb531920cae8f78afd4938e4a25e421
commit: 38f21b4bab11fc877ff18dd02f77f2c34f1105b9 [3/53] crypto: inside-secure - Added support for the AES XCBC ahash
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout 38f21b4bab11fc877ff18dd02f77f2c34f1105b9
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/inside-secure/safexcel_hash.c:366:64: sparse: sparse: invalid assignment: ^=
>> drivers/crypto/inside-secure/safexcel_hash.c:366:64: sparse:    left side has type unsigned int
>> drivers/crypto/inside-secure/safexcel_hash.c:366:64: sparse:    right side has type restricted __be32
>> drivers/crypto/inside-secure/safexcel_hash.c:798:50: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
>> drivers/crypto/inside-secure/safexcel_hash.c:798:50: sparse:    expected unsigned int [usertype]
   drivers/crypto/inside-secure/safexcel_hash.c:798:50: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_hash.c:1869:25: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/inside-secure/safexcel_hash.c:1869:25: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_hash.c:1869:25: sparse:    got restricted __le32 [usertype]
   drivers/crypto/inside-secure/safexcel_hash.c:1969:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_hash.c:1969:34: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_hash.c:1969:34: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_hash.c:2054:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_hash.c:2054:30: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_hash.c:2054:30: sparse:    got restricted __be32 [usertype]

vim +366 drivers/crypto/inside-secure/safexcel_hash.c

   296	
   297	static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
   298					   int *commands, int *results)
   299	{
   300		struct ahash_request *areq = ahash_request_cast(async);
   301		struct safexcel_ahash_req *req = ahash_request_ctx(areq);
   302		struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
   303		struct safexcel_crypto_priv *priv = ctx->priv;
   304		struct safexcel_command_desc *cdesc, *first_cdesc = NULL;
   305		struct safexcel_result_desc *rdesc;
   306		struct scatterlist *sg;
   307		int i, extra = 0, n_cdesc = 0, ret = 0, cache_len, skip = 0, res_sz;
   308		u64 queued, len;
   309	
   310		queued = safexcel_queued_len(req);
   311		if (queued <= HASH_CACHE_SIZE)
   312			cache_len = queued;
   313		else
   314			cache_len = queued - areq->nbytes;
   315	
   316		if (!req->finish && !req->last_req) {
   317			/* If this is not the last request and the queued data does not
   318			 * fit into full cache blocks, cache it for the next send call.
   319			 */
   320			extra = queued & (HASH_CACHE_SIZE - 1);
   321	
   322			/* If this is not the last request and the queued data
   323			 * is a multiple of a block, cache the last one for now.
   324			 */
   325			if (!extra)
   326				extra = HASH_CACHE_SIZE;
   327	
   328			sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
   329					   req->cache_next, extra,
   330					   areq->nbytes - extra);
   331	
   332			queued -= extra;
   333	
   334			if (!queued) {
   335				*commands = 0;
   336				*results = 0;
   337				return 0;
   338			}
   339	
   340			extra = 0;
   341		}
   342	
   343		if (unlikely(req->xcbcmac && req->processed > AES_BLOCK_SIZE)) {
   344			if (unlikely(cache_len < AES_BLOCK_SIZE)) {
   345				/*
   346				 * Cache contains less than 1 full block, complete.
   347				 */
   348				extra = AES_BLOCK_SIZE - cache_len;
   349				if (queued > cache_len) {
   350					/* More data follows: borrow bytes */
   351					u64 tmp = queued - cache_len;
   352	
   353					skip = min_t(u64, tmp, extra);
   354					sg_pcopy_to_buffer(areq->src,
   355						sg_nents(areq->src),
   356						req->cache + cache_len,
   357						skip, 0);
   358				}
   359				extra -= skip;
   360				memset(req->cache + cache_len + skip, 0, extra);
   361				if (!ctx->cbcmac && extra) {
   362					// 10- padding for XCBCMAC & CMAC
   363					req->cache[cache_len + skip] = 0x80;
   364					// HW will use K2 iso K3 - compensate!
   365					for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
 > 366						((u32 *)req->cache)[i] ^=
   367							cpu_to_be32(ctx->ipad[i]) ^
   368							cpu_to_be32(ctx->ipad[i + 4]);
   369				}
   370				cache_len = AES_BLOCK_SIZE;
   371				queued = queued + extra;
   372			}
   373	
   374			/* XCBC continue: XOR previous result into 1st word */
   375			crypto_xor(req->cache, (const u8 *)req->state, AES_BLOCK_SIZE);
   376		}
   377	
   378		len = queued;
   379		/* Add a command descriptor for the cached data, if any */
   380		if (cache_len) {
   381			req->cache_dma = dma_map_single(priv->dev, req->cache,
   382							cache_len, DMA_TO_DEVICE);
   383			if (dma_mapping_error(priv->dev, req->cache_dma))
   384				return -EINVAL;
   385	
   386			req->cache_sz = cache_len;
   387			first_cdesc = safexcel_add_cdesc(priv, ring, 1,
   388							 (cache_len == len),
   389							 req->cache_dma, cache_len,
   390							 len, ctx->base.ctxr_dma);
   391			if (IS_ERR(first_cdesc)) {
   392				ret = PTR_ERR(first_cdesc);
   393				goto unmap_cache;
   394			}
   395			n_cdesc++;
   396	
   397			queued -= cache_len;
   398			if (!queued)
   399				goto send_command;
   400		}
   401	
   402		/* Now handle the current ahash request buffer(s) */
   403		req->nents = dma_map_sg(priv->dev, areq->src,
   404					sg_nents_for_len(areq->src,
   405							 areq->nbytes),
   406					DMA_TO_DEVICE);
   407		if (!req->nents) {
   408			ret = -ENOMEM;
   409			goto cdesc_rollback;
   410		}
   411	
   412		for_each_sg(areq->src, sg, req->nents, i) {
   413			int sglen = sg_dma_len(sg);
   414	
   415			if (unlikely(sglen <= skip)) {
   416				skip -= sglen;
   417				continue;
   418			}
   419	
   420			/* Do not overflow the request */
   421			if ((queued + skip) <= sglen)
   422				sglen = queued;
   423			else
   424				sglen -= skip;
   425	
   426			cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
   427						   !(queued - sglen),
   428						   sg_dma_address(sg) + skip, sglen,
   429						   len, ctx->base.ctxr_dma);
   430			if (IS_ERR(cdesc)) {
   431				ret = PTR_ERR(cdesc);
   432				goto unmap_sg;
   433			}
   434	
   435			if (!n_cdesc)
   436				first_cdesc = cdesc;
   437			n_cdesc++;
   438	
   439			queued -= sglen;
   440			if (!queued)
   441				break;
   442			skip = 0;
   443		}
   444	
   445	send_command:
   446		/* Setup the context options */
   447		safexcel_context_control(ctx, req, first_cdesc);
   448	
   449		/* Add the token. Note that the XCBC result is only 1 AES block. */
   450		res_sz = req->xcbcmac ? AES_BLOCK_SIZE : req->state_sz;
   451		safexcel_hash_token(first_cdesc, len, res_sz, ctx->cbcmac);
   452	
   453		req->result_dma = dma_map_single(priv->dev, req->state, req->state_sz,
   454						 DMA_FROM_DEVICE);
   455		if (dma_mapping_error(priv->dev, req->result_dma)) {
   456			ret = -EINVAL;
   457			goto unmap_sg;
   458		}
   459	
   460		/* Add a result descriptor */
   461		rdesc = safexcel_add_rdesc(priv, ring, 1, 1, req->result_dma,
   462					   res_sz);
   463		if (IS_ERR(rdesc)) {
   464			ret = PTR_ERR(rdesc);
   465			goto unmap_result;
   466		}
   467	
   468		safexcel_rdr_req_set(priv, ring, rdesc, &areq->base);
   469	
   470		req->processed += len - extra;
   471	
   472		*commands = n_cdesc;
   473		*results = 1;
   474		return 0;
   475	
   476	unmap_result:
   477		dma_unmap_single(priv->dev, req->result_dma, req->state_sz,
   478				 DMA_FROM_DEVICE);
   479	unmap_sg:
   480		if (req->nents) {
   481			dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
   482			req->nents = 0;
   483		}
   484	cdesc_rollback:
   485		for (i = 0; i < n_cdesc; i++)
   486			safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
   487	unmap_cache:
   488		if (req->cache_dma) {
   489			dma_unmap_single(priv->dev, req->cache_dma, req->cache_sz,
   490					 DMA_TO_DEVICE);
   491			req->cache_dma = 0;
   492			req->cache_sz = 0;
   493		}
   494	
   495		return ret;
   496	}
   497	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
