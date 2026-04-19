Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985A8282F38
	for <linux-crypto@vger.kernel.org>; Sun, 19 Apr 2026 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776562613; cv=pass; b=HTHRzsd80eqwLRm6hBq7suJ4wEi33L3UOh7dEjUD9oeTM8kwLAY3xkepcAM0kZLvUoluk6xFu6NymqLPKnP6K5aLbOYk//ZDIRw2kNMwdyQbZQ1XSrmUWZROsIUNLgs10HLh68eMU+Gwf+zM+M2/komQbt4YHN1Y80/3pJ1O+FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776562613; c=relaxed/simple;
	bh=SIuzGJEOyfdQbVHrkN9auEfohxql8b/XIH1Ni0aYNGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0/rgI+HSzK6y6mNg439VNtz2fMeOF33jm8BgEw+h8/OA6/PUWyPENMxloGJYiSWXNlqArNjJ4MlWCi+GXLMgUocrn7Ktl/mlihlGkG1lMcLTqBKoK8F1Ku+KYg9KdIYX8mZynMBQxd4Mey5pnqu0EqYgKaNRq/uo5NOmtd01sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etdYbYDR; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etdYbYDR"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e4ad756bbso6415631cf.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 18:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776562612; cv=none;
        d=google.com; s=arc-20240605;
        b=e4FFJcSnb2jeDEcGEpM5kRTRQp7AoaLzLGbpt+i+Zq6SZfGW31mBMI23Z11xY8935p
         b0G2FD3bWgIZSn/mFQH4KH12QZm6kMsImUAYXfOI+X3M7puHUaBmgm5l/8AZ4bDkWMIt
         d/jBmKJORQkbfKyDnT/AkjEdVtqL2iSutXVK45aZMcG7117iujyZUDSERt91JAlqpBDF
         1NHNOJBpjQCx1POy4HDWp4MqsJ1hLUepMu6BKa8aiXbF7wvUCaOMcaCy++nf1ClAzZ7y
         He1ZaqcEd1goNa+VnrDy+RCdWurZb2+Zs1P7mie7bPC7wGZb8/6hjgu3/2q+J/YdgST1
         fKxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        fh=5AZ7bgyG8BDphCgb62xouVHyuuNFRu+qg9M9VS0ipOM=;
        b=G/D+lU30HXI9rUfepL/F/y7a88AH8CVn44scswzH5v6dDdqM87rQ5451Z6zYR4X1QE
         jPSwrGnqe51UCtYVKR32694/v1rIj9Tond3KQAq1SXhSqoV67aHy1HnAbSWpPRqIvp97
         Q7eD4SdEaFR17IpXiAjrZJ2cqgHMlv9q2UvMYo8h7gUSyhBl9+2maa47eMlq7APKlyqZ
         eYxegLROosO33NiW5I+kw7XBVeoMY7558FqDbZEjpp2Tq3DFzCiI/Bz/r6pRlCZUUI85
         WGxHGIz8D996W0TzqlJernaX3lsD0YuCg36m9cj+Fn0b+1Wp6AbunENjn+qBafd/5P0y
         JwRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776562612; x=1777167412; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        b=etdYbYDRX1im72blh0xBhg8GPKvbYNqT+oGPIbsTa13vy3aB7hiWcEWCgmHQn1u4WB
         k31CXU6X3S2pbga6g89zBNZiCXxM7KPUC41lpasQIcVfOVYL8Pb5R70NMAjZh7+QV31t
         Mu/xhq1ewkerh3KzI3TP7z4er/++73tKqady7Kch+jcA1N2tV79aqmwQ+2nFBmg1I7Fe
         Cj9EFf0XVrAutsmbKzUDU2/0BF866alu5BM1Lb4mJ42PzMYbeRG774jbXuGFPNosZVnF
         AbzJZg6wZnpx49PFkV2mZPoMX+8M5fKT0RVRIyYI6Oy6qxfQMG0Nx22UkdflgLiJHCMH
         7VyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776562612; x=1777167412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        b=WHXrkQqkDRPabfBFazWC6mIHHk+kbA40jm9xdNANVL7QYnPjEVLTbSXwgMxPs5Zu5+
         i2Uxv9P7Ocu3E40E4x9HY5JaDD+W9J6Pr/JCVt6LDQPoC4vdIrIglvlBfWkEpvfW8Tw5
         tBlKj8W1c2lp7PKRETC5R7zh84nTtC6mmhMEsBzoOzYL7eFrytk6ssvtTJHcKpH38xkb
         VVRkHUjusFdzG5ojgulWt+TEjIFNd4vUi7S906fs80pWtaN8MUjDb75/J/9EeTF8TGgb
         FYNwAGkUh8e09l0e8O5XKGVd77WNKSqgDKWnCv7ffSWA/C5FCMTrZxiHZMUBr0yCHE6W
         ZVKA==
