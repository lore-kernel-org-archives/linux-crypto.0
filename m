Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6703E49EF;
	Wed,  5 Aug 2026 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785958492; cv=none; b=MKZtDx4VYVkAjXMgy5a6FeKXJH+SF2k10sQeR7silRhqhjBAPZ6a3VbPxuHBdmsIMLZ6NSwzoVnnxX26knXPGWTptaQWX4M6slEAUCFTJ21GZjMxis4Am/jYZ8XXI7536YLHHj25unH+QA7aid9XjgAEBxCAKIgygcMpCGA4aUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785958492; c=relaxed/simple;
	bh=1M7Kt4gH5Kc0H5wpwsXlOXWFaT068dyJQ76jsc7Hrrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+swkkhUrD3W4c5rCLnv2DZNLkXnLrZN3h+C/2GccXy0l/byKjpf6tQ9mE3XKXnbfhgptZ8LiuetKH3n1eXZmDd/hkZRo8TxBaE9+/eI9qKQRyPvb+Nnp03fRP2JsWY4oY8bJL1a2QZF5TEgIWTPRkMXi7vz3TycxY8Mgh45ZwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=koZ4Iajn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="koZ4Iajn"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 26FB140E016E;
	Wed,  5 Aug 2026 19:34:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EGLyDRL-ZRNP; Wed,  5 Aug 2026 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785958478; bh=GGPdBvG2Xw3jFrgOiBoBHB/7TfCPQzXsCYIMDeHD5aY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=koZ4IajnqxqFoqXkhgFRnj3uWwg64ho6hxxe8klsaqTO5Pib+krIsqMXPYhIEOdhU
	 1R2zSmumkjY/yk4Uz18j0ev9ScDfZHHePgt88NHUWWo0hJWoRy0sQK0bsmpsyt4U94
	 s5UqXlvZc9c1Ho/PFmP6dsKhonFO56hCBtm/+2j8fK+7MLuWefL8zfYai1qe+9dIIL
	 TUzzG1iQfC3XSZuGqtxpCAWddcAJTcLOgJ/p0EaPED04/4Qbemfs5F+E00ykwLt0oc
	 et1Nn59HJQMzMrWTEeIiLJ4KKBxlli1a5oWzjvZYy56UqUunvj2D+euZnJf8HCh4LI
	 mkH2cke4wlg0UTrRFGw5o8soQK5J5N2yDEUJQJoKgeZtDS0Tika2WvruO+YfDJal0/
	 HtWJdw6kZkLMiDXCiW/7MC7FwTJkGKj8YmATRh9MZBNuXscavwQQrzzLZGRqAmwZg1
	 T86/eii+M3JF6kF1xC9SG0jqzbbyGl6PBDsZ18Yl8yvLEmtR0NlV8mqYOGIhocChql
	 RczZG/Roe+is7xLQUMYauVE/T/KSer49LMqDwZZsEhIHYKfJ3sItdHdw5g/qOXoxk0
	 HVz1YRYdLTScDjwwGx1WFecHqxPL7gl7EyqQqWHB4EHljt2aiBkpYHFOW8X2zSTLjr
	 dT/UxHfvqEsq88RcN4VNDKx4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3EEF840E0031;
	Wed,  5 Aug 2026 19:34:02 +0000 (UTC)
Date: Wed, 5 Aug 2026 12:33:59 -0700
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kalra, Ashish" <ashish.kalra@amd.com>, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
	thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com,
	aik@amd.com, Michael.Roth@amd.com, KPrateek.Nayak@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260805193359.GBanOQJ9tqyoX4IXiz@fat_crate.local>
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
 <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
 <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
 <ea4c1117-197b-4267-87ff-7ec48c2b7e2c@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ea4c1117-197b-4267-87ff-7ec48c2b7e2c@intel.com>

On Wed, Aug 05, 2026 at 08:12:45AM -0700, Dave Hansen wrote:
> A periodic scan could be useful but only if it coincides with a VM
> teardown event, or other event that opens up new RMP optimizations. I
> _think_ we decided that with current upstream code, the only event that
> matters is VM teardown.

Yeah, see my reply to Ashish just now - it turns out we don't even have events
which will open up potential opportunities for RMP optimizations besides guest
teardown. So yeah, we should be doing it then only.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
