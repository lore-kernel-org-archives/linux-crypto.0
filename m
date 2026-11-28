Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795829321;
	b=I0Q8Mpq7CPR/WZn263+vFLG7HrH8i8StF8U38YdSLuHjHDgmqYYCF0qCB17SCAxzZCwE
	 XZMyFG7vp95W8Vc3J6XEOZ5ysqkePxfOCNa0Tii/NS1fYvR4pGS7J0F8YMpiZQUMuG2yL
	 qHdp6/plW4xstznHr/2bID5/82ns/Mw5fsPJ3bMGRhx7goRHllOo8W4W+8XbCBQd5FYb2
	 gfZWPwISBAa8VBXWH09wlzJameHJL2cmFDtkkGOfMrqaLHK5axHdsynoOYhKkrMlI+GmY
	 lBzWUipTeabxuro42CfR6mo7Vjba/RWklCr5E5TdKBKuCj08GdRkcRL94WvK//PEK+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795829321;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IMHvjFB6PWzJhAbDoR5X+YeuFYh6UVZse7iHnSalLu0=;
	b=E+1m3vV/eeGd0eK0Nf7TE6U7PZgk6g0bc4YefH/hE5pV5o27kXecmWJTfhisDwG8JzGb
	 jKllnBzAf9IpQz/1iOGIKFTYZ6lCax1vlJbjtedVgz88dgZ5jS/WQEpOeAleb823V7Q1e
	 7vv561ntetoSTjavKdqXwlb4ZO8svmRp/Mgr+7WFZiJl+RBHKIKKEmRid1Q6PA4u8ywoT
	 8kfg14CKJeUecUE1IhjBU5nSYDVRj47WWol/PQgt5fnILogE7B2x9R3jH2cNANCzRU87I
	 dlX4TGkYgI1NPRvXPDn2wMGMvvHJ/wBLQ29eSqLKy2b2E9YejsWDNRlztgAKHowbrng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWjgwx4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C0D606A31C;
	Sat, 28 Nov 2026 01:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWjgwx4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A01F00897;
	Sat, 28 Nov 2026 01:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795829321;
	bh=IMHvjFB6PWzJhAbDoR5X+YeuFYh6UVZse7iHnSalLu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WWjgwx4q6J7XqwSIbHznU9agsouJgr4yotN9beXychXtM+3XesRVfgKN4Cq3/0s5x
	 rIiVBexU3lUoXzppdWwzqHAGbupSPJxJHdh6ny3BPQrwBR/M0BagWec2Xt5HfQRNqB
	 h2xmhHbIX9iksx9QKVOma0UhHS9uV3WwM6eRH6nbmLR6oqSuEp3kQQv1XjNSs9dfem
	 0B0sfIivCCekF+H5qIR0xrxkWeAozUk5o+Ed2XL1/tIcOKHFK/K6O6J3Y4ON3KBK7/
	 tgq4vLgaXQHQmA57r67LA0aj3sNA34e7P5IUu3XHfFSx9MV0wiMRc5N/YG6aLEtFHI
	 MDQXGPQRQJoZA==
Date: Sat, 28 Nov 2026 02:28:36 +0100
From: Thorsten Blum <blum@kernel.org>
To: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - fix missing ECDH public key
 validation
Message-ID: <awouRON5Mgq6pbhf@kernel.org>
References: <20261125231745.1857056-1-rc4d5a@protonmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125231745.1857056-1-rc4d5a@protonmail.com>

Hi Ryan,

Thanks for the patch.

Please shorten the commit message substantially and focus on the missing
software validation and how this patch adds it.

On Wed, Nov 25, 2026 at 11:18:08PM +0000, Ryan Prinz wrote:
> atmel_ecdh_compute_shared_secret() passes the peer's ECDH public point
> into the ATECC508A/608A/608B secure element over I2C without checking
> it first. The only check on req->src is on length
> (req->src_len != ATMEL_ECC_PUBKEY_SIZE); the coordinates themselves are
> never validated before atmel_i2c_init_ecdh_cmd() hands them to the
> device.
> 
> crypto/ecc.c's ecc_is_pubkey_valid_partial() is the generic software
> check for this operation: it rejects a point that is zero, out of
> range, or not on the curve. crypto/ecdh.c's compute_shared_secret()
> calls it before computing the shared secret. This driver's hardware
> path has no equivalent check.

The function is ecdh_compute_value(). Validation then happens in
crypto_ecdh_shared_secret().

> Both the generic implementation and this driver register under the
> same crypto_kpp name, "ecdh-nist-p256". This driver registers at
> cra_priority 300 (ATMEL_ECC_PRIORITY) versus the generic
> implementation's 100, so any caller requesting "ecdh-nist-p256" gets
> this unvalidated path whenever an Atmel/Microchip ECC device is bound.
> 
> net/bluetooth/smp.c allocates "ecdh-nist-p256" for LE Secure
> Connections pairing and performs no validation of the remote device's
> public key itself; it relies on the crypto_kpp backend
> (net/bluetooth/ecdh_helper.c's compute_ecdh_secret() converts the
> wire-format coordinates to the big-endian layout this backend expects,
> but does not check their validity). Unlike this driver's HPRE
> counterpart, nothing else in that path currently blocks the call from
> reaching the unvalidated code: on a device with an Atmel/Microchip
> secure element bound as its ECDH backend, a BLE peer can send an
> invalid public key during pairing and force the resulting DHKey to
> one of a small number of predictable values in a single pairing
> attempt.

Please drop this claim unless supported by testing or documentation.

Also, wolfSSL's public-key validation code [1] assumes that the devices
validate keys internally:

  /* consider key check success on HW crypto
   * ex: ATECC508/608A, CryptoCell and Silabs which validate the key
   * internally
   */

Thanks,
Thorsten

[1] https://github.com/wolfSSL/wolfssl/blob/master/wolfcrypt/src/ecc.c#L12012-L12015
