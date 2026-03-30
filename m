Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ADB27442;
	Mon, 30 Mar 2026 07:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774856921; cv=pass; b=gOx3M78EhdnzdsyN4tTH35YwreXZG1DwA7Yra4QT1bqNWXPRaHn2VA0fy3S5bNLgPOM2EmYu8KwMPU/r+827Ul/OLztcHcFAMFiKWKgLY3zbz4EZ96t0Cf4nBjtqGbIm9T5O4S3DP78hs7d4NccVUaaCDKWSw52sGIvYYhyXpGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774856921; c=relaxed/simple;
	bh=JS3mUaxHpNIfK3xG+FD7rzZtq5N3AyYsBKQpDTCe+2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3Ak+WAdHV0cWqB2yQMJRlc5SJU3bG4Cjeoyp4qPgJc6r94M7mnEEXtrTKGp66yOPic+Xhv3g0lhXTPW2drc79pNqTuBvhH4ICbW9N9sDO/9Tcbc3PJ4ThmJWLPsdZrszbLoQe3v1AvBPcMN94GkmCWMtpt3Wt4cxv/uPTU0oI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=CNL63hV9; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=0PZbj6fc; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="CNL63hV9";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="0PZbj6fc"
ARC-Seal: i=1; a=rsa-sha256; t=1774856198; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=nnyHqy9CsSkGt3KlUbu/3FdPQu5PrA5hsk/HPJE3hLoW2Ew9E4TYNW4ORRF4cL2Cxh
    DNRvGhgmwv1yL/+2XayT9vOWKXq+fYMGRy4uaW0mNl3YQ2nNyQUWV/MNPM280t7VjOWn
    SLP9dIOQjSayXQB0Iepa9okucQ1Dg/gz49I6BpGsgQCdsTjbeonPFgwhrymTEg+Rx0B3
    TSrZSRUAnfTOBK6YlhMEtMc6cVn/xbrIKcE4o3gYyd8GjjyEFoJi2d43iCtYh3j7BI1X
    dg+aX/NE/6kWaG6WiixI+raKWVvqaEVKbXZD9wcc/vKViadLlil92t0LY3wDlDHN0iDy
    bV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774856198;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JS3mUaxHpNIfK3xG+FD7rzZtq5N3AyYsBKQpDTCe+2A=;
    b=XdHhaqJlGSEFC67Mp1AEqotDQudiCzzExA0kiUpJkWSIrkGrc6J282ZO1odPWTGIVh
    5dEjUkouMDMNb9eB/rrpAoYQFkQCTuuBlS6yynbsm7/5O831GkGkcFQq2arFmA2BCwYg
    prZR8ibjIPZ9a9bUBUoy84XdCMU7VtF4+wV2yaiDyW7LDgx2Y0RX1urQ+GKEIT0xSn63
    I8GT3XFhB6hsbQXPKEfeL6R0SgIbpZdS8YNJfuwbBsfNHmkyHvLJA9ii4drNUKALTP2l
    LV421wM+Rs7wKEPtAH0+Z/kv8lqHl1BdjSiW6+up8wwQ2MwR0DQRmpeDTzibrQXXEe9d
    yNXw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774856198;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JS3mUaxHpNIfK3xG+FD7rzZtq5N3AyYsBKQpDTCe+2A=;
    b=CNL63hV9BVyMwfuutnUHomBRiqZ5qn/OjViMOhjhqgMohFXudMnDa/CDZ/PY+DGCbo
    Sdh4xfPmCw+fjW8hwDRbmODPUuLPuZ0cutzioTD0pmpi7lDgVRE3wueQCDu/2PY2UUQa
    F3ujGHSlO6LaYfjJ5RupqvoiujPpJ1omC0YtlCJvsDV2vfA0u3AVLxvJYqBewcetvi2h
    oF4tQ5BafUqNx1eukU0NOmRcuy0lW0lvT2RXuGsgl3qvaEnQS7hrNcLlvQlT2Y01vDTk
    WUuySkV8n7iL2GClVG2KsL31K/ixnL06WMxd9zJin4Yf7SxdpUYbs/aJjtrfU8mvkNLo
    tt9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774856198;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JS3mUaxHpNIfK3xG+FD7rzZtq5N3AyYsBKQpDTCe+2A=;
    b=0PZbj6fcoKep3B5gBSE/EdXn99i4VOhwcqe9mmKB6b6Ye1qbM0LTZ9G0SuLiTZOmoP
    YnAM/MrSmxKZTHbisGBA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYIvSc86Ny"
Received: from tauon.localnet
    by smtp.strato.de (RZmta 55.0.1 DYNA|AUTH)
    with ESMTPSA id f7792022U7abXuq
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 30 Mar 2026 09:36:37 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: linux-crypto@vger.kernel.org, Haixin Xu <jerryxucs@gmail.com>
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 yuantan098@gmail.com, bird@lzu.edu.cn, jerryxucs@gmail.com
Subject:
 Re: [PATCH 1/1] crypto: jitterentropy - replace long-held spinlock with mutex
Date: Mon, 30 Mar 2026 09:36:36 +0200
Message-ID: <8044552.18pcnM708K@tauon>
In-Reply-To:
 <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>
References:
 <cover.1774854094.git.jerryxucs@gmail.com>
 <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 30. M=C3=A4rz 2026, 09:23:46 Mitteleurop=C3=A4ische Sommerzeit s=
chrieb Haixin=20
Xu:

Hi Haixin,

> jent_kcapi_random() serializes the shared jitterentropy state, but it
> currently holds a spinlock across the jent_read_entropy() call. That
> path performs expensive jitter collection and SHA3 conditioning, so
> parallel readers can trigger stalls as contending waiters spin for
> the same lock.
>=20
> To prevent non-preemptible lock hold, replace rng->jent_lock with a
> mutex so contended readers sleep instead of spinning on a shared lock
> held across expensive entropy generation.

Thank you very much for the report and the patch.

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


