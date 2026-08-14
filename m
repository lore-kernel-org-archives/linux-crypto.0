Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFFF46A618
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 13:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786712908; cv=none; b=dmgWTzWQFb98oCZcAD2TJ1rlQCVHNpRz7TMohYbZJqBTgfopNyX8fHyd7eczsr7GK2640OxWzWbZ4B2M3l/v5BZWhCtziqPg73omGnhSo96+wQLOmcIV08PygM3ML2LzWKx0iuu4CS2/Q0uMDpT5ISce89Qvg4ayIFRLOc8ATV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786712908; c=relaxed/simple;
	bh=D+oA7XXUEwK8Vgcr5JtNxTy8Y5YNvhfR+mG8F/ppQbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFmduwQj3qdl/o55sb3vHMuJQU/uQo6rubwZ7lVh6xiVu6wec+hGu67qjRPYNAbzFcsqEHgT8kIadkIQ/0dSDI7w2WPG5N3fYQLVM8RcktKt+A947gcyKsoEphXE5+qp1/JUuZjgRENALQMLs/JPqpONrnmWQ/F4/tN6L8mfqzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1677c91969so127076766b.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 06:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786712905; x=1787317705;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HpKsPUcvfKXegQzg7KkqL+Bcp0KZtYbTU/PRYTZP8pU=;
        b=VlkT16N7TqkdX123Ey+4H9wUvIseQUInQv4f7rEzDdCScRPWVkHNjVHzX9vSyT2SGz
         bVBokUoFVfiIK0QboAHnJ6sfMQkgiKTfn3zgL/1JHpVaG00Wewqrqkaf4l5Q/e1mpLkH
         +BuHPCJHQdIqlq8rms71OKmIgbzI2rAFeJytoLH9SZ+WKWZTyS0bnCQVQmwgqMZ2ev3P
         q/eO32/IA77TDgjcrZg72H49U/TApaEmR510Pl9fbOS/JIwoAONDAnTCK736fBi9mhRw
         lJqq9ynHL617tDJlmIX4G9QENz6yY+IQXkAJiPFRM0d7V/NSZBwe0js5WaM99tN68iV+
         e9Eg==
X-Forwarded-Encrypted: i=1; AHgh+RpXiOBhT2kZc+XiIMUD0h+iJeHZraftF+Rx/ps5fNbeKsJmQhLT5pZg2G7j5v12nSrmW35Bx1HhWrOrqhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYeAxz0SpPAMo2DmRhnCwvmmnIWl0nQUVkT8QPGCVBa2gxk44k
	fu8tc3MDe+DPug4X92FpTK1/QlVxcWZMVnoBji70DMv+tlpiYn1y8V2mK8688L4IriM=
X-Gm-Gg: AR+sD10u/VBwF3eWcpWPwq5OkaH/nT6T04hGKcEVvFPbOTzBTTM8f/jkEkCC7rHFPhb
	XSh2AcM0gGwmOGWUdEwhcqj8pz4xiciRiKXGMefquVDBQAkVZIBQDgJLnmS6xN8+N9RYnDDt6Ds
	Z9QJ8vB4T1rRZ+1WYOCwh3STcwyiaxe5gd7F10upTDpAJsBGcqF8jswQXv7CcOPjKcFUOD6TmF3
	BOQ23PTq9WUbMwPgJ8fmYMOZLhtpgdbZuO61zcvIoe37Dhu3F9C0sfDyTELAfwWLdfxppzMjKpo
	YHAkeM6xztlQoxnfpm6zDE3uJyJW8Vndjx5RJ91f/HSUGD8ELmkSKZDlfZoS6E17qKkJfAwMK0o
	/XrcyMO7mixKcDGV8iy2YJDX0BC110q4Bk3E4HVHxcOdPi3cdU420+E6DeBAJWBtoQ33KvxxP7T
	/dMZsJaHqVBR+Phhuuk6oRXdQ7ZGj7i/p9hXc1QS+XjLqgIg8Z/FzgeGDE7AwVUXPrIiIHLX7JE
	BdDVWB6/bt12LBDWr8=
