Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AAB2E093B
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 08:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766134469; cv=none; b=uezI1D4rPQsD8tp5wwUDfHXH4NkWw7xzmloXr3axJSoTQyqu7zrd0LfpEZ4Rrv7bZxItef7N0AYMwSAO6t2p+xdKD5Yzq3bI4Si0o4iEe/uiwpE0HPJhSWqWYazDp+6Xu5vQSmbQAlCas64P0TcRL3mP95VAO6DmSfE3HjT5fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766134469; c=relaxed/simple;
	bh=NoxUVwNfgVTB6bg9sGbXpW6EBQP2qNETVT/baBFW7Ak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OV+39z/3L01LcYZGSoHsyrxUjKuO6KCOLf1B9YnjqRz+BaOJz5ziSmVPq/GZw1zpQ6xjJIpSvIgw2EeV+//rSE71axn0RqcePvrY78hCk1061uHBEl7TDJ/uqa+cHE/27BJ4pUalM2AbhLbGDDePZXzM20sb2W1oNdUIb+J2dbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XO+xPLx2; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XO+xPLx2"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fbc305552so1116274f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 00:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766134466; x=1766739266; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9XCG/x3CPy9rlQRHe4VVvN3GKkuv1UkakFP0rNsXXqk=;
        b=XO+xPLx2NAbxz4McBZ3sXAlJ2hfLxzCSQY9YnHVbZkkRSdkNiZGmndhhMrHFDZDtkC
         zTvKsj8j0YM3lpWnxIqQSaykk/Bym+1DJIPbwX/5lZwq5t9KXl2T9w3qEg7eU6nHHlRr
         V6o4h+Kmsw/WQOMr5VJ+uk438WjekyuJOQQot9YZqMfPqaGG4dFsKrmYwBSETgcqIIW/
         DLfAQaeIh1mfQ1G92JT62caj00Yz1ihquNruyE/VUpQYoqq3dSC6FwsQChSsN9pOE3FY
         ITZIaBYMKgxLWMfSU5ZVPH+1b/lmkCwvC8P/EMuze+KrGEEOOvxdol3dtNrkRB/5ov1l
         h8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766134466; x=1766739266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XCG/x3CPy9rlQRHe4VVvN3GKkuv1UkakFP0rNsXXqk=;
        b=RPG5oDkcKhQc0QHhPNIneNNoCHK8BdOHesKNmfH3ljzN4ag/b03SplYs+vRW82otn3
         yzChPa0YTfeWx1KL60urJaYZIv3g8ONX/BnIfKMxTdQTlgLiisNWtV3hxBGadc4UsTOA
         GwUdD2UJsAEtOjtO6vF8EfP6Wj7YqvAbtdYHq9j1ZTH+rdsCTYOQSb/Xf0olYo2k38+9
         wVjZOy4ygjEleCmUxJzXoXQ/a+dUplsdviLRVzLjPgVzTYshzswtGtXazU6p2fArIYmP
         q0bxYxhRwxQtM7FC5nXAYXMpejH9M3wjqjEu2GD+hi+P0B7c0wIyVg+LulIFJmof96yg
         JHbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHGQ2hvYipG2YGc1XIaBROL608A15dwpdMB0X9lzf7Ci1WBshpPlKKszxmRrLL6FUkA0qX+2r3Oc0qFdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr3MQT3bmnI1igs9GyBgDflCP7YFgBCsSAuizZTjFggx8Yj0M4
	8JNbwmGNFKyYovSqq2/p2oKgDRKdXPMdu+nSpsqaMGxsICpcNz/4Y+/OPk8gqMbNfp0yALQoS8U
	n4COTSfz+tN4Ax/vWRv3XBzNjC/P+yg9S907KUxAt
X-Gm-Gg: AY/fxX6NEJre6xUcAVyryMqfW76FY/+to/TFF8OoTqu9Fqzw75ztGGDxsfmreKfFTmy
	7EWFu87prk7f45pyJSK/2W7oIcEoIiDFU1JcS/rWBSJtxMUzoi91Cw2mgrXrnizMumVJvkOzmp0
	3Ir4hvbDJFxkKeSq4mIWYMdyjUfIzjR/I/uoDt90OURtAyangucZxZA9KdDpX9tW3wWwAN7igFi
	z4R1shbOWHDNnZHilACZz2qeNygFX+kBJbBBelRwogtqi4pfHUBeDuzFmhs0aXOXBS9tA==
