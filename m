Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313E13B28A;
	Thu,  6 Jun 2024 07:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660570; cv=none; b=oAOq7i6PwyE9u++EnNXcC6GpMIoCgSQs7lyaDdWiedgCFL68zu+fxMTHEHE/Z7hWue0cpKqvG9NobSk3OG3tnGEsG6T9f/osRznZz8h+PLqNJvNg13yDaYvAraNoaYufRNgJZDUzguKgzsBcpoMrGJd2s5bfzGuRE1F9LrwaXiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660570; c=relaxed/simple;
	bh=CVkaqZl8ch00DGfkNJRMLiOVSK869YuGUN3ADO9UFOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BlIjUlpxuACyECcPTwVqNkhMe2oO6U/UxnTO415HqQt4nwE2GKpBnJdHG6JtMKSGo/ne07VwRFWRXgBRDUEQaZMxPZkFW2BLwTPacxF1sXOukg7KUIXYlQk0jw9LRIjHMqoSbaFm/1LgPOk5VkjX0JfWeWlDZQLxX2G0PhdRHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TP7ezMIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TP7ezMIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D45C32782;
	Thu,  6 Jun 2024 07:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717660570;
	bh=CVkaqZl8ch00DGfkNJRMLiOVSK869YuGUN3ADO9UFOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TP7ezMIEYo5tH6cqv6jM3GitTGHJyiZW+uodFmffXAGjrXgvBIijEQQOOnYux6EkY
	 liAthHQH2lBRbXNvJW0APd8rVZWoFl+7Ftk37MCuU2kNRDVaS24ZgbtIh1YTiDKASJ
	 EYKTni5J9PAe2axBB2sJ/BmvQMZpFKdwVVPz6D4bp7Zi2JhECFhdK/0CdwT9/d3ywi
	 oO28PJRDGZjGWDNGNvUVtSvZ50oOV3WGUsaPBKi9H8gyYxhYohF2L28/gtMRCe1mJk
	 vE/0XrnPbKBdARta+46Ypxrp2c2xhNi9oR8YmxZYe0dIcyCS1z0j2ypJS+/FqIdgW8
	 Epe9H/ygqg2Dw==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2eaccc097e2so6683721fa.0;
        Thu, 06 Jun 2024 00:56:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVlTgcpJe0OTMTxJGlpHY396DDfjuJ6g13YJPr6+Tk5zntl7zhVCs6Em7d1jl4SnZZaKFO9v+pYu12zyWLUaRgz1XvAxtXH+WF+HpNAFlqM/6xukM/eaLVN0KLOZAmdISZb0c5P
X-Gm-Message-State: AOJu0Yxm4Lk8F/7uIuBvRnjOC8JnTgw22GMwnMXsUTEZxe/VvAQJNTLY
	JNmY8Lw4Kx3uSg2UREiWNoRJDiKJWMlNP1r0UFdA8gC6t2guKMm0OtZ1jjTSmdyoliDbb8kPzxB
	OMDHCRgRe7SXVFrBzb03tohU1AMA=
X-Google-Smtp-Source: AGHT+IFV+tAqQp09BODHzBNmtMi8MlvdHjCn2uBHKx0cTB133/EqPXtxB/XwMTtgflBRfXf6XRYzCruVskBjfCX1R8c=
X-Received: by 2002:a2e:b704:0:b0:2ea:81cc:b146 with SMTP id
 38308e7fff4ca-2eac79dcb4bmr25794821fa.18.1717660568411; Thu, 06 Jun 2024
 00:56:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zl7gYOMyscYDKZ8_@gondor.apana.org.au> <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au> <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au> <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au> <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au> <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
In-Reply-To: <ZmFmiWZAposV5N1O@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Jun 2024 09:55:56 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
Message-ID: <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Tim Chen <tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 09:34, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 06, 2024 at 08:58:47AM +0200, Ard Biesheuvel wrote:
> >
> > IPSec users relying on software crypto and authenc() and caring about
> > performance seems like a rather niche use case to me.
>
> It's no more niche than fs/verity and dm-integrity.

fsverity is used by Android, which is the diametrical opposite of
niche when it comes to Linux distros.

> this could potentially be used for all algorithms.  Just the
> reduction in the number of function calls may produce enough
> of a benefit (this is something I observed when adding GSO,
> even without any actual hardware offload, simply aggregating
> packets into larger units produced a visible benefit).
>

Sure. But my point is that anyone who cares enough about IPsec
performance would have stopped using authenc(cbc(aes),hmac(sha2)) long
ago and moved to GCM or even ChaChaPoly. This is not just a matter of
efficiency in the implementation - using a general purpose hash
function such as SHA-256 [twice] rather than GHASH or Poly1305 is just
overkill.

So complicating the performance optimization of something that runs on
every (non-Apple) phone for the benefit of something that is rarely
used in a context where the performance matters seems unreasonable to
me.

> > I'm struggling to follow this debate. Surely, if this functionality
> > needs to live in ahash, the shash fallbacks need to implement this
> > parallel scheme too, or ahash would end up just feeding the requests
> > into shash sequentially, defeating the purpose. It is then up to the
> > API client to choose between ahash or shash, just as it can today.
>
> I've never suggested it adding it to shash at all.  In fact
> that's my primary problem with this interface.  I think it
> should be ahash only.  Just like skcipher and aead.
>

So again, how would that work for ahash falling back to shash. Are you
saying every existing shash implementation should be duplicated into
an ahash so that the multibuffer optimization can be added? shash is a
public interface so we cannot just remove the existing ones and we'll
end up carrying both forever.

> My reasoning is that this should cater mostly to bulk data, i.e.,
> multiple pages (e.g., for IPsec we're talking about 64K chunks,
> actually that (the 64K limit) is something that we should really
> extend, it's not 2014 anymore).  These typically will be more
> easily accessed as a number of distinct pages rather than as a
> contiguous mapping.
>

Sure, but the block I/O world is very different. Forcing it to use an
API modeled after how IPsec might use it seems, again, unreasonable.

So these 64k chunks are made up of 1500 byte frames that can be hashed
in parallel?
