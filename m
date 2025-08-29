Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2018EFD1;
	Fri, 29 Aug 2025 04:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756440752; cv=none; b=MVzgLdqhuMnwzwmDN/P8LefCUbHZ2aHIwU/C8NG63yVsSb1j/TKb2LVBzGINdBSge0s9qLlwXN/3RtO6FHvcHaoiK15OteIyvHlut/qPvjqPJOG3itfph/YXzBjsamvz62Mv6SzZW2DKqRIEaxAKLmHbOqUzHnmoylcakzuEwHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756440752; c=relaxed/simple;
	bh=z23qMv9asvIaS761OQWXOPAgAnhNOkI6v3mSvEeOaPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvnnVU0dGvNRSHrq4UYfI03GkDp7LUFe/aTPDOvtFyUQ1LTPWr02wnmwj48yPMG31VewMl+ssyD5uHhEEHVcc2XVCea3pE1UyexThgjeB03j+wYwzpxyUfY1ePw88sQlekjEE3qk9/HF2YRT8PP55642nEM3wRBZeFHtSeYpc6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGn5g/cE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGn5g/cE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D249BC4CEF0;
	Fri, 29 Aug 2025 04:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756440752;
	bh=z23qMv9asvIaS761OQWXOPAgAnhNOkI6v3mSvEeOaPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pGn5g/cE5aqZg9W0ikZ5FAAHGbXeLzt3/o5yo8xKISCuJa2T7X+RpbyKIKkMDPbqm
	 m142QHeg+CyWsBzbke8175jQD27SgmZDTyyeVXyhxWsioBPt/0xJQVg9VktSaM7Os7
	 2wU61n1n+XYluYDUeP5E94kXiF8luOOgcyZBdCg3WaAtMyifCZt2yEO3j7hqiWddYc
	 dmTYFg6Nlps1sh15O/Fatnsp5qCI6TUxrathV2utOFvwFFOGOjE9Z1wQgCr0ZOwtbY
	 alB8HCYx+dh+fVaP9NanxRsuC+rXh13tfxEO5A+R13XD8UGRUF1NCs5O6SlEhRXLqD
	 7QnKQhGoXYr/g==
Date: Thu, 28 Aug 2025 21:11:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Andy Polyakov <appro@cryptogams.org>
Subject: Re: [PATCH v2 2/3] lib/crypto: poly1305: Consolidate into single
 module
Message-ID: <20250829041128.GA67340@sol>
References: <20250824025736.148576-1-ebiggers@kernel.org>
 <20250824025736.148576-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250824025736.148576-3-ebiggers@kernel.org>

On Sat, Aug 23, 2025 at 10:57:35PM -0400, Eric Biggers wrote:
> +ifeq ($(CONFIG_MIPS),y)
> +libpoly1305-y += mips/poly1305-core.o
> +poly1305-perlasm-flavour-$(CONFIG_32BIT) := o32
> +poly1305-perlasm-flavour-$(CONFIG_64BIT) := 64
> +quiet_cmd_perlasm_poly1305 = PERLASM $@
> +      cmd_perlasm_poly1305 = $(PERL) $< $(poly1305-perlasm-flavour-y) $@
> +# Use if_changed instead of cmd, in case the flavour changed.
> +$(obj)/mips/poly1305-core.S: $(src)/mips/poly1305-mips.pl FORCE
> +	$(call if_changed,perlasm_poly1305)
> +endif

Sorry, I realized I still didn't get these build rules right.  It needs
the following to prevent mips/poly1305-core.S from always being built:

    targets += mips/poly1305-core.S

RISC-V version needs that too, in patch 3.  I'll fix it.

- Eric
