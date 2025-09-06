Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC62550A4;
	Sat,  6 Sep 2025 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757186543; cv=none; b=Gc8ZxyGCQETJqQlq43sEXAMFIuhNk9FjD4kTrFQGg8QnqmlwlMuINgPdkGIjX/6nr7p0zypfbjcU5JUxez2komEWHiCH+lEmSao2xMyTL0tgKJmMwBUR917wc7Lg6ubYILZBY1KpN7mNaT4OOmqWQfY3RyX1F8jAeClIyjznr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757186543; c=relaxed/simple;
	bh=PG93cAu1Xu9wl1cfjEqbuP7XLKHbpHXEiceV7SE9Rww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjqEGbvoUZGP86CnSeRMXBh4dQkzjGe5jJdTfSnryQ2RHHQgFX2ogm7r/6dsTXPubA9YAwBIWuLCs6DpMg4s/CcjFtpKEm5E6xu20zjYUoePvJMkCm6KebgxU+ZtOEf0RlmE/RLKb3WWzBrWlaDShWG5SJPQXUDENMLf0Z9p8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMP6Bquu; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMP6Bquu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757186541; x=1788722541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PG93cAu1Xu9wl1cfjEqbuP7XLKHbpHXEiceV7SE9Rww=;
  b=PMP6BquuEU7aP5pBrG8g1S/uAdqPqJ82g17MEutacbHue82sqYpKuIXi
   wRVnBntvFNOvFfFUoAlITg7tyIFQ3oourMMTcwvQk/XzZ0e6dah1hJ9tZ
   VKvyLHXbiX3vD/8eh+JWYnJdOJnRU7Xwof/UEzVfZQQq7WMQwup4CqwbZ
   CX05Ew0Uhca5YhZsiJrhD1q/lqnNfFA5ro16n2cHe4lKADjo/6469snt1
   +4Pl3XtykLttCQbbS9zDlhe+6/9BENe1b1gmobSHzmB1Dz1Rht7E+0P2q
   vPUGEjnQvkGjU6sYbTpsOwveSj1XeROupf87d1PgIE195rYPE0YpwP1mN
   A==;
X-CSE-ConnectionGUID: R1MpYRzATiiQQM6nafVB9g==
X-CSE-MsgGUID: dKHaX/AiSKSYx794eJIoFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11545"; a="77115273"
X-IronPort-AV: E=Sophos;i="6.18,244,1751266800"; 
   d="scan'208";a="77115273"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2025 12:22:20 -0700
X-CSE-ConnectionGUID: wWzejtnrRHipVevferClww==
X-CSE-MsgGUID: e1d9xfwOTeSfjAI16doFWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,244,1751266800"; 
   d="scan'208";a="196090478"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 06 Sep 2025 12:22:17 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuyUJ-0001l1-0m;
	Sat, 06 Sep 2025 19:22:15 +0000
Date: Sun, 7 Sep 2025 03:21:49 +0800
From: kernel test robot <lkp@intel.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] crypto: ti: Add support for AES-CCM in DTHEv2 driver
Message-ID: <202509070251.7MfOWGUB-lkp@intel.com>
References: <20250905133504.2348972-8-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905133504.2348972-8-t-pratham@ti.com>

Hi Pratham,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250905]
[cannot apply to herbert-crypto-2.6/master linus/master v6.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/T-Pratham/crypto-ti-Add-support-for-AES-XTS-in-DTHEv2-driver/20250905-214245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250905133504.2348972-8-t-pratham%40ti.com
patch subject: [PATCH 4/4] crypto: ti: Add support for AES-CCM in DTHEv2 driver
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20250907/202509070251.7MfOWGUB-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250907/202509070251.7MfOWGUB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509070251.7MfOWGUB-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/ti/dthev2-aes.c:818:7: warning: variable 'unpadded_cryptlen' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     818 |                 if (!dst) {
         |                     ^~~~
   drivers/crypto/ti/dthev2-aes.c:962:6: note: uninitialized use occurs here
     962 |         if (unpadded_cryptlen % AES_BLOCK_SIZE)
         |             ^~~~~~~~~~~~~~~~~
   drivers/crypto/ti/dthev2-aes.c:818:3: note: remove the 'if' if its condition is always false
     818 |                 if (!dst) {
         |                 ^~~~~~~~~~~
     819 |                         ret = -ENOMEM;
         |                         ~~~~~~~~~~~~~~
     820 |                         goto aead_prep_dst_err;
         |                         ~~~~~~~~~~~~~~~~~~~~~~~
     821 |                 }
         |                 ~
   drivers/crypto/ti/dthev2-aes.c:779:32: note: initialize the variable 'unpadded_cryptlen' to silence this warning
     779 |         unsigned int unpadded_cryptlen;
         |                                       ^
         |                                        = 0
>> drivers/crypto/ti/dthev2-aes.c:995:49: warning: result of comparison of constant 2305843009213693951 with expression of type 'unsigned int' is always false [-Wtautological-constant-out-of-range-compare]
     995 |             (ctx->aes_mode == DTHE_AES_CCM && cryptlen > DTHE_AES_CCM_CRYPT_MAXLEN)) {
         |                                               ~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~
   2 warnings generated.


vim +995 drivers/crypto/ti/dthev2-aes.c

   973	
   974	static int dthe_aead_crypt(struct aead_request *req)
   975	{
   976		struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
   977		struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
   978		struct dthe_data *dev_data = dthe_get_dev(ctx);
   979		struct crypto_engine *engine;
   980		unsigned int cryptlen = req->cryptlen;
   981	
   982		// In decryption, last authsize bytes are the TAG
   983		if (!rctx->enc)
   984			cryptlen -= ctx->authsize;
   985	
   986		/* Need to fallback to software in the following cases due to HW restrictions:
   987		 * - Both AAD and plaintext/ciphertext are zero length
   988		 * - For AES-GCM, AAD length is more than 2^32 - 1 bytes
   989		 * - For AES-CCM, AAD length is more than 2^16 - 2^8 bytes
   990		 * - For AES-CCM, ciphertext length is more than 2^61 - 1 bytes
   991		 */
   992		if ((req->assoclen == 0 && cryptlen == 0) ||
   993		    (ctx->aes_mode == DTHE_AES_GCM && req->assoclen > DTHE_AES_GCM_AAD_MAXLEN) ||
   994		    (ctx->aes_mode == DTHE_AES_CCM && req->assoclen > DTHE_AES_CCM_AAD_MAXLEN) ||
 > 995		    (ctx->aes_mode == DTHE_AES_CCM && cryptlen > DTHE_AES_CCM_CRYPT_MAXLEN)) {
   996			struct aead_request *subreq = &rctx->fb_req;
   997			int ret;
   998	
   999			aead_request_set_tfm(subreq, ctx->aead_fb);
  1000			aead_request_set_callback(subreq, req->base.flags,
  1001						  req->base.complete, req->base.data);
  1002			aead_request_set_crypt(subreq, req->src, req->dst,
  1003					       req->cryptlen, req->iv);
  1004			aead_request_set_ad(subreq, req->assoclen);
  1005	
  1006			ret = rctx->enc ? crypto_aead_encrypt(subreq) :
  1007				crypto_aead_decrypt(subreq);
  1008	
  1009			return ret;
  1010		}
  1011	
  1012		engine = dev_data->engine;
  1013		return crypto_transfer_aead_request_to_engine(engine, req);
  1014	}
  1015	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
