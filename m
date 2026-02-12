Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE97194AD7;
	Thu, 12 Feb 2026 01:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858611; cv=none; b=ULpnJrcBdRXvhFVHBtVpylRD9dxCMHgRK9S3G1ClZPDhl/yZD0LFt9T1sT7/kdTgnukhUbxOasaGuEzj8eOHUkzTw70Rlr27BPUSBbPdIm3c0W1jRvBUO7C3+V2gA1S3ACOV7gDPR4buYZ8akpB3XRjqf6Bh54vhX3/84P2MZNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858611; c=relaxed/simple;
	bh=ol3ynPd9prBcg7JzeK79Mqng5RN1/fzAtgcIP1PsSBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oDiSJl4KzeIPKkW8qOi45+5s/dyMngTcTV9oMP9SJOWUC3mPLP262B1Fyp8/OehTUIx6EEc9lRUoNUKVMA5EEEErBHbS8Xj8kle3O7fsk1ga/UpWysXFxAmwTWGXv7PdHTWhPQ/EYgeRzuT/075v2XfuGcANslm8f1Jl74srkGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fE0HvcNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fE0HvcNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7B9C4CEF7;
	Thu, 12 Feb 2026 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858610;
	bh=ol3ynPd9prBcg7JzeK79Mqng5RN1/fzAtgcIP1PsSBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE0HvcNXY8I5TwUiXy/DeuF6uQ1Lv3D3IabtxLHPhTvm1DlCkhvpfp2SOHmrbpZvw
	 TsI33yulTm4ab6dpOGKsI0eCYXNN9n2PCpOPtgdJu49Ru3TntFSTv66zJb1VaVndQE
	 YjE9Xxx3L2+zTAbts1gutkdjzAHvK8zNO3tSXb335z5J2gJV+H58JX0kd4lk7pHsXN
	 RF2HpWfYx9bqCsMeYTe8cwbwK/hs75C4lWg7zRpaQjRED5QQvCjxmqT1cR/WgOrzG1
	 oFD5q6vTKukPBMoYyOWSH6cWSRwNVmzCtxXHeIrCls/Z2KPpEbuto7tHe8A/SazcEL
	 O5LvMSZ++Cmcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] crypto: hisilicon/qm - move the barrier before writing to the mailbox register
Date: Wed, 11 Feb 2026 20:09:31 -0500
Message-ID: <20260212010955.3480391-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit ebf35d8f9368816c930f5d70783a72716fab5e19 ]

Before sending the data via the mailbox to the hardware, to ensure
that the data accessed by the hardware is the most up-to-date,
a write barrier should be added before writing to the mailbox register.
The current memory barrier is placed after writing to the register,
the barrier order should be modified to be before writing to the register.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the full analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is clear and specific: it moves a write memory
barrier (`dmb oshst`) from **after** the MMIO store instruction (`stp`)
to **before** it. The stated rationale is that the hardware must see the
most up-to-date data before being triggered by the mailbox register
write.

### 2. Code Change Analysis

The change is in `qm_mb_write()`, which is the function responsible for
atomically writing 128 bits to the HiSilicon QM mailbox MMIO register to
trigger a hardware operation.

**Before (buggy):**

```611:620:drivers/crypto/hisilicon/qm.c
#if IS_ENABLED(CONFIG_ARM64)
        asm volatile("ldp %0, %1, %3\n"
                     "stp %0, %1, %2\n"
                     "dmb oshst\n"
                     : "=&r" (tmp0),
                       "=&r" (tmp1),
                       "+Q" (*((char __iomem *)fun_base))
                     : "Q" (*((char *)src))
                     : "memory");
#endif
```

Sequence: `ldp` (load 128 bits from memory) -> `stp` (store 128 bits to
MMIO) -> `dmb oshst` (barrier)

**After (fixed):**
```asm
ldp %0, %1, [src]     ; Load 128 bits of mailbox data from memory
dmb oshst              ; Store barrier - ensure all prior stores visible
to device
stp %0, %1, [mmio]    ; Write 128 bits to MMIO register (triggers
hardware)
```

Sequence: `ldp` -> `dmb oshst` -> `stp`

### 3. The Bug Mechanism

The ARM64 instruction `dmb oshst` is a **Data Memory Barrier** with
**Outer Shareable** domain and **Store-Store** ordering. It ensures that
all stores program-ordered before the barrier are observed by all agents
in the outer shareable domain (including DMA devices) before stores
program-ordered after the barrier.

The call chain is:
1. `qm_set_and_get_xqc()` writes data to a DMA-coherent buffer via
   `memcpy(tmp_xqc, xqc, size)` (line 715)
