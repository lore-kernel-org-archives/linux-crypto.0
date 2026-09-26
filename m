Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D172FE05C
	for <linux-crypto@vger.kernel.org>; Sat, 26 Sep 2026 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790432276; cv=none; b=P86wQf8FdglZIBocYylHbuP7TjcS/5dhcDpUKQLaEXJP6xTykeecRnE63VuHBEReMjzPbaVjKR2hoothmJf8Bf0Z1BvSDsIJkUQ5iajWbUWLxNHzHHzrjDcvlUIaq/0po48MDWmlyW3wuh2oyIpljKC5PI3ZYYNMGpFEaJwKWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790432276; c=relaxed/simple;
	bh=vf2QTi4KxlykMEh5veM7tyu2sJw9obTwFxi52JkGA8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HpvpGJAOvKIFMBbNPXF20+7exPeQDBjc2HsjO7HvRLbkdK0NHgYRzbp2ATiubTscFEmheOHcBrtydtWyk27NciBPAemI7baPKccc7yUSbuswXaHSrciwtz4tBNpaBuF5eowsvHbDlRqTHNSeZEyTJz/q8RA/28+G/qMMQAY01WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2afb4e9977so145577566b.1
        for <linux-crypto@vger.kernel.org>; Sat, 26 Sep 2026 07:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790432272; x=1791037072;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GxzjIQXEnb8M/kPF1Cslk3duOl1nSIWd2BBMXKiDMHE=;
        b=GWnQ4s4wfRrrK+MohyZN/AWbFrrwYrO8NxTV8H4BnIEtqOwr/dWqFyTk8+sL/M1BC8
         AewAc2FuueA+7e9OEAYdnurB70qLOR0PEl7Y2iINdkM0GRIOcYkEM8HIoJLWW2ZiDwkm
         uUEstHjrtX8KgxDHvklnARPaPIAVI7ZZRqWjlqRN7kyQZTKXln1GaC1yz+xZDhAh6t9z
         1cMRivj7+9CzUoqPEgkrK8wEmhmcaCp18IeQRWgvg2+IrxoPCUsYnq0eEMzwyb15mvz7
         +iWwGrqXGiRYFIyyV+MeSwEcjd/HK5/701Wg5U0PicOYtqgSlhLwC3TXr1h/8OQz3dg0
         f1wA==
X-Forwarded-Encrypted: i=1; AKwUvBwFDa3dDiUZqXUSJhlkpIO7Ud062uh7ZLHshy3hDLEvEdDSy0bgLPzirG1OMt72X/OkDYLDxU3dXEPrMvg=@vger.kernel.org
X-Gm-Message-State: AFuF++mhsPYurs9Kib4R0KpijtKql89mg86M2ZMAevcGOR+kaVlLxKCM
	ZKTqOyteWvr254nadZfHkzLU28Ef3PrBaXx7cblwSdewUNthrKOegupFn6OAaCRKxxg=
X-Gm-Gg: AYBFou3vlLfKynTflgSrc7rkhf2McOofaprTXOv1rV6qVNCHKkkD+9DlxqYPaFtzUQy
	gcXehS3TKEA2S7BqDOxLQMpRYlJfo1spSR9/CSzEN8xNFE40jzEbTH0UOChIQO6FjalU88RL/rs
	T1kuk5QcGXw/T3GbJlCaCKCzfaROcarD3vDKkqpoa56+rWYsKf+e5IvR14Qgw6COU4PtLzrunOd
	creJR1VxzZM0Rbx7p85MQhLB0LIf761gI9hSliVpuqPI1qhvbLHM8fccLtKUpxn5x3t+KzX4X1d
	VjpgKgqpm9LJBxGd+mDqoLH/g9QPAIwb1ElxcF1t2NotOZoQvzLMMNuaqwWvHk/1xV88kqHatRY
	Xyn17xlTLC/9YoM/hxMocO2sBe3/5g14BL0N9tcpdTZn4airdwciEWYyJTAIGK6wc/olTIQapIc
	ww1Rnah0nSA7keMJCY4LziktInAB+74TZ1lzYbOgPtjAtwEsYSbL/gfFlXs5xBzGwD0CTOpZhTR
	rNESGzGsIMQ4URyDV+cplRGJIe1ZJSnNBmgDe8+PA==
