Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D672222A0;
	Sat, 13 Sep 2025 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737917; cv=none; b=t1nY7Um7umcV5mECE0ch93AFyAE9rQOx3eD94sA0NZ4xV2uSQ5AIisEKA3+jF1BrYZsoxfFr0Bgc1SQA15/Mw66YF+/J9ywvrs8QjZ4nFvGfT46A7hdxlLXREErWJIi+0kpfcYMNVQyY4bw//wcsCyWbgw0HuLpfToj1HbgMNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737917; c=relaxed/simple;
	bh=V56UNnycCpEU3b1FiaU5+wDTmPXfctVwOtoh59m++mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I99lBmWIPCl9YN/7IK2Ptf6rkE2Sf/DlEqziBN0741ZfcwZGmShLK6BIDchr0mjp6hkKcPIZUHDIh31OwLoWcoY2+1f8nqNWZeRe8sJYXnQiAdD0T9nYlf8A/gxJu6AzkEzv8DFf2wyiuQw2kjfEoqb2LfzOoXq33WpTXAMn3N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mLnFba/M; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mLnFba/M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WpcYeZLZ6FwItSXc1AYhFvi6A4ewnyUtqBGNZ/33+/Y=; b=mLnFba/MaGJhz1DOCUu9AA/Ssk
	HcrXW6zi4TFJTLSydTqMPuhhB3j1+kazpBePqUrlqLWfegPRevUB8PEWqXihpU024hJyl3i0QC5Iv
	ASILGAYLOOkapFUX9F3Sgr83VsSg8FJ+cy6QVcMPuUxGP6Oaq45+6fEdatZhRIWNfR6G+udmb3gAk
	LGq3nTTuMmfRp3esFlZxWqfZ79n93pVDQhmYYQBwyrB4CNjknG+fSHf4FsyTld5RvzU5Rj/jiaObu
	0U7I98tzfBJOFSytyMs98eUjgNib6Adczhg5nERyK544QVZHrrSJS7ku5+8hMUoeX776Od1pQ+Ev4
	Ce9GbK9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHg1-0053xO-0U;
	Sat, 13 Sep 2025 12:31:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:31:49 +0800
Date: Sat, 13 Sep 2025 12:31:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>, stable@kernel.org
Subject: Re: [PATCH] crypto: ccp - Always pass in an error pointer to
 __sev_platform_shutdown_locked()
Message-ID: <aMTztcNPqtQkZ4DI@gondor.apana.org.au>
References: <20250906122145.29784-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906122145.29784-1-bp@kernel.org>

On Sat, Sep 06, 2025 at 02:21:45PM +0200, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> When
> 
>   9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> 
> moved the error messages dumping so that they don't need to be issued by
> the callers, it missed the case where __sev_firmware_shutdown() calls
> __sev_platform_shutdown_locked() with a NULL argument which leads to
> a NULL ptr deref on the shutdown path, during suspend to disk:
> 
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   CPU: 0 UID: 0 PID: 983 Comm: hib.sh Not tainted 6.17.0-rc4+ #1 PREEMPT(voluntary)
>   Hardware name: Supermicro Super Server/H12SSL-i, BIOS 2.5 09/08/2022
>   RIP: 0010:__sev_platform_shutdown_locked.cold+0x0/0x21 [ccp]
> 
> That rIP is:
> 
>   00000000000006fd <__sev_platform_shutdown_locked.cold>:
>    6fd:   8b 13                   mov    (%rbx),%edx
>    6ff:   48 8b 7d 00             mov    0x0(%rbp),%rdi
>    703:   89 c1                   mov    %eax,%ecx
> 
>   Code: 74 05 31 ff 41 89 3f 49 8b 3e 89 ea 48 c7 c6 a0 8e 54 a0 41 bf 92 ff ff ff e8 e5 2e 09 e1 c6 05 2a d4 38 00 01 e9 26 af ff ff <8b> 13 48 8b 7d 00 89 c1 48 c7 c6 18 90 54 a0 89 44 24 04 e8 c1 2e
>   RSP: 0018:ffffc90005467d00 EFLAGS: 00010282
>   RAX: 00000000ffffff92 RBX: 0000000000000000 RCX: 0000000000000000
>   			     ^^^^^^^^^^^^^^^^
> and %rbx is nice and clean.
> 
>   Call Trace:
>    <TASK>
>    __sev_firmware_shutdown.isra.0
>    sev_dev_destroy
>    psp_dev_destroy
>    sp_destroy
>    pci_device_shutdown
>    device_shutdown
>    kernel_power_off
>    hibernate.cold
>    state_store
>    kernfs_fop_write_iter
>    vfs_write
>    ksys_write
>    do_syscall_64
>    entry_SYSCALL_64_after_hwframe
> 
> Pass in a pointer to the function-local error var in the caller.
> 
> With that addressed, suspending the ccp shows the error properly at
> least:
> 
>   ccp 0000:47:00.1: sev command 0x2 timed out, disabling PSP
>   ccp 0000:47:00.1: SEV: failed to SHUTDOWN error 0x0, rc -110
>   SEV-SNP: Leaking PFN range 0x146800-0x146a00
>   SEV-SNP: PFN 0x146800 unassigned, dumping non-zero entries in 2M PFN region: [0x146800 - 0x146a00]
>   ...
>   ccp 0000:47:00.1: SEV-SNP firmware shutdown failed, rc -16, error 0x0
>   ACPI: PM: Preparing to enter system sleep state S5
>   kvm: exiting hardware virtualization
>   reboot: Power down
> 
> Btw, this driver is crying to be cleaned up to pass in a proper I/O
> struct which can be used to store information between the different
> functions, otherwise stuff like that will happen in the future again.
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: <stable@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
