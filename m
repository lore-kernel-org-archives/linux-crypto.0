Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD0393DEF
	for <linux-crypto@vger.kernel.org>; Fri, 22 Aug 2025 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755853085; cv=none; b=XHCKtydevvBfQ7YjWxv3XaQX00nujgJ1dsIyAxoKMCkL0xjbm4aCBFUQcrSLGTeLVcYrJJKpGEr3AurKMUP0m4GIvuhseSRVXW3KoRHViIy+/c5jh+zc91K6SXKMs+gpDKxnSsmXt2PYi+0/De0X5vXzYgeQJElz/TtaoaWvJYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755853085; c=relaxed/simple;
	bh=ALpsR/+QnYMzgrQAH5rBkSelUhchhJR0FMQTODwcgSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WI/jKV28gf7DrxWZeQr3+CUxjEUNdzRUG5H4bnBymS3iXFpquJEemjVv3B3FWcQUmpLmq2Dj6iPuzihmBiGB1tw+lTgpiwincyOUUZoWwcrkI91shiVtQYUQmzLT0N5fCn/bra1tlzLwVgML/gyWxNdQ1XROhiSNJmLeDy8R3qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pkNSMrOp; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pkNSMrOp"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-70d9f5bdf63so1411606d6.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 Aug 2025 01:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755853083; x=1756457883; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T9JU4KJhU3tISAjpEH/Fov7efxhoAOfJYnU/2TA6bkg=;
        b=pkNSMrOpb7sahO4Q+NtOqkuZnLaP2SAnXi2NIbKqZCtvascYlv8ay3x2HpDr+YXgt7
         vc9gAaUaNZjbDMDnP9jQHK/m+GYtWd6PBFhdRZvhHdXCD4nYhVhGiuiNJc/IDB/cjAVK
         orWVk2OedK/iWTI/JqWkbAu0PoiYUkih9fYCUZSNdCawtWr1OzUYSe2/twJHJvm7pPZ4
         6Ohq7SYZT/UyavqNo2hG1bZBDGQGrX/JeUmETLnzzr+wQUxk21wLFnmT4mFxiiRZKLJd
         ysgbYoBqgTo25wcjVlrxEh/u2ekeQHiNdbRB2b6cbHo9eS5XuUXMpP9xYtT4Ca+42FGj
         eRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755853083; x=1756457883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9JU4KJhU3tISAjpEH/Fov7efxhoAOfJYnU/2TA6bkg=;
        b=E3l8hA8v0+b7VxaQKJq7x54w7mhmYjikSc1dSGAo8hpdNzVtSkmHoCdcwo3HmxgQPn
         1/iy7ui32x9t2uICp7hLf4smKo7nQ/wSCdj4RJVsEUngzWFXo4aaRK9/pcKl+kVxRfsM
         5PW5ULLFeUwVZUWxdLhuYLiooV4jJTYdDjfzN5vBPuDm9dg1JCaI3bApPcdykAeB+5bc
         DKMe9H9UTPG3SxExRuy+IUeAlucPpf9MftK1nad5xZ+Yeyl7RtTFYdlSmA+XrP4inKQu
         i7b2j5lMnJVUyf8vUdKyQv8WtorTOW50rrHTODoPSqiXZc1jaagJ9IphTckSsTbjJ05U
         azjA==
X-Forwarded-Encrypted: i=1; AJvYcCXl3yoqe6S5E2/sKYTiDRJpSeb/sotAi6z/ViftBRVt/YNlA1q+uo9Yxru2WPAV9kd1Kw3yrKA3G22W6tU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD9hUuAwLFtmfUMC2UEH9ghrENdEFBrX3inUMylZpE69o3qowf
	6ykIInk49AJ9YNBTIuBWiDjXN92NaCHtbvCAWSkuX5CkXTs8Q+GprXFPSPeR1fDfOWwKTvJEjqD
	ClYypq4MkzWqK1b5rfo4u3a3Ch8Cf0mZvLeTpHTdb
X-Gm-Gg: ASbGncu5gv1qzOzkaVOcKyvwHtfEFrJSWbAqs/lq4ZqdesSHlNoTSnoJB2xgYz76TOe
	dk1/Jy1Nhh5Qyt1qQeoX4ZDjKZAMzlOILC2qX8nG4Z2439HjEhSfpQ2AH9uNBXpLqObW7gppgHp
	MDv+oekHGGdN9zZnabgHivBRKFGTFbM3qu97W8UjPOZFOS3CstdnkbWrULm4tznmAVlchXoC+tl
	3f6VYEu7v9v
