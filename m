Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26418C06;
	Thu,  5 Jun 2025 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749150123; cv=none; b=UyzVTWwNxoSVS7xNtGwzJlTiARX+WrFDR9jxBS1Sx6arNdfM4Zp8Mkn+qofGytojum8DA3H1WJKOsBXoctbwzUrQ5gKzoI1Bp70GajoQBh++JiFv1hP62r92zxzHc8tD0J0hrBL4dqyTzWAa38IWlruOjeqQcnTWnVD1G8I8nSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749150123; c=relaxed/simple;
	bh=XxRokW+/dMt7qLnii6MRmLb2sBIeInQb0EjwzLaQ6XM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iVWXB9kDfeE8mCVi0Yg5HM42k564sQj/16bzfKocGFCY4OguzA7BMi97eYb68kO4UVKm5FnhxraQq/tqQDe/+M3Bf/1DurCGK4kjzKsSEyhmOgerJpRGMnVPopSkrRl1l76zdonb6SMBCTHG3BlFuFKHbTzloYikNU3cD4HdEEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQeAIbDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQeAIbDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594AC4CEF0;
	Thu,  5 Jun 2025 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749150123;
	bh=XxRokW+/dMt7qLnii6MRmLb2sBIeInQb0EjwzLaQ6XM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nQeAIbDk+/4ttpiRtXz0crVvMV9eDiCs//fqxZWvnsYIi9xLHxxqX6P5tyjQwJ0df
	 56/a5IddYokcCEeo2KW62Ti/2TVNCY9bmfMqGeNybTqSwcL9iM+luJE69TsDZVahK1
	 JS0pNkZcCBCsR7PH7/jFNYtJ5JBL8b5Thahg7faM8dl+MkacBtejtCV/jCSg3QqVQD
	 rLrFn6dY0sqLZ8HjJ478lX+72T7XdkoO66ZecY1pHvStsymrmI0wWp3sIGtYiGutDJ
	 ksCfsaV8nmlGjTO6FToFddMPcblZrr2W6tUfGnoP3la2jzf3Jc8usakEeyzU8fe0je
	 llrQMnDutD/gQ==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-551fe46934eso1530666e87.1;
        Thu, 05 Jun 2025 12:02:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXLI7/RMnCz/p2bBxQbkdlviVmTYsNoJL6Vex37Vw3oI/VYDegj3iXKKsnpb06YHZr6N+Z1dGsfaSeO7UoF@vger.kernel.org, AJvYcCXfzxQKnATx+gzQl63YfQejQgUs8omHBx3SWLUYgnmvCbujwDg2sn8r7JHjqhPYcHh0hOKmau+HYfV2Pf8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl+4nxe4QcnxMS9/2jcYRTaDaaBCKXRDXGgyU2Z4WdU1lB6dHG
	DpQbe2CrvptxpeqIY+T8xzapAKO+GNq7stL5ZafI15/6HDNZk1O3RDuwPMTzLGqQp1CNvpMt2Fo
	0F7C6MyfklTESTkgq88vhCZBE2qJaeZs=
X-Google-Smtp-Source: AGHT+IETGFT/vOPMFADytAvc9wAfTaXnwRrLijKbq4AborxlFJh7XrLda3pqY6aqBVVHFFv1brU4NJ5haKIj1ie1apk=
X-Received: by 2002:a05:6512:4025:b0:54e:780f:3074 with SMTP id
 2adb3069b0e04-55366be73fdmr69396e87.8.1749150121548; Thu, 05 Jun 2025
 12:02:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605171156.2383-1-ebiggers@kernel.org> <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
 <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
 <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com> <CAHmME9qE-gihY9XK0nNnRY+mHeTNNgn1qi1E7xCKJACFz-uqDg@mail.gmail.com>
In-Reply-To: <CAHmME9qE-gihY9XK0nNnRY+mHeTNNgn1qi1E7xCKJACFz-uqDg@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 5 Jun 2025 21:01:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHthZYSrZzUEkMzjO+Jwy2LA4WUCCBosScX3P8FAPn1yQ@mail.gmail.com>
X-Gm-Features: AX0GCFtQY_SejFzjSP_ShcwJjUdFWSmSivNCuBFfayQgHNKDIi8BiBMuP5wFWqk
Message-ID: <CAMj1kXHthZYSrZzUEkMzjO+Jwy2LA4WUCCBosScX3P8FAPn1yQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jun 2025 at 20:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Jun 5, 2025 at 8:45=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Should I just add you and Jason directly as 'M:' entries for this?
>
> Works for me.

Sure.
