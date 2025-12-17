Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BB73164D6
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765965254; cv=none; b=sXvzCYxIRtJzPXU9iw5K7cGDXtTdg1CxcWWYRCkYOGoiksjBy0w8U4c8i+8XdzLVlP0QpWIjOUS3i4wkqKNtzO9Kire08pMMnZUfwCzrtvXZdHKWmRbUnPzJom0Tiv/CUYAaXUze2BStWtfmV7QRHazOvo6KaOibENrBkLc/bEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765965254; c=relaxed/simple;
	bh=BnOhIFJHCEJ9Q568FxYeIyzQSVnBw5NFVMU7dCGNflw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtVFIQ00F3gbVafruvvU4HEEHim05mDv14wrEBgIevL1rvCyNJNyVXmowyZh/d+TMkd05IXLZ7SUadJhDWJ8SGaVh/HuzKWkP9t+D9kIsF1TeNA9kuCava2wNaJqR38AeJXIOmkeqE/WtKksZfRvrnBhW993rPPCEpGkSaWwAQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TGFH1MUg; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TGFH1MUg"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4308d81fdf6so2017294f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 01:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765965251; x=1766570051; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CLp87w2Zl0Q70lR4vWQMSXFwjDPnr4EdK4mZ1eR+I34=;
        b=TGFH1MUgpxZKc3tD5/LHhz5koy3C0pgzCJO3R+xtSi7NiE7wpmzDlaoAVV9y2OzlIJ
         6vBDunhg39UmGt4S+1NbJ7OJD3kR+WErBhr/v08yhMkUp0uDRshNktSPhP3iS0sxTliU
         YtiOVT0ieoXxvcY6PxnjsQclu++8+WA4Nx2fy5J1Iow1BqMF4Aj0G8+0Y2XgGkHuAK/p
         zWloD0uthy3Ci+RTH9tzTH6Uw4OQHhnKgmA9RuG4+6XUGbmCnPiMwTTjF4dernvPPDBT
         7Le5vyn5PT3WORtZTarfQbqkpzrMwyklNSjV5c26cHmlLgCnXONKRRxWa4xa+TQR3NYe
         +eRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765965251; x=1766570051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLp87w2Zl0Q70lR4vWQMSXFwjDPnr4EdK4mZ1eR+I34=;
        b=VYbuG4poUTCgGhKn+lUvpLzy3pXVffG77zYR7puMdvolcYMDowFS9VtP1trtO0ivbI
         dndey1iGf+Z/P1Fg56eNEfRzCHqLBUhELu3XdJy+AMuw03ivuUKMK+H+1gNDXrsGFrVr
         ZW/eP3goGYA4uNHocWMiSG0fDwrj50SZHUDjkgR3UmBkIs9Kxs7Ag9w3pvUK0Kn0LHfb
         lpDJtM+BcoKvSj/DPZwqiw0d0EZ2XNn6sAqgb9vbeiBoASwiFW1QMP8mObJ8W3MvnhRU
         w+cAIrTqsb3EA8jFrdev7QiokZtCkbITw5K7JSOsxmaCwNAcRzNwLAON3PW4uwujRBjs
         1UUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUylVtAXZcidLqRd+83enCkFLUK05b3aOtF11vgBOa8+C43vcXLAGU0xiLme0e4vHLE3R5dO6ALw7wqZe8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzIDHBYtnkhChsACP/aTNJ6fQJBK6+YoXLCUKrFRuaKpxFiNcc
	3HDkkPU8QawrX9pi2+/9M4LWu551BgtZFP+T2GDzDUXsRfTcGH5JTWEc1NHxDbb4X4Kk0j5dmMY
	Z8KpDZuTWcS5+X9cMHi7sdf5UVA8dAmEOnhDj3iOh
