Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCA225785;
	Sun, 23 Nov 2025 05:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763877216; cv=none; b=FETDmxgkfXx19lzaYCwpGjuMkDWNBrvFTWQqgwQjtFifDWcAJMw3sffQf4KHNKOnm9HmeaSEPVbi6oSLWlFQ/9SseHXOeqqAKev+3SqDl4OaMTCegg/Om+PmmHXZHktDCgSZml1Y+2HeQZafmbHPtLiXOj/hNvh3y0U/MGAK4no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763877216; c=relaxed/simple;
	bh=/ruTeuPvcOANSJ2THFRUezMHU1XSmFc2P1vj7WskTpY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPhYMS+/OdFnVOpHKColnEfTcoAy595ztyEveDiw/GiZtia9Sow5oIPNsmHW4e6FtbXZAUoNH8O663vKEqz3RAgbDswPjjiMiFLc3dVnn2tefmtM6mNTZ7ttDnXwO+5QcSLE8EM5kcLj3zhKSU9JWOi2h6SdgjBl6g5avfAViLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=RhvWYM2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RhvWYM2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2CAC116B1;
	Sun, 23 Nov 2025 05:53:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RhvWYM2s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763877213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ruTeuPvcOANSJ2THFRUezMHU1XSmFc2P1vj7WskTpY=;
	b=RhvWYM2sNfePIvTt8CUDlYuacdufeNjqYKpwfWNm+0pwS6VAx66sehZkALzaLOKEbCIXup
	GnZoBCb4egl2Slw0jCtwpwG8Et7sZk1KJM1xuM9t/r87BM28Y0mB4HudAQRG9gkfrkfBkP
	fBYDQUuQgXiO2MFKNsq+66rs9lj5DuM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c4e5baf9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 23 Nov 2025 05:53:33 +0000 (UTC)
Date: Sun, 23 Nov 2025 06:53:34 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v4 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <aSKhXgtqUnkSaGrT@zx2c4.com>
References: <20251123054819.2371989-1-Jason@zx2c4.com>
 <20251123054819.2371989-3-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251123054819.2371989-3-Jason@zx2c4.com>

Ah, the subject should probably be "compiler_types: ...".
