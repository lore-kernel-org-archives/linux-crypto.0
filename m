Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F093F8D1
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715347237; cv=none; b=e+zoHbFaAsMV4/izJ/kwb2XhP651oUR6s0W58wpigKKzDdbAaaO+CM6/vkOErLa9n0l9DRRFYUtdGt/gvkdmDXkWpyCKzGjjYVwCjyhVdEicP4p+K5R9q9EjizRBPKJ1+OokDD2ZCLMy8vtOqj49iznz19/OfGr6jiPsRP+ICtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715347237; c=relaxed/simple;
	bh=oIlRLwp1FQWAX5nzp6zQCzQAtkWzJORnnnzJ42a12qc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3slTQaab2IyUTkmoS5hX9k97XoJUEOYA4YXLUfWrDun0vbCn4DKoXZ1HdR1HLFYBGxVuWBidxWDoCIfL0tXOxBpRTC06FWQrT0IBrbz37UruV18YytNTss47hfKIOmw6li9hWdVfJHNBORM5IO9NZs2kEkKf+oxHMJXF8DzZuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGxSBHer; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGxSBHer"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59cc765c29so452639666b.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 06:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715347234; x=1715952034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=939G0JcTnD3DY7PHHnmv9Ic3GSSK2KFfF0p412OVmNc=;
        b=iGxSBHerxYY8+06p8wGUSzUF5lyeMeAIHKeZAtIFBpBJXaWVE/wsAitvd6P+YS8lBE
         dft1vK8ya2COfijrGSGjUUj4wn8yCiyH5+WLby1eHj76P9fqgVpSkjywyp7TBU4O2Qh2
         CgJqhdHUs652H3+sE00bmGnFISKkvtkZd+g8dhz+KpDXqwFBd/c8r7rJ8Sih9Bk+mma+
         2z+Vd6FiSAOqiRk6PQ8Jt5BKEG5GTBjRvUw+R6SG2QxQenanJxSaDtkSasWm6MG/N58N
         gihW7hEesFaH4CG+g+r9jbNwYb3UBubTbYRsG5GWd9WfxJWlNshQ923bLisUHpHNmvBE
         mH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715347234; x=1715952034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=939G0JcTnD3DY7PHHnmv9Ic3GSSK2KFfF0p412OVmNc=;
        b=CewkWcQU1j8lAs97Xz+/4tppFkvi00qVtnmLUMvmhxrYJF/BK0J6+3QSc9f9A+T1iA
         bUcVoNl2kQE+tFICkp5eEVWZ7bGIiY4hpa3aPHtcNyl4vxIONSLl6q24LI1/PZ8AqZi0
         Z9Zni2p/jHgaMfqwhY3NdzC89cA7DylkbZLgcxmYYkTD/TQDN1A9YFWay3xsoXyE5U04
         u0ReuVkiX3ZNo2IjvHcaQOBYgD5y90XVLDcLCAcJpoOp9VUFboD01XqYwFzILnHVLOhf
         DYHpGHCE5S5MrbOxdRI5dNKHyPyAtN1H9xXN2fWLLOTXOfqClA1GxnA4FhECDAj+QzkD
         GZ2A==
X-Forwarded-Encrypted: i=1; AJvYcCUfiFxcynih7BrHQtgYTQqbeU2eV9lvwTbM+Etv5afHjGF/VdxpKzgu1tcoBHmtRW6dOPNc3WO1gelzkIMoyS8mrS+S++u0rqh8UuXJ
X-Gm-Message-State: AOJu0Yy+FvjwO0EnT+Mb7U0H2Hnw9hxxyTN3ay2Za0mexZcg8UydM0Uh
	AdoFD4J7t/E6ICfFoW2xsZOaW3EvJDFPt428wZ/r7vaKX4N/PWmRybt1ER3Y9RRJftkTBmWfQ9u
	trLxdc7ZIiQAI/OiXCXo5s60zc2I=
X-Google-Smtp-Source: AGHT+IFtTuucGLUmn7DA7mVfavem1VVK3zkgnsxBIoHAT3QKsWAf9fIw7TfCdsbiMPUfVKbPRVZYXciS3Wvxb6ND3S4=
X-Received: by 2002:a17:906:d95:b0:a58:bdfe:95a with SMTP id
 a640c23a62f3a-a5a2d57a722mr161036666b.26.1715347233814; Fri, 10 May 2024
 06:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240508103118.23345-1-kabel@kernel.org> <20240508103118.23345-8-kabel@kernel.org>
 <Zjti-FkUCAQzMmrQ@smile.fi.intel.com> <20240509205729.09728cbb@thinkpad>
In-Reply-To: <20240509205729.09728cbb@thinkpad>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 10 May 2024 16:19:57 +0300
Message-ID: <CAHp75VeW8P2S4i62NhcpwZ=tbpNfBtanz_1zXzBh2H2PCbHLUg@mail.gmail.com>
Subject: Re: [PATCH v9 7/9] platform: cznic: turris-omnia-mcu: Add support for
 digital message signing via debugfs
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>, Gregory CLEMENT <gregory.clement@bootlin.com>, 
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 9, 2024 at 9:57=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.org> =
wrote:
> On Wed, 8 May 2024 14:33:12 +0300
> Andy Shevchenko <andy@kernel.org> wrote:
> > On Wed, May 08, 2024 at 12:31:16PM +0200, Marek Beh=C3=BAn wrote:


...

> > > +#define OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN    33
> >
> > 33? Hmm... does it mean (32 + 1)?
>
> Rather (1 + 32), the first byte is 0x02 or 0x03, determining whether
> the y coordinate of the public key elliptic curve point is positive or
> negative, and the rest 32 bytes are the x coordinate.

I hope you used that in v10, i.e.  (1 + 32) with a summary of the
above in the comment.

--=20
With Best Regards,
Andy Shevchenko
