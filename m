Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C6206066;
	Wed, 16 Oct 2024 11:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729077734; cv=none; b=YgAhUBVphBKcEccdafscNsJsj6rdjG5T7QgSGiF38C9ADADV8feLa3I8fDtUyh9/tfVfrow1ZVjqiKW9w9qvM+Q9Xqg5h3R6xwuLnax1ABZYAaSvIadjOpcDZdf06KdopaFmIWYby8pcWZhc4O8XoAeSOj4apUpm3s/jMT6EI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729077734; c=relaxed/simple;
	bh=Gau0sTeAKP4PxxVTvgkDOWCBf/ZUVWIEi4VtTvfm0rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcHQXkobGPt0LC8L66vOsQfpgMSR0hiwZZufftMkHxHIxl0SiduYH18+BS9YT/u2oMUrHyNmTf7jgGm1Tr8RNnr8WeUlQE+gSI4rfGeMgDu/SwjswRRkOGtXhn0sF1MT0a7z8R67ePH5Ie/3OcNxSBr8y6Ggs2yASCGzs6q0RF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pc9Nav5h; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pc9Nav5h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729077732; x=1760613732;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gau0sTeAKP4PxxVTvgkDOWCBf/ZUVWIEi4VtTvfm0rk=;
  b=Pc9Nav5hkW70ooy7/1CypARVAAld8kdAqRH3tzwKXjUfwGMK5yCXpQBO
   0W/ooFiAL4G2fejlfXlXswSBygzQwy3jMHtUpwZm+Zf7oqF81Ftzfav2K
   o9Ieat1PJEaoPhLHhSeGntgpganZZLCnbvqf3socR95h2dgR7yWJh1w+e
   ukHqbk8MOmSDaRVc9jtN+5J+bZDazKCF6BV+AHWHnBYSBY1FQM754femJ
   dk/amQtaMdK0AcGO6RwUktpd+6qb/rgBfPBjXSYgd1xhZOf+YEyeHAEE8
   x9hSXm6fxDrfBI1lU0a+xykfCkm78WD5LiMXye21PgZTNslZEwKSSk6bn
   g==;
X-CSE-ConnectionGUID: 6MHXf17qSLmpg62V9FShUA==
X-CSE-MsgGUID: WmeBFeIkRvuuxQjIUgPuWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11226"; a="32317972"
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="32317972"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 04:22:12 -0700
X-CSE-ConnectionGUID: 8j/7+9XOS+SQsZvNVHkwvw==
X-CSE-MsgGUID: 9Iz2gBfdTWe9P65TlLL2GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="78083159"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 16 Oct 2024 04:22:10 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t126R-000Kpv-0m;
	Wed, 16 Oct 2024 11:22:07 +0000
Date: Wed, 16 Oct 2024 19:21:14 +0800
From: kernel test robot <lkp@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Zijlstra <peterz@infradead.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] lib/digsig: Use scope-based resource management
 for two MPI variables in digsig_verify_rsa()
Message-ID: <202410161914.lY62TWL3-lkp@intel.com>
References: <300a0376-f003-4862-bb16-7e004733c9c1@web.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <300a0376-f003-4862-bb16-7e004733c9c1@web.de>

Hi Markus,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-crypto-2.6/master herbert-cryptodev-2.6/master linus/master v6.12-rc3 next-20241016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Markus-Elfring/crypto-lib-mpi-Extend-support-for-scope-based-resource-management/20241012-231156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/300a0376-f003-4862-bb16-7e004733c9c1%40web.de
patch subject: [PATCH v3 2/3] lib/digsig: Use scope-based resource management for two MPI variables in digsig_verify_rsa()
config: hexagon-randconfig-r064-20241016 (https://download.01.org/0day-ci/archive/20241016/202410161914.lY62TWL3-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241016/202410161914.lY62TWL3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410161914.lY62TWL3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from lib/digsig.c:25:
   In file included from include/linux/mpi.h:21:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from lib/digsig.c:25:
   In file included from include/linux/mpi.h:21:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from lib/digsig.c:25:
   In file included from include/linux/mpi.h:21:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> lib/digsig.c:176:3: error: expected statement
                   }
                   ^
   lib/digsig.c:178:2: error: expected statement
           }
           ^
   6 warnings and 2 errors generated.


