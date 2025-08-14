Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8E215062
	for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755185309; cv=none; b=MVvbWE1qrKJ9MbNJCYJd9o0ZOSaq0jRkyWJmoJxR5eBCG02V6Mzsh+/0MPNjxwAIB15QlMmIxZ4uR/8s/lAQ1gSQVfCE33UNPOQphQAStp3N02bUNQjCDAEQgn1BE8vu59lFcCTHKXmr1KCEm3irT1sGPA0nm9V0RIINyjGlIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755185309; c=relaxed/simple;
	bh=9rAIQ4jp40wbs/EmvOWCpMFpnbWDf9zKOV8Ck/+NJDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CP8K9Jtc4syUwsCF8mYb/quRv5b6e2W6KogwSsBWFA44NqR3UkK8gGOxqKOMyiOqYa4jQhxY300K/LEmRH8CiYh2EQQTD33jbjDGg0IF6zklc0/dMapKd4FS/BolSqt29mRabQhEC4cnniL84fLP/Qc+3Sa6qfecM0zLFbKcjyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=OGzbRqeX; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="OGzbRqeX"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55ce52ab898so1168613e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 08:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1755185306; x=1755790106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNZq1Plf7qYhg3FaQgA7s7d5l7vZ/mBnFNpSg0zUHLI=;
        b=OGzbRqeXeyswGQ2LE41uMDBipfEQQyVVhiZhOuvUZJ+DWnae0PayBAbDqWjYgjdvbz
         RoC0ntri0Jsk3JIeq7Zny5m+1qP50zUPkx1MM3SdDyKkKp5bnsyZAI9+YvCJPx/HpkEW
         XAvHGd8S9hJgJICFd5JQtbZscx+f2YKN2Bm3JqS4M9qbuGWqNogalbsqjbkcgO/FWBZ8
         t2M1vpFP0LmNopr/F86NsaQyNPp5nDVreMEt4JzedLnkXj5+FfD6VaMaERa8HBXivvIW
         Z1hNLXbLlMwK6igIJJLF1YIpPHQm0b9ZWJQish+xTLR74GZ7Fj65FgjtuZD89v02H+xA
         GyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755185306; x=1755790106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNZq1Plf7qYhg3FaQgA7s7d5l7vZ/mBnFNpSg0zUHLI=;
        b=SCDV3SV+EQXjCVwGO3hk1YfE7gvbfjPFyyI0NS7DWMt+RSrDoBQU4PTaQS0Xm1SaK1
         FLFXt/hx0snCYfxPKsrIAIf8TwGXvaUODO1U7AqvbTlMpCJ6WRAOFEsXf03YL95l25PI
         qHtloKqQbk2Me+OuDRNTH9EF8Nd+zXuoBOleKe4G/BcrOn2R+B2vtNUk0q2edTn9xNJW
         AL70NPnJzz+tpo0Q5i9hyZaJlqjqv50br//rb2KRdIgIowLSanR/jL6yzgtKmFAW7mIH
         E+xn4rWaPOJc34tS/9kHvy89608iSLO0GB1SSw3rnsdAEoGJusIVkRNCMY9dZQxkoDhV
         bDvA==
X-Forwarded-Encrypted: i=1; AJvYcCVWrCT5VCVCKceYK5oh9JvUgi9venr5gERWlKfzkCzup9x8L9ufZnMHRi8JQLn9oSd7qtNufLBgXmP1D8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxUfMc0kF9WsE4uRjRUSIPP+pDrUfQEL38n+xIlRXDjL0DYBtz
	UIKeSNdhvM+BC7tnkHtEjKYQIt0BoU+eBcRn+i8nInpm0fKOQj/FntQ5RQfLtWtM/l6brjK0uO4
	p3DnGVqGqMtexmG8C+bHC/HambuTRBJnXbOuWBfHMpw==
X-Gm-Gg: ASbGncv1LyjDTfxsflOPdAill78quGNGeMckgOuXDPXNWomxZ/aoU0ULZzJB2MaMROP
	P5900+NdHClNwPBgQJKo9lVuRlyJiZ8ky20nEz4/e1R/vqSd31Qza9t/nNkl1BZpzNk2OtQHD/C
	FwkEj1QPSm102/PwwjaH78hS0Qo++/EwHRU18VLviNE7/RPiu2cSFqIdErs5WEbOg0DRXDUV4Lb
	mwFkFvNhItWkrY3piuGGn1PQQ==
X-Google-Smtp-Source: AGHT+IHQ8F3iADMu1+UWrg73CrYiGwX8UpQYUYOvtGC+LP7TmJAAopR8WHzWm3NU2ztOeAgz1cMRk77sbhDWFguLt2c=
X-Received: by 2002:ac2:4e16:0:b0:55b:8540:da24 with SMTP id
 2adb3069b0e04-55ce50133c8mr1226637e87.20.1755185305657; Thu, 14 Aug 2025
 08:28:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
