Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1187836998A;
	Fri,  6 Mar 2026 15:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811556; cv=none; b=HC5pp/W2iLLzaEwPlxUBxZQJSODOtSu4FPIhIiCto0EFfemiLdXUAIHVrLZ+Ej54dii8dZ6MehUcAODjoWaIB4AWzbhKKlisrtHgh0MjXdEisZcjXiEFjv9sOeFlIhAQh+4SA7B0AEYo3hZYZvo3K9L9NwecshCq9wyWVR9uz0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811556; c=relaxed/simple;
	bh=RMsaFTGi5HoxOWrM1yewKAjFDmFB5CzMVV4IpXkQd/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLNIoTdC85elXPUjFVoP8Dt1NcPMMywx7hHBM/Wotq9V/d8clWpqCqjLDKPabZbzQcqpZ7+khbjc9eQhBHeOBf6WyQ2b3AxBT2Q3OZHrDyHxe8laCfR5jz1rhkQ5TPa9A0lFkOp04n8QPWpTnWV3hW+SkPrjvzMnnMXhUh2qufQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gbHV9aLL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gbHV9aLL"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8D80240E00DA;
	Fri,  6 Mar 2026 15:39:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id leErI5PjNcMt; Fri,  6 Mar 2026 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772811549; bh=wGxJ03IwZRmHdnyMnLQa680eNY031Lii9FDjQ+y5Cf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gbHV9aLLQzpv6yGqNt0B5h0MIlLjDUl56f1SbjQl9uwx7updl2O3+SgCE2J45eMt4
	 Ipg3nttHcFbuaM6VcRVTvUsMXJpGO/fNNjOR1pgBEgmeDjB/089T72dW2ApsmxUVDX
	 vmocjxMhratjZpq6/o5y3aEW5xBo7Uo9iDD3MZAkNs2kLGynNex/LmZKpiCVqD/p5X
	 k9Z/OV5QGOUMFa8BFZr6TtWSxID0lyK0tUK0rwvutxykBGC0fPrQFukI4Qnpa8E4zG
	 tF0mmBFUDBEBupd/gkA+KWubZqE+uyiGCLwy/xCuQAXLLkXVTgDtGLtU9YOALHPbkg
	 CJPm6j9BOrDdJf4+imeZnTIjszEsxuZ3R3YHfVjIIri6Qfgje4e5m+0MjA5Jo9yToI
	 mwHCHOyx4jX0xwQipyIaE7jt0iWPQPmUU2iDEhI9OevrgyDFJCEaq76hZAH3l0kfjF
	 tZDtTKHP3ZQ9JTqiJUAojZdtcrB+ujVtYgpLJun6h9oP/ceoWyJLjhEgmaU0PQ8hIJ
	 yO6b7LDHN97/H84rtr/WYsz9L4EJVAarhDjmn/Eq3eSLZkdms5F5TuLpVTWs6AS4zG
	 c3S512Wmk7w63Jkvb31X2VoGltufsFKhMY35HOpeozmkQ90eqSXDJbmXbLE+rsYEjm
	 bbgMDlIBQVAo3UdtkAlKPNQI=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C0CB040E0163;
	Fri,  6 Mar 2026 15:38:47 +0000 (UTC)
Date: Fri, 6 Mar 2026 16:38:46 +0100
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
Subject: Re: [PATCH 01/11] x86/snp: drop support for SNP hotplug
Message-ID: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-2-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260302191334.937981-2-tycho@kernel.org>

On Mon, Mar 02, 2026 at 12:13:24PM -0700, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During an SNP_INIT(_EX), the SEV firmware checks that all CPUs have SNPEn
> set, and fails if they do not. As such, it does not make sense to have
> offline CPUs: the firmware will fail initialization because of the offlined
> ones that the kernel did not initialize.
> 
> Futher, there is a bug: SNP_INIT(_EX) require MFDM to be set in addition to
> SNPEn which the previous hotplug code did not do. Since
> k8_check_syscfg_dram_mod_en() enforces this be cleared, hotplug wouldn't
> work.
> 
> Drop the hotplug code. Collapse the __{mfd,snp}__enable() wrappers into
> their non-__ versions, since the cpu number argument is no longer needed.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/virt/svm/sev.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)

Btw, this one conflicts with Ashish's

https://lore.kernel.org/r/85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com

Considering how yours is removing code and is almost ready, I'd suggest you
send a new version of it now-ish, as a reply to this thread and after
incorporating all feedback, so that I can apply it first and then Ashish can
base his stuff ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
