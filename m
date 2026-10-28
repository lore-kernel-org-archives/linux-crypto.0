Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793172548;
	b=fp9TRbJ/7f08zIdB9gZNLKSSLiOG7oHVEmInBCTstZRJ4/e/golF3P7+AukBJ2yxgZV3
	 JT21tTRjA+fJZBBy9YchMwmhEHC194ewzusQI9ARInmWso6jyQ4xcvW+50a9HpviglEnZ
	 /6Toya1Ow525LDSMgWWiwz9I3ZOY85xiZZJQAiRlspdgq5/xZWXqXR7N3gQ2F3Gn6Ui0F
	 vxhd3Qss+cCDOWCBgM8Wy6IiRR0MbcF6SFCVgVCMF/D1GgN+AMAz6rRXP8rTxv9s7CF0v
	 2nnVYemsMfBXgX1vbal90nT/3H4/djHykiXjiKkro6nSyVrkQv7uFui29eLQXYqUbCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793172548;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=N9gBy32Umx1KK8RH0X7KkA8q7a84CegEqG9LxghN33w=;
	b=W0dwY3OQF/Mwmn7eFdzjdorcxo/MVBZytBxYVQmbVVm78zUCCKp8XKMrbshMv6/6mdRQ
	 +xshogXrareBQIefU1WCs23KqVGjogCM7YN8+K77VSj8DBhpWVGyeFYxcYOzbOX8WM3KO
	 sjyAB27wNP0DfCSZxmn0lLY0WRrQQ5t1iwYULlzwTsuBYNiZoEMnmecYoXsRImfIiGnVv
	 T+GFw4GzPuWs1wIJe+06KfAVF6VkbKIFJIMga3L3KnmAMI65ES1M74hKeUe2ELoJ5uhvE
	 6ca3rNiFcn3s0PWdD/CGb8K4FvKSEut0aioOvMtxjmrwaI/Qe3z1Apy65ZZKUqqLbVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QstgLqVe;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD73606A31D;
	Wed, 28 Oct 2026 07:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD73606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QstgLqVe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793172548; x=1824708548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3rO83+6ZiPbQh0ra3NNYRzFCPQ7QM/wKotP9MQYg5uU=;
  b=QstgLqVeJIM9cwRtdS+Ad1Eyi6UyD48JScFue+r3BZSIJdoheidfpBGg
   ZhaIaLYP5EH4zj+8dOo4wUMAiVH+kgXo0LIdAK25y/759o9/onB4Nq6mm
   2YA+AKI74r/pNdFXvPD4HjRVqwfQ4JQNRKETbhz2d5BARKwIMasohX1L9
   okTfKZZDZOE2pFXao0zRGX6QRv28XuKFzk/ow7AkUn00fdNiVZEmoOOp4
   27ipWksY7Klk9IsE4ZupSQnyHdzA5T6q/BFSbxnxxJg5iXxIVWAaw1POA
   zPEBy3FOe7jCZtU9OshpoCdGDov5Y4nzxOEl5hkgOPcwK5zAsCSijg7tx
   g==;
X-CSE-ConnectionGUID: codRlU+ARyS6pZLt8NY9vw==
X-CSE-MsgGUID: zs7t+fR5TYu4+xb/bd0JDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1767477"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1767477"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 00:29:07 -0700
X-CSE-ConnectionGUID: pJBqjxOOQdeCRpcIm+CX0Q==
X-CSE-MsgGUID: /B5GbNDIRyy+HTbdg+QbCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="4847384"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 28 Oct 2026 00:29:04 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLy5k-00000000YRI-1vsi;
	Wed, 28 Oct 2026 07:29:00 +0000
Date: Wed, 28 Oct 2026 15:28:38 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	keyrings@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <202610281546.OMDCubFW-lkp@intel.com>
References: <20261025001105.1824178-6-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>

Hi Jarkko,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261027]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
base:   linus/master
patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 186e70f4e6a1521991d2340d3d49b23b1beff11f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610281546.OMDCubFW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
   7 errors generated.


vim +32 kernel/bpf/keys.c

abaa0835b4f3810 Daniel Borkmann 2026-08-28  25  
264d8fd2794fabe Daniel Borkmann 2026-08-28  26  struct bpf_key *bpf_lookup_keyring(void)
264d8fd2794fabe Daniel Borkmann 2026-08-28  27  {
264d8fd2794fabe Daniel Borkmann 2026-08-28  28  	struct bpf_key *bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  29  
264d8fd2794fabe Daniel Borkmann 2026-08-28  30  	if (!bpf_keyring)
264d8fd2794fabe Daniel Borkmann 2026-08-28  31  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28 @32  	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
264d8fd2794fabe Daniel Borkmann 2026-08-28  33  	    !READ_ONCE(bpf_keyring->restrict_link))
264d8fd2794fabe Daniel Borkmann 2026-08-28  34  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  35  
264d8fd2794fabe Daniel Borkmann 2026-08-28  36  	bkey = kmalloc_obj(*bkey);
264d8fd2794fabe Daniel Borkmann 2026-08-28  37  	if (!bkey)
264d8fd2794fabe Daniel Borkmann 2026-08-28  38  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  39  
264d8fd2794fabe Daniel Borkmann 2026-08-28  40  	bkey->key = bpf_keyring;
264d8fd2794fabe Daniel Borkmann 2026-08-28  41  	bkey->has_ref = false;
264d8fd2794fabe Daniel Borkmann 2026-08-28  42  	return bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  43  }
264d8fd2794fabe Daniel Borkmann 2026-08-28  44  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
