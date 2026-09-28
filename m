Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9015D4B7A32
	for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596517; cv=none; b=SlP4Uv5yBs3ppu4m/WYqEpKS2MzdctKKiv1Yuoz6Zli6F69avJtvQfeVowEBjPwy+udLOr23Keje8V/nUYShzW7gXpoqhctgKCGR0zx3yI5Sye916zDQ4yq8L4tccTOcQWPUJ2aQhvE2X0RYgx5XbonGraoff4z+oAQZlALSAn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596517; c=relaxed/simple;
	bh=cQAChtepgMpC3QAC/HxIQYzzUCwW6JkrFd27BgpOpRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b39QuaSW1ROlC9Vc5fso7OYym2+5Pe2Oiu/Zp6uHWjG3zG6HMQT9ym7EhA/R7eXIkmOxP1LtkXYkwaN8d0ZAXtOUPJk+k8Rwb3ICNzpmi3Jmnlg/4aXJEautcGqSC2CDdcjEBXWSuz+fN59Nt5OkBmQm0axqXVUbNrqPQLRIRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2da4eea067so206161766b.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 04:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790596514; x=1791201314;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QRj08SUQ00B6c/vwfuBc/4g/UNksF46V58efjI36W1s=;
        b=dpweD+1rbt9Ye85llPaKNGYyoasJmxtDbseUQgAoIx5fq0duxPkEEIiqr0yEWEh2FB
         s3VTqEPCysEZu7PP97r0z+0627XtYAZhQQAqLLmzlQJAca9XRDOYciiRduK+ysw2KVyl
         oxqEKAm7Xz4i9EIPXtg0A6pbVcDuRyBHBI/qEVbxauo1gH/5Sa6rS3tlkL/QX5S4QKvf
         G7bgVX1ISYjUjPRwH9ghYlAnQpBxOE7gmQENYr8OHgAL8RTiahiDQEEp07s/s0nRBOzX
         s9491tcmFGAzr1I6f/HowYB1orInDhXOSbV9PwrmyctCpilRqTDGGirpMwwlT+K/FCdc
         HeDw==
X-Gm-Message-State: AFuF++msSRH1RkiPdab4tYPsHkWCsLUQFtptvpo9e+QtNkCRcs4nZUJJ
	h+X3Nx+vVVPXykyTGWn6c4LP8NapESWVSuf4j5GEWwWSavBejfBwDXk3bD/t5XAugJo=
X-Gm-Gg: AYBFou3hnvFDfNat2TDZZXZvRv4DWrvM8q/BycjxYel4QGMd9nsml71Dp3T1k5D/2HF
	dkbrhXm2G8CvEBYHNuRVSaYbQhYEFQdQFKKaw/sO7Su7tCn250LSNumdABeHtd7a+MW5PhnATHH
	6PK5TsfihkKhMLBZzzmJmbaHcBAF21Zk2wbr9fQuDpwZJdnxtSgVH2iRvSEn+mTuFvm1n2oFkHj
	dsoAPaTDI0S2J4AeYznlMyr+rJ8svyvWwzXp2ly3kCVrFgwBJBq/PzpU1Sy4R8PvGG4A5CNCnMC
	T9bGcASzOvW1MYmp5lytE4vdeVnpasPMLFKTdkL1q0WfzEOqn5LNAtcsubzMlunJw3CKFI5CUYW
	l9SSi2fgshuM26qi6iPIS5RZ7sYBRIWMCumqTBr0QS9HYOcG1rg8eFRbY1lt4ZafIvi06GViT8H
	Sqtmt1Uj81olZpCZqf/RATsoIQnMgjU+rv20jdqBbLLrMoUi2hHjJavpx63zrb8E60qkJemnWHQ
	qsxRf/N1tYWPyGpJirekOIB24U0llM=
