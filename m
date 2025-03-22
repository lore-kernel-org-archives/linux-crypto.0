Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626659443;
	Sat, 22 Mar 2025 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742667904; cv=none; b=hXQqqze+JQYiY/TPKGcUzplOvk37imvNmU3WdDAbiiI1zXeh3Q5lPnygNyVYShNIlBgc85IKsqUFiJmH7Pw35t6lLiYuUYE96jSYPSZxE6z+rfCZElwLgRJWg/ggElQHI+8ppFmbbAH/WW0RipUAcPWSSd4qpNa3phoATbJwC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742667904; c=relaxed/simple;
	bh=AB6eqa6YfKi5G3b5ZN2NOcYKZyPR8BbRtQUz7L6unIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pw62zqocY4OiLt0Tl30SMOKONS5EFHAj/xvlJTXaKCprt5V0oo/M8Zz33OaAJZvsUyMEOqjSIAkMfyqSVX72yA/+eaEqBQHlOIsCYbCm6g92QH5pU+8d1gnHyFQFUmTqSJ8a9r2nMKUCoH18DsAWFmQh7Om5RYhcTYjvcEIt8cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KIrq97fU; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIrq97fU"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso412108266b.0;
        Sat, 22 Mar 2025 11:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742667900; x=1743272700; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AB6eqa6YfKi5G3b5ZN2NOcYKZyPR8BbRtQUz7L6unIM=;
        b=KIrq97fUWiehEZPTGAaVJtBBgpHHSFrsRoOkOjkO3fIEFm1mWJY+U+2ybeeHNrbqp0
         LoUrlCGRuw73MoASiRt2uftOKv+NAnfxRiit+wi+bMIRVUIRHYlYJN4/36XlHnZ1GLme
         VbubdDlQR0JYQgjeiht8PuQb8tnkMswDqvRwIaJEiJcnEAMfftAlGdljV4cMijpim/eY
         7oohXw/pGGPFKvqJtQFhVg63ua9OMqaKvdI3s941NVsvkga37mX29+KKA5p2E0Wejrw9
         LlKjYgmx8c5NjX5dD2ehYUqZi4RmNL4dzhbGL1mcQ+yA8gEWWaoDMMCLFmEXPEJq0DGP
         S2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742667900; x=1743272700;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AB6eqa6YfKi5G3b5ZN2NOcYKZyPR8BbRtQUz7L6unIM=;
        b=k1PqXNLBvNdZBSv5uMLbGg7EF1KoA2hYDtXt24EDtE7KHFB+79rGVizsP9gvL3pf16
         V0fOlnKYMthCTVX7Mn5TgNqy/g0xdrQzwSYSrUw2tWqmL0c2llHaeCy7PMZoh7QTsHeF
         m97M/pVEjYqFKKC7j2mf67s+crijXxD+8cQwXp5xRINzZMHzXR1w2oTmayHTq3N150Gj
         JfIoJaIbwsaqYZwtBcw9R0lgxFuVLvFhvXArINx/GvHeiiFrYTf9vb6AF3Z+UA9D+gjc
         544rS3rTMf/AF5NQR5jjNwZSRPNeMSBTo38azLKfef8r82c9bVYTbWb4c0Q0VNTXHzA7
         m2TA==
X-Forwarded-Encrypted: i=1; AJvYcCWMJMF/V6rj6LbOStgMI+9UawnSDmjjecAuMedFgg+nXdFXvQ4x7DurH9n8UAt324KeW8H8Spg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNPKUPS9Tht6rO7NwiAk2zeVujKe8jbvuDtO1y9fKOIHSLg8Wt
	mngg6g/KHKzkUDTqEFyV+jpJ5GcUEs6ET2riBdkdqJVE+KPOh3Sv
