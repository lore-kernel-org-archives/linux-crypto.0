Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88713959D;
	Mon, 25 Aug 2025 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111653; cv=none; b=S9DfWxl45CGd1M4BQ3C3kDz0q4g2xsae5pvc/59EiybHxqQpRFigYNjkn4cBjttyXfEPomm3xWyOPXdmbOPb6BtRh4qCoxphbfyricPvY4JRw8DWdYpKUDN7z6JUZksPxozXyyXSelGGORWg38ApNW5N5d5UI6FM6mAHPct8Gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111653; c=relaxed/simple;
	bh=bPVNpV6nMN5xahOwuEGChnOhxKBoMGh0YVXl92nUSSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0Xy2ztxjXnzO7mrN9zCzGZDYPJw6Cfo5sYfpyjRRwH2Ozl5i3MkbQIYt+8NxD9j5WslRzTI0Yrf9XKJPEV0WKj5Wg7CGS2BTqSYfSfvVLAxZzJz67a7QPqLV+eB5SU4kktnb1wwutRUl/vLr1Ew3ma2QFJAW7e0D422F5vMaH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cv3PLodc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cv3PLodc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756111652; x=1787647652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bPVNpV6nMN5xahOwuEGChnOhxKBoMGh0YVXl92nUSSY=;
  b=cv3PLodchH2BPbAF9V+5f3d6Z1TYB+OGNVAjDv8y11gnc5CKD07ohLKI
   vx8BAfk+n+fyH0GRrG+X+D4TxnUZWzDbJGdxiMzcYEWGoDUWl4bpK4IzP
   Uh59tKPYBlSNoOrge+MvY1TkPHV3XwzGKNPSDfvSSyYhgqOGcjgnlwKiQ
   vkHM0W29UdVY34GCgWu4E0/Rms4bXPhh3ZvK5oVV9ba6nCxEQDZgNmxsI
   21lTe93FTixb0DK9apCxjKxRcarz0fKR9CqFVUqWwHWsKdezvaqgsYvKa
   FwbsHZLf+VeU5mNo0RE4/FgNPoISighk1sImQrdJYRVpTvajnp6NXYTMp
   g==;
X-CSE-ConnectionGUID: zJWErrChQQCzq//vzla5cg==
X-CSE-MsgGUID: 5zwtZ7KJS8qn39mr0b07vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="62133706"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62133706"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 01:47:31 -0700
X-CSE-ConnectionGUID: EHKU6I3xQgyx4nNPByQ0/A==
X-CSE-MsgGUID: 6v+ucBATRY+7FVaT1s8goA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169133596"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 25 Aug 2025 01:47:29 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uqSrH-000NWx-3A;
	Mon, 25 Aug 2025 08:47:21 +0000
Date: Mon, 25 Aug 2025 16:47:07 +0800
From: kernel test robot <lkp@intel.com>
To: Osama Abdelkader <osama.abdelkader@gmail.com>, tytso@mit.edu,
	Jason@zx2c4.com
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: Re: [PATCH] drivers/char/random.c: Clean up style issues
Message-ID: <202508251623.uUGghjhZ-lkp@intel.com>
References: <20250820170359.78811-1-osama.abdelkader@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820170359.78811-1-osama.abdelkader@gmail.com>

