Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE4C8CE;
	Sun, 23 Nov 2025 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763904085; cv=none; b=lL2OrGYhtAedDXXZSdmDL0+1XdGbmCrLwccg4Zl5AyFTYtxiqEpM09RDAIZNfzPEOzmo6jcK6zhI/xIhmdaRu2bF0nRPELO3AE4YvcIwQgLN5vd11rdW9/SnKTMPsZ0OkqVwO0F6yH+Ry5X8i0XJOKklQrJswD99xk4ZKUuotxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763904085; c=relaxed/simple;
	bh=uHkqng3PE/9XAv4lfDp3wnbkDpWSAIvDKX5Fbh8s2ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNymp0DvUSDiW7cIK+nKjE5AFAM+Tmof1mhBoAcG3/0GGFgTIN/D++2qXTPm3suZVlmTAtD4RyTB/0KjDW4Vy1CgAJej0l7eGD+5IqQ2a/zJepBXCSv6EcBxIXb//3M7DdyABFPggl/I3aErCrk7hpy/YwnWK0zADdo1Zm+P5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=dgM2TkW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dgM2TkW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD41C113D0;
	Sun, 23 Nov 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dgM2TkW6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763904082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XIEnNVaz8qmhTqw90pB1dWyUGruxiuZXNemgFM+75UM=;
	b=dgM2TkW6HI4Cw/GsYiHfxxKspRKhDO2P7SehyNXQtZa/zew0CRbCnqbIp2BNw/wm2TVzvj
	mPJcA5tLt9MA2yFyDK8JVzuX129L5Jbe7WoEUqYSoMe2iSkgeaQY8kbvxZ5NhUxQi0ewxv
	w0ktGcVV+iFNsJj7xZFfbsfoXqk4AG4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9464ae3f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 23 Nov 2025 13:21:21 +0000 (UTC)
Date: Sun, 23 Nov 2025 14:21:23 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <aSMKUy_d-8damnKv@zx2c4.com>
References: <20251120011022.1558674-1-Jason@zx2c4.com>
 <20251120011022.1558674-2-Jason@zx2c4.com>
 <20251122191912.GA5803@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251122191912.GA5803@quark>

On Sat, Nov 22, 2025 at 11:19:12AM -0800, Eric Biggers wrote:
> On Thu, Nov 20, 2025 at 02:10:21AM +0100, Jason A. Donenfeld wrote:
> > Clang and recent gcc support warning if they are able to prove that the
> > user is passing to a function an array that is too short in size. For
> > example:
> 
> (Replying to this patch since there is no cover letter.  In the future,
> please include a cover letter when sending a multi-patch series.)

Ah, sorry, I saw this after sending v4 yesterday. Will do in the future.

Jason
