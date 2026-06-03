Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36F63E3173
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2026 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780506770; cv=none; b=bJqXCak0w0JNoM8UXVjjkeXIVQft7LndsDBUc8o1mcYF97HJZWEK1515tM5gIlpF6GDE3jzr77Qx2NFqz1EkoAC5d/FhV+yhnStgR7z3Gn2rzWqDQwVNTeqTCdOzTmAoiUpEFxeye0Bb7bvAPolLijUvjJ4A5HnY6A1X/Lz1P8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780506770; c=relaxed/simple;
	bh=wsWpWEvQNhVUUEykAzMjrJBZpET9UbIt3zo6SgrnxFw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p+ZIGDF3fPA1wTX3KiBfafiSWDvhHy4krpztqDLA1A5TBhDW8b4chI5gtKK+Nuw6uCuw+px+pGp7Tt0cAFdfEwvP/L/y6h445tjKcdxD7X5fylsq1UQYJOtLcI7aiLCkEhHkUD8kd++Q5Z5B0+KIa8jxqa7buhzSRNGK5eItgoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=Gmnzx+V6; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="Gmnzx+V6"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4865e953031so760053b6e.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2026 10:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1780506767; x=1781111567; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sdJos9DxFWNEwtNb73fnv381GQri8Si62f+7n/hMFzg=;
        b=Gmnzx+V62a9gHMMYPLnCBryteI326RAApVLpuNrO5Bojm2iGvbAjh4ybuWAkYhNbtL
         cZfcB2ddMfC/3dmjfHCLC27ONRyVc6+3T5A5r7P23Em8+HNMUM2WN86fHMp6XJvjdMDI
         iAZ15gx8YooszW2wCJtq8mW1EGjBtofKTYE+KvCQ2rSTninmqBJFcJXkBeHyE/8JQVbo
         BlZ2UWmZW6dtsDTdpctUP5DLMD3UT6T4PFuz2faCd/UD6B1BRMtdaNk8KN5HwietBQ17
         fuYOSw/EGlHMBtA64fI4aHWBRet6ArQWqSwiJ9SPaEZwlzkTwZDt7d1fU8eUxTcWNMsO
         749g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780506767; x=1781111567;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdJos9DxFWNEwtNb73fnv381GQri8Si62f+7n/hMFzg=;
        b=W8JCxU17EpYVE8X++tbTfJjctZ2at3j6u3hiTVconrPeDH98fDr9kB3lxW78/0/LZE
         G0VBW9ZyGWv2lpsiMMdm3pxUWJpKLShnQ+KVhQMUCg2GWnH+Txe0Y0Zf8oVw3wJ68CN8
         OQhNvPxZCAJFjfTglHHnyzD6ZgFX0OSj3vaQ2V2mPbIVUky35bGUsZWy9nNwwKTufo/A
         5UBTv5O28Fgu6usc4ZSMFbTI82sKJHZMWlG9nRiOV1/BGHCs5erwGHfJTeTE7cUhy5Qg
         BwMp7d62XAw9z27/VeBxYAVMBjfBhz7OFQy/ltewDvrFUBoXgr3pBeHx5nr7L09fNvPv
         wwgA==
X-Forwarded-Encrypted: i=1; AFNElJ+cVMe0d+EbY+IDEoYEARenPyFkm3Gsp8urQE9uTiDeyj7ZHJKlvxPfFMjR5bMz5kV9jD44pqtqhU7FlBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxhITD409u1zSkpVvxF8fe5Oerr8ObG+Y6+lRX74Njcseeih6R
	ZOsa1WHzdZ7iZptGeQTZiz2/VyIQMKLiddAwuRBWyfGTRIbwpvLVmspKKYden9ZJuSg=
