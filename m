Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024883B27E9;
	Mon, 20 Jul 2026 22:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784585901; cv=none; b=H9X8K6aJ2wgt9GMWypiwy/iPUzjJHc7ZG7WuhiIdy/5QYw+wbp6ZFVAVIWFOFbJanjJMp+MYjJIMfaV0vQHyV3bQ1B01/jyE2RpWYZyycJhOKnpRNxw1PpwM5YfE6L0SM0buYYGHAyuLxgizI8WuH01yZ5ZnPMkJKTqJtLDl+Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784585901; c=relaxed/simple;
	bh=xaAacfcSw/SR5JFFESJUe2l8bEdWu7XN9+4m4Sb9tWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5a6SDEH6OQKKDbDMedLop1+tN4tgDL0eJqqqsUkM//SyYD+wFp5wgE+pTaY6KGT1jIJIWRKsLHm/08QyWMLlgTwPhkMVjC0nDHylGaSG0QQNo1tmWitJcRKrEq6CU4a2/7l/tnOUYdf/0ARvKBvwxr9qU5W2LZNc1picP1ahw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Txl9XdbW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Txl9XdbW"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A73E440E00C3;
	Mon, 20 Jul 2026 22:18:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id h-WYldXAHExt; Mon, 20 Jul 2026 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784585883; bh=ZKHdWLva2raujNfRG1gDninMW1KAIemEDky52gRjDbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Txl9XdbWDm0BxS4H+8V3TUtAc/pOzDGhgJVRPNvhVAm21VDLvQRHuorPYMzNZp1d1
	 3V2lE4AUQFY/I7yBbwQmBDJD1+tiOcWLodvQynOwL0lBiu2DV+z+fiogF8u24iyxML
	 w/bEFEpNgx8LGyG/f7wVCeA9wnPiMixVXX3Hbqd1XbGpghlDr0cEAZKxpqwOwBvzwo
	 8h7C+eY2qxmTh+P1GqoC+Pk90vxXvUFI+ywkpY3GX1FnD8n6EzfVCc+PngjLJ2AL/2
	 I58pbXKRt+SwLhxMDHFWKe+YMP5JGVmzLE6uxpHHWms02KN+fm0Tk6Pr+7sHW1HaZt
	 DNzCNrNVG6qUCJ6O2nps9hIyBafsmb8lt5wvVSjTTOiloOm3fGw9VBsmg8sp89aFYK
	 Pp50cw1nIl3YtFMdA4CFH8pCoRepkiD80glBhusm5v89O27H+cznm5nVcP1udtB7A5
	 HC87gpDZWM2BN6Ub5b5pca5ujyxUcSEb0GTW2+c9A5KWG1G8Vev1xitI7sJB9S4hQb
	 J2ONhHbOoq80zfdlKXbW4EopsekAFDpumuG/xSyhSzZqkUNPe1HwD0I/8ntc/sro7Z
	 P0XtRFczezP+TK8jlJXBvhe2j8lD0SGg9zDU7AOTu11VLVdsG1xJbTCJp5buxcjAE6
	 //XbcjO5UdihdGYobWN9fyE0=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CB40240E00B8;
	Mon, 20 Jul 2026 22:17:28 +0000 (UTC)
Date: Mon, 20 Jul 2026 15:17:25 -0700
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
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>

On Tue, Jun 30, 2026 at 06:10:13PM +0000, Ashish Kalra wrote:
> @@ -490,6 +494,11 @@ static bool __init setup_rmptable(void)
>  	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>  		if (!setup_segmented_rmptable())
>  			return false;
> +		/*
> +		 * RMPOPT requires a segmented RMP, so indicate that the
> +		 * system is capable of configuring and running RMPOPT.
> +		 */
> +		rmpopt_capable = true;

So we're capable of doing RMPOPT when setup_segmented_rmptable() has
succeeded. Which means, when rmp_segment_table is not NULL, i.e., when we have
a segmented table.

Which means that instead of testing rmpopt_capable, you need to test
CC_ATTR_HOST_SEV_SNP and rmp_segment_table != NULL and you can put that in
a helper local to arch/x86/virt/svm/sev.c

Which means, you don't need that bool.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
