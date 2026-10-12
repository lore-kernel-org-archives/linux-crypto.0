Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEC137206B
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791787439; cv=none; b=mhuhNRID8oaWe8X0JcTJAWJcR05KppGIjIUvHxWeakwW7gue2IeIVG2AW/5Nx5fQ8P8CKYrnS4fjAKGm5w1xWyq9MyUvMaPOr4CsLektTpkV1sBYLsuLArnJIeykByGIwk2Mv3bd8JFy9bRaGN5SH7qNJ5505ldu1hOsmsr7GS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791787439; c=relaxed/simple;
	bh=WvwO8Heen6gHH1/fETaLTpwy91+mtBWchDHHFWaukLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=akoVTNASwd5dXe397JCPVuWfMur8BxNYCGQmTninT4G/Ux8Kr1jY1ELUiozHu/V/emh4v5ka0P2QLLV+IvbGr5NYLXq88VzNyPIlhzs4+f7s09AuvyBnD3Ndar/V9xF1UMe9r2B2mfmnenXuzADgri7Jk1lsKBJU371kYeAOOyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxW8+Nx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxW8+Nx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE4E1F008A1
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 06:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791787438;
	bh=AiZ+K3i3XydEbQliU5imZAaF688mZtezn+fB9pQXCwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YxW8+Nx5skz6uLABXwKtvlq2Mka9YDyStii02VE/sfC+x5YJC/nJ6mRHbupufyYH/
	 zkrFY/K9AOfUpvnYd507RuzbsLhCFtJ7G4qG7RuTQNIaD43pn2akwKFHwYfEj8WOR3
	 m68RGoB/udFqRPLoSX59VjDv6Fb5gVLw0wVWLn8Wh+5W7ODecSjRsTrtukUVjM4E9i
	 HkkkiwDWR1fMnB+2I3fByKGk6L55xEUKDVcV52PpXs5IQKKQmGxUNujORt6n5BVbKF
	 gZ92wpmjjpSD2CICgVuMsmx+hZ41cMk6C7J1Y8odGtdtLtVAVkkrKzKTWw2SEvFlu4
	 Uf3IhDBCKUbUg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so181212266b.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 23:43:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx+EA0zTRqpfEnlbuGGaQLVin3qFjB3cihWa7++9P6eEZOHP1FTNVztxBHjGwDP1xf6VdNLRNs/jJ5Ajng=@vger.kernel.org
X-Gm-Message-State: AFq9FYIHfVtnTaklOI/q833L3on24JpHefCeeB/2l/7hS1ckujfeSNgp
	w6lmSPR7cG24wVONBhiA69R9G45zD9u/GFzBc1Cv818qZeIdfOXMCq97s2RGSgHwH7th1uS3aPb
	EyVRkNv3rsxAG6UJSNZie8TRvNikhg88=
X-Received: by 2002:a17:906:c110:b0:c2e:32d3:1b5 with SMTP id
 a640c23a62f3a-c31aa079e98mr742007666b.32.1791787437315; Sun, 11 Oct 2026
 23:43:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011150052.GA168780@quark> <tencent_4750F9C704AA3CFA1E7309B7@qq.com>
In-Reply-To: <tencent_4750F9C704AA3CFA1E7309B7@qq.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 12 Oct 2026 14:43:47 +0800
X-Gmail-Original-Message-ID: <CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>
X-Gm-Features: AclHuK9Vx56Shq2EC6hjhbF0Erv-m921g-ZeXyaEjehh6i5ThvU9fcIhErAA96Y
Message-ID: <CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib/crc: loongarch: Use hardware unaligned load in
 CRC32(C) loops
To: Wentao Guan <guanwentao@uniontech.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Huacai Chen <chenhuacai@loongson.cn>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, loongarch <loongarch@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Tianyang Zhang <zhangtianyang@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Eric and Wentao,

On Sun, Oct 11, 2026 at 11:14=E2=80=AFPM Wentao Guan <guanwentao@uniontech.=
com> wrote:
>
> > On Sun, Oct 11, 2026 at 10:29:29PM +0800, Huacai Chen wrote:
> > > +static inline u32 get_le32(const void *p)
> > > +{
> > > + if (static_branch_likely(&have_ual))
> > > + return *((__le32 *)p);
> > > + else
> > > + return get_unaligned_le32(p);
> > > +}
> >
> > No, this is just broken.  The bare misaligned access is undefined
> > behavior in C.  Also, every other use of {get,put}_unaligned_* in the
> > kernel would need this; it is not specific to the CRC code.  Also, it i=
s
> Right, I got your thought. It not belong to CRC level.
>
> > inefficient to compile both code paths into the binary.
> >
> > The only way that realistically works, as we know from the other
> > architectures, is for the unaligned access support to be known at
> > compile time, and to have {get,put}_unaligned_* do the right thing
> > accordingly.
> So the optimize it can be move to {get,put}_unaligned_* code?
Yes, we considered modifying {get,put}_unaligned_* globally. But it is
not arch-specific code and we have no way to override it.

On the other hand, the byte-to-byte {get,put}_unaligned_* is always
correct, we are free to only optimise the hot path (like crc32 code).

>
> >
> > Since loongarch made the incorrect decision to not specify unaligned
> > access unconditionally, similar to RISC-V it can be worked around only
> > by overriding that in the kconfig.  For loongarch that appears that
> > already be implemented; just unset CONFIG_ARCH_STRICT_ALIGN when you
> > know the kernel will run only on CPUs that have fixed this bug.
> I think that we have the use cases to provide the general kernel instead =
of the two kernel with
> different config, so the image increase will be tolerated.
Yes, the default configuration is to keep CONFIG_ARCH_STRICT_ALIGN set
for single kernel binary.

Huacai

>
> BRs
> Wentao Guan