X-Forwarded-Encrypted: i=1; AFNElJ8/H8ps8skeXCHBxywjWmNwYV74a/omBJxT0AVaWKFsmKqnd8PRGVznphT7R/0Fg60FKzpDvzHnn3aBiJM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCGtFf8/Ua7eW7OuJdud9Ihm5EQBK+u/UDZQI6OhpUcnzPVfgP
	nX18YW9URRXW/+WaztZ6jFW94w7nSKUMnQAnmclkFFYjoZLmKsYRwYvEzEjLO0UUsqTPonV/IBR
	BR6bVO8591bU//bCvjSpfz+GLmHtIE90=
X-Gm-Gg: AeBDietmQcjO0vnSYtM0UuAmDmJxy+wuWI95DD/hf6Y0vd22tXh9DJpD+mLJ0n9OHr9
	L7NpYwMDcNGdvWpUM4+DFOeREgWItM2g53SA7wzJpyma2h4OXa4PjkoDjscVP0cZB1iqr1f910W
	BsormAXowGNL1vrflXz6npFcXLhM8gBhM/9/vUJbQwvFsVMK+0dHbZms90jASRX353fFY4YeYf6
	XIrNryZXOaQTsMzc6s2/N1nZRkgZcG8c6s/YmW+hDCmNFFk7ezfNu8Qo0/+fbsAnG6gm3AJxz2M
	6+zZp9F4zb0RhlpZk43riYu3O/mvs+wNXLn+6C8fksWl1AD1IHGsR8tQoq0gZZriue1dQIllwXb
	AxeItC5K3o8v+x/4RQIDiIolTs+K2sBskxbH6QWEsLWyQlM1x68yjIPZ8/exQW1VlsFLsOjBl3I
	yFKgCVr2vlheAWBeTxoVllYc8V8EuSLLMT
X-Received: by 2002:ac8:5807:0:b0:50d:7504:b719 with SMTP id
 d75a77b69052e-50e36ee7aefmr137108941cf.52.1776562611630; Sat, 18 Apr 2026
 18:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418221311.67583-1-ebiggers@kernel.org>
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Apr 2026 20:36:39 -0500
X-Gm-Features: AQROBzCK7srreg0o2SXwUbTa33baOj43xTQYmO1CQ0YZRMqB_en4VoZsbvby9rI
Message-ID: <CAH2r5mu-zJa_N_NJERuOrAbS4RnKsaMTroZs6Nxdtd9CNGo-_w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] smb: client: Use AES-CMAC library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	linux-crypto@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing and review

On Sat, Apr 18, 2026 at 5:13=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This series updates the SMB client to use the AES-CMAC library functions
> that were recently added, instead of a "cmac(aes)" crypto_shash.  As
> usual, this simplifies the code considerably and is much more efficient.
>
> These patches were originally sent as patches 8-11 of the series
> https://lore.kernel.org/r/20260218213501.136844-1-ebiggers@kernel.org/
> The only change from that version was adding tags and rebasing.
> I also added some microbenchmark results below.
>
> This is intended to be taken through the smb tree, either 7.1 or 7.2
> depending on maintainer preference.
>
> A few microbenchmarks that demonstrate improved performance:
>
>  - Total cycles spent in generate_key() during SMB3 mount
>    decreased from 20640 to 10780 (3 calls total).
>
>  - Total cycles spent in smb3_calc_signature() during SMB3 mount
>    decreased from 177620 to 73180 (32 calls & 4255 bytes total).
>
>  - Total cycles spent in smb3_calc_signature() while writing 10MB file
>    decreased from 27551180 to 26628360 (10 calls & 10001392 bytes total)
>
>  - Total cycles spent in smb3_calc_signature() while reading 10MB file
>    decreased from 28390900 to 27879340 (14 calls & 10001781 bytes total)
>
> Note that my "before" numbers were taken from current mainline which has
> my changes that made the "cmac(aes)" crypto_shash a bit faster as well.
> So the speedup vs v7.0 is actually even greater.
>
> Eric Biggers (4):
>   smb: client: Use AES-CMAC library for SMB3 signature calculation
>   smb: client: Remove obsolete cmac(aes) allocation
>   smb: client: Make generate_key() return void
>   smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
>
>  fs/smb/client/Kconfig         |   2 +-
>  fs/smb/client/cifs_unicode.c  |   1 +
>  fs/smb/client/cifsencrypt.c   |  62 ++++++-------------
>  fs/smb/client/cifsfs.c        |   1 -
>  fs/smb/client/cifsglob.h      |   7 +--
>  fs/smb/client/cifsproto.h     |   3 -
>  fs/smb/client/misc.c          |  57 -----------------
>  fs/smb/client/sess.c          |  11 ----
>  fs/smb/client/smb2proto.h     |   1 -
>  fs/smb/client/smb2transport.c | 113 +++++++++-------------------------
>  10 files changed, 53 insertions(+), 205 deletions(-)
>
>
> base-commit: 8541d8f725c673db3bd741947f27974358b2e163
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
