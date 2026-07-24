Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46013AFB13
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 20:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784925333; cv=none; b=CFxaWcyzhb1cJZWCuI+3OgRln5qpr5JSUycBC0yA795Y813vTb/NZb3ASB3/ar2n84Q7kCnoyojXlcXWCp0jLlg2KDLSFlCQ1K/mZhXZ6STKti5tbiYlCkcONETCrkfeLa+ySEVoXXm6mvPNlIhX01K7IEZal5W/oTrITVQFj6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784925333; c=relaxed/simple;
	bh=TIdb+PrmPRPIJerRy/ogzvQiQrvIOHY0y1wo5UN9DMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akXkoLjZblPPiNOprKqG/NubGq4Wn7UW9I7Gb2aeCHq700x32h1p+dRkUINg+WVrwBL6Dui/rqO9VrMLnpFgoUDKgCWwFu5na8mvp6gtvw6lKb0a88XpGdrZdpZ4Xeg60Lv0Y8bKda0jCAxY892lSahg/tpSBXRAuTRhuy4yNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MxbopMaS; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MxbopMaS"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-668c1b780e5so497291d50.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 13:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784925330; x=1785530130; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q/8kImmPB4tQ/JHFIpayA/JIm7PmQB1mt4kK24yFpjU=;
        b=MxbopMaSEbgL+KxR9/xyT+gM5Om4AmEFUsVi+9Zcfgeh3CENNroRbgjkSiMDradbEH
         K8rdviMh2pQu0L7YZuy4VD8RIoDfwPhZthlQiXOMOF+KQICTGUyhwaGScBn2iS5qMLfp
         bmKb0/TCM+08yYsrmTurrllrPtABMC6S4jMdni9A3ne/KnQ9IsTBqFqVUuF1taaYKPlh
         KbwV4RCeWhKVq0WoDXIWc2+TYS07Z/qAHbAbOsQvkpjae9ZiQWtMMcfH2U31Rpe2bMk8
         JjN9xHKufsKQ7OwSOudVktKdi9WwtlWKBiqLdcsXH0eB++4xcUSMicZ/372h57f44Dnx
         eceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784925330; x=1785530130;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q/8kImmPB4tQ/JHFIpayA/JIm7PmQB1mt4kK24yFpjU=;
        b=lowkWfjiAOsFKa2fRo65o8Q9AsDqWmy8RE2tKSNHEGn8tFDtA4pM48JK2QQmoM4lKP
         z5agslnoZH7w7DIHOgSL1PU0pZ7n+cnV12HH703c86hRPZUqF9G5U/b0TZ8YAi35tcMw
         Ivv1vqLSM4gtKwBmR4gMKjQuSabjM45Cfn5hpzoSjqW8pWQmpgux5yyaHXBHmSJiDX1n
         3Maig+EZabiZIFh4c+6vnxxjjrivUxRsnJj44Ug68RVnZuPlGiPugeoWNklkUlwq4jLF
         OYNcpAhAcoL0NkzfLks6YJ2znTtzs4hY2EGkXor5waFOZ3fEGVDMsSlCLo90f7G9a0CH
         M33Q==
X-Forwarded-Encrypted: i=1; AHgh+RpB59+bKq5FUSI9q1sOkv1Q9EmhCF02nrMC1cabEBoZA/w8Jo61hAwgBEDkVUVSG++GMZVUjvhXkFXc8jA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpUzZ45iPNpV41ahFoYU7s5ERz0Vc3cvSEkJnBagvEnzKmUQ+1
	uXarYGGZH9d0xO0oBkZckexpAkVtSyag2IdX+KZE1he1vrxZvL3lEkRQ
