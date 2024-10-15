Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F191FE105;
	Tue, 15 Oct 2024 21:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729027736; cv=none; b=K9j+gmqaBtGUzWkITOiPyA6gu3NAFWYVMKx2qDmG7YY8ehT4bkKLoVbmfMV09GX/T7u2WSmUQutlPfSpkSDouraRE3sFwGdSsSAu85MTNOsF94F01orTG8L9yquRymS7OYPv3lUwMINgJnHSEsuAVKIjEaKGcD8Ddo6vtajfQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729027736; c=relaxed/simple;
	bh=xPCIn32QQfr54O0zHazFhSN5jue+7V076iFkE2q84Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMcbt1vhFnG+4jf5nMNyQkJSO7ft9Rjz8I11zdnJ2/567ooBWBOtlkFO1iseye9UKx54G4eEt5rFde+G727vlQViJpO6U6wnM9WWm93fXROKnl+w1Q5frZo2NH+Wq8iGEfV2dG3nPSczLbjtrK8vgNzskC6wBtgEnnUFpF3HrIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Itum5/FW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Itum5/FW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729027735; x=1760563735;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xPCIn32QQfr54O0zHazFhSN5jue+7V076iFkE2q84Ik=;
  b=Itum5/FW6XD/fgdSiRUkMKmVDGPJ91QoXD6QAXPLKjWSHrUrXdEeBIKE
   f9fBR7ZYF0Y6fXvdDgqOrSUtTY3H/wmyvKzsD3wzbB0tw60w/ayrO1bxe
   43Sn+dTrRzRVXQ1APeD+vRewl4XX1ARW6nwzh0Zgm0di8knKk/158U33Y
   ANPrwnvILwwzovj0p0z6rvLxbgzwmQ0Yq1ZojjV71apgF3zBIluz830zD
   CtgW1wrETa2vsitYJYPPn/GSQlrAhQrtFnBN6bBIBOJCZZUu2enXJlDp/
   dDmjWAQBVo6wwVeHOWCmJLH5VOH6DIHHwIz8aHBRVhiZu3IAaNfsovH9T
   w==;
X-CSE-ConnectionGUID: QcPSu1VYRfyzTlYRclyO0A==
X-CSE-MsgGUID: vUbFVdfxRM2dbAtTZDGBQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="27891399"
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="27891399"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 14:28:54 -0700
X-CSE-ConnectionGUID: 9ed/BWG1Q563Zf26f963sw==
X-CSE-MsgGUID: GLmnR+SHT5mHPhynDws5YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="78861952"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 15 Oct 2024 14:28:52 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t0p61-000Jx7-0T;
	Tue, 15 Oct 2024 21:28:49 +0000
Date: Wed, 16 Oct 2024 05:27:52 +0800
From: kernel test robot <lkp@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Zijlstra <peterz@infradead.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] lib/digsig: Use scope-based resource management
 for two MPI variables in digsig_verify_rsa()
Message-ID: <202410160438.SOIZeFku-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-crypto-2.6/master herbert-cryptodev-2.6/master linus/master v6.12-rc3 next-20241015]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Markus-Elfring/crypto-lib-mpi-Extend-support-for-scope-based-resource-management/20241012-231156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/300a0376-f003-4862-bb16-7e004733c9c1%40web.de
patch subject: [PATCH v3 2/3] lib/digsig: Use scope-based resource management for two MPI variables in digsig_verify_rsa()
config: arm-randconfig-002-20241016 (https://download.01.org/0day-ci/archive/20241016/202410160438.SOIZeFku-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 70e0a7e7e6a8541bcc46908c592eed561850e416)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241016/202410160438.SOIZeFku-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410160438.SOIZeFku-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from lib/digsig.c:25:
   In file included from include/linux/mpi.h:21:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> lib/digsig.c:176:3: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
     176 |                 }
         |                 ^
   lib/digsig.c:178:2: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
     178 |         }
         |         ^
   3 warnings generated.


vim +176 lib/digsig.c

    16	
    17	#include <linux/err.h>
    18	#include <linux/module.h>
    19	#include <linux/slab.h>
    20	#include <linux/key.h>
    21	#include <linux/crypto.h>
    22	#include <crypto/hash.h>
    23	#include <crypto/sha1.h>
    24	#include <keys/user-type.h>
  > 25	#include <linux/mpi.h>
    26	#include <linux/digsig.h>
    27	
    28	static struct crypto_shash *shash;
    29	
    30	static const char *pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
    31							unsigned long  msglen,
    32							unsigned long  modulus_bitlen,
    33							unsigned long *outlen)
    34	{
    35		unsigned long modulus_len, ps_len, i;
    36	
    37		modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
    38	
    39		/* test message size */
    40		if ((msglen > modulus_len) || (modulus_len < 11))
    41			return NULL;
    42	
    43		/* separate encoded message */
    44		if (msg[0] != 0x00 || msg[1] != 0x01)
    45			return NULL;
    46	
    47		for (i = 2; i < modulus_len - 1; i++)
    48			if (msg[i] != 0xFF)
    49				break;
    50	
    51		/* separator check */
    52		if (msg[i] != 0)
    53			/* There was no octet with hexadecimal value 0x00
    54			to separate ps from m. */
    55			return NULL;
    56	
    57		ps_len = i - 2;
    58	
    59		*outlen = (msglen - (2 + ps_len + 1));
    60	
    61		return msg + 2 + ps_len + 1;
    62	}
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
