Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955445;
	b=GCpyYWFyMosqCYJ5Ai9mcNiDEooISwYJcdWFFb7y4b+gItZq2Nn6ndWmFtu9dnjTt8zW
	 SJWPvi5jhdqrn0fVnrROaGF7Y2NtkWmdXZril2YvlPqG+n6aMx6k/DNNDciHAIIIXL729
	 IzUYVs5VBvA2lJPtsrEyRWyLoHwFHzrc3uixyClEWONP6jIhAeSrmrubB5VeIcudos0Yc
	 BvtWVqDPgMsnJ/9hO8Sla70JeyttjUs6eLhUckCHP2SZfgREx5TtvnRwkKn1wRQxCnWLY
	 BoSbiAc44i0gtJay1YK7J1WzaIT9Ro9JbuaEko2432xvXjnKtP4lo+u7gRGxG6g8mZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955445;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=zAm+Qxq3AwNjcyzNwTLKYZPfyr4szSJKsRwUt3uckiY=;
	b=c8LE5b2b6oynR/y0tXCLLma4veMrxXWVnAodvLBmM/SToqYwueSAGya/sh9LMiyu2/0P
	 42Ybc6+tH896mFrEpiSuWKtrh6qzoHQY7oANEbx3pwsmeIITf7aM8ka2p8/bzYWNWEVH3
	 RpERJbOfGGEpkkF2HrE3nzF6G5LHeN7qTrOWpHbXvCYmb8VvG7zsMvkZ8mt+IYLY6fFbr
	 R+NdJ1//ojy0EveQ8MwBui/uyWmpB3vt9aG+dzGuclF+JrnFisvq2YwhI01CGWHLqX/0f
	 PmBgpOpxcMgm5rfo5DOk6AMpSTq0WIUnffP0VP5KDTBWMQo+M4kDIaQJ2iDgKwIIipA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kztpnqol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98B606A32C
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kztpnqol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578B11F008A1;
	Fri,  6 Nov 2026 08:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793955444;
	bh=zAm+Qxq3AwNjcyzNwTLKYZPfyr4szSJKsRwUt3uckiY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KztpnqolyWzW9MJQyqnhiTG4kyH8l6eMbVJGBq+p1Ar0/3L0qwCAVtga3R583rsCn
	 7+i94iSmzJkY0b5inaoJpf+/JsuqHvxpHO1Ayv3ENv4cC6wHX+KkHnNX9dTE3pa5s+
	 WJPmJuhvSKjjFwO8e1PeXWIuQcQtFzAGliTQrFTSIPLhZfNJ3HeU1IRKMQA9ebjfak
	 Pzc0XGl3YB3yA9rOGbSfQPm+6Al6mM17o9gFnm6RLWB4okA8F3/hE1roPVibnUZkn5
	 YU7iBQm7RBIfBM0ZYrLIaB37pNkdc1dQWC5zniPmBtOQO2hNhWK8PPVeM0M9UCs66v
	 IzMwh1cJKhUmg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8A917198003A;
	Fri,  6 Nov 2026 03:57:22 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 06 Nov 2026 03:57:22 -0500
X-ME-Sender: <xms:cZbtatRtl0UbVGZjhqfJbQ_LNDiFRc2sGw_21gQkSNY8oA4m77TTBQ>
    <xme:cZbtahkPJaHUiQ3liKL3jggyTWVRSC0bm8VLKbbydJbLkESROwHXb1rn36bGa8WIz
    -TYgD7qbTLa3y_wc_m_KbwncSftrcCu_t1uf9T5ZOBvPZQCWd_JTG0v>