X-Gm-Gg: ASbGncsFIiqRKuu/W/qm2Yao1mfHrRDCJbXdDL8nOO/RVXIomj6igf6mVOJ6EdTfEHE
	6SlUQIcHTaMWNJSSc+yZJVGChX25vege/5iLUaCP7sHSRIunr7TpRE4ajWRf+R/NHSP4sWjL5Hz
	S6JN03GLbcqXCK/Tv2rL8W+8ksKyXO+lpZVsLpCoHQu1teEcdS7cY4lSmV0CjR8CsumVcEDtl1i
	Ytu07pFF7RAA/snVd9ZkEs1gm21Sex3OIpkupmHya3dr4EGP6j2h749+vX2Vz+i62xAZniEe39M
	fGbCRg+7o+BS0bbPK9srtRPT/Hur/ldR4xB3So3kn1IEJO4A5yxhcWS1n7c99eHmxOpWSQ/2Cw4
	KOawcgeFy6w==
X-Google-Smtp-Source: AGHT+IFWB+6mea7hYGLXQtSZdB4Di32YVFmAH5RM683PcmHmiehwcZRGAQ88qX2IogmRJwfc5lhmlQ==
X-Received: by 2002:a17:907:3d94:b0:abf:5fa3:cf96 with SMTP id a640c23a62f3a-ac3f226e548mr608444066b.14.1742667900134;
        Sat, 22 Mar 2025 11:25:00 -0700 (PDT)
Received: from [10.53.15.220] (tuc-211-215.hrz.tu-chemnitz.de. [134.109.211.215])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ebccf687fbsm3503562a12.4.2025.03.22.11.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 11:24:59 -0700 (PDT)
Message-ID: <8db53465-381f-428a-8fea-7386b4a97557@gmail.com>
Date: Sat, 22 Mar 2025 19:24:57 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] prandom/random32: switch to Xoshiro256++
To: Simon Horman <horms@kernel.org>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, akpm@linux-foundation.org, Jason@zx2c4.com
References: <20250214081840.47229-1-theil.markus@gmail.com>
 <20250214081840.47229-3-theil.markus@gmail.com>
 <20250217111806.GJ1615191@kernel.org>
Content-Language: en-US
From: Markus Theil <theil.markus@gmail.com>
Autocrypt: addr=theil.markus@gmail.com; keydata=
 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
 EjwE9Q==
In-Reply-To: <20250217111806.GJ1615191@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jQPmiHFUesImpFohiY00irMN"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jQPmiHFUesImpFohiY00irMN
Content-Type: multipart/mixed; boundary="------------vUv60RjUVgzNkEtRqS4htxae";
 protected-headers="v1"
From: Markus Theil <theil.markus@gmail.com>
To: Simon Horman <horms@kernel.org>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, akpm@linux-foundation.org, Jason@zx2c4.com
Message-ID: <8db53465-381f-428a-8fea-7386b4a97557@gmail.com>
Subject: Re: [PATCH 2/2] prandom/random32: switch to Xoshiro256++
References: <20250214081840.47229-1-theil.markus@gmail.com>
 <20250214081840.47229-3-theil.markus@gmail.com>
 <20250217111806.GJ1615191@kernel.org>
In-Reply-To: <20250217111806.GJ1615191@kernel.org>

--------------vUv60RjUVgzNkEtRqS4htxae
Content-Type: multipart/mixed; boundary="------------aE5eggJc89LW0MoqnFqZjnoK"

