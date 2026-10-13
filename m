Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470994BB263
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885651; cv=none; b=Mtcfxd73C2o21IMQHmHapvhxOU12Ce6RrZ6W0NMZ1UstFNVBOhZkUZzfX7Zl+z2suGSSwsYtgUbaiiLHifTThmT9irhpv+Togfi2i01VJ81LpswgE8j4NsPbkMGju9N+7CZ4R0BDpYbkRssx0ZiXRQ4vElvIWX3DfA1bmMDY9SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885651; c=relaxed/simple;
	bh=XnVrhANqeuMVIu0XygOlFG8ZPBZkKQaNjD3lYtvQ9wY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aNCpxSlp3PXj2vFFWte62u2DktzKkVNVbrocPH1jDLgZIcOmiIEmExKdBAuf+QbAUIQpjSCYHdOtZxNuY+VvPl2mTNZPuFv9hcc/2Ptc5QVN5j4kHNkzb/oqCF3h2boe+n9HobwNnRBY/COQOyZNutmQrQxgylMvTM8DOaiZ2Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2a4e013a44so407942366b.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 03:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885648; x=1792490448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XnVrhANqeuMVIu0XygOlFG8ZPBZkKQaNjD3lYtvQ9wY=;
        b=noQgWhjelGE8t6TMU+pmYeQ2OcRmPTxrIqAjTsAV8M/kS64AisusAwHJE9VzHIT8HV
         SfPqspnyJlEAhZLFATaH3S6pwPOzMPKPEUroZ8KAS/Ca0O0W7Orv7kO/1/wC2GiQqjYd
         Jfa7uQTfGaIfUs+KbJcErzu0VxhtEIRx+mDbfsMtJdq9g6LAMchI37tw/UOFZ+ujtQGZ
         H03wm9SSxofDob01iMFibNfrTqlhPapqbYQgy3hC9Ql+8mWO/b/yThp/JGkD7xKS18Hh
         UNggK1CsN7dPzRP4CjTaO0ykzjDyhJpuAIAhBn9TV0AMWpi7bXPaejSW4DnvY9s9CHo8
         IbsA==
X-Forwarded-Encrypted: i=1; AKwUvBxYC6dTe/EAnwpr2tpqSprHXm80cfqTaHOWsSgkBdOseFkMaL0mXdbANLkpfEdot15V8PanQPwLz002kMg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKUn7khyh/uthsktc7XmT3WfMDhSZ5/QLZQcxGxumskLx2g15KZ
	b78uVQ9fM7MVgM6yXjVDFd8jPBHxguZwajpXzFF9mjDyWBngAcOCAbASqw1qB1tSPqU=
X-Gm-Gg: AYBFou2TDn6aOFkyRbw4l12lc8YqgN/GruMoOoJENsIjUPyh7EyNyjQjGxXPbwtpQJP
	Ep1CJ6Ugu38B8dkA8B8Tc01XkdLMuJGjk1bFH9MjYnOzg6HAh4olnbOZibqo6D23dY7e4FOQ/on
	PjCCtfwGIEsn+uiFjwKiSxGH41VpqVjU2XxdenEiXnx/8so1kQeeZ6gL1appJc7jq4GRGxngvny
	EzAtbSy3jXFm2/QfJ/bFIlZPcldf19tuGxzOPhp56guZQMOa5S7P2sbWDVZ1Aglq6LZElBx3F9s
	2ZGPxAvkCmSp6yedStbiKG0zn7XY3AnMTYmr+OY6YQpQGNChxkLDZQmsfP0JSYZhrAMISOUt+ZR
	zEifKyYuXfCV+sSc2OYV9Ormf01lRFDWf7lcDHA8olO5US/XamslUZTZ16BX7cVbvjBU9exDk+T
	Heg9BblqAsMwXDlIdT0fGPAJPTF16d0GlTsDe09gCNZVtVAQbPnxtKI4ravqxh8tyjx2vfUsT0D
	gqH2ayZEFNPQuKi0uD03GG1VJhtFA==
X-Received: by 2002:a17:907:969e:b0:c26:19de:9ae3 with SMTP id a640c23a62f3a-c31a9fc13f3mr1219903966b.34.1791885648000;
        Tue, 13 Oct 2026 03:00:48 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ae46f0sm569476266b.79.2026.10.13.03.00.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 03:00:47 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c37b612635bso1300766b.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 03:00:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz/tWRBYNcktk3hCijAwGmf5m3/IhaxQdiHb04kdXH2gVL7lzi7HH5ZlILfAZeSlGJT1F6YY2ZvBIuByyc=@vger.kernel.org
X-Received: by 2002:a17:907:9411:b0:c2e:3464:6e36 with SMTP id
 a640c23a62f3a-c31a9ff9da2mr1106851466b.41.1791885647302; Tue, 13 Oct 2026
 03:00:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928042641.307683-1-pawliczekerwin@gmail.com> <asMaVj3KFINl3je0@gondor.apana.org.au>
In-Reply-To: <asMaVj3KFINl3je0@gondor.apana.org.au>
From: Ignat Korchagin <ignat@linux.win>
Date: Tue, 13 Oct 2026 11:00:34 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVXSTC9jx0+aHJ1Qqu+SmenpG7hFboE6cU0Q53esg9f8A@mail.gmail.com>
X-Gm-Features: AclHuK_tAyYWHxgKHcntS-y-sSXdDkZXIzV1YAVb00w5795MU7hR46YRHM7QTf4
Message-ID: <CAOs+rJVXSTC9jx0+aHJ1Qqu+SmenpG7hFboE6cU0Q53esg9f8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Use constant-time modular inversion in ecc_point_mult()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Erwin Pawliczek <pawliczekerwin@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Paul Louvel <paul.louvel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 4:32=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Sun, Sep 27, 2026 at 11:26:41PM -0500, Erwin Pawliczek wrote:
> > vli_mod_inv() is a binary extended Euclidean algorithm whose branches
> > and iteration count depend on the input. ecc_point_mult() uses it to
> > invert the projective Z coordinate, which depends on the secret scalar,
> > so ECDH leaks information about the private key through its running
> > time.
> >
> > Reimplement it with the Bernstein-Yang divstep algorithm ("Fast
> > constant-time gcd computation and modular inversion", 2019,
> > https://eprint.iacr.org/2019/266), and keep the old code as
> > vli_mod_inv_vartime(). Only ecc_point_mult() uses the constant-time
> > vli_mod_inv(). Signature verification now uses vli_mod_inv_vartime()
> > because its inputs are public: the s^-1 inversion in ecdsa.c, the
> > inversion in ecrdsa.c, and ecc_point_mult_shamir() and ecc_point_add(),
> > which only they call.
>
> Last I checked we have no in-kernel users of private keys at all.
> So does this actually have a real in-kernel use-case?
>
> In fact we should probably strip out all the unused private key
> support code from the kernel.

This is not unused, these are used in the supported ECDH algorithms.
Hence I was rooting for ECDSA private key support anyway, since we
have all the blocks.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Ignat
