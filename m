Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A860551FCA1
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788546979; cv=pass; b=QbBn2NYMEl4qwEjMTzijCVHsqVTpdVnn34PPpE3bXl8/iUko89bq3wnqxKVd7FvnIcKxp0BovqoOWH6T/i1aV7cibwY2Om/bf9eyJa34m5xZ3NkhtSdSPxZ5zyX85tGhT74ZDDUPeWzo3QJ7Zgh82I4Y9whAOwuwYCnE54z/ps0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788546979; c=relaxed/simple;
	bh=L+kEvddOAYt+2p4d1QGytEK36KNFtDsH3dz0SJzHKNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9vlFusZUPsjqxcYWvUfKt5fQsCTMI8VV9H/+GWoAn8M8KngXISN5ooQb9zFVL5up6hKUOTBoRh5zVYLEQQKvGNAu3Gp7IE47k4I1eoJqaX/VBFQJzTeg37XYgCSq6GDBjcXKbpvVCL6TzE7WHB4Qv8ix7ikPhsitd5LIiSVVSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ButpDVyu; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ButpDVyu"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a5ebf75d62so2017940a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2026 11:36:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788546975; cv=none;
        d=google.com; s=arc-20260327;
        b=s3UMfDCfdWauTvyveaJZPsf+nVUxSjWMn51gzvk44bJX3boHC73eeMrShJHy66NpZv
         YPPPA3GGj3XHWUTCj2b0NeFoETh8pft97EY3LBasKXuR2b6wDfiilx1saX8uMWuJl2cU
         VRaUBAvWKfRAyGOy3qFJWREgFEDc9nfjOLpWUTRxpcbeIw4XAjckToDB44TRYydIbMQc
         swqM8HDXFjEGPMkY0vPBUBX/3r9VEhX5ihZwCqdRSL9xwYUUJbVddOOnTEenno8vJ30H
         +qYSlm0Q5SifARzvGOGuafwnOj6JcMGoRxYSHAzlW9jq8K5EikU55jfHXJUnQofc+hfk
         ZPUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gOkqG6TuNgAD5h74emORdEhCfU9eyK97BAx9wxJ6SUQ=;
        fh=7cvKoD2ulm76bq8attQYd1bGL8l2sFn2Er3bgX41a6U=;
        b=frfQ4EyFnzHmxTzKvZzb6Qp7zDTUZrAqv5qvZ//e4JTlebaEhda0KiWv4TisbKv+JP
         NdjmRK86KuorKVWTc9gHTZ8DhlDPbu5Q1SmRM4VnFVfm683CMVU/jiv8HS1T10FkX8I9
         4StBFkWJOZyxktS1iENMy8J3py94l9JCpALLy8OnN6KwtdZZ1AnSiGaQmkZL1nh8i96X
         WU1t/DWisoQ6cLgrPJ97tLnJYA5RaH0dYjBoHopADl76jQ26w2FzeENcgpLaZiNoaBOv
         tFRozyQuC4FXjLzpTHYAJtCq28sBhPTYvb6dmEWVO1DBHwJur0C1hKd8i2S2ev5rBLOI
         KYnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788546975; x=1789151775; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gOkqG6TuNgAD5h74emORdEhCfU9eyK97BAx9wxJ6SUQ=;
        b=ButpDVyu1dZw7dqnMkU/XikTgVfwgYOEVGG801mbk2jZ4AJqnaKFrARMqqLFu3QK2H
         q3reNMrkCH2AXolkBZ5XvcIyCpj4sOsPVwf5b3mYI234dgdA9TNeVZb3JfW/rOYjAwD4
         mpQVnw8EN0rOH4t1ZxzbTUIWA2RE5aiFXImtPd6KhjlyJDpJ/Sg2N+i6rTsAN9Neszpv
         knt/6OoBufFU1c5ZZqziC5Uzph9q0ezeRbnHJGUwEKagcFCqSFwCyE1UEuzDc+2Rlgbf
         Aze8gxVye/i/9Of8R6meKFPEhvXpvBaSvwVQoeEIaJf6WAd/ZXz3HSZY9QFhpjdOul1N
         NZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546975; x=1789151775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gOkqG6TuNgAD5h74emORdEhCfU9eyK97BAx9wxJ6SUQ=;
        b=pyMcLOxYbGBZQLQJGTaoDB/CYe0rgAks78oViyaJw0BZXFezACnhoWQT9JBQ2NqSG7
         cU9YnaKGs1mPpGSbYx/HBe5wHAw2+NMgRuX2fEBFFOOpbbyrbBKusSCdGeaTWyYEWzAz
         6NCVO98sOcsVg9dBlzNxDVVtErE/laLncQzcEp22GEhdBLyMhJutqUNCMU+LzMDzRRnA
         Cq5JKCPJzG3/Jgrl8Px9Ijz2TmCYZPNxNMALB00+6PCjfniL2pRRiDe24TDomPL3ltc5
         Dg8hokV8ZsFapAd/XAfPpd75ddlCVX5o5SURxb1C8d1t5+Z0W7AKQm9b5WS4YZwpdnI2
         H3Mw==
