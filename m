Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794976575;
	b=nD7j8Bga4nF2vPbtSbOCNRIWc/2JLsDyZRj5eGmKsPPXbpVnWi0sCeRpXXMN96XNz5sD
	 LdSVAXRiVhTQ68fit0R5xGj6yAZxTGW1OLmA2u6ykwKAIl1dEh55r+qhSZ3g5xPhEdSBJ
	 X+sndqghCOk0x6/CAyYBrFiuCI0zKjluvHrUtU5gnJDd11yu/Xyzicns971OFjLVyStfm
	 aH4eNwJlpPNtNyh/3PkbmBXVFBvXoOGklFYmayZES4ruu/dcosDPgECjlbmqfthHcsqAm
	 RByBxv61weTW5KVyGAotFVnqGB7+csXHMoCOVLjywEGXlk8kLUkMfl3qHuITEHQGH0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976575;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lxTa2Po3QPuoZYXxjHOakVrPpe9+UdOu0Xf9/tl2qe8=;
	b=0J1BVjIc6CGYV8fmc5D8ckj2/Lbt5hqHoV+uWLFG7Rc/FIefU4btgNAvPnwpbRwZh+Mq
	 fbr/ym7O9I5nQcJkrQAUc22nWaM9Jpsbr/6rCrX+b2JSfkKjxUIuaLdRKv7JFU6RmsWEv
	 39+IaxWluUnvVEwzIoC3BkqGIz1ec2BHt08dh1/6kYGd6Wpv3PUsEfWDAx5n7EGUbrk9h
	 V09og0RbqIe8bpcJMUn8Tyh+9znFKADYDREWhreLOxbUjiWRkSvnZojCZvWDUqNTuNObE
	 G94Qg+hc0pJDvaC5RhSiBUH+ga/v+oPHcie0pSwauWBVg9Bt6z0VYfcM1cCzCLGU+uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SwXNBwas;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9890606A31C;
	Wed, 18 Nov 2026 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SwXNBwas
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21F1F000C4;
	Wed, 18 Nov 2026 04:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794976575;
	bh=lxTa2Po3QPuoZYXxjHOakVrPpe9+UdOu0Xf9/tl2qe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SwXNBwasryayXUYT36pmT6cjuryMq2TJL08Fc2UZvaLaNm6EmR3CT5l1xIuG5RyOm
	 IoLXauBm1S3b/A57EpDPO+YGYgiVnPjqDjBz8LRVHx5yZcksSv+KHWGsFcn64pINYV
	 8O1rghu+P4vrwZlQ1wOvv5uKHiamxHgGYJhNxwaDW5QoT04DANsu5r7UHJyyLMpvES
	 zgpLoWtbmWN2+3tAdTs696wanmfm0fEjVt9aKmRl5/WvLAgZ2JHGq1xDFck3hQ0Tut
	 qb105Tqq58Q9F6HpVNPwWuZv0zKejGUh/Faygw3A2MqgFAdXBNnr71Pdj+qIBqgnlu
	 ZaZ41eBC1XTOw==
Message-ID: <sashiko-outbox-220115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 12/12] unwind: arm64: use .lr_unwind to unwind
 interrupt frames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dylan Hatch" <dylanbhatch@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Weinan Liu" <wnliu@google.com>, "Jens
 Remus" <jremus@linux.ibm.com>, linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Indu Bhagat" <ibhagatgnu@gmail.com>, "Prasanna
 Kumar T S M" <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org
In-Reply-To: <20261117043504.1021063-13-dylanbhatch@google.com>
References: <20261117043504.1021063-1-dylanbhatch@google.com>
 <20261117043504.1021063-13-dylanbhatch@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 04:36:14 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] arm64: stacktrace: broken unwind of synthetic pt_regs in
  kunwind_next()
--

commit 68ea7139e10984e52da92dcf88b763bce8dfdff8
Author: Dylan Hatch <dylanbhatch@google.com>

