Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617865192;
	Tue, 14 Jul 2026 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988591; cv=none; b=l3oOdaBPwIRM8QruVW5Ko8O9FEN3OVKqdSyu/GhK4QVr6RF4WkyfD64Afm6YMFcIxSPFiUXW3GCPDTiO8FTLzo21scXNazKmAXo4IN6U/0AXGdAyhY5ajfxsnWnxU4MJkTD8TXUQ9Vh3+kPV0RpJ09p8wYUuon3NOdWwPROHz4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988591; c=relaxed/simple;
	bh=rNmfYOgW0bOO/ZZD5dI06lSNkQphWfcdh5mx/GCeUSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CH/socQn8MEeA2DTIlpMc1jut5st9UX7xCLwvsA9ptzd/ALsfdMlgSIkeBUtjXWXNG3pI9OALUsASmvADiZ2pYUDh0DeJwTEn1xqDRgY/hHo85RMC203Rnjiu4YRf03ZRTTLf2kltmuPwBWEGHJ7CYcgRk0dfU55JQG3e32m8wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7YbjjOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7YbjjOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8751F00A3A;
	Tue, 14 Jul 2026 00:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783988590;
	bh=XYOcibFAuGLyKoBSgJRMGJ47aKWWmtww+7w6c4aZzCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G7YbjjObeKSO8PKnkpMqBXGdam1tjRQvlda1q77UhN7j32WGEzcUb1Tccs/6+niii
	 QPqrcnDGfvNDUVgcqtxOIGDKBBgz0l+po0/coFsaDEAhwyl3JpX5orwsmqvyswOKj/
	 2H3xEkdhj6Lf2ILFd+kBJT6JIxRLLKfBXD2tkAOfmG7ZcTKKRWM4lYFSjZZ/sInsf2
	 y4jFcKf+h7jWmvd8pDoCGRy4253aKUKKvZ5A4/tHEdZ+FKPhWuUm4IradKLPdNhvqG
	 mSCc48i9E600BlIiv9M5TodMbFPa0w390hEMa28yLEs9Vvu+BdDVPJ/qQP494t4GyJ
	 M0vfxiirA2wuQ==
Date: Mon, 13 Jul 2026 20:23:08 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/33] lib/crypto: aes: Add XTS support
Message-ID: <20260714002308.GC24654@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-6-ebiggers@kernel.org>
 <6c6d258e-d510-4e44-bd07-7ea91b9369a6@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6d258e-d510-4e44-bd07-7ea91b9369a6@redhat.com>

On Mon, Jul 13, 2026 at 02:15:05PM +0200, Thomas Huth wrote:
> So in aes_xts_decrypt_cts, you're using a union to get a u8* pointer to the
> tweak, but in aes_xts_crypt_nocts_blockbyblock() you're casting it instead?
> ... looks a little bit inconsisten, I'd maybe use the same way in both
> functions (IMHO casting in aes_xts_decrypt_cts should be fine, too, since
> you never seem to access the individual bytes of the tweak).

In aes_xts_decrypt_cts() the buffer is first used to hold a le128 tweak,
and then it's used to hold a temporary array of length partial_len.  So
it's two different purposes, and the union makes more sense there.

- Eric
