Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672798;
	b=om/wYybC4TYJlcX7CTzW2yuXoCS0f7nAPXktU/voOfw/O9oI3Jm57dUiNXZKLQoG3f/k
	 vv7+fFBi5fKvsmA05oRUNo0XeCBtAdgxpmyW2PsTP6KaySCir5Ojohm1DGi/CyhLa1zr+
	 6EgzxAemLopRy2pC/H91WMSQ3bnYk788IVA4F3lyXk9QFhazYGIY0jO///h4aa3WT6TM9
	 s3hmSEDLl40mL0ohLJU0uOP9IG8MIJ8knC9xmiZjdr+JsP2hd4GTnv3kg6gP8BGxIJ1LW
	 ASgbxOoIQ3Sa9IwLspi6dgCIwA08lcHxUoOo2y/OehYB+SyJLRVtMbQDqdQndxobJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672798;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TxJL+on+PkOhrku4jezl6ZOpfoxKuEgYNetn1MwOTbk=;
	b=O47TM5uY8dc8Cict4nMVNm7U8qwqNhkSQURfGpQZZsFnkqMxpuOo2xhUPDrArL++eap+
	 M7nHGjNjKZiFR0arX/l1ZENCh8CZ9v4FAcskxuICteETm2GHTR90cFyH5iaR1jORBPGj6
	 0wwHHr5zR2ct1gQWpqiKp3AZZJ5d/4FlW1xHLGPOcbpaUw048zkzaquykzC/wSXBepf1Q
	 xaS7aUnGWmpV7XeKY9XNK04dgkA4IaLGODObPnO2b3I5m4m6VkudedC3qc9fLjViZNwr0
	 nzHvNpmT9QmFWwdyyC9g1EqXqboQlHwqetYTGSck4uOnkqVwVAhCFWv8BX5ANH4rcAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MqB/r4Tk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55E1606A32C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 05:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqB/r4Tk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CF01F000D0;
	Thu, 26 Nov 2026 05:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795672798;
	bh=TxJL+on+PkOhrku4jezl6ZOpfoxKuEgYNetn1MwOTbk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MqB/r4TkHsJj9Wr2GuUlZwtfzXREGYU1OHNpgZ52Hk/vSArDoO16Zpj3hIL9skqOX
	 fIqVGePnNjEsC1AanjXK4OLIzQoFb4Q5t4Tgv/4tquTU/UrT9OMkh5X5Ii4sIhcOWt
	 H1V8Ktfe/ucf/EBWpkzfb2n9O8yGSk0vIVnOgWmCp2qbULhsHlrKw0Gb/N5Nn+tqP1
	 RawmVh4b+fZcGp826YTAbW55muQuYx/jqIo8fGVxZrWcYLRbF/+WzTaT8aRUEloLkb
	 w8NuKRkmCJgcoJGugLoCsSKvrLa3fc5gXxj8ked4Z8GN6ydYWahrY6xAg/LEqRTLtt
	 Ov9Og8idUyheg==
Message-ID: <sashiko-outbox-234814@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: tcrypt: avoid 32-bit overflow in throughput
 calculation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Novak" <artem122novak@gmail.com>, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: anirudh.venkataramanan@intel.com, mark.d.rustad@intel.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261126055600.23172-1-artem122novak@gmail.com>
References: <20261126055600.23172-1-artem122novak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 05:59:57 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] crypto: tcrypt: inaccurate Fixes trailers for 32-bit throughput
  overflow
--

commit 511920037074a37ed1b8de2506cd7025bc33e2ab
Author: Artem Novak <artem122novak@gmail.com>

> crypto: tcrypt: avoid 32-bit overflow in throughput calculation
>
> Cast bcount to u64 before multiplying by blen to prevent 32-bit
> overflow when calculating throughput on 32-bit architectures.
>
> Fixes: fdaeb224e2bf ("crypto: tcrypt - Use pr_cont to print test results")
> Fixes: 3e3dc25fe7d5 ("crypto: Resolve shadow warnings")
>
> Signed-off-by: Artem Novak <artem122novak@gmail.com>

[Severity: Low]
Are these Fixes: tags pointing to the right commit?  fdaeb224e2bf ("crypto:
tcrypt - Use pr_cont to print test results") only converted printk() to
pr_cont(), and 3e3dc25fe7d5 ("crypto: Resolve shadow warnings") only
renamed sec to secs.  Both test_ahash_jiffies_digest() and
test_ahash_jiffies() along with their ((long)bcount * blen) / sec
throughput calculations were introduced by:

  Fixes: beb63da739f7 ("crypto: tcrypt - Add speed tests for async hashing")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126055600.2317=
2-1-artem122novak@gmail.com?part=3D1
