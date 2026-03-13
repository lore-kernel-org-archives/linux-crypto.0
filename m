Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9BB3E3C54
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 22:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773442719; cv=none; b=EZ/LuCpCAhtFWgkiKDncR7SMNx69M0omoycnDSe491pnl4XLxf5GG0EjdKvax4r0yVtaa5A2/iMwrSnF7TAjbCa7ooFuGHI6bM2yhdYMbxJCCKg7mM7xqbqLCFaug+PfVuIaseRZnLXNTdszoYzvdI9QuEImTug83Ra54iIzYlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773442719; c=relaxed/simple;
	bh=3kZBp34QHPnWOkKsdkMOMumBAyYT2+CBGfH1b7FItMA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=h1TFfR+eRtWx/KraBFT53wfPZSq2DAVLhWgrF3TYXUeisF2W0jjW1sARAUmn27ZAOo/Fy6VhrMhUD5SGv0RdSP624xirvCmOkcBpB+KHsBfPZifisyatAxvUgaAVO3xByTXel1xeotL16n0PskLkqaTnkA6Q01c3DIWKxH6o+gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FjP7ddBI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FjP7ddBI"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35a203038c8so1742228a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 15:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773442717; x=1774047517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fFWZXhlihsWtwYAozJDDCeA0FVsn3VlqEhc7IimzQf4=;
        b=FjP7ddBIaYU+G6ResyQNRDqOtSYgEVuwoIC9fJfKYV69qD33FVvQVkIcyAgm3xwh53
         Ms7V8JJauX6hvBD2ZpQEU4RklQ7w3x5loANKkCM6ftsAAD2aqbXbwwKXQlkmqi07c6wW
         jkOiYUEZIeoAiQNkkDfTL3m9p5hMJqftcl+MKhE4uMuSKeAgiHF63rAxClzplaj5hh8U
         AKapBRSV655jXUBiSQ/Zm6rYE3VrlimpRwTEWvcwtbAYDOJAjQOYa/gB3EpghabYBIOW
         730Ygrz3h2F37ExJdhMrM9pAne25gzOhGElCJXIgFrkrHF62MkmlmMnfFC0F23nO8iEw
         dCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773442717; x=1774047517;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fFWZXhlihsWtwYAozJDDCeA0FVsn3VlqEhc7IimzQf4=;
        b=QxV3D7sdVPT/Tt0rm4hd/UjPycTNbORwPzOaqYaVcuXsS6HcG6L9tSc8zUAnH0DGBQ
         BPtCMhOQjWy0y1l6PvANi5ThCXkDR9hqikMv622F6F4CqyT0RtN9r6x4ZgSEjGM+GWle
         Ixa/CYRAJix2lcU8h2K1X05O2yR8J7TFrYkKrDWO6CaZGQwX8g9AKX2XfCkb1b5z3m9l
         z+1cJBeMCzQjLo/tUOyOHWxi6IdkguVyow/8NQx2ORiofLK8d0Zlr/QvBnd0l+8agI8C
         mjLYs2+L5fJl+vfUv57wboyUYc1maB1Qo+BpbllkeQGxMTZ43LX+WihXlibbR2aak8pZ
         7L2A==
X-Gm-Message-State: AOJu0YygOoAfkhTDUhVSb4zJz7uJMZ4Qt3xdS2Bq80d9Dfz9UKTN3tXA
	bDa3iNn0+wjx6SrZ3/UhEbc6oCatA+pRx9m2GELZQ03jOH1vpQ79eMnKTZP/yOr9UejawT55WpU
	uVuSU7w==