X-Received: by 2002:a17:906:dc95:b0:c25:4f7c:8ec5 with SMTP id a640c23a62f3a-c2ac223aa65mr751125766b.23.1790432271660;
        Sat, 26 Sep 2026 07:17:51 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2b769429ddsm117071666b.51.2026.09.26.07.17.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2026 07:17:50 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so272861566b.0
        for <linux-crypto@vger.kernel.org>; Sat, 26 Sep 2026 07:17:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcH2MNQN7jwKSmk/zsCazfmQOcXLn1wUWbG7c/TfkThbdWpLt+yMPc+ETSPAekfCOri2YRMEQD7J9J8Vk=@vger.kernel.org
X-Received: by 2002:a17:906:4792:b0:c26:3107:71bb with SMTP id
 a640c23a62f3a-c2ac2235d55mr776169066b.24.1790432269525; Sat, 26 Sep 2026
 07:17:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260925132223.706291-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260925132223.706291-2-Jeremy.Jean@oss.cyber.gouv.fr>
From: Ignat Korchagin <ignat@linux.win>
Date: Sat, 26 Sep 2026 15:17:38 +0100
X-Gmail-Original-Message-ID: <CAOs+rJWUi+Lr-G9NcOzStqPQyCG_L8HC2ZTa6QZBTGD+AAQKSA@mail.gmail.com>
X-Gm-Features: AclHuK-eDjj9evugOMyaNvtIxuiQ17nmVU1U9pRZQSYDNBJ974qVAgrbJMdt_kQ
Message-ID: <CAOs+rJWUi+Lr-G9NcOzStqPQyCG_L8HC2ZTa6QZBTGD+AAQKSA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Handle exceptional points in Shamir multiplication
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 2:23=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Shamir multiplication mishandles equal points, opposite points and the
> point at infinity. This rejects valid ECDSA signatures and can accept
> invalid digest/signature tuples when the public key is G or -G. The

Can you provide/construct test vectors for these? The ones that were
accepted, but should fail.

> kernel incorrectly rejects 16 valid signatures from Wycheproof.
>
> Handle doubling, cancellation and the point at infinity in precomputation
> and accumulation. Add regression tests for P-256 ECDSA and 256/512-bit
> EC-RDSA. The vectors are Wycheproof P1363 secp256r1/SHA-256 cases 60 and
> 210 converted to X9.62, two constructed ECDSA signatures for Q =3D +/-G
> with k =3D 2, and six constructed EC-RDSA signatures for Q =3D G, -G and =
-2G.
>
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm=
")

This is worth backporting so I would CC: stable@vger.kernel.org

