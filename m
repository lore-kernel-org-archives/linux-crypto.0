Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE993F7ABC;
	Wed, 20 May 2026 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301665; cv=none; b=Gze9V1aPcYe1xEUKCCGhrSCYvieTaotcXR/BYqwHDjfBcKLk8jblPirCa8LF8YkvaDpX8Lf5hiOsuJSXJ2Qx9yvfTMVeZDP7wOHbu44uk4pMc24UpWex/bTNZ+HP124REY/ub+dSb/YOI96rklg63+oq/Ycp+VmFJrToB6Pt5o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301665; c=relaxed/simple;
	bh=Y6K4hu1l3UXqWGY6QUjw5D1toYfIYfsN+7a8DHqoI4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBv7nsx/AwKt9zYIa8cx8sl5vQ5U7nkNtGz1a5CrV5l/FreFZUPWLUf0/LT86yw/j4PEMDvAKeO/25DfDGjPKmkHskDqmREqlF7HEcbfay+AtQCGX6fhW/BBVZFT1tPh3/xgJmmAokq/5WrXceYTjpMqjaFx9v5sQ3oSMmLIJXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnC0JJuw; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnC0JJuw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779301665; x=1810837665;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y6K4hu1l3UXqWGY6QUjw5D1toYfIYfsN+7a8DHqoI4k=;
  b=fnC0JJuwZhJq1EGPuiZjxH6/IrhR49+NlYpRZskCGa2hZep3mA8eYKF1
   R3QH6VHpd9WG0HQi4HGE2Kzt6uPjzfJzRuWbCPmsCMQK5+UwFbRj0VNGN
   BXfXaJYcgEjfEiFeqLauGeTk2fDxvf1BfjJEay+shmvqRyI5f+L9FqhSc
   u5iHeAi68ZF3vzAPZZRQ4vpDIXuTqjr4r6Mj+QDDAE7D7mjb8AtsX+s8s
   vegbkwlMxno/F2aSJZwXegY3XDUqLBKgDgjxz76raXbJfVEjT/Q+WLgmJ
   wENCZVI7hAcvqB1yVE6o9vkbgHboCOj39cONCM4xkbG9VoZYfZKjy04bV
   g==;
X-CSE-ConnectionGUID: 3xkB9UI4Qh6TAzaHLxOUhA==
X-CSE-MsgGUID: muTHwHo0QoydzE2KF3R3MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="80177362"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="80177362"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 11:27:44 -0700
X-CSE-ConnectionGUID: DuZ9iwDKRXCFnwlxhgpTBQ==
X-CSE-MsgGUID: 1qotuqwZSIKV+9YRhpc2Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="264072193"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 20 May 2026 11:27:40 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPldq-00000000AcX-2omz;
	Wed, 20 May 2026 18:27:38 +0000
Date: Wed, 20 May 2026 20:27:27 +0200
From: kernel test robot <lkp@intel.com>
To: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com,
	thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, tycho@kernel.org,
	nikunj@amd.com, michael.roth@amd.com, prsampat@amd.com
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <202605202038.zpyF8AIf-lkp@intel.com>
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>

Hi Pratik,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v7.1-rc4]
[cannot apply to next-20260520]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pratik-R-Sampat/crypto-ccp-Introduce-SNP_VERIFY_MITIGATION-command/20260520-035846
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat%40amd.com
patch subject: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260520/202605202038.zpyF8AIf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605202038.zpyF8AIf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:364; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:234
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:373; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:243
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:636; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:252
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:645; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:261
   Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities:1: ERROR: Unexpected indentation. [docutils]
>> Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities:1: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
>> Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities:1: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
   Documentation/arch/riscv/zicfilp.rst:79: WARNING: Inline literal start-string without end-string. [docutils]
   Documentation/core-api/kref:328: ./include/linux/kref.h:72: WARNING: Invalid C declaration: Expected end of definition. [error at 96]
   int kref_put_mutex (struct kref *kref, void (*release)(struct kref *kref), struct mutex *mutex) __cond_acquires(true# mutex)
   ------------------------------------------------------------------------------------------------^
   Documentation/core-api/kref:328: ./include/linux/kref.h:94: WARNING: Invalid C declaration: Expected end of definition. [error at 92]


vim +1 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities

   > 1	What:		/sys/firmware/sev/vulnerabilities/

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
