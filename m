Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBBD3A961B;
	Sun,  6 Sep 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788715507; cv=none; b=VJ5bJ8tLHcegQYz3u0fl4Pw/3456IE+gubn5wTsaZhyvjq4Oz2NblgaVsuH6ieWAYSe0x870np5N3OTFuSENmUVcElWVYLExUdf7AmZli/8wAsj+vpzNjziaUfLqLR+/YLSKsJV+CZ8DS+BLiY4Ef9I+RwI5aQkNH53Qd/blknE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788715507; c=relaxed/simple;
	bh=V6LNUOGENCLkm9ZOZOi/Vm2wFAm6FSSYMJpDKhCCdp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3yZhRakXbMNjnvfaIDgB3Os977ysgrzt3fPcukIxQw713sVCG/PiPSb/VXNUIBv/h7sF7Bh1oEV8kN9V+ZuPUj/juZGEZA9h8X0HZE36ab0NF24brA4put4LbcU8tyvkPyz1wBgqzjb9uCv141lHEDwcKfd34iLtaGe8LH3y78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RSkwG/VG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RSkwG/VG"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A669140E01E1;
	Sun,  6 Sep 2026 17:25:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id afoUUyLUNP5x; Sun,  6 Sep 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788715492; bh=IGvIabwTQZmhND09OHm9YhbR9dwWckJV+EZ+Q9zQ28E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RSkwG/VGmy5iGQE7hiCDbut1C8EEipXMYhAP+DYVoVCCd8WQBGZZiiysip55ythaF
	 gVXcbdRDXTBJwD1nwWTDcoFYa5jzdQM5QcxGlJFi9A6KKy/cs2TiUBxwMq0+SqB2P8
	 7+d/0ZyIR344vOUgKMUXX0TPVVu5HE1aBm03I8xmPpsB3zTvNhmrYfSlHeoSfECHO3
	 SE16A2ICvzY6skAaAppTDQvmH15BdukmIFafQIrWOyB3AJOLsjAQ9DKGI/Wk0mffe/
	 nLxxuU42cg6vYk0erabVLYgIiAcpF+OKttQ5h5uw7I6yUvxzIpMlAJV6I19lgCEWxF
	 51YCOl2ERiDclQ8RNdnaKpQwqmkWdy3+krYG33UcwCpSljE6kPX8OczYUMUpxsjNPu
	 s3SIsWva5OeTcFqiD7nPTMWNAZg4KyaMYtjA6iM8eO1muwEMf04LnoJ3ufdJaWdA+A
	 rWZXKjsMGdGWMQWZa7v/NGo3yeckojDpHUTQtNMpy+nw8jsXjmtpyQI4PuSdxegKTv
	 18+Rl2Qzb6B9B72qmxQTH072CSR6WtxE8mbSf5Hxj7jcLDcpkUl6GU3scNglcfmllv
	 l/TeRPm7qhMtLPBo6TbmOxPOKvQthXn/J+83VnRse8/5yUyDB8s+i5OIoXHTT84uVt
	 1Y2u0EYsPM/jTssBe1twvRi8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B710740E00B9;
	Sun,  6 Sep 2026 17:24:18 +0000 (UTC)
Date: Sun, 6 Sep 2026 10:24:15 -0700
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
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v13 5/5] x86/sev: Re-enable RMP optimizations on SNP
 guest shutdown
Message-ID: <20260906172415.GSap2hv9Aa16O_tL31@fat_crate.local>
References: <cover.1788296083.git.ashish.kalra@amd.com>
 <e8a8d0ec63bda2db61cde7cf298a4ccb6a502c20.1788296083.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e8a8d0ec63bda2db61cde7cf298a4ccb6a502c20.1788296083.git.ashish.kalra@amd.com>

On Wed, Sep 02, 2026 at 09:29:21PM +0000, Ashish Kalra wrote:
> +		/*
> +		 * Perform RMP optimizations on memory freed by terminating
> +		 * guests.  The scan is deferred, so it normally runs after
> +		 * sev_gmem_invalidate() has converted this guest's pages back to
> +		 * shared, and picks them up then.  A very large guest whose
> +		 * conversion has not finished by then is picked up by a later
> +		 * teardown's scan.
> +		 */

Move that comment over the function definition.

> +/*
> + * Delay, in milliseconds, before the RMP re-optimization pass runs after an
> + * SNP guest is torn down.  snp_rmpopt_all_physmem() re-arms the delayed work
> + * with mod_delayed_work() on each teardown, so the pass fires this long after
> + * the last teardown.  This coalesces a burst of teardowns into a single scan
> + * and gives each guest's pages time to be converted back to the shared,
> + * hypervisor-owned state before the scan re-optimizes their 1GB regions.  The
> + * 10 second value is a heuristic trading re-optimization latency against
> + * scanning too eagerly.
> + */

Simplify:

"Delay, in milliseconds, before the RMP re-optimization pass runs after an SNP
guest is torn down, passed as the delay to mod_delayed_work(). This coalesces
a burst of teardowns into a single scan and gives each guest's pages time to
be converted back to the shared, hypervisor-owned state. The 10 second value
is a heuristic trading re-optimization latency against scanning too eagerly."


> +#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
