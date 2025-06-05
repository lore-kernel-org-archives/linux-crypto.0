Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70AA1DFF8;
	Thu,  5 Jun 2025 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749147178; cv=none; b=od7nJrJ9eEc//QrF5dEcWq3FsO8xzEJZZGlQTTfhrKCyiDCryzwDUv9Dy4IfNTRmG+61Y5l3uhN6l1AY3mT/2ao84VGs5wkV+qfjrKBquZK6oc2VrGAoIv72gxKKis2sJKikPvtUSMdbxRpS/cGE9LTbIVuyzfu+lJJO8+0y+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749147178; c=relaxed/simple;
	bh=VC8TiWEJbCP5fK0TurDRuMuKqFoNrwTF28zOwDUpCbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U/fhOaxOixteZHy6ojucK789LthkXghlHCStbZ/G8TOOcRuvUzGFbi8FpfTq5vVJdMA7lAOXd5LiXGo94CusjQCHm/G1eAvrBPBzsTgIadpnigr6srmTqgtZx6CwXwE1tTEBAcEE5xeW/TTaNnkQkvpRn3G8EF9t8gZJoXcK0Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=h/PhjNNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h/PhjNNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA09C4CEF1;
	Thu,  5 Jun 2025 18:12:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h/PhjNNg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1749147173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yz+riPGjolDYqtLqirI8fOQXzpyk1sCFLqxaGoXvwwo=;
	b=h/PhjNNgxroIykBgAe51rjx9DmIqLoH5LYWVxtTwERlTxRBAlqFtQuYAeEs1BZ3H4vZCF5
	r3mVUJoLJTrlZptPHyWpOc7lCUh9UXBIE7ay5aIA4zLHHnhhTJnI5XodwrWe5ebwiMMPdL
	7MfjJLqrtBzqHNXmSgzoQiT6hdsPc6U=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8d2c07ea (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 5 Jun 2025 18:12:52 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6021e3daeabso586254eaf.3;
        Thu, 05 Jun 2025 11:12:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXX29vuQ7Kry3tJ+3kBQQx5sckDRzvQnvuktaARCd0GRcZMCScrHLuyerFw+XZZmOptn3jTeyUq9axIbyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX6uzNA8ekvHmNsAR67vEhIHIzEJiq5RQF9lmEOenjTFecwiWo
	KQ3aukK0ejvrbJjGGW0mH5lO7se4q0BrwEIUSTdugbVB4yfT6tArtL0M3d9kMvt7ec4ogGah19l
	Y7sgeci4WpugnXCfpkJ4PGIso9TVxjc0=
X-Google-Smtp-Source: AGHT+IFMzxQ0yDITEcbwM4QJbsNSXQVqEevb0+SMynwElAJVD7geXYbMW/G37EuS11U9wW+ZY1BquTGh4cCKmaDmVXQ=
X-Received: by 2002:a05:6820:3102:b0:60e:d5fc:aa09 with SMTP id
 006d021491bc7-60f3cf132e1mr279392eaf.4.1749147171385; Thu, 05 Jun 2025
 11:12:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605171156.2383-1-ebiggers@kernel.org>
In-Reply-To: <20250605171156.2383-1-ebiggers@kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 5 Jun 2025 20:12:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
X-Gm-Features: AX0GCFswnp-bT3dT59KZzxWSeyWyKRFqNf10qQ5gJIt4H4JINfmYokK9LLexy30
Message-ID: <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 7:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> I am volunteering to maintain the kernel's crypto library code.

Lord, please, yes!

    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

And if you'd like a co-maintainer, obviously I've been quite
enthusiastic about the whole librarification thing for quite some
time...

Jason
