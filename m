Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422874;
	b=RBa/3pFUW0peVituomaxgfyI4HGXjWra4qhToeYZoRAUxClZYUUmLWCVs3BDzv4Gswmv
	 LxBqVTCe+TF3UOzig7CULKiImBgSenMSJhxOnqQYUQjdHIl2a8I0B4D75PcR8aZ1t8Ebf
	 mVTAnZQT+7tJ7v3qHoXkBu1aKd63ersRHYgXcp4NuAZSvRjT+KiRYPa+mVFluMJI8AZqO
	 E3k7UfQf4hei6r8Ai5eiNtnC9SLJTbQz09eiC0VOg1OEOERBTP1wnlO+dNvPRB7FyhWS5
	 JN677OU4YJZfA10cfz5alL1I508c/xPChmpGZwkBx1uSI4Zmz+WbHaHMJxw/kKylMYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422874;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=n3qf+f9JOnVqbADl8hOmlsjTW3vGVFRlj2rwalpREsQ=;
	b=QqVc+nrTlZUUpPZEBkMXbQdrauPMpzlTSr+2yUklkdgySeJCgxFdSSGbBBa6ziCu01hU
	 WN0+fgjyVi36iHOFRZI3xx4kd7oRIZxA52/JIYU26vtVtfxGWl/g6WT++CDopfo4hPYxR
	 Dvo2KCIDBKb3siF/qDZzAkvJYqjL61zDH7mcAnl2JlZox7Rh+hFow9kJTGRaKojLiZnOQ
	 bRWQh3tyt5oz0J/z9kZreCfmDYxqMjHxjJ6KLvg4goposoErLyEqkJ+Z/PNia3YYC68qV
	 9CxlEyeaFs9Pf9HKpxqcpa+81PDCExeRBRQZUnvrNJp2pxy/PWpKyAwYPhHkLKUJa6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=l1USfmJ4;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF05609CEC5;
	Mon, 19 Oct 2026 15:14:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FF05609CEC5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=l1USfmJ4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422874; x=1823958874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SkRzdP6TGWZsx5ESerPHIuIbeqAgpFdhqI58Lf1jinQ=;
  b=l1USfmJ41MNlEkjdVHX9djFGjQKOTP+ZDW/zGCpBlpWhxJd61roKilSR
   EsvViyrRjKGVbfd7HM1dY5XFtskBiUvUbavIzWGwtzTeH/bN9divPUuK2
   NSpcnQL1t4T9flg36rZN5TlrGkY1ru7jxpW5ciCoLitVdBi8YOcuE+9IC
   fmSiJPCS0MThNeX7zpicRgFz1R3R0SWP2Sa3tMKyDy20JAgAtxt8dhvTz
   DcdT1O0spmY0DaTUWWFWAaCo1V8Q9JPeqGekiAu/7soopN52XzYbpV92S
   LvKKxOyMPAujwTGMqojTCl1KVvRrYEFRdeF81OzCtnqBw2Cd/dakVhZJv
   g==;
X-CSE-ConnectionGUID: v93U+4vSTACewUO6kMFi8A==
X-CSE-MsgGUID: F69UYfbEQqOhfDyjJbxv2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986891"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986891"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:33 -0700
X-CSE-ConnectionGUID: GC5P4fG4RF+Ouz8K5nXipg==
X-CSE-MsgGUID: OJ0YWyC/RKOyYnxcr4Ws4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536938"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:33 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 00/17] [PATCH 00/17] dmaengine: idxd: fixes found by an in-kernel polling client
Date: Mon, 19 Oct 2026 08:06:13 -0700
Message-ID: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are fixes for bugs in the idxd driver that an in-kernel polling
client exposed while sharing DSA work queues between many io_uring rings
(that client is to be posted separately as "io_uring: DMA-engine copy offload
for buffered file I/O"). They apply to v7.3 on their own and do not
depend on that series. Each patch says which released kernels it
affects; the ones that fit stable are tagged.

In short:
 - the event-log fault path dereferences a NULL workqueue on a kernel WQ
   (stable, 6.4+), plus a hardening of the user WQ's workqueue teardown;
 - a memcpy longer than the work queue's transfer limit is accepted at
   prep and fails silently in hardware (stable, 5.10+);
 - a channel is listed before it is complete, and a failed registration
   leaves a freed channel on the list (stable, 5.13+);
 - the device driver is unbound after its work queues were freed;
 - terminate_all releases the work queue's interrupt handle for good
   (stable, 7.0+);
 - device commands wait forever, and the interrupt-handle release writes
   over a running command; the device disable misreads the fail-fast
   status as "already disabled"; the device is disabled after its
   queues' software state is gone; a reset loses the command interrupt
   it re-creates;
 - terminate_all frees descriptor slots the device still holds, and
   drains and resets report a timeout as a completed drain;
 - a descriptor whose submission failed is freed twice (stable, 5.14+);
 - an iaa_crypto descriptor is completed as a dmaengine transaction on
   abort and flush (stable, 6.8+);
 - software- and system-reset halts never flush the work queues, a halt
   flush strips the callbacks of live clients, and the interrupt-handle
   revoke runs without the queue lock.

Tested on a Granite Rapids system with four DSA devices: crc32c-verified
DMA I/O from the io_uring client under WQ unbind, live unbind and rebind,
driver unbind, PCI FLR and PCI driver unbind and rebind, on a v7.2-based
tree, clean under KASAN, DMA_API_DEBUG and lockdep; the v7.3 rebase is
conflict-free and build-tested per patch.

Daniel Byrne (17):
  dmaengine: idxd: don't queue EVL fault work for kernel WQs
  dmaengine: idxd: detach the user fault workqueue under the event log
    lock
  dmaengine: idxd: refuse a memcpy longer than the WQ max transfer size
  dmaengine: idxd: list a new channel only once it is complete
  dmaengine: idxd: unbind the device driver before its work queues go
    away
  dmaengine: idxd: keep the interrupt handle across terminate_all
  dmaengine: idxd: bound device command waits and fail fast after a
    timeout
  dmaengine: idxd: compare the device disable status code whole
  dmaengine: idxd: quarantine terminate_all's descriptor slots until the
    device has drained
  dmaengine: idxd: return -ETIMEDOUT from drains and resets and leak
    what the device may still write
  dmaengine: idxd: disable the device before its work queues are
    unregistered
  dmaengine: idxd: hold device commands off while the reset re-creates
    its interrupts
  dmaengine: idxd: fix the double free of a descriptor whose submission
    failed
  dmaengine: idxd: complete an iaa_crypto descriptor through its own
    driver on abort and flush
  dmaengine: idxd: flush the work queues on every halt type
  dmaengine: idxd: keep client callbacks on a halt flush and cancel
    resubmissions after a terminate
  dmaengine: idxd: run the interrupt-handle revoke under the queue lock

 drivers/dma/dmaengine.c   |  41 +++
 drivers/dma/idxd/cdev.c   |  62 +++-
 drivers/dma/idxd/device.c | 588 ++++++++++++++++++++++++++++++++++----
 drivers/dma/idxd/dma.c    |  60 +++-
 drivers/dma/idxd/idxd.h   |  53 +++-
 drivers/dma/idxd/init.c   |  64 ++++-
 drivers/dma/idxd/irq.c    | 258 +++++++++++++----
 drivers/dma/idxd/submit.c | 158 ++++++++--
 include/linux/dmaengine.h |   2 +
 9 files changed, 1109 insertions(+), 177 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

