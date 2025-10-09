Received: from mail-24424.protonmail.ch (mail-24424.protonmail.ch [109.224.244.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E061E492A
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 04:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759984548; cv=none; b=JsiXelqL8Ta1XOPnGfzU3IT8jpxWU21vIEqAush64d8UjZ1huRzSrYlAOC8eNb/Dr24rPLDHhrNw9yh1Erb0PQEAhWkWhWmGf99lQYNRrttQ14YkaQXuqSZ18JMJAqOYHb2dKQh7L3I1kjIzUSWQ0f4OTqzcbbSQqg+NSy52JF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759984548; c=relaxed/simple;
	bh=h2tIPvXtIjUkWW8Si/LxYhExw6Ya/TkaTmizQ7XGhoc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Aoth7xrwHqdPJtgrYUQ9uqE1u9YovohgvrEU08a/YC4O7Q07YPpOy/IOy8UoI2+jfiOhy6AATOfNic6SP+9iM0ViwCRK8PE4+UfjCgtjlPfHghk6oaa1EhGzlmjE8yiJoVcykJqFAc8mJZJNglhxfB485YiSXcWNXrdOz/Uc2fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=CUsThzE3; arc=none smtp.client-ip=109.224.244.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="CUsThzE3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1759984542; x=1760243742;
	bh=LGSEpgA+aW6Ym+pdPVcBCxcRwaJErMHlI/EoFe4xgOk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=CUsThzE3FT7+fLrxaRK1E2bhkm5g4zmNEuSYeooPeO0YvixfGT6QBp2x4zi7cvWGr
	 jrjFTZ8nytr++P6oWo9aUvuGvewp+WJ16Hdp4HT0dAmUlrZVVhKOr8EFMx3MJbe/Zo
	 nvwxAA4i47A6+wj4A+SjUnT6io401I+IQv6w31Xwk3A51rIOC3wkB1sANBx+SFccUT
	 WZvWpx+DNeKi4ZPmJz/otvxXjNAfKu5aT0/4ilDt7jHhoYsomEbT3dMBKcGPphgfLC
	 cR9z3+hwEDdUsQ14689L/DhmUBruIGf9e5oKqY/2vra0fGV5gZRqqrYw6r/mN9nsbX
	 sQSYyBDueJO+Q==
Date: Thu, 09 Oct 2025 04:35:36 +0000
To: Ard Biesheuvel <ardb+git@google.com>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "ebiggers@kernel.org" <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 20/21] arm64/fpu: Enforce task-context only for generic kernel mode FPU
Message-ID: <lEQKYlJspHGzmd8DyuKKcpZege3zgX8WlhnHUM044EmEhtaElIqZrX-cZ5ApNx9ylcn8fS1JjzCPcmEP72WXnn4H0JrsFYge3Jba-YngKrs=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: d081bbc03fb51d4975836091df950ebb6c33e6f2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ard Biesheuvel wrote:
> So enforce that kernel_fpu_begin() can only be called from task context,
> and [redundantly] disable preemption. This removes the need for users of
> this API to provide a kernel mode FP/SIMD state after a future patch
> that makes that compulsory for preemptible task context.
[snip]
> --- a/arch/arm64/include/asm/fpu.h
> +++ b/arch/arm64/include/asm/fpu.h
[snip]
> +static inline void kernel_fpu_begin(void)
> +{
> +     BUG_ON(!in_task());
> +     preempt_disable();
                ^^^^^^^------this looks okay
> +     kernel_neon_begin();
> +}
> +
> +static inline void kernel_fpu_end(void)
> +{
> +     kernel_neon_end();
> +     preempt_disable();
                ^^^^^^^------this looks wrong
> +}
=20
Maybe that second one should be preempt_enable()

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

