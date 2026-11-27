Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795805082;
	b=cxBCRXgv75Jje5osmClDckSfaAI0CCDED7a4CEzknNhJkYAvFd0D5ltyAyCROYRemZtN
	 ITu57JYofQO8qktMpTv3JAsa5YsfMYU3wbSF4ZvEGi8igwn65iZGqyeEucfJ83eMPhQn2
	 rBlHlyqplNUzVySrpCuH74PwljAoYXfJjy6hbSbocVLLPSy81AoLhYc/8FluKVvPqpuGg
	 x1gKf6TG93QKCL7T7blNSPPyHsCagb12Ew8dpDU9ycJDPz3CmnPErzbdbG9CKcr7pGaqs
	 Px3NZyCpJ0psNTt5n6UkfrxIoLeQJ9n2BVIcffePuRHsADyvZiekJpSfE9b8X73ChMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zTjWzbnUUC8dN1QyYk20s5zHqmG8btAZ5mtIxbCNZ00=;
	b=lxAZxH/Uo1pi5q03Aq8Q0Qu0igNAtrRDef0p0PZAJNWAHfRHhzoC5UgBTeD+ldGcKGsT
	 rqJmI72sH9knOKOcBKbOQhiRU/HZ00duERVGJyfTFSeSFfFYhoVq1WBEVdzh415eJ3bVl
	 PXeW8Af1viJpatFJ7+Fo26g0N7P/x0xfXnQ8U0bymrALhkidTiWrpPh+Nb98zED0wgu5O
	 4Z4mMBwQwhfZ1NnyE6Lv2uDubd4CqkSMr0/7snWUYRwUrnqvh8LMKrFSRAhVsAn5BpLqk
	 wxnVhiyw85nduVlAlw2Tb9PB984itkZVcOhudilTEiOhs0Rpxgl7fvgWpdoOyEgTwaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+PtFEQk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C071606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 18:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C071606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+PtFEQk
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-9213922de73so47523966d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 10:44:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795805081; cv=none;
        d=google.com; s=arc-20260327;
        b=sho3oz1nA3L8N/YLDNOhujlOMmlQV6TS8Viv0qoG4WX1r8a+4IAdi5OLLqLN+g87YY
         iJjBr5EDQXAtb87occjrBn1Eqpo4Z/qFmHXcs6TX/X8SDn/Oxh3rKsxvylEzgwlH0VT2
         bOLwyHv6+Nvh+4SbsOXcqlee5l+sneX4tV3hWwP+svaQiblLPLeeotYUhK5Q5uc6IdhY
         EqEaWOubG5wdYgdAesTdkPR1xp7ZYlCBNM8IyEUo2S/qE1ouOcL4PNLVAE7VYn2tq9tA
         ItHuCR6jWGIM3ehB4H0nw9ADv9BzjsGQmbF3GLeRcuXczH2ImHsQtwy5h7PnsvhK+YUD
         lngQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zTjWzbnUUC8dN1QyYk20s5zHqmG8btAZ5mtIxbCNZ00=;
        fh=gzXkblrxkm4e9azWWWe4jfLuolryK1gHKdKXltEKcN4=;
        b=OPypodcpyndYPRixDkfcBkhbxi9DuzUH8XWTsFEn/+LzotWOYTpPXrhEfxLIU1SNrz
         rJOztTYog2n9EJ9CQKis+HmJVZZPbQAabhObz6YTk1HQeNFFb7ayMp0FpPm+DSywaQde
         s2DGNJ6jjP06pH5dl4tqeaOqS8/GIEpyZfDeohxRchGV2Ke2kV+SXcQa5w/iwfOZYVJR
         yFQbgRYWnrraqVF7LrYa7AaYouRaZHIA9WPybWOi9dpVHvF21qxznPMuPiRSmGjiIkzI
         HyMZ3LvCbmBAX8EUvoSEgT3UvRTmKCBCUgo1IUPMsncxUEnLe15czVWvj8W2WlS4GkhR
         83Mw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795805081; x=1796409881; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zTjWzbnUUC8dN1QyYk20s5zHqmG8btAZ5mtIxbCNZ00=;
        b=S+PtFEQkyzOCD9qVC/M0fxTz3Dk6GUpnzqvJ5FAG/DeDrvmbRS6p+tQvVhkOsLppkU
         bDLbMkGr2Qs8jr0kf8bM7SFMTzuwWrtU8oLmjTBGOx4X45yr5q5JXqjD9/hpVveLOr/Y
         BDEdk3YFCLUjE1Don6vh/0rTIyHmUG3C6XL23SIrXbj5u8aWuXfs70xdVpyrdbQ4agwf
         +z4Lu1Cdq+fVVPxh0uHdP580aoXozNodSm2xFEtFJxl3rQQhSLRpG0BxXs7YEt8oIX64
         0u83jrGtqFehNdLCsGTxS1xUwHa0FZwHr4pizt1fL4vrWaHIQxSdgP+UZvLY6WrLJGA0
         pr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795805081; x=1796409881;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zTjWzbnUUC8dN1QyYk20s5zHqmG8btAZ5mtIxbCNZ00=;
        b=2YX+Tgv/1sAqPR5QBNbQpTzq3abKJsa17QBCMOBnSsh+4T6Yf7KbeLhswfbJet6aTw
         kjBTWwEIy0xN86QvlxEe1EuMJHNCd8yM/1k/LJPekkgsRZLmjHKM8SR1jkx0FCu0HFCQ
         536A5bxT+7DI0Xx3CPQQltpXkgALSxufo2XJNOcYWstgV/J100qJVUnHc1tkUusGo/OK
         hBFzqeTgD3mFpYIrbL6OxlFHofr43bavJdoXHXAxu9HfLTXS4auhs1/eNHCGczpTevNT
         AEi5PejprkIyH4nzO31dFT8W7P41x9SP0z/PElGC9X9eapnivkweN6kRacs8DOn1yPj2
         yCPg==
