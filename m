Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4139E37DEB5;
	Thu, 23 Jul 2026 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783719; cv=none; b=LfZlkywZYEN1HTTEwiWlqoB30Pfgmr2UTkGDdL6Gf/8XTOWe90KHkBSWUQAmmpLd3qdZEJwQKgIfbUvHEAnk3TQp41F9Kw5CMMisgaB8ceIETlrOQVSyoSCX3zxaBkolQ0BthktDmSL52iR7/NCp2eO6K2BrduGXd0ZMLEtLxRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783719; c=relaxed/simple;
	bh=nUFIhy23wPIvcdXKNXP7uW/tn5Gq+I2t9wo+ptAuegg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ml68Lnsw9ag1wuH8N7bJpM9CpKYGc3cI394Ja/330EspYqgL3bAUC/fxgCXS+WtBeSHKJK4n+euM8yazgQiRiC3OnAyM07lUQSMNkNERzcGHe5HexMxj4lSVJkVECmU/CbhmLqQcm+SmeoxWjJXqlMLpfd3hA3PBge0BtENjmuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=B/NZ0b/J; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B/NZ0b/J"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D94DE40E027F;
	Thu, 23 Jul 2026 05:15:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id etzROib32P5O; Thu, 23 Jul 2026 05:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784783701; bh=OQRjjaSbk43bvPbDeB6pyF9tcyG0794hJa78bgjEmrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B/NZ0b/J0iSmUCpooQTeluxRCzi6OhX3sY1QLGSnPb3eUlfgE/GJlLTEiKZckMeW+
	 qp/on+sCkiPmDQbKCLxaoPPVXSRA5jjFB7CKPigZV8Mb14rGGP79fQJ4tALydOT6KR
	 YBKL+bg96Sd9lbpWwbhm/IprgMYE94P9mNwYZIJ9jtAlINda+Ys3f6/BvIMqErXSdu
	 6hkxTxytEXPWDb/qZgGOUBi3kggv4RybfPqIUizam/QPE5RstodpZn1NmQj9BdtpY9
	 mDOyL8rLRaw7dDS31EICtKtbY2cQKKlAfdzi8ToUv1nBvV8z7cSAG7X+AStCTxvv3/
	 LbSNKJOyL+ezJ9KrXza07EteOdzeiKY2HMjNYuspAVxlDHbph5AMCpH8hdGEzqPndV
	 SHjb8BM1VkNIPj2zbSy97SsUHbtLKtobxSGkmsSyXLSDI3h+hZ5lF408HIBAkwGmw3
	 LsD82LdzAZr46UAlpZr9KOCeEIUa8jkS2FVnnFw3VLVzTFBcQwdNWFYCYNJNy4ZxOb
	 7CNzgoTCWt3DkZirO3LD2qt1X2lvneN1KKIH+6d1GRhhI+Y0URmA+hudUWq5PiKg7q
	 kFJXq4Uh4O6FxAAtV+zgPZmTGNUVTrIp2phvUFKjwZ/n83HIe17i250w7sWBFmfwiY
	 Qdg36mppiK+O550Ps9Stxumc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0800840E00DC;
	Thu, 23 Jul 2026 05:14:27 +0000 (UTC)
Date: Wed, 22 Jul 2026 22:14:22 -0700
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>

On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
> The offline cores will remain offline since hotplug is disabled. RMPOPT
> is simply a performance optimization for RMP checks and leaving the
> offline cores (that will never exit idle) unoptimized should be
> acceptable.

What happens if you boot with a subset of cores, the boot flow enables RMPOPT
and then you online the rest?

Have we tried that?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