X-ME-Proxy-Cause: dmFkZTE3w9h05NTT/kixG6tbOeWGsgiAqxt80A9hxhkIQpVwRz7C7d7vp8eiKZoUdix7nV
    s7/IQXJQDzDmD/JDIM+DJH4+oqUzwkb41yHMSQbfDaHZDaxCZzWRZgXtvPno33YDvmP2eS
    q9JHAFaS3ZpFEWXTbcVxSggDZNzKx7+EnftaRLF4/iTQvpVt8euyaHL9mwj9+kY/gO0h+R
    xEzYuPVCgoCoGyqZcTPmgtaekdZVB4bqbEHs6Sq5b4Qoa0d4CzWWG/tPWXXxDvArFJKSG9
    WnoL1orA7uvBHWJac1mLFcygLSczR035g/y4afz7fccJEZ/MdoiBlfrTaPBuz5imOlMINH
    /hgSrZ02mUw9vtePeRBUq0ct1CiQKKBUmU33bJqt1cDp8BSG94h1wjMAKet1PqZtcPT5ZN
    A0I/eCFtr+LmzLLNb/hdW4z8ocy72pjvsKbv5D4leWqNRkAGvycBpt4Kox/byy5XL3qD/8
    bepfbxu4PDqnSkNEWoeAUapTwnnVuhsyEfUXVV1UztB1nWwzr0NN3esx3Loo27+S9KoCm7
    4SlTDKJKi7N8AFBRjBufwBG2x9srM2VaqoYgcHokeBxXrvBBLjTL+aORjfXyea1A82IOEp
    IAl/AjWe4UiUiX5fSlCbIP4vxhhzE1wFUonorn0aGICydn6dQRnzuhBpdQhw
X-ME-Proxy: <xmx:cpbtak4Zu0Yz30U0TfHQ3QHCXB7W-nsSZYBnawLC4-jKNAToyYvZWA>
    <xmx:cpbtahUo5HxSt7AICtGWj34zVZYScGNUKo5oquJdFu-08uFH7mdf-Q>
    <xmx:cpbtam8Cb9or82HBcSkq4swlTSZYf3fb0OXeqLFuHG5c-vLXhDnSFA>
    <xmx:cpbtatmp9FgENH1XAmeP8O8gQ_lp0QX8kUs8aBMxF4ZRvNg-UQ6mgw>
    <xmx:cpbtakXa4xWV1evXyDpOr9YZZZCif6KLUVJEFEtOlTH_eYRxjAPvP9j8>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 46EB1F8008E; Fri,  6 Nov 2026 03:57:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AMwy3xRkW0AJ
Date: Fri, 06 Nov 2026 09:57:01 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Emanuele Rocca" <emanuele.rocca@arm.com>,
 "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <68e24de8-0c94-473b-b2a1-47b9b79eb974@app.fastmail.com>
In-Reply-To: <20261105154145.557042-1-emanuele.rocca@arm.com>
References: <20261105154145.557042-1-emanuele.rocca@arm.com>
Subject: Re: [PATCH] lib/crc: arm64: use .arch_extension to enable CRC and crypto
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Emanuele,

On Thu, 5 Nov 2026, at 16:41, Emanuele Rocca wrote:
> Instead of using ".cpu generic+crc+crypto", use ".arch_extension crc" and
> ".arch_extension crypto" to enable the required instructions.
>
> The ".cpu generic+crc+crypto" directive replaces the assembler's current
> feature set with generic+crc+crypto, dropping any other features that were
> previously enabled, for example by -march or by a toolchain configured with
> --with-arch=armv9-a. In contrast, ".arch_extension" enables the requested
> extensions while preserving the current feature set.
>
> This is not a functional change: crc32-core.S only uses base A64
> instructions plus CRC32 and PMULL, which remain available, and BTI landing
> pads are emitted as HINT instructions. However, using .arch_extension
> avoids the pitfall of silently disabling features. See commit 9142c2f8f84b
> ("octeontx2: use arch_extension to enable LSE").
>

I don't mind the patch, but I will point out that issues such as these can
never occur in .S sources. The emitted instructions are always the same, and
the only reason we need the .arch is so that the assembler permits the use
of the special ones.

Commit 9142c2f8f84b is different because it uses .arch in inline asm, where
it switches the assembler into a different mode behind the back of the
compiler, leading it to reject instructions generated by the compiler.

