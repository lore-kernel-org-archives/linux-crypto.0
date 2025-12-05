Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE62225A645
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764940001; cv=none; b=kgRopDOgdyv6Mrmb0VpF6vi09895e74/cm7fM6g8FLd/dK7YPgfTVPe/XqsAjqfjBnkzTSlmjtCypAth7sYVONHl3TpIHHfZBRO998NCGq98HWi+6q4StRD4dw0O1tH3/vtyO/Fbi6AqpxM9MLBnENHDVogTAroPqj1l1O1/Sbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764940001; c=relaxed/simple;
	bh=1EBb19I7TXyr0Wc23Pl3IU7EwdnF5SMRtXHCjSD0p9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MdMEYpCAXvkuY5nWpHqYk/LYSigjexsCmmwn9efI5pYqIiM9vWDIXEko5EaQowU4/KzcowhyTk6InLKzZGKfy3Rf2DYcfGVJmZXiPs1nZZ3op0siwgo70GJcEMvvlDyBvpUBGhV/BBL1rCAGOFCnBaP3bKdGCThpdMMLKw0YDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-657230e45e8so1598998eaf.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 05:06:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764939997; x=1765544797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aMjf00fvZ2LGfiVehlweJ/JHTaRsyCeBS7wev6/MCNc=;
        b=YewqzRrGBsAyKH3epV3T/OFkCxxrNy4gn23P0VozU06jGMhJqcuchpjmzqX/HVTojh
         Ib0MhB6D5Ovel9XKwDpsTqwkplVTfiu9UvyAHsVmh5qMLDBcAIeJGDlrpnzbyDSvup5p
         461XbD3LCHprM7H0+KJWtqmRn32nhbHvJNVCzOPqtKBeaoJseD03vOqbYhd4PIIxHI9G
         VEcBH5PzR7wDqXrIZybPk9eZ8A83E1vR8zRNPJuJWLwu3jLD+/KRJAjauKOy0bMgW6oZ
         HBtc5hQKvb90wVaUdCftkp8LEZ8+fOTVDX88rHhK8ggF/yc0cuTx0+2GIYglt7SMe9/r
         GHKw==
X-Forwarded-Encrypted: i=1; AJvYcCW5Y60aj00UxRX/3mQqIQQAL8mGXXF3h9W/UG7CspCkBbHKZmjjnBgzxn8NY5SR7Mp/uXpcUYKoUn7jI9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOnWtJyF+7k67mtjjUtTLP7EEvDkCNGcBWef2aPD3fc2hYkMbE
	G6NHv2Se34we9y8+BSSPZXc+eaBsHIRPI7auLjenCuZcLcfib61cHNglZiKNVQ==
X-Gm-Gg: ASbGncsQufQI6ghfpjysShEsw46kG2W50oY25dR9vmsjtYbk7ipiYvg3xAgbS37cEUl
	/aSusMV10ksc6Uo3kkGcg2RvVr6cfryyP4L0qDvN4GP6oNQtz0GHP53boEs4m423nRoJUhccTTz
	vzstvRukNFjC4KuY/q3bREgCymKPAhLmNrHpICuwiaQ7InTTT7W60wYUoplxQaL4R8ODLztoC+Y
	FQyGwzgkMW2x37+bwzTlc1HpQrLdFu1C7XHqpZnJ1BSncut+gi+byahAbx1RsCdmRdZglLq6UAv
	2UICGgtPpVhB66d4j2Fx+WYhk2BvhNXNGxQRaQfpWUVCzczeOvDby0/pTXDt0q8rO9EUzVTGbPF
	XdY2q4NWESkHvW8aMR2QPNp5b71+pL8iSIGXg9YlhntIZFVWfhis1KRXBPX37Tc3WIEmkzZJOZP
	CZlRM91p1dn5DNfVegUAgAwzYGHarqasARnLnimHxcpeRk8Zd3m7ox6f13L0EaKi/SKp7ayzxn
