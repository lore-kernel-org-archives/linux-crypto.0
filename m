Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B45429CE8;
	Thu,  8 Oct 2026 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444764; cv=none; b=mm6nhB6luAV+NqWePsw7RP8kqN755lzHEXjN8YwuZuMIkZg+2JVmgEAtEDDDGMGdICKSYTMwlgHxmnBodPUE7yYXWQkUGIJHfkBh5dOIT+fwCNHi9lhJqgrhBXgErJElpKoFSxJGt3NScj0ucF54LVJGbIoT3ICweaQxcFec8MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444764; c=relaxed/simple;
	bh=W2SLbqd2xBK5qGql3qW8bR0TpoH/wQ3q7wnDbVkviqs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XqiKwJAasDKLRV1mMqeGcaKFA5nR67xoKL0UTXg/7SalYHJh3mshWacdciEViZTERD4GNqJZaJCCV+Jd/6ZNoD0mlF/GZZ4jkHP6Rc0HJNevOq+Lc8zb+1Xip0kFqSvvAD8Sp2YDzCB3lzZQ300/R7G64H2cmF3Xd0dXgCo3NwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=THa/6USN; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="THa/6USN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=AB
	76wT+kAafII40R0w3J8+4pHsqj1QhkmXqpKw8ObTQ=; b=THa/6USNjR3osX+D+g
	uvJc7bhRw2vmyrFEadet7IeM1482sb1MederSaxTMCI+qrG6ZkJApGy2zYlU59a9
	bZ8SoAYI8buCqXzlZPRUR9E3n9IjZyUsWeI+iDvVhFptbcIOUDU+IAg1DkoReUp0
	T0Zjsbim8JDgD6AK6i4LWp1wo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3v07tRsdqtq9hDA--.12178S2;
	Thu, 08 Oct 2026 15:31:58 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev
Subject: [PATCH v9 0/2] mfd: loongson-se: Add multi-node support and fix miscellaneous issues
Date: Thu,  8 Oct 2026 15:31:49 +0800
Message-Id: <20261008073151.15808-1-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v07tRsdqtq9hDA--.12178S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw47tr43Jw4xWF1kZw1xuFg_yoW5AryDpF
	W5W345Cr4DGF4SkwnxXw409r15Z3yrGF45Can2q3W7A3srtry8XF43ta45uFZrurZ7t3W7
	XFWDta1ku3WkC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrhL8UUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbCxQ5ZmGrHRu7FHgAA3U

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

- Patch 1 introduces the multi-node platform support.

  v9: Keep checks immediately after allocation calls
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

  v9:  - Keep checks immediately after allocation calls

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
 2 files changed, 105 insertions(+), 15 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.2

