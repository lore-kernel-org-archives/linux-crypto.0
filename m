Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A50253958;
	Mon, 23 Mar 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774281010; cv=none; b=Vr75slcUpr5vZGH5qIcfoar5KNsYNxD0p/B59n32ofe5w+aVh0RYAhUx122C5T1Ow9Ngi2r4DEn6qeMfV5Gv5GCCtwGoT3KjafvQ3YcLDZ+JUon4PVMAHq89KC8k6zVGRJ88d4PyDYCt8wfwbNkSP71cBJq4O2yZriM0wvk9Vcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774281010; c=relaxed/simple;
	bh=GPEp2uZkHGASSlPgrijyyJCytWy8KMseEJ9BpDAi/j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKMQKxufQ2CQVxXBUFtUzijllsrjiigyUsO6zhP8dmXjwMVLUouq0ASj5OpZ/fhU3T4N4UMLQJLVa0M/+2dIXk5qv+CUWho1oNJUk1rgdbWNQ9hw0o+qpATI8u3a+zT6phw4lYgJpAAAP3A7ZRJb7QWQ1En1fhxtItbSHjTlOPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eCrC+h7/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eCrC+h7/"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E631640E0294;
	Mon, 23 Mar 2026 15:50:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hcBTh-zCjNM1; Mon, 23 Mar 2026 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774281002; bh=ONWOKw4Lzjv46aZV0RJEebbDt5Osznc+yIQ5vBIDgdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eCrC+h7/Kbg3rg6o7hLfUh5r1U8U32ErG2ms6MgmRstDBHrUbtRGSZ6hjP08mc7Xd
	 gvmRLf6KL3qqjhPVWlQR93R7R3JR9pYiGRK97LIzpRjj117sAbi7Bvil080AvtVHgI
	 p9uinE73mqfHdQB+paeKORTkhwjtVqpDRZr0YVWVMohJmpu4yZ/KpX4BJeyB+DTtoD
	 7khW8qYhY9NS83hR9g04WotP16OYGEp6+gSHRQ4TJGmTCcT09zFyY9Y2IvUbZbPhnl
	 ecldRrc/gC63pSWWDWmScHA6Zw1g4Ujrx2npssXdwttvly6lfcdWYnTewtcfrVmw40
	 xfTbuXLWSS4UsyN05itTKcdcPZZXpGeirKOdGWNO3xeNxhSRYqCKwQuBQgkaWgroDR
	 aEnE0O4ZxQEipD/Ct+CMLcjxuFP86txNeaF6GYOJ8U0qnh7mZLHFX5vR/yKLgYqI0q
	 QdW1wNczpDZ/NLewIrFxOcfQ7gAcdzxoBoCxDn7eteSjLJ9o3cme5/PTy+72Oin8XC
	 O4u2OqzoUoMDWsBr/Z+R7Rj27oCrbSoIdlHLXNxRu1qBbaLW2zolfZ3bRmyWBgjAoJ
	 YOpzr8PD3TDEuiOaO6KVCt9NibWTPlMD2U8IdXJ6aBijZrwlcnBw4bHNYkMmimi2Cy
	 RcAumwcqKAoumu9myWiclkT0=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B789D40E019D;
	Mon, 23 Mar 2026 15:49:40 +0000 (UTC)
Date: Mon, 23 Mar 2026 16:49:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Move SNP initialization to the CCP driver
Message-ID: <20260323154939.GEacFhEwUGdWHo5nKz@fat_crate.local>
References: <20260317162157.150842-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-1-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:50AM -0600, Tycho Andersen wrote:
> Tom Lendacky (2):
>   x86/snp: Create a function to clear/zero the RMP
>   crypto: ccp - Update HV_FIXED page states to allow freeing of memory
> 
> Tycho Andersen (AMD) (5):
>   x86/snp: create snp_prepare_for_snp_init()
>   x86/snp: create snp_x86_shutdown()
>   x86/snp, crypto: move SNP init to ccp driver
>   x86/snp, crypto: move HSAVE_PA setup to arch/
>   crypto: ccp - implement SNP x86 shutdown
> 
>  arch/x86/include/asm/sev.h   |   4 ++
>  arch/x86/virt/svm/sev.c      | 112 ++++++++++++++++++++++++-----------
>  drivers/crypto/ccp/sev-dev.c |  62 ++++++++++---------
>  include/linux/psp-sev.h      |   4 +-
>  4 files changed, 120 insertions(+), 62 deletions(-)

Ok, I think the next version of this will be ready, pls incorporate all review
feedback and I can pick it up.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