X-Google-Smtp-Source: AGHT+IFKEKkXzGJMiUuoIWpJeLSSUZ3tx5WrjCRb/GojVzHuD5PCFtW2cwxcm/h+yDGGuGRRMxv4ZA==
X-Received: by 2002:a05:6808:13cf:b0:450:d4b5:3527 with SMTP id 5614622812f47-45378f717cemr3659112b6e.24.1764939996888;
        Fri, 05 Dec 2025 05:06:36 -0800 (PST)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f50b584778sm3266286fac.16.2025.12.05.05.06.36
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 05:06:36 -0800 (PST)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c77ed036c3so1994730a34.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 05:06:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUK9gfuKeHYlNG3AU8J8Lgk27/SGERmv21CjLNZMuIRaQNC0iTFJTNR6F2kjU1pt0JOEyUbfEowOV95jsM=@vger.kernel.org
X-Received: by 2002:a05:6830:310c:b0:7c7:26e:4686 with SMTP id
 46e09a7af769-7c957c0afe7mr6091417a34.5.1764939996182; Fri, 05 Dec 2025
 05:06:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205070454.118592-1-ebiggers@kernel.org>
In-Reply-To: <20251205070454.118592-1-ebiggers@kernel.org>
From: Neal Gompa <neal@gompa.dev>
Date: Fri, 5 Dec 2025 08:05:59 -0500
X-Gmail-Original-Message-ID: <CAEg-Je_4-vcyTg+aYA3nTsQ9ekBBZ1h89u9Qk_ZGQ_mGS_5Y4A@mail.gmail.com>
X-Gm-Features: AWmQ_bnWVIauyhohzQgsmdPw2A8fSpbERJ7LqNlJnEyvjZSg3WiSLOfT0DPM3mM
Message-ID: <CAEg-Je_4-vcyTg+aYA3nTsQ9ekBBZ1h89u9Qk_ZGQ_mGS_5Y4A@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: switch to library APIs for checksums
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 2:21=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> Make btrfs use the library APIs instead of crypto_shash, for all
> checksum computations.  This has many benefits:
>
> - Allows future checksum types, e.g. XXH3 or CRC64, to be more easily
>   supported.  Only a library API will be needed, not crypto_shash too.
>
> - Eliminates the overhead of the generic crypto layer, including an
>   indirect call for every function call and other API overhead.  A
>   microbenchmark of btrfs_check_read_bio() with crc32c checksums shows a
>   speedup from 658 cycles to 608 cycles per 4096-byte block.
>
> - Decreases the stack usage of btrfs by reducing the size of checksum
>   contexts from 384 bytes to 240 bytes, and by eliminating the need for
>   some functions to declare a checksum context at all.
>
> - Increases reliability.  The library functions always succeed and
>   return void.  In contrast, crypto_shash can fail and return errors.
>   Also, the library functions are guaranteed to be available when btrfs
>   is loaded; there's no longer any need to use module softdeps to try to
>   work around the crypto modules sometimes not being loaded.
>
> - Fixes a bug where blake2b checksums didn't work on kernels booted with
>   fips=3D1.  Since btrfs checksums are for integrity only, it's fine for
>   them to use non-FIPS-approved algorithms.
>
> Note that with having to handle 4 algorithms instead of just 1-2, this
> commit does result in a slightly positive diffstat.  That being said,
> this wouldn't have been the case if btrfs had actually checked for
> errors from crypto_shash, which technically it should have been doing.
>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> v2: rebased onto latest mainline, now that both the crypto library and
>     btrfs pull requests for 6.19 have been merged
>
>  fs/btrfs/Kconfig       |  8 ++--
>  fs/btrfs/compression.c |  1 -
>  fs/btrfs/disk-io.c     | 68 ++++++++----------------------
>  fs/btrfs/file-item.c   |  4 --
>  fs/btrfs/fs.c          | 96 ++++++++++++++++++++++++++++++++++++------
>  fs/btrfs/fs.h          | 23 +++++++---
>  fs/btrfs/inode.c       | 10 ++---
>  fs/btrfs/scrub.c       | 16 +++----
>  fs/btrfs/super.c       |  4 --
>  fs/btrfs/sysfs.c       |  6 +--
>  10 files changed, 133 insertions(+), 103 deletions(-)
>

This patch looks reasonable to me and seems to work as expected.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
