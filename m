Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A672917BCE;
	Mon, 10 Feb 2025 21:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739224179; cv=none; b=SlMWAYqDHZuMqhAzwEPLHpqDmfYSEU6wOV6GgRsdNYRdrWqETzKhdyqsHq3lvYhUwGI2mhkA9Zb6W2pCtDDF/7Y9JNi22J4Ay3Lstdb4ig8iV+2/rhf0WjaElnCgIqcAmhRDxIqhpGVuFCmFIsAL9tXfy/4lD7F/QN86qtySo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739224179; c=relaxed/simple;
	bh=CMH0lCE4UKBAqjsbOKBbPK/OudKwXDkpG2SCa7blu+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTGg7mGok3Y1A7FDd33X5VtbZooGjZDEXKloMFpdZzgMBNesMHeyzo23vNS0mYHIOWZPRXzX+duVFee5Or8/oVUPGjPb6HnFDXxbNrPmEoKdbG50+r8OwAIOOpXvkcfNtmmFlwx6P9cqjI2n9ZKDsDJHOSa+ERM6sLhOGBjyMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JwwfSmUU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JwwfSmUU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A1E8140E0176;
	Mon, 10 Feb 2025 21:49:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MLCjmeRqh906; Mon, 10 Feb 2025 21:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739224169; bh=u60Y3XOQngf86+CrfbNHL4uwS9yUESpIZja2xEqG36E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JwwfSmUU4Gs8CFcaAvgJBS300n40txncVCaaS7/rxLP/Zp20jfSU6d+WsnIulEWoI
	 KBrMo3e0b7gNjmZoUBV4u82BSNgvLCGCYuU03uUXvKHYU8qJkAY6R4Km+ONB+wwZ3v
	 0YlhSpFSmGvhlGcNk/1ES48Uw8nV/PW3pDE/KRDy7S76ie4UxgxKzCtSn5Tl2V/BYY
	 +bjR7evz3xE/IEOB6xL4ihDf5xQFYofAVM2U01ip4B3LrgcrZ9iI6kbkNMwm3qmQ8S
	 SGnHmJsdTIVQr8fAQwYgu3ckkPjx9OKlzIg3cTVV5p/PLAQqAFBpBAknqYFgzD60Qf
	 SrNVtSgGELV2gXV522ec5ewCMKo6pJCNQ/ZuGOBtwOyzKkE6fxAdkNZhO2XVOD4K28
	 ze8ncuIMk3JUfJSGn6NDvp/BGqeKiq2vsn/Nz2Mug1EIc3hu/+mU+5PHAjRFsItxcL
	 GS5LEE6XhwJHtB565ERN0A4cajpOnhe+S0XQOaWhE4XhxDngeBkqxXC+TxRffTRxgK
	 XfquKXie0Kwf4GSB7ij9T+HUvsvNOmH0FgbzJ/XhwT8LUoOv1+ZXgT3dF9v6i61Sk8
	 igdU3N767+/DM8Cd/Gmu3h2g3ptA4AM4hU7ifBpodslGxRzDUwXgfT5bmSPJcOpw+4
	 j+X6KpxOx+1jKsOyLaFKAkJY=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 473DB40E016A;
	Mon, 10 Feb 2025 21:49:19 +0000 (UTC)
Date: Mon, 10 Feb 2025 22:49:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Message-ID: <20250210214913.GDZ6p0WdZL259TOMa7@fat_crate.local>
References: <20250210174540.161705-1-ebiggers@kernel.org>
 <20250210174540.161705-2-ebiggers@kernel.org>
 <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>
 <20250210210103.GC348261@sol.localdomain>
 <20250210211710.GCZ6ps1pNklAXyqD0p@fat_crate.local>
 <20250210213705.GD348261@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250210213705.GD348261@sol.localdomain>

On Mon, Feb 10, 2025 at 01:37:05PM -0800, Eric Biggers wrote:
> I'll also note that boot_cpu_has() is missing a comment that says it is
> deprecated (if it really is).

/*
 * This is the default CPU features testing macro to use in code.
^^^^^^^^^^^^^

 *
 * It is for detection of features which need kernel infrastructure to be
 * used.  It may *not* directly test the CPU itself.  Use the cpu_has() family
 * if you want true runtime testing of CPU features, like in hypervisor code
 * where you are supporting a possible guest feature where host support for it
 * is not relevant.
 */
#define cpu_feature_enabled(bit)        \
        (__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 : static_cpu_has(bit))

#define boot_cpu_has(bit)       cpu_has(&boot_cpu_data, bit)
---

Forget what I said - we'll convert everything when the time comes.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