X-Forwarded-Encrypted: i=1; AL+hErEIVgqwN8caxlY2fV7rr6X0tHmkoFaVkVqCRWlgXIZuRFfORw2nKC/uAlNfzl5Xfhppi6PHXU7sKKjFS+k=@vger.kernel.org
X-Gm-Message-State: APuU4Z8O9NjTcnIl2Q5pPDqBRfUFAoATzFgYF69VYO6vP3+irjT1XGiB
	M+U+c6qYr1P/TkZbI45dZjJBPYSADMrn/3idqdewAvaJuL62ddgQbwxbS7+tFn/mt+bK6l3LA4q
	9WAyj6/YZN0IrC3oF3CkxVDffuZP5ctAVdkciPX9cjw==
X-Gm-Gg: AZFdTZfW57ieBzziy+n6/wiSf/MFmORHZUB4+lezJn+iUdxzdeERc2Ixzq2lPnO+ydy
	Une/P9sFYgmKgq/zDF5OfZDUty/hmToL2aE+EeIQIpxUvc6MWvTZ2l9XSfeCZnPpQpNw+D1JkVF
	DDnlC1J0mdMMzRtDITPvtetJUJ0n1JJu1WexCEVqLZTiZsywDgrX2Y3b2nnDeI646ybXl3DD8B4
	btjSPeTlAkTuu03QScH8dqwD86p1cwa/bTLKCmXIPiA1Ab5UuIsSGqSh9mtV17s/wGkcHvzkeo8
	9QdtVMsMAnbxyxcV+1fUG7/kqWaP8f7Uks9k51RDro3w4DnljAAZmPGxqU6+hL9z6DAaTI9c/wP
	p54UKWw+ywOjaOsJXMREM4NRuAM6GVhnFe517
X-Received: by 2002:a05:6214:3107:b0:921:404d:f460 with SMTP id
 6a1803df08f44-921404e1bc5mr411681906d6.23.1795805081366; Fri, 27 Nov 2026
 10:44:41 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261127041853.127855-1-artem122novak@gmail.com> <20261127184010.GA1974@quark>
In-Reply-To: <20261127184010.GA1974@quark>
From: Artem Novak <artem122novak@gmail.com>
Date: Fri, 27 Nov 2026 12:44:30 -0600
X-Gm-Features: Aa3M54rlpHYUJnbfYeC7GS2lHvHK4qXZFgCeLBOIW_h40HEFsgENFGq8tkyvopg
Message-ID: <CAPufuha3cspM+oLjtb_P0u3H0ZchD0qDR9D6Js3LEW=HACc+Rw@mail.gmail.com>
Subject: Re: [PATCH] crypto: sparc: remove trailing whitespace from AES assembly
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jason@zx2c4.com, ardb@kernel.org, stian@itx.no, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, Nov 27, 2026 at 12:40=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:>
> I don't think a single trivial whitespace cleanup like this is worth a
> commit.  (And the trailing tab here isn't new, either; it's inherited
> from the original code from 2012.)
>
> - Eric

Alright, I'll drop this change.
Artem


>
> On Thu, Nov 26, 2026 at 10:18:53PM -0600, Artem Novak wrote:
> > Remove the trailing tab after the key expansion label in
> > aes_asm.S.
> >
> > Signed-off-by: Artem Novak <artem122novak@gmail.com>
> > ---
> >  lib/crypto/sparc/aes_asm.S | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
> > index fd90b129972f..0ddf181f342e 100644
> > --- a/lib/crypto/sparc/aes_asm.S
> > +++ b/lib/crypto/sparc/aes_asm.S
> > @@ -293,7 +293,7 @@ ENTRY(aes_sparc64_key_expand)
> >       ba,pt   %xcc, 80f
> >        std    %f58, [%o1 + 0xc8]
> >
> > -1:
> > +1:
> >       /* 192-bit key expansion */
> >       ld      [%o0 + 0x10], %f4
> >       ld      [%o0 + 0x14], %f5
> > --
