Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5DA1CFB6
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720913510; cv=none; b=atT7ESv63kttN3sW6yyP1uCDzut04bph6HIR4/lT0coAyEhD4gCEyEqNmRW/HZp9fjokij1avW8yjloaCN4riKoe/asKHzfSbaPBdQGvTT+UTAp8VNJyGb26Ohp+8fC1mA/K08BMnHAkbeA4gmwbT6hU/bSK60oSps9KR9Sjh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720913510; c=relaxed/simple;
	bh=eVFEoOTA3jQhAnpW7CLCZNiw6dOfk2HFXadutNB8z0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fk/52PV1MxWxTZcIMJUpNBXSrjgvOFWPf+WMYfqmLp91Leq3KaZeteIvYZaT88hH7/WxgTBm+gESvQaIyZihZfQdYpxNo5/M3EHCA2BjqQEmlr+b5tc1i7Xxxd9PcI3uizwUS8LcmFI+zz6hJ4TjOwCYYxscTg4h7lg6yXwcZS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZchoLthb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZchoLthb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486CCC32781;
	Sat, 13 Jul 2024 23:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720913509;
	bh=eVFEoOTA3jQhAnpW7CLCZNiw6dOfk2HFXadutNB8z0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZchoLthbYEU8k0kATJd+0DTo28PkHue0w7pZP8lG6srsHJf7TiMysnaTCa5Vr61+J
	 tCJ0BMg3RzThect0Mt6p6VjwLDGYBWGfZmgPyFz9Fk1+VFzaY1uV8c52hs8Vb74Daz
	 F6rfHBvr1RW38C7SbPTXnBA1kNDQCf3Y9MnfI/l7+XxA9hA930VNzoSDK6EhuXi7mX
	 32RJogBXZ2jSCusQpGbu1/BxQJLqDWZXyHa8cBfeN74LNCWpqUS98k0oaDn6Rxklr6
	 1oe8fqe19r22HohtW87hErWOMEoWOAclvsHobGfq+MIcXjzWGaRa38Ldx9k2PKnpBU
	 IRquEb/Th8usg==
Date: Sat, 13 Jul 2024 16:31:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: flyingpenghao@gmail.com, Arnd Bergmann <arnd@arndb.de>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Subject: Re: [PATCH] crypto/ecc: increase frame warning limit
Message-ID: <20240713233147.GB443207@thelio-3990X>
References: <20240712113656.30422-1-flyingpeng@tencent.com>
 <CAMj1kXGDc6ix0YDcwMj9-DJhKp73oZL60afZFxrVoWvjVx3KPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGDc6ix0YDcwMj9-DJhKp73oZL60afZFxrVoWvjVx3KPw@mail.gmail.com>

Hi Ard,

On Sat, Jul 13, 2024 at 12:23:24PM +0200, Ard Biesheuvel wrote:
> On Fri, 12 Jul 2024 at 13:37, <flyingpenghao@gmail.com> wrote:
> >
> > From: Peng Hao <flyingpeng@tencent.com>
> >
> > When building kernel with clang, which will typically
> > have sanitizers enabled, there is a warning about a large stack frame.
> >
> > crypto/ecc.c:1129:13: error: stack frame size (2136) exceeds limit (2048) in 'ecc_point_double_jacobian' [-Werror,-Wframe-larger-than]
> > static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
> >             ^
> >
> > Since many arrays are defined in ecc_point_double_jacobian, they occupy a
> > lot of stack space, but are difficult to adjust. just increase the limit
> > for configurations that have KASAN or KCSAN enabled.
> >
> > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > ---
> >  crypto/Makefile | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/crypto/Makefile b/crypto/Makefile
> > index edbbaa3ffef5..ab7bebaa7218 100644
> > --- a/crypto/Makefile
> > +++ b/crypto/Makefile
> > @@ -190,6 +190,12 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
> >  obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
> >  obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
> >
> > +ifneq ($(CONFIG_FRAME_WARN),0)
> > +ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
> > +CFLAGS_ecc.o = -Wframe-larger-than=2776
> > +endif
> > +endif
> > +
> 
> I don't think this is an acceptable workaround - this applies to all
> functions in the file, which call into each other as well.

Agreed, as I stated on a review of another patch this same submitter
sent for a similar warning in infiniband:

https://lore.kernel.org/20240709212608.GA1649561@thelio-3990X/

Unfortunately, this appears to be getting copy and pasted from AMDGPU,
which needed it for their horrible DCN code that comes from some other
upstream source.

> It would be better if we could figure out why the stack blows up like
> this on clang, which could be related to inlining behavior or other
> compiler heuristics that prevent stack allocations from being reused.

I asked for further details like configuration in my second message in
that thread and it never materialized:

https://lore.kernel.org/20240709212608.GA1649561@thelio-3990X/

I suspect this might just be a KASAN_STACK warning, which is known to
generate high stack usage warnings (as noted in the Kconfig text),we
will have to wait for confirmation:

https://github.com/ClangBuiltLinux/linux/issues/39

Cheers,
Nathan
