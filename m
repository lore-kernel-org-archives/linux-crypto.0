Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645FC1D5175;
	Sat, 26 Oct 2024 12:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729944910; cv=none; b=hu96x0S1+mwor2XrGZ11bWGzLbk4ALIL0CVcMWVih/flPm9J+ioFDypo50W8mVKgWmhFDPrLrBmTF1shWaFGgM131v5bepa3LBaIahNV+Uov7tBZlIaZItNqzgOUfG+T1H7jWzh3/nzcvprnIdUvDVnarWO5exoMjqdswb9yiGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729944910; c=relaxed/simple;
	bh=2nTmWXBaxd8HmKSp49DDYnZi3FLIHlutHgR4SdKYiVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQXFQ5e7bxixTFh7704EF5mXGU3Jeo4ebsaj1hkWLKLPmHEl7m4oTnmaw5k1hUEg91hHpeh6Fib12VlNGlrg5Muv7NeWPN2Pk4eO9HwwZKuEC/IlLpUqkSJztWaUC2AfT2D/Uta7OYai8jg8FagT9RWtquCjMkwe2BQP1TPOqnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNORLFOn; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNORLFOn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729944908; x=1761480908;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2nTmWXBaxd8HmKSp49DDYnZi3FLIHlutHgR4SdKYiVQ=;
  b=BNORLFOnoexFmANlnbmIvTHFjfpg91MZEYk3RBW8fCE97NvvhRY5mL6/
   eZXGhUyyofckwaods0h+JEG4kQhzZF1FmAQqvmI08lbl3IuiqVi/uM9fL
   fPw95IwZyw8Q0B15s14PvZAKmkHDu+XWaZUwtlGK//gBGdtKa8j1FGSZA
   7VQ0W8JHPVj/60eQRXwbchfioyaTODcOHanonsh8/Txfm4lS/M26VhLR7
   gRPFCno6w/Y8S2LyOVP764CyCqFNHjgvo2BdycS1rMvPENVThuu+5YAnY
   lnJ0GcaumfeLfNPHF+Lw018BiFmdA0Sj9esczijeYCpcsBhOebRv1zNly
   Q==;
X-CSE-ConnectionGUID: Mm0IjClPRGeL2qCjcHZUMg==
X-CSE-MsgGUID: EFTtaXw0S3m+CKpsSg+Dhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11237"; a="29819673"
X-IronPort-AV: E=Sophos;i="6.11,235,1725346800"; 
   d="scan'208";a="29819673"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2024 05:15:07 -0700
X-CSE-ConnectionGUID: Q7BgeC7sR4ytrV0kbV/ZPA==
X-CSE-MsgGUID: ElFcr9VUQkqa/OyvaweKTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,235,1725346800"; 
   d="scan'208";a="81206440"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 26 Oct 2024 05:15:01 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4fh4-000Zcc-2C;
	Sat, 26 Oct 2024 12:14:58 +0000
Date: Sat, 26 Oct 2024 20:14:42 +0800
From: kernel test robot <lkp@intel.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v4 3/3] crypto: Add Mediatek EIP-93 crypto engine support
Message-ID: <202410261900.DyTk6FZW-lkp@intel.com>
References: <20241025094734.1614-3-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025094734.1614-3-ansuelsmth@gmail.com>

Hi Christian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master tip/locking/core linus/master v6.12-rc4 next-20241025]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Marangi/dt-bindings-crypto-Add-Inside-Secure-SafeXcel-EIP-93-crypto-engine/20241025-175032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241025094734.1614-3-ansuelsmth%40gmail.com
patch subject: [PATCH v4 3/3] crypto: Add Mediatek EIP-93 crypto engine support
config: powerpc64-randconfig-r123-20241026 (https://download.01.org/0day-ci/archive/20241026/202410261900.DyTk6FZW-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 14.1.0
reproduce: (https://download.01.org/0day-ci/archive/20241026/202410261900.DyTk6FZW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410261900.DyTk6FZW-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/inside-secure/eip93/eip93-hash.c:423:37: sparse: sparse: cast to restricted __be32
>> drivers/crypto/inside-secure/eip93/eip93-hash.c:596:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] @@     got restricted __be32 [usertype] @@
   drivers/crypto/inside-secure/eip93/eip93-hash.c:596:38: sparse:     expected unsigned int [usertype]
   drivers/crypto/inside-secure/eip93/eip93-hash.c:596:38: sparse:     got restricted __be32 [usertype]
--
>> drivers/crypto/inside-secure/eip93/eip93-common.c:542:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int @@     got restricted __be32 [usertype] @@
   drivers/crypto/inside-secure/eip93/eip93-common.c:542:39: sparse:     expected unsigned int
   drivers/crypto/inside-secure/eip93/eip93-common.c:542:39: sparse:     got restricted __be32 [usertype]
>> drivers/crypto/inside-secure/eip93/eip93-common.c:546:23: sparse: sparse: cast to restricted __be32
   drivers/crypto/inside-secure/eip93/eip93-common.c:668:43: sparse: sparse: cast to restricted __be32
>> drivers/crypto/inside-secure/eip93/eip93-common.c:811:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] @@     got restricted __be32 [usertype] @@
   drivers/crypto/inside-secure/eip93/eip93-common.c:811:38: sparse:     expected unsigned int [usertype]
   drivers/crypto/inside-secure/eip93/eip93-common.c:811:38: sparse:     got restricted __be32 [usertype]
   drivers/crypto/inside-secure/eip93/eip93-common.c:812:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] @@     got restricted __be32 [usertype] @@
   drivers/crypto/inside-secure/eip93/eip93-common.c:812:38: sparse:     expected unsigned int [usertype]
   drivers/crypto/inside-secure/eip93/eip93-common.c:812:38: sparse:     got restricted __be32 [usertype]
   drivers/crypto/inside-secure/eip93/eip93-common.c:101:5: sparse: sparse: context imbalance in 'eip93_put_descriptor' - wrong count at exit
   drivers/crypto/inside-secure/eip93/eip93-common.c:127:6: sparse: sparse: context imbalance in 'eip93_get_descriptor' - wrong count at exit