X-Google-Smtp-Source: AGHT+IHUL0oRmRvKhg9dGvnkb454deRsSFvLMAeIV7Rbb7jjdY+u2GEmSYDYvkovvdkqAUgIg0TSMfQuqBE+xvdtLZQ=
X-Received: by 2002:a05:6000:2303:b0:431:342:ad42 with SMTP id
 ffacd0b85a97d-4324e50d6d7mr2149225f8f.44.1766134466082; Fri, 19 Dec 2025
 00:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219080850.921416-1-davidgow@google.com>
In-Reply-To: <20251219080850.921416-1-davidgow@google.com>
From: David Gow <davidgow@google.com>
Date: Fri, 19 Dec 2025 16:54:13 +0800
X-Gm-Features: AQt7F2oFKPIp-d3F7z6rSK7Ctsc22rNT_YxNItkO3zp-nwcoNaLw15JpfPBdQr0
Message-ID: <CABVgOSm1=+13RijNG=8P=Pow3mdEjecLUG5fcP4g_AqFo5QBOw@mail.gmail.com>
Subject: Re: [PATCH] kunit: Enforce task execution in {soft,hard}irq contexts
To: Eric Biggers <ebiggers@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Rae Moar <raemoar63@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000082a26006464a391a"

--00000000000082a26006464a391a
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Dec 2025 at 16:08, David Gow <davidgow@google.com> wrote:
>
> The kunit_run_irq_test() helper allows a function to be run in hardirq
> and softirq contexts (in addition to the task context). It does this by
> running the user-provided function concurrently in the three contexts,
> until either a timeout has expired or a number of iterations have
> completed in the normal task context.
>
> However, on setups where the initialisation of the hardirq and softirq
> contexts (or, indeed, the scheduling of those tasks) is significantly
> slower than the function execution, it's possible for that number of
> iterations to be exceeded before any runs in irq contexts actually
> occur. This occurs with the polyval.test_polyval_preparekey_in_irqs
> test, which runs 20000 iterations of the relatively fast preparekey
> function, and therefore fails often under many UML, 32-bit arm, m68k and
> other environments.
>
> Instead, ensure that the max_iterations limit counts executions in all
> three contexts, and requires at least one of each. This will cause the
> test to continue iterating until at least the irq contexts have been
> tested, or the 1s wall-clock limit has been exceeded. This causes the
> test to pass in all of my environments.
>
> In so doing, we also update the task counters to atomic ints, to better
> match both the 'int' max_iterations input, and to ensure they are
> correctly updated across contexts.
>
> Finally, we also fix a few potential assertion messages to be
> less-specific to the original crypto usecases.
>
> Fixes: b41dc83f0790 ("kunit, lib/crypto: Move run_irq_test() to common header")
> Signed-off-by: David Gow <davidgow@google.com>
> ---
>  include/kunit/run-in-irq-context.h | 41 ++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 13 deletions(-)
>

.. snip ..

> @@ -85,6 +88,10 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
>                 .test_specific_state = test_specific_state,
>         };
>         unsigned long end_jiffies;
> +       int hardirq_calls, softirq_calls;
> +       bool allctx = false;
> +
> +       max_iterations = 1;

Whoops! Left this debug line in.

v2 fixes it: https://lore.kernel.org/all/20251219085259.1163048-1-davidgow@google.com/

-- David

--00000000000082a26006464a391a
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
PzANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgjPkaNZtfSt3MhXRw7K0rRVdMmFrV
BONXMqPYSOAxVtIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUx
MjE5MDg1NDI2WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEADZ1aqIf1UFuJyVmbBztQkZV6MIvd5WC7eRJr1725Bpomjj3s/Lj10uoox40LnCvL
AIUg+4QWQbs33Lv0VOYqk3Y9+QGW3/PbQNSaDlb/G4voY0eT04AGTQk5lQTbYnsdk3vRZ1uK1ywk
2/noozAW6FSvJXsBJujNju6oXKcvQr5ofoBHUoOYDhl0+0DM0v22+sWrdvaEl3QkuXIqXBg3qj44
VHNRddC5H1V16xcJ09LP3zNmf8iUb/UZm1U5oBGK0lgru6Jq9LW6JXWBKS1/CmwTo0scCoa9iA2o
0Du5RnyX6boHfQ5yw0penVpwF0is3KK5O0PPFcazw9ju9dQh1Q==
--00000000000082a26006464a391a--
