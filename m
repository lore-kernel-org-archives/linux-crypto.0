Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7161F31715B;
	Sat, 21 Mar 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774111572; cv=none; b=LxnLGACJtPuEJfntzgcgKbFRmGbyTHB6ujVXfelzLxEeaZ5s8GzJXEa2tDDHPPS0OXxuexvf6GSZhE886fekRWP9EbTSdawoGITaSl5/trJQlYs1KhSOXlcjqrefDEdirPPryu2Pto5cmjOGskAnkOZ85DMZwiDX9MxOmn4P+lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774111572; c=relaxed/simple;
	bh=1ZvyR1RuVasmrMSKJwsdhVO0p2Cud6Hqy/BTdcTmVsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsJrcGtE5dZy6UcK2fCLhrIJvANv45P2NjdejGIoj88oRa3QmUrtCK4I+tKuW+LfChjDYKnFX4Uh+HIeHNlhBlWwuLiJ66U4Glkq88Squ5InmyGR5Dv6MWyADcU9fi4M5mpVUkCtL2tyxQGyLz1jmXUFsrjii/y04o2JQlpOmFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eP+hrr0A; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eP+hrr0A"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 456A540E0174;
	Sat, 21 Mar 2026 16:46:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tNywZ7V4Idmz; Sat, 21 Mar 2026 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774111563; bh=twnuSt37zseOSnFf+2TpQjV2XCJp19cWrwS+xhRc0Vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eP+hrr0A9mfUO9MJ5pEEOcfnKn6+CrQ95L/dMgKj1g/UES6ilrVL7G2b6FxUSUb9O
	 CZJOfvWKxsiIbEfL3/6GfGpfKy46gjKZaYSTzXv5z9ffiIHtJvO6BAs9zeLHbIQyBq
	 XCupvBLfYSyG5R9Oo574VEoaidr8zAl5X9a75MTkOE6NJVN+eczYAY7TvwLrV+0tu3
	 Q6wA3tonL65GtyHGnDA3eZNUleXZU80J+Z8qabeQOupG/sGpULRgeJKI6Ajpp+o2Pl
	 P8xMhPLarCF89DbR+Guju6pVwo8exku3Mk4IBUwlPzdFEBra7vHsyDeJWL2GDfLn/e
	 GzvIC+ICpaiFH2IkPVj18FpTTwg+HiQktE5PgM7pWbJff53KLbs8ZtT3dAxe0ZPjER
	 iSKUPZndJJv/zXBA28m4ICwsfG594q5/GilKikbVvRxLEovNaBNIV50EThMUlbzavy
	 GOcooSA2cRG5z/bn7Db1h4JOKtW2U5aW3XMGJg/lhdKSDBMQVwh2hiESROgWwu9ATP
	 uQdPLWi89zXfAz8B2u2qVSVe7Kx/08Y7xOm/YDMqMBuurPTjXOBO3rz3xm0t89n4R+
	 AOVMOLkI9BJdufBoTDwahPYV4b0CBAjsTMTi3uk4Plb1Rs5degLvbGq4k+rMAPz4+o
	 gtjNUmrN2GLPJxwQFQimMXqA=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 76B0540E019D;
	Sat, 21 Mar 2026 16:45:42 +0000 (UTC)
Date: Sat, 21 Mar 2026 17:45:35 +0100
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
Subject: Re: [PATCH v3 2/7] x86/snp: create snp_prepare_for_snp_init()
Message-ID: <20260321164535.GAab7LL2cXZhT1jeOS@fat_crate.local>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-3-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-3-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:52AM -0600, Tycho Andersen wrote:
> +void snp_prepare_for_snp_init(void)

What's wrong with "snp_prepare" simply?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