X-Received: by 2002:a17:907:80d:b0:c20:83b0:92d8 with SMTP id a640c23a62f3a-c21295e749amr262043066b.0.1786712904525;
        Fri, 14 Aug 2026 06:08:24 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c21233a28c8sm103829666b.4.2026.08.14.06.08.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:08:22 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15cd3fd760so122254266b.2
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 06:08:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrG15v1dZXnUp3RDjOVT3JZH7fI287skJBauMk4QqPzQKluxhz9cnZB/1McXRIHde8/uYJCwLD7365oA/A=@vger.kernel.org
X-Received: by 2002:a17:907:980a:b0:c20:eea4:267c with SMTP id
 a640c23a62f3a-c212a8b725amr256899366b.30.1786712901999; Fri, 14 Aug 2026
 06:08:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813165654.36098-1-fabrice.derepas@canonical.com>
In-Reply-To: <20260813165654.36098-1-fabrice.derepas@canonical.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 14 Aug 2026 14:08:10 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVztmvHSkNxP_voc7E=girsstCKmqxG37pvO2kTaEk1TQ@mail.gmail.com>
X-Gm-Features: AUfX_mzBSOfXwtJ5pD6mo8sbrCNXyHrVNtlB2GQLFDuAwYnXUpBucQGGaS7Lzek
Message-ID: <CAOs+rJVztmvHSkNxP_voc7E=girsstCKmqxG37pvO2kTaEk1TQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
To: Fabrice Derepas <fabrice.derepas@canonical.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 5:57=E2=80=AFPM Fabrice Derepas
<fabrice.derepas@canonical.com> wrote:
>
> pefile_parse_binary() reads the size field of the certificate table's
> data-directory entry, which sits at fixed index 4 of the PE optional
> header's data directory:
>
>         ctx->certs_size =3D ddir->certs.size;
>
> but nothing ensures index 4 is present. n_data_dirents (the untrusted
> NumberOfRvaAndSizes) is only upper-bounded against header_size and may be
> 0, and header_size need only satisfy cursor < header_size < datalen. A
> crafted PE with n_data_dirents =3D 0 and a tiny header_size therefore cau=
ses
> the ddir->certs.size read to land past the end of the image (CWE-125). Th=
e
> chkaddr() that bounds the certificate blob runs only after this read.
>
> verify_pefile_signature() is reached from kexec_file_load() (the
> lockdown/secure-boot enforced PE-image signature path), and the image is
> parsed before its signature is checked. The trigger needs CAP_SYS_BOOT an=
d
> the access is out-of-bounds read only (no write).
>
> Require the certificate table's data-directory entry (index 4) to be
> present; the existing upper-bound check then keeps ddir->certs within
> [cursor, header_size).
>
> Fixes: 26d1164be37f ("pefile: Parse a PE binary to find a key and a signa=
ture contained therein")
> Assisted-by: copilot-cli:claude-opus-4-6 frama-c
> Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
> ---
> Reproduced under KASAN (CONFIG_KASAN_GENERIC, x86-64) with a KUnit case t=
hat

Any reason not to commit this as well?

> builds a crafted PE (valid MZ/PE/PE32 magics, data_dirs =3D 0, header_siz=
e just
> past the optional header) and calls verify_pefile_signature() with a NULL
> keyring -- the parse runs before any signature check. On an unpatched ker=
nel:
>
>     BUG: KASAN: slab-out-of-bounds in verify_pefile_signature+0x1d6/0x950
>     Read of size 4 ... in pefile_parse_binary() (inlined)
>
> With this patch the crafted image is rejected (-ELIBBAD) before the read =
and
> the case passes with no KASAN report. The test is not included here; happ=
y to
> submit it separately.
>
>  crypto/asymmetric_keys/verify_pefile.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_k=
eys/verify_pefile.c
> index cec99db..e7f8bdb 100644
> --- a/crypto/asymmetric_keys/verify_pefile.c
> +++ b/crypto/asymmetric_keys/verify_pefile.c
> @@ -87,6 +87,10 @@ static int pefile_parse_binary(const void *pebuf, unsi=
gned int pelen,
>         if (ctx->n_data_dirents > (ctx->header_size - cursor) / sizeof(*d=
de))
>                 return -ELIBBAD;
>
> +       /* The certificate table entry is at fixed index 4 of the data di=
rectory. */
> +       if (ctx->n_data_dirents <=3D 4)

My agent suggested replacing 4 with offsetof(struct data_directory,
certs) / sizeof(*dde) to make it more obvious, however not married to
it.

> +               return -ELIBBAD;
> +
>         ddir =3D pebuf + cursor;
>         cursor +=3D sizeof(*dde) * ctx->n_data_dirents;
>
> base-commit: 3d6d817622b0a9721e3cc404df3469171582be13
> --
> 2.53.0
>
>

Ignat
