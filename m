Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4663D6CCF;
	Fri,  3 Apr 2026 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775246056; cv=none; b=QmYXCIT0aioFAvWqqgDDu1FeNMNA1E6lq6z6N46gHbZ9C3NyMwXfarhc7bxzw4ueGE7rKK/+x0raPk6WCweNUqlePI7U9qQclrE4nHo2BPZdohm4CtySWoqG/j92W7rjAUp+/Snh0mlfjWkevI+dNCHLfh5jDPSByqpFA+AwvqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775246056; c=relaxed/simple;
	bh=hAMyJ0KJDVo4DXk9ebE3sCO3OgdZXd4wei+lEUQv+NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDznbXR5oJYEZ7/oH2II/2/Vergnzmix7/j3MTRUWpzSsgt0yf5jaJ2WbqtvJLJba/FlgbQBsIzCJpp+NRHLBbUvGjXms9U97PH7JdCnU1ni1Y2DERZiOQNEcju3hZl9lA7ZcWfaQvmt6wsMUdmzqTORpj3K70VgvQmWzkJPLts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cYEihNU+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cYEihNU+"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2A1A140E016E;
	Fri,  3 Apr 2026 19:54:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wNMHZiqu3GW7; Fri,  3 Apr 2026 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1775246040; bh=1oIVim6zhbpw8Q6YPq07jH8oiFi0rf3ZeKYxg+QYDnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYEihNU+ns6frv9ukE8D4bZEaSH1hbiDRFSi9U5uPI07jo9NHZEKzmjkynFF9NsrX
	 0wob7lCYQcuHAeD9Ix2y77mNKi76dMBEr5C1v8C+KP3Va0ixlKLaaUxedYudTRLE1x
	 c7ApxWGpLSGJfS6pwgOUZJ0s43khwK5FMgw6caA172e+zlJ6gjRseV1biRjVEeRwAe
	 ZPF3jky5EPSwUEa3KPZqU159pNphRZWxawj48adZo4n3OVkolvGoYOVONMv4AMrFO6
	 IJkw1tjiRliU1OXebXRWq4+trpwM1cqYa3e8MKzKqZ5Fv2718IRri5Em5r9UDWlI24
	 SUVdCoCHvkonj0EnIKjuYA39KwrbjYZbmG4hiYkmfIuTkOyzHHB5qaPBSBT+XN/479
	 ld1JQ9RKmU6MVke6gayU6IQ0/Pkf6JaLJ0X88bmYWRpzXMbuIKqQmNfAaxTXDBbVjF
	 S0fAbML6ZnUSSeXCfaOTNCHSYOlsz3EkQbWvvBUV6K8j+KIibdZtK+kC1KkkfTRqbw
	 xKhI54wNitK8ytrbzdukcZfVRpwSKCTHJhHb2KRUa++x1DS9GQJPg+KJ6yFJfFnCyB
	 CYczsYCT07yRVKNThEC3Z58BLZMUWAmc1ZJc2561rVDEZjCjLUPOvIOVN2I/D2Sgav
	 F3NHv9a596+EzgC2Gj52aexY=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 0479840E00DE;
	Fri,  3 Apr 2026 19:53:38 +0000 (UTC)
Date: Fri, 3 Apr 2026 21:53:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20260403195332.GYadAavDxUjWbgdngk@fat_crate.local>
References: <20260401143552.3038979-1-tycho@kernel.org>
 <70635612-76e5-488a-bb82-e66752dc9857@amd.com>
 <20260403171833.GXac_2aVdvz9gTb_DL@fat_crate.local>
 <ac_-Sfa6qAhdG8rR@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac_-Sfa6qAhdG8rR@tycho.pizza>

On Fri, Apr 03, 2026 at 11:52:09AM -0600, Tycho Andersen wrote:
> I suppose depends on how the firmware reasons about such things too.
> But it seems like the suggestion of cpus_present_mask is right.

Yes, I think that should work.

And in that check you could dump both masks if they're unequal - hint *%pb or
%pbl as printk format strings:

Documentation/core-api/printk-formats.rst

so that we can get more debug info on what the mismatch actually is.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
