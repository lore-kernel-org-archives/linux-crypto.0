Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D3547125E
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552444; cv=none; b=sn4iewFuwiEn4rkwBCJrbxn6NBb3/6EJ+FR0+Wk5tUWSsxudWAerG7B+4VWRRX5SM6IuxCoTDcBH+nO+X66JJ6etGSMAra3GL6Z3cr3Ct4FkrCV4RIMue+RcPtF3/ldAmnQFqwjVwx6TczT1JBEG7w7VI6xb+4MkjvFPnMJZKQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552444; c=relaxed/simple;
	bh=SLmT1GgNQU3kWcxbSG+Q5XK2/G1R5xmyTnBKqlDN6EQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7F7GfO41AzfXKI2dn2lyWkYQEaqe2s97J+9eaQofVdDmFguKcfE+0wM8M5vBcqzmot1w75lm4v6TDw3hqw6+C3+jzXk+t3Wj4r6+/bLPz0xupIK7pK9CRtRv97V5LpUrREiBw/yJWbV6mB1n/9ZsILdNUP29L6jgCzin8O8/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qfx+O4ci; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qfx+O4ci"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-80e2cfe6918so13019617b3.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 09:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786552441; x=1787157241; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iM+NaC1zlJR/NpoZRDW4qwLcabieecck7HoE7aO5nQA=;
        b=Qfx+O4ci8HJ+CSmg+ol4VWZqWmBJQU0ll5dEl32zj+MqyUmSFvM1KHsJczGXIg+tN/
         J7Uym5CAi82XIydVsxtAwWIpinjo6f92rePAMJB77aIwSFisJgo3g6A3QGbHD0A4yXS4
         07/DAw7mVs8zi8jd5BcKHcm1gBS7qi75L0b8tPKSAoz54evFOk4nQIUMwNfes6mr9kTN
         4HZyw0ReFdFz0hSZFVSR562yVGjPqyMPRgQK3hfDODDW4nynMRUFw7E4uFzNK7+rEXG/
         2PXqrCJjgrVHnrNuicC9VeZfTcIBauXhXk1Ufw+weQgXF3LL/eCoqjI2oAEKP4ojltgk
         Tfvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552441; x=1787157241;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iM+NaC1zlJR/NpoZRDW4qwLcabieecck7HoE7aO5nQA=;
        b=cmdvMoNdmTF6pSI8LfZpM15UH44V1w/LQwUFL7R6GI7VriuG2+UYKGmyDcaWI4fQSn
         7ci2e/cWUb175xpbK2lq28u/kCPHGjz/1HorgD1EKy2D4BGIVtyy2RExloKBuOHiIPsF
         gTTDr43THawMDMCQTiNFn0PcUiBuBcgfrC6KedOHN9AS3uYO0ptHwn18W5Iv5bCOHO9J
         6GNz/X/DARGlTvRrsdys1VTDVsSxyufpVc+845p5HqoZopeI37Y4eKTtCDo21dO6ASEU
         QU1IrkvwvSxmcOsLZzn00JxtmM1Z68BkUmZwvz+aEEE9BHaDp3lVC5yMuG7J+0Eu2uPw
         UMwQ==
X-Gm-Message-State: AOJu0YzPqYMwef6WyQT3KRzSZJ2cpv3o5dUKZHupelcKmNR9KYWBaRl8
	tZwcIFmcHjq4l2dhardyzlX7HLyjDACFwEx7pNx2KgLP3YE/AaeODhNP
