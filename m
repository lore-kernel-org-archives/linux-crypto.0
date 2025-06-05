Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CAD27A46E;
	Thu,  5 Jun 2025 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749149172; cv=none; b=kSU1SCufDV93qQ12la8DBRZ3G5UEwH5If9A/U6m/lBKoa1iz7dQ1QyhogPnH/xKlK0iuxfExTV5s0flh/CVLMvVdFq4P5X02CcW44SlApKT6zleT9JHgwwmkucXaf7pUBLnHvF4E1C9M/DqjB16ZZvejFOaGoInSHQyc0dPacUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749149172; c=relaxed/simple;
	bh=5whSNxZjJBq8hlzf6X5onhHVEXe5wrAaLddVIqqoP28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nl8q/q1Zvtete3vM1q5GfTNVFI/zH8q0OkdYDcNmDap3qVhH+51Isv1c5FCCvKTnOJPCe5ah+lTr5mP3CU118rmFhxd7j31mFittSS2gqCaqoOJ9/dsI+JXqdLGUBpyreWF71aLus0uRKlKs+q6tmDjUgzhNIUPyM1ZnEQumV+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=oiGe/5Q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oiGe/5Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54273C4CEE7;
	Thu,  5 Jun 2025 18:46:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oiGe/5Q0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1749149169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5whSNxZjJBq8hlzf6X5onhHVEXe5wrAaLddVIqqoP28=;
	b=oiGe/5Q00IXBICxEs88AKVrO8sluUNu1TfN25toYolE8mVGTi4kXuKLzpxc45WBN5sYygh
	jL+NQak+Rg4dS2sR4raJSRmLZTekDwyFKc6LN19oHRpQvgH2R0o85YPyQ+mQzpC2sndS+b
	/rBpI7S38PezBr7ITP8AH3rviyJZyqw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 83c903e7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 5 Jun 2025 18:46:09 +0000 (UTC)
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-606668f8d51so829696eaf.0;
        Thu, 05 Jun 2025 11:46:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUyb8JzdcO/IDWgl4uiOQ5zgmTHs7qSzcmohxtVtTCQ7M27c1elnXPlhzGl37LQ1QPmNDVN0I+fhHCdPAI=@vger.kernel.org, AJvYcCXyg9phrNLMzKigIe7K9k6mceIfHF66GNjkk8x/5SoN1H29eQqO1QLEwTjYfXj4HjqC7t2c1yiVF7a4mzZC@vger.kernel.org
X-Gm-Message-State: AOJu0YwqCHJ+BOz8bk3lH6krmSFEcwkaFHceY940VvbV092ruLsmQg72
	Rgm6vaUhm5+0uDl1mviHDa46AzaMA7ARd0UKr4e57Ko0GPRajX2m6Ayjp239s9eAe0RwDDq32Km
	q0i/g/pA74OeUAULzhyiTKYYtQ4kK0+8=
X-Google-Smtp-Source: AGHT+IHfGH+NWz2p1/fN0HHjBnBQpbtCX590e/Q9M8WXiJ1PVzoRDQ6L8jQJ/ncZqlBqsjPelf05qj+u7Rlo48VBxjQ=
X-Received: by 2002:a05:6820:2112:b0:60f:1fac:b899 with SMTP id
 006d021491bc7-60f3d723f96mr170630eaf.2.1749149167922; Thu, 05 Jun 2025
 11:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605171156.2383-1-ebiggers@kernel.org> <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
 <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com> <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 5 Jun 2025 20:45:56 +0200
X-Gmail-Original-Message-ID: <CAHmME9qE-gihY9XK0nNnRY+mHeTNNgn1qi1E7xCKJACFz-uqDg@mail.gmail.com>
X-Gm-Features: AX0GCFs-d7gBFupCQpdXIWYR568jYeUBNMCl-9sHIpUeMd-ViOev8bC94KfV6Qg
Message-ID: <CAHmME9qE-gihY9XK0nNnRY+mHeTNNgn1qi1E7xCKJACFz-uqDg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 8:45=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Should I just add you and Jason directly as 'M:' entries for this?

Works for me.