X-Received: by 2002:a17:907:ea91:b0:c29:45f6:6a1d with SMTP id a640c23a62f3a-c2ac5507183mr975334766b.43.1790596513408;
        Mon, 28 Sep 2026 04:55:13 -0700 (PDT)
Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com. [74.125.228.97])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2dd1153f09sm176785166b.15.2026.09.28.04.55.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 04:55:11 -0700 (PDT)
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac6fa788e6so1570537a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 04:55:10 -0700 (PDT)
X-Received: by 2002:a17:907:c308:b0:c28:ec7c:27ae with SMTP id
 a640c23a62f3a-c2ac5396f65mr1010475866b.25.1790596507876; Mon, 28 Sep 2026
 04:55:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4a0b2e00f5cc62c173a01fec2f56eab1b04d70bb.1790568982.git.xuyuqiabc@gmail.com>
In-Reply-To: <4a0b2e00f5cc62c173a01fec2f56eab1b04d70bb.1790568982.git.xuyuqiabc@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Mon, 28 Sep 2026 12:54:56 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUaq6W_TBh-rThhd_N4Aj33sndvYhEA6=zOVGBbz7NP4g@mail.gmail.com>
X-Gm-Features: AclHuK_Wg6kgdXGN_cBEZ2B8n--Ssk5P9tVcVa6IjqC_p1OFoCo87o4XkTq72pA
Message-ID: <CAOs+rJUaq6W_TBh-rThhd_N4Aj33sndvYhEA6=zOVGBbz7NP4g@mail.gmail.com>
Subject: Re: [PATCH v2] KEYS: Account for asymmetric key payload data in the quota
To: Yuqi Xu <xuyuqiabc@gmail.com>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org, Vega <vega@nebusec.ai>, 
	Ren Wei <weir@nebusec.ai>, xuyq21@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 9:27=E2=80=AFAM Yuqi Xu <xuyuqiabc@gmail.com> wrote=
