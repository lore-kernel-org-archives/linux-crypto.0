Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBED18C008
	for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776014148; cv=none; b=B3foiinOvYKuYf491xO4l5I04CXj86pE6rhWR/BGkxRioIVGBwL0F+3N1Pgo93d5umPv6nSLrg/NNBbWIijgRJ7z1cEo6NenuJjltP/2DRFwiXqoqXEt0GhWk2/DBWHyvESo5EMichOZJjvclEgb5uOd36UzBG+XWz4kjEZrrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776014148; c=relaxed/simple;
	bh=IxNbGI88uQ1p8dYK42akaQTfhd9KSN7hbXKIb7H9SMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBDngK3oRKit9WGS4nlJ9dmc+o3daHNC+5+nGgApYY4nm6tTg4+qJXXgSfb8lXKB75D+2t/uIWWNVQsQZ2PMB11CphgWGsFO199U9vhGk7kJBFWCxkx+YWtEGneDfJGPRkLiiaRnviRXsudl3OVlGGru0kwtSvB+NUc3cZPCWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-66ba9dfe83bso4730769a12.3
        for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 10:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776014145; x=1776618945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uf3IQutPFxq5lhwnJCMynPep7nBDNY5tp9FNBCtFxQc=;
        b=hJL3BF7E3Oc5kHyRVxdLCYGx/Rndb7w+ow6XE2mNDPdQgYB4HWwZGI+k8GaqSlqFbX
         KGIvodF+mIt9DumTKCVozQck9jUunREwhK6DWZ+z+AHnFErtHAcQsEgpDGFwa0o4zQgN
         dHf7wxgxwa01AtmOIb0YmtZ2ZNklc4fT0jUrzWLd5XAfWYM40898rg+3+pe0log6R2P1
         vNyngB3CCkgZnbLlGvYwEY6yXgoXdqm4ECvR3Umb3fl2BKlnpwxVrA6qjqxegRzqb0BJ
         U1VsCLtu+kPcNXv49mrIbgKuefKHrBbN00YSMmKffFyrszhzrilLHy9DQ950kn1aRbgJ
         Hkvw==
X-Forwarded-Encrypted: i=1; AJvYcCVBZpnvbMnRHzfvWCEN230NEG26uPZ2dzRuXYPIEoy5SpFSZWns7dTcCFSece/2ZU3gB34kt6901zEAl3g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmsmupmk1YJWVxLvixDqD4xyGgNVS0Nx75Hzq5oXNfjtkdqkLc
	RWmafJfpceeRPyaLL4yX0zqXxw6qHM2xYt+OAFkrQEMFVZYtqOtkKUz0bnfPE1PITYk=
X-Gm-Gg: AeBDies5UxLkyDjSy1O8n3Pftr56LE14VijsxuKE1PNkAhfkzm3xtoWc83/H2ZkLDPF
	PBV+OwiHONTNMBikCT/DISPTJSSvDhvH3Q0O7Jm0IA0HqSrjXq8G3t3r7qIPImoE0Wu42KyRfVW
	09xxGT4xg34UBGP0ohHQiAYPAcnxrpGXidwz6g07Fcqq+IAwz8ctXluANK24uhNq6zlw9ZUXdFh
	Ls7MXmAUnJ8OQTvWVIrYYL3CMbcHom5UA2/shSGjSG/UmkAYAIjiHpSXYJy3cG6xOr6smELyR9w
	hgqw2KNpsvUFDLMRPo/5dAKzwadaQAAg6nVqpVWbSXT/SBR7b8WnIbdgpZuefh9G5EyOCvzXQwY
	zG3VORMYdLNK1ChwQdNqUxMVV1u/HYNhWt+E009CFOm6CKPYa1MLPJYvp1rU+UKupGJ+zMjbt3S
	9mz7RMTbScbsHhpk5tjAw0DkHZ1YmQ/0qb4w+iZyMmVkRkCQNWnEk0Kw==
