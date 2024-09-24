Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F1A84A3E;
	Tue, 24 Sep 2024 07:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727161946; cv=none; b=rlvb9EQ+w6c0tmUbpYPAjMBMi+L1bctpWLAjuL5n1wAJ0Npnli+z/KGTBAl3/sP7ZiUMFaiPui2sVje8T9hM7Ip9G7K2hX4vOBdRphU4TyFtN5tQOebnEMKpuMB8rUJOHPbrqMEHPtC57k97OJdhWQWdx3RmCZKTZwNBJMb5zjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727161946; c=relaxed/simple;
	bh=odpEEdkbCbe9L+HLJkxfdzxxlD6QYySuZAMQL5T9aaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbtaPfvkYKViiq1tuK/8V7yWVh3laCEldI0s9Tnmy2AGloAWN9YKaDGk9NsksPYWYWCAm2+vuwzHBOy4fW75gcyXTq8+DR4Sj09CFhVy/IOnboHhpFujxYsP936F6FJYCgnehBHlIJ922x/nK4UQ7fK++Eto7gFE7XBZIE5kGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJoY7Og5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJoY7Og5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2F3C4CED1;
	Tue, 24 Sep 2024 07:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727161946;
	bh=odpEEdkbCbe9L+HLJkxfdzxxlD6QYySuZAMQL5T9aaY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fJoY7Og5B/yc51XOlC9Cj2eEbVAGNsFzyztP9FCgEswCojEFvruGfcTwmxN+nqfbd
	 udQ/H5Vkhy7SklpQBH+wmBaNQqurCle4/3jcLkICBfUYR9Lvyo6F8asn3nJpJyZGrj
	 6oyQpNCB01G6WjLze+DcIozYwQyJNWfu9ZtHU1TI08+8YZJhchs5hQDKgFKMgfELIg
	 Ydn6RPujMfMtmMPCDEzqvi688W8Hhk5suJAuH3rZv4R4VOGXpEi+jRMLLVP9ieqU2J
	 BFNlMu8OLT/AfwtMOSYHZcN42xFK5rhv8FWdD19Ew5glBsdykp7/mtsdJmfLkNQygf
	 2WM7nkPt+k4fA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5365c512b00so6146467e87.3;
        Tue, 24 Sep 2024 00:12:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUsVaGksIlFJ76n2e0o//THgvTrrBlU0+K+VggsaSn6AKG/yDRhnG4qGtYZJ7ABKMEpaNiODJReiZXFSBQ=@vger.kernel.org, AJvYcCVBImAFUiKc6kzJ9w+1DtykISNZAIwJpMPp+Axj77l4dBIaQH2hWVBH0wKWrKGtCco9W+1wt9o5QsNqZ9Wm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9IK2iybh4pwNNx6XV7lXz2lEv+SrE+LCqZnh/AfsIEoRnCm9j
	c6QOtZAh6XvV/9oS85+wkFk/tuXKwB9M67ggG7eW72cBxLv1U/DtFA7J5tCgAc5Wx1BG7sFt9OG
	4Yf6Bw7tqk8UICFc6hBgEKwcWEro=
X-Google-Smtp-Source: AGHT+IH/dUwV4LEcLPyeJ+21mBsE7rrtW1nyiTymOC/tMLvSpXC2dXArmXNw04XA4nMxOGY9JuhnMiBurWENoAJoAZU=
X-Received: by 2002:a05:6512:acd:b0:535:65ce:e901 with SMTP id
 2adb3069b0e04-536ac2d6791mr7595449e87.4.1727161944567; Tue, 24 Sep 2024
 00:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240919091359.7023-1-xry111@xry111.site> <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
 <b9bc6db245775b0a2e990467f414071e82b06a29.camel@xry111.site> <ZvFji_xpV0tWxZIn@zx2c4.com>
In-Reply-To: <ZvFji_xpV0tWxZIn@zx2c4.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 24 Sep 2024 15:12:11 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5FfbgH_7Cy_OTzjxEYJ_y9UKBXavk2D7Sy+-SAxQqvZw@mail.gmail.com>
Message-ID: <CAAhV-H5FfbgH_7Cy_OTzjxEYJ_y9UKBXavk2D7Sy+-SAxQqvZw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Xi Ruoyao <xry111@xry111.site>, WANG Xuerui <kernel@xen0n.name>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>

On Mon, Sep 23, 2024 at 8:48=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> On Mon, Sep 23, 2024 at 04:06:41PM +0800, Xi Ruoyao wrote:
> > On Mon, 2024-09-23 at 15:15 +0800, Huacai Chen wrote:
> > > > +#define line3          state12, state13, state14, state15
> > > > +
> > > > +#define        line1_perm      state5, state6, state7, state4
> > > > +#define        line2_perm      state10, state11, state8, state9
> > > > +#define        line3_perm      state15, state12, state13, state14
> > > > +
> > > > +#define        copy            copy0, copy1, copy2, copy3
> > > The indentation here is strange, it seems some of them are spaces and
> > > some of them are tabs.
> >
> > Oops indeed.  The tabs after "#define" should be a space instead.
> >
> > Jason: can you edit it for me or do you want a new revision of the patc=
h
>
> I've fixed it in tree.
>
> Jason
