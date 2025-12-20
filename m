Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858BC2D4805
	for <linux-crypto@vger.kernel.org>; Sat, 20 Dec 2025 06:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766212659; cv=none; b=PH2ztjFoB86mXLjGoHYogyUdMY+KlY9ryNLEpgIX535B4f8MHmacGhAri5RN9AgGozPTZAUkSrIREcq2TAo2BKwCteZthy75UyJ2ISWkRGtmbjuElrXaqZvOToHNb3LRZM+k6A7cCf2AcxHV0rOpjrjfGWYrHXC1y08PnayL9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766212659; c=relaxed/simple;
	bh=9gqH+ljH8CIJz+w+e9D65iHpM9/IfSrrDlqo9jQSDCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bGln+f67bMp9PAzCfmmPED1Ea+6RLtuSbs3r8Py8gUnxEvCjYpnpFC3q1q87LazR1VtcRwZPX5M05hWFE5yoAXlBzp3KA+jLPJ5t1t07K5nTtlmZANoALG0qjdlvhE1SxdrravHKV8uybQ8Emneb3+pauF1zKkqiFD829P2mU6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vIXmsuZF; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vIXmsuZF"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42e2e628f8aso1028398f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 22:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766212654; x=1766817454; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yAlCY9x6iP3VEUTXLNZoFygltTzSzbeJmm06YgUUvvQ=;
        b=vIXmsuZFB4esJXBzirKruZoTBnyEnBbJQoaH/Zkz1YzLzT0HkGP/zJyxvrsBOaX3Su
         ioGdY9lS8jNFGwBW2rN5rL9+yqDQAfgKph88szG/sazSaAdFQvuvNYQTQ/taSWUFk0j8
         k44hcXovd+3X9hpd1wfkl9//EZz5mBxU48M/QPj0AIJn/x5gqjnQsfbj7EsEBvNXjf2h
         OMgnZ8XFidp0gWIdif1gFedjPIEsjxOVz0lTfgAHRYSgCkjioUtNcaPA0BLhuYm7hWLi
         PDI/K3G6u56nbgRnHSK+VNHaVptDWFAFY26piNFY/x1OF8uvomNQ+PruM7os2EISUSXz
         WM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766212654; x=1766817454;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAlCY9x6iP3VEUTXLNZoFygltTzSzbeJmm06YgUUvvQ=;
        b=fNLAOpdcq30k6zcvZ5LV9cwIoamyC7bL1V/nxaNCV0xnI5wPOEa0i4+Z8P3C2JibqY
         ENmix5NQG8LWFf6XtBuRkRABKAjlIIrnLAru+7hS2QRWXJtB6RFK/q0Iun+Zm0UkiTwT
         xtmEEvyL3+FZA4N2OEQhjqP9grSF/16kjLUchdFlBMLuk18qKUQVDPFHydXGVzAz1UEA
         wlL9rtet1E+el8FWYIFaDORalm9BOjoZBxthiK/VHqAm//6CqD90F3oB/waGNM0lEr7x
         tvGQadZ67t9f8E/0k8O7hq+mvFtGj4NXgugL8/GimaAIHlMKna9f3bo45E65CipDDEOm
         xQJg==
X-Forwarded-Encrypted: i=1; AJvYcCV2aHA+TitAmxdZjiokUZtkS7ulTtuwOgH/3lkmuJwTyfv7yvKQoY5SfjxKkOEniy1H9xgE2TDIYoAHKgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWAsTOgdKMAO3/DRiuesxo8hVJk1/gF5eQYUcPMYWDQbLFZHSV
	exaRz0lkSxDN97MuhR4x60p4qLPEx+1eTejA8fBiKXw+Ilal2rUNq+UGZBFOwSXizeHWb3IAuBX
	GKcrUDST82P2c3Nu45TVCrHtgnOTReQ34CpTIaeAZ
X-Gm-Gg: AY/fxX7ETjZVcjDpvuueJ+Gw2XmiO5UhegZQJFXZSlhYjrfSk1B5KGqgRdDPfsGDH8H
	zGewj0bCzcipSSsE6+2tbB8ycWUe6/g9zENC9dK+498b62pktT2z6424G7tjnCJ5NDs+K9F9vNI
	NsZbgKEJ2B/DLoLYPkoKO8AWZODSkbbJs5ijsQCuVbyTfs/CWFP4BI+dOzA/qa6A91whZFi1IZ/
	driumIbtvSahZHe0pQanFzZmCWZUWIf54j355zis9sEpSsEKetCyPO/dOg5psOz6XoPWQ==
