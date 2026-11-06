Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989425;
	b=ImaYYJANgoY8fUcCK2NX4zkJaaXGgkJ27YtoxBAbvF0Nm+egpUrPZs9gy3+SsGETk0aq
	 /LtW+7nWMX4C+yOcy/iWskYpCwIFau0HwfezBZeAzkJVyH11qjnN0ZODdRQHzOub0uMIC
	 b3fn/plc6SGZi03xaNmKR+dmZtBiwMC0pkofQP1Ayb+bbGZVj3003i5836etUNlJNA75B
	 8phdQv2yeR8ipRF23oxSaLNdb5q58URf8ee/YYz7CJ7fj4ij+htB4ipjZ8L15gdSM9Sh7
	 6mCxDJE9mL3tEwUMRdZpr8YzBIvEc2GHiG6lTPJ+45N3lG9imSMYSBgAgVkWFP1OJKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989425;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gmail-Original-Message-ID:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=aNrxcQ3EqzspHqBIrIiO9tnG/RBY6rmNXDWaz9X6PEg=;
	b=KUvVKVCqWn9FZkaTjVjz7QHg410EQvZwBPyOGJzXPdVR7fCg6wBwD5IRCZt4RlJO0gDm
	 e/QAm5KFYIvukXC5Q8jWZAA5RuNQzx6paAos84whR0K/cynIf4qwiV9z0jubxmFBU6dV5
	 XKXYqrjuVOjyWFEVgbyk28PtEe4a635DqQ5NTO51IMWqjJeCmFqLtGgWPonDkZQchffLV
	 lQ+1via7F5i2dhK6rZGxJWKWkSxTSSAonzcv7Xv4nXivTlF/tilyuUyehAwgZdvMX9YBX
	 tlTs4UbJd3lhf1USgrk31Zk8Cz7TffOFMg+AAcYJnNCdwe1h9G7qXtxkDRlW5FEG0rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C9D606A326
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 18:23:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50C9D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso150411866b.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793989424; x=1794594224;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aNrxcQ3EqzspHqBIrIiO9tnG/RBY6rmNXDWaz9X6PEg=;
        b=mo+BIQdse9gn691l0V80Ui83OgUj7qsFeeKCVvS9IUeXyq/9dqGhUZV4P5kiSXujm2
         jXeDdKbMKxRGTAHMAcEcOL88n4d8+6Mre0wUFLl5R+N/0IxxBbTE3x9rSlL+TEskeZQe
         FfC5WcuYSmValnebAUem9oEBWHAIilI7PEwsdCbIy6zT9sJlTgm0U8cjAGxiy+XBam2R
         v/GkoIhvE7e59Toit2GX9CfaGzvhR5/9Gr3qXAyx6Yr/SYQe27l0itPDQhvCClWvz/yM
         +PK1Kz/U2v1CaUZuoRueqiZ9MHYaBvH57Gr8JWrIponGaRFF8iUbPmwpKbvcS/jARw3n
         f7dw==
X-Gm-Message-State: APuU4Z+gfQiP3pKDz2qlFuNuurUoBuujSb0IBnMAvEF7rodPzeyr8g3k
	FRmrbgFAGTTeyeax8pJy2oNINNF/2JmjXtfZVsFyKPz43SfSc3lessnYGyiyCcWERqM=
X-Gm-Gg: AYBFou3ry8W45BTLTtvrY//NPqBmZowkZDvBi/Jfli2i/kcXlWhbrtbpaCI9u8DBElD
	3PlHrqGQf0uRsquBmOHnESQDyRb4CPQMMciieJJh06pBGoNAIEFjmI1GKRNyCPxoTlkExOqVTtT
	2HiBLTJRs68+1GE/1oL2mYandmvORlJs5+ZWD8V3qG9XtxFRDdUX0DyVUgMlE3c2aboH9H9pTm2
	Sk/wCNcCKH1dx57pu+Ur7at+oizPypzSn6PRwrkOpqHujqsNEENtIoDXMVj45Fb0dHg5J8yYn/k
	CZDKqcD5sF2B8L20N5LQdhOPgKWsjlPmXSLI+A0hrYGWhwsmF/zyy8xJujDRtaftzr5XapF3ZHJ
	pcPfzE7+hgjjnUslD7TbWTPboTPK+3/emttGADHxOMmMRXwCi7Hwu91Ivgkxt5F29dGrlvmshFN
	8koMrzN/SrVErXHET5kHPdWy6W71zHGyj3nX0LT2q2vdCnxFvz3N102EryOpJyft44CdeC9UvdX
	sxx1hfJCtlfiluZ+zS5tYNxaGcFINQaPLmKYvPlqB97hf38XfdqirKcXmd1q1ZonqokSBkWVCis
	n3PK/LGRpJSmSk7PLImosX1932+/ehcnSbD1cZ720cG56RDMZSbjYXvkbYc=