--------------aE5eggJc89LW0MoqnFqZjnoK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMi8xNy8yNSAxMjoxOCwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPiBPbiBGcmksIEZlYiAx
NCwgMjAyNSBhdCAwOToxODo0MEFNICswMTAwLCBNYXJrdXMgVGhlaWwgd3JvdGU6DQo+PiBU
aGUgY3VycmVudCBMaW51eCBQUk5HIGlzIGJhc2VkIG9uIExGU1IxMTMsIHdoaWNoIG1lYW5z
Og0KPj4gLSBuZWVkcyBzb21lIHdhcm11cCByb3VuZHMgdG8geWllbGQgYmV0dGVyIHN0YXRp
c3RpY2FsIHByb3BlcnRpZXMNCj4+IC0gc2VlZHMvaW5pdGlhbCBzdGF0ZXMgbXVzdCBiZSBv
ZiBjZXJ0YWluIHN0cnVjdHVyZQ0KPj4gLSBkb2VzIG5vdCBwYXNzIEzigJlFY3V5ZXIncyBC
aWdDcnVzaCBpbiBUZXN0VTAxDQo+Pg0KPj4gV2hpbGUgb2YgY291cnNlLCB0aGVyZSBpcyBu
byBjbGVhciAiYmVzdCIgUFJORywgcmVwbGFjZSB3aXRoDQo+PiBYb3NoaXJvMjU2KyssIHdo
aWNoIHNlYW1zIHRvIGJlIGEgc2Vuc2libGUgcmVwbGFjZW1lbnQsIGZyb20NCj4+IHRvZGF5
cyBwb2ludCBvZiB2aWV3Og0KPj4gLSBvbmx5IG5lZWRzIG9uZSBiaXQgc2V0IHRvIDEgaW4g
dGhlIHNlZWQsIG5lZWRzIG5vIHdhcm11cCwgd2hlbg0KPj4gICAgc2VlZGVkIHdpdGggc3Bs
aXRtaXg2NC4NCj4+IC0gQWxzbyBoYXMgc3RhdGlzdGljYWwgZXZhbHVhdGlvbiwgbGlrZSBM
RlNSMTEzLg0KPj4gLSBQYXNzZXMgQmlnQ3J1c2ggaW4gVGVzdFUwMS4NCj4+DQo+PiBUaGUg
Y29kZSBnb3Qgc21hbGxlciwgYmVjYXVzZSBzb21lIGVkZ2UgY2FzZXMgYXJlIHJ1bGVkIG91
dCBub3cuDQo+PiBJIGtlcHQgdGhlIHRlc3QgdmVjdG9ycyBhbmQgYWRhcHRlZCB0aGVtIHRv
IHRoaXMgUk5HLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE1hcmt1cyBUaGVpbCA8dGhlaWwu
bWFya3VzQGdtYWlsLmNvbT4NCj4gLi4uDQo+DQo+PiBkaWZmIC0tZ2l0IGEvbGliL3JhbmRv
bTMyLmMgYi9saWIvcmFuZG9tMzIuYw0KPiAuLi4NCj4NCj4+ICsvKioNCj4+ICsgKiBwcmFu
ZG9tX3NlZWRfc3RhdGUgLSBzZXQgc2VlZCBmb3IgcHJhbmRvbV91MzJfc3RhdGUoKS4NCj4+
ICsgKiBAc3RhdGU6IHBvaW50ZXIgdG8gc3RhdGUgc3RydWN0dXJlIHRvIHJlY2VpdmUgdGhl
IHNlZWQuDQo+PiArICogQHNlZWQ6IGFyYml0cmFyeSA2NC1iaXQgdmFsdWUgdG8gdXNlIGFz
IGEgc2VlZC4NCj4+ICsgKg0KPj4gKyAqIHNwbGl0bWl4NjQgaW5pdCBhcyBzdWdnZXN0ZWQg
Zm9yIHhvc2hpcm8yNTYrKw0KPj4gKyAqIFNlZTogaHR0cHM6Ly9wcm5nLmRpLnVuaW1pLml0
L3NwbGl0bWl4NjQuYw0KPj4gKyAqLw0KPj4gK3ZvaWQgcHJhbmRvbV9zZWVkX3N0YXRlKHN0
cnVjdCBybmRfc3RhdGUgKnN0YXRlLCB1NjQgc2VlZCkNCj4+ICAgew0KPj4gLQkvKiBDYWxs
aW5nIFJORyB0ZW4gdGltZXMgdG8gc2F0aXNmeSByZWN1cnJlbmNlIGNvbmRpdGlvbiAqLw0K
Pj4gLQlwcmFuZG9tX3UzMl9zdGF0ZShzdGF0ZSk7DQo+PiAtCXByYW5kb21fdTMyX3N0YXRl
KHN0YXRlKTsNCj4+IC0JcHJhbmRvbV91MzJfc3RhdGUoc3RhdGUpOw0KPj4gLQlwcmFuZG9t
X3UzMl9zdGF0ZShzdGF0ZSk7DQo+PiAtCXByYW5kb21fdTMyX3N0YXRlKHN0YXRlKTsNCj4+
IC0JcHJhbmRvbV91MzJfc3RhdGUoc3RhdGUpOw0KPj4gLQlwcmFuZG9tX3UzMl9zdGF0ZShz
dGF0ZSk7DQo+PiAtCXByYW5kb21fdTMyX3N0YXRlKHN0YXRlKTsNCj4+IC0JcHJhbmRvbV91
MzJfc3RhdGUoc3RhdGUpOw0KPj4gLQlwcmFuZG9tX3UzMl9zdGF0ZShzdGF0ZSk7DQo+PiAr
CWludCBpOw0KPj4gKw0KPj4gKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShzdGF0ZS0+
cyk7ICsraSkgew0KPj4gKwkJc2VlZCArPSAweDllMzc3OWI5N2Y0YTdjMTU7DQo+PiArCQl1
NjQgeiA9IHNlZWQ7DQo+PiArCQl6ID0gKHogXiAoeiA+PiAzMCkpICogMHhiZjU4NDc2ZDFj
ZTRlNWI5Ow0KPj4gKwkJeiA9ICh6IF4gKHogPj4gMjcpKSAqIDB4OTRkMDQ5YmIxMzMxMTFl
YjsNCj4+ICsgICAgICAgIHN0YXRlLT5zW2ldID0geiBeICh6ID4+IDMxKTsNCj4gbml0OiBU
aGUgaW5kZW50YXRpb24gc2VlbXMgb2ZmIGhlcmUuDQpTaGFsbCBJIHJlc2VuZCBmb3IgdGhp
cyBsaW5lPw0KPj4gKwl9DQo+PiAgIH0NCj4+ICtFWFBPUlRfU1lNQk9MKHByYW5kb21fc2Vl
ZF9zdGF0ZSk7DQo+IC4uLg0K
--------------aE5eggJc89LW0MoqnFqZjnoK
Content-Type: application/pgp-keys; name="OpenPGP_0xFEE64346C8BF92AE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xFEE64346C8BF92AE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
1gXx4DiU9RItUZKqEjwE9Q=3D=3D
=3DBp87
-----END PGP PUBLIC KEY BLOCK-----

