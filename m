Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614389;
	b=ij+o/aRUww2oNMPT3JEGSJi01U/OLenC1cF5KoHUwltN6kzbeF0S9NEYF9TOGG8hpmVL
	 1hfgNfgBeXuAFXTXnjjQqODleDN98IWmfNkb+ZMGitrmpYFaqlknPZMz7wT6BYLxcUurN
	 BPBdgcagLnPtV1diLnIG4EixfA6B3LPyTmK+5XX/MfLIL3e8HPlx4Ut9UmXJKe7rB0LOM
	 K8MrfHprqBp7WtUQhjl9FJCGOoALmkZvcm/TOMN6njwEahkTd5NMrUQv6zyJci0H3UaJ8
	 NMVdoIxy29uNVren6lijWthcLDJ50bjzHy1E9SLsaP+fKphK2WUdBR3X4a2fcNSxWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614389;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Bce2KlDG4ggff4eJWY/Cqm429Y6p4LEqCaZ6RsNcRH0=;
	b=EI2w4LaeRocQP+W5OVpAUJEPxAusMXYOArabA33WlE5i7krQFBkXy6ZynNtuFwsUxJbO
	 dIH51iajtvTDXorD+0FXwDVqF/7Ch/Ym1dUBoEqKUlh5yGXDBCYl7135raSQJlMS0gLBM
	 ZikH9xDqjwhfaSl5/FX0EvwzcaHGHRZLRkm5HZzg1KNXKpDok8FqRGIbroPxz9njHud2Q
	 PJABsMYJJqziynbKswNMVWS+VAuIeHrxwAB9MpEnfSp2bWZjWqZf0ZUHypseBjdweVHWU
	 AWfOCu+oBGDnW+O8lUK5GMBxJ2nUcmi2jUOSr+xEKUysgb9FU8+43TX0/XD544Qcsrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=E+KBQkQE;
	arc=none smtp.remote-ip=109.224.244.17
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C088606A31B;
	Wed, 21 Oct 2026 20:26:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C088606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=E+KBQkQE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1792614386; x=1792873586;
	bh=Bce2KlDG4ggff4eJWY/Cqm429Y6p4LEqCaZ6RsNcRH0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=E+KBQkQEFkzbBzlQftAxcYF1jybkzElM1zoymGeLrC5kjyrf/trxyNJtH4n2njzTY
	 tS9r09T+ZzNiQ2eGGOrVvbo4Q7GSHFm6aXB1zWaW5kNnUQUzCmv6s4oyJP927zlUIU
	 cXpLPpeTngInBWLHiW9oNf/nxSn2sxxeK6Vu2Juq5EyJ5/RTi0yC4J0Fjjy6tds8Kp
	 aMuLo/yxh5nueXWzcFH+GlzL0E3UyIVWdNmvfYmgKioCJKy0KIfTWFpJnnu+F5hyTx
	 othTOQvqBJPLq7PldAsyejnP4T9YWGnTUlyWhjfHzClrpNnLID6Ihua7xYKaJaUbP0
	 xAN3oJU3j5WZA==
Date: Wed, 21 Oct 2026 20:26:17 +0000
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
From: Birk Skyum <birk.skyum@pm.me>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [PATCH v10 09/14] crypto: qce - Only register algos if the user really wants it
Message-ID: <179261435862.92690.611780170759449709@pm.me>
In-Reply-To: <20261013-qce-fix-self-tests-v10-9-57162a38a554@oss.qualcomm.com>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com> <20261013-qce-fix-self-tests-v10-9-57162a38a554@oss.qualcomm.com>
Feedback-ID: 21326998:user:proton
X-Pm-Message-ID: 65740e0ea33da3bf88d934988af2b35a331cb6e5
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Oct 2026 11:57:38 +0200, Bartosz Golaszewski <bartosz.golaszewsk=
i@oss.qualcomm.com> wrote:
> The power-management part of the driver is kept as is to allow scaling
> down of interconnects gating of clocks by runtime PM.

On X1E80100 that part brings deep sleep back. With this applied to
7.3's driver, qcrypto binds without registering algorithms, both crypto
paths drop to 0 in runtime suspend, aggre2_noc and mc_virt reach
sync_state(), and a deep suspend counts aosd, cxsd and ddr again.
Details in my reply to 10/14.

Tested-by: Birk Skyum <birk.skyum@pm.me> # X1E80100, Lenovo Yoga Slim 7x

