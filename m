Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBBC457E70
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981018; cv=none; b=WsieL5kMXr7voX5wNdCRgwWT96TSKqNoanTmtVv/JCbGhc1JC8PSzUX0WTmGdqlB16odyUqTzZIhtoRigWJUwWS9mZIdLfpkBfovFzHEAeL5fwe44+0fdvpGPgqm4O9KqrI7V3vTtN8XovXHcumWOKpnARbj9UdGVqljZ17BtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981018; c=relaxed/simple;
	bh=2a5mHMgwlyejMsFJQNISCi2AvFfycqTH5EAXJVfXLvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCZfk+KBx7qaWqO1cdUgvQwVGY/ByGRJ3thRxtYzpPtlgW4UnmWF6CSlNfxcQGCkzF9gTsbQFtI/bg0eGgEf/jaEGWskspW7S4dtLsvDt4j6OoMri2lPtI3SRUlodnSeLqjCuaNUg+297ZIP8c1BDuFxfLxPBDN6njVyodqlpUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWWAKtbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWWAKtbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02081F0089C
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 08:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789981016;
	bh=2a5mHMgwlyejMsFJQNISCi2AvFfycqTH5EAXJVfXLvg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iWWAKtbeMFd8MTJIlJ8Ojb1MD8bAC2qJItwDlZw+33XW8Scrj1cRSH3A+SC2saFjm
	 xSZTm7SOnJsabYlSRk80otn1Sr7E/BXGymGxVMtWdhm4jznFjQ7HcQwUsrHHsPOJZV
	 anr4AvegeaXtkGEly6db3MshWhgfOCZYkulBM6gSySw1Whb+j40Ox0FCgzCvh7//r2
	 H5QhnFqgp0hR2lvJo5Gd6q6abZkMznlOuAbkh+lz5Sk/JlwOU0tqwN6EUnymjie5ne
	 tMB4crx5jBnGB/UMqk3uWz9Tei1nPxiNbXxhHMPq4BI0lX7tIGXsd4UjVNKBAx0JTT
	 1A9vt36jhstww==
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b74dbc7359so1951621e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 01:56:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByd2AyfWubcWBY4R+tKabA3CigmLfm22U757uLjNJauJV694ujCPEgqZueHrNh+7PVPLTP8ctFx+sEAuf0=@vger.kernel.org
X-Gm-Message-State: AFuF++mOWHhZu3BuaDn1g/T0tAjRiUzXAa5p5PsIgNw9Pc+u6eQJ85+d
	xGEi8A+TlR0U4d2eSs0PFDmiOHwUsAow7hW/v2OF1tXnJqcp7qMDeoXDfrl/JEK3tuMODLnTViX
	taboDEa3o6xCjZMXxvfXJINoqrbG4TtA=
X-Received: by 2002:a05:6512:3345:b0:5b4:8658:a401 with SMTP id
 2adb3069b0e04-5b8c17fa206mr3083443e87.19.1789981015453; Mon, 21 Sep 2026
 01:56:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921061120.29694-6-blum@kernel.org> <20260921061120.29694-8-blum@kernel.org>
In-Reply-To: <20260921061120.29694-8-blum@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Mon, 21 Sep 2026 10:56:41 +0200
X-Gmail-Original-Message-ID: <CAD++jL=ah_RX1P3fPr=QjJpzhtxti5wz7FB+Vs-TpmQdrKSbaA@mail.gmail.com>
X-Gm-Features: AcwNN1XALyjIwjQI4ZaIxHXpArCEdJ4cTcRwnxSkp5lz5jN9zOxBaiocFEsP44g
Message-ID: <CAD++jL=ah_RX1P3fPr=QjJpzhtxti5wz7FB+Vs-TpmQdrKSbaA@mail.gmail.com>
Subject: Re: [PATCH 3/5] crypto: ixp4xx - use memcpy_and_pad() in register_chain_var()
To: Thorsten Blum <blum@kernel.org>
Cc: Imre Kaloz <kaloz@openwrt.org>, Corentin Labbe <clabbe@baylibre.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 8:12=E2=80=AFAM Thorsten Blum <blum@kernel.org> wro=
te:

> Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
> simplify register_chain_var().
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>

This makes sense.
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