X-Google-Smtp-Source: AGHT+IGTpyc7b4bivJRNGFE/mdSRx8SZKpEnTqJ//u9kSEgiVDljS6wsx7qNKsqizRofJeABeiwWOUE+HHMEyzPJNMs=
X-Received: by 2002:a5d:5f85:0:b0:431:6ba:38bd with SMTP id
 ffacd0b85a97d-4324e4c715fmr5926274f8f.10.1766212654200; Fri, 19 Dec 2025
 22:37:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219085259.1163048-1-davidgow@google.com> <20251219190547.GB1602@sol>
In-Reply-To: <20251219190547.GB1602@sol>
From: David Gow <davidgow@google.com>
Date: Sat, 20 Dec 2025 14:37:22 +0800
X-Gm-Features: AQt7F2pgc0DEQR1SRH_TTdLlzBsMrnx4w5dJ3-8glT6qrK039PqEJlm_6V9iSSY
Message-ID: <CABVgOSmr4HEbOVKs1FZEmP_xwDExDxB8JZjFy0gfZWj01fqByQ@mail.gmail.com>
Subject: Re: [PATCH v2] kunit: Enforce task execution in {soft,hard}irq contexts
To: Eric Biggers <ebiggers@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e29db006465c6dc4"

--000000000000e29db006465c6dc4
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Dec 2025 at 03:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Dec 19, 2025 at 04:52:58PM +0800, David Gow wrote:
> > The kunit_run_irq_test() helper allows a function to be run in hardirq
> > and softirq contexts (in addition to the task context). It does this by
> > running the user-provided function concurrently in the three contexts,
> > until either a timeout has expired or a number of iterations have
> > completed in the normal task context.
> >
> > However, on setups where the initialisation of the hardirq and softirq
> > contexts (or, indeed, the scheduling of those tasks) is significantly
> > slower than the function execution, it's possible for that number of
> > iterations to be exceeded before any runs in irq contexts actually
> > occur. This occurs with the polyval.test_polyval_preparekey_in_irqs
> > test, which runs 20000 iterations of the relatively fast preparekey
> > function, and therefore fails often under many UML, 32-bit arm, m68k and
> > other environments.
> >
> > Instead, ensure that the max_iterations limit counts executions in all
> > three contexts, and requires at least one of each. This will cause the
> > test to continue iterating until at least the irq contexts have been
> > tested, or the 1s wall-clock limit has been exceeded. This causes the
> > test to pass in all of my environments.
> >
> > In so doing, we also update the task counters to atomic ints, to better
> > match both the 'int' max_iterations input, and to ensure they are
> > correctly updated across contexts.
> >
> > Finally, we also fix a few potential assertion messages to be
> > less-specific to the original crypto usecases.
> >
> > Fixes: b41dc83f0790 ("kunit, lib/crypto: Move run_irq_test() to common header")
> > Signed-off-by: David Gow <davidgow@google.com>
> > ---
> >
> > Changes since v1:
> > https://lore.kernel.org/all/20251219080850.921416-1-davidgow@google.com/
> > - Remove a leftover debug line which forced max_iterations to 1.
>
> Thanks!  I'd like to take this through libcrypto-fixes, if that's okay
> with the KUnit folks (acks would be appreciated).  kunit_run_irq_test()
> is a recently-added helper function used by the crypto and CRC tests.

No worries: I don't think there are any other tests using this at the
moment; certainly nothing that needs the fix.

> For the Fixes commit, we should use the initial addition of this code:
>
>     Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")

Sounds good: I'm sure it'll be a tiny bit trickier to backport this
(and, e.g, the changes to the error messages aren't useful) to older
branches (and certainly I never saw any issues prior to the polyval
tests), but it is technically more correct, which is the best kind of
correct. :-)

Cheers,
-- David

--000000000000e29db006465c6dc4
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
PzANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg+LV6I9zFI9+K/+x/6NCBsZQ7UwQb
cu0Ra+Cqg80RCJ8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUx
MjIwMDYzNzM0WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAXR37J1Eyc8xHn4trxn91FBtHdyO7tp33FwLFOeJKA/2Hjye4fwmWnBeKpqRmUmPc
7fMYn57gz0wrCYM/YBjV9XxO0F1YI9iNTpmNN6qSowdzQYFuhwDRIIMv1r4ICQddk/11qBk7CpnV
19hjWgNEdLjjaFhsasPB3v2fXgQwaixHXB4pw2I9J/TwohTGxGcRMtP/caLflPhxeXwcHFFU7WAS
Lp/TT3cM99xPzoyfi8p/whZVGM9dy8LIbyafMrisuVs+6Ha+OOre8MAlOaZfkNGt8mrrd2EbsLhl
Jyzb5frjcHAu0/nlE5nje6avoOZfDLrxRn3/YCQ8zTGdRe9mwA==
--000000000000e29db006465c6dc4--
