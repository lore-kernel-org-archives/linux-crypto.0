Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795169339;
	b=RexyJ3mdtkLN8CO2QIvQrOxI9Q0TU6/9E3mem3X5mDMF/cPsqdWBJPORsuGGL5NYY//z
	 ObiRLw0aM7tc7CkbnOb7BptOBzXQEJcp6fcjNyzKZ87LBVr0LI5Uvz3pceRxYp0YWTIF6
	 swLBHjzsrVGHEzanOOo9bO3BO+lmc6gugmVpPgf3sTwYw50SOFrWkdLjdgRXi5QyDSfep
	 bsu+/0LHKMWTeym81dbcj+hEFqTObe9WKO5lqQT9V2ZOeEbW9aQNVRFeH44HQb6DdoxID
	 Bqb4340kuwJ0sYSMAXYvg8TNZtt2aPp4j+ZfKYChl8l/zVoCleVfaF+Fr0q6GCEKLKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795169339;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=a/yPvsuyQKidDGPeEKJxrugs2SOnd4NXe099F4lVUCE=;
	b=D5wUjtfPdb40D+2DVdGUpbuliKJT3Y4UZCYGpQuBMaIDRsdFadhdc7e6flwJmC9ipjtA
	 RefCOwbIsNZHGg5Z0XlLpojKzykN2CnYOTUMgcY/McvGnhwKSdHIgCOAno7SwGAGn6ph7
	 jcTlTkMRHD4gDeYRs3tzBUC/3kbmrrapM46o/l1z4LipObzuIBXGaB9xT57jqmNnwr0mA
	 otFAPVAm0Ta9LqOL/cO3Vi7XYxd0Boi14Ft6BGMPWts+sduGnKe6sCSa24axLAFr0UqRR
	 dBbzDsYrOmpt3UJCUdjlK1CG5AdWJvUPXq25sQ17weqxRqnOvCdVJL6yZbANDp76nKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MKY2zM2T;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2047C606A334;
	Fri, 20 Nov 2026 10:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2047C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MKY2zM2T
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3883B1477;
	Fri, 20 Nov 2026 02:08:55 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 940733F632;
	Fri, 20 Nov 2026 02:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795169338; bh=smHjf+1WZoiuJVQZvV/DEHqRPCzJJYdPwysB/bAQ1zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MKY2zM2TUN5Q+pNCTCxoFwyfgg26V5F5lkzPVsLWwQHx/8ZXd9xvPclM2IvabwAS2
	 mfFfTxd8N/pcAB4ky49bECNwb6SZBYu1hpKE7S0p81QPf3DndprYgWPQ+dLv1J21h6
	 y7QEi5I7IniNAmFdsGDAsqQLz5eOMJrOUmTD+0rs=
Date: Fri, 20 Nov 2026 10:08:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Russell King <linux@armlinux.org.uk>
Subject: Re: (subset) [PATCH 0/4] Get rid of all NEON intrinsics stdint.h
 type hacks
Message-ID: <awAcNlbDwM6xmLjH@arm.com>
References: <20261029135020.272082-6-ardb+git@google.com>
 <179508547602.2557572.9682726373932810888.b4-ty@b4>
 <81ddf2f1-faec-47ec-b3b1-7210b4e7712b@app.fastmail.com>
 <20261119192848.GB875856@ax162>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119192848.GB875856@ax162>

On Thu, Nov 19, 2026 at 12:28:48PM -0700, Nathan Chancellor wrote:
> On Thu, Nov 19, 2026 at 01:08:51PM +0100, Ard Biesheuvel wrote:
> > On Thu, 19 Nov 2026, at 11:51, Catalin Marinas wrote:
> > > I left the last patch out, IIUC it's just clean-up rather
> > > than fixing a problem on arm32 and can go separately via Russell's tree
> > > during the next merge window (let me know if you think otherwise).
> > 
> > I'll let Nathan respond to that.
> 
> Yeah, as far as I am aware, we only need the arm64 bits. arm builds are
> fine right now. Russell's tree would need to have the first two patches
> to apply the arm change if I understand correctly so it could either go
> to 7.5 with a backmerge or 7.6 with a base of 7.5-rc1.

I plan to send the first three patches as fixes for -rc, so they'll be
in 7.4. Russell can merge the other one for 7.5-rcX (well, Ard still
needs to cc him; copied now).

-- 
Catalin
