Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D5B3909AB;
	Tue,  3 Mar 2026 00:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497612; cv=none; b=Z3pHFClLHoefjXDTe95/FuXQKsrYtHyEWDT2fZ1i9IOF2vUift2RM0bc/ZBpUdi36Q3PFxCSchnwWpI8WbzqeMIAvgh7TBSDkDIHsstV5Lf2n2IFSMmO6L/rOeo1yZll8M5F1f8dPLKIXI/+WMPm/dUuz0BKfRdJ/L1y3IVvhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497612; c=relaxed/simple;
	bh=Rc0DxRChtbCtwoaq+0s82dkSSZYybO5p84C4yP4BPJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsxZ+VtH31hsGrfWlHbDSll2bjhKEB8Cfty0MnbYGWly8syrvbemSFZ7x9JuT8LcBvH3JASwpHfrYoeaoyIn2lUNla9otybt8PQDQQETJFP6fp010SjKeNTzVda2V562jVgS+XJ0eHhwQxCu2HtDX0I601KQ4hRF8zcyLxJx2V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xts27gHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xts27gHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D999AC19423;
	Tue,  3 Mar 2026 00:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497612;
	bh=Rc0DxRChtbCtwoaq+0s82dkSSZYybO5p84C4yP4BPJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xts27gHBFzglUcIOSJ9h7fOAYvOeZ3Qi2foAc1cmLi1j42spxy4+pYMOH7h6L2dTx
	 I4jHoxdUQdMVPguCKBsLD1j2Imnls4CYdQB9e3I7C9EuWncKgsw1pbRQPVeGkddVT8
	 FI6RtVw4EVaY34PoTpK7J5Ps1SxR6bm9wJLMxChQ8ggHhy/N3Cu5oXTpNBcSkrH9+I
	 AOFBPaDG8g4hWYu6onEzVPixpuWpBoO694s9j1O/75Tx8my8u18LozLHCBk4FrrM3E
	 macFN80RmmZipM7/sKnkHy5WISxSE+ohcAXswkkEPnvvvDDpCHW+LirAHWp5P2JMJw
	 1rXnnRhORkvXg==
Date: Mon, 2 Mar 2026 16:26:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-nvme@lists.infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/21] nvme-auth: common: add KUnit tests for TLS key
 derivation
Message-ID: <20260303002649.GE20209@quark>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-5-ebiggers@kernel.org>
 <1de7ef59-4236-4372-81f6-60d5a4f1e253@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1de7ef59-4236-4372-81f6-60d5a4f1e253@suse.de>

On Mon, Mar 02, 2026 at 11:04:43AM +0100, Hannes Reinecke wrote:
> Which discrepancies do you see between the specified algorithm
> and the implementation?

I'm looking at the latest NVM Express Base Specification, v2.3.

First, there's the following:

    The host computes KS as the hash of the ephemeral DH key resulting
    from the combination of the random value y selected by the host with
    the DH exponential (i.e., gx mod p) received from the controller
    (i.e., KS = H((gx mod p)y mod p) = H(gxy mod p)).

The actual code skips that step when deriving the PSK, and just
considers the DH value directly to be "KS" and uses it directly as an
HMAC key.  That is something that should never be done.  DH values are
not uniformly distributed and must not be used directly as keys.

Second, the only mention of HKDF is in section 8.3.5.6.2.  Assuming that
corresponds to what was attempted to be implemented in
nvme_auth_derive_tls_psk(), it does not match because (at least) the
specified label does not match the one used in the code.

Those are just a couple things I noticed in a very quick glance.

(There's also the key reuse bug I pointed out before.  But it sounds
like that's a bug in the spec, not the code.)

- Eric
