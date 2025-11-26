Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BAD2FB990
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764154516; cv=none; b=kuOPyurcmgw3WonLQ9UJSYARemf0ETEmSePfKZqOIK6ifb91bZYDTzB31OE7bbrbrd6sAfqgU9iOq9fe/lR+eMRgy0lyq1rlQPmtzQMEX5FuFBZ0QwEfvXP55zwSLGJpCzuYQhq2wdZ0/0W0ITPfMAeRtYGwNFtepyzkKNLLgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764154516; c=relaxed/simple;
	bh=ox7MSuzPIeIIE7aLoA8rsi8xRs8yOy1dZB8ukDyKoNo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E/fg8m8CZZIRI6Bpyf5IZvujyr46QDiLjL/F6BRY7eDTZTkiwysLvKlirfKVhN4VREU7QNjjt68wnGAjYKSwr0+5VIcVDIAbWUdRQpDx39PovFSHtRL+bcJv4HYp02bc2vTjwY8bwmxNBUE2EPlnXvQt+H0Cxlifg0BMzzlVRxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtY0J4dq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtY0J4dq"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779a637712so40274085e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 02:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764154513; x=1764759313; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ox7MSuzPIeIIE7aLoA8rsi8xRs8yOy1dZB8ukDyKoNo=;
        b=UtY0J4dqD2YFIap9aAvGeQVZn1gHqyu75H2wdHUXsc1TZ9br8bvMI9dRv3Q5u2MDTW
         PkVnA0+car8RYWAhiuKAs2MhcPwOZe9xDq5eb1Kn8ow0aqv/bBiQL1K6sBrx0TANP9NF
         aG4nqWAfYBWDsfCd5Q4TIk9/OJmOHtoD78BtQ2S8opyljcUMHLW1RoWs8AmJ3k221oRn
         Cl+YEDLuw2g7rgaEA0UjRo3vwePPi/XFM9Cob8YY2TY1bOJD6dywGmKe9bh4HlhUo1SY
         s52gijFXz5N2bv5F4VoYZI+PvZ6ZTmBcdnGzP4f/hUKmePu/fsVymgyJun8Dyqgzf3v5
         dvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764154513; x=1764759313;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ox7MSuzPIeIIE7aLoA8rsi8xRs8yOy1dZB8ukDyKoNo=;
        b=f8RHsnedEU4zTpAHQlDnQPgcdV+znvgnOU3ywLbpoSGljLIb9ipis41BL1XE9S58Xt
         qesbyYLONUX2R7x1Z8hGAfIMeGVJCCPY1DHSCB2NFNIueiQTevjp22zWJg8K9AhK1P8v
         +oHna6gZhBmUZDg+d2ayUk6GZ52PsvVwiM2orUViPmYCYNIrJ18d5eMuX994LNHdKiNb
         ihIBS63tygisiv/zxKVY4e0JaHS5E9ULN8+Pb7GHytiJOrxRW/+plTrJxeieBtp/0DT8
         CVbuV5+YQaYLNAnBBX8zGregi5hVT6o/V1Fae3WHuTychyEwvESR/i/PLzWQOulWYMjx
         skXg==
X-Gm-Message-State: AOJu0Ywvh6YXRamaDTxaJgAVPrprUok1+zbpY+VFiyW4+XxsIIDB2SIW
	febNMNBrJKS7L6fOjo0GaDyF3nfO/x78xZrnTCBW50ISDilkgTOH+PzdAabmqA==
X-Gm-Gg: ASbGncs1G2CYxJPfjrt4jiSi1qtcD6sl/O7D/BbA80BTSwEy0PGKNCI7d/qFeFCZ66Z
	72OFtgh1oxkurHIfFRxEl2287Sq8HunSWrtrTzBmYIORuMQpjdUxtjUvTJQIjigugYkDsCjVBlK
	b4u6zvZ4jtBqEjaZJ0eHx/tYxTLX0Ks/pfkaHI4/lJciariQ8eKGUjlYeIFs2PUnkOUKMW6Sedh
	4tuWUgKdN55hXFm9Jjj4eIqU2tizHiJj1TO4nMeuqIocBpsqhzrK1TyqoIqku2xTDOy2z0yKjvu
	wC2CGT4SEn6G7UultNqkBlQZ3SMG8smrxBtv3WfNuRisEtwZavScylaK14r4d57jZJ+uusFxm2t
	oJEp4B9Vdyw41m9o8OkieOO0PAvOohJY0HIXL2LY+b8EtEs4q2pwLbJlVplu5E/B5XLV44F+DjG
	9fOgvpFQIeJEim/ZuFYrTvQ/BXZeM05yv1og==
