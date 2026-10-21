Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792565701;
	b=hsbFmq42ct6nG9fX/aJ3q0ibu8bMacv6B3gGLAA0Txh1rLiU+LEMD+0wwiZMcnS6i0wM
	 D++4pTwzTPWIM7hLE8kDHoR7ioJgYHbViZ5c/0PWzNPSCl3fM74BoRie8zMMTeg0tyupH
	 NXdeBHw5NNmNpU/FzAZ5qK4snjbBESvvKO0Z/ia3/PN8LDwmfRmJ9LGQexH9dAbpbnUNm
	 w8vtEQtWPPzMFPJ2Ch6RLmJsvjrUinV+1CvE8289Ra7ZZhkOrfFY7HAf22Wv0yh9FyfXH
	 +XytA6qudPZYCJyKycDWRYPLliOw3t16/o1/Fz062iBy7rCx457hEVN2JnkNH31HhSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565701;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1BqHJjII6cVWu3Nsh/HKxlnLNSQZKW3DPQgCR3y1+gs=;
	b=mjBlrGr6xlta6upmlSR/1GE7fuMm07kqAQ6OlYCImWB3nyXCQKYSboa2zWmBNUenKPH7
	 oCWovQuAFZhpfCwxz1sMgeRHX5vWvCWuMlL8Cl5hlUMXPCjW/mtlaubqVdc54ms6+t/OJ
	 VjtpVdBM5a4ynjY5KGp3g8DsuvMpnSxkKtwRRgQmG+o3QopnT9L4U2t6+NOgucLMB+zQ6
	 w6N2nSOYMqjU+uGEcwmps3GtY6Z9WPulfbsCYJep7wiylZ5+4+lqgHALoIG4mil+6ott3
	 F6sYsSY4iBCq5nFHTL5kjWPGgOnKg1ITioWAE6wpjKLnQ95zWZJo3zDKo3H/T3IsEOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ShpRYgID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB3606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 06:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ShpRYgID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43921F000C9;
	Wed, 21 Oct 2026 06:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792565700;
	bh=1BqHJjII6cVWu3Nsh/HKxlnLNSQZKW3DPQgCR3y1+gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ShpRYgIDjX4Z3e5gV6DjdlI3C9GSQyFJg5YUhHFvadDaEYWF9fupGDBt7GsX892L5
	 VX2We0Y9UWHIdFz+5gRi0p5sWpFgaecprP5R0A0F+WD4RqXwll5VrhOUHROD9w0zCa
	 px9Fo7h5xp/swhEeSJZfxDbAIkK8cNJMgHAYKtbRYf3xUgforGosDrMVM8JG1F7Gzs
	 B+QOuwyoeiRAqKV2u+ZGnqK1QS66h3Q36EKHLfOFreYNhxvn17FOByEWfBEMu0lEW4
	 1mL/WnRuYu56f2GuUffOT4DFW8gkIXt1IEF/tm0GqdLzUPa2ML4B/eOpVs0huV5BXK
	 aBKVZpWPFkAwA==
Date: Tue, 20 Oct 2026 23:54:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Enabling Sashiko replies to linux-crypto?
Message-ID: <20261021065459.GD31908@sol>
References: <20261020215744.GF699485@google.com>
 <d3dc7e74-0189-4aa6-b23d-0fa8ad75e059@redhat.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3dc7e74-0189-4aa6-b23d-0fa8ad75e059@redhat.com>

On Wed, Oct 21, 2026 at 08:18:18AM +0200, Thomas Huth wrote:
> On 20/10/2026 23.57, Eric Biggers wrote:
> > Currently, Sashiko is configured (in
> > https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml)
> > to monitor linux-crypto for patches, but not to send emails to it.
> > 
> > Would there be any objections to me opening a pull request that changes
> > it to the same setting that I set the fscrypt and fsverity lists to?
> > 
> >      ["linux-crypto@vger.kernel.org"]
> >      reply_to = ["author", "list", "recipients"]
> > 
> > That would enable emails for issues found, with reply-all.
> > 
> > (There's also a 'positive_review = "all"' setting that would enable
> > emails for positive reviews, i.e. "Sashiko has reviewed this patch and
> > found no issues. It looks great!"  But those are kind of noisy.)
> Is it possible to configure it in a way that it only sends mails if it
> really found something? ... always getting "Sashiko has reviewed this patch
> and it looks great" mails is rather annoying than helpful ...

Yes, that's what I proposed above (and it's merged now).

- Eric