X-Gm-Message-State: AFuF++m6UFrdxZqM4dM/AQa5tYTaHep5Hj5WMoUDSrVSgGZC0nT3sPKj
	PUJ1yUdfQjiUDypa8F2UbLuBmmhi1d8wzRRIytjL5jszz1BxrkjeTuj6hgOOzloJ9W7jdbdHX9N
	3Y3EX8r82aawfYHjQw1ZSsTvaP6lsi7M=
X-Gm-Gg: AYBFou1Bmwlu2cuEyN8r5RgKtE5CFP0HkM11mOV60Kn6mh7xom2mkqqGBkGd9SHdhck
	mLzX6/SAKKW0bHkiazw8JGgw9wCCpq2v4JEXtX7Is+m4nPr4B433V6olxMylLs5X4mf3Th3tEYE
	zm8XCjhic2m1S9ctlNMigZQiq6BIXSrSN2MXzZkmWsrQxfqmC9HiKkfQG/0N75LApzwrYUKk8WL
	EQFo2XaVAFA4xwyNr+gXaEUwCtMpLnJHVZuu1NwvcWDr7M/CoPJuO9pCmL5eGpu9Dkwws7kNAQr
	B6snDQCciHfTkRcogp5G/kCPjvNkUIdgFZg+P5om4+LZYL1hlxEnekOkQtelqDi6J4URutl3+wT
	FNY/SjB2LCLDS19K5Ida1HpTdsZ1iJBUFisD7DvGt4D8Ec6StLSJyfTcWj8uTSatgxBFqtR24qH
	i/MCwFYbNpUrhbaeO3XHJ1dVKg523YFTan9Dj8mz0bJFW1G6RW/waaWIGGd4WTTGs/Hw==
X-Received: by 2002:a05:6402:270c:b0:6a6:b2b9:61f9 with SMTP id
 4fb4d7f45d1cf-6a7e9520211mr2501315a12.13.1788546975225; Fri, 04 Sep 2026
 11:36:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812185747.79173-1-rosenp@gmail.com> <apqPiw_Oar-BaAtv@gondor.apana.org.au>
In-Reply-To: <apqPiw_Oar-BaAtv@gondor.apana.org.au>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 4 Sep 2026 11:36:03 -0700
X-Gm-Features: AcwNN1VP2B8NfhJAXVOMzia2qg2zEOCOf_CklIrufd2iLP7DY1YOBJrTMm_wENQ
Message-ID: <CAKxU2N8ytLFpf_dCR_ymi6MmOqNDj+4XdxyPttYnr_pgrmyuVg@mail.gmail.com>
Subject: Re: [PATCH] crypto: amcc: trng: use devm_of_iomap()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 2:29=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Wed, Aug 12, 2026 at 11:57:47AM -0700, Rosen Penev wrote:
> > Convert of_iomap() to devm_of_iomap() so that the TRNG register
> > mapping is automatically unmapped on driver detach, eliminating
> > the need for manual iounmap() calls in the error and remove paths.
> >
> > Assisted-by: opencode:big-pickle
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  drivers/crypto/amcc/crypto4xx_trng.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
>
> Please check Sashiko:
>
> https://sashiko.dev/#/patchset/20260812185747.79173-1-rosenp%40gmail.com
>
> Thanks,
So I guess conversion from void to int is needed beforehand.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
