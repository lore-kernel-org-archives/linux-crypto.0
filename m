Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2AB24DCE6
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760463589; cv=none; b=Of74fGUSjTuKuCjQlFHwZic0Idp7SBe/7O4XNw7Rv86mVM/U4pHlVFlrlXCwCZ735S1rUgsuUfYV5R9+dGbtoZ0MsQAB8WDOUlzovm/SX/UEjlOgnPiE8PX+QIQi6sZYo4fZu+6wySaODpfQpemGHjuCkNzdpnyYyF0OhMczMjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760463589; c=relaxed/simple;
	bh=2MgZiQ8xCOmS7begoOB7JEYWhDBoDqRlArb5/meY4Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aokAOMJMUXGBaHWXLD4Eo2N+AKRb5xbbX5BvuW8Ch3nWqL9y4GMh2nGLAfwCbZ1/Z1mQfZMgKbIoERmHCozd1hcHXeBl/kelxB2sXjJMdWnetlMEPnIpBE/4jDEtNmrZ0EyGOcQmbmvDEJVnZiUCyDlReRDJo2cAwUak6hm5VmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBfgm/oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBfgm/oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED22EC4CEE7;
	Tue, 14 Oct 2025 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760463589;
	bh=2MgZiQ8xCOmS7begoOB7JEYWhDBoDqRlArb5/meY4Us=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBfgm/ooW4+ZUXOHYWXrYcTe7BHM8YMsdZ0F+vBY+IJvlGkrLfoZHGY2NKYxY9FPn
	 QNWzu0WFawJduerYC+SM0t9NBXB17YJkmeu7bQnoLw59zoEGg1x0bSswSeyYta6GWw
	 J3byrrEBGnzG/N6PcIRBjCAQMjVOF+XjiwxAV2pIQtEbb0/0U1ONAb2uCcLa0ELp4L
	 pX0tFee8N/g76vSMTdkfbzwSsZOm0tlzwwUQrAcmo62PkqdTy6r20KuVSMJpQfTvPU
	 v0ywKMmgI/gJIB1J514CtPjdLMvDIx3G7B0BrpHazWeM2s9eXXLQBqQDjaTpgvsKdQ
	 cu2W9cpSwyT7A==
Date: Tue, 14 Oct 2025 17:39:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: Adding algorithm agility to the crypto library functions
Message-ID: <20251014173947.GA2923951@google.com>
References: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>
 <20251014165541.GA1544@sol>
 <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>
 <607ba12f2700e4a5bca9e403dd4c215d7cb6e078.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <607ba12f2700e4a5bca9e403dd4c215d7cb6e078.camel@HansenPartnership.com>

On Tue, Oct 14, 2025 at 01:32:01PM -0400, James Bottomley wrote:
> NIST is deprecating sha-256 for Post Quantum so it's a time limited
> choice before we have to do agile anyway.

So support SHA-256 and SHA-512.

Let's not do "we have to support multiple algorithms anyway, so let's
add a bunch of other random algorithms too".

- Eric
