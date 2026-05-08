Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB39A37BE7F;
	Fri,  8 May 2026 21:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274480; cv=none; b=CX17ExnSzIddHJKOo5YjziofVnc5fIOoZFHVKhT+4g8moU7pFqFjWd/JbiPiQduFi4tdv/iP7Q4CfBTpQIdoDBRD+FZWhlnvooh9pvTqMIYY0S4eRWeHgz2fALGTVyH+I1/q5elMfqu4yxkPb1gPYYoSy7ayuvMFn1XIcgmogm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274480; c=relaxed/simple;
	bh=snGlCXNdRPdE6D6LIf8+v3R6FDzyG5p6i/lY7VpPi0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8Swpdd0sOey/6DQBrsA/UV6HV4tVxCUB2Bzyml+gBSmdoRE9aOfzvSv+pNT75H71ErD4l9uUIxNi5tC2LE+GEVSeIeXqvBXfhHvcBi3cMjhp8FId/tZVfmO68kRbCSU8f2B4yCoRs0i8DYNtKRhHEG8OyGIs30OOu/47c0SVQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GWzS6ex3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GWzS6ex3"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0C72440E014B;
	Fri,  8 May 2026 21:07:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nteMjf7f3Rkz; Fri,  8 May 2026 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1778274465; bh=dyC6j2Ha8uaqPe40e7AkHw5Pabt9MP7uRNHi7eH1NNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GWzS6ex3JDg4ClbFRqVhEu0UmJdDbYXhoPjUaCkA+zf3+CDRrbExoCem77ySlycHd
	 Jzsb7+nM8kYSDQwc5JCB6VAfhZZH2vjfKlXwjE5SL6Ld+Sk6Nk5Kip7tutiJAtXyf1
	 g7/kAB4HVSBtXEDeO7yFUFVjy2adOSA1RG6S80wEc971NRdm3hliK8/J6eWOSZ8Rct
	 4uUo/8PdAlzZbvtPL5XKYbTfOq1f9GxQ/smmJaM8+JPjM2x9RKgeqxjR95bpOi6++t
	 XY8DUbiiu9oAiNyivvVrDylXo457B0QhCHWjxqCzjU18NFYVqUpMGs9JJh8QPE4L1g
	 eO55M/KthaPRIox14Bzy+QnzvSO28x529s6zWHTxnwnT3IF1plj+sJ/EyKJot1zTF4
	 5y0TcTUe9Xg3rL4/NC+541tEYtS+9qs/ysJ//fPnIa1OV2gMkd95tgwfXDWC1JoYF5
	 xQDxnTzoCVS82D2OefqBcOGuAXzlkfvKKHb0RwIWbrLB35JzVBqSK7vGIy6li7sF1c
	 WZ+rdw5EM0e2dDV76SINdee/QB1LkwsG+B5EfMfpL/r1/O+ZSTYb1wjisWkVx5349h
	 5nM7e/1Z9/L0xIDDXOkXxBGqeUkORsJ2ehi1x8K5T4FHuA0nQaZ7COwMfvmIhV8XeI
	 6Z4nxbcmXgRghBVEF1E8DiUY=
Received: from zn.tnic (pd953014d.dip0.t-ipconnect.de [217.83.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 1A22D40E00C2;
	Fri,  8 May 2026 21:07:12 +0000 (UTC)
Date: Fri, 8 May 2026 23:07:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v4 0/7] Add RMPOPT support.
Message-ID: <20260508210711.GGaf5Qf3xh4e1eoMwS@fat_crate.local>
References: <cover.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>

On Mon, Apr 13, 2026 at 07:42:03PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
> to RMP checks on writes to provide integrity of SEV-SNP guest memory.

Sashiko has comments:

https://sashiko.dev/#/patchset/77153c889934972efcfc3d210251564f29abcf51.1775874970.git.ashish.kalra%40amd.com

Pls address them.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
