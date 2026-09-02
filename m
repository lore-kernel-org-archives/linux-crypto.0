Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506AB3AF65A;
	Wed,  2 Sep 2026 20:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788380586; cv=none; b=cai0+QvGdltPALrkldHjLcaY+rSeTq/xChrhW6iqbaVn/yCSUQ5cURjGZYG6J3zwxw+QfmQUNJJY1jdabzunHimpvkK6h4p+xz/oB41PPYIm/4W6GQvmRGfA6wZSIP7y/1LqDzxwsDgmHNWR153Z7nwW3YDd6EUnVWMTxMEzNvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788380586; c=relaxed/simple;
	bh=El+lfXOiISwUcWK6Vj2fB3vvXaxwx2zumh7ylVVqsjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUVfJWD748eCCv5i1vQ5OKvkJcECGXAcNbGcmHa1eFhFQC2lLHFvuO2FjVyasfkQaa4DXfFZdCZSeruiOf65/cgI4zXDsqAbmUsgq6/A/8YDktlmei1ei4tjtxdwU8NLx0DgXiPHl1Vy0+n+SgD0PNj2fQd0JcjDnJcFsmgbgU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=akHMTUt+; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="akHMTUt+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yFko6/9Mo2Syy55GgxaAO11RjRRG5Bdo144bz4kvt04=; b=akHMTUt+nGmF8lyTkh0nEW4L7t
	Peqr8fg/8LJSjZUyEZrCDgycYhkEE2VwrYIIBuB1PpRDNA1u535mt3bqw1GIB+94InVNQ8a8kQL/v
	Ft2c9jSu5LXGm64dkD7x/l+Oixp9sVN92TfW1AHHGNbKkk1mXHrRGgtPvEd4gH4Eh1/hzrt/Jt+9n
	VPa53kQO1NuUYJlQne5duC5b9rA/OmRUG2dXMzA6efGytwYjlj6DVIeLLdUvyf6CPrA+l5Gh9E+Ia
	F2pUx1JQitgGZz1qeB25ASfhAQbhVwYX3ylzIERmFK04PtXZXxTfYkxjD6fVsDL+PB9Rq3We7p0VY
	3ttBL2TQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <carnil@debian.org>)
	id 1x1rTq-0002ar-1P;
	Wed, 02 Sep 2026 20:22:46 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 96074BE2DE0; Wed, 02 Sep 2026 22:22:45 +0200 (CEST)
Date: Wed, 2 Sep 2026 22:22:45 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Andrew Wilson <wizlonex@gmail.com>, 1145026-done@bugs.debian.org
Cc: Sean Christopherson <seanjc@google.com>, ashish.kalra@amd.com,
	aik@amd.com, herbert@gondor.apana.org.au, stable@vger.kernel.org,
	regressions@lists.linux.dev, thomas.lendacky@amd.com,
	john.allen@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#1145026: [REGRESSION] [6.12.y] crypto: ccp - Move SEV/SNP
 Platform initialization to KVM breaks SEV-ES VM launch
Message-ID: <apiFlWsTBSsdU0jx@eldamar.lan>
References: <CALAyJWrn7OQyQMd5OPoifn_3qe6iWNf1+xSSg_six-+po9kpvQ@mail.gmail.com>
 <aphXfTJicnEde3R4@google.com>
 <178732258045.5504.12626873976870242251.reportbug@solo>
 <CALAyJWqXT=LFr2wAi4egPPQX57=NRK5tXJh_t4nOKqrJbfga3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAyJWqXT=LFr2wAi4egPPQX57=NRK5tXJh_t4nOKqrJbfga3A@mail.gmail.com>
X-Debian-User: carnil

Source: linux
Source-Version: 6.12.105-1

Hi,

On Wed, Sep 02, 2026 at 03:14:48PM -0400, Andrew Wilson wrote:
> Hi Sean, Salvatore,
> 
> Tested-by: Andrew Wilson <your.email@address.com>
> 
> (With strong assistance from Gemini guiding me through builds, module
> DKMS rebuilds, and interpreting logs!)
> 
> I can confirm that commit 6b748c39d18e completely resolves the issue,
> and SEV, SEV-ES, AND SEV-SNP are fully functional on official Debian
> packages (tested on EPYC Rome and EPYC Milan servers).
> 
> Here are the test results from bare-metal hardware:
> 
> 1. Upstream v6.12.104 (Source build) on AMD EPYC (Rome):
>    * Tested SEV-ES: Functional, VMs launch cleanly.
> 
> 2. Debian 6.12.107-1 (linux-image-6.12.107+deb13-amd64) on AMD EPYC (Rome):
>    * Tested SEV & SEV-ES: Functional.
>    [    3.676036] kvm_amd: SEV enabled (ASIDs 16 - 253)
>    [    3.690542] kvm_amd: SEV-ES enabled (ASIDs 1 - 15)
>    [    3.735896] ccp 0000:26:00.1: SEV API:0.24 build:22
> 
> 3. Debian 6.12.107-1 (linux-image-6.12.107+deb13-amd64) on AMD EPYC (Milan):
>    * Tested SEV-SNP: Fully functional!
>    * Host log:
>      [    4.678767] kvm_amd: SEV enabled (ASIDs 256 - 509)
>      [    4.684694] kvm_amd: SEV-ES enabled (ASIDs 1 - 255)
>      [    4.690563] kvm_amd: SEV-SNP enabled (ASIDs 1 - 255)
>      [    6.212275] ccp 0000:47:00.1: SEV-SNP API:1.58 build:2
>    * Guest dmesg:
>      [    0.908804] Memory Encryption Features active: AMD SEV SEV-ES SEV-SNP
>      [    0.908820] SEV: Status: SEV SEV-ES SEV-SNP
>      [    2.109524] SEV: SNP running at VMPL0.
>      [    3.439649] sev-guest sev-guest: Initialized SEV guest driver
> (using VMPCK0 communication key)
> 
> Because Debian builds KVM as a module (CONFIG_KVM_AMD=m), we avoid the
> built-in CONFIG_KVM_AMD=y SNP race on 6.12.y, so both SEV-ES and
> SEV-SNP are completely working out-of-the-box on 6.12.107-1.
> 
> Salvatore: Debian bug #1145026 can be marked fully resolved by
> linux-image-6.12.107-1.

Thanks for the confirmation, thanks Sean for checking the report!

On Debian's side I'm thus closing the bugreport.

Regards,
Salvatore