In-Reply-To: <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 14 Aug 2025 16:28:13 +0100
X-Gm-Features: Ac12FXx9I9MrbtuwHaesyssft3AApB1lCQVaDorKwBHz1btfjTXbPnGjfwlVOBI
Message-ID: <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com
Cc: glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 7:14=E2=80=AFPM Marco Elver <elver@google.com> wrot=
e:
>
> [+Cc crypto maintainers]
>
> On Wed, 13 Aug 2025 at 15:38, Ethan Graham <ethan.w.s.graham@gmail.com> w=
rote:
> >
> > From: Ethan Graham <ethangraham@google.com>
>
> Should also Cc crypto maintainers, as they'll be the ones giving

Thanks Marco!

> feedback on how interesting this is to them. Use
> ./scripts/get_maintainer.pl for that in the next round, and either add
> the Cc list below your Signed-off-by so that git send-email picks it
> up only for this patch, or just for the whole series (normally
> preferred, so maintainers get context of the full series).
>
> > Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> > rsa_parse_priv_key to serve as real-world examples of how the framework=
 is used.
> >
> > These functions are ideal candidates for KFuzzTest as they perform comp=
lex
> > parsing of user-controlled data but are not directly exposed at the sys=
call
> > boundary. This makes them difficult to exercise with traditional fuzzin=
g tools
> > and showcases the primary strength of the KFuzzTest framework: providin=
g an
> > interface to fuzz internal, non-exported kernel functions.
> >
> > The targets are defined directly within the source files of the functio=
ns they
> > test, demonstrating how to colocate fuzz tests with the code under test=
.
> >
> > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > ---
> >  crypto/asymmetric_keys/pkcs7_parser.c | 15 ++++++++++++++
> >  crypto/rsa_helper.c                   | 29 +++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+)
> >
> > diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_=
keys/pkcs7_parser.c
> > index 423d13c47545..e8477f8b0eaf 100644
> > --- a/crypto/asymmetric_keys/pkcs7_parser.c
> > +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/err.h>
> >  #include <linux/oid_registry.h>
> >  #include <crypto/public_key.h>
> > +#include <linux/kfuzztest.h>
> >  #include "pkcs7_parser.h"
> >  #include "pkcs7.asn1.h"
> >
> > @@ -169,6 +170,20 @@ struct pkcs7_message *pkcs7_parse_message(const vo=
id *data, size_t datalen)
> >  }
> >  EXPORT_SYMBOL_GPL(pkcs7_parse_message);
> >
> > +struct pkcs7_parse_message_arg {
> > +       const void *data;
> > +       size_t datalen;
> > +};
> > +
> > +FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)

Not sure if it has been mentioned elsewhere, but one thing I already
don't like about it is that these definitions "pollute" the actual
source files. Might not be such a big deal here, but kernel source
files for core subsystems tend to become quite large and complex
already, so not a great idea to make them even larger and harder to
follow with fuzz definitions.

As far as I'm aware, for the same reason KUnit [1] is not that popular
(or at least less popular than other approaches, like selftests [2]).
Is it possible to make it that these definitions live in separate
files or even closer to selftests?

Ignat

> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
> > +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> > +       KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE=
_SIZE);
> > +
> > +       pkcs7_parse_message(arg->data, arg->datalen);
> > +}
> > +
> >  /**
> >   * pkcs7_get_content_data - Get access to the PKCS#7 content
> >   * @pkcs7: The preparsed PKCS#7 message to access
> > diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> > index 94266f29049c..79b7ddc7c48d 100644
> > --- a/crypto/rsa_helper.c
> > +++ b/crypto/rsa_helper.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/export.h>
> >  #include <linux/err.h>
> >  #include <linux/fips.h>
> > +#include <linux/kfuzztest.h>
> >  #include <crypto/internal/rsa.h>
> >  #include "rsapubkey.asn1.h"
> >  #include "rsaprivkey.asn1.h"
> > @@ -166,6 +167,20 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, con=
st void *key,
> >  }
> >  EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
> >
> > +struct rsa_parse_pub_key_arg {
> > +       const void *key;
> > +       size_t key_len;
> > +};
> > +
> > +FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
> > +       KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_S=
IZE);
> > +
> > +       struct rsa_key out;
> > +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> > +}
> > +
> >  /**
> >   * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in=
 the
> >   *                        provided struct rsa_key, pointers to the raw=
 key
> > @@ -184,3 +199,17 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, co=
nst void *key,
> >         return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_=
len);
> >  }
> >  EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
> > +
> > +struct rsa_parse_priv_key_arg {
> > +       const void *key;
> > +       size_t key_len;
> > +};
> > +
> > +FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
> > +       KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_=
SIZE);
> > +
> > +       struct rsa_key out;
> > +       rsa_parse_priv_key(&out, arg->key, arg->key_len);
> > +}
> > --
> > 2.51.0.rc0.205.g4a044479a3-goog
> >

[1]: https://docs.kernel.org/dev-tools/kunit/index.html
[2]: https://docs.kernel.org/dev-tools/kselftest.html