X-Received: from pgmp7.prod.google.com ([2002:a63:1e47:0:b0:bac:6acd:818b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c1:b0:359:fecd:1cb6
 with SMTP id 98e67ed59e1d1-35a21cb4b21mr4507609a91.0.1773442716988; Fri, 13
 Mar 2026 15:58:36 -0700 (PDT)
Date: Fri, 13 Mar 2026 22:58:35 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <abSWm4wyY91I4zf8@google.com>
Subject: [BUG REPORT] crypto: ccp: Interrupting INIT_EX firmware writeback
 crashes host
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>
Cc: linux-crypto@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>, 
	David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="us-ascii"

So... while doing stupid things I accidentally stumbled on a flaw with SEV's
SEV_INIT_EX support.

If userspace CTRL-C's an SEV ioctl that triggers "auto" initialization, e.g.
SEV_PEK_CSR, and the fatal signal causes the kernel_write() in
sev_write_init_ex_file() to fail, I'm fairly certain the on-disk firmware data
gets corrupted, and can lead to some wild crashes.

After getting the -EINTR, INIT_EX fails and SEV is completely unusable. 

[  166.178620] ccp 0000:24:00.1: SEV: failed to write 32768 bytes to non volatile memory area, ret -4
[  166.187617] ccp 0000:24:00.1: SEV: INIT_EX failed 0x0, rc -5
[  255.102921] ccp 0000:24:00.1: SEV: INIT_EX failed 0x1, rc -5

At this point, all sorts of things go wrong.  If the ccp driver is unloaded and
reloaded, *without* deleting and recreating the on-disk file, the kernel will
crash when attempting to reload the ccp driver.  E.g. see the splat at the bottom.

If I delete the on-disk file (prior to unloading ccp), INIT_EX continues to fail,
and the platform chugs along, at least for a while.  I even managed to unload and
reload ccp and got SEV usable again, but only once.

Every other time, I've observed what appears to be widespread data corruption in
the kernel, e.g. corrupted page tables, NULL pointer derefs in completely unrelated
code, and so on and so forth.

FWIW, I've also seen this:

[  729.245590] ccp 0000:11:00.5: SEV: could not read 32768 bytes to non volatile memory area, ret 0
[  729.363068] ccp 0000:11:00.5: SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.

even when SEV was "healthly".

The easiest way to reproduce is to get ccp + kvm loaded on a non-SNP, but _don't_
run any SEV VMs, so that e.g. SEV_PEK_CSR is forced to initialize and shutdown the
PSP on every call (see commit ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP
init and shutdown in ioctls").  Then do SEV_PEK_CSR in a loop in userspace, and kill
the process.  The initialize+shutdown behavior makes the window for getting -EINTR
quite large, e.g. I can hit it just by manually doing CTRL-C ~25% of the time.

Given that all of this requires elevated permissions, and in practice for the PSP
to be in an uninitialized state, I'm not concerned about unprivileged userspace
doing bad things.  But I do thing we should try to harden INIT_EX against failure
to write to disk, because the esclating from "cancel a file write" to "system is
on fire" isn't very pleasant.

[  210.532156] ccp 0000:11:00.5: SEV: INIT_EX failed 0x1, rc -5
[  215.351268] ccp 0000:11:00.5: SEV: INIT_EX failed 0x1, rc -5
[  225.961467] BUG: unable to handle page fault for address: ffa00000324a97e0
[  225.961901] #PF: supervisor read access in kernel mode
[  225.962345] #PF: error_code(0x0000) - not-present page
[  225.962593] PGD 100000067 P4D 101820067 PUD 60500ba067 PMD 0 
[  225.962876] Oops: Oops: 0000 [#1] SMP KASAN
[  225.963085] CPU: 174 UID: 0 PID: 17365 Comm: modprobe Tainted: G    BU  W           7.0.0-smp--830fa8710ad0-kasan #104 PREEMPTLAZY 
[  225.963638] Tainted: [B]=BAD_PAGE, [U]=USER, [W]=WARN
[  225.963883] Hardware name: Google Astoria/astoria, BIOS 0.20250817.1-0 08/25/2025
[  225.964235] RIP: 0010:simplify_symbols+0x32f/0x650
[  225.964479] Code: e7 e8 55 37 63 00 49 8b 04 24 c1 e3 06 48 01 c3 48 83 c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 31 37 63 00 <48> 8b 1b 49 83 c7 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c
[  225.965328] RSP: 0018:ff110062e0fa7b50 EFLAGS: 00010246
[  225.965585] RAX: 1ff40000064952fc RBX: ffa00000324a97e0 RCX: ffffffffc09a0198
[  225.965922] RDX: 0000000000001c7c RSI: ff110062e0fa7db0 RDI: ffa00000320aace0
[  225.966259] RBP: ff110062e0fa7c70 R08: ffa0000132053498 R09: 0000000000000000
[  225.966596] R10: dffffc0000000000 R11: fffffbfff811a05f R12: ff110062e0fa7dd0
[  225.966938] R13: dffffc0000000000 R14: 000000000000000d R15: ffffffffc09a02d0
[  225.967275] FS:  00007fba2c441740(0000) GS:ff1100bf3377f000(0000) knlGS:0000000000000000
[  225.967652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  225.967928] CR2: ffa00000324a97e0 CR3: 00000061f90a0002 CR4: 0000000000f71ef0
[  225.968268] PKRU: 55555554
[  225.968409] Call Trace:
[  225.968540]  <TASK>
[  225.968658]  ? setup_modinfo_srcversion+0x1c/0x50
[  225.968889]  ? setup_modinfo+0x371/0x4d0
[  225.969083]  ? show_modinfo_srcversion+0x80/0x80
[  225.969324]  load_module+0x41f0/0x4fb0
[  225.969512]  __se_sys_finit_module+0x384/0x580
[  225.969741]  do_syscall_64+0xe8/0x890
[  225.969925]  ? trace_irq_disable+0x60/0x1c0
[  225.970131]  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  225.970383]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  225.970627] RIP: 0033:0x7fba2c579099
[  225.970810] Code: 00 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 07 f9 06 00 f7 d8 64 89 01 48
[  225.971679] RSP: 002b:00007ffcdf8ba828 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  225.972035] RAX: ffffffffffffffda RBX: 000000001289de10 RCX: 00007fba2c579099
[  225.972377] RDX: 0000000000000000 RSI: 000000001289e250 RDI: 0000000000000003
[  225.972717] RBP: 00007ffcdf8ba870 R08: 0000000000000000 R09: 0000000000000000
[  225.973054] R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000040000
[  225.973391] R13: 0000000000000000 R14: 000000001289e250 R15: 0000000000000000
[  225.973730]  </TASK>
[  225.973849] Modules linked in: irqbypass vfat fat dummy bridge stp llc k10temp i2c_piix4 cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd [last unloaded: ccp]
[  225.974609] CR2: ffa00000324a97e0
[  225.974778] ---[ end trace 0000000000000000 ]---
[  225.975005] RIP: 0010:simplify_symbols+0x32f/0x650
[  225.975245] Code: e7 e8 55 37 63 00 49 8b 04 24 c1 e3 06 48 01 c3 48 83 c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 31 37 63 00 <48> 8b 1b 49 83 c7 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c
[  225.976099] RSP: 0018:ff110062e0fa7b50 EFLAGS: 00010246
[  225.976350] RAX: 1ff40000064952fc RBX: ffa00000324a97e0 RCX: ffffffffc09a0198
[  225.976687] RDX: 0000000000001c7c RSI: ff110062e0fa7db0 RDI: ffa00000320aace0
[  225.977024] RBP: ff110062e0fa7c70 R08: ffa0000132053498 R09: 0000000000000000
[  225.977361] R10: dffffc0000000000 R11: fffffbfff811a05f R12: ff110062e0fa7dd0
[  225.977702] R13: dffffc0000000000 R14: 000000000000000d R15: ffffffffc09a02d0
[  225.978040] FS:  00007fba2c441740(0000) GS:ff1100bf3377f000(0000) knlGS:0000000000000000
[  225.978416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  225.978691] CR2: ffa00000324a97e0 CR3: 00000061f90a0002 CR4: 0000000000f71ef0
[  225.979029] PKRU: 55555554
[  225.979168] Kernel panic - not syncing: Fatal exception
[  225.993094] Kernel Offset: 0xf400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
