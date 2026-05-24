Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7F2FE060;
	Sun, 24 May 2026 23:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666207; cv=none; b=fDltaYfi4a/m3JKeOw7uds2b6GaPeVkfRdEjWyp6DuNc3gOB1W7kB8A76EPXkAnrX+295X1UH12gp62fKouLNbNeY+VYi1Rwr3Dw7kV7a21le+Stdp9/YSSA3JSuIZlrRzdiBUbTcE6pyZ3L3KAnyKRW4QYaM7i9Hstzg6WvDA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666207; c=relaxed/simple;
	bh=VOmEuoqj1QUiQHRcFyD2vyoILB4OVqxCbqJRFJ4a65k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRpvVBjXHy/cLsYTbBKumpXDNfoZaonzdUNNB6Pr08povaw8iq0MAAeiiZEGpHlBUqWFkwakyABqRFAGb/JWViaoICN4f3Z8CsG0o2Tc2X81y8fI6eJAE+SmmnofSG0tQ5MVx688M6bY7BX2R0QwLKrIVw9odQDmyKwVKooaRQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyXFgO6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyXFgO6S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D0A3A1F000E9;
	Sun, 24 May 2026 23:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779666206;
	bh=4sOyiLRAJhl9sAFTpmyEnymyYch14BKVOAXeJ1tQ6aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lyXFgO6S5Gh7biB5sBEb3niyyTwrPanLaytjF3N7j9CHWLqNYgqnO7qCshElmu/HH
	 6Y5auQUrL9F6KptUoX2A+Nkrznnn7uUxVy3mfbDitJaYnYUW2TbqptuszhQ2dTObHm
	 LmQcEk4OkwRU54MkO/jPf+XWSqt5yXU0p0uMG1jjx5T4r6vYf8r8gMqm54EecypArW
	 6eUgNG7gnR4ZfKq8qXYdkkIsnZw5bYY4laxUdY/UtijvSD/cBS3hvr++5piQ7wP4PJ
	 TEYDftW26jsmIEyO9dWHIf65CzFlXl/o9aD2A+fCrSBmeZKG1XQLW4stGMivWLWX2x
	 hC0K56haUc9eQ==
Date: Mon, 25 May 2026 02:43:22 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/3]
Message-ID: <ahONGtGQkrOYlunW@kernel.org>
References: <20260524051519.3708075-1-jarkko@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260524051519.3708075-1-jarkko@kernel.org>

On Sun, May 24, 2026 at 08:15:11AM +0300, Jarkko Sakkinen wrote:
> This series introduces key type for operating with asymmetric keys using
> a TPM2 chip.

This would deserve more explanation but the original trait was to
implement TPM2 parts of:

https://datatracker.ietf.org/doc/draft-woodhouse-cert-best-practice/00/

What motivated me to reiterate are actually these coding agents and how
all secrets are sprayed across the home directory. So, besides iwd one
could  use this feature to provide per-session cryptography for coding
agents.

There's a lot to do with security and coding agents as we have literally
moved to an era where we host indeterministically rogues software in our
development workstations.

There's other questions too that we need to eventually answer like for
instace, how to deal with persistent agent memory stored at the
computer's hard drive?

The irony here is that LLM is really neither rogue nor a lier. It is
just a text predictor optimizing for maximum reward and those
descriptions are just human interpretations of the output text. It
understand neither evil, lying nor quality for that matter ;-)

BR, Jarkko
 
