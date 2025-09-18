Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67966318135
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204968; cv=none; b=P+HgKUlMNcOlymicf9VXjGdZGX+Duz8j6VEePEU4RVAVmcMyAC1nGisU1IHmX09jxaowgUlymFs95jS3aogwnY4fGG1tvGICAA6xeAHenGeXWjmLNd8IIRkCzebJxZetsBRerh78GOA3Vaybivam7bf5nE+wZVxbqHDx5dC3JVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204968; c=relaxed/simple;
	bh=EA7vYi5ofvk1cKNAjb9IvxaMHv14pBRTDKOPF0eO/9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YkZ8WyBYVYc2yG+HjE/Nxyl9bLwlIAD4IYoQ6yE0ppKlbGc9lJpVUgVacrngBNSAYcPpa2k2U+cVzCDIXf//sy2wLmkcqJ9fy4NmPvZuqGkNp4OYT916eebMFJ+XVdugRD7b0z03Kc4hYyKt/AVSkOpdflxDfqkpKjbuaIWnLQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hAAO2o/R; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hAAO2o/R"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7957e2f6ba8so4781606d6.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 07:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204965; x=1758809765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1m9V0QnucGw1fYjnWnkHTlkfdmFSylGoU4nkl6jTtY=;
        b=hAAO2o/RW29jJnKjlwzPfp+JBtsq3p3RoyZnPU1nP30Kkq+OTOsfka2SUcbzMnM9zY
         A32COQJK6I5uv/AblMAslEvn0MLPo4cAwVHEy431i37YIHgiKfsyD4OdM+rJrGES4hSc
         vMtvjJkAQnr93pkn2ZdO7LTPZokzW9zZjiYyu0b0wqxkoBjFUA77lh/IVCmof5J602T+
         aja8YF0inSgW8GCIIXHbctSMVffyglA15+gbrQGlSLJmo/LH9XV66GEd9c9qyqGB+hRf
         5a7U0sNTeqEjNgy8QkFRoAKLEnyevvgfAmOmeeCVUAfLIoGVDdMeqHJl1rdOGU3R5U9q
         uf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204965; x=1758809765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1m9V0QnucGw1fYjnWnkHTlkfdmFSylGoU4nkl6jTtY=;
        b=xNH+hq8LruCLZ9AGTV9Nh6aK4af6gMfNUbceCsmtpGk2DHZoxEjmDUf+OALCTJJAhD
         PZxq6CWYMknwj2XT8fRdW7qz7C5/Q6xXRLYe3fEqjtB5aBr04JlV7Ak3FHYycWMQIeNQ
         +3i/28qykJCzUqo3cXmtxJU+D6A1HDfTIWECKv/uxatfGDUHHhbdsvHcI6RAv+ImnCoo
         6QR/H4giDnBXnhc5PT0qjK81jlwte9Qa9xlUAHUlGgM/Vi0KU+CLeLSk7Dfs9A/fn22Z
         hnGWLP6jB1MQmkmayZmCr6zjvG8/P4yDVRQF12MnqjLQTHDWlBgWojcJJDGlt2gTgt+M
         7EDg==
X-Forwarded-Encrypted: i=1; AJvYcCWso5eajD5mUvJWXRrJkYRk4E89qau+HBCfGyYMJyj/rR3iBoXbtQzAqWD8lDGBrj7qLJqH09Yatp9i/JI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo7NNLQURhS6UOUKtwEefGjhftXvKbs9VwOGWi8PBX+qN7ShlL
	0gKL6XYyr1cZq7oz40LNjlfAMaL1BsJmpyWwZFGNqiu+tZaoEFg+EQcyUsHFINcSL7clmNI1ARC
	Gn23cSXN+Zq3b1eQBXkDPAnDGpeq7qUbxlKTV2Vpr
X-Gm-Gg: ASbGncsfny3sqgKgQvLDxZAOkWtx7KItIXMVqFVn6lVNu7qVuGui9q5ienFlG1QfqHz
	zDmPAcKUbg87zHhb8tdM/WsqHL2s0iELdin4lZwYKppb8BqH/hDbkBaVQ/2eVsMQaFVjWqjcabq
	y8f982m9DWm4KytHXwBuul0ub+BcEoO//wh1ejwllKs8qzBSGzTCDA2x7v7SsWovaHT1KtRRgBC
	GFW2rQANfj52O9d1cH21zOIpW1flBR5P2tOA80mlCMYhw+E6SANk9jUCqzCEt0=
