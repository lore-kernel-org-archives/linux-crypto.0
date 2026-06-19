Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D343D3203B6;
	Fri, 19 Jun 2026 23:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781911262; cv=none; b=naDfFGxcLXOfI4rVvHCh34pPkIzcs/rrVW1WFVcqNaDjv6hWuDKNq9mItk8KC5gpLBivZ7ginxVn7iVPK/dQDlRD0cWjg0C9GAVLNlzTdXy6ms8yJDgbM05U/6hCG58du/e+a0YWsnikks06Erd6z+OjoUERlbARyzSd48jQpio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781911262; c=relaxed/simple;
	bh=4VkP7iRuyQCADVx7K/kmsKiVJe/3JrNYJVsPSqhAOvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PevwGmhPhxt4uWNh8oJAifbVsyboIWkUOQ082pM26uflWCJliSwNctW7YS5uGZfIUW1u7bbgYBSxdn+oxxeqEuxd3jsjyZY7Qv566iRDJmCf2MjUdIwcarWSXPvZ/bpSJCUgrTrBmgRLe0Er6/ebJ15vy1NrhLhJ9g3Geyv0Jmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LxCXBhel reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LxCXBhel"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A3BE940E00B8;
	Fri, 19 Jun 2026 23:20:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Mh_XyiWoVdiz; Fri, 19 Jun 2026 23:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781911248; bh=4pUZzPPYLHmgVdFIgc58Ac49zJOqWwEtfoVa13EiPz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LxCXBhelyDyWUi/MJ2u0Cr8iS9kWNal8L0EEkEHNLAr0MJV+7dv8fjvlcsf0mngYQ
	 ByIBuLfjE496UqTlwY+wbR0iByfDY58OkolFftds7wgStAMnA9lU77ug3U19gKWDN1
	 9essBmApU1YKbgtzqCNs+Yg1e8l8WPotKNiqpQL6T3L8hl30yMPFlZGpKOPlzb4WWa
	 6+kQYF2rwtcKI+VV17RwmnL57aQdOA0oAJBhxDKdXOQzHa42akF8nPsA9bMzA5jfgE
	 sdmUKP5ykCF5v9h3D9PepFhNCQGe4n8irNtEkFHUBNNj9zxnH0xqbP93r0hiLkVQXm
	 SheSfN5AvxL1OPUKxASz0D07UL1AAyySF8gpOZammHzb1hvkaIe7YCD7PG8bkTsByu
	 TWrXR4d0M8SFcmEYtXwbS+R0ZlHwym3oknJ26Mc63lXdj/gXQB4GpisrTklwLmWkKI
	 FdV2GFok7O4G4NWTA31LnaVP0EkmJ5IsuYWAVev3MWOHFjlXxShjjzjlZzMSaPEyIg
	 wulGFtX+qurN+3yMl4pES/nf9lGfAW5wdESOFF9YSKhykxtW1kJ62m+kTIV7z4fadT
	 I7clgw5I0+DLufSrcaIqoWdDlntviiSp8GQZRRvr4uNFOtGN5uV8ob2YnPDoxNBZD1
	 dlp/RfKI6se6DSykPTA7mi8I=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8E0AE40E00C0;
	Fri, 19 Jun 2026 23:20:11 +0000 (UTC)
Date: Fri, 19 Jun 2026 16:20:07 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
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
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
Message-ID: <20260619232007.GCajXOpyPbiu4FVZIW@fat_crate.local>
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
 <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
 <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
 <d91bf0a8-0c4a-4552-9009-0ecef46aa279@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d91bf0a8-0c4a-4552-9009-0ecef46aa279@amd.com>
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 05:34:37PM -0500, Kalra, Ashish wrote:
> Once SNP host RMP/SNP is enabled at boot, offlining is disabled for the
> entire boot =E2=80=94 no re-enable, even if SNP is fully shut down late=
r. In
> comparison, there is the possibility to re-enable CPU hotplugging durin=
g SNP
> shutdown path by calling cpuhp_remove_state_nocalls().

I'd let tglx maybe give a better idea but this cpu_hotplug_disable static=
 var
in kernel/cpu.c could get a getter function and be used instead of you
reinventing the wheel in here.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