X-Gm-Gg: AR+sD10moEFwLnFSsgAV5xpSG9dIfTVnQO7R7darJbXw6NwxE+TgtlsqXtfhmRPMnNK
	oAV63OLFdQrWp3cjxrSgN/Gs3WPaAppCK6kJgQZInw4gSa6nfLhrNh/JgygJSESr2x5AsCpoZiv
	HI6OLpb6bPwTX5dgMoek6rHUuMWeOwtYY2tSNmxtDu1Dp9B3LSRcCMO1irWFPACNmu6z6Q+CX3l
	VEcgIzVm5odIZXARQ3k0bUkmUmMs1EFbyyOtmRaXhvB20jyTlzlHR6JwN0h9ydib011SzMWx0vv
	u4W69fSYzvUaTEtBgI5xzFBNpfpIjcSClQDesdw4PuSnlRAfpIOhxOUayPceomklyFN03eaDUo/
	2XVjy4QVCfT4Zxrm1NRyF3r5FDaSoYWbBx7jGHn3pFMBPCV6oevLbprxxuOhDxJcumyWHxUAcXl
	W5bkDp2/NfQohgsB4DxsxHzbGBkSKpJ8/byrmoFsLsrRfafelQ3k21gtoHN1T0wBk=
X-Received: by 2002:a05:690e:44e0:b0:667:bc49:373d with SMTP id 956f58d0204a3-66b34307b1bmr2246810d50.33.1786552441348;
        Wed, 12 Aug 2026 09:34:01 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-830a368e86asm15513787b3.1.2026.08.12.09.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 09:34:00 -0700 (PDT)
Message-ID: <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
Date: Wed, 12 Aug 2026 12:33:45 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Bartosz Golaszewski <brgl@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Kuldeep Singh
 <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GyUom66QLghtcvfW8pbhyBYR"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GyUom66QLghtcvfW8pbhyBYR
Content-Type: multipart/mixed; boundary="------------6zVWfHQIO5csRmwlYh0DKQg0";
 protected-headers="v1"; hp="clear"
