Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8753923AB81
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750676140; cv=none; b=cTObY3AsnNmuYAYk/tTSFaRAuCkAkR9KjN0DednMAGfzx84Wo/i0cYOJLnOhFO07lLK4eZ1w+OX+r3UBXHFnGZPC6LcCxdJnIHB0FWmO1JF8cZffMPNiUPg9a/R9g6RiUlXFRGPfUyR0hRGQsOkOi57ol2RMWRGJyRCOiBxTrW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750676140; c=relaxed/simple;
	bh=kuqz1UH4mU07lApOh4u1QNYszUKmEc/6AE2nlZkskYs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UHRYpms5UNIRmYqdzwn6S8AuxqEXWddmECqi6WxVWDJhlAyYnFaoFd+toc3aw+lE/uuLAOLJzvXuNv8Ajiis1HpJ1wxmDxa3lOF1Vdaf9j3oPzdNHEaIMOm7B5cKB95vSup2MY802vNhVgYF1lfbY0s233MOM3BNeOCpcPYuKxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jee781Ya; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jee781Ya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750676138; x=1782212138;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=kuqz1UH4mU07lApOh4u1QNYszUKmEc/6AE2nlZkskYs=;
  b=jee781YaRbYDUSu36oxMh7eBBx6f1FUnmvpXWuPUImIxtD5loYTQuhMK
   KhJ0nDKjA9/0Bu1yQgrIxxKep6DFEWzSVFlWjE5RW5q/v1cDM48mrZyC8
   h95BZW+1GpmkcDKg2/radriSLc4TzNFd8Ve1u0mh6JRVph+pQmNvG+4ui
   JO5/5OkT/4JygEX0pRmR03rhyzPu8MnBTJqwSnhATHxdcjxiMbAug4VGs
   cl5q85sqh/JQP16CVbChiCZGONsQgIWng733O1Mv2KG7RJR396CdnjPxn
   gVF7JtoIHEGQhEo+C6hBq0KijBf9S/DWRZGWKqE86HtklG5EDEssSfDtA
   A==;
X-CSE-ConnectionGUID: +UH4bWzzSuOCtYhIHEr82Q==
X-CSE-MsgGUID: XJnfdTKVTGmu9CFqw/o4Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="70445608"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="70445608"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 03:55:38 -0700
X-CSE-ConnectionGUID: oDootPeNQN+FShEmERMWoQ==
X-CSE-MsgGUID: G0zOekpcTNKx81SXDc97Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="152078359"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 23 Jun 2025 03:55:37 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uTepq-000NyA-2A;
	Mon, 23 Jun 2025 10:55:34 +0000
Date: Mon, 23 Jun 2025 18:55:06 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 11/61]
 drivers/crypto/aspeed/aspeed-hace-hash.c:443 aspeed_ahash_fallback() warn:
 inconsistent indenting
Message-ID: <202506231830.us4hiwlZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   82a0302e7167d0b7c6cde56613db3748f8dd806d
commit: 508712228696eaddc4efc706e6a8dd679654f339 [11/61] crypto: aspeed/hash - Add fallback
config: arm-randconfig-r073-20250623 (https://download.01.org/0day-ci/archive/20250623/202506231830.us4hiwlZ-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506231830.us4hiwlZ-lkp@intel.com/

smatch warnings:
drivers/crypto/aspeed/aspeed-hace-hash.c:443 aspeed_ahash_fallback() warn: inconsistent indenting

vim +443 drivers/crypto/aspeed/aspeed-hace-hash.c

   422	
   423	static noinline int aspeed_ahash_fallback(struct ahash_request *req)
   424	{
   425		struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
   426		HASH_FBREQ_ON_STACK(fbreq, req);
   427		u8 *state = rctx->buffer;
   428		struct scatterlist sg[2];
   429		struct scatterlist *ssg;
   430		int ret;
   431	
   432		ssg = scatterwalk_ffwd(sg, req->src, rctx->offset);
   433		ahash_request_set_crypt(fbreq, ssg, req->result,
   434					rctx->total - rctx->offset);
   435	
   436		ret = aspeed_sham_export(req, state) ?:
   437		      crypto_ahash_import_core(fbreq, state);
   438	
   439		if (rctx->flags & SHA_FLAGS_FINUP)
   440			ret = ret ?: crypto_ahash_finup(fbreq);
   441		else
   442			ret = ret ?: crypto_ahash_update(fbreq);
 > 443				     crypto_ahash_export_core(fbreq, state) ?:
   444				     aspeed_sham_import(req, state);
   445		HASH_REQUEST_ZERO(fbreq);
   446		return ret;
   447	}
   448	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
