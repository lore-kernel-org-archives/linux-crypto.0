Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D089308F2A;
	Mon, 20 Apr 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776696746; cv=pass; b=n4gajWQJC+uaXkIXNPbBUX/VmgfflgnHySRsbQsCO6pSSvX/mZieJJpoxqZgrJwaIcE6XrVcMEM7YzrvV+bY0hVsnBnIkEfbjSySAYECSaf73YJuJB11GhgXZDYqp/v0iDc/+yoB4j4CssAqEPK8EOE953szXUfz9EDtBbp23qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776696746; c=relaxed/simple;
	bh=gou1AsmCWquRRwK1l6Z+46tA6I0zqSU0zMvjrI6PQF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBwwMKJTcqrsORhOR9XkY/dkaZBlVb/wPDmhWWmO4nP4EFD9GdifJykKAvSxM9yMnjHdHu1nWZUTf0x4tl0JBcqPsr6aPgbSNBAIKyR55SIfBNIFmD+YWXleIUOwXyP07fsFNdAx2AiIMEbl1n9dc+PC8Y0gUlLisADFmVjra0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=Dnk7cEQC; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=mN9vVUzk; arc=pass smtp.client-ip=85.215.255.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Dnk7cEQC";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="mN9vVUzk"
ARC-Seal: i=1; a=rsa-sha256; t=1776696024; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ndgBZQQiR7BRWKO6I/6d0Sui4wlT1X5fM0L7jIDkwPDivlV/k9Kb0gJU9v4QMxLhyF
    8Mbm4L4QXwM313pcZ3jkceXmgCvoTBnayBvFN6Sts9pEjOhx0uXVFwHhqBWBKKg5Xl9j
    JymIePVlRxGQgXKvMdhhI/bJK30+Iefsg2hHhwzqwNowF58Fk4FD5kVxRKwk4AbicpPl
    t+y/xSw97OxrgncFEQ2D4EseYFTCiamz7Mi+goN8XjZKrlKeH+yLYBQHiuivZ2Q/mrbS
    HA3ykTVEJl7HDzxMO2Po3B4dfwTVBx5I+7HMr8MaTOUKWSd18jOy9XgXvkOawOgxEodm
    x85A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1776696024;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DEu+Ioa/vl6puvJDptVdZ5jwQw83/GukidV7goX3aIo=;
    b=sIEAcQcsPwmb7DMnAK8j7D49dtWXcAtCOSSeYAXyFAdJrqmKX4yy1nU6I+LAlRhhos
    kE1ujmQDLHd3h+vo18jP0X9vRwn4RYpYDogaI9WvPBZEth608CNwOoP4y6p5pnIsOMcv
    t0ofQALVGa7YT1qQaNeTdQ/HmIAMZL9rkTRVxohJJj/xUQZXyJUCOmCalsbA1nxaYdEe
    vwD6ww2/G9UwZN+BD51iMMT12ruQFOg2jo5CpRUfdUYBK/D9GbcmqMHq+IGmVst2Rnfr
    TfbgdNsqqIfbakvSnRyArYw3vxRLMEsQ0IIESQ4gPS3+/5nXciHpurgT6Ixe63lGgUaJ
    lmzg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1776696024;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DEu+Ioa/vl6puvJDptVdZ5jwQw83/GukidV7goX3aIo=;
    b=Dnk7cEQC7b0rLjw/fk2IEJFUTcovMvz5Legft0E6s6ki8TwKRdLECMYehUljRR0U74
    O3qd5+e4m45DfcvsABXoBD97JPLJRPP4LD7QtHkYoZl4UBCH1HSTkRtt3IlN9SL2Uc0y
    VitwIY8DC5PU5YWjAjPYa/3dIFTlOLE/TqS93tA+556D6rhe3vwYO9jYbov4i+zByrvO
    RY2RYdKKF9ctQJwKjZF6Ghp4dnHNsMDUMU0fBkp5+ISbo4VyUekHxmJ9+BUKZ7vZTT/U
    RHFCPmtbRjr+BGdK01gc3TsxPLgXN71RGiB03b5KOLAnHR3tYDFnjbPp96DdoEv4jBmb
    /5EA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1776696024;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DEu+Ioa/vl6puvJDptVdZ5jwQw83/GukidV7goX3aIo=;
    b=mN9vVUzkEpxbGgP/6+iXCWR3e0YsqUTq0yO1o3n75QCVYbbWI750od0zDcyV8YO3QZ
    fGZ3V3Rs3Dvh0i6XGGAg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yWsdNeIHyFbS0Vgyta8="
Received: from tauon.localnet
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id f7792023KEeLvZD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 20 Apr 2026 16:40:21 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
Date: Mon, 20 Apr 2026 16:40:18 +0200
Message-ID: <2300345.NgBsaNRSFp@tauon>
In-Reply-To: <20260420063422.324906-13-ebiggers@kernel.org>
References:
 <20260420063422.324906-1-ebiggers@kernel.org>
 <20260420063422.324906-13-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 20. April 2026, 08:33:56 Mitteleurop=C3=A4ische Sommerzeit schri=
eb Eric=20
Biggers:

Hi Eric,

> Remove the support for CTR_DRBG.  It's likely unused code, seeing as
> HMAC_DRBG is always enabled and prioritized over it unless
> NETLINK_CRYPTO is used to change the algorithm priorities.

Just as an FYI: the CTR DRBG implementation is used, because it provides=20
massive superior performance. The CTR DRBG implementation is lined up to us=
e=20
the AES-CTR mode directly. If you have an accelerated implementation like A=
ES-
NI or ARM-CE, your performance increase is significant.

=46or example, on my M4 development system, the generation of 1GB of data f=
rom=20
the CTR DRBG takes 90ms whereas the HMAC DRBG takes more than 4 seconds.

The default of HMAC DRBG, however, was used since it has a simple logic and=
=20
smaller code.

Ciao
Stephan