2. It prepares a mailbox structure containing the DMA address of that
   buffer
3. `qm_mb_nolock()` -> `qm_mb_write()` writes the 128-bit mailbox to the
   MMIO register
4. The hardware reads the mailbox, extracts the DMA address, and DMA-
   reads from that buffer

With the barrier **after** the `stp`:
- The ARM64 weak memory model allows the CPU to reorder the `stp` (MMIO
  write, which triggers the hardware) **before** the `memcpy` stores to
  the DMA buffer are globally visible
- The hardware gets triggered and attempts to DMA-read the buffer, but
  the data isn't there yet
- Result: **hardware reads stale/incorrect data** from the DMA buffer

With the barrier **before** the `stp`:
- All preceding stores (including the DMA buffer writes) are guaranteed
  to be visible to the device before the MMIO write
- The hardware is triggered only after the DMA data is committed
- Result: hardware correctly reads the intended data

### 4. Impact and Severity

This is a **data correctness bug** affecting the HiSilicon crypto
accelerator (used in HiSilicon Kunpeng ARM64 servers). The
`hisi_qm_mb()` function is called from 9 different callers across the QM
driver and VFIO driver, including:
- `__hisi_qm_start` (queue startup)
- `qm_stop_qp` (queue stop)
- `qm_drain_qm` (queue draining)
- `qm_set_and_get_xqc` (configuring SQC, CQC, EQC, AEQC)
- VFIO live migration paths

If the hardware reads stale DMA data, the consequences could include:
- **Incorrect crypto operations** (data corruption in
  encryption/decryption)
- **Hardware timeouts** (mailbox operation failures)
- **Undefined hardware behavior**

### 5. Scope and Risk Assessment

- **Lines changed**: 4 lines modified (2 line reorder + 4 lines of
  comment added)
- **Files changed**: 1 file (`drivers/crypto/hisilicon/qm.c`)
- **Risk**: Extremely low. The fix simply moves an existing barrier
  instruction to the correct position in the assembly. No new logic is
  added; the semantic intent is preserved but the ordering is corrected.
- **Regression risk**: Essentially zero. The barrier provides the same
  protection, just at the right time.

### 6. History of this Code

The original code (commit `263c9959c9376e`, v5.4) used `dsb sy` (full
synchronization barrier, all domains) after `stp` — also in the wrong
position. Commit `4cda2f4a0ee68a` (merged in v5.19) "optimized" the
barrier from `dsb sy` to `dmb oshst` (a weaker but sufficient barrier)
but kept it in the wrong position. The current fix addresses the
ordering issue that has been present since the driver was originally
written.

### 7. Applicability to Stable

The `dmb oshst` instruction was introduced by commit `4cda2f4a0ee68a`
(v5.19). Stable trees from v5.19 onward have this exact code and can
apply this fix directly. For older stable trees (v5.4-v5.18), the
barrier was `dsb sy` but had the same ordering problem — a similar fix
would need to be adapted.

### 8. Non-ARM64 Path Comparison

The non-ARM64 path does:
```c
memcpy_toio(fun_base, src, 16);
dma_wmb();
```

This also has the barrier after the write, but on x86 (the primary non-
ARM64 platform for this driver), stores to uncacheable/write-combining
MMIO memory are strongly ordered by the architecture itself, so the
barrier placement doesn't matter. The issue is ARM64-specific due to its
weak memory model.

### 9. Conclusion

This commit fixes a real memory ordering bug on ARM64 that has existed
since the driver was introduced in v5.4. The bug can cause the HiSilicon
hardware accelerator to read stale data from DMA buffers, potentially
leading to data corruption in crypto operations or hardware errors. The
fix is tiny (reordering 2 lines of inline assembly), obviously correct
per ARM64 memory ordering semantics, carries essentially zero regression
risk, and affects actively-used hardware (HiSilicon Kunpeng servers). It
meets all stable kernel criteria.

**YES**

 drivers/crypto/hisilicon/qm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index d47bf06a90f7d..af9dd4d275f9f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -609,9 +609,13 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 	}
 
 #if IS_ENABLED(CONFIG_ARM64)
+	/*
+	 * The dmb oshst instruction ensures that the data in the
+	 * mailbox is written before it is sent to the hardware.
+	 */
 	asm volatile("ldp %0, %1, %3\n"
-		     "stp %0, %1, %2\n"
 		     "dmb oshst\n"
+		     "stp %0, %1, %2\n"
 		     : "=&r" (tmp0),
 		       "=&r" (tmp1),
 		       "+Q" (*((char __iomem *)fun_base))
-- 
2.51.0