vim +423 drivers/crypto/inside-secure/eip93/eip93-hash.c

   396	
   397	void eip93_hash_handle_result(struct crypto_async_request *async, int err)
   398	{
   399		struct ahash_request *req = ahash_request_cast(async);
   400		struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
   401		struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
   402		struct eip93_hash_ctx *ctx = crypto_ahash_ctx(ahash);
   403		int digestsize = crypto_ahash_digestsize(ahash);
   404		struct sa_state *sa_state = rctx->sa_state;
   405		int i;
   406	
   407		/* Unmap and sync sa_state for host */
   408		dma_unmap_single(rctx->mtk->dev, rctx->sa_state_base,
   409				 sizeof(*sa_state), DMA_FROM_DEVICE);
   410	
   411		/*
   412		 * With no_finalize assume SHA256_DIGEST_SIZE buffer is passed.
   413		 * This is to handle SHA224 that have a 32 byte intermediate digest.
   414		 */
   415		if (rctx->no_finalize)
   416			digestsize = SHA256_DIGEST_SIZE;
   417	
   418		/* bytes needs to be swapped for req->result */
   419		if (!IS_HASH_MD5(ctx->flags)) {
   420			for (i = 0; i < digestsize / sizeof(u32); i++) {
   421				u32 *digest = (u32 *)sa_state->state_i_digest;
   422	
 > 423				digest[i] = be32_to_cpu(digest[i]);
   424			}
   425		}
   426	
   427		memcpy(req->result, sa_state->state_i_digest, digestsize);
   428	
   429		kfree(sa_state);
   430		eip93_hash_free_data_blocks(req);
   431		eip93_hash_free_sa_record(req);
   432	
   433		ahash_request_complete(req, err);
   434	}
   435	
   436	static int eip93_hash_final(struct ahash_request *req)
   437	{
   438		struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
   439		struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
   440		struct eip93_hash_ctx *ctx = crypto_ahash_ctx(ahash);
   441		struct crypto_async_request *async = &req->base;
   442		struct eip93_device *mtk = rctx->mtk;
   443		struct mkt_hash_block *block;
   444		int ret;
   445	
   446		/* EIP93 can't handle zero bytes hash */
   447		if (!rctx->len && !IS_HMAC(ctx->flags)) {
   448			switch ((ctx->flags & EIP93_HASH_MASK)) {
   449			case EIP93_HASH_SHA256:
   450				memcpy(req->result, sha256_zero_message_hash,
   451				       SHA256_DIGEST_SIZE);
   452				break;
   453			case EIP93_HASH_SHA224:
   454				memcpy(req->result, sha224_zero_message_hash,
   455				       SHA224_DIGEST_SIZE);
   456				break;
   457			case EIP93_HASH_SHA1:
   458				memcpy(req->result, sha1_zero_message_hash,
   459				       SHA1_DIGEST_SIZE);
   460				break;
   461			case EIP93_HASH_MD5:
   462				memcpy(req->result, md5_zero_message_hash,
   463				       MD5_DIGEST_SIZE);
   464				break;
   465			default: /* Impossible */
   466				return -EINVAL;
   467			}
   468	
   469			eip93_hash_free_sa_state(req);
   470			eip93_hash_free_sa_record(req);
   471	
   472			return 0;
   473		}
   474	
   475		/* Send last block */
   476		block = list_first_entry(&rctx->blocks, struct mkt_hash_block, list);
   477	
   478		block->data_dma = dma_map_single(mtk->dev, block->data,
   479						 SHA256_BLOCK_SIZE, DMA_TO_DEVICE);
   480		ret = dma_mapping_error(mtk->dev, block->data_dma);
   481		if (ret)
   482			return ret;
   483	
   484		eip93_send_hash_req(async, block->data_dma,
   485				    SHA256_BLOCK_SIZE - rctx->left_last,
   486				    true);
   487	
   488		return -EINPROGRESS;
   489	}
   490	
   491	static int eip93_hash_finup(struct ahash_request *req)
   492	{
   493		int ret;
   494	
   495		ret = eip93_hash_update(req);
   496		if (ret)
   497			return ret;
   498	
   499		return eip93_hash_final(req);
   500	}
   501	
   502	static int eip93_hash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
   503					  u32 keylen)
   504	{
   505		unsigned int digestsize = crypto_ahash_digestsize(ahash);
   506		struct crypto_tfm *tfm = crypto_ahash_tfm(ahash);
   507		struct eip93_hash_ctx *ctx = crypto_tfm_ctx(tfm);
   508		struct crypto_ahash *ahash_tfm;
   509		struct eip93_hash_reqctx *rctx;
   510		struct scatterlist sg[1];
   511		struct ahash_request *req;
   512		DECLARE_CRYPTO_WAIT(wait);
   513		const char *alg_name;
   514		int i, ret = 0;
   515		u8 *opad;
   516	
   517		switch ((ctx->flags & EIP93_HASH_MASK)) {
   518		case EIP93_HASH_SHA256:
   519			alg_name = "sha256-eip93";
   520			break;
   521		case EIP93_HASH_SHA224:
   522			alg_name = "sha224-eip93";
   523			break;
   524		case EIP93_HASH_SHA1:
   525			alg_name = "sha1-eip93";
   526			break;
   527		case EIP93_HASH_MD5:
   528			alg_name = "md5-eip93";
   529			break;
   530		default: /* Impossible */
   531			return -EINVAL;
   532		}
   533	
   534		ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
   535		if (IS_ERR(ahash_tfm))
   536			return PTR_ERR(ahash_tfm);
   537	
   538		req = ahash_request_alloc(ahash_tfm, GFP_KERNEL);
   539		if (!req) {
   540			ret = -ENOMEM;
   541			goto err_ahash;
   542		}
   543	
   544		opad = kzalloc(SHA256_BLOCK_SIZE, GFP_KERNEL);
   545		if (!opad) {
   546			ret = -ENOMEM;
   547			goto err_req;
   548		}
   549	
   550		rctx = ahash_request_ctx(req);
   551		crypto_init_wait(&wait);
   552		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
   553					   crypto_req_done, &wait);
   554	
   555		/* Hash the key if > SHA256_BLOCK_SIZE */
   556		if (keylen > SHA256_BLOCK_SIZE) {
   557			sg_init_one(&sg[0], key, keylen);
   558	
   559			ahash_request_set_crypt(req, sg, ctx->ipad, keylen);
   560			ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
   561	
   562			keylen = digestsize;
   563		} else {
   564			memcpy(ctx->ipad, key, keylen);
   565		}
   566	
   567		/* Copy to opad */
   568		memset(ctx->ipad + keylen, 0, SHA256_BLOCK_SIZE - keylen);
   569		memcpy(opad, ctx->ipad, SHA256_BLOCK_SIZE);
   570	
   571		/* Pad with HMAC constants */
   572		for (i = 0; i < SHA256_BLOCK_SIZE; i++) {
   573			ctx->ipad[i] ^= HMAC_IPAD_VALUE;
   574			opad[i] ^= HMAC_OPAD_VALUE;
   575		}
   576	
   577		sg_init_one(&sg[0], opad, SHA256_BLOCK_SIZE);
   578	
   579		/* Hash opad */
   580		ahash_request_set_crypt(req, sg, ctx->opad, SHA256_BLOCK_SIZE);
   581		ret = crypto_ahash_init(req);
   582		if (ret)
   583			goto exit;
   584	
   585		/* Disable HASH_FINALIZE for opad hash */
   586		rctx->no_finalize = true;
   587	
   588		ret = crypto_wait_req(crypto_ahash_finup(req), &wait);
   589		if (ret)
   590			goto exit;
   591	
   592		if (!IS_HASH_MD5(ctx->flags)) {
   593			u32 *opad_hash = (u32 *)ctx->opad;
   594	
   595			for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(u32); i++)
 > 596				opad_hash[i] = cpu_to_be32(opad_hash[i]);
   597		}
   598	
   599	exit:
   600		kfree(opad);
   601	err_req:
   602		ahash_request_free(req);
   603	err_ahash:
   604		crypto_free_ahash(ahash_tfm);
   605	
   606		return ret;
   607	}
   608	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
