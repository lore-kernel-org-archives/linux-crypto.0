Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6B535CB60;
	Fri, 13 Mar 2026 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418706; cv=none; b=Ipcq1s4mT/sDTNipupXSIj01NQEL0cifeEgLaxmVg99moRluCyHzeDgR5E9rv+rcM+iJE1yCKKIJtscTAxBGFF5ozYjks+xprQ64UShlYXdvKYhxDHHKStT4jDpXORNPRkfS2QEVmdcqAgHEkCW/Z+EUtJnp/r2TPVITzFpzOlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418706; c=relaxed/simple;
	bh=8AeNipmWQPew10LMaSW7H4brASjbmtfOb8+UtMYx++Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mml7xkSU7R5fo8SptAzRkiDvqA4rK2wfQtUTGfic10ntE8UN0ibj1lteIR1nzGrQCTPxbh1tZewlpha4Tqxs4aA1Vb8t0zFbJ7NUVYRKP6ADn+Zm3lbhEnKYXIHrcnNPdzPRJ7AjVwRM6f13L9kIYCEZYyGtmr6GS6k8JzpvOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hX/cL0DO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hX/cL0DO"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F091D40E01D2;
	Fri, 13 Mar 2026 16:18:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gGih9f-M2-5n; Fri, 13 Mar 2026 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1773418696; bh=vC2kRN06dgFsrh9RSSCl23fMd5zmj2uHduvcUtiqr1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hX/cL0DOskwRuIKOqnL7Uy4+QPSvYyougN97AbbUQF99+AG8Lr9RPeke+KZqfH+4Z
	 VP7hL8ofBBhtuzmC20rLesOajt9sLzNWMJMiz3fFWVWmYoioTkQRtMQktgrkmouY/Z
	 n7Yd2ue8ynor2RGgPwr8QzC1jG3p4VzNIhmLOx5PBcDWeXrrbzNMzEleB9HXIKh12C
	 HgdculfKiIThXmemITiR1Z6wQ3t/tU+yOcSVNyH20Q8b1DPS+M3UVBZkDvPiVW03KS
	 vO+eQz20ypHPcYOLE83tgmEWH0TEw3m5M+fSbVB5TAF2Y+l63Ml7N55cJiy6lXNvJu
	 z2B8GKQwdE2GY1fphUVq+/utHkjFeR5f1lYjLprImXWp+vVDAsHpb7EdNDtA7B/ont
	 D7Wxf3YurLw+DTLWQ1+VjC+DhIgm335KiZBVFFLVoZyuVeGLF/DHYjgr8R7p7gP3Hm
	 /wugkQXGlA7UL7CpCY4BKEXUE3gG6aY1JPmbk78HuFN5FrpJgCiDvYHa+B/RoZ6uLt
	 B1PDewt8R9g0IJvgnKHEtwBkLBSIRqMXTyEqb5CDkgj/s2vOjHc4iZe7AJL30rbDJY
	 MxMxem6ZrXI4dblbn9Sg7tQJJrhifNXW459T7d/HSwq0FDY+HlnpHDAjZFI1vqvON4
	 peDtN7ovQ8EcoQ9JkpTRLhOQ=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 697F140E0163;
	Fri, 13 Mar 2026 16:17:55 +0000 (UTC)
Date: Fri, 13 Mar 2026 17:17:49 +0100
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
Subject: Re: [PATCH v2 04/10] x86/snp: Create a function to clear/zero the RMP
Message-ID: <20260313161749.GUabQ4rSBtOLWJ3XKN@fat_crate.local>
References: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
 <20260309180053.2389118-1-tycho@kernel.org>
 <20260309180053.2389118-5-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260309180053.2389118-5-tycho@kernel.org>

On Mon, Mar 09, 2026 at 12:00:46PM -0600, Tycho Andersen wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In prep for delayed SNP initialization and disablement on shutdown, create
> a function, snp_clear_rmp(), that clears the RMP bookkeeping area and the
> RMP entries.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/virt/svm/sev.c | 41 +++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index e35fac0a8a3d..f41b92e40014 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -242,6 +242,32 @@ void __init snp_fixup_e820_tables(void)
>  	}
>  }
>  
> +static void snp_clear_rmp(void)

No need for "snp_" prefix on static functions.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
