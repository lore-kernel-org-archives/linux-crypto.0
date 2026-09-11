Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424134611CF;
	Fri, 11 Sep 2026 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117410; cv=none; b=aaoPlP8KFBzunB0MIjx9p+5RaL29qeZxIWSlDUSdqMEimdKjQzFKYC4yANmCIHx5Iz1yNSeNCj9JFP81XeE1cV3/OWU/gEujzfhmB4IrJDG0IMpxTvTuBRVeQ5MLXM84b8C6ZCOmH6s8Yq7r5l0wOoKD5o8F9HLfP/WzXDRDYLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117410; c=relaxed/simple;
	bh=miczkEadzXzrHWkQLeIc5Wi4x9QcGfK+m9e5T3TPFi8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XiJ4xO4k+0wJTCv+Y0qkZfGkgxojfrOwMd49kEiARDPoqv4NkJuslRMvCSzHg3iqpgHVRIFYL+j7/rW7hL8Byy7mBiCsQgUsgxIvtODSAhpIMSaucqgKC6UjbAS03wWzYjrIOFTY5NX/T6wzqq9yr0o0MvCvodk+rFMluDL8slQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DuaeJLrh; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DuaeJLrh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xM
	HsitC1tg6E1bhUL7jBzEhhg2Vu1whjKmi4Gl/RbW8=; b=DuaeJLrhErejTCL4N9
	6SXuHnjFMM34DEdQtKj8pQTb3uKcLxtdR+qA6Sz5xcMFnHHS98kDR2Z8FpJ6SD01
	e2qHNB8NPziSb+9WtoMeLLtZ8aVwaz9QcWRywviL/vei+sSqdra9D7GNIri46fSX
	6UMs+5vhVk7A0lRQl99fZXLRc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDnjyvCw6Nq5PUqRA--.58051S2;
	Fri, 11 Sep 2026 17:02:59 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev
Subject: [PATCH v7 0/2] mfd: loongson-se: Add multi-node support and fix miscellaneous issues
Date: Fri, 11 Sep 2026 17:02:54 +0800
Message-Id: <20260911090256.7834-1-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDnjyvCw6Nq5PUqRA--.58051S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw48try7Zr17tw45ZF47Jwb_yoW5Wr1DpF
	W5W345Cr4DGr4IkwnxXr409r15ZrWrGF45Can7ta47A3srtr1vqF43ta45uFZrCrZ7t3W7
	XFWUta1ku3W8C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b82NtUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbCxQOk42qjw8OjBAAA3v

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

- Patch 1 introduces the multi-node platform support.

  v6-v7: No changes
  v5: Clear pending interrupts with S2LINT_CL before requesting IRQs,
       and move S2LINT_EN to after all interrupt handlers are registered.
  v4: Safely handling shared interrupt handler returns.
  v3: Using shared interrupts (IRQF_SHARED) instead of manually
      iterating through all devices to check for interrupts.

- Patch 2 focuses on structural and error-path hardening for the
  pre-existing baseline code. This includes resolving critical issues
  discovered by the Sashiko Automation system such as: completion
  race conditions, missing engine completion initialization, spinlock
  held with interrupts disabled for up to 10 ms, EPROBE_DEFER
  handling, DMA buffer overflow validation, interrupt cleanup on
  probe failure, and device removal ordering.

  v7:
       - Re-enable the interrupt under dev_lock in loongson_se_poll()
         instead of poll_lock, so both the mask and re-enable of
         SE_S2LINT_EN are protected by the same lock and cannot race
       - Wait for controller command completion with a bounded
         non-interruptible wait so a pending signal cannot leave the
         controller running while DMA buffers are torn down
       - Validate the id argument in loongson_se_init_engine() to
         reject engine 0 and out-of-bounds indices
       - Drop the redundant init_completion() in
         loongson_se_init_engine() now that probe() initializes all
         engine completions
  v6:
       - Mask the target interrupt, clear pending status, and
         reinitialize the completion under dev_lock before issuing a
         command, re-enabling the interrupt after triggering
       - Keep the original engine_init_lock scope instead of the
         broader cmd_lock mutex
       - Reuse loongson_se_send_controller_cmd() in the STOP path and
         register the stop handler before loongson_se_init()
       - Correct the dmam_size validation formula
  v5: Fix all issues reported by Sashiko analysis:
       - Initialize engine completions in probe to avoid NULL deref
       - Use cmd_lock mutex for command serialization, drop spin_lock_irq
       - Add reinit_completion to controller and engine command paths
       - Fix EPROBE_DEFER handling in platform_irq_count()
       - Validate dmam_size against minimum required size
       - Disable IRQs in probe error path after init failure
       - Add loongson_se_stop() devres cleanup with proper ordering
       - Use non-interruptible wait for STOP command
  v4: new patch


Qunqin Zhao (2):
  mfd: loongson-se: Add multi-node support
  mfd: loongson-se: Fix miscellaneous issues

 drivers/mfd/loongson-se.c       | 127 ++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |   1 +
 2 files changed, 113 insertions(+), 15 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.2