X-Gm-Gg: AY/fxX6ikduG7926KWfbXnvAmSrp4hju52aQi3wK837cEyNO/eNlzTi5SqOmS/GAfxy
	eFDUg9ehy5mvOGyuLn5AMgrKj6oR0cBYN/CrTV+4ABcgzAxbeSay+G9v4Ii+S0/O5FxKJXb4AYd
	C3wW9moVwHKgSLgVsxj8PbQSdmVq9NXamDJsYGcmynIEt1FaEecY/+5U++IOhLC2krg42F1PG5j
	k33X0xDyIU2HG2jWRjbsLjsBS5+fdREA20A3uStNjy8ECoqQ9iWf4MNLCBqWV3q2AxK/A==
X-Google-Smtp-Source: AGHT+IHcd1cBMf0tjP8Tm6lMXWPk4d4cjfoy1/ZgAckExl7D+GG/DiAIXXheLvRkdZgYaDznGnOmOsuTRFG8W6inc2c=
X-Received: by 2002:a05:6000:25c1:b0:431:3a5:d9b0 with SMTP id
 ffacd0b85a97d-43103a5db88mr7080182f8f.56.1765965250556; Wed, 17 Dec 2025
 01:54:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com> <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
In-Reply-To: <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
From: David Gow <davidgow@google.com>
Date: Wed, 17 Dec 2025 17:53:58 +0800
X-Gm-Features: AQt7F2oC_jvvXkvPODN4WxlSQbR6kIlWyRO8BredDW5Okb-nVmRsiAtrJ3vkYco
Message-ID: <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, andy.shevchenko@gmail.com, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007d39b0064622d303"

--0000000000007d39b0064622d303
Content-Type: text/plain; charset="UTF-8"

On Sat, 13 Dec 2025 at 08:07, Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 12/4/25 07:12, Ethan Graham wrote:
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> >
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters) that are difficult to exercise effectively from the syscall
> > boundary. It is intended for in-situ fuzzing of kernel code without
> > requiring that it be built as a separate userspace library or that its
> > dependencies be stubbed out. Using a simple macro-based API, developers
> > can add a new fuzz target with minimal boilerplate code.
> >
> > The core design consists of three main parts:
> > 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
> >     macros that allow developers to easily define a fuzz test.
> > 2. A binary input format that allows a userspace fuzzer to serialize
> >     complex, pointer-rich C structures into a single buffer.
> > 3. Metadata for test targets, constraints, and annotations, which is
> >     emitted into dedicated ELF sections to allow for discovery and
> >     inspection by userspace tools. These are found in
> >     ".kfuzztest_{targets, constraints, annotations}".
> >
> > As of September 2025, syzkaller supports KFuzzTest targets out of the
> > box, and without requiring any hand-written descriptions - the fuzz
> > target and its constraints + annotations are the sole source of truth.
> >
> > To validate the framework's end-to-end effectiveness, we performed an
> > experiment by manually introducing an off-by-one buffer over-read into
> > pkcs7_parse_message, like so:
> >
> > - ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> > + ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
> >
> > A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> > introduced in patch 7 successfully triggered the bug inside of
> > asn1_ber_decoder in under 30 seconds from a cold start. Similar
> > experiments on the other new fuzz targets (patches 8-9) also
> > successfully identified injected bugs, proving that KFuzzTest is
> > effective when paired with a coverage-guided fuzzing engine.
> >
>
> As discussed at LPC, the tight tie between one single external user-space
> tool isn't something I am in favor of. The reason being, if the userspace
> app disappears all this kernel code stays with no way to trigger.
>
> Ethan and I discussed at LPC and I asked Ethan to come up with a generic way
> to trigger the fuzz code that doesn't solely depend on a single users-space
> application.
>

FWIW, the included kfuzztest-bridge utility works fine as a separate,
in-tree way of triggering the fuzz code. It's definitely not totally
standalone, but can be useful with some ad-hoc descriptions and piping
through /dev/urandom or similar. (Personally, I think it'd be a really
nice way of distributing reproducers.)