unwind: arm64: use .lr_unwind to unwind interrupt frames

This commit adds kunwind_next_regs_lr_unwind() to unwind across pt_regs
exception boundaries using .lr_unwind metadata, falling back to
frame-pointer unwinding and marking the stacktrace unreliable on failure.

> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrac=
e.c
> index 3ebcf8c53fb04..842555a4a3fe2 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c

[ ... ]

> @@ -244,6 +249,65 @@ kunwind_next_frame_record(struct kunwind_state *stat=
e)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_ARM64_LR_UNWIND
> +
> +/*
> + * Unwind from a pt_regs according to .lr_unwind info.
> + */
> +static __always_inline int
> +kunwind_next_regs_lr_unwind(struct kunwind_state *state)
> +{
> +	struct pt_regs *regs =3D state->regs;
> +	enum lr_unwind_mode mode;
> +	unsigned int sp_off;
> +	unsigned long fp;
> +	int err;
> +
> +	if (WARN_ON_ONCE(state->source !=3D KUNWIND_SOURCE_REGS_PC))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(!regs))
> +		return -EINVAL;
> +
> +	state->regs =3D NULL;
> +
> +	err =3D lr_unwind_find(state->common.pc, &mode, &sp_off);
> +	if (err) {
> +		/* Fallback to FP based unwinder */
> +		state->unreliable =3D true;
> +		return kunwind_next_frame_record(state);
> +	}
> +
> +	switch (mode) {
> +	case LR_UNWIND_LIVE:
> +		if (state->common.fp & 0x7)
> +			return -EINVAL;
> +		state->common.pc =3D regs->regs[30];
> +		state->source =3D KUNWIND_SOURCE_REGS_LR;
> +		return 0;
> +	case LR_UNWIND_FP:
> +		return kunwind_next_frame_record(state);\n> +	case LR_UNWIND_SP:
> +		if (check_add_overflow(regs->sp, (unsigned long)sp_off, &fp))
> +			return -EINVAL;
> +		state->common.fp =3D fp;
> +		return kunwind_next_frame_record(state);

[Severity: High]
Does kunwind_next_regs_lr_unwind() mis-unwind synthetic pt_regs passed via
arch_stack_walk() -> kunwind_init_from_regs()?

kunwind_init_from_regs() sets state->source =3D KUNWIND_SOURCE_REGS_PC for
any caller-supplied pt_regs, not just on-stack exception frames.  Software
perf events, tracepoints, and BPF stack helpers pass a pt_regs filled by
perf_arch_fetch_caller_regs():

arch/arm64/include/asm/perf_event.h:perf_arch_fetch_caller_regs() {
	(regs)->pc =3D (__ip);    \
	(regs)->regs[29] =3D (unsigned long) __builtin_frame_address(0); \
	(regs)->sp =3D current_stack_pointer; \
	(regs)->pstate =3D PSR_MODE_EL1h;	\
}

Here regs->pc is CALLER_ADDR0 (in the caller frame), while regs->sp and
regs->regs[29] belong to the inner frame and regs->regs[30] is unset.
When lr_unwind_find(regs->pc) returns LR_UNWIND_SP, adding the caller's
sp_off to the inner frame's regs->sp points state->common.fp into the
middle of the stack frame, causing kunwind_next_frame_record() to treat
arbitrary stack words as {fp, lr} (leaking stack contents into perf or BPF
callchains or hitting WARN_ON_ONCE(tsk =3D=3D current) in
kunwind_next_frame_record_meta() if both words are zero).

Similarly, arch_ftrace_fill_perf_regs() leaves regs->regs[30] unset (so
LR_UNWIND_LIVE at fentry sets pc to 0 and drops the caller frame) and at
fexit copies an uninitialized fregs->sp from return_to_handler into
regs->sp.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117043504.1021=
063-1-dylanbhatch@google.com?part=3D12
