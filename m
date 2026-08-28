Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDFB2ECE91;
	Fri, 28 Aug 2026 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787878498; cv=none; b=PUiK4XeHfefTfmZOI7zTePA5NHxJ/EOMAElDLxCeaz/+FH/qKARaQYtE/fU12tCxLIEaWaV9GlRQG3FZbsEyXvhJZcpfhgz5aIv5FuNfdfWJ5orkV2z92IQ5J9J3cWi5nOLlzP+DbtYfzYxR5AtDVcm71PEYe4zFs/WP9T43/CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787878498; c=relaxed/simple;
	bh=lkLNCDmuOclJQul5e0NVXK6dZf+WeD60Xio5XflWVQE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ldDCzbycFulmttuQEhUSpa3EDYFtBKPND/sb6TkHybetvoI6peEneuXOnGbpsNLVwRh7B3t/8wZgHrw1v+nf83siOqnrDV/1KsOY2abG7DsBrzlTaETx1QBQpAUviR57t97rLmBDZ12S9lxNmMmj6S6lYMZpF2qB7o2T3Fanlaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=leNsmW1+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="leNsmW1+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787878496; x=1819414496;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding:in-reply-to;
  bh=lkLNCDmuOclJQul5e0NVXK6dZf+WeD60Xio5XflWVQE=;
  b=leNsmW1+JwKw0t0VHL7BswnsLz0nmUAQajMEMB37kEI6IP0Sw/TiWV5y
   h/BbKjjwskuri/bX2WzZHHH/h+knocBRk/419saAgpq0ZtWgitvtTaLqp
   3FtVUljLvO8640RYyDt+djHqbFvlh/qN195NPcl4UaCaIxJee6ebMIMX0
   T73zRpuW6w/rl0d88R2YuI3tODiuBkHuwCarLksvuP6pQhm+PrBvoyTMD
   bc/JX4uOuCghZlQoKeiJyjpqNIpT3iCbNmwXNy+gNuftb5r+kWmbjyNhj
   Y9LyzLjbh2CZ5vu3mLclNGT6ReBYa0sLyQRFvmwhzkN/49l0+8y/u95Py
   A==;
X-CSE-ConnectionGUID: Vzxd+yC9RqGR5w6G2Kr48Q==
X-CSE-MsgGUID: gM6dKnO6SXGKuL3j7gi6lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99548810"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="99548810"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:54:56 -0700
X-CSE-ConnectionGUID: 5UaGwS1vRNGl6pWq0sf0kg==
X-CSE-MsgGUID: vYYcAbSKQAWvwI7oPBWoIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="268591115"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:54:53 -0700
Date: Fri, 28 Aug 2026 08:54:49 +0800
From: kernel test robot <yi1.lai@intel.com>
To: quanyeyang via B4 Relay <devnull+quanyemostima.gmail.com@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	NeilBrown <neilb@suse.com>, "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com,
	quanyeyang <quanyemostima@gmail.com>, yi1.lai@intel.com
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket
 locks
Message-ID: <202608280842.861e5949-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>


Hello,

kernel test robot noticed a 12.5% regression of stress-ng.shm-sysv.ops_per_sec on:


commit: 62d8460a4e7a3ee028e5134d86169001490e7a60 ("[PATCH] rhashtable: use per-init-site lockdep classes for bucket locks")
url: https://github.com/intel-lab-lkp/linux/commits/quanyeyang-via-B4-Relay/rhashtable-use-per-init-site-lockdep-classes-for-bucket-locks/20260815-014140
patch link: https://lore.kernel.org/all/20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com/
patch subject: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: shm-sysv
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202608280842.861e5949-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260828/202608280842.861e5949-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/shm-sysv/stress-ng/60s

commit: 
  0131b508c0 ("Merge tag 'ntfs-for-7.2-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/ntfs")
  62d8460a4e ("[PATCH] rhashtable: use per-init-site lockdep classes for bucket locks")

0131b508c0e2489e 62d8460a4e7a3ee028e5134d861
---------------- --------------------------- 
    192413           +44.1%     277255        stress-ng.shm-sysv.nanosecs_per_shmat_call
    349549           +24.2%     433996        stress-ng.shm-sysv.nanosecs_per_shmdt_call
    174600           +51.9%     265191        stress-ng.shm-sysv.nanosecs_per_shmget_call
    793610           -12.5%     694260        stress-ng.shm-sysv.ops
     13236           -12.5%      11578        stress-ng.shm-sysv.ops_per_sec
     65737           -10.0%      59167 ±  4%  stress-ng.time.involuntary_context_switches
  53645785           -12.0%   47213499 ±  2%  stress-ng.time.minor_page_faults
      4660           +24.6%       5806        stress-ng.time.percent_of_cpu_this_job_got
      2585           +27.8%       3305        stress-ng.time.system_time
    214.61           -14.7%     183.11        stress-ng.time.user_time
  10735595            -7.0%    9986470        stress-ng.time.voluntary_context_switches
 

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


