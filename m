Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033700;
	b=R29YlkqZ7Fx+2Fa7oktfKhVHafPDOjrEQSI9iUt6JoNbeM2ai8jCgRz68r3EXw8GYh+t
	 WflO3aAhH92lTm6cshiR8gYIbFI2tEvUOvIQq3HYcY29oCWEKW/KLDukp4BBqRAa2241h
	 6dtq0fidsZlqDCH5m4UNmXS5onmx24WWosjjJULydtfijuRWlzlo4DTltPNTDJcM4Ef+1
	 Yc3WmuEUtQojo8F5u4S0Rfy8c+hV07Yqt6NPXB/BvXfN5aPrlgDblvm4bTJAT7z7YnPBf
	 zFZjpbB0rvqjUn7j2x/ghF5jDkiiIvv4hIyiVRnlKRsjgPGKhfvZFduRKPfUnGiY8Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033700;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=90tAbqMzJaQia7XfxJtfvbD0HtWu+CPWAaXAGRp0tI0=;
	b=eSxZsu+b/rtflfLLzeHw3EWO2dqnjau6vbdIF0NrtYvK5of2sUcmzNHvE4M0qYy9FYyE
	 sdCLoWQ3mWzCBBaWO2TrhdJZTkG2Oe4uCWuTCa3OOZPL7NJAgbfc+nANfMcMUUcpD14Nc
	 YmsiZ76In5kBhgiEFQjF8ICUBQbaUrAlwu5tbO3bodRGQm4wVxecGgWz1AaRGXy3F8rRD
	 OdD8OGeueAZM8Bjj6Kfu8PMRN0px+0zBGLcdOljG/09CgN0RHyikZfqxpTLh3DJw2t0fC
	 9CVLLgbK7ml3lUX7hnDTeihQ7PHWasZNvMw+GezHVT76iHcXiwc06rH76Yxi8u0YAOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VrhzcSDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D4E9F606A320;
	Wed, 18 Nov 2026 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VrhzcSDi
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B5521F000C4;
	Wed, 18 Nov 2026 20:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033700;
	bh=90tAbqMzJaQia7XfxJtfvbD0HtWu+CPWAaXAGRp0tI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VrhzcSDiurSe9ldgs2udIVaBrSIngIZY5+J7rZn/0s4/XzvcBKsorRzq2WWQW1CNY
	 u8ARLcNfd0cl3AMLg239pXxuZjbzQtaabTPQkk+cbn1vePA8i9ZB5laJJCqlSPdvFx
	 v1tX0CMNV+NlkcviWgBYN7koZAfiYUefuorAglHAnxdE751ZwnSe7gYIIsAbQSwLTQ
	 NkYapB5um7nefemtlSVuqJ3HkD9gz8hUe52NtXZKKUrlBpUq4zh99CXvM8T1ly5djN
	 tkWNZdxSYjkH85Fagx1MNjrsqvw1ov4vJlnVo/YndXiguh/cwuvuCJYhjdzsGZDJk7
	 q1g3+CHj1u6lg==
Date: Wed, 18 Nov 2026 22:28:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: florian.bauckholt@cispa.de, David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <av4KYKy7pZHyErVs@kernel.org>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
 <f38f6d32-16d3-4986-8d6a-9d65517f5317@linux.ibm.com>
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
In-Reply-To: <f38f6d32-16d3-4986-8d6a-9d65517f5317@linux.ibm.com>

On Wed, Nov 18, 2026 at 03:08:19PM -0500, Stefan Berger wrote:
> 
> 
> On 11/11/26 10:56 AM, Florian Bauckholt via B4 Relay wrote:
> > From: Florian Bauckholt <florian.bauckholt@cispa.de>
> > 
> > Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> > made keyctl_pkey_params_get_2() set params->out_len to the maximum
> > output size of the operation instead of the size provided by the caller.
> > It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> > buffer: out_len shares a union with in2_len, the length of the
> > signature.
> > 
> > As a result keyctl_pkey_verify() ignores the signature length passed by
> > the caller. It copies max_sig_size bytes from the signature pointer and
> > passes max_sig_size as the signature size to the verification.
> > 
> > This makes no difference for signatures that are always max_sig_size
> > bytes long, such as RSA. A shorter signature, e.g. a DER-encoded ECDSA
> > signature, is followed by whatever is behind it in the caller's memory,
> > or the call fails with -EFAULT if that memory is not readable. The
> > x962 ECDSA template currently ignores data following the signature,
> > which hides the problem.
> > 
> > Use the length provided by the caller, which has already been checked
> > against max_sig_size.
> > 
> > Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> > Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>

Can these patches be rebased? They don't apply.

I've probably missed b4 shazam issue last time.

Was just wondering why I don't have these yet.

Br, Jarkko