Hi Osama,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.17-rc2]
[also build test WARNING on linus/master]
[cannot apply to crng-random/master next-20250822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Osama-Abdelkader/drivers-char-random-c-Clean-up-style-issues/20250821-010651
base:   v6.17-rc2
patch link:    https://lore.kernel.org/r/20250820170359.78811-1-osama.abdelkader%40gmail.com
patch subject: [PATCH] drivers/char/random.c: Clean up style issues
config: sparc-randconfig-r071-20250825 (https://download.01.org/0day-ci/archive/20250825/202508251623.uUGghjhZ-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508251623.uUGghjhZ-lkp@intel.com/

smatch warnings:
drivers/char/random.c:325 crng_fast_key_erasure() warn: inconsistent indenting
drivers/char/random.c:349 crng_make_state() warn: inconsistent indenting

vim +325 drivers/char/random.c

   304	
   305	/*
   306	 * This generates a ChaCha block using the provided key, and then
   307	 * immediately overwrites that key with half the block. It returns
   308	 * the resultant ChaCha state to the user, along with the second
   309	 * half of the block containing 32 bytes of random data that may
   310	 * be used; random_data_len may not be greater than 32.
   311	 *
   312	 * The returned ChaCha state contains within it a copy of the old
   313	 * key value, at index 4, so the state should always be zeroed out
   314	 * immediately after using in order to maintain forward secrecy.
   315	 * If the state cannot be erased in a timely manner, then it is
   316	 * safer to set the random_data parameter to &chacha_state->x[4]
   317	 * so that this function overwrites it before returning.
   318	 */
   319	static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
   320					  struct chacha_state *chacha_state,
   321					  u8 *random_data, size_t random_data_len)
   322	{
   323		u8 first_block[CHACHA_BLOCK_SIZE];
   324	
 > 325			WARN_ON_ONCE(random_data_len > 32);
   326			if (random_data_len > 32)
   327				return;
   328		chacha_init_consts(chacha_state);
   329		memcpy(&chacha_state->x[4], key, CHACHA_KEY_SIZE);
   330		memset(&chacha_state->x[12], 0, sizeof(u32) * 4);
   331		chacha20_block(chacha_state, first_block);
   332	
   333		memcpy(key, first_block, CHACHA_KEY_SIZE);
   334		memcpy(random_data, first_block + CHACHA_KEY_SIZE, random_data_len);
   335		memzero_explicit(first_block, sizeof(first_block));
   336	}
   337	
   338	/*
   339	 * This function returns a ChaCha state that you may use for generating
   340	 * random data. It also returns up to 32 bytes on its own of random data
   341	 * that may be used; random_data_len may not be greater than 32.
   342	 */
   343	static void crng_make_state(struct chacha_state *chacha_state,
   344				    u8 *random_data, size_t random_data_len)
   345	{
   346		unsigned long flags;
   347		struct crng *crng;
   348	
 > 349			WARN_ON_ONCE(random_data_len > 32);
   350			if (random_data_len > 32)
   351				return;
   352		/*
   353		 * For the fast path, we check whether we're ready, unlocked first, and
   354		 * then re-check once locked later. In the case where we're really not
   355		 * ready, we do fast key erasure with the base_crng directly, extracting
   356		 * when crng_init is CRNG_EMPTY.
   357		 */
   358		if (!crng_ready()) {
   359			bool ready;
   360	
   361			spin_lock_irqsave(&base_crng.lock, flags);
   362			ready = crng_ready();
   363			if (!ready) {
   364				if (crng_init == CRNG_EMPTY)
   365					extract_entropy(base_crng.key, sizeof(base_crng.key));
   366				crng_fast_key_erasure(base_crng.key, chacha_state,
   367						      random_data, random_data_len);
   368			}
   369			spin_unlock_irqrestore(&base_crng.lock, flags);
   370			if (!ready)
   371				return;
   372		}
   373	
   374		local_lock_irqsave(&crngs.lock, flags);
   375		crng = raw_cpu_ptr(&crngs);
   376	
   377		/*
   378		 * If our per-cpu crng is older than the base_crng, then it means
   379		 * somebody reseeded the base_crng. In that case, we do fast key
   380		 * erasure on the base_crng, and use its output as the new key
   381		 * for our per-cpu crng. This brings us up to date with base_crng.
   382		 */
   383		if (unlikely(crng->generation != READ_ONCE(base_crng.generation))) {
   384			spin_lock(&base_crng.lock);
   385			crng_fast_key_erasure(base_crng.key, chacha_state,
   386					      crng->key, sizeof(crng->key));
   387			crng->generation = base_crng.generation;
   388			spin_unlock(&base_crng.lock);
   389		}
   390	
   391		/*
   392		 * Finally, when we've made it this far, our per-cpu crng has an up
   393		 * to date key, and we can do fast key erasure with it to produce
   394		 * some random data and a ChaCha state for the caller. All other
   395		 * branches of this function are "unlikely", so most of the time we
   396		 * should wind up here immediately.
   397		 */
   398		crng_fast_key_erasure(crng->key, chacha_state, random_data, random_data_len);
   399		local_unlock_irqrestore(&crngs.lock, flags);
   400	}
   401	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
