Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D823806B5
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 22:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777933698; cv=none; b=eFrEihs6/v2TN3jPrLdi7ULVULNsZzqn+UrWAI+I/glm6xki7L7r+TQZiYqeiKXCXZU5sAprbvAga+kelkZLswbkjIq+yJypwOMoQ0ljvKSKpALHSReAZYkz+RgPH2IGxWwhL3J/YR+kET7J/uhmFXQ2n6Vlm19AUm+J6kmZs+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777933698; c=relaxed/simple;
	bh=nAdJEDyngH7dfU41fuTqWpnQUDFiP9+zU5ixevk6PFs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RWTzrsYGLWb0GsWC+4eHo94ACoXsIXnytqwL+SJB9ehisIm8YfAz9oK+rRdvTVOybfaCNDrRSimaxo3IihpGFTZe5QZWwf4ApmlgGtlXukVPfxofrT7w+BkuKpgvXHrvdospdaGjdSUwm9DtcEW6g6ajaTQ8SH4HX5NO3FO2rt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6HBctP8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6HBctP8"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f6b984b3aso2315494b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 15:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777933696; x=1778538496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxG9n89RcbpIujhXq1n/Govhp0ZWwsAPWFB7EmWSODM=;
        b=p6HBctP8dEa7nLbXL9ib8Ny4413DrpnYTiAgfSQzzrYXyHvTzd4oy21bx1BMdC9Tcx
         4HiPlL8kWngrd+W4MofL0Fwg2XqviE44jZA3pVsSMd2KeZUr0XcwyVQsMd9e9LHcWQpp
         cAK9DYh4BRnH5FWMGvnmVTueErtkEc+fvDswNOl5sSqqIh5nM3ULH+IUKDOaWGQLO2/C
         +RZojhfEG6adRngUqInZ/fXye2ksY1qyJ2Yo/ygJUHVgT9mgNh/5Guh+qKXPyDleivjT
         xYYIDTnbdw4J73/2wtGemuJYY62Cp0Cg36G0D0VG+Y9CBUCuaYwO6hSXRfiQxM2g8Czg
         j6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777933696; x=1778538496;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxG9n89RcbpIujhXq1n/Govhp0ZWwsAPWFB7EmWSODM=;
        b=Fon24izW9q97Rb9edOa0BkFceWKYyYL9e5ZtRlmhvmUTroz7rZheVnF3uI2y+U7PKB
         JpAJn6Q3mcNzkdJmm8JaBMlwSjf7iFjIbQpSPRVtD1nPo65ZO0bl2uAdbL72MFAyE6cB
         EG66u1EpWnpxYsPsHl8su+Sbq3VNF6hoHhngi9/J0vSF1c1Jv9nX9vkB4v34FSlYqHrA
         f0/wfVrBChPDdCINTiZJgJbD3T/DcmdDvXa34nBn7C6yk3W1w5jQfuM/zjkCgPFaIpZM
         PtLFfItrcYEd9WQa9OuIvhj5TULsvk8oWXEcIwve9Vwongs8ynPDVXq93EqhBr+8GQ0K
         Qd9Q==
X-Gm-Message-State: AOJu0Yz+NzxnVNDqz+q0CgeId2R7oSSuA6am6InkMCveSPfZ3kN/fmuh
	WgXf6Yqy086lv2v5se1G6Qb5UslNXfcki+0mM+w40rgqTJkDQkYyvdmWJ+kPza5VQnKw4gb6ODC
	Yea4veA==
X-Received: from pfnd3.prod.google.com ([2002:aa7:8143:0:b0:82f:7163:35c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b55:b0:82c:d9d0:f482
 with SMTP id d2e1a72fcca58-83924eb8dd2mr626887b3a.46.1777933695533; Mon, 04
 May 2026 15:28:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  4 May 2026 15:28:12 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504222812.2339526-1-seanjc@google.com>
Subject: [PATCH] crypto: ccp: Treat zero-length cert chain as query for blob lengths
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When handling a PDH export, treat a zero-length userspace cert chain buffer
as a request to query the length of the relevant blobs.  Failure to account
for the zero-length buffer trips a BUG_ON() when running with
CONFIG_DEBUG_VIRTUAL=y due to trying to get the physical address of the
ZERO_SIZE_PTR (returned by kzalloc() on the bogus allocation).

   kernel BUG at arch/x86/mm/physaddr.c:28 !
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 30 UID: 0 PID: 28580 Comm: syz.2.18 Kdump: loaded
  Tainted: G        W           6.18.16-smp-DEV #1 NONE
  Tainted: [W]=WARN
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.62.0-0 11/19/2025
   RIP: 0010:__phys_addr+0x16a/0x180 arch/x86/mm/physaddr.c:28
  RSP: 0018:ffffc9008329fc80 EFLAGS: 00010293
  RAX: ffffffff8179110a RBX: 0000778000000010 RCX: ffff8884e6992600
  RDX: 0000000000000000 RSI: 0000000080000010 RDI: 0000778000000010
  RBP: ffffc9008329fdf0 R08: 0000000000000dc0 R09: 00000000ffffffff
  R10: dffffc0000000000 R11: fffffbfff126d297 R12: dffffc0000000000
  R13: 1ffff92010653fc8 R14: 0000000080000010 R15: dffffc0000000000
  FS:  0000555556bec9c0(0000) GS:ffff88aa4ce1c000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fd3159e7000 CR3: 00000004fbc44000 CR4: 0000000000350ef0
  Call Trace:
   <TASK>
    [<ffffffff853d3869>] sev_ioctl_do_pdh_export+0x559/0x7a0 drivers/crypto/ccp/sev-dev.c:2308
    [<ffffffff853d1fdd>] sev_ioctl+0x2cd/0x480 drivers/crypto/ccp/sev-dev.c:2556
    [<ffffffff82549ebc>] vfs_ioctl fs/ioctl.c:52 [inline]
    [<ffffffff82549ebc>] __do_sys_ioctl fs/ioctl.c:598 [inline]
    [<ffffffff82549ebc>] __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
    [<ffffffff8630115f>] do_syscall_x64 arch/x86/entry/syscall_64.c:64 [inline]
    [<ffffffff8630115f>] do_syscall_64+0x9f/0xf40 arch/x86/entry/syscall_64.c:98
   [<ffffffff81000136>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7fd3158eac39
   </TASK>

Thankfully, the bug is benign outside of CONFIG_DEBUG_VIRTUAL=y as getting
the physical address is just arithmetic, and the PSP errors out before
trying to write to the garbage address (which it must, otherwise querying
the blob lengths would clobber memory at pfn=0).

Fixes: 76a2b524a4b1 ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..ed3b8065f59b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2301,7 +2301,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
 	    !input.pdh_cert_len ||
-	    !input.cert_chain_address)
+	    !input.cert_chain_address ||
+	    !input.cert_chain_len)
 		goto cmd;
 
 	/* Allocate a physically contiguous buffer to store the PDH blob. */

base-commit: 2d4aef3da2981e326a88f8b07249083150ae3ef3
-- 
2.54.0.545.g6539524ca2-goog