vim +176 lib/digsig.c

    63	
    64	/*
    65	 * RSA Signature verification with public key
    66	 */
    67	static int digsig_verify_rsa(struct key *key,
    68			    const char *sig, int siglen,
    69			       const char *h, int hlen)
    70	{
    71		int err = -EINVAL;
    72		unsigned long len;
    73		unsigned long mlen, mblen;
    74		unsigned int l;
    75		int head, i;
    76		unsigned char *out1 = NULL;
    77		const char *m;
    78		MPI pkey[2];
    79		uint8_t *p, *datap;
    80		const uint8_t *endp;
    81		const struct user_key_payload *ukp;
    82		struct pubkey_hdr *pkh;
    83	
    84		down_read(&key->sem);
    85		ukp = user_key_payload_locked(key);
    86	
    87		if (!ukp) {
    88			/* key was revoked before we acquired its semaphore */
    89			err = -EKEYREVOKED;
    90			goto err1;
    91		}
    92	
    93		if (ukp->datalen < sizeof(*pkh))
    94			goto err1;
    95	
    96		pkh = (struct pubkey_hdr *)ukp->data;
    97	
    98		if (pkh->version != 1)
    99			goto err1;
   100	
   101		if (pkh->algo != PUBKEY_ALGO_RSA)
   102			goto err1;
   103	
   104		if (pkh->nmpi != 2)
   105			goto err1;
   106	
   107		datap = pkh->mpi;
   108		endp = ukp->data + ukp->datalen;
   109	
   110		for (i = 0; i < pkh->nmpi; i++) {
   111			unsigned int remaining = endp - datap;
   112			pkey[i] = mpi_read_from_buffer(datap, &remaining);
   113			if (IS_ERR(pkey[i])) {
   114				err = PTR_ERR(pkey[i]);
   115				goto free_keys;
   116			}
   117			datap += remaining;
   118		}
   119	
   120		mblen = mpi_get_nbits(pkey[0]);
   121		mlen = DIV_ROUND_UP(mblen, 8);
   122	
   123		if (mlen == 0) {
   124			err = -EINVAL;
   125			goto free_keys;
   126		}
   127	
   128		err = -ENOMEM;
   129	
   130		out1 = kzalloc(mlen, GFP_KERNEL);
   131		if (!out1)
   132			goto free_keys;
   133	
   134		{
   135			unsigned int nret = siglen;
   136			MPI in __free(mpi_free) = mpi_read_from_buffer(sig, &nret);
   137	
   138			if (IS_ERR(in)) {
   139				err = PTR_ERR(in);
   140				goto in_exit;
   141			}
   142	
   143			{
   144				MPI res __free(mpi_free) = mpi_alloc(mpi_get_nlimbs(in) * 2);
   145	
   146				if (!res)
   147					goto res_exit;
   148	
   149				err = mpi_powm(res, in, pkey[1], pkey[0]);
   150				if (err)
   151					goto res_exit;
   152	
   153				if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
   154					err = -EINVAL;
   155					goto res_exit;
   156				}
   157	
   158				p = mpi_get_buffer(res, &l, NULL);
   159				if (!p) {
   160					err = -EINVAL;
   161					goto res_exit;
   162				}
   163	
   164				len = mlen;
   165				head = len - l;
   166				memset(out1, 0, head);
   167				memcpy(out1 + head, p, l);
   168	
   169				kfree(p);
   170	
   171				m = pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
   172	
   173				if (!m || len != hlen || memcmp(m, h, hlen))
   174					err = -EINVAL;
   175	res_exit:
 > 176			}
   177	in_exit:
   178		}
   179	
   180		kfree(out1);
   181	free_keys:
   182		while (--i >= 0)
   183			mpi_free(pkey[i]);
   184	err1:
   185		up_read(&key->sem);
   186	
   187		return err;
   188	}
   189	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
