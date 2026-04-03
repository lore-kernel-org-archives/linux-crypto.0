Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B03612E2;
	Fri,  3 Apr 2026 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236745; cv=none; b=A8fM3epUkFGFDV2sBWXmkR3FyVo7x4KLoNa7O5MQxkizpSjksXhM9rNN7nM2hEmTFWe+Ts/SxP0ruxAKDrKx5Gt3hn6WezNa6HeLmUlYwABser05EZIdKCqJtWFUTjXny33Ld+DGN1u4MDnP1IxDe/2Rde2VHpQ58NhLJvMJ2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236745; c=relaxed/simple;
	bh=1E83iZ26gMwOfBVeh+Jj3u4BFmg+Ydf0KArZRildDHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Csa2Eg45w8WdiM4BJOUSv27NE9aipdtvP0CwsjcEtQ3O2Nez2iAC3fjG9sE6ju6PV+1A+dAwdCEctTHIefWFLB7kgSn4mbvlGKcK8i/xeHzMgGutEkbyDkQeYqTPW9oIhCwl4/fpz++i0UqG24WYVpe7Y4R8OQPuU4nI/dzxzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RbCmnDkD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RbCmnDkD"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6F04140E016E;
	Fri,  3 Apr 2026 17:19:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pplOMlejbk-P; Fri,  3 Apr 2026 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1775236736; bh=1+F0Dmue8/JmTiEHbJbRPOS9WkJQoy2+dVqjC/siblA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RbCmnDkDAYVdJHYJXLM8K5VkCQVNssOvxwHKzC/3THtvgvrALtVu4s919+3XkwCJR
	 WVpmHCppnfZ21NQnKptiM4TZyThTqrv/AMBT2In5sd3lNSmj1LOuvYvIbJm3Yr51bV
	 mo6CkH24AtxdeGDYZnjazyZBdAX1GTQYMku/jkPVSUpkaJgSKgQ6HPOUBi3662xj/+
	 IYJ0YO21aPHJrwCYVAdNVczYI9VomU1J/cs4gQpf0YECVo10xFr+YnZU/6Tgs1rW+K
	 ejPACvnSTnmwQdHrQkhycUH+jPMDFkZ3Qdeb43Q+vhClDkvZj5HfZcZo3nlTAEKyww
	 G40lvRVLPXN3d3V+vzIL1lgMlB83y9yVW4UOYHQoXsj7tzxPZ0t96X1wY/c8/8F7c+
	 ijURju6004r1AQGvriTMxBFZ0pwu2GwAr80zz20VVE5h4i/Eyena0fcNTuovjQj3bn
	 +D9RU7SnX5LvuMPEsnMiuy0b2NBnMJp8+jZQbmgyjwB5TovtWfRJ7DMCApMQ0T6lxx
	 5km42xbdTVR1JvYd2N4nvU2hk/w0pkG5vvR4zB7aOV3dQu9BSFB/7+Tzbr5rv00WXC
	 LM2Do4XQyU4DeY5zn1WtsLMC6EyfgLGgr2Hy6Shz8jUe4nu5LGhu9gyEvdByNlauZe
	 hxLIRYIbPl1qJISdMQIqSHug=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C3FFC40E0163;
	Fri,  3 Apr 2026 17:18:34 +0000 (UTC)
Date: Fri, 3 Apr 2026 19:18:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
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
Subject: Re: [PATCH v1 1/2] x86/sev: Do not initialize SNP if missing CPUs
Message-ID: <20260403171833.GXac_2aVdvz9gTb_DL@fat_crate.local>
References: <20260401143552.3038979-1-tycho@kernel.org>
 <70635612-76e5-488a-bb82-e66752dc9857@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <70635612-76e5-488a-bb82-e66752dc9857@amd.com>

On Fri, Apr 03, 2026 at 08:31:24AM -0500, Tom Lendacky wrote:
> > +	if (!cpumask_equal(cpu_online_mask, cpu_possible_mask))
> 
> If CONFIG_INIT_ALL_POSSIBLE is set, won't that set cpu_possible_mask to
> include all CPUs up to NR_CPUS? That would result in this always failing.

Yah,

sashiko gave another possible situation where this can fail:

https://sashiko.dev/#/patchset/20260401143552.3038979-1-tycho%40kernel.org

> Not sure if this change is worth it.

Well, it would save us a lot of effort if we can check at module load time
whether some CPUs are offlined. A very simple use case:

echo 0 > /sys/devices/system/cpu.../online
modprobe ccp

<boom>.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
