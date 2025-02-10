Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD50264603;
	Mon, 10 Feb 2025 20:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739220062; cv=none; b=l0zTdajnNIeosBBdf6Q4eCcZPZ7DJUo0lqmdJKztbk8rmFcalcFtG/jZnCgBd0gWJNpNUF8lSV7UAWe6208qWkrKtAroIjbRE4RJt1py0xUN2WoYBNbENtZHOQqYDf717TIkiH/52XVXl11VnE3hdu5tlLJd71ZBV37eJgoGTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739220062; c=relaxed/simple;
	bh=yPdHdObYJs7N4Nlg9KX0zJlMQlUolWycQynndsFpYPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBaaNt8+dIc+rLc6gPeoeLkaiNKp1MwxmpeR+YWWRS+t+1M50Wn8s3/zsV+XMq1jdRxjewG+I8eMvbTGtYWkfsa29Q7TOWrWh5T4OVlFc/dB9gXUcwMfacwzKg0jjEaF/PJ5Ff2wGq2cX0/lvfIgwGcYt5r4HL94eaAZUQRTB0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=azvVQWX1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="azvVQWX1"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 604B240E0177;
	Mon, 10 Feb 2025 20:40:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TS2OdWt8lwlR; Mon, 10 Feb 2025 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739220049; bh=SSfTdyjRwC6La0TaEkrgbjDaAq72qiIrANDEpo1CPAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=azvVQWX1ofvYjZI0GftI0JZggJ2c+ockYm5kgrxnX+dX5adZguekHmFd+ci9CSpGp
	 8gQ2orMhD7BMSStQ5W7XXmVYeqpoEHlgcROsyoRaQC9d4Te+JTrA6LpbEehg+3MROP
	 neWEnkpaoP9uEPPyx9S/Kn5sANlVRmxypXoMMPsDr8ftoIB6JYg47ulDDoBlNAhcys
	 aoC7f2F2MDzrh6qEc5zDqwmQvV0n33vgzCe3F2GJcAFjpyQ9mN8VGsZhyazb7qAIGc
	 5kKTyxWCL/3QFVMkFsSbYZlvw6zuZd7FeFs+yQ7K+Pjk1ep1XlIgCk406DRymXnpKH
	 1Yos9zMRslwMGy4B61+8Hm/1nNoOUf+FnxGzbG/jdjLG+E6W4StNuz6UP+M8i/LOm/
	 k897CgGj0AXOCxloPiBW15OWRlLanpW/LNbT3xxsU6WCNFX0ipHJiwCTqDroSwmoz5
	 DZ2qRScR0vC0ijm5e63djvG/I+w6s5B5P7VvuzBo/jZtpzFgmJDHXW7ryUZXc2rcw8
	 QbnCrcqFInWSp4VNrKVn3F9EhZdHbRcCN6wtSzL8Aymy7TbJodlojiIECW7QbWlq7z
	 490r49QJLHb8RgH5c8U3CQnPuf6z9WST42E4htcNjPTOT2b6Gta7/kI9T3aoS7ysYm
	 Ywc4z10aKLRdwIbLx725zt+k=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CAF8240E016E;
	Mon, 10 Feb 2025 20:40:38 +0000 (UTC)
Date: Mon, 10 Feb 2025 21:40:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Message-ID: <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>
References: <20250210174540.161705-1-ebiggers@kernel.org>
 <20250210174540.161705-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250210174540.161705-2-ebiggers@kernel.org>

On Mon, Feb 10, 2025 at 09:45:35AM -0800, Eric Biggers wrote:
> @@ -1598,11 +1578,11 @@ static int __init register_avx_algs(void)
>  					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
>  					 aes_gcm_simdalgs_vaes_avx10_256);
>  	if (err)
>  		return err;
>  
> -	if (x86_match_cpu(zmm_exclusion_list)) {
> +	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {

s/boot_cpu_has/cpu_feature_enabled/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
