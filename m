Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518679;
	b=LapWyoZsciIVCzoixpQsPeppsrr5ygTI6NQmEMaaOVykAceQnJnJ2Uik4A8YWBgcoOBH
	 +iTq01wFj93h+ChDtmVJSZZTq7t0T9PcigoGXizw3Ji9hFS32RUXU/xjsrLcXJxA9Wsoi
	 klwak1kZ1EEppoUYv+YT26udSqZVmfN3ADLyVxbxqSxaIP81R1e42LmCDLSBh3UiWEMPx
	 2N8qKGCgyl1VjSJIr/pUgqmCMe6gh1C7v8Ig6OGchCFZWmqctAjYvc+mqXui9FPwegLkl
	 +5qR3af+BJp4+L6lpqwo8MdzTdw2qdsmrwH4WdSxr4VT8VHJZ4u1wnfcyu4T+K2dIqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518679;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=1rqNf8DXGNQhqw2bih7fwgNOK1pcQshJVyfz+w/p2OQ=;
	b=PH+LxNzsTufvXsCSuyPQE0iiJuejFoG+YdFo97pbHCHASCZA1pGIymHIYGvVqeStckd/
	 n3F6OT787PUhc/94j0JKYdvUsi1uZoCL+jVFH8rVo/K0+EsKk9qqMVCxccr/zTO8iBhKf
	 PSl97i8MpDnytJXtVmV0UfFlthEaMiWWugbmD2knUdBphbyYg3cKc8RaT8E+SjLZwEuJD
	 by7DwgtGl/wD3mZmwl67hEG9VYAGmrsPBwioEME1YdgwOAPnpsNy9r9N2W15SUCVrAvlk
	 Ct7bGZZFDKp2/3jt2Bs7z9+3C4Dx2qyAGgV9T9hymtXx6HyNn5cctb6mFjBgM1beypg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5H2R0A8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F8606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 11:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5H2R0A8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A21F000D0;
	Tue, 24 Nov 2026 11:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518678;
	bh=1rqNf8DXGNQhqw2bih7fwgNOK1pcQshJVyfz+w/p2OQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Q5H2R0A89EI23bEby5GCCIecMBCreYJxyWyRALmPE36C0sdvdDW6x+FACknEBIktl
	 QElB2NtO3jNXSyvn2HIrKLG0OnZ/RBBZSMQlZ0q863iygT+IoFRt8rGv4z6WCYecw7
	 eP8BddpjsTbHmoY2Xl9qqfeGf+R3ae5wIc9rfQowYtTZr+5y833ObsKSJs0wZJonK9
	 7EcaxF3pvOWrQyeAWNbEI7w1G329xTWkBEBWXAhzB0td9KlNORbPFM5sipdBsG76Gw
	 a0f6CkLXkoGaAdb7WCUVToKMVtDdmPYh8WU3/mtzL4iEUWHxPKuzOXZ4WrKZzeGs8J
	 WsrMWLKFfh0dg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 94725198003A;
	Tue, 24 Nov 2026 06:11:16 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 06:11:16 -0500
X-ME-Sender: <xms:0nAFa9VWpW9uJ8l3_D_wUyXrLfEw6nZFJrWYwSxf7tyIYxR8t3pO8g>
    <xme:0nAFa4YqVLPzf9glM33mF1LlFbs5RmaN917HnaLE5NJE1Vq8U5ZQ4mH1-qg5P_P73
    CoQDqPMBx7YE5PMX2oezf6FIyp5FgoijhkY1aCCcRL99yhmyOU-zxKw>
X-ME-Proxy-Cause: dmFkZTG2GcUkH5HHLMhct1sPKBX/cvn14gnx/Zs5RxgF/vwxnqVC7OvwHkd6wuE4GcD9ky
    kRzDtGLVdMQcN8kYRoZqDWL0uAGk/o7e9bb5OAG7qknYM7UNRdnsENPTEEVJKgDyXJno6l
    bgx84+1O0w4cYTPvoC0eCRYyR6ogh2YWGpNYnS0kmry0nTczFzbr+sYV0LjU9JLrqzqyMN
    4KlY2L8+oGGS1qeVJ0SXOV75QItRRh4YX6xxkPVQre43Ykn4QJ59Q035JFqF5G6d27ORco
    WaQnsxCel3SAI5SivSgCPbwecghpNiJjS6nEtRGIRXwBxe97uBg5mWi+XTwG+bQ/mjXflv
    MMyLGr+y83jLAVuy8fr4rn0oNCeDOkztoNGxND0NHSTPg6lNbBWs0hqmyGv+UlAk4UZCBp
    tOaCDuzdyCEEfJB/8xZ7tLEQtNeyifI97q/Q1qeTi1nAl7i9r3pizuX6BjJyaJdwWhRc23
    WRgAZ96E4BPI1sz4Eqguxz7wn0ln/dqwXOFdXFYaCsSz3LJKgWLl32TNlGR9bQkZzGDFX/
    0KxqqmoAGi1vxy/+IC+N2M7h5rtL2XFQ4pUShztbrmwqzPF2o6PMc6s9YTWxkll8Uq1EOd
    MJgoKd2inbIY/5OgskcHbOG2UCbVor7hQIhuM9AXkcPu1hXUyesz/kYZeAsg
X-ME-Proxy: <xmx:1HAFa9uls_ezzIOPSG0VqpxzrQnE4h37fDp7j0p-208zhq9yxJIwGQ>
    <xmx:1HAFa3LOEz2ezP-8pqmMUwR4R1KRmAHMTsYypqQrY4TBPtJEVRsbwQ>
    <xmx:1HAFa-8mtkEL-DzR98a6Nmr8ZFujkjOxtTZrKjb5URQaChJvip58nQ>
    <xmx:1HAFa4ytKhqb1psvaagNiCMpBDDJPpvSgs7IESZIsErfNIjF4whDCg>
    <xmx:1HAFaz4IAlX6UO_erPKikg5noWxOS-bLp4i5XjChbTR0u9RBP1gjdeId>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id DCC92F80093; Tue, 24 Nov 2026 06:11:14 -0500 (EST)
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
Date: Tue, 24 Nov 2026 12:10:53 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org,
 "Emanuele Rocca" <emanuele.rocca@arm.com>
Message-Id: <f87eccd7-f9a8-4e94-8fad-603703eb8bc8@app.fastmail.com>
In-Reply-To: <20261114211019.80609-1-ebiggers@kernel.org>
References: <20261114211019.80609-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64/sm3: Use assembler for sm3 instructions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 14 Nov 2026, at 22:10, Eric Biggers wrote:
> All supported assemblers (binutils 2.30 and later, and clang 17.0.1 and
> later) support the sm3 instructions now.
>
> Therefore, drop the use of '.inst' in sm3-ce-core.S and just have the
> assembler generate the instructions.
>
> This requires adding '.arch armv8.2-a+sm4'.  (Yes, the assemblers want
> sm4, not sm3.)  I also tried just '.arch_extension sm4', but that
> doesn't work with binutils 2.40 and earlier because they consider sm3 to
> depend on armv8.2-a or later (and this file isn't built with
> -march=armv8.2-a or later).  This was fixed in binutils 2.41 commit
> 205e4380c800, but the kernel currently supports binutils 2.30 and later.
>
> No change in the resulting .text section with either binutils or clang.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is intended to be taken through libcrypto-next
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