X-Google-Smtp-Source: AGHT+IF3c1yLJidJzZUVZ9l29G/SnoKEGAF/5ONlc8c84CWTzJTLZ0ZRzg6LQbZvkByeQnyXh9t2hqoVTcjT4bVEWd0=
X-Received: by 2002:ad4:5bab:0:b0:707:55d3:9984 with SMTP id
 6a1803df08f44-70d97325aeamr29917046d6.45.1755853082204; Fri, 22 Aug 2025
 01:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
 <20250815011744.GB1302@sol> <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
 <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
In-Reply-To: <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
From: David Gow <davidgow@google.com>
Date: Fri, 22 Aug 2025 16:57:49 +0800
X-Gm-Features: Ac12FXzJsp2vCYslm6ERlK05gi4KeqjE3YdvQXHbGJxUAQ-w3a_LzfiA2QZcy44
Message-ID: <CABVgOS=7wrxywmgn8YRW4o_sUN=wOxa4k7NbTObAxA5okmr+CQ@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, Eric Biggers <ebiggers@kernel.org>, 
	Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, glider@google.com, 
	andreyknvl@gmail.com, brendan.higgins@linux.dev, dvyukov@google.com, 
	jannh@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004c1d5d063cf06703"

--0000000000004c1d5d063cf06703
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2025 at 18:08, Marco Elver <elver@google.com> wrote:
>
> On Fri, 15 Aug 2025 at 15:00, Ignat Korchagin <ignat@cloudflare.com> wrot=
e:
> >
> > On Fri, Aug 15, 2025 at 2:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> > > > Not sure if it has been mentioned elsewhere, but one thing I alread=
y
> > > > don't like about it is that these definitions "pollute" the actual
> > > > source files. Might not be such a big deal here, but kernel source
> > > > files for core subsystems tend to become quite large and complex
> > > > already, so not a great idea to make them even larger and harder to
> > > > follow with fuzz definitions.
> > > >
> > > > As far as I'm aware, for the same reason KUnit [1] is not that popu=
lar
> > > > (or at least less popular than other approaches, like selftests [2]=
).
> > > > Is it possible to make it that these definitions live in separate
> > > > files or even closer to selftests?
> > >
> > > That's not the impression I get.  KUnit suites are normally defined i=
n
> > > separate files, and KUnit seems to be increasing in popularity.
> >
> > Great! Either I was wrong from the start or it changed and I haven't
> > looked there recently.
> >
> > > KFuzzTest can use separate files too, it looks like?
> > >
> > > Would it make any sense for fuzz tests to be a special type of KUnit
> > > test, instead of a separate framework?
> >
> > I think so, if possible. There is always some hurdles adopting new
> > framework, but if it would be a new feature of an existing one (either
> > KUnit or selftests - whatever fits better semantically), the existing
> > users of that framework are more likely to pick it up.
>
> The dependency would be in name only (i.e. "branding"). Right now it's
> possible to use KFuzzTest without the KUnit dependency. So there is
> technical merit to decouple.
>

There's definitely some overlap between KFuzzTest and KUnit, from the
relatively superficial API similarities: both having similar
ASSERT/EXPECT macros; to the more specific: KUnit parameterised tests
allow running the same 'test' code against several different pieces of
input data.