:
>
> add_key("asymmetric", ...) preparses the supplied blob and then
> instantiates the key with generic_key_instantiate(), which charges
> prep->quotalen to the owning user's key quota through
> key_payload_reserve().
>
> pkcs8_parse() duplicates the attacker-controlled PrivateKey OCTET
> STRING with kmemdup() into pub->key. pkcs8_key_preparse() stores that
> object in the asymmetric-key payload but hard-codes prep->quotalen to
> 100, so the quota records 100 bytes regardless of the retained private
> key size. The ASN.1 decoder accepts blobs up to 65535 bytes, so one
> key can pin about 64 KiB while consuming 100 quota bytes. With the
> default non-root limits (200 keys / 20000 bytes) a user can retain
> roughly 12 MiB instead of the 20 KiB the limit is meant to allow.
>
> x509_key_preparse() keeps the parsed public key, its parameters, the
> signature and the authority key IDs, but also charges a fixed 100
> bytes. PKCS#8 later repeated the same fixed-100 accounting. The same
> add_key() call reaches the X.509 parser, so fixing only PKCS#8 would
> leave the bypass reachable.
>
> Charge the size of the retained payload instead. An oversized PKCS#8
> key now fails with -EDQUOT instead of being accepted for 100 bytes,
> and the same applies to an X.509 certificate that retains an oversized
> public key or set of authority key IDs.
>
> Measured on v7.3-rc1 (10396a2d6d41), 2 vCPU / 2 GiB QEMU guest, as uid
> 1000, adding PKCS#8 keys with a 65000-byte PrivateKey field. Before
> the patch, 176 keys were retained (about 11.4 MiB) while
> /proc/key-users charged only 19712 bytes. After the patch the
> oversized key is rejected immediately, and a 200-byte PrivateKey still
> loads and is charged 264 bytes. A small X.509 certificate whose only
> large object is a 26000-byte authorityKeyIdentifier is likewise
> rejected, while the unpatched kernel accepted it and charged 109
> bytes.
>
> Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.5=
09 certificates")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
> Reviewed-by: Ren Wei <weir@nebusec.ai>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
> Changes in v2:
>  - Move the bug details and the measured quota numbers into this
>    commit message, as requested by Ignat Korchagin.
>  - Sashiko (High): "keys: integer truncation in key->quotalen causes
>    permanent quota leak" on pkcs8_key_preparse() and
>    x509_key_preparse(). Not changed. The truncation is real only past
>    USHRT_MAX, the unprivileged maxbytes is 20000 so add_key() fails
>    with -EDQUOT first, and this patch does not widen key->quotalen.
>    Replied publicly: Message-ID
>    20260920073515.64399-1-xuyuqiabc@gmail.com
>  - v1 Link: https://lore.kernel.org/all/cover.1789801335.git.xuyuqiabc@gm=
ail.com/
>  crypto/asymmetric_keys/pkcs8_parser.c    |  2 +-
>  crypto/asymmetric_keys/x509_public_key.c | 23 ++++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_ke=
ys/pkcs8_parser.c
> index 9dd1c181789a..fa8b142a8e14 100644
> --- a/crypto/asymmetric_keys/pkcs8_parser.c
> +++ b/crypto/asymmetric_keys/pkcs8_parser.c
> @@ -150,7 +150,7 @@ static int pkcs8_key_preparse(struct key_preparsed_pa=
yload *prep)
>         prep->payload.data[asym_key_ids] =3D NULL;
>         prep->payload.data[asym_crypto] =3D pub;
>         prep->payload.data[asym_auth] =3D NULL;
> -       prep->quotalen =3D 100;
> +       prep->quotalen =3D sizeof(*pub) + pub->keylen;
>         return 0;
>  }
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric=
_keys/x509_public_key.c
> index 25cf8ac7f257..f2bdd0244262 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -163,9 +163,11 @@ static int x509_key_preparse(struct key_preparsed_pa=
yload *prep)
>  {
>         struct x509_certificate *cert __free(x509_free_certificate) =3D N=
ULL;
>         struct asymmetric_key_ids *kids __free(kfree) =3D NULL;
> +       struct asymmetric_key_id *id;
>         char *p, *desc __free(kfree) =3D NULL;
>         const char *q;
>         size_t srlen, sulen;
> +       int i;
>
>         cert =3D x509_cert_parse(prep->data, prep->datalen);
>         if (IS_ERR(cert))
> @@ -228,7 +230,26 @@ static int x509_key_preparse(struct key_preparsed_pa=
yload *prep)
>         prep->payload.data[asym_crypto] =3D cert->pub;
>         prep->payload.data[asym_auth] =3D cert->sig;
>         prep->description =3D desc;
> -       prep->quotalen =3D 100;
> +
> +       /* Charge the memory retained in the payload, not a fixed estimat=
e */
> +       prep->quotalen =3D sizeof(*cert->pub) + cert->pub->keylen +
> +                        cert->pub->paramlen;
> +       if (cert->sig) {
> +               prep->quotalen +=3D sizeof(*cert->sig) + cert->sig->s_siz=
e;
> +               if (cert->sig->m_free)
> +                       prep->quotalen +=3D cert->sig->m_size;
> +               for (i =3D 0; i < ARRAY_SIZE(cert->sig->auth_ids); i++) {
> +                       id =3D cert->sig->auth_ids[i];
> +                       if (id)
> +                               prep->quotalen +=3D sizeof(*id) + id->len=
;
> +               }
> +       }
> +       prep->quotalen +=3D sizeof(*kids);
> +       for (i =3D 0; i < ARRAY_SIZE(kids->id); i++) {
> +               id =3D kids->id[i];
> +               if (id)
> +                       prep->quotalen +=3D sizeof(*id) + id->len;
> +       }
>
>         /* We've finished with the certificate */
>         cert->pub =3D NULL;
> --
> 2.55.0
>
>

Thanks
