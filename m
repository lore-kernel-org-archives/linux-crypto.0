Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E787B30D413;
	Mon, 10 Aug 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383093; cv=none; b=kWCVAHg0ggyh3nO5uodHqQEvufMt0E5ALA1kvjvUp1njILr+AZjxzX1Zy5ZS+sJUlyDtg7uX79huOqUjixsnmGTwSIO9c6P8jIxOyHk6IaW2CHft/BdSVmKDk+wvygV0CaCCf5G+VNv26yy1i9hFJ7/7X0XpM0wXv4DMuVZ/6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383093; c=relaxed/simple;
	bh=jn3DnZ8nSKDEbEhMIKu/snhovwo3ij+JNY3pV7qzriE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cT8vsUGsRnMCFv16Qn6eyHrNoqbWTx1xtEAKc9qtHZQCknjZ3CQ1ZdAYIo7Z2ywyOZVLzEp0wIJNkjv70btZmaPzkK9aRyIKuaSw/LLm8YeGu1kf3AYfSX+aVLo1sBtUCPMBKn1OMRPLi7/QnlDVItPNR36yfGqwlDr1Y+UAgko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Cly4RLit; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Cly4RLit"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5AA2E40E0031;
	Mon, 10 Aug 2026 17:31:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6FhBj5Z8Jten; Mon, 10 Aug 2026 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786383072; bh=zXDuxTVzxqJR90PY15cLjqnsPmGMetHAEPwbiwSVHng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cly4RLitwcF8KLFm/QTZhLgWNJqgzt9r6DUUuq/MmeNikJ6uPYGPQwzDKI5TttE++
	 illg7iEdWqn0oto0Up2nhqSXnYUe7PQIqf6eQ0N2N0T2OAoKDxlohJxZSBiYrfFoIx
	 IrAMJTYaimDd5uMSDO261z7KTeHgJBBcNDpWWijJd1rwxqlgYSE75k9ndOLr/bP3NN
	 o23gMxXho57ZX6kjOJ5XoTiYLksXEuobE9f/v5mOQeW6vYWtrAgHZHBcNIdtZ2JIPd
	 c07CbSnHFtizfFYUgjg4EWuX3U6YADVPgwq/tYKet5RwhQ/yEWOc4/iE5VuJOC+a9/
	 9TftgD47g8OcVY6XbRxKAxk8pft67k1mGlalgzAt+ai/ROvqXfZVgvltxlnmnYyk1J
	 ydHUc/9K6kvdIlBqfPgvX2PG67459aYn0Th2AvHQzBzueQWXytXp/n4fz36HCsr9ne
	 l3rIRgs9PPJB7s1ac1tM6WqMGu2W43vYgKXTO3tQ/Gb3SeaGy8ogyUzRykyJ/3nlZB
	 hYsn2S0PfSjPM9vzPRWPTMZzSkW1Hd/9waBWnVtNUX4PUqSoJ4GyyBW2Sg3+wzpPd3
	 +irK+bGrnWoHzMQCkd64Y+buANPnnsQ71S/PBQtGADUPLvPa/QuB+i2vbTaVopC4MZ
	 LEtSRN9Z3Z8OBrR+RKCDvi2k=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 959F040E019C;
	Mon, 10 Aug 2026 17:30:37 +0000 (UTC)
Date: Mon, 10 Aug 2026 10:30:34 -0700
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
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 5/6] x86/sev: Add interface to re-enable RMP
 optimizations.
Message-ID: <20260810173034.GAanoKujdd2O4bGfWC@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <afc058ce32417dc45e3f7cd9536d0fafafcacb4b.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afc058ce32417dc45e3f7cd9536d0fafafcacb4b.1784844080.git.ashish.kalra@amd.com>

On Mon, Jul 27, 2026 at 07:05:54PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> RMPOPT table is a per-CPU table which indicates if 1GB regions of
> physical memory are entirely hypervisor-owned or not.
> 
> When performing host memory accesses in hypervisor mode as well as
> non-SNP guest mode, the processor may consult the RMPOPT table to
> potentially skip an RMP access and improve performance.
> 
> Normal guest events clear RMP optimizations: pages are converted from

s/clear/disable/

or "prevent RMP optimizations". "clear" sounds weird.

> shared to private as SNP guests are launched, and large pages are split
> and collapsed during guest operation -- both clear the RMPOPT
> optimizations for the affected 1GB regions.

> Conversely, guest pages are

Not "Conversely" but "When guests are torn down" or something to that effect.

> converted back to shared during SNP guest termination, so those regions
> may become eligible for RMPOPT optimization again.
> 
> Without some intervention, all RMP optimizations would eventually be
> lost.  Add an interface to re-optimize all of physical memory.
> 
> The interface uses mod_delayed_work() instead of queue_delayed_work()
> so that the delay timer is reset on each call. This provides proper
> batching semantics: re-optimization runs 10 seconds after the *last*
> VM termination rather than after the first. mod_delayed_work() also
> re-queues work that is already in-flight, so a re-scan request
> during an active scan is not silently dropped.

And I keep wondering what are you even doing here until I saw the next patch.
Just merge the two into a single patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
