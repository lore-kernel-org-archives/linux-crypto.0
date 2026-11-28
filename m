Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795841526;
	b=YOlmAlehxLLe3AiLRCHg/OMAms+i31w3WwfbpM0aWK48rq81LeOYMfJymlnNUDHhbArA
	 +xx3BaEExgO0+kNqziKV32S/7tybXYe9NNaPQvTY5BRswco0LScouN6uKiJEVhEAkYhyj
	 OfG4Uo7ZkDbxDWQ4RKOeaQDnQCBt4Us4zM0WI0300FdNkIVsHx4rRlp0BGEf+6eHtc3AZ
	 08kMn0OIo451wJ92nIUt86d7j6PJCRcJYbKr5kVsy13z0oyUTvcJys5ukeUk8GNKhFFE8
	 qDo6Qvfya9FkqG3XkUAdzYCX/sr0ef55hByG5aHVP8dFNUSeXWCadbDqQuMKotTCFIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795841526;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xaIOALVdkuy+CxBOHdZYBLQ6WSMeo3etw1WcXYt9n7Q=;
	b=1V64HzkqwxJENlKPt+luAI235kBF71YBC1n/78lSdoHLuWqwHOOu509bOgOnlFeN0rQg
	 pZj2MrolFLqC187MhHc9rPc8EUSkL3deY0zre8+XUcDezz22sjCrAOpqBbtGkN/EBOvma
	 JWNHC8r9qjxJI0DC4HE4sjdtqpbVh6Qj9J2G30SVSTj1HzX9gaEnNCRyCdMGwPM3eaLit
	 pThe+RsBGp6qsZatgVp/p2TwAbirmHwqi7pNsdGocBrlo4SADt5OozSiG3p3wGXioMNPW
	 tAucXZTyPzzt9g60+/w9bCtTk9Di170KNnBRPra8W1kbNFLgstQTA7FIXIeuWEWv8Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N6/mi8Xa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D66606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6/mi8Xa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8991F00897;
	Sat, 28 Nov 2026 04:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795841525;
	bh=xaIOALVdkuy+CxBOHdZYBLQ6WSMeo3etw1WcXYt9n7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N6/mi8XaW+XBo6OLPAQdF3HLzfi2V1I9rQlX71sEpJLX7zmmuMH2pMyg2CIc12/ao
	 yhpsRuPyF6e7hiQ767+XufZ+sO1vGQ5oChhiJpheZlf29IZRxiCGNXagLnZ+HthL6f
	 bQxlpqJILVdw5tiLwyaqxaWQbbnUc8hKLLLJGlgLaiiHCCovPpUQbNdHUixrLc7GQ4
	 huJnS40BzsOtNeO8L3hd2Wsemb9tKku96btiPHe8rNKJnMYrBM/QuUioRa2pS3zWOw
	 nrtSj751M+2fCq/+gy57H/swiQINWI4LZ9X17p4fuiXoCsZoUjwYHbqQmVelibZ+Gx
	 6/F/ofSmttchw==
Message-ID: <sashiko-outbox-238462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] crypto: cesa - finish the HMAC outer hash when
 padding by hand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rosen Penev" <rosenp@gmail.com>, linux-crypto@vger.kernel.org, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: "Srujana Challa" <schalla@marvell.com>, "Bharat Bhushan" <bbhushan2@marvell.com>, "David
 S. Miller" <davem@davemloft.net>, "Arnaud Ebalard" <arno@natisbad.org>, "Boris
 Brezillon" <bbrezillon@kernel.org>, "Russell King" <rmk+kernel@arm.linux.org.uk>, "Romain
 Perier" <romain.perier@free-electrons.com>
In-Reply-To: <20261128044050.722617-5-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
 <20261128044050.722617-5-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 04:52:04 +0000
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
- [Low] crypto: cesa - Fixes trailer cites TDMA commit instead of
  f63601fd616a
--

commit 1b090efdccb0bcfaec213f4a5b0122cbc6cbc29d
Author: Rosen Penev <rosenp@gmail.com>

> crypto: cesa - finish the HMAC outer hash when padding by hand
>
> The engine applies the HMAC outer hash only when it finalises the
> message itself, i.e. on a last or unfragmented operation that has data
> and whose total length fits the descriptor field (0xffff). Otherwise
> the driver pads the message by hand and runs the padding as a middle
> fragment, which leaves the engine with a plain inner hash state. For
> HMAC that is wrong twice over:
>
>  - the padding encodes the message length only, while the inner hash
>    also covers the ipad block, and
>  - the outer hash is never computed, so the result read back from the
>    IVDIG registers is H(ipad || m) instead of HMAC(k, m).
>
> This hits every HMAC whose last request has no data left to hash, i.e.
> any update()/final() sequence over a block-aligned length and any
> finup() or digest() of an empty message, and every HMAC of 64 KiB or
> more.
>
> Count the ipad block in the manual padding of HMAC requests, and when
> the result comes from the IVDIG registers on the last request of an
> HMAC, finish the outer hash in software: import the opad state computed
> at setkey time into a software hash, with one block already counted,
> and hash the inner digest. Each HMAC transform allocates that software
> hash at cra_init(). Select the software hashes so they are always
> available.
>
> Verified on an Armada 385 (WRT3200ACM) against the software HMACs,
> single threaded with random lengths and update splits: about 0.5% of
> HMAC-SHA1 and HMAC-SHA256 digests were wrong before, all of them with a
> block-aligned total length, and none of about 195000 after, nor of
> 30000 more with lengths up to 140000 bytes. HMAC-MD5 was not tested:
> the test kernel has no software MD5.
>
> Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

[Severity: Low]
Should the Fixes tag reference f63601fd616a ("crypto: marvell/cesa - add a
new driver for Marvell's CESA") instead?  mv_cesa_ahash_pad_req(), the
manual padding fallback in mv_cesa_ahash_std_step(), and the CESA_IVDIG
result readback for HMAC were all introduced in that initial driver commit
rather than in db509a45339f ("crypto: marvell/cesa - add TDMA support").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128044050.7226=
17-1-rosenp@gmail.com?part=3D4