X-Google-Smtp-Source: AGHT+IHcHI6170B8NfKQQMp8egrR1vGwUk5xF9DhlZO/uq9fy+Xjr5nT4MGqEAz9VgSn2UVWyQL5GA==
X-Received: by 2002:a05:600c:1d0e:b0:477:bb0:751b with SMTP id 5b1f17b1804b1-477c01c4d79mr178895815e9.27.1764154512550;
        Wed, 26 Nov 2025 02:55:12 -0800 (PST)
Received: from vitor-nb.Home (bl19-170-125.dsl.telepac.pt. [2.80.170.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790add2648sm40933725e9.4.2025.11.26.02.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 02:55:11 -0800 (PST)
Message-ID: <ac727d79bdd7e20bf390408e4fa4dfeadb4b8732.camel@gmail.com>
Subject: Re: CAAM RSA breaks cfg80211 certificate verification on iMX8QXP
From: Vitor Soares <ivitro@gmail.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	imx@lists.linux.dev
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
 herbert@gondor.apana.org.au, john.ernberg@actia.se,
 meenakshi.aggarwal@nxp.com
Date: Wed, 26 Nov 2025 10:55:10 +0000
In-Reply-To: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
References: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

++imx@lists.linux.dev

On Mon, 2025-11-24 at 19:03 +0000, Vitor Soares wrote:
> I=E2=80=99m currently investigating an issue on our Colibri iMX8QXP SoM r=
unning kernel
> 6.18-rc6 (also reproducible on v6.17), where cfg80211 fails to load the
> compiled-in X.509 certificates used to verify the regulatory database
> signature.
>=20
> During boot, I consistently see the following messages:
> =C2=A0cfg80211: Loading compiled-in X.509 certificates for regulatory dat=
abase
> =C2=A0Problem loading in-kernel X.509 certificate (-22)
> =C2=A0Problem loading in-kernel X.509 certificate (-22)
> =C2=A0cfg80211: loaded regulatory.db is malformed or signature is missing=
/invalid
>=20
> As part of the debugging process, I removed the CAAM crypto drivers and
> manually
> reloaded cfg80211. In this configuration, the certificates load correctly=
 and
> the regulatory database is validated with no errors.
>=20
> With additional debugging enabled, I traced the failure to
> crypto_sig_verify(),
> which returns -22 (EINVAL).
> At this stage, I=E2=80=99m trying to determine whether:
> =C2=A0- This is a known issue involving cfg80211 certificate validation w=
hen the
> CAAM
> hardware crypto engine is enabled on i.MX SoCs, or
> =C2=A0- CAAM may be returning unexpected values to the X.509 verification=
 logic.
>=20
> If anyone has encountered similar behavior or can suggest areas to
> investigate=E2=80=94particularly around CAAM=E2=80=94I would greatly appr=
eciate your guidance.
>=20
> Thanks in advance for any insights,
> V=C3=ADtor Soares

Following up with additional debugging findings.

I traced the -EINVAL to rsassa_pkcs1_verify() in the PKCS#1 v1.5 verificati=
on
path. The check that fails expects a leading 0x00 byte in the RSA output bu=
ffer.
To investigate further, I poisoned the output buffer with 0xAA before the R=
SA
operation. CAAM RSA operation returns success, but the output buffer is nev=
er
written to.

During debugging, I loaded cfg80211 multiple times and observed that
sporadically one of the certificates gets verified correctly, but never bot=
h.

I confirmed that other CAAM operations work correctly by testing hwrng via
/dev/hwrng, which produces valid random data.

Given that CAAM reports success but does not populate the RSA output buffer=
, the
problem appears to be somewhere in the RSA execution flow (possibly in how =
the
result buffer is handled or returned), but I don=E2=80=99t have enough insi=
ght into
CAAM's RSA implementation or firmware interaction to pinpoint the exact cau=
se.

As noted previously, blacklisting caam_pkc to force rsa-generic resolves th=
e
issue.

Regards,
V=C3=ADtor