The only thing really missing would be having the kfuzztest-bridge
interface descriptions available (or, ideally, autogenerated somehow).
Maybe a simple wrapper to run it in a loop as a super-basic
(non-guided) fuzzer, if you wanted to be fancy.

-- David

--0000000000007d39b0064622d303
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
Dxz3AgMBAAGjggHgMIIB3DAeBgNVHREEFzAVgRNkYXZpZGdvd0Bnb29nbGUuY29tMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFHZtY3XkWtC2
e2Idfk+0JyK7BLzzMFgGA1UdIARRME8wCQYHZ4EMAQUBAjBCBgorBgEEAaAyCgMDMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQC
MAAwgZoGCCsGAQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWdu
LmNvbS9jYS9nc2F0bGFzcjZzbWltZWNhMjAyMzBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3J0MB8GA1UdIwQYMBaA
FDO6vqPUOU0qGdfIZpJogf3BxsnGMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vY2EvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3JsMA0GCSqGSIb3DQEBCwUAA4ICAQBo
hqjbVaHxZoT6HHUuwQcTlbgXpuVi59bQPrSwb/6Pn1t3h3SLeuUCvOYpoQjxlWy/FexsPW+nWS0I
PUmWpt6sxbIRTKPfb7cPk32XezfnA0jexucybiXzkZKTrbI7zoMOzDIWpTKYZAonB9Zzi7Dso4An
ZOtz/E3yhdR/q1MK30d5fiCS0vorEd0Oy8Jzcc7TJ2HGMzEEXiFFvVrJYJHvfYOeXE4ywAG6YWO0
x78+bXeB9vkeWHhOYKyYXuAXrnHASddEICg1QlJCHDAISMC1Wn/tjqTMTt3sDAe+dhi9V1FEGTbG
g9PxPVP4huJEMIBu/MWNMzHfiW4E7eCHVPrmtX7CFDlMik7qsgQBbO5h6EcxBamhIflfMgoISsRJ
Vyll2E5BNVwkNstMgU3WMg5yIaQcuGFgFnMTrQcaLEEFPV3cCP9pgXovYDirnB7FKNdCZNHfeBY1
HEXJ2jIPDP6nWSbYoRry0TvPgxh5ZeM5+sc1L7kY75C8U4FV3t4qdC+p7rgqfAggdvDPa5BJbTRg
KAzwyf3z7XUrYp38pXybmDnsEcRNBIOEqBXoiBxZXaKQqaY921nWAroMM/6I6CVpTnu6JEeQkoi4
IgGIEaTFPcgAjvpDQ8waLJL84EP6rbLW6dop+97BXbeO9L/fFf40kBhve6IggpJSeU9RdCQ5czGC
Al0wggJZAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKjAo
BgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjYgU01JTUUgQ0EgMjAyMwIQAYQLf/BIzLow9kWqD8My
PzANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg8WSU37KJM6lEEw7My8LMCoVePdPU
v5PCtno3l44i2vUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUx
MjE3MDk1NDExWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEABmjx2K96q1SBsg3PYYnTVeEoaXlZFvs7uElaGpWLFc6y7d78VW6Mhwyxng8dkEED
487yTPg6n/Hyla9aA3ISmIwdr7Z1eSfxgCBMUfJxrAolMhJlLGrqZJ7f8rY/wS2jLLtVN84rIL/c
Wr7JYlUO8RnXNaSY3JExNpmVVBYq1PZR6vIJEaPuxQ460xloYSQwZgkbo9skBIZmNvLib2yOcmQU
QDMlxBzdGMCBvSQuXd+Q2S/jnPMxHt/Lc+THDv8Kf6hWFuhkCfKrBP8PkVmivogt8aid6IU7m1XK
S15pshmb7dKRdzdykfVbX2+5gygsW8nk4DhTK7E3leEwjcFSvg==
--0000000000007d39b0064622d303--
