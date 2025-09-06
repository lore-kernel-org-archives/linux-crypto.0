Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECB51C8630;
	Sat,  6 Sep 2025 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757161310; cv=none; b=roOSkJZuvLl7pI4AIo33NH73TIdRL8ZZlR8Zu6FrLyLNX8RWEHsRGlwWyQVtNb3o5ov/aP9iZNpF21sRVyQs7N+MrSEuzkV6wsRxDlxAUNNSL+sUoWCb5Bt634h5z2Q1gCle/OPpE+rMwG91tJX1rTZJ+VESUW9w+t9nQwP3HA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757161310; c=relaxed/simple;
	bh=LVu9YGaoVJEQyJmb9+Y1eQq40J+xELbQe/ERu9Ttj1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a8Xk8OMr+gBPtKZzumdd1JDd68/Ag6fOU3/c4pu1R5/R4XvIYEDImtu/pUjYDdh7fjkdMHaHpKzzXnt5mqq7yDe1siXi7mBWsR11JTSveH898e/L6h6qicH2vvZJXpF5aj13rEsx9yVTrTzgJX/v6xgpRHUJAdQZ6oXDl0hG+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6VuJrOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6VuJrOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20675C4CEE7;
	Sat,  6 Sep 2025 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757161309;
	bh=LVu9YGaoVJEQyJmb9+Y1eQq40J+xELbQe/ERu9Ttj1U=;
	h=From:To:Cc:Subject:Date:From;
	b=b6VuJrOHxWrSx78dLuxdqqsO5WWb/G+Ha+Z50ssFPL3lCO5frxpuFTO5CwPBsZTm4
	 zviy6iYPZ1oaWEUBE2XtIhnZlkFNA0vVvBcisrWK5uK5Ixc4eJPf/0LGwyJ34B+5JE
	 Ipj/OsY3T/9+jM07gm1hXxyjiCtq2hu2KmkPVtFlgLSF+erafFgoCli616kjfGa91m
	 uMfLT3+4YJH54JQ9BASdonkbOYJMlRE5NHPscOFhZXFP5dWIO5lRHrTGEaRc/EMJeR
	 REMcnK0C2RXskZdPBVx6QbOrJBFyyPIreZIzpaLYo/HkAiVit+8Sff0QTlRGlhKtjw
	 1+0nCjOiZqXag==
From: Borislav Petkov <bp@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH] crypto: ccp - Always pass in an error pointer to __sev_platform_shutdown_locked()
Date: Sat,  6 Sep 2025 14:21:45 +0200
Message-ID: <20250906122145.29784-1-bp@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

When

  9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")

moved the error messages dumping so that they don't need to be issued by
the callers, it missed the case where __sev_firmware_shutdown() calls
__sev_platform_shutdown_locked() with a NULL argument which leads to
a NULL ptr deref on the shutdown path, during suspend to disk:

  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 983 Comm: hib.sh Not tainted 6.17.0-rc4+ #1 PREEMPT(voluntary)
  Hardware name: Supermicro Super Server/H12SSL-i, BIOS 2.5 09/08/2022
  RIP: 0010:__sev_platform_shutdown_locked.cold+0x0/0x21 [ccp]

That rIP is:

  00000000000006fd <__sev_platform_shutdown_locked.cold>:
   6fd:   8b 13                   mov    (%rbx),%edx
   6ff:   48 8b 7d 00             mov    0x0(%rbp),%rdi
   703:   89 c1                   mov    %eax,%ecx

  Code: 74 05 31 ff 41 89 3f 49 8b 3e 89 ea 48 c7 c6 a0 8e 54 a0 41 bf 92 ff ff ff e8 e5 2e 09 e1 c6 05 2a d4 38 00 01 e9 26 af ff ff <8b> 13 48 8b 7d 00 89 c1 48 c7 c6 18 90 54 a0 89 44 24 04 e8 c1 2e
  RSP: 0018:ffffc90005467d00 EFLAGS: 00010282
  RAX: 00000000ffffff92 RBX: 0000000000000000 RCX: 0000000000000000
  			     ^^^^^^^^^^^^^^^^
and %rbx is nice and clean.

  Call Trace:
   <TASK>
   __sev_firmware_shutdown.isra.0
   sev_dev_destroy
   psp_dev_destroy
   sp_destroy
   pci_device_shutdown
   device_shutdown
   kernel_power_off
   hibernate.cold
   state_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

Pass in a pointer to the function-local error var in the caller.

With that addressed, suspending the ccp shows the error properly at
least:

  ccp 0000:47:00.1: sev command 0x2 timed out, disabling PSP
  ccp 0000:47:00.1: SEV: failed to SHUTDOWN error 0x0, rc -110
  SEV-SNP: Leaking PFN range 0x146800-0x146a00
  SEV-SNP: PFN 0x146800 unassigned, dumping non-zero entries in 2M PFN region: [0x146800 - 0x146a00]
  ...
  ccp 0000:47:00.1: SEV-SNP firmware shutdown failed, rc -16, error 0x0
  ACPI: PM: Preparing to enter system sleep state S5
  kvm: exiting hardware virtualization
  reboot: Power down

Btw, this driver is crying to be cleaned up to pass in a proper I/O
struct which can be used to store information between the different
functions, otherwise stuff like that will happen in the future again.

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..9f5ccc1720cb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2430,7 +2430,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 {
 	int error;
 
-	__sev_platform_shutdown_locked(NULL);
+	__sev_platform_shutdown_locked(&error);
 
 	if (sev_es_tmr) {
 		/*
-- 
2.51.0