Message-ID: <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
Date: Wed, 12 Aug 2026 12:33:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Bartosz Golaszewski <brgl@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Kuldeep Singh
 <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49yB+l2nipd
 aq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYfbWpr/si88QKgyGSV
 Z7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/UorR+FaSuVwT7rqzGrTlscnT
 DlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7MMPCJwI8JpPlBedRpe9tfVyfu3euTPLPx
 wcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9Hzx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR
 6h3nBc3eyuZ+q62HS1pJ5EvUT1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl
 5FMWo8TCniHynNXsBtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2
 Bkg1b//r6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
 9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nSm9BBff0N
 m0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQABzTxEZW1pIE1hcmll
 IE9iZW5vdXIgKGxvdmVyIG9mIGNvZGluZykgPGRlbWlvYmVub3VyQGdtYWlsLmNvbT7CwXgE
 EwECACIFAlp+A0oCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELKItV//nCLBhr8Q
 AK/xrb4wyi71xII2hkFBpT59ObLN+32FQT7R3lbZRjVFjc6yMUjOb1H/hJVxx+yo5gsSj5LS
 9AwggioUSrcUKldfA/PKKai2mzTlUDxTcF3vKx6iMXKA6AqwAw4B57ZEJoMM6egm57TV19kz
 PMc879NV2nc6+elaKl+/kbVeD3qvBuEwsTe2Do3HAAdrfUG/j9erwIk6gha/Hp9yZlCnPTX+
 VK+xifQqt8RtMqS5R/S8z0msJMI/ajNU03kFjOpqrYziv6OZLJ5cuKb3bZU5aoaRQRDzkFIR
 6aqtFLTohTo20QywXwRa39uFaOT/0YMpNyel0kdOszFOykTEGI2u+kja35g9TkH90kkBTG+a
 EWttIht0Hy6YFmwjcAxisSakBuHnHuMSOiyRQLu43ej2+mDWgItLZ48Mu0C3IG1seeQDjEYP
 tqvyZ6bGkf2Vj+L6wLoLLIhRZxQOedqArIk/Sb2SzQYuxN44IDRt+3ZcDqsPppoKcxSyd1Ny
 2tpvjYJXlfKmOYLhTWs8nwlAlSHX/c/jz/ywwf7eSvGknToo1Y0VpRtoxMaKW1nvH0OeCSVJ
 itfRP7YbiRVc2aNqWPCSgtqHAuVraBRbAFLKh9d2rKFB3BmynTUpc1BQLJP8+D5oNyb8Ts4x
 Xd3iV/uD8JLGJfYZIR7oGWFLP4uZ3tkneDfYzsFNBFp+A0oBEAC9ynZI9LU+uJkMeEJeJyQ/
 8VFkCJQPQZEsIGzOTlPnwvVna0AS86n2Z+rK7R/usYs5iJCZ55/JISWd8xD57ue0eB47bcJv
 VqGlObI2DEG8TwaW0O0duRhDgzMEL4t1KdRAepIESBEA/iPpI4gfUbVEIEQuqdqQyO4GAe+M
 kD0Hy5JH/0qgFmbaSegNTdQg5iqYjRZ3ttiswalql1/iSyv1WYeC1OAs+2BLOAT2NEggSiVO
 txEfgewsQtCWi8H1SoirakIfo45Hz0tk/Ad9ZWh2PvOGt97Ka85o4TLJxgJJqGEnqcFUZnJJ
 riwoaRIS8N2C8/nEM53jb1sH0gYddMU3QxY7dYNLIUrRKQeNkF30dK7V6JRH7pleRlf+wQcN
 fRAIUrNlatj9TxwivQrKnC9aIFFHEy/0mAgtrQShcMRmMgVlRoOA5B8RTulRLCmkafvwuhs6
 dCxN0GNAORIVVFxjx9Vn7OqYPgwiofZ6SbEl0hgPyWBQvE85klFLZLoj7p+joDY1XNQztmfA
 rnJ9x+YV4igjWImINAZSlmEcYtd+xy3Li/8oeYDAqrsnrOjb+WvGhCykJk4urBog2LNtcyCj
 kTs7F+WeXGUo0NDhbd3Z6AyFfqeF7uJ3D5hlpX2nI9no/ugPrrTVoVZAgrrnNz0iZG2DVx46
 x913pVKHl5mlYQARAQABwsFfBBgBAgAJBQJafgNKAhsMAAoJELKItV//nCLBwNIP/AiIHE8b
 oIqReFQyaMzxq6lE4YZCZNj65B/nkDOvodSiwfwjjVVE2V3iEzxMHbgyTCGA67+Bo/d5aQGj
 gn0TPtsGzelyQHipaUzEyrsceUGWYoKXYyVWKEfyh0cDfnd9diAm3VeNqchtcMpoehETH8fr
 RHnJdBcjf112PzQSdKC6kqU0Q196c4Vp5HDOQfNiDnTf7gZSj0BraHOByy9LEDCLhQiCmr+2
 E0rW4tBtDAn2HkT9uf32ZGqJCn1O+2uVfFhGu6vPE5qkqrbSE8TG+03H8ecU2q50zgHWPdHM
 OBvy3EhzfAh2VmOSTcRK+tSUe/u3wdLRDPwv/DTzGI36Kgky9MsDC5gpIwNbOJP2G/q1wT1o
 Gkw4IXfWv2ufWiXqJ+k7HEi2N1sree7Dy9KBCqb+ca1vFhYPDJfhP75I/VnzHVssZ/rYZ9+5
 1yDoUABoNdJNSGUYl+Yh9Pw9pE3Kt4EFzUlFZWbE4xKL/NPno+z4J9aWemLLszcYz/u3XnbO
 vUSQHSrmfOzX3cV4yfmjM5lewgSstoxGyTx2M8enslgdXhPthZlDnTnOT+C+OTsh8+m5tos8
 HQjaPM01MKBiAqdPgksm1wu2DrrwUi6ChRVTUBcj6+/9IJ81H2P2gJk3Ls3AVIxIffLoY34E
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>

