Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536DC264629;
	Mon, 10 Feb 2025 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739222254; cv=none; b=Wbgc8ipKDj/WjChlILkVGO9akzLCLZAfWfuSRTPglVTqtTZsr0RMc18PtncVNgoNvIlsOLoH4p2HdjuDGzyYyjRU6uw0CpHb01S7jMEpaXwC4KZq3dopXKoi9PwAxgb3kG0302dh30eO01GzZexWEiZt0V8WohxV1PGGB3aFHSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739222254; c=relaxed/simple;
	bh=NbgMzbcyw2owQ9/39eGsTtzw7KL8UJNuQApxo5Y7/VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cu5diER+1x3P9Tw+SWOc3Y9PvDgwngBQsXErqQAgO4jHrhYo3e7Ms7EqNyvUCrvpvt3oRak+Z9caLnUikRo4zukM00xJWiM/orncwj1PywibitZQRtpq4XszpKZBJgJ4YN8EyGPXtduVgIDiceeK+OyOrDb1xv7Cd5EMmVMBTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VqRkoeDv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VqRkoeDv"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1B94F40E0192;
	Mon, 10 Feb 2025 21:17:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id etHQdUE8OFdG; Mon, 10 Feb 2025 21:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739222246; bh=RaxWY8Nec5n9lz+Fu9jiIKNndnwovJmtFQRUBkpX9nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VqRkoeDvvI8pgX4TyzdOE2Dd4ITfwg878q4pRYQLCmorDIs24bX2UjvDCUW7X4uVu
	 dJonaxq3DZPmUVPM5AUpwlvrtWuyToKecy3Hzt1gF90+f5yWlvinCrmbxWNLdUPHNA
	 qhTFpT9VpsleS26MWYHjrjuN+jOxVCczCp4Acphc5SBW9+3sBSthZcb8rY6g0aUKxK
	 76uyTV6Z7PmSI+G2dBEByiPjFWo0pj77xTQzBCtZ2JQJYnvqgaFcA0XCclcl2lG3Lq
	 gCuvYDJsTLnxDrGfmW4Ar5j8fzL9bIuOX83rAOLGiQAKCIpI3lwk1LDkiupT1lecEv
	 YYyGt6Ta4lY+galkXHQ9UMwZEEgpoVFUxT4U4Dvdvxtrd0wQjAH4tauMhlJrXx4yvS
	 bRV2IyxILYaYe/tIS9Ir4pOLLAdHeLnuxvuyEMjuotr+9zVH+fH5fA37eVIe3P+RYx
	 2i1ZbPDI0mB8bB/cAOypjl/h28Um/pS5T/j8jwBMdmKxSRqoNz7YA5rkmOANDBG+E/
	 WegEgz0y2tO4ZslCYTac6sqaIxf5U9k3Vw/zWdAV4/u0KxtvufyQspQEl9ncRXfnoh
	 QTPVRxJhV1n1RJMIHSkg8LRgOHXy2ij2TnB6BRIM2Vmhi7Kq3r+5CVnSvMeCeWbLBj
	 rIcPA5o18Tq9tWvQqp1m2XXE=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 04AD340E0176;
	Mon, 10 Feb 2025 21:17:15 +0000 (UTC)
Date: Mon, 10 Feb 2025 22:17:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Message-ID: <20250210211710.GCZ6ps1pNklAXyqD0p@fat_crate.local>
References: <20250210174540.161705-1-ebiggers@kernel.org>
 <20250210174540.161705-2-ebiggers@kernel.org>
 <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>
 <20250210210103.GC348261@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250210210103.GC348261@sol.localdomain>

On Mon, Feb 10, 2025 at 01:01:03PM -0800, Eric Biggers wrote:
> I see that cpu_feature_enabled() uses code patching while boot_cpu_has() does
> not.  All these checks occur once at module load time, though, so code patching
> wouldn't be beneficial.

We want to convert all code to use a single interface for testing CPU features
- cpu_feature_enabled() - and the implementation shouldn't be important to
users - it should just work.

Since you're adding new code, you might as well use the proper interface. As
to converting crypto/ and the rest of the tree, that should happen at some
point... eventually...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
