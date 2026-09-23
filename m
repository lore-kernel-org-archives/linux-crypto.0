Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5073EF649;
	Wed, 23 Sep 2026 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153317; cv=none; b=K7SSrZyU2TfAJ3ymgQ6xy6hbZ4XdppBx8dW4N2m6DfXiIDtCw4F2+ttRy7hrLltq0rhOcM9cEHQLT6S9dsPFcIelVMc8T6M5femcICnNJJigYkwbCLqQuLhYotfznz1MaCBhx6+2FYyjRgzggg7sPIeJlUyAnP0tMWMT8OeF6Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153317; c=relaxed/simple;
	bh=WFYAHlViBCqfI0KK7+DKs31c889CWenAhlH3w6Q8o8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=akTVKgcSEoX45sTOUaj6aWGC5+r+/0ME62ppM0F1VunqMLWIWzI4JtVzPBW3r+zoQkp65V9DvRVDFEcJKSy6FQapLUt2oYQQt1NVLiIEH4TaMEn4cu1DClQtGOLcuwzTUWrKOwvb3o2P+C+bpuiTwqV9KDBb6a5d7N9mbxsS6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=K9fCWCIf; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="K9fCWCIf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=79
	j2Q4MfSEaqDwOVOTqW37/tqjjDbYsDLiZ/iL+1x4U=; b=K9fCWCIfKb3p6SP5YG
	S7jHW09OOs+btIBGnNr0lU9Sr0BmnDgoOpD62HcJ8aeefou2K3g6KJLSyP6XjcDn
	se5K1XZ7QFJj9Kn44ZoGEx7Bkybo1kjTQFUTnSDukxgcnd/nWFnCM/oBx29uN4xf
	PGIMAoO1mV9bMioffMHXagtxc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXHyRIkrNqfwQ4AQ--.22208S2;
	Wed, 23 Sep 2026 16:48:09 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev
Subject: [PATCH v8 0/2] mfd: loongson-se: Add multi-node support and fix miscellaneous issues
Date: Wed, 23 Sep 2026 16:48:00 +0800
Message-Id: <20260923084802.29508-1-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXHyRIkrNqfwQ4AQ--.22208S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw48try7Zr17tw45Ww1UGFg_yoW5WrWkpF
	W5W345Cr4DGF4SkwnxXr409r15ZrZ5Ca15Can7ta47A3srtryFqF43ta45uFZruFZ2q3W7
	XFWDta1ku3W8C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j_2-nUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbCxQk+fWqzkkn7+AAA3O

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

- Patch 1 introduces the multi-node platform support.

  v6-v8: no changes
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

  v8:  
       - Remove the poll_lock added in v7

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

 drivers/mfd/loongson-se.c       | 119 ++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |   1 +
 2 files changed, 106 insertions(+), 14 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.2

