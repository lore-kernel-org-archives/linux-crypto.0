Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE578F4B;
	Sun, 21 Sep 2025 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491980; cv=none; b=G0AdH7LEMprQxVbeOEEuj5jwHS/joBHv1ZqE5ZI+dRnxQTWn3Ng6ebgcEIUSmbNuVuVfU3Px9QJgAKuREKI6VB3yo8UsK2tifokyYWoyY4BsVYjK5d7WnyXMPP4JArL6d73cEY1ci/pqIglxfPbPGu3GCNf7TUr1Mzq80sRF4UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491980; c=relaxed/simple;
	bh=M2v7sfpTNNCmcFOkAb0KWsTGiwbSzGag6VBqaXtIdoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phFaGqtWJY++bqijzkfp0zx2Wc0S9sLw8e8STK2Gbg7zTKkZ2M30bSFIkfepL6kctFG6dhv9ej3WUN9kGitBWrPmyEH89gRV5w6hpvliZli4on/AijUtHBmnbsCZ1SLReJ93DfgcpbEN0er3dOKuPjpx2NH/rHzbvy/GCr36soE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f/G5UviB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f/G5UviB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758491979; x=1790027979;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M2v7sfpTNNCmcFOkAb0KWsTGiwbSzGag6VBqaXtIdoQ=;
  b=f/G5UviBC4FVBPupUlFBCcv1qH7Jq+S3ns3K8o0cxkqWtMeOJMnYbHTS
   UPwGcHj/fOa3DwcQ8/YmeXFIQcLn5m2y1bADC6dfCcVh43jEomUBXcxI9
   UvMCJCoaOPSDZjp3Btdzecw+VhoM6I4QTkgpUk/OX2jLT7CiAq26ifIMt
   rjAhw5CzhCcuRl54mKfofG1OmxYw21Co47ug1T7WjVSpdsYALBzEVEpVu
   aQoY3pmNdLU78f/LPgmverh4SzjtVK1ooJNbu+5alXasP7pOqTiXifKMn
   gNHAjni9DVPxRnReJyiG6sFzCIqDKaWvUldJ0oXmalbviAm3SKaoSygUW
   A==;
X-CSE-ConnectionGUID: 0ZhcMHWqQjKknqTStVoo4w==
X-CSE-MsgGUID: K882RHsrRrCdF5BeEnI7nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60671431"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60671431"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 14:59:38 -0700
X-CSE-ConnectionGUID: l17xTKIzSS2SgRiJlaW/5w==
X-CSE-MsgGUID: C+Ft5zF3SlWfsyqfo6lDCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="181581299"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2025 14:59:34 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0S5S-00012D-0Y;
	Sun, 21 Sep 2025 21:59:20 +0000
Date: Mon, 22 Sep 2025 05:58:14 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/5] arm64/fpsimd: Require kernel NEON begin/end calls
 from the same scope
Message-ID: <202509220514.RnYqxP9V-lkp@intel.com>
References: <20250918063539.2640512-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918063539.2640512-11-ardb+git@google.com>

Hi Ard,

kernel test robot noticed the following build errors:

[auto build test ERROR on f83ec76bf285bea5727f478a68b894f5543ca76e]

url:    https://github.com/intel-lab-lkp/linux/commits/Ard-Biesheuvel/crypto-arm64-aes-ce-ccm-Avoid-pointless-yield-of-the-NEON-unit/20250918-143859
base:   f83ec76bf285bea5727f478a68b894f5543ca76e
patch link:    https://lore.kernel.org/r/20250918063539.2640512-11-ardb%2Bgit%40google.com
patch subject: [PATCH 4/5] arm64/fpsimd: Require kernel NEON begin/end calls from the same scope
config: arm64-randconfig-r132-20250920 (https://download.01.org/0day-ci/archive/20250922/202509220514.RnYqxP9V-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250922/202509220514.RnYqxP9V-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509220514.RnYqxP9V-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c:27:
   drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c: In function 'dc_fpu_begin':
>> drivers/gpu/drm/amd/amdgpu/../display/dc/dc_trace.h:42:9: error: expected 'while' before 'trace_dcn_fpu'
      42 |         trace_dcn_fpu(begin, function, line, ref_count)
         |         ^~~~~~~~~~~~~
   drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c:86:9: note: in expansion of macro 'TRACE_DCN_FPU'
      86 |         TRACE_DCN_FPU(true, function_name, line, depth);
         |         ^~~~~~~~~~~~~
>> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c:106:11: error: 'else' without a previous 'if'
     106 |         } else {
         |           ^~~~
   drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c: At top level:
>> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/dc_fpu.c:99:6: warning: 'dc_fpu_end' defined but not used [-Wunused-function]
      99 | void dc_fpu_end(const char *function_name, const int line)
         |      ^~~~~~~~~~


vim +42 drivers/gpu/drm/amd/amdgpu/../display/dc/dc_trace.h

8b198f6e94d669 Rodrigo Siqueira 2020-09-09  25  
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  26  #define TRACE_DC_PIPE_STATE(pipe_ctx, index, max_pipes) \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  27  	for (index = 0; index < max_pipes; ++index) { \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  28  		struct pipe_ctx *pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[index]; \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  29  		if (pipe_ctx->plane_state) \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  30  			trace_amdgpu_dm_dc_pipe_state(pipe_ctx->pipe_idx, pipe_ctx->plane_state, \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  31  						      pipe_ctx->stream, &pipe_ctx->plane_res, \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  32  						      pipe_ctx->update_flags.raw); \
8b198f6e94d669 Rodrigo Siqueira 2020-09-09  33  	}
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  34  
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  35  #define TRACE_DCE_CLOCK_STATE(dce_clocks) \
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  36  	trace_amdgpu_dm_dce_clocks_state(dce_clocks)
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  37  
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  38  #define TRACE_DCN_CLOCK_STATE(dcn_clocks) \
13b5ca42ca9c96 Rodrigo Siqueira 2020-09-10  39  	trace_amdgpu_dm_dc_clocks_state(dcn_clocks)
96ee63730fa306 Rodrigo Siqueira 2021-07-26  40  
2d8471dc371f36 Rodrigo Siqueira 2021-07-26  41  #define TRACE_DCN_FPU(begin, function, line, ref_count) \
2d8471dc371f36 Rodrigo Siqueira 2021-07-26 @42  	trace_dcn_fpu(begin, function, line, ref_count)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
