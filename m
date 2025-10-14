Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422A2FC007
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760461733; cv=none; b=NcIvuCl7Hn0tbUiZyULhScNBUAa1Cfby+HNtyczwrhRQ8OR/5PuP6+cqOyuK8etyBaIs9JSHgfXIFETA4Av0ZFlXHQ6Osfs63/quvGdXvLT7MccWaw2uQ424ZuDxbGY0C52jwDoQ/ypl42F5Zv+qemqlaLeNGOyeNAZPdybSQmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760461733; c=relaxed/simple;
	bh=llGTfL/hruPuI3poyclCbTdGVJc/cIEMAV0RebKWbeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRhTFjBZhoNT5lmlGezp69u9sxGW4m3zW346pUQr+LzLMpDCzQroGiW3c8bRGUaGyBUbw44bt5b8CaS8qsMuu1L77x+r/D1HQTEoghgwAWIS7VQK9TGEACMxnArt2v2SZGOZaCexBjrzjocbyDdZIiwjSXdZnEifrMBYEu6PD/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzLc28Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzLc28Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52428C4CEE7
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760461733;
	bh=llGTfL/hruPuI3poyclCbTdGVJc/cIEMAV0RebKWbeU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fzLc28Ywld8M3/2oBZOQaronZ5BCDjBYMJey0AOwsAm4SJa9al4tn75MdXOW9hqix
	 5up6Vqancn4KUEahofdrLpDs+djV7tmbBo8ahvpaXodlLy4kb8jdkTr7l3sjeYfiML
	 lItFRkOsZzj7aiEA4mQ2PiT07tfW6a/cU67VOqb4gl9PM5XLTIAqPlV0+KQelQVBFY
	 WNdZ7flWYwzvrQcuOBFSo/Yqh1LNgCL+Pz1aPTHTwWPhTttwGADqeNVKceEXotoHo9
	 zfswoKKVx+pnylmOZuJqNX41vhU2XYC/I3TEXPb5WXSM+MIEj1vpevYYd3mKQ8v6zf
	 IRD8bRHJMqtmg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57b7c83cc78so91170e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 10:08:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVur4br1yXey4H8VVDU/7ocWeEoXEv52TD8juxdei2XqA+TjcBAUsQXcdp1J0qzlmYlfzGh8hhg5nLPAsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA9BhHlbv5E/gLFsqEbRBSpL1vnc2t/bjsw10EvrT3ejPUaNVk
	rv4UWJI1idiv5qdKkai+gFV7+XguLFTGTlFXKKmHnA+D1Qz53zktOWrA1hNHFrCAaAeYCtKY0uG
	9O/nfTd1flGnSgnPjL6i5TYnuTZjWURg=
X-Google-Smtp-Source: AGHT+IHxPIYgUM364egP01qFsFjEJii3t+dh6aYQIX99l1675zbcriuqj4pjuT+ecllJeULMqzVWjYg+rIJF7sK64I4=
X-Received: by 2002:a05:6512:1313:b0:591:c8ef:f838 with SMTP id
 2adb3069b0e04-591c8effb76mr44305e87.17.1760461731685; Tue, 14 Oct 2025
 10:08:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>
 <20251014165541.GA1544@sol>
In-Reply-To: <20251014165541.GA1544@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 14 Oct 2025 19:08:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>
X-Gm-Features: AS18NWAZDqinEyn9xu2bP5Q2myA80DF3mkFAybPsJ3soPTkZx-B5eSi25fizApg
Message-ID: <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>
Subject: Re: Adding algorithm agility to the crypto library functions
To: Eric Biggers <ebiggers@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Oct 2025 at 18:57, Eric Biggers <ebiggers@kernel.org> wrote:
>
...
> > because the user has no input on the hmac hash algorithm so, although
> > the TPM specifies it to be agile, we can simply choose sha256.
> > However, we have plans to use what are called policy sessions, which
> > have require the same hash as the user supplied object used for its
> > name (essentially a hash chosen by the user).  In a TPM these hashes
> > can be any of the family sha1 sha256, sha384 sha512 plus a few esoteric
> > ones like sm3.  So the question becomes: to avoid going back to open
> > coding the hmac and using the shash API, is there a way of adding hash
> > agility to the library algorithms?  I suppose I could also do this
> > inside our hmac code using a large set of switch statements, but that
> > would be a bit gross.
> >
> > If no-one's planning to do this I can take a stab ... it would probably
> > still be a bunch of switch statements, but not in my code ...
>
> This isn't the job of lib/crypto/.
>
> If a caller would like to support a certain set of algorithms, it should
> just write the 'if' or 'switch' statement itself.
>
> The nice thing about that is that it results in the minimum number of
> branches and the minimum stack usage for the possible set of algorithms
> at that particular call site.  (Compare to crypto_shash which always
> uses indirect calls and always uses almost 400 bytes for each
> SHASH_DESC_ON_STACK().  SHASH_DESC_ON_STACK() has to be sized for the
> worst possible case among every hash algorithm in existence, regardless
> of whether the caller is actually using it or not.)
>

I agree with this in principle, but couldn't we provide /some/ level
of support in the library so that users don't have to do it, and end
up breaking things, either functionally or in terms of security? The
fact that you yourself have already implemented this in 3+ places
suggests that there may be many other occurrences of this pattern in
the future.

I agree that adding a generic hash API that takes a char[] algo_name
and supports every flavor of hash that we happen to implement is a bad
idea. But perhaps there is some middle ground here, with a build-time
constant mask representing the algorithms that are actually supported
at the call site, so that the compiler can prune the bits we don't
need? I'm asking for the sake of discussion here, though - I don't
have a use case myself where this is needed.

> But I have to wonder, do you really need to add support for all these
> hash algorithms?  Adding SHA-1 and SM3 support, really?
>
> What stops you from just saying that the kernel supports SHA-256 for
> these user supplied objects, and that's it?
>
> Getting kernel developers to think carefully about what set of crypto
> algorithms they'd like to support in their features, rather than punting
> the problem to a generic crypto layer that supports all sorts of
> insecure and esoteric options, isn't necessarily a bad thing...
>

Yeah, that's a good point too.