X-Gm-Gg: Acq92OFxhIp0ZZtsdz5Aj2Rbd2fNmCrAgVerYuBVtoTEmB/judTzORQthW7SePGTSdR
	GcR9RoYpNnUuW1e9+/ewTVUuwfA8Pk6ZZ8mSbrGdqhu78NDmVreOU28h7rCgq0kUs5yhJJWg7FX
	eLYxjM0kk5vPEOYhqP1K337Y4maicsWdExc/i9+0zHWw7olOFWfRD7zvxqWuskI8iUyh6FCpt7W
	ydQ9nq4aGCnE9O7oF2PO934aMqR/kMoU5Qu8tGf0iCquLx18RXWvhz4MMUc8P4DGJWeBaviU4Jx
	uNvrJCCcjHRELdlpzTAo+R8N4HicpSuO5oBV8LVm2cRs0iQawrbxCjf73/bOm2btuPsPQ/kDLIb
	Po57LTjPKmLEUwJANbNzCsPEP15tgP9qioteDHyFe7sRaTKEcvSHLbv3olav/DMtGLD1u2vaAGx
	6HfXfABYdXgfTAHiOiABOQcGKt6EA5onnC7rJr97K+xEIWPWIBSPQ3MoEjJ3EzCsUziBczFFedz
	7j/bUgLW66CID8geimZYW1zdMoIm/Dl2WAjEGpXIbz6/29jvZff8w3tBeoN8+Rpw3pG
X-Received: by 2002:a05:6808:199f:b0:485:5430:2ba9 with SMTP id 5614622812f47-4866fee57eamr156538b6e.22.1780506767632;
        Wed, 03 Jun 2026 10:12:47 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:9912:77fa:9c5:3949? ([2600:1700:6476:1430:9912:77fa:9c5:3949])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b91f944sm2177130b6e.9.2026.06.03.10.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 10:12:46 -0700 (PDT)
Message-ID: <55ec2272160ed73a2a376cf7400e2f87b7dcb34c.camel@dubeyko.com>
Subject: Re: [PATCH] crypto: testmgr - allow
 authenc(hmac(sha{256,384}),cts(cbc(aes))) in FIPS mode
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ilya Dryomov <idryomov@gmail.com>, Herbert Xu
 <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Jun 2026 10:12:45 -0700
In-Reply-To: <20260603155008.736872-1-idryomov@gmail.com>
References: <20260603155008.736872-1-idryomov@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-06-03 at 17:50 +0200, Ilya Dryomov wrote:
> hmac(sha256), hmac(sha384) and cts(cbc(aes)) algorithms have been
> marked as FIPS allowed for years.=C2=A0 Mark the respective authenc()
> constructions per RFC 8009 ("AES Encryption with HMAC-SHA2 for
> Kerberos 5") as such as well.
>=20
> SP 800-57 Part 3 Rev. 1 from Jan 2015 [1] links the draft of what
> became RFC 8009 in Oct 2016 as approved in section 6.3 Procurement
> Guidance (item/recommendation 3).
>=20
> [1] https://csrc.nist.gov/pubs/sp/800/57/pt3/r1/final
>=20
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
> =C2=A0crypto/testmgr.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 4d86efae65b2..7788e6fa80ce 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4215,6 +4215,7 @@ static const struct alg_test_desc
> alg_test_descs[] =3D {
> =C2=A0		.alg =3D "authenc(hmac(sha256),cts(cbc(aes)))",
> =C2=A0		.generic_driver =3D "authenc(hmac-sha256-
> lib,cts(cbc(aes-lib)))",
> =C2=A0		.test =3D alg_test_aead,
> +		.fips_allowed =3D 1,
> =C2=A0		.suite =3D {
> =C2=A0			.aead =3D
> __VECS(krb5_test_aes128_cts_hmac_sha256_128)
> =C2=A0		}
> @@ -4256,6 +4257,7 @@ static const struct alg_test_desc
> alg_test_descs[] =3D {
> =C2=A0		.alg =3D "authenc(hmac(sha384),cts(cbc(aes)))",
> =C2=A0		.generic_driver =3D "authenc(hmac-sha384-
> lib,cts(cbc(aes-lib)))",
> =C2=A0		.test =3D alg_test_aead,
> +		.fips_allowed =3D 1,
> =C2=A0		.suite =3D {
> =C2=A0			.aead =3D
> __VECS(krb5_test_aes256_cts_hmac_sha384_192)
> =C2=A0		}

Makes sense.

Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Thanks,
Slava.