X-Received: by 2002:a17:907:1ca5:b0:b9b:452f:fd9 with SMTP id a640c23a62f3a-b9d724c9dc7mr643254666b.22.1776014144686;
        Sun, 12 Apr 2026 10:15:44 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6de9b414sm254561066b.6.2026.04.12.10.15.43
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2026 10:15:43 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6718ebdf877so44939a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 10:15:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8OgKMiK05dxwfLkRV+aYoZJk73WsEf5yay4MpL9/uZ5AkbVC1lMqhektfhp31Uo5RFLKdAUJ7NJfFatDI=@vger.kernel.org
X-Received: by 2002:a05:6402:2486:b0:670:65f0:59ca with SMTP id
 4fb4d7f45d1cf-6707ab3e6dfmr4742343a12.26.1776014142829; Sun, 12 Apr 2026
 10:15:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
In-Reply-To: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
From: Ignat Korchagin <ignat@linux.win>
Date: Sun, 12 Apr 2026 18:15:29 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUBaO5Wus0ji1ciKj24RLaS6EiMjn6aq-KCjTBtsSQ2tA@mail.gmail.com>
X-Gm-Features: AQROBzCENbSgLpQSeJ5jJvlNmjwhq_3I9KF3io2MOo2k_d_J7GqzSSDKThYG7AE
Message-ID: <CAOs+rJUBaO5Wus0ji1ciKj24RLaS6EiMjn6aq-KCjTBtsSQ2tA@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in mpi_read_raw_from_sgl()
To: Lukas Wunner <lukas@wunner.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Jason Donenfeld <jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Yiming Qian <yimingqian591@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 12, 2026 at 3:19=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> Yiming reports an integer underflow in mpi_read_raw_from_sgl() when
> subtracting "lzeros" from the unsigned "nbytes".
>
> For this to happen, the scatterlist "sgl" needs to occupy more bytes
> than the "nbytes" parameter and the first "nbytes + 1" bytes of the
> scatterlist must be zero.  Under these conditions, the while loop
> iterating over the scatterlist will count more zeroes than "nbytes",
> subtract the number of zeroes from "nbytes" and cause the underflow.
>
> When commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") originally
> introduced the bug, it couldn't be triggered because all callers of
> mpi_read_raw_from_sgl() passed a scatterlist whose length was equal to
> "nbytes".
>
> However since commit 63ba4d67594a ("KEYS: asymmetric: Use new crypto
> interface without scatterlists"), the underflow can now actually be
> triggered.  When invoking a KEYCTL_PKEY_ENCRYPT system call with a
> larger "out_len" than "in_len" and filling the "in" buffer with zeroes,
> crypto_akcipher_sync_prep() will create an all-zero scatterlist used for
> both the "src" and "dst" member of struct akcipher_request and thereby
> fulfil the conditions to trigger the bug:
>
>   sys_keyctl()
>     keyctl_pkey_e_d_s()
>       asymmetric_key_eds_op()
>         software_key_eds_op()
>           crypto_akcipher_sync_encrypt()
>             crypto_akcipher_sync_prep()
>               crypto_akcipher_encrypt()
>                 rsa_enc()
>                   mpi_read_raw_from_sgl()
>
> To the user this will be visible as a DoS as the kernel spins forever,
> causing soft lockup splats as a side effect.
>
> Fix it.
>
> Reported-by: Yiming Qian <yimingqian591@gmail.com> # off-list
> Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v4.4+

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
>  lib/crypto/mpi/mpicoder.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
> index bf716a03c704..9359a58c29ec 100644
> --- a/lib/crypto/mpi/mpicoder.c
> +++ b/lib/crypto/mpi/mpicoder.c
> @@ -347,7 +347,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, un=
signed int nbytes)
>         lzeros =3D 0;
>         len =3D 0;
>         while (nbytes > 0) {
> -               while (len && !*buff) {
> +               while (len && !*buff && lzeros < nbytes) {
>                         lzeros++;
>                         len--;
>                         buff++;
> --
> 2.51.0
>
>
