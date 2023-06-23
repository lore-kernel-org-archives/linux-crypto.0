Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDFDEB64DD
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 11:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjFWLXU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjFWLXU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 07:23:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E361739
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 04:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687519398; x=1719055398;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4iviLU/caHFtySDgBtufB71/+hgqsJXxNKmvZUx7wfE=;
  b=I7T9zZ71l5ZylKpIZTUAaOsyevWwzlYkphI6jUMDromBr8WPjEs+WfJP
   qnxrDsRoTe/2TMfpbdMgZc8hdci/LQ4L7QBvVoXQbmxEDq78b8RsNCAQ4
   Xi5fXuzpNuqpcCqdkKDdfyZ209hEKZlSNVKcCCl2trtvhObvbJNjLbFCg
   +Pb1qhLOQpy1paAFgf4WfogbfQVE0bIuXjtv813PCrb6LGtckNyOKlKQn
   mVsdjX+e91CDe0N8zySus3QDG7+Lt2l2Vj4htMN66wokUHMNdbFpM4Hr5
   WtwbBeVnV1DqqSYIZwSmja1rmLAY67lQI9MjyMBsqxNpaEGViR/+gslLA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358234670"
X-IronPort-AV: E=Sophos;i="6.01,151,1684825200"; 
   d="scan'208";a="358234670"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 04:23:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718470710"
X-IronPort-AV: E=Sophos;i="6.01,151,1684825200"; 
   d="scan'208";a="718470710"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2023 04:23:07 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qCesc-0008EV-0d;
        Fri, 23 Jun 2023 11:23:06 +0000
Date:   Fri, 23 Jun 2023 19:22:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 76/81]
 crypto/asymmetric_keys/x509_public_key.c:70: undefined reference to
 `sm2_compute_z_digest'
Message-ID: <202306231917.utO12sx8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   b335f258e8ddafec0e8ae2201ca78d29ed8f85eb
commit: e5221fa6a355112ddcc29dc82a94f7c3a1aacc0b [76/81] KEYS: asymmetric: Move sm2 code into x509_public_key
config: nios2-randconfig-r031-20230622 (https://download.01.org/0day-ci/archive/20230623/202306231917.utO12sx8-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230623/202306231917.utO12sx8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306231917.utO12sx8-lkp@intel.com/

All errors (new ones prefixed by >>):

   nios2-linux-ld: crypto/asymmetric_keys/x509_public_key.o: in function `x509_get_sig_params':
>> crypto/asymmetric_keys/x509_public_key.c:70: undefined reference to `sm2_compute_z_digest'
   crypto/asymmetric_keys/x509_public_key.c:70:(.text+0x34c): relocation truncated to fit: R_NIOS2_CALL26 against `sm2_compute_z_digest'


vim +70 crypto/asymmetric_keys/x509_public_key.c

    20	
    21	/*
    22	 * Set up the signature parameters in an X.509 certificate.  This involves
    23	 * digesting the signed data and extracting the signature.
    24	 */
    25	int x509_get_sig_params(struct x509_certificate *cert)
    26	{
    27		struct public_key_signature *sig = cert->sig;
    28		struct crypto_shash *tfm;
    29		struct shash_desc *desc;
    30		size_t desc_size;
    31		int ret;
    32	
    33		pr_devel("==>%s()\n", __func__);
    34	
    35		sig->s = kmemdup(cert->raw_sig, cert->raw_sig_size, GFP_KERNEL);
    36		if (!sig->s)
    37			return -ENOMEM;
    38	
    39		sig->s_size = cert->raw_sig_size;
    40	
    41		/* Allocate the hashing algorithm we're going to need and find out how
    42		 * big the hash operational data will be.
    43		 */
    44		tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
    45		if (IS_ERR(tfm)) {
    46			if (PTR_ERR(tfm) == -ENOENT) {
    47				cert->unsupported_sig = true;
    48				return 0;
    49			}
    50			return PTR_ERR(tfm);
    51		}
    52	
    53		desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
    54		sig->digest_size = crypto_shash_digestsize(tfm);
    55	
    56		ret = -ENOMEM;
    57		sig->digest = kmalloc(sig->digest_size, GFP_KERNEL);
    58		if (!sig->digest)
    59			goto error;
    60	
    61		desc = kzalloc(desc_size, GFP_KERNEL);
    62		if (!desc)
    63			goto error;
    64	
    65		desc->tfm = tfm;
    66	
    67		if (strcmp(cert->pub->pkey_algo, "sm2") == 0) {
    68			ret = strcmp(sig->hash_algo, "sm3") != 0 ? -EINVAL :
    69			      crypto_shash_init(desc) ?:
  > 70			      sm2_compute_z_digest(desc, cert->pub->key,
    71						   cert->pub->keylen, sig->digest) ?:
    72			      crypto_shash_init(desc) ?:
    73			      crypto_shash_update(desc, sig->digest,
    74						  sig->digest_size) ?:
    75			      crypto_shash_finup(desc, cert->tbs, cert->tbs_size,
    76						 sig->digest);
    77		} else {
    78			ret = crypto_shash_digest(desc, cert->tbs, cert->tbs_size,
    79						  sig->digest);
    80		}
    81	
    82		if (ret < 0)
    83			goto error_2;
    84	
    85		ret = is_hash_blacklisted(sig->digest, sig->digest_size,
    86					  BLACKLIST_HASH_X509_TBS);
    87		if (ret == -EKEYREJECTED) {
    88			pr_err("Cert %*phN is blacklisted\n",
    89			       sig->digest_size, sig->digest);
    90			cert->blacklisted = true;
    91			ret = 0;
    92		}
    93	
    94	error_2:
    95		kfree(desc);
    96	error:
    97		crypto_free_shash(tfm);
    98		pr_devel("<==%s() = %d\n", __func__, ret);
    99		return ret;
   100	}
   101	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