X-Gm-Gg: AR+sD10ENxZnGOBWVwkxWSsmZ+3fzyBZIsO8vThuGDakJOc21BCL3AKfcaa+531Gv+i
	Gvj/OcHx8PRNzQfrfNUFVT2wBfI6d3fpOesse2MOUq0g+3ktJO9KYtjo2xrJMx+/ZTdGDrB2Hex
	OedGmzQkWm+bMDHuQ4HV2xW75uWp/r62jS1JZ3XkEmBIpD4lbO7fTAMHfcOR5d4ixFeqdVFoJ59
	h/fPwuL47UaTZh8TRwz/TdY1W+vxeg6Eli+vneQRXw2meAYGXzu/Jdbre1PEycd6e5k7kUsgcyO
	FEwKB4BGjNjUx6pEcwGl/QPmMDAeIFYqxdMAH/uyLtMDvj52NJKQX+dF+oKQJDEeFkIZ3uVbiAm
	Chxrtl8GuhMesKwY2EBH5AREGmx598YilYr6fzwP++ODPtLDq2i7rbCQExpspZ6Rb2zthQQQZcn
	O5fpd6
X-Received: by 2002:a05:690e:43da:b0:662:ebb0:36fa with SMTP id 956f58d0204a3-668a4bb68b6mr1963039d50.20.1784925330394;
        Fri, 24 Jul 2026 13:35:30 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-668c6dd57a0sm108d50.8.2026.07.24.13.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 13:35:29 -0700 (PDT)
Message-ID: <0ccda05f-077c-4661-b852-e6bf9bf40be3@gmail.com>
Date: Fri, 24 Jul 2026 16:35:13 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Dominique Martinet <asmadeus@codewreck.org>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
 adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
 ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
 io-uring@vger.kernel.org, irogers@google.com, james.clark@linaro.org,
 jolsa@kernel.org, kuba@kernel.org, kuniyu@google.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org,
 skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org> <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
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
In-Reply-To: <amOTjPW__CNZui3_@codewreck.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8JNKQ02asdP8sqLTJjoHdKEp"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8JNKQ02asdP8sqLTJjoHdKEp
Content-Type: multipart/mixed; boundary="------------tHcDdCFADMuM4KeFqlrbc8bo";
 protected-headers="v1"; hp="clear"
Message-ID: <0ccda05f-077c-4661-b852-e6bf9bf40be3@gmail.com>
Date: Fri, 24 Jul 2026 16:35:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Dominique Martinet <asmadeus@codewreck.org>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
 adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
 ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
 io-uring@vger.kernel.org, irogers@google.com, james.clark@linaro.org,
 jolsa@kernel.org, kuba@kernel.org, kuniyu@google.com,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org,
 skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org> <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <amOTjPW__CNZui3_@codewreck.org>

--------------tHcDdCFADMuM4KeFqlrbc8bo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/24/26 12:32, Dominique Martinet wrote:
> Eric Biggers wrote on Fri, Jul 24, 2026 at 09:00:34AM -0700:
>> On Sat, Jul 25, 2026 at 12:35:55AM +0900, Dominique Martinet wrote:
>>> The tool source is available here:
>>> https://github.com/nxp-imx/crypto_af_alg
>>> (which now fails with:
>>> bind(3, {sa_family=3DAF_ALG, salg_type=3D"skcipher", salg_feat=3D0, s=
alg_mask=3D0, salg_name=3D"tk(cbc(aes))"}, 88) =3D -1 ENOENT (No such fil=
e or directory)
>>> )
>>>
>>>
>>> I don't particularily care for the API used as long as we can keep us=
ing
>>> the hardware key, but as far as I can see there's no alternative API =
--
>>> what's the path forward?
>>
>> There's no "tk(cbc(aes))" algorithm in the upstream kernel.  So, it's
>> not possible that this ever worked with upstream.  Given that, there's=

>> no regression in upstream for this program, and it wouldn't be
>> appropriate to consider a sysctl knob in upstream at this time.
>=20
> Bleh, you are correct, it's an NXP patch in
> drivers/crypto/caam/caamalg.c that they've been carrying in their
> tree(s) since 2018[1] and has apparently never been upstreamed...
> [1] https://github.com/nxp-imx/linux-imx/commit/6868c9e49c1854028fb4602=
2daac3b1b10ca2c70
>=20
> Sorry for not having checked, I was hoping for better.
> (I should be used to it by now...)
>=20
>=20
> Regardless of the specific algorithm, most recent SoCs flaunt some
> "secure element" or similiar hardware-backed keys (so one wouldn't be
> able to decrypt $whatever without running on the specific board it was
> intended for); I'm sure _some_ of them are upstream?
> (Never used it so not sure if they are reachable from af_alg, but for
> example drivers/crypto/ccree/cc_cipher.c talks about hardware key...)
>=20
> There's not much I can do about the vendor's kernel I'm stuck with, but=