X-Google-Smtp-Source: AGHT+IFBpnDsj/3XitirZWPzOjid3pk9f5ycO+u5s3pMsQEUT+8NOpONrRLGkmiWyeP3kqXiHfhufSRzIIkcKBIaTRI=
X-Received: by 2002:a05:6214:2aa5:b0:782:1086:f659 with SMTP id
 6a1803df08f44-78eccb0cae7mr65869736d6.26.1758204964157; Thu, 18 Sep 2025
 07:16:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 18 Sep 2025 16:15:27 +0200
X-Gm-Features: AS18NWDFBwLJ1l73cBf4HqMXnx0YeCt1p-LK845oN4Qc3Ee7lXGT_Tt4s1Okcjk
Message-ID: <CAG_fn=Xkig71cn1xCUP1t=OLAbk+YYLsec0HhciROuiTD6AELg@mail.gmail.com>
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ignat@cloudflare.com
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, jack@suse.cz, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> rsa_parse_priv_key to serve as real-world examples of how the framework
> is used.
>
> These functions are ideal candidates for KFuzzTest as they perform
> complex parsing of user-controlled data but are not directly exposed at
> the syscall boundary. This makes them difficult to exercise with
> traditional fuzzing tools and showcases the primary strength of the
> KFuzzTest framework: providing an interface to fuzz internal functions.
>
> To validate the effectiveness of the framework on these new targets, we
> injected two artificial bugs and let syzkaller fuzz the targets in an
> attempt to catch them.
>
> The first of these was calling the asn1 decoder with an incorrect input
> from pkcs7_parse_message, like so:
>
> - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> The second was bug deeper inside of asn1_ber_decoder itself, like so:
>
> - for (len =3D 0; n > 0; n--)
> + for (len =3D 0; n >=3D 0; n--)
>
> syzkaller was able to trigger these bugs, and the associated KASAN
> slab-out-of-bounds reports, within seconds.
>
> The targets are defined within /lib/tests, alongside existing KUnit
> tests.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
>
> ---
> v3:
> - Change the fuzz target build to depend on CONFIG_KFUZZTEST=3Dy,
>   eliminating the need for a separate config option for each individual
>   file as suggested by Ignat Korchagin.
> - Remove KFUZZTEST_EXPECT_LE on the length of the `key` field inside of
>   the fuzz targets. A maximum length is now set inside of the core input
>   parsing logic.
> v2:
> - Move KFuzzTest targets outside of the source files into dedicated
>   _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
>   Ignat Korchagin and Eric Biggers.
> ---
> ---
>  crypto/asymmetric_keys/Makefile               |  2 +
>  crypto/asymmetric_keys/tests/Makefile         |  2 +
>  crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
>  .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
>  4 files changed, 64 insertions(+)
>  create mode 100644 crypto/asymmetric_keys/tests/Makefile
>  create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
>  create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
>
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Mak=
efile
> index bc65d3b98dcb..77b825aee6b2 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -67,6 +67,8 @@ obj-$(CONFIG_PKCS7_TEST_KEY) +=3D pkcs7_test_key.o
>  pkcs7_test_key-y :=3D \
>         pkcs7_key_type.o
>
> +obj-y +=3D tests/
> +
>  #
>  # Signed PE binary-wrapped key handling
>  #
> diff --git a/crypto/asymmetric_keys/tests/Makefile b/crypto/asymmetric_ke=
ys/tests/Makefile
> new file mode 100644
> index 000000000000..4ffe0bbe9530
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_KFUZZTEST) +=3D pkcs7_kfuzz.o
> +obj-$(CONFIG_KFUZZTEST) +=3D rsa_helper_kfuzz.o
> diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetr=
ic_keys/tests/pkcs7_kfuzz.c
> new file mode 100644
> index 000000000000..37e02ba517d8
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * PKCS#7 parser KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <crypto/pkcs7.h>
> +#include <linux/kfuzztest.h>
> +
> +struct pkcs7_parse_message_arg {
> +       const void *data;
> +       size_t datalen;
> +};
> +
> +FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
> +       KFUZZTEST_ANNOTATE_ARRAY(pkcs7_parse_message_arg, data);
> +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> +
> +       pkcs7_parse_message(arg->data, arg->datalen);

As far as I understand, this function creates an allocation, so the
fuzz test will need to free it using pkcs7_free_message() to avoid
leaking memory.
What do you think, Ignat?


> +       struct rsa_key out;
> +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> +}

Do we need to deallocate anything here?
