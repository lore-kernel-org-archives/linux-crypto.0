Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C17E19D898;
	Thu,  6 Jun 2024 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717657140; cv=none; b=PEMPoeVboHeXp/jPOTednpn/dtVwaSp8j2/LwNIm3kOxCi58v6+/khS0n8pMFQNp38mN1ZPTbh91AthnE5U5Z7uJagwlOs/FH3sECkx0TyR+CQ/LZCbQINFDoFRthcStry07fhxAoekcEtD1Qhsngr3zkChXK70hyogMH93bFsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717657140; c=relaxed/simple;
	bh=87LH+aaU1KT+V0MM3MNI+6hzSZdEAjajZB97hmhjhBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbQ+x51aQuMREuLcFEseSGnwAB5hDXZFV3cIezpcl6kF3fQfEHJxBMozHeJqg/JBq7BWeUv7C1wfLcSDiZth+vH8oyfLOumOAWLepV63oJBmNcC2+pdb56D24E/zHzR7xOni3sixXjcCpwQwUIwmj1aw+qhp56E92Vxx1Ig8abE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jH4dMWr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jH4dMWr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F3AC4AF12;
	Thu,  6 Jun 2024 06:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717657140;
	bh=87LH+aaU1KT+V0MM3MNI+6hzSZdEAjajZB97hmhjhBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jH4dMWr07DETa2BkS0tc8A3a5D8JBHx3CiJmQrz+Ny9JpZPF8h/wzB34qhSg8Kl9J
	 cSuIMjyGju8e0FSobLeUh6MQNM7w5XzyVShcQADQnJPYNISyyoiShe8nN5e8XVstm0
	 xyFjzTG5GTfmibC4Wvv5dMqkz/s0St4lkLluod/oM1P4nLJWTicBYCbFZMTL3yDUj6
	 zNGOjcRyfhXyo1vULD2AVSXZmTZBPyhUYKlgyhxqZSQMSTjIvIJIhm4dj/1+hifdtP
	 CMRf8PkW5E4fSGFdpIpMFpVaI4QZ8H9FJFxQyDIBBnDo4tX4VyFKVFCGvzJRBqrK7y
	 ADzrua+FnjKfA==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e6f2534e41so6175721fa.0;
        Wed, 05 Jun 2024 23:58:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+SO7er6kKoHFW/GuQEBX/zKGENHVlEraXJjwpj3BCpCkhGcNsiyvp43wtc2z7Piyut6mO4XGDJdItdFXpQBXsAfzQgM44p6NgOeySPn51WQNAtRQl1CmfyUkUBZn6xs0E6Mfg
X-Gm-Message-State: AOJu0YyswfldTHrzm+wY1pKltVuG+9IvV8VbnTMiTxJ/4QzV0QlkCrsb
	O7KdkrOQDLCASC94VtWPILFO+OvZjZtX7GjdnVnu6MCilr6byME+cN3evrwGO5d0pE4JL9km9q1
	U4sKfIa3d/O1I2NnpxhqNLcnn8a0=
X-Google-Smtp-Source: AGHT+IF4pgsLvGvG79oDFfsn4R1Zk0TF45o69r+lMzPkB0QPutIkw9xIe8I08ISdidP9SOiERLqlkB4BoW7iMvGRGpg=
X-Received: by 2002:a2e:b607:0:b0:2ea:8ae5:92c with SMTP id
 38308e7fff4ca-2eac7a7089cmr23831261fa.47.1717657138214; Wed, 05 Jun 2024
 23:58:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603183731.108986-1-ebiggers@kernel.org> <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au> <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au> <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au> <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au> <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
In-Reply-To: <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Jun 2024 08:58:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
Message-ID: <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Megha Dey <megha.dey@linux.intel.com>, 
	Tim Chen <tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 07:41, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jun 05, 2024 at 10:28:01PM -0700, Eric Biggers wrote:
> >
> > With AES, interleaving would only help with non-parallelizable modes such as CBC
> > encryption.  Anyone who cares about IPsec performance should of course be using
> > AES-GCM, which is parallelizable.  Especially since my other patch
> > https://lore.kernel.org/linux-crypto/20240602222221.176625-2-ebiggers@kernel.org/
> > is making AES-GCM twice as fast...
>
> Algorithm selection may be limited by peer capability.  For IPsec,
> if SHA is being used, then most likely CBC is also being used.
>

IPSec users relying on software crypto and authenc() and caring about
performance seems like a rather niche use case to me.

> > In any case, it seems that what you're asking for at this point is far beyond
> > the scope of this patchset.
>
> I'm more than happy to take this over if you don't wish to extend
> it beyond the storage usage cases.  According to the original Intel
> sha2-mb submission, this should result in at least a two-fold
> speed-up.
>

I'm struggling to follow this debate. Surely, if this functionality
needs to live in ahash, the shash fallbacks need to implement this
parallel scheme too, or ahash would end up just feeding the requests
into shash sequentially, defeating the purpose. It is then up to the
API client to choose between ahash or shash, just as it can today.

So Eric has a pretty strong case for his shash implementation;
kmap_local() is essentially a NOP on architectures that anyone still
cares about (unlike kmap_atomic() which still disables preemption), so
I don't have a problem with the caller relying on that in order to be
able to use shash directly. The whole scatterlist / request alloc
dance is just too tedious and pointless, given that in practice, it
all gets relegated to shash anyway.

But my point is that even if we go with Herbert's proposal for the
ahash, we'll still need something like Eric's code on the shash side.

For the true async accelerator use case, none of this should make any
difference, right? If the caller already tolerates async (but
in-order) completion, implementing this request chaining doesn't buy
it anything. So only when the caller is sync and the implementation is
async, we might be able to do something smart where the caller waits
on a single completion that signals the completion of a set of inputs.
But this is also rather niche, so not worth holding up this effort.

So Herbert, what would the ahash_to_shash plumbing look like for the
ahash API that you are proposing? What changes would it require to
shash, and how much to they deviate from what Eric is suggesting?
