Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A6B3546FD;
	Thu, 18 Jun 2026 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781806147; cv=none; b=XILC2T1jzyoVb1VvG3Acgqoe+mLhMpODpl2BmP4SMTyFLsj4G5C6uXWiy1vM9BAfRnH8K1QVg9vdpWjI9BvIIw27oQrF+01RBvuNTJfkbNQuzMq76zpZ/q2+UwBUjKwBNkm+C8U+nPYIu/+wP0YfFO3KAcwJIty0ZLFJ8BSMPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781806147; c=relaxed/simple;
	bh=rAa8LEQvk+1s+hFT3N+GAcQefqp86NaczF4HhGpoMbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNgQ4u31lAp3jFjvFxtW/7FOhkOeHp923M2neJNmfmBFkaOfQVaGcR2gQvfc2IvfPWtg7XW0w0qi5MadUSbE0iZPNcVbCkksqyA3PpIDtpT7crPvAkeZnjM8J21oDl8gWBvy6Cr77HP2TC0uGRZG/BiWy75Xj/Qro1cFYUQmDNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BDhRLYFR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BDhRLYFR"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7A70F40E02A1;
	Thu, 18 Jun 2026 18:09:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fYI6Wz8iLQBu; Thu, 18 Jun 2026 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781806132; bh=AbUUknJ8mkdCJrlkEr1r8m9QQjKgmoQkDiKU2zcLEG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BDhRLYFR+EXuFe+zt79BtJIqnB4DWwSA1KUtL6OVBUYeFnsBdMcC79eXB4EWLVZD6
	 7TBZd0ePwSGThwpyvAAcmou8UEAV8s6nMLieE13u7OLUE19axUbp8tnPIpeTOpJ1wu
	 9IkfpKnySMFniT1opMExZgo4nae8ThMSPv3BongLmN1u/KucQJ0Zxrj2Jav+aZFjYE
	 RqAafnKxyBT8t+q8ll9qmPAWe8xnAkfd/zjVJmoooBPdwlrvzK6YSdEYdExpAr717b
	 hvUgCKwt+yrobqY2ISbZvgSe6hkZQoAcs1Z3vK1BhMdxjiIZEN5rKuWW2Zg1lRPH29
	 1LmO3PGn6thhlbwM3J3yq6Q03c7q7R3dRKqtHYzigOshFRjwJfWRkllU4xx1/vyRZB
	 8PLGeCIo7ffBGKFubjtb51Ufy2MEDTYJg7Uz2YZ4K/JP2ymzeb6fEUvkdJyLGSJ9SY
	 Ra0kCF6fF+CxN31GawqO0Crjws5NZwUcpaks5qqovtR56LvK/WAbfPrTRXBHf3BBRj
	 cOwxa+xzX+y5j0MZ8UFJtD0iLox2XI/GTlYmTLEeWijTiGlBDJyHlidOolCkESCbWY
	 zaIaOU+0mnjpIKh4X3b/IxjU2Pi0deelPRVd22e16TxDPUziygLpJpd9/9617RLsnw
	 PiY9MNK5KkQKAaqnrO/POelY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B5D740E01D8;
	Thu, 18 Jun 2026 18:08:17 +0000 (UTC)
Date: Thu, 18 Jun 2026 11:08:14 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v8 7/7] x86/sev: Add debugfs support for RMPOPT
Message-ID: <20260618180814.GCajQ0Dv0CoRMJxbP0@fat_crate.local>
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>

On Mon, Jun 15, 2026 at 07:50:56PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add a debugfs interface to report per-CPU RMPOPT status across all
> system RAM.
> 
> To dump the per-CPU RMPOPT status for all system RAM:
> 
> /sys/kernel/debug/rmpopt# cat rmpopt-table
> 
> Memory @  0GB: CPU(s): none
> Memory @  1GB: CPU(s): none
> Memory @  2GB: CPU(s): 0-1023
> Memory @  3GB: CPU(s): 0-1023
> Memory @  4GB: CPU(s): none
> Memory @  5GB: CPU(s): 0-1023
> Memory @  6GB: CPU(s): 0-1023
> Memory @  7GB: CPU(s): 0-1023
> ...
> Memory @1025GB: CPU(s): 0-1023
> Memory @1026GB: CPU(s): 0-1023
> Memory @1027GB: CPU(s): 0-1023
> Memory @1028GB: CPU(s): 0-1023
> Memory @1029GB: CPU(s): 0-1023
> Memory @1030GB: CPU(s): 0-1023
> Memory @1031GB: CPU(s): 0-1023
> Memory @1032GB: CPU(s): 0-1023
> Memory @1033GB: CPU(s): 0-1023
> Memory @1034GB: CPU(s): 0-1023
> Memory @1035GB: CPU(s): 0-1023
> Memory @1036GB: CPU(s): 0-1023
> Memory @1037GB: CPU(s): 0-1023
> Memory @1038GB: CPU(s): none
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 128 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)

https://lwn.net/Articles/309298/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