--------------aE5eggJc89LW0MoqnFqZjnoK--

--------------vUv60RjUVgzNkEtRqS4htxae--

--------------jQPmiHFUesImpFohiY00irMN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEhApWCu7803jVjNDD/uZDRsi/kq4FAmffAHoFAwAAAAAACgkQ/uZDRsi/kq69
zRAA2a4FXk3mCMe6GeEGMjmQpKFlWa9pzG0TDxW7gHwOMs+Fav7wCbE7h5DVAl/i8yN+4d7aQgBk
Hy1uC3PeFikSSqWsyE8KOP1Bghehuc7uqqgx+Y2RGGbrdIHdvC5hR0WP7XBLFc9ZvKwD+Cg7bnDA
At6rbh4hBNkArZDCm+H2Rx2wDJLJpItNmISqMKRo4tCJHg2DjlO7tHSByV+GOBG4OX7SFxPsrMR+
2nk4alrJJgtEqYgHWXTebn31KCBb7SDU54n5FAsCVps5i9eB/otqR6VyfWLXXduGfxG+l/U+2HjM
GpB99MWXVJb7ICnCUenxj7nA9JUuqXUw8k4CnrwNrPA08smOA/eZ2d73P5aPwSj3AMpeHB5D4qi9
DW6lofX8cocjINy58Wn/Uw3ZIINFoevab70UfMn2jQsS5ZH/39vI+Z9mo1oZhHuHTAEXuLa9Kkk/
XzRh6wujdIjJKo4rBJNs7gh4rHcsIiym7n01r9HB8vk0T2R5dp2AEckiRQl4zIVpouhxrkcvqRor
68xvHquD3Cx/acaP68CJVQ491S9mlxkBqDnO5ycZPkmo8GQTrnGATULSGd+/kN9j6D/X53YvTaSG
XEsJeetyrCqU5sBCJsU4xbtsDjmLIJIMStTPg7jYaJVyTM0FKPR6wVAGnGPlxLU9a91mDwhEL5zg
yAs=
=PBgs
-----END PGP SIGNATURE-----

--------------jQPmiHFUesImpFohiY00irMN--
