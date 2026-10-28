Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218427;
	b=yZ1FOoAvpzalWRK9CSYdPQDY2X9H70QYNb54s9U6hqPdDNObVAUEQzG17urWJ+YImAgX
	 Sn15wk0zedSuDs8jFtyc9eTQdRfdbw0f2TeoSyrzKgD1TgVtKKr22CgDMATrK/CrJ+3Em
	 jMIVBCur/RLMFg1TibSexJJjmTVBo9RGM/8RD+Nfia8vtptH1PYFSq8KF7B9OWua+CKu0
	 LpHIn4+ElfO9JtkMXaO+WGPo9H0n0cXvEX7920wt8JQAGLFWppD2VBU5tj36QhIpiF458
	 3DUs2DbeHa1d9AmK9KOaviXrDVrHx05Vr8oi/C2ji/XCzHOKMH2Uvp5AQjsz1+TYrTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218427;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qcNCn3o5PHSz7rHDpFBcCfTyitECJ4mMk4mDBTECIc0=;
	b=MRKRu1YZanamcbiZ6102GxJyQHMzl+ATAfGZlrN1Hc4xtk02vmYnCAwVXhhhW9cXwycK
	 IWbLzp95WmbFlEjxm0w0SYG4ecptZ1Vl1kLma4Uts9O6ThwoQfWZcTWSJELJiofr7fl0D
	 We6R5lSElv9BCT3zx27T/IieNPcjQ2ipWVm4uin3LF+Bl26cKJsjclhakK4cKJz7IbvP/
	 y/tiSV/IuO9jThWqNEu4TCQ+K1+W9IhnRmWPAPqVJFQ76Ah1Yac9JvLA+VeftcXfZOF5S
	 ePTQJWp4q7QLYuRynfM249RLNtS6rlcqBYrdxRi1xX7vyqqGXnYW3iUPv8fXKaEXCbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8SiLvNr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2FACA606A324;
	Wed, 28 Oct 2026 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8SiLvNr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4688F1F01829;
	Wed, 28 Oct 2026 20:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218426;
	bh=qcNCn3o5PHSz7rHDpFBcCfTyitECJ4mMk4mDBTECIc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A8SiLvNroTPllgxM7/NlCUN5LPANqhn6UynTAq5ihgbboZkFux6BhBkTBjZm3crr9
	 dZxaHxev/vlaupaACgdv834naSVYBkUmjwfsPLlSW08KoweT/hCn2jJhlFEBBoQp0n
	 ThnwIDRbeospa50sgUHEaLYo5TdohXooPlJll8bGcGX5NMPkLTkwVsUvTplrrSbSTR
	 wFSVjQvIZRMzBWSBYAgQARXpltti5u6bQnimxtIRnQ9pmDCxDHDGY4qvncj2r0M5iP
	 Wy5oqGXTFGtNUiHCP+3VArt+FptWgWlWI612t6R2PoKF6VYZYkHx5SU177/bobDWkp
	 JXow5JGpoMKZQ==
Date: Wed, 28 Oct 2026 22:13:43 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: David Howells <dhowells@redhat.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <auJXd718ys6ZaTHj@kernel.org>
References: <20261025001105.1824178-6-jarkko@kernel.org>
 <202610281546.OMDCubFW-lkp@intel.com>
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
In-Reply-To: <202610281546.OMDCubFW-lkp@intel.com>

On Wed, Oct 28, 2026 at 03:28:38PM +0800, kernel test robot wrote:
> Hi Jarkko,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on linus/master]
> [cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261027]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
> patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
> config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 186e70f4e6a1521991d2340d3d49b23b1beff11f)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/reproduce)

This is expected as at the time when I sent the patch set I did not have 
BPF changes yet.

Br, Jarkko