X-Received: by 2002:a17:907:3d88:b0:c4d:2cb4:7bbd with SMTP id a640c23a62f3a-c4d35641f5fmr237403366b.47.1793989423279;
        Fri, 06 Nov 2026 10:23:43 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d3562eb8csm96991866b.30.2026.11.06.10.23.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:23:41 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d21051042so132022766b.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:23:40 -0800 (PST)
X-Received: by 2002:a17:907:6ea1:b0:c49:903e:1e19 with SMTP id
 a640c23a62f3a-c4d354e89acmr271729566b.26.1793989420455; Fri, 06 Nov 2026
 10:23:40 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026024840.23482-1-xuyuqiabc@gmail.com>
In-Reply-To: <20261026024840.23482-1-xuyuqiabc@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 6 Nov 2026 18:23:27 +0000
X-Gmail-Original-Message-ID: <CAOs+rJWf5JEMD7UC-4YS2ayAX5f2SUgr5s9DCwmWXExBhqaEJA@mail.gmail.com>
X-Gm-Features: AclHuK-C3Nt3Bae-E0GNpd5wrE9zs0X4WIFo37tTe1DY5jHnZaQm4KTY5Zirqa8
Message-ID: <CAOs+rJWf5JEMD7UC-4YS2ayAX5f2SUgr5s9DCwmWXExBhqaEJA@mail.gmail.com>
Subject: Re: [PATCH v4] KEYS: Account for asymmetric key payload data in the quota
To: Yuqi Xu <xuyuqiabc@gmail.com>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org, Vega <vega@nebusec.ai>, 
	Ren Wei <weir@nebusec.ai>, xuyq21@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 2:50=E2=80=AFAM Yuqi Xu <xuyuqiabc@gmail.com> wrote=
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
> public key or set of authority key IDs. A charge which does not fit
> in unsigned short is rejected with -EINVAL before the payload is
> installed, because key_payload_reserve() keeps the full delta in the
> user counter and refunds only the truncated key->quotalen. key_alloc()
> also charges the key description to the same field, so include the
> effective description length in that limit as well.
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

SInce we touch PKCS8 as well, missing a relevant "Fixes:"

> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
> Reviewed-by: Ren Wei <weir@nebusec.ai>
> ---
> Changes in v4:
>  - Sashiko (High): "keys: integer truncation of key->quotalen causes
>    permanent quota leak" on key_alloc() and key_payload_reserve().
>    Include the effective key description length in the USHRT_MAX
>    limit. key_alloc() and key_payload_reserve() add the description
>    and the payload to the same unsigned short field, so checking the
>    payload alone was not enough.
>  - v3 Link: https://lore.kernel.org/all/20261019041314.48569-1-xuyuqiabc@=
gmail.com/
>
> Changes in v3:
>  - Sashiko (High): "keys: integer truncation of key->quotalen causes
>    permanent quota leak" on pkcs8_key_preparse() and
>    x509_key_preparse(). A payload charge above USHRT_MAX is rejected
>    with -EINVAL before the payload is installed. key_payload_reserve()
>    keeps the full delta in the user quota and refunds only the
>    truncated key->quotalen, so that charge would leak quota.
>  - Reposted so Sashiko records a review against this Message-ID, as
>    requested by Herbert Xu. v2 was posted and Ignat Korchagin replied.
>  - v2 Link: https://lore.kernel.org/all/4a0b2e00f5cc62c173a01fec2f56eab1b=
04d70bb.1790568982.git.xuyuqiabc@gmail.com/
>
> Changes in v2:
>  - Move the bug details and the measured quota numbers into this
>    commit message, as requested by Ignat Korchagin.
>  - Sashiko (High): "keys: integer truncation in key->quotalen causes
>    permanent quota leak" on pkcs8_key_preparse() and
>    x509_key_preparse(). Not changed in v2. The same finding is
>    addressed in v3 and v4.
>  - v1 Link: https://lore.kernel.org/all/cover.1789801335.git.xuyuqiabc@gm=
ail.com/
>
> diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_ke=
ys/pkcs8_parser.c
> index 9dd1c181789a..db2d57489d96 100644
> --- a/crypto/asymmetric_keys/pkcs8_parser.c
> +++ b/crypto/asymmetric_keys/pkcs8_parser.c
> @@ -10,6 +10,7 @@
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/err.h>
>  #include <linux/oid_registry.h>
>  #include <keys/asymmetric-subtype.h>
> @@ -136,6 +137,8 @@ static struct public_key *pkcs8_parse(const void *dat=
a, size_t datalen)
>  static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
>  {
>         struct public_key *pub;
> +       const char *description;
> +       size_t desclen, quotalen;
>
>         pub =3D pkcs8_parse(prep->data, prep->datalen);
>         if (IS_ERR(pub))
> @@ -144,13 +147,26 @@ static int pkcs8_key_preparse(struct key_preparsed_=
payload *prep)
>         pr_devel("Cert Key Algo: %s\n", pub->pkey_algo);
>         pub->id_type =3D "PKCS8";
>
> +       /*
> +        * key_alloc() charges the description to the same unsigned short
> +        * field that key_payload_reserve() later adds the payload to.

While today indeed only the asymmetric keys hit this I wonder if the
fix is better to be in key_payload_reserve(). Something like a fail if
key->quotelen + delta > USHRT_MAX. That fixes all current and future
key types.

> +        */
> +       description =3D prep->orig_description ?: prep->description;
> +       desclen =3D description ? strlen(description) + 1 : 0;
> +
> +       quotalen =3D sizeof(*pub) + pub->keylen;
> +       if (desclen > USHRT_MAX || quotalen > USHRT_MAX - desclen) {
> +               public_key_free(pub);
> +               return -EINVAL;
> +       }
> +
>         /* We're pinning the module by being linked against it */
>         __module_get(public_key_subtype.owner);
>         prep->payload.data[asym_subtype] =3D &public_key_subtype;
>         prep->payload.data[asym_key_ids] =3D NULL;
>         prep->payload.data[asym_crypto] =3D pub;
>         prep->payload.data[asym_auth] =3D NULL;
> -       prep->quotalen =3D 100;
> +       prep->quotalen =3D quotalen;
>         return 0;
>  }
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric=
_keys/x509_public_key.c
> index 25cf8ac7f257..4a9c85277ce0 100644
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
> -       const char *q;
> -       size_t srlen, sulen;
> +       const char *description, *q;
> +       size_t desclen, srlen, sulen, quotalen;
> +       int i;
>
>         cert =3D x509_cert_parse(prep->data, prep->datalen);
>         if (IS_ERR(cert))
> @@ -221,6 +223,36 @@ static int x509_key_preparse(struct key_preparsed_pa=
yload *prep)
>         if (IS_ERR(kids->id[2]))
>                 return PTR_ERR(kids->id[2]);
>
> +       /* Charge the memory retained in the payload, not a fixed estimat=
e */
> +       quotalen =3D sizeof(*cert->pub) + cert->pub->keylen +
> +                  cert->pub->paramlen;
> +       if (cert->sig) {
> +               quotalen +=3D sizeof(*cert->sig) + cert->sig->s_size;
> +               if (cert->sig->m_free)
> +                       quotalen +=3D cert->sig->m_size;
> +               for (i =3D 0; i < ARRAY_SIZE(cert->sig->auth_ids); i++) {
> +                       id =3D cert->sig->auth_ids[i];
> +                       if (id)
> +                               quotalen +=3D sizeof(*id) + id->len;
> +               }
> +       }
> +       quotalen +=3D sizeof(*kids);
> +       for (i =3D 0; i < ARRAY_SIZE(kids->id); i++) {
> +               id =3D kids->id[i];
> +               if (id)
> +                       quotalen +=3D sizeof(*id) + id->len;
> +       }
> +       /*
> +        * key_alloc() charges the description to the same unsigned short
> +        * field that key_payload_reserve() later adds the payload to.
> +        */
> +       description =3D prep->orig_description ?: desc;
> +       desclen =3D strlen(description) + 1;
> +       if (desclen > USHRT_MAX || quotalen > USHRT_MAX - desclen) {
> +               kfree(kids->id[2]);
> +               return -EINVAL;
> +       }
> +
>         /* We're pinning the module by being linked against it */
>         __module_get(public_key_subtype.owner);
>         prep->payload.data[asym_subtype] =3D &public_key_subtype;
> @@ -228,7 +260,7 @@ static int x509_key_preparse(struct key_preparsed_pay=
load *prep)
>         prep->payload.data[asym_crypto] =3D cert->pub;
>         prep->payload.data[asym_auth] =3D cert->sig;
>         prep->description =3D desc;
> -       prep->quotalen =3D 100;
> +       prep->quotalen =3D quotalen;
>
>         /* We've finished with the certificate */
>         cert->pub =3D NULL;
> --
> 2.56.0
>
>
>

Ignat