> that doesn't make having encryption material not accessible to userspac=
e
> useless as a concept;
> forgetting about the sysctl for now, what are the alternatives API this=

> kind of implementations could be based on?
>=20
> I guess I should start looking at how tpm backed encryption works,
> some other day, it's getting late here...

I actually had this thought myself, though with a different
use-case: preventing long-term keys (like TLS and SSH keys and
cookie signing/encryption keys) from being accidentally leaked.

I came up with a much simpler API than AF_ALG:

1. Generate a file descriptor and a wrapping key.  The wrapping key
   is used to encrypt data that will be imported.

2. Import an encrypted secret key.  The key contains both the secret
   key and the algorithm it will be used with.

3. Optionally, attach a restriction policy that requires data to
   be signed to start with a certain prefix.  This provides domain
   separation in contexts where the same key is used for multiple
   purposes.

4. Pass the file descriptor to another process via SCM_RIGHTS.

5. The receiving process can use ioctls to perform secret-key
   operations, such as ML-KEM, ML-DSA, XChaCha20-Poly1305, and
   XAES-256-GCM.

6. When the file descriptor is closed, the secret key is securely
   deleted.
  =20
Compared to AF_ALG, the kernel attack surface is very small.  It's not
quite a "hello world" character device driver, but compared to many
of the other drivers in the kernel, it is tiny.  Furthermore, the
whole thing should be able to be written in safe Rust.

To keep the attack surface minimal, this would only use library
functions, so there would be no support for hardware-wrapped keys.

I don't plan to work on this myself, but I think it's of potential
value in the future.  For asymmetric algorithms, the overhead of a
system call should be fairly small compared to the operation itself.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------tHcDdCFADMuM4KeFqlrbc8bo--

--------------8JNKQ02asdP8sqLTJjoHdKEp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpjzIsACgkQszaHOrMp
8lNPug/+IDHRwaftOISwVsC+WuuG9FgGOwTLlQjjABKkrEhHZObZ/mWU4BpfL+Ek
ujcELLLDD1+ewxFwJoh9hynjIG9XDJEwXB7dLJuOYCiMLBWFk/Gujjh2YK2Pd+La
VGBc9XNcz96+3O8jQtwTbu1P5kQBg5+5WUOPTmONUetB2pzwACQUuRrtMW3g2LrU
PA9IyEB2n3i/D74GD5L0ca5RVzqf6YrUMrQ9qeMXGLCehhyZecnsMeweBWR6ikIT
b1s8wFFMD2V0/A5mWhoCnFmmfiyFR3zZQ14ZuxJ1/rhwZVUYgtMnsC6L8zjJLsVm
pNxg7iXUTnzVjL8467eLCS2Cl3r02dXgvSHt2/xxlpKjPiexOcb5DCzr1ecPlHuh
TvX19LaVBuITkjtzOlyvzQ0EvBKVqUh3B6btKfyYQ3NEP57Khbjp71rSICESPqdv
j6fv7iJMmYVPPsIb4yPYowfIHBm7baekQfml+0o+/8Wkmj62T2Cd0dUS7yEGJRIz
WSiK+99wi6ucfbVEEJNR5vckddmPfpYOasHohP3IhTM89G3FLxmuwfO+2WBJPPXo
2NcfEWnlp7l8+QaZzvqnTqIVrqEPrfTuMIR421Z+OoDYCzdaP/hz+SLLPyZXBjF0
eISqWWtGWHVcK7u8UNxBEkFZFbj5385JeXjl4UhysytbZVCK9v0=
=cZKJ
-----END PGP SIGNATURE-----

--------------8JNKQ02asdP8sqLTJjoHdKEp--
