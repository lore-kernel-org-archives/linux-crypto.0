Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86462114
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jan 2025 00:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556031; cv=none; b=svuWM9p5WNBS4NdEXXinZ7fYkPtgL//J/h3GOfKIyzSOLxi4NF0GTLFAyYJUQHtUxgzr/EE9e0SwuGy8pMzaq8Vl5oLlQGUGJhVl59oK5WR4/wFQRUeN+DosrM0Nu+1BLhMkhUwZhNL3VqrLaITq4cIcDWHLqAFzBIvoRrJ/D0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556031; c=relaxed/simple;
	bh=LYCX+42re+3E8A1I0Co36RucaMGSTo7jis8Nnz9qJdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XZ2rWXKepKlvlk+YFsyUP5F3p0OLBU1uzvwQsCsKQK7lXScAmORRp3zeD+cOYnRjZ5YXvM2vGV7OTT9aaLXLGbq9OqZ2HzPa7y8SO/wJu1vEbx0q+hPWEkQ3sfmvp9hnxFdAy4QF4R0wOBwLdgpnvDqfR69FMZk2e68qDDu6BOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q+m3kt5z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q+m3kt5z"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso4770929a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jan 2025 16:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556029; x=1737160829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9yMVbiaBA6FoWo38EEFg01Y6eTRR0fobEa+ZtoTkLg=;
        b=q+m3kt5zE+fp/tMuaIqWCBIAkwiwWTHsDPSgpolfnxABpI6VJGxmWGDh0P2sRQJy26
         Vc1jUrfTbavrHAIZ4sn2LOTbae2yyCb98WpR7Z5YTb8DUBZQkhYB0PtKCVL2IJPcYtiO
         oBcWuVBxOS+e3DK2s8+l6VWG5ZiBA0uvlqHM2GqZsatU6kAX3BNs1OSSM6V5AHH+q9M6
         t/iU1g6p0RE+5ni82j6cMJNxVkV9A3Ut5QTRD5PxqhCr1FoSsSUnMqbk/RThwl8wRAAS
         4Nc/iqf8mpogDouBUBndcRG4tyELvIhjOiXy6woOdGx9lyoO/+KFN74SpOMlSgTZl2B1
         ENvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556029; x=1737160829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9yMVbiaBA6FoWo38EEFg01Y6eTRR0fobEa+ZtoTkLg=;
        b=FN2ZGva94ESHSWkZ5v0uVUBGUxfj8POJxNFjAg7twZLjvlwg/8AbPpHf98aFeYzz9g
         Erij2Sgv07N5rUdrdvzzbURuf8T9t3nAW+YjgLGTmlE5ycjpl0hwH4KzBUMG3YegDPdB
         bm1n+JE+JTq4FYdEC1Wz2tjMiFJPvgn5OLPsXa9m7DfXex8wwBDEOJAuqK3t+cdM/F5b
         mjMQLr+MUJncUop4UR3yFNZ3K8nMFN/+g5EPi4K49SO++OBGOGF7vP93B7hn9YcdP5FI
         RDF9i4/04KkzwIuFBSBzBRHW8QbaHFy7adBcTtFZOe4xncUWmgySqBp2URbqKvdrWoC8
         b12Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7Cj3G5weZgz6oEoesP6VhwSMlSMRSkRrqcLaQMTq+GGuA12dsxHCnAWxLBTtNr76wH7HVFJCVXwpfCMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzggCuEKULwQLEtHd5VvluDHn86cbkTFgy3lwXrq8qgnS5I/kF7
	M5LeaeAizOp2x8EocPKjABTKIgqUSnW5q2aWeHnGiDOYlFyC23jIBsbV5vY90/tmIjWaW9aoHey
	CPA==
X-Google-Smtp-Source: AGHT+IF6dJqkFdvJ/t4pUYySPc+qKbEBtTOzjtwAhnrNAl1U2vPupjI6nWiArj29VBbhv0O4Szus9aJ2EzQ=
X-Received: from pjbsb4.prod.google.com ([2002:a17:90b:50c4:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540e:b0:2ee:a76a:830
 with SMTP id 98e67ed59e1d1-2f548f1b2bfmr20165708a91.24.1736556029072; Fri, 10
 Jan 2025 16:40:29 -0800 (PST)
Date: Fri, 10 Jan 2025 16:40:27 -0800
In-Reply-To: <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com> <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com> <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com>
Message-ID: <Z4G9--FpoeOlbEDz@google.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, michael.roth@amd.com, dionnaglaze@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 10, 2025, Ashish Kalra wrote:
> It looks like i have hit a serious blocker issue with this approach of moving
> SEV/SNP initialization to KVM module load time. 
> 
> While testing with kvm_amd and PSP driver built-in, it looks like kvm_amd
> driver is being loaded/initialized before PSP driver is loaded, and that
> causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fail:
> 
> [   10.717898] kvm_amd: TSC scaling supported
> [   10.722470] kvm_amd: Nested Virtualization enabled
> [   10.727816] kvm_amd: Nested Paging enabled
> [   10.732388] kvm_amd: LBR virtualization supported
> [   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.753768] PSP driver not init                        <<<---- sev_platform_init() returns failure as PSP driver is still not initialized
> [   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.763124] kvm_amd: Virtual GIF supported
> ...
> ...
> [   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
> [   12.521691] ccp 0000:23:00.1: no command queues available
> [   12.527991] ccp 0000:23:00.1: sev enabled
> [   12.532592] ccp 0000:23:00.1: psp enabled
> [   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
> [   12.544389] ccp 0000:a2:00.1: no command queues available
> [   12.550627] ccp 0000:a2:00.1: psp enabled
> 
> depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on the list and before kernel/drivers/crypto/ccp/ccp.ko
> 
> modules.builtin: 
> kernel/arch/x86/kvm/kvm.ko
> kernel/arch/x86/kvm/kvm-amd.ko
> ...
> ...
> kernel/drivers/crypto/ccp/ccp.ko
> 
> I believe that the modules which are compiled first get called first and it
> looks like that the only way to change the order for builtin modules is by
> changing which makefiles get compiled first ?
> 
> Is there a way to change the load order of built-in modules and/or change
> dependency of built-in modules ?

The least awful option I know of would be to have the PSP use a higher priority
initcall type so that it runs before the standard initcalls.  When compiled as
a module, all initcall types are #defined to module_init.

E.g. this should work, /cross fingers

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..02c49fbf6198 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
 #endif
 }
 
-module_init(sp_mod_init);
+/* The PSP needs to be initialized before dependent modules, e.g. before KVM. */
+subsys_initcall(sp_mod_init);
 module_exit(sp_mod_exit);