> Assisted-by: LLM
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  crypto/ecc.c     |  33 +++++-
>  crypto/testmgr.h | 280 ++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 310 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 3250a464b852..c7366eb7ce1f 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1423,9 +1423,22 @@ static void ecc_point_add(const struct ecc_point *=
result,
>         vli_set(result->x, q->x, ndigits);
>         vli_set(result->y, q->y, ndigits);
>         vli_mod_sub(z, result->x, p->x, curve->p, ndigits);
> +       if (vli_is_zero(z, ndigits)) {
> +               if (vli_cmp(p->y, q->y, ndigits)) {
> +                       /* P + (-P) is the point at infinity. */
> +                       vli_clear(result->x, ndigits);
> +                       vli_clear(result->y, ndigits);
> +                       return;
> +               }
> +               /* The co-Z addition formula does not handle P =3D=3D Q. =
*/
> +               z[0] =3D 1;
> +               ecc_point_double_jacobian(result->x, result->y, z, curve)=
;
> +               goto out;
> +       }
>         vli_set(px, p->x, ndigits);
>         vli_set(py, p->y, ndigits);
>         xycz_add(px, py, result->x, result->y, curve);
> +out:
>         vli_mod_inv(z, z, curve->p, ndigits);
>         apply_z(result->x, result->y, z, curve);
>  }
> @@ -1465,22 +1478,38 @@ void ecc_point_mult_shamir(const struct ecc_point=
 *result,
>         vli_set(rx, point->x, ndigits);
>         vli_set(ry, point->y, ndigits);
>         vli_clear(z + 1, ndigits - 1);
> -       z[0] =3D 1;
> +       z[0] =3D !ecc_point_is_zero(point);
>
>         for (--i; i >=3D 0; i--) {
>                 ecc_point_double_jacobian(rx, ry, z, curve);
>                 idx =3D !!vli_test_bit(u1, i);
>                 idx |=3D (!!vli_test_bit(u2, i)) << 1;
>                 point =3D points[idx];
> -               if (point) {
> +               if (point && !ecc_point_is_zero(point)) {
>                         u64 tx[ECC_MAX_DIGITS];
>                         u64 ty[ECC_MAX_DIGITS];
>                         u64 tz[ECC_MAX_DIGITS];
>
> +                       if (vli_is_zero(z, ndigits)) {
> +                               /* Adding to infinity starts a new accumu=
lator. */
> +                               vli_set(rx, point->x, ndigits);
> +                               vli_set(ry, point->y, ndigits);
> +                               z[0] =3D 1;
> +                               continue;
> +                       }
>                         vli_set(tx, point->x, ndigits);
>                         vli_set(ty, point->y, ndigits);
>                         apply_z(tx, ty, z, curve);
>                         vli_mod_sub(tz, rx, tx, curve->p, ndigits);
> +                       if (vli_is_zero(tz, ndigits)) {
> +                               if (!vli_cmp(ry, ty, ndigits))
> +                                       ecc_point_double_jacobian(rx, ry,=
 z,
> +                                                                 curve);
> +                               else
> +                                       /* Adding opposite points yields =
infinity. */
> +                                       vli_clear(z, ndigits);
> +                               continue;
> +                       }
>                         xycz_add(tx, ty, rx, ry, curve);
>                         vli_mod_mult_fast(z, z, tz, curve);
>                 }
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index c4a15e714ecd..045a3e46fb09 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -1443,6 +1443,94 @@ static const struct sig_testvec x962_ecdsa_nist_p1=
92_tv_template[] =3D {
>  };
>
>  static const struct sig_testvec x962_ecdsa_nist_p256_tv_template[] =3D {
> +       /* Wycheproof secp256r1/SHA-256 tcId 60. */
> +       {
> +       .key =3D
> +       "\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b=
"
> +       "\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28=
"
> +       "\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4=
"
> +       "\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51=
"
> +       "\x3e",
> +       .key_len =3D 65,
> +       .m =3D
> +       "\x70\x23\x9d\xd8\x77\xf7\xc9\x44\xc4\x22\xf4\x4d\xea\x4e\xd1\xa5=
"
> +       "\x2f\x26\x27\x41\x6f\xaf\x2f\x07\x2f\xa5\x0c\x77\x2e\xd6\xf8\x07=
",
> +       .m_size =3D 32,
> +       .c =3D
> +       "\x30\x44\x02\x20\x64\xa1\xaa\xb5\x00\x0d\x0e\x80\x4f\x3e\x2f\xc0=
"
> +       "\x2b\xde\xe9\xbe\x8f\xf3\x12\x33\x4e\x2b\xa1\x6d\x11\x54\x7c\x97=
"
> +       "\x71\x1c\x89\x8e\x02\x20\x6a\xf0\x15\x97\x1c\xc3\x0b\xe6\xd1\xa2=
"
> +       "\x06\xd4\xe0\x13\xe0\x99\x77\x72\xa2\xf9\x1d\x73\x28\x6f\xfd\x68=
"
> +       "\x3b\x9b\xb2\xcf\x4f\x1b",
> +       .c_size =3D 70,
> +       .public_key_vec =3D true,
> +       },
> +       /* Wycheproof secp256r1/SHA-256 tcId 210. */
> +       {
> +       .key =3D
> +       "\x04\xc6\xa7\x71\x52\x70\x24\x22\x77\x92\x17\x0a\x6f\x8e\xee\x73=
"
> +       "\x5b\xf3\x2b\x7f\x98\xaf\x66\x9e\xad\x29\x98\x02\xe3\x2d\x7c\x31=
"
> +       "\x07\xbc\x3b\x4b\x5e\x65\xab\x88\x7b\xbd\x34\x35\x72\xb3\xe5\x61=
"
> +       "\x92\x61\xfe\x3a\x07\x3e\x2f\xfd\x78\x41\x2f\x72\x68\x67\xdb\x58=
"
> +       "\x9e",
> +       .key_len =3D 65,
> +       .m =3D
> +       "\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3=
"
> +       "\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23=
",
> +       .m_size =3D 32,
> +       .c =3D
> +       "\x30\x45\x02\x20\x7c\xf2\x7b\x18\x8d\x03\x4f\x7e\x8a\x52\x38\x03=
"
> +       "\x04\xb5\x1a\xc3\xc0\x89\x69\xe2\x77\xf2\x1b\x35\xa6\x0b\x48\xfc=
"
> +       "\x47\x66\x99\x78\x02\x21\x00\xb6\xdb\x6d\xb6\x24\x92\x49\x25\x49=
"
> +       "\x24\x92\x49\x24\x92\x49\x24\x62\x5b\xd7\xa0\x9b\xec\x4c\xa8\x1b=
"
> +       "\xcd\xd9\xf8\xfd\x6b\x63\xcc",
> +       .c_size =3D 71,
> +       .public_key_vec =3D true,
> +       },
> +       /* Q =3D G, d =3D 1, k =3D 2. */
> +       {
> +       .key =3D
> +       "\x04\x6b\x17\xd1\xf2\xe1\x2c\x42\x47\xf8\xbc\xe6\xe5\x63\xa4\x40=
"
> +       "\xf2\x77\x03\x7d\x81\x2d\xeb\x33\xa0\xf4\xa1\x39\x45\xd8\x98\xc2=
"
> +       "\x96\x4f\xe3\x42\xe2\xfe\x1a\x7f\x9b\x8e\xe7\xeb\x4a\x7c\x0f\x9e=
"
> +       "\x16\x2b\xce\x33\x57\x6b\x31\x5e\xce\xcb\xb6\x40\x68\x37\xbf\x51=
"
> +       "\xf5",
> +       .key_len =3D 65,
> +       .m =3D
> +       "\x35\x9d\x17\x29\xb9\x1a\x52\xe9\x8b\xb5\x95\xc3\x86\x28\x3c\x10=
"
> +       "\x30\x44\x95\x1a\xa1\x08\x20\xf0\xa0\x22\xc4\x18\xc2\x71\xa0\xcc=
",
> +       .m_size =3D 32,
> +       .c =3D
> +       "\x30\x44\x02\x20\x7c\xf2\x7b\x18\x8d\x03\x4f\x7e\x8a\x52\x38\x03=
"
> +       "\x04\xb5\x1a\xc3\xc0\x89\x69\xe2\x77\xf2\x1b\x35\xa6\x0b\x48\xfc=
"
> +       "\x47\x66\x99\x78\x02\x20\x59\x47\xc9\x21\x23\x0e\xd1\x34\x0b\x03=
"
> +       "\xe6\xe3\x45\x6e\xab\x69\xf8\x66\xff\x7e\x8c\x7d\x1e\x13\x23\x17=
"
> +       "\x06\x8a\x84\xec\x1d\x22",
> +       .c_size =3D 70,
> +       .public_key_vec =3D true,
> +       },
> +       /* Q =3D -G, d =3D n - 1, k =3D 2. */
> +       {
> +       .key =3D
> +       "\x04\x6b\x17\xd1\xf2\xe1\x2c\x42\x47\xf8\xbc\xe6\xe5\x63\xa4\x40=
"
> +       "\xf2\x77\x03\x7d\x81\x2d\xeb\x33\xa0\xf4\xa1\x39\x45\xd8\x98\xc2=
"
> +       "\x96\xb0\x1c\xbd\x1c\x01\xe5\x80\x65\x71\x18\x14\xb5\x83\xf0\x61=
"
> +       "\xe9\xd4\x31\xcc\xa9\x94\xce\xa1\x31\x34\x49\xbf\x97\xc8\x40\xae=
"
> +       "\x0a",
> +       .key_len =3D 65,
> +       .m =3D
> +       "\x35\x9d\x17\x29\xb9\x1a\x52\xe9\x8b\xb5\x95\xc3\x86\x28\x3c\x10=
"
> +       "\x30\x44\x95\x1a\xa1\x08\x20\xf0\xa0\x22\xc4\x18\xc2\x71\xa0\xcc=
",
> +       .m_size =3D 32,
> +       .c =3D
> +       "\x30\x45\x02\x20\x7c\xf2\x7b\x18\x8d\x03\x4f\x7e\x8a\x52\x38\x03=
"
> +       "\x04\xb5\x1a\xc3\xc0\x89\x69\xe2\x77\xf2\x1b\x35\xa6\x0b\x48\xfc=
"
> +       "\x47\x66\x99\x78\x02\x21\x00\xdc\x55\x4e\x07\x96\x0b\x81\xb6\x80=
"
> +       "\xb1\xae\xe0\x40\xb9\x90\xa5\xf4\xc4\x90\x49\xbb\xa2\xa1\x62\x70=
"
> +       "\xc5\x88\x51\x39\xe8\xa8\xfb",
> +       .c_size =3D 71,
> +       .public_key_vec =3D true,
> +       },
>         {
>         .key =3D /* secp256r1(sha1) */
>         "\x04\xb9\x7b\xbb\xd7\x17\x64\xd2\x7e\xfc\x81\x5d\x87\x06\x83\x41=
"
> @@ -1827,7 +1915,8 @@ static const struct sig_testvec p1363_ecdsa_nist_p2=
56_tv_template[] =3D {
>  };
>
>  /*
> - * EC-RDSA test vectors are generated by gost-engine.
> + * EC-RDSA test vectors generated by gost-engine, followed by constructe=
d
> + * exceptional-point regression vectors.
>   */
>  static const struct sig_testvec ecrdsa_tv_template[] =3D {
>         {
> @@ -1973,6 +2062,195 @@ static const struct sig_testvec ecrdsa_tv_templat=
e[] =3D {
>         .m_size =3D 64,
>         .public_key_vec =3D true,
>         },
> +       /*
> +        * Constructed EC-RDSA exceptional-point vectors.
> +        * With Q =3D dG, choose k =3D z1 + d*z2 (mod n), r =3D x(kG) mod=
 n,
> +        * e =3D -r/z2 (mod n), and s =3D r*d + k*e (mod n).
> +        * The input digest is e, encoded little-endian.
> +        */
> +       /* cp256a: Q=3DG, z1 =3D 3, z2 =3D 1. */
> +       {
> +       .key =3D
> +       "\x04\x40\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x14\x1e\x9f\x9e\x9c\xc9\xac\x22\xb1\xe3\x23\xdf\x2d\x4f=
"
> +       "\x29\x35\x76\x2b\x3f\x45\x5a\x50\xdf\x27\xda\x9c\x98\xe0\x71\xe4=
"
> +       "\x91\x8d",
> +       .key_len =3D 66,
> +       .params =3D /* OID_gostCPSignA */
> +       "\x30\x13\x06\x07\x2a\x85\x03\x02\x02\x23\x01\x06\x08\x2a\x85\x03=
"
> +       "\x07\x01\x01\x02\x02",
> +       .param_len =3D 21,
> +       .c =3D
> +       "\x1a\xed\x44\xae\xd4\x4a\xed\x44\xae\xd4\x4a\xed\x44\xae\xd4\x49=
"
> +       "\x32\x67\xe0\x26\x16\xfd\xb7\xaf\xa4\xd7\x3e\x61\xd4\xf9\x7b\x94=
"
> +       "\xf7\x06\x3e\x70\x63\xe7\x06\x3e\x70\x63\xe7\x06\x3e\x70\x63\xe7=
"
> +       "\x06\x3e\x70\x63\xe7\x06\x3e\x70\x63\xe7\x06\x3e\x70\x63\xe4\xb7=
",
> +       .c_size =3D 64,
> +       .m =3D
> +       "\xdc\xd3\xfd\x46\xcb\x14\x9d\xe1\x8f\x92\x54\xb2\x0c\xa0\x22\x66=
"
> +       "\x18\x9c\x8f\xc1\xf9\x18\x9c\x8f\xc1\xf9\x18\x9c\x8f\xc1\xf9\x08=
",
> +       .m_size =3D 32,
> +       .algo =3D OID_gost2012PKey256,
> +       .public_key_vec =3D true,
> +       },
> +       /* cp256a: Q=3D-G, z1 =3D 7, z2 =3D 6. */
> +       {
> +       .key =3D
> +       "\x04\x40\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x83\xdf\x60\x61\x63\x36\x53\xdd\x4e\x1c\xdc\x20\xd2\xb0=
"
> +       "\xd6\xca\x89\xd4\xc0\xba\xa5\xaf\x20\xd8\x25\x63\x67\x1f\x8e\x1b=
"
> +       "\x6e\x72",
> +       .key_len =3D 66,
> +       .params =3D /* OID_gostCPSignA */
> +       "\x30\x13\x06\x07\x2a\x85\x03\x02\x02\x23\x01\x06\x08\x2a\x85\x03=
"
> +       "\x07\x01\x01\x02\x02",
> +       .param_len =3D 21,
> +       .c =3D
> +       "\x2a\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa=
"
> +       "\x92\x10\x2d\x68\x19\x8f\x22\xd5\x60\xeb\x59\xd6\xf3\xe5\x9e\xc2=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01=
",
> +       .c_size =3D 64,
> +       .m =3D
> +       "\xc3\x9e\xe5\xf3\xd6\x59\xeb\x60\xd5\x22\x8f\x19\x68\x2d\x10\x92=
"
> +       "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\x2a=
",
> +       .m_size =3D 32,
> +       .algo =3D OID_gost2012PKey256,
> +       .public_key_vec =3D true,
> +       },
> +       /* cp256a: Q=3D-2G, z1 =3D 5, z2 =3D 2. */
> +       {
> +       .key =3D
> +       "\x04\x40\x95\xfd\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\x14\x1e\x9f\x9e\x9c\xc9\xac\x22\xb1\xe3\x23\xdf\x2d\x4f=
"
> +       "\x29\x35\x76\x2b\x3f\x45\x5a\x50\xdf\x27\xda\x9c\x98\xe0\x71\xe4=
"
> +       "\x91\x8d",
> +       .key_len =3D 66,
> +       .params =3D /* OID_gostCPSignA */
> +       "\x30\x13\x06\x07\x2a\x85\x03\x02\x02\x23\x01\x06\x08\x2a\x85\x03=
"
> +       "\x07\x01\x01\x02\x02",
> +       .param_len =3D 21,
> +       .c =3D
> +       "\x7f\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xb6\x30\x88\x38\x4c\xad\x68\x80\x22\xc2\x0d\x84\xdb\xb0\xdc\x47=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01=
",
> +       .c_size =3D 64,
> +       .m =3D
> +       "\x49\xdc\xb0\xdb\x84\x0d\xc2\x22\x80\x68\xad\x4c\x38\x88\x30\xb6=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x7f=
",
> +       .m_size =3D 32,
> +       .algo =3D OID_gost2012PKey256,
> +       .public_key_vec =3D true,
> +       },
> +       /* tc512a: Q=3DG, z1 =3D 3, z2 =3D 1. */
> +       {
> +       .key =3D
> +       "\x04\x81\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\xa4\xf2\x15\x52\xcb\x89\xa5\x89\xb8\xf5\x35\xc2\x5f=
"
> +       "\xfe\x28\x80\xe9\x41\x3a\x0e\xa5\xe6\x75\x3d\xe9\x36\xd0\x4f\xbe=
"
> +       "\x26\x16\xdf\x21\xa9\xef\xcb\xfd\x64\x80\x77\xc1\xab\xf1\xac\x93=
"
> +       "\x1c\x5e\xce\xe6\x50\x54\xe2\x16\x88\x1b\xa6\xe3\x6a\x83\x7a\xe8=
"
> +       "\xcf\x03\x75",
> +       .key_len =3D 131,
> +       .params =3D /* OID_gostTC26Sign512A */
> +       "\x30\x0b\x06\x09\x2a\x85\x03\x07\x01\x02\x01\x02\x01",
> +       .param_len =3D 13,
> +       .c =3D
> +       "\xd8\xc0\xd7\xe3\xfb\xa6\xca\xff\x6a\xd1\xb4\xb4\x82\x1d\x15\x6f=
"
> +       "\xa7\xc7\xbd\x63\x95\xb8\x29\x0d\xd4\xfa\xb1\x1c\x36\xbd\x32\x8d=
"
> +       "\x1a\xba\xf1\x2e\xbc\x7b\xf2\x02\x96\xf8\xef\x2a\x5e\x72\x64\x86=
"
> +       "\x67\x62\xfb\x62\x8e\x83\x53\x63\xb7\xe6\x78\x3c\x42\xd7\x0d\x1d=
"
> +       "\xb7\xbf\xb8\x09\x56\xc8\x67\x00\x31\xba\x19\x19\x29\xf6\x4e\x30=
"
> +       "\x1d\x68\x16\x34\x23\x6d\x47\xa6\x0e\x57\x1a\x4b\xed\xc0\xef\x25=
"
> +       "\x74\x52\xef\x78\xb5\xb9\x8d\xbb\x3d\x9f\x31\x29\xd9\x34\x94\x33=
"
> +       "\xce\x2a\x3a\x35\xcb\x51\x9c\x91\xe2\xd6\x33\xd7\xb3\x73\xae\x16=
",
> +       .c_size =3D 128,
> +       .m =3D
> +       "\x5f\x04\x9d\x6b\x69\x7d\xf7\xe7\xcb\x1b\x81\x2f\x76\xfe\x20\xcd=
"
> +       "\x2c\xcc\xd0\x74\x63\xfa\x52\x32\x56\xfb\xd3\x3e\xba\xa5\x93\xb3=
"
> +       "\xd9\x10\x3f\x12\xb4\xe5\xa8\xf1\x59\xb8\x92\xdc\xcb\xe9\x97\xe2=
"
> +       "\xcf\xb1\x09\xd6\xe6\xe6\x45\xce\xff\x98\x37\xa9\xf6\x47\x40\x48=
",
> +       .m_size =3D 64,
> +       .algo =3D OID_gost2012PKey512,
> +       .public_key_vec =3D true,
> +       },
> +       /* tc512a: Q=3D-G, z1 =3D 7, z2 =3D 6. */
> +       {
> +       .key =3D
> +       "\x04\x81\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x23\x0b\xea\xad\x34\x76\x5a\x76\x47\x0a\xca\x3d\xa0=
"
> +       "\x01\xd7\x7f\x16\xbe\xc5\xf1\x5a\x19\x8a\xc2\x16\xc9\x2f\xb0\x41=
"
> +       "\xd9\xe9\x20\xde\x56\x10\x34\x02\x9b\x7f\x88\x3e\x54\x0e\x53\x6c=
"
> +       "\xe3\xa1\x31\x19\xaf\xab\x1d\xe9\x77\xe4\x59\x1c\x95\x7c\x85\x17=
"
> +       "\x30\xfc\x8a",
> +       .key_len =3D 131,
> +       .params =3D /* OID_gostTC26Sign512A */
> +       "\x30\x0b\x06\x09\x2a\x85\x03\x07\x01\x02\x01\x02\x01",
> +       .param_len =3D 13,
> +       .c =3D
> +       "\x7f\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\x93\xf3\x4a\x99\x7a\x46\xc4\x88\xb7\xf9\x15\xc6\xa7\x02\xb0\x30=
"
> +       "\x4d\xa5\x9c\x55\xfd\x69\x5c\x2e\xe5\x66\xd8\xa0\x8f\x88\x59\x37=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03=
",
> +       .c_size =3D 128,
> +       .m =3D
> +       "\x3a\x59\x88\x8f\xa0\xd8\x66\xe5\x2e\x5c\x69\xfd\x55\x9c\xa5\x4d=
"
> +       "\x30\xb0\x02\xa7\xc6\x15\xf9\xb7\x88\xc4\x46\x7a\x99\x4a\xf3\x93=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x7f=
",
> +       .m_size =3D 64,
> +       .algo =3D OID_gost2012PKey512,
> +       .public_key_vec =3D true,
> +       },
> +       /* tc512a: Q=3D-2G, z1 =3D 5, z2 =3D 2. */
> +       {
> +       .key =3D
> +       "\x04\x81\x80\x7c\x13\xea\xd2\xd9\xaf\x82\xb9\x1f\xb2\xfd\xe1\x8d=
"
> +       "\xf4\x5b\x37\xe4\xf2\x04\x6a\x2a\x1d\x15\x16\x95\x2a\x5d\x40\xcd=
"
> +       "\xbb\x34\x44\x2f\x2b\x13\x0a\x47\xb0\xf6\xe5\xa5\x58\x3a\xf4\x54=
"
> +       "\x09\xb0\x1d\xf5\x5c\xf1\xbf\x9d\x86\xa5\x97\xab\x96\x29\x62\xfc=
"
> +       "\xdc\x89\x3b\x76\x3d\x50\x6e\x8a\xcf\x02\x4c\x74\x0e\x6e\xe0\x1f=
"
> +       "\x28\xab\x27\x9b\x20\x02\xc8\xc4\x12\xcb\x8a\xe3\xa4\x27\xce\x39=
"
> +       "\x62\xdf\x35\x6d\xc1\x65\x7f\x7b\x48\x90\x11\x8f\x19\x7c\x1e\x67=
"
> +       "\x91\x97\xeb\x90\x85\x25\xfc\x86\xb3\x88\x6e\x5c\x57\x1f\x1d\x1d=
"
> +       "\x3b\xec\x37",
> +       .key_len =3D 131,
> +       .params =3D /* OID_gostTC26Sign512A */
> +       "\x30\x0b\x06\x09\x2a\x85\x03\x07\x01\x02\x01\x02\x01",
> +       .param_len =3D 13,
> +       .c =3D
> +       "\x7f\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\x93\xf3\x4a\x99\x7a\x46\xc4\x88\xb7\xf9\x15\xc6\xa7\x02\xb0\x30=
"
> +       "\x4d\xa5\x9c\x55\xfd\x69\x5c\x2e\xe5\x66\xd8\xa0\x8f\x88\x59\x33=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
"
> +       "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03=
",
> +       .c_size =3D 128,
> +       .m =3D
> +       "\x39\x59\x88\x8f\xa0\xd8\x66\xe5\x2e\x5c\x69\xfd\x55\x9c\xa5\x4d=
"
> +       "\x30\xb0\x02\xa7\xc6\x15\xf9\xb7\x88\xc4\x46\x7a\x99\x4a\xf3\x93=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff=
"
> +       "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x7f=
",
> +       .m_size =3D 64,
> +       .algo =3D OID_gost2012PKey512,
> +       .public_key_vec =3D true,
> +       },
>  };
>
>  /*
>
> base-commit: 165768bb70265b5c38cf0b73fafd75be235f8b14
> --
> 2.47.3
>
>

Ignat
