Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8853AA1B0;
	Mon,  7 Sep 2026 02:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788748741; cv=none; b=hRUzqR9SmQ1ZKudhTqsjBp+caoTkjszvFyWMXaHVES36PAdEaubsbOK93ILA0i1cliEdbuF2BcyWR2gp0+WRO00yXYgVEEj4NpJaIT9k5gjwYNDy6G+Usy9NPckJtCtkGPZoGYHYnXMMAWYchcnbokyrxpnwkjuwtn8iqkmF2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788748741; c=relaxed/simple;
	bh=pEfTD7XRTj7vv40tU/H4w2ItBtIf6jB6kOmsKCjhRYI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pYLptgIcnpUGvkls48TTyXDJNEe0UT5igPbNrHulmPBPP7DAmWTEh2DNvcsZSqeu8O7ar7FaImmGNDBEE4TVljgknGNwav7/FdScDocg0s74mTfYCkgjWu992dXw7ihoF6Mt8BmzPtitofoGp7X3irYmVhgfYYBj1m5YZcUfXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RFLUqz51; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RFLUqz51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xS
	p8M10DEpKkRdDFCj4PAI7qKkNrbLVIt/0nGZ318Lo=; b=RFLUqz51tu3YP/fWBR
	W7+cU7LCzo0JvRzhOXRmy/eX32+VHbGJ0dcp8b/Atxema/+qWSVX/k+UGqz4FhlI
	TPaUHIZnL8g4399WGRHPuBdQEDni01fhjkFwXM61c9Ubee0vaCowBM87o3p5FSuV
	kuO46ONfhx5fE8yVQ8d/GsuOM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD399KkI55qynlmBA--.44662S2;
	Mon, 07 Sep 2026 10:38:29 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v6 0/2] mfd: loongson-se: Add multi-node support and fix miscellaneous issues
Date: Mon,  7 Sep 2026 10:38:25 +0800
Message-Id: <20260907023827.14905-1-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD399KkI55qynlmBA--.44662S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr4UWF17ur13Xw15tr43Jrb_yoW8KryfpF
	W5W345Ar4DKrWIkwnxXF409r1rXrWrCF45Can7W347A3srtr1vqF43ta45u3y7CFZ7t3W2
	qFWUta18uF18C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bj4SwUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbCxQU0c2qeI6W02AAA3Z

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

- Patch 1 introduces the multi-node platform support.

  v6: No changes
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

  v6:
       - Still use init_completion() in loongson_se_init_engine.
       - Serialize command submission with a new poll_lock spinlock
       - Mask the target interrupt, clear pending status, and
         reinitialize the completion under dev_lock before issuing a
         command, re-enabling the interrupt after triggering new cmd
       - Keep the original engine_init_lock scope instead of the
         broader cmd_lock mutex.
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

 drivers/mfd/loongson-se.c       | 105 ++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |   1 +
 2 files changed, 93 insertions(+), 13 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.2