--------------6zVWfHQIO5csRmwlYh0DKQg0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/12/26 04:07, Bartosz Golaszewski wrote:
> On Wed, 12 Aug 2026 00:41:10 +0200, Eric Biggers <ebiggers@kernel.org> =
said:
>> On Tue, Aug 11, 2026 at 08:42:55AM -0500, Bartosz Golaszewski wrote:
>>
>>> No, the rationale has never been this. FWIW it can be that it's used =
for
>>> testing of the crypto module on a supported platform and that is alre=
ady
>>> enough of a reason to keep it upstream.
>>>
>>> As I've said before: we don't just drop maintained drivers from linux=
=2E
>>
>> We definitely do if the drivers are not useful or appropriate for
>> inclusion in the kernel, though the policy varies by subsystem.  Even
>> just last month an entire filesystem got dropped despite someone wanti=
ng
>> to maintain it.
>>
>=20
> I suppose you're talking about EFS? A thing that can't even be tested o=
n real
> hardware? This is a much more extreme case. Here you have several peopl=
e
> representing the vendor saying they want to keep and maintain it. I'm f=
ine
> having my own tree and sending PRs to Herbert if he agrees and you are =
of
> course entirely free to disregard any patches targetting it.

Would you be okay with one of these options?

1. Make the stub driver as the default, with
   the real driver guarded by an off-by-default Kconfig option.

2. Keep the driver as is (with the power management issue fixed),
   but don't register any algorithm implementations with the crypto API.

3. Only register algorithm implementations with the crypto API if a
   non-default Kconfig option is selected.

4. Only register algorithm implementations with the crypto API if a
   non-default module parameter is selected.

5. Move the driver out of drivers/crypto, delete the algorithm
   registrations, and then add support for restricted media content
   decryption later.

The last option would be my preferred one.

Also, if Qualcomm has customers who use the QCE via the crypto API,
is Qualcomm aware of _why_ they made that choice?  From Eric's and
my perspective, that seems like a very strange decision, unless there
are factors that Eric and I are not aware of.

Finally, would you be willing to have a group call to discuss this
at some point?  That might be a more suitable venue for this kind of
discussion, and could potentially lead to a conclusion faster.  Also,
while at least I couldn't sign any NDAs, there might be information that
you could discuss there that you cannot post to a public mailing list.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------6zVWfHQIO5csRmwlYh0DKQg0--

--------------GyUom66QLghtcvfW8pbhyBYR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmp8oHMACgkQszaHOrMp
8lMQ9A//QJhJ0WxnD3czDPUecAwiool8hr6eNkI+7yOuU64ELLj5lqjVwiU4Mpi2
cFtokcg5uTSi47zXn1zva367V8mUpBLEhig5Y8sY0LPoz6GhqIqBZRKBeMnDS49D
conE2J7MTlZPmF9CHlI/U4ox5ppQkGsDmMSpjvllIbZTsFgUTXFgzMV8ZPJ2fNKv
U36tafg51dlENv/J5gOcRubblJz+WmJ9RoN1h5r0rjLYT/6P+eArUjKn3RylzFG5
AmgaABzAXBsHZ/0ciPcMmOGxc/fuHSfOxSYnbsSIN3V4IYmof0QSiGeHBCJlnNX0
Ahzld3abt5DZM5S97MNiBI3TT7swLYPdTEHrt3Qk/zCdR5tlWsTYx4kjVdpIKhoV
RPJqbx/oqPgdYu1QrUxUSY46PYbVhawBvtvcljRqtaFyzryK94qtTCQEOzSddWwz
N7sHidjwjvhuhiTPzm4ppCbHJA36JzoBlbUOA0cygvUBpoozU5Hlgr6OKgGPumAg
R6vthtvcn2FnFx4Gt3om8FOvLrMLPQWCmN6cgDY8IOja18cxJexupdwB2Qtr59m7
oZXzNPrjdjMDNE8DUNvvusn0f8xKQSCwYLZDsblCgdahkRuw1n++bLwL23EXvnKr
P/GUjDHX9/FHNE9C1HwDEHQ5eJV2FRqwAx8ywso4+Y1BJaoAF38=
=kYiV
-----END PGP SIGNATURE-----

--------------GyUom66QLghtcvfW8pbhyBYR--
