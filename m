Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DD71B78F3
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917910; cv=none; b=HlXrQzMf1JrGYyOCE6kMlWWfJbYjge+I+Ng0nXajlCho5sz5iC3/D8P8ZyMtSLyr05E2prTEWKMix7gfYMN9eq/F9richSpdCcEwKBXOOIieh6XaDEhUlD8n3h809dAqby3AJYnP+yVAmByFr+eMU+SACPnsFK5XePJjtvx3LJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917910; c=relaxed/simple;
	bh=wTlDsvwEiOp7PN0Uv8Eldm2vlzIe3fwQFXEsyyz7Eks=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=TFt2JAnazBYzz0GrbygaVLVuJEit6+YrNCh4mpw7tR1o2cBc7aT90GcW55MEtvLqdOhtI1aMmUfEEstpX2H9VvkgzUr+Zwb4c8S+4+xRPPcjFfRNqG1T7f5wTZH9Q+/t0Bpao3YH2Nq5p9XNSUy7Mo6bIwuvnNTKBevykNbEnE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oT8L+ysD; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oT8L+ysD"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67bac077116so2397073eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 17:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774917908; x=1775522708; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mdV7saOUjIDAHAVu162wvni1KJ8JIN4P9J1aBuMdPl8=;
        b=oT8L+ysD01eRVhbPotwXDXYpmWi8mj/y/Tun4/+H/Qo9FtlcxeuLAGBB7GiAownmrw
         C8Ky3ITvnDO41X9F1bAHI+4+3+XoCfCxmtdNqsIDE8NJPRXRbY3g0iOVwW4uMedbd8sW
         hxsO2hvwNmRXLgWIwRJXhGVxUfa1DPtdeO0+4JSmkX8pQKrHP2y4Yrwnfiuz4zA76Had
         eui6/ANoGwBS4fWv33aUFbmv9/2+aKy+CquqOYtMVWdImsQsU1DjthRUPlVorI2Xmpht
         Qq/3x1gNSQDzZ5vKerMf+/1QMZuM2JIBT3fKWl3m9l475f/Vmtk+MMydEmvPUxK+OkOi
         k1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774917908; x=1775522708;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mdV7saOUjIDAHAVu162wvni1KJ8JIN4P9J1aBuMdPl8=;
        b=fE1XvmzyxnPzh+PgbGbP1uYyf0Hr9EcpDB+aymnTgTRisyiFifEGwa3TIwO1paNvuu
         fYNp0j8raBj1YPaCwTWuToOaulfrA7LNe0rjbYMvScsvJRb6KIfwZVinuBS227skejAO
         KwsO5ZXgLY8muJrRd5gvWWSudaB8yh55X0sX4IFgiQ6Flmaq5ISpQ13w/fnXHwMrUvHt
         4LzsaBk2/640gUVqlqANqhMQFdgORO+US2fg8yOhQ/rFqUegBbgOQ8aHc48B9RlAxw11
         BCLwwq1niVlzNHYU7WBRe7hM9wiipxHe79tj9zYpPr9se7t/j16Lv2d3sNuMhZVq4hT6
         fKuQ==
X-Gm-Message-State: AOJu0YwsJ8tOchrTU92eB7j6TMAYNKTXgBPqmiP30t9lXh7opY5GkWp3
	ftNsBJAfwvFhXxUC/CdEnYav4TdBVdsaDcJ5sTbURQ2ngUSnUly+Xsz6
X-Gm-Gg: ATEYQzw/WDHxrFBhhXQ0MQuBD0mTCGOW6ZgjwKFAl9Yn91bEI+ls5pUYT8wlGi++OGO
	q7BajNnkk47qSaMPPqcUnYBYRlZsiK8sl/DcjKpYT1zd2n2WsT1mthm0BEQUA8PPnZfocd9uo5X
	mcWw7fX1oBnMUAvrWzQCu8O93AzwQMHtL1xtzS2p7E32t9/CUEyyZpUqSr5yXmdYvVbqJkmtEKd
	56OhF++7kt2saO2Lf1QhvFliJVGwdoGH9HJw+T9EJU/MWhzm0A+wSL7V2a4AtY3ef443dWBFdMG
	biJLGvEID04hs3F7SzuBRxB4J+2oh5d8+veoMV6QCAgnDRrtREiMV4jDkkmvRD1V2OOby5Mdhqf
	svzaykmhr6gn+sU4TkQeIBN7RO5BbE8O3zPbE5cUF+sR48bjFg0XHQCtig3XlDRITOU7ebBk/b6
	5McjMWquIGwkzi5GWtgv11TxFwJfsxAAxJ9+ieEV1kpPJ7Xie1AkMwK5iiEmHvSYN7uENytj/LV
	LDMlw==
X-Received: by 2002:a05:6820:20e:b0:67e:3e27:8575 with SMTP id 006d021491bc7-67e3e278735mr887522eaf.50.1774917908015;
        Mon, 30 Mar 2026 17:45:08 -0700 (PDT)
Received: from smtpclient.apple ([2600:381:6705:e5f:ad55:112f:ba58:2819])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e231ad680sm5683946eaf.10.2026.03.30.17.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 17:45:06 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Ryan Appel <ryan.appel.333@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: Kernel ML-KEM implementation plans
Date: Mon, 30 Mar 2026 19:44:55 -0500
Message-Id: <7507DE2E-1507-4D03-B6EF-9C139BBF34F8@gmail.com>
References: <20260331001358.GA5190@sol>
Cc: linux-crypto@vger.kernel.org, wireguard@lists.zx2c4.com,
 "Jason A. Donenfeld" <Jason@zx2c4.com>
In-Reply-To: <20260331001358.GA5190@sol>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: iPhone Mail (23D8133)

WireGuard was my big implementation user. I also know that VMware uses the k=
ernel crypto space for many of its crypto operations. I do not know when the=
y will want ML-KEM and if they will want it only within BoringCrypto or Open=
SSL, but if there is need for it in the market before it can be developed th=
en that makes sense.=20


Thank you,
    Ryan Appel

> On Mar 30, 2026, at 7:15=E2=80=AFPM, Eric Biggers <ebiggers@kernel.org> wr=
ote:
>=20
> =EF=BB=BFOn Mon, Mar 30, 2026 at 06:41:46PM -0500, Ryan Appel wrote:
>> Hello all,
>>=20
>> Looking through the mail archives I see no information on an
>> implementation of ML-KEM that has been planned, except for leancrypto
>> attempting to make a Key-Agreement Scheme a Key-Encapsulation
>> Mechanism.
>>=20
>> Is there a plan to implement a KEM interface at this point? Is this
>> something that needs support?  How could someone contribute to this?
>=20
> We don't add new algorithms preemptively, but rather only when an
> in-kernel user comes along.  Otherwise there's a risk that the code will
> never be used.
>=20
> Do you have a specific in-kernel user in mind?  I haven't actually heard
> anyone specifically say they need ML-KEM in the kernel yet.
>=20
> I guess the obvious use case would be WireGuard.  But that would require
> a new WireGuard protocol version that replaces X25519 with something
> like X25519MLKEM768.  It's going to be up to the WireGuard author
> (Jason) to decide whether that's in the roadmap for WireGuard.
>=20
> Also maybe Bluetooth, though it seems the spec for that is yet to be
> defined?
>=20
> Anyway, point is, before it makes sense to consider possible
> implementation strategies, there needs to be a plan to actually use it.
>=20
> - Eric