Then again, there are definitely some differences, too: KUnit doesn't
have a way of describing complex binary data (though it's definitely a
feature we'd like one day), and the purpose of KUnit tests, while
having some overlap, is different than exposing fuzz targets.

If there's a bit of KUnit functionality you can reasonably re-use or
otherwise take advantage of, I'd not discourage you from doing so.
There's a balance to be struck between taking the extra dependency and
ending up with duplicate implementations of the same thing.

I also think that what Ignat says below around simply ensuring that
the API is familiar (i.e., not deviating from what KUnit or other
frameworks do without a good reason) is a good middle ground here.

So my gut feeling is that you could end up with one of three things:
- Make KFuzzTests a special case of (parameterised) KUnit tests. This
would probably involve adding a way to run the tests with a parameter
from debugfs or a kernel command-line argument using the metadata
format, and teaching the fuzzer to run KUnit tests. KUnit already has
an attributes mechanism that could be used to note which tests are
fuzz targets, and maybe even providing some of the annotation, but
there'd be some work needed to improve it. The big advantage here is
that you'd automatically gain the ability to use KUnit helpers to set
up things like memory regions, fake devices, etc.
- Share some of the implementation details between KUnit and
KFuzzTest, but keep them as separate things. We already have a bunch
of, e.g., work on assertions, logging, etc, which could possibly be
helpful. This could be done by depending on CONFIG_KUNIT or by
splitting those out into a shared test library.
- Keep them separate, but be careful to make the APIs similar enough
to be familiar. KFuzzTest already looks pretty similar to me, so I
think we're already in a good place here.

Personally, I'd quite like for there to be a bit more overlap/code
sharing -- at least eventually -- as I could see some benefits to
"borrowing" some KFuzzTest code to allow, e.g., providing custom
inputs/outputs for tests.

> Would sufficient documentation, and perhaps suggesting separate files
> to be the canonical way of defining KFuzzTests, improve the situation?
>
> For example something like:
> For subsystem foo.c, define a KFuzzTest in foo_kfuzz.c, and then in
> the Makfile add "obj-$(CONFIG_KFUZZTEST) +=3D foo_kfuzz.o".
> Alternatively, to test internal static functions, place the KFuzzTest
> harness in a file foo_kfuzz.h, and include at the bottom of foo.c.
>
> Alex, Ethan, and KUnit folks: What's your preference?

I think that keeping tests in separate files by default is the right
way to go, but obviously either #including them or using a whole bunch
of conditional symbol exports (either with symbol namespaces or
something like EXPORT_SYMBOL_IF_KUNIT) will be necessary in some cases
to get coverage of internal functions.

I'd suggest being a little careful with the naming scheme, as Linus
was not happy with the foo_test.c names we were using as they make tab
completion more annoying; we ended up putting tests in a 'tests/'
subdirectory where appropriate:
https://docs.kernel.org/dev-tools/kunit/style.html

But ultimately, I think this is a style decision, not a critically
important technical one: provide some good practices to follow -- and
encourage people to be consistent -- but understand that occasionally
a maintainer will override it (sometimes even for good reason).

Cheers,
-- David

--0000000000004c1d5d063cf06703
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIUnQYJKoZIhvcNAQcCoIIUjjCCFIoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghIEMIIGkTCCBHmgAwIBAgIQfofDAVIq0iZG5Ok+mZCT2TANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNDdaFw0zMjA0MTkwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFI2IFNNSU1FIENBIDIwMjMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYydcdmKyg
4IBqVjT4XMf6SR2Ix+1ChW2efX6LpapgGIl63csmTdJQw8EcbwU9C691spkltzTASK2Ayi4aeosB
mk63SPrdVjJNNTkSbTowej3xVVGnYwAjZ6/qcrIgRUNtd/mbtG7j9W80JoP6o2Szu6/mdjb/yxRM
KaCDlloE9vID2jSNB5qOGkKKvN0x6I5e/B1Y6tidYDHemkW4Qv9mfE3xtDAoe5ygUvKA4KHQTOIy
VQEFpd/ZAu1yvrEeA/egkcmdJs6o47sxfo9p/fGNsLm/TOOZg5aj5RHJbZlc0zQ3yZt1wh+NEe3x
ewU5ZoFnETCjjTKz16eJ5RE21EmnCtLb3kU1s+t/L0RUU3XUAzMeBVYBEsEmNnbo1UiiuwUZBWiJ
vMBxd9LeIodDzz3ULIN5Q84oYBOeWGI2ILvplRe9Fx/WBjHhl9rJgAXs2h9dAMVeEYIYkvW+9mpt
BIU9cXUiO0bky1lumSRRg11fOgRzIJQsphStaOq5OPTb3pBiNpwWvYpvv5kCG2X58GfdR8SWA+fm
OLXHcb5lRljrS4rT9MROG/QkZgNtoFLBo/r7qANrtlyAwPx5zPsQSwG9r8SFdgMTHnA2eWCZPOmN
1Tt4xU4v9mQIHNqQBuNJLjlxvalUOdTRgw21OJAFt6Ncx5j/20Qw9FECnP+B3EPVmQIDAQABo4IB
ZTCCAWEwDgYDVR0PAQH/BAQDAgGGMDMGA1UdJQQsMCoGCCsGAQUFBwMCBggrBgEFBQcDBAYJKwYB
BAGCNxUGBgkrBgEEAYI3FQUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUM7q+o9Q5TSoZ
18hmkmiB/cHGycYwHwYDVR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwewYIKwYBBQUHAQEE
bzBtMC4GCCsGAQUFBzABhiJodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vcm9vdHI2MDsGCCsG
AQUFBzAChi9odHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9yb290LXI2LmNydDA2
BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL3Jvb3QtcjYuY3JsMBEG
A1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0BAQwFAAOCAgEAVc4mpSLg9A6QpSq1JNO6tURZ4rBI
MkwhqdLrEsKs8z40RyxMURo+B2ZljZmFLcEVxyNt7zwpZ2IDfk4URESmfDTiy95jf856Hcwzdxfy
jdwx0k7n4/0WK9ElybN4J95sgeGRcqd4pji6171bREVt0UlHrIRkftIMFK1bzU0dgpgLMu+ykJSE
0Bog41D9T6Swl2RTuKYYO4UAl9nSjWN6CVP8rZQotJv8Kl2llpe83n6ULzNfe2QT67IB5sJdsrNk
jIxSwaWjOUNddWvCk/b5qsVUROOuctPyYnAFTU5KY5qhyuiFTvvVlOMArFkStNlVKIufop5EQh6p
jqDGT6rp4ANDoEWbHKd4mwrMtvrh51/8UzaJrLzj3GjdkJ/sPWkDbn+AIt6lrO8hbYSD8L7RQDqK
C28FheVr4ynpkrWkT7Rl6npWhyumaCbjR+8bo9gs7rto9SPDhWhgPSR9R1//WF3mdHt8SKERhvtd
NFkE3zf36V9Vnu0EO1ay2n5imrOfLkOVF3vtAjleJnesM/R7v5tMS0tWoIr39KaQNURwI//WVuR+
zjqIQVx5s7Ta1GgEL56z0C5GJoNE1LvGXnQDyvDO6QeJVThFNgwkossyvmMAaPOJYnYCrYXiXXle
A6TpL63Gu8foNftUO0T83JbV/e6J8iCOnGZwZDrubOtYn1QwggWDMIIDa6ADAgECAg5F5rsDgzPD
hWVI5v9FUTANBgkqhkiG9w0BAQwFADBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBS
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
jmkLAgMBAAGjggHgMIIB3DAeBgNVHREEFzAVgRNkYXZpZGdvd0Bnb29nbGUuY29tMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFBp5bTxrTm/d
WMmRETO8lNkA4c7fMFgGA1UdIARRME8wCQYHZ4EMAQUBAjBCBgorBgEEAaAyCgMDMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQC
MAAwgZoGCCsGAQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWdu
LmNvbS9jYS9nc2F0bGFzcjZzbWltZWNhMjAyMzBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3J0MB8GA1UdIwQYMBaA
FDO6vqPUOU0qGdfIZpJogf3BxsnGMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vY2EvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3JsMA0GCSqGSIb3DQEBCwUAA4ICAQBF
tO3/N2l9hTaij/K0xCpLwIlrqpNo0nMAvvG5LPQQjSeHnTh06tWTgsPCOJ65GX+bqWRDwGTu8WTq
c5ihCNOikBs25j82yeLkfdbeN/tzRGUb2RD+8n9I3CnyMSG49U2s0ZdncsrIVFh47KW2TpHTF7R8
N1dri01wPg8hw4u0+XoczR2TiBrBOISKmAlkAi+P9ivT31gSHdbopoL4x0V2Ow9IOp0chrQQUZtP
KBytLhzUzd9wIsE0QMNDbw6jeG8+a4sd17zpXSbBywIGw7sEvPtnBjMaf5ib3kznlOne6tuDVx4y
QFExTCSrP3OTMUkNbpIdgzg2CHQ2aB8i8YsTZ8Q8Q8ztPJ+xDNsqBUeYxILLjTjxQQovToqipB3f
6IMyk+lWCdDS+iCLYZULV1BTHSdwp1NM3t4jZ8TMlV+JzAyRqz4lzSl8ptkFhKBJ7w2tDrZ3BEXB
8ASUByRxeh+pC1Z5/HhqfiWMVPjaWmlRRJVlRk+ObKIv2CblwxMYlo2Mn8rrbEDyfum1RTMW55Z6
Vumvw5QTHe29TYxSiusovM6OD5y0I+4zaIaYDx/AtF0mMOFXb1MDyynf1CDxhtkgnrBUseHSOU2e
MYs7IqzRap5xsgpJS+t7cp/P8fdlCNvsXss9zZa279tKwaxR0U2IzGxRGsWKGxDysn1HT6pqMDGC
Al0wggJZAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKjAo
BgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjYgU01JTUUgQ0EgMjAyMwIQAUXA7LnOuRz2DvkWTeMc
0TANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg9H0TO/qid64EtuSTX99+cSgt7eo0
VC+zREg+oYNxnT4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUw
ODIyMDg1ODAzWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAH5FxfGzMR9w2OCmWaVMafGBbv4Qguo1JgOQbNeS2a4bIuN9GrZEM9hu4pgF+OKQP
cR6eMy7Ac7IUZk0H0oWcNqxbVPFgtoqynW9/FhZa4iLA7P2j38xNJa/5PJVt/rxXqWYJ+W6Rnmyh
FsiFNn9ZjDTD7/CsvVpmmd1Gu/kFadQRcxby4chuBRHxTO1pV3ml7XN3hNzoyxmtEyJnh9NoZgiM
e3z/CR5MvdRnOB8CxVDIg/TpinvTbGBbQnEMDbpIF2TzL3nkUqYbhLISvKOPAVADMa9dsBG8wiSC
+oqZYUCZ0y2TRXLHvED/0mrTygSNSzPvxs+QCLCijyJ89lmfaA==
--0000000000004c1d5d063cf06703--
