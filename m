Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795650192;
	b=nQXw7v29J22/y7Ytoc/28TNotPz9agqc3jEYWuoLGc5gQBS2C8nMulcKbmS65PPK0xUn
	 2OISX5egCOJ8MD8svfpbUuq1tCCZWESnFSI4ScoQZYIauUz6AXev2vSgQVkOqbkTXQzgI
	 LxzUtWgJZx+ZJe1EqVodtl9a91sLLy5q8bT1aMilJtS5Mreg7+QcZAxa7mPUGC7TSDRCI
	 GZGdQJbkjsUwLw/wOn6/uPyZeWtRCocKwnrgcaIdTS4vuR5UeJT0mtKV6hoGeO7P1ii/j
	 aQylQc50PFlDm3i6MtfQpzwsp3c9nJJchlcnZACxgE9+GoIDzlOi/S1zGrvg9Jm8vcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795650192;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=oKSnt8gA2Fy+R/UYvUgzl3Tn/GEe05bs1oSii6h9IUM=;
	b=3zyeCEz12RT5rNXvYIP8UUhJNbdgXGo/IcXcvI8iygQvu/jz+8k2f/AgUFl60TozIjma
	 YokKZST3YiL+y32W200kvvjHK/Q52z+z9jJrg4r7GBuix+5IN69GUaRqUxGsLh/PSvSOG
	 htR4LaLM9x0CGPCfXTwpm1xyJ3u0jHq2WAgykzA6t/JeQ2HA+IC2IhEi1roi9DgYejIsI
	 aa7SixsDywk6f6NOp1wlfSFgXPCV9+6w3gnfhS4uaCkZrAqjyE7SjVLaCrkJY8ViJQpsM
	 axKSHKOalzyi2+KfmpGc0AOBYbVjIkX+NDGjL1gQ7MHGGC0V1PL4ZkJ5tMu5sfHCWtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=K8ouC93Y;
	arc=none smtp.remote-ip=185.70.43.16
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C21606A31E;
	Wed, 25 Nov 2026 23:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24C21606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=K8ouC93Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795650189; x=1795909389;
	bh=oKSnt8gA2Fy+R/UYvUgzl3Tn/GEe05bs1oSii6h9IUM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=K8ouC93YjiaipkUnZUaf2Z03ICpRfvLmXU+boGZ+n9ypVWaunylwWbhoB0CLGcOSh
	 ukxiXp11zh8cq0D0l3ynNA62BVtt0IAahRLafsPosW9Sj68ArmM3tZdEmvUhVQJkUT
	 TI+YD06KESLqTYrgX6QODxPK8DC6Cw9yaRbwxbJcGMVm9VBm28mC2+598krVb0ncFw
	 omUlKsV/c+6YhAM+v0ci/3i4M5gmK1VgE8ibBe+IpRh4caDpKe2V1SxFFRpyQrf6hx
	 kh8WWXFcPHwhaBdyDCtGs+ysK7tx6JqQtEjBYWiEKHUgKOjnnzHEtIBELlkfwBRXEL
	 q0cFJ6jQAi7Rg==
Date: Wed, 25 Nov 2026 23:42:58 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: qat - fix missing DH public key validation
Message-ID: <20261125234242.1859833-1-rc4d5a@protonmail.com>
In-Reply-To: <20261125231859.1857450-1-rc4d5a@protonmail.com>
References: <20261125231859.1857450-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: d64c2bb74ea5fe9170b588389f55311779cf819f
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

Confirmed -- this is expected, and the fix isn't a code change.

This patch depends on a separately-sent patch, "crypto: dh - add
shared DH public key range check" (Message-ID
<20261125231825.1857253-1-rc4d5a@protonmail.com>), which adds
crypto_dh_pubkey_in_range() to crypto/dh_helper.c and declares it in
dh.h. That patch needs to be applied first; this one was never meant
to build on its own without it, which is exactly the build failure
reported above.

Apologies for not making that dependency something the build tooling
could see -- the commit message notes it in prose, but that doesn't
help an automated check applying this patch in isolation. I'll send
any future multi-patch dependency as a linked series instead.

