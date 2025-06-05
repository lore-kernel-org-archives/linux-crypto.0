Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5918A6AE;
	Thu,  5 Jun 2025 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749149010; cv=none; b=f8hFFyuIafUhagAfa9DRyQmQJEa0rKa28sPepVBlh1wNhhnkDJT1EXqPdwpXyTdEPgw5YpZ/EF5sR7bTdlQe/FxzJ6whJMvNbytoGgjyBkSPilvv8vouoNfxgOVlFFagJ3N60cHmxeQUVYvx3def5zICUJyZfHVbHrQx0OwoEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749149010; c=relaxed/simple;
	bh=u9gzUFCKidEumaUnvbV5RzzYgOucfFD0dUvCo3IU0A0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mGy3YLbDHpPmrc67pUCgYsegpgPfmrYvioH9xNkRDNpFYeMSJ3YRHpa1aLJX5m3jmFp40Pc0y5mioWieNN6WUAENK+ydv0UKoOd8rBOBWDxp+tqQ/RiE0AGRfn6Wlz72jDY+pihm1Qeah6CUPB32i0kcpyrA/gi4La7W9Sj9qUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7WsMaw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7WsMaw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A6EC4CEE7;
	Thu,  5 Jun 2025 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749149010;
	bh=u9gzUFCKidEumaUnvbV5RzzYgOucfFD0dUvCo3IU0A0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O7WsMaw6n2SYGvDgKirT6Se3MQZqwdbCxXKXYlfkCgIEwDOS00llkp+st6548UO3z
	 dQjOlbxEQn7mlICiAZpvsTPZvYIfogfZLlLXE7DajISuuk77CZ+v/b1bctQqocIWlH
	 Kbibh2toGVfhyTUxB2J/5UQAe991/txTiKn3ANYJBYzmHZeswPDYQa6mOX/OBGdyBt
	 CEc/MboNsP0BbbDN/WZowmgKqJPozNWkVfYbgFHYdnQr29hriciwxJvjlqOzhVpgD8
	 pDKYW7BUyFoHXHiluUDFidZeeonJtTOItTC6XnjPVHfAPTHiMxm+btGn9Eo3kWI2ah
	 ccBFd9OWSkLaQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55220699ba8so1621619e87.2;
        Thu, 05 Jun 2025 11:43:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWSlgzoFaJsTxXatF+unv8RcWo3NHd8MJlLLIqglMoXMPhjVFt002cJJr66Nxa7afmeTNDixyx4WlpcYfXy@vger.kernel.org, AJvYcCWTIrk7or02mUU1phHNJm5Pw43eDbDEQAlsOcrZslpjmzUavkDquPkDYuNV5mBuoFpiu/Kr4wP+zH5Do5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCDCc8+VDhiDU5oyyeuQGJkQh48deBjrwMiQCIlhDMGc/kzrIx
	t2l/L5/cdUaesIhejl8igLRQxaIRpHBFxFJNXvvgCvLa5yjqzN5sGK+Z1M4LNH7b5s847VpqtQl
	oS47wTKdWXwstuEBdMqvXVfA5zOWsP/Q=
X-Google-Smtp-Source: AGHT+IEj/lNS69htILOnltpFsRm0fGjR8uOD+7RLm/EOY7Qh/1jajcJoqwRpI/Y2Vh2cHwLyE2HsOc0lVszxsfwYn6c=
X-Received: by 2002:a05:6512:2251:b0:553:50c9:c8a8 with SMTP id
 2adb3069b0e04-55366c31309mr57603e87.48.1749149008473; Thu, 05 Jun 2025
 11:43:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605171156.2383-1-ebiggers@kernel.org> <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
In-Reply-To: <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 5 Jun 2025 20:43:17 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
X-Gm-Features: AX0GCFtxoamIsfTa6xWkMwMqc-CT2LH7_XTprX0ZZ5bzE0P2lw7igeOX3RpV-4A
Message-ID: <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jun 2025 at 20:12, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Jun 5, 2025 at 7:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > I am volunteering to maintain the kernel's crypto library code.
>
> Lord, please, yes!
>
>     Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> And if you'd like a co-maintainer, obviously I've been quite
> enthusiastic about the whole librarification thing for quite some
> time...
>

I agree.

  Acked-by: Ard Biesheuvel <ardb@kernel.org>

Happy to help out as well.
