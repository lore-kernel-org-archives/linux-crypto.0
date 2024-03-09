Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8422EED
	for <linux-crypto@vger.kernel.org>; Sat,  9 Mar 2024 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709973744; cv=none; b=ULPAlE5AuzrbnOtXSdqlPT9ZXftsk+C6nu2k6Pc4fDQCgbf8XxYREIjPnHu/BV1ANH5NxyvUyE3G+NAKkGfrXFkFzc/+uQV4DNp8BRTrlgxNurv+GKd7d7Y87rF6MHdvsHrSCduNTtGC3zsK/cIlmIeUe64w52XtLM4OYvLgayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709973744; c=relaxed/simple;
	bh=GJ+XCHb1Zm/gTMEvDcf71lf7l1jbXIQqYljMRF3mSSU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cL+Pqm5akIv2QLdN84EGverL8+pR1NVMhC7NIq4/biw3G4pP+Zc11ruUKnADqCpsr0KD3jdQLUORz46q2SNS8IrI0SIGMClIyhZIrtcigc/wX7VvqNmRyeCEDB35fZ43eGzKr+u92DbGPBpqwIHe81bfsVeguD/ar5glhwcuJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmCJrLM2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmCJrLM2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709973742; x=1741509742;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=GJ+XCHb1Zm/gTMEvDcf71lf7l1jbXIQqYljMRF3mSSU=;
  b=QmCJrLM2UXKeZX2CMEWFLE5G6n94/DaKbmw+WmnZDlg0dqQAOZPPT9Kt
   qyD6L1m0Nef2DgGEVaq9B2hcTsWvKNKYSXc3vYQJQT8GIguwi+rH/Mit/
   WagodEkNyEzfzT0UsbLU8Putj2Kt5V/PpihvHz3i1ikpuPlVIPYPkjQer
   S7IKmL6O4R6e1wnlVm0Ys8m9dpah1VpQg3hXN24EvqDx1cEczx5Cholyh
   ZhNZhWnkXl2lpDZnBto5J1d+HDzhWvdKn3hO1NFe7eOxBj+XnmPHFAm5p
   7FeAGfg/dk8a4E3ZyNm1RXKHnhJq2T6LO9pIhsgOgJg0IuQGwKIUzypmk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="27170680"
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="27170680"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 00:42:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="11119588"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 09 Mar 2024 00:42:20 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1risHZ-0007Ab-1Y;
	Sat, 09 Mar 2024 08:42:17 +0000
Date: Sat, 9 Mar 2024 16:42:07 +0800
From: kernel test robot <lkp@intel.com>
To: Barry Song <v-songbaohua@oppo.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 80/80] crypto/scompress.c:174:38:
 warning: unused variable 'dst_page'
Message-ID: <202403091614.NeUw5zcv-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   77292bb8ca69c808741aadbd29207605296e24af
commit: 77292bb8ca69c808741aadbd29207605296e24af [80/80] crypto: scomp - remove memcpy if sg_nents is 1 and pages are lowmem
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240309/202403091614.NeUw5zcv-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240309/202403091614.NeUw5zcv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403091614.NeUw5zcv-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from crypto/scompress.c:12:
   include/crypto/scatterwalk.h: In function 'scatterwalk_pagedone':
   include/crypto/scatterwalk.h:76:30: warning: variable 'page' set but not used [-Wunused-but-set-variable]
      76 |                 struct page *page;
         |                              ^~~~
   crypto/scompress.c: In function 'scomp_acomp_comp_decomp':
>> crypto/scompress.c:174:38: warning: unused variable 'dst_page' [-Wunused-variable]
     174 |                         struct page *dst_page = sg_page(req->dst);
         |                                      ^~~~~~~~


vim +/dst_page +174 crypto/scompress.c

   112	
   113	static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
   114	{
   115		struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
   116		void **tfm_ctx = acomp_tfm_ctx(tfm);
   117		struct crypto_scomp *scomp = *tfm_ctx;
   118		void **ctx = acomp_request_ctx(req);
   119		struct scomp_scratch *scratch;
   120		void *src, *dst;
   121		unsigned int dlen;
   122		int ret;
   123	
   124		if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
   125			return -EINVAL;
   126	
   127		if (req->dst && !req->dlen)
   128			return -EINVAL;
   129	
   130		if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
   131			req->dlen = SCOMP_SCRATCH_SIZE;
   132	
   133		dlen = req->dlen;
   134	
   135		scratch = raw_cpu_ptr(&scomp_scratch);
   136		spin_lock(&scratch->lock);
   137	
   138		if (sg_nents(req->src) == 1 && !PageHighMem(sg_page(req->src))) {
   139			src = page_to_virt(sg_page(req->src)) + req->src->offset;
   140		} else {
   141			scatterwalk_map_and_copy(scratch->src, req->src, 0,
   142						 req->slen, 0);
   143			src = scratch->src;
   144		}
   145	
   146		if (req->dst && sg_nents(req->dst) == 1 && !PageHighMem(sg_page(req->dst)))
   147			dst = page_to_virt(sg_page(req->dst)) + req->dst->offset;
   148		else
   149			dst = scratch->dst;
   150	
   151		if (dir)
   152			ret = crypto_scomp_compress(scomp, src, req->slen,
   153						    dst, &req->dlen, *ctx);
   154		else
   155			ret = crypto_scomp_decompress(scomp, src, req->slen,
   156						      dst, &req->dlen, *ctx);
   157		if (!ret) {
   158			if (!req->dst) {
   159				req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
   160				if (!req->dst) {
   161					ret = -ENOMEM;
   162					goto out;
   163				}
   164			} else if (req->dlen > dlen) {
   165				ret = -ENOSPC;
   166				goto out;
   167			}
   168			if (dst == scratch->dst) {
   169				scatterwalk_map_and_copy(scratch->dst, req->dst, 0,
   170							 req->dlen, 1);
   171			} else {
   172				int nr_pages = DIV_ROUND_UP(req->dst->offset + req->dlen, PAGE_SIZE);
   173				int i;
 > 174				struct page *dst_page = sg_page(req->dst);
   175	
   176				for (i = 0; i < nr_pages; i++)
   177					flush_dcache_page(dst_page + i);
   178			}
   179		}
   180	out:
   181		spin_unlock(&scratch->lock);
   182		return ret;
   183	}
   184	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
