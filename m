Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793613501;
	b=Ra/NfTr9X7IwI5P1GnkHIZCzU14099ETOg4w6UQN1hk4Ii4HdNjVSIAED39245FBaLx1
	 i9QK7LEv5LfBKll27DUJzw64MPwDNcKbwYIeZs14Fj1JaDt0Qhyp8mS3W84XVSwx60WVz
	 dsxNqT0tuo8YK5U9E1EGhpIErb241I8FEXudcofWTYTx00A9IzNaDmhSWOlFN/j5NzXur
	 3vGSn87mnTvJFesHwpaf7cQWdttHzm1WSPIPruzGXXiM6ULNEL4eyZagwDdMYfUA9XbR8
	 y6rL43ZGAPQZiMQ6ShILXP05YLaMhXlY3Y9FSKUDxmxq+1QA9v94g9jKZcir1w5Ordw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793613501;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0tR0C5wrSJK8oL3NG4NwgFXSd1VItIjr967cGvPECk8=;
	b=kL2A5JFG/9ssqyvW60Og5//TzMN0vxA2e4Mfw2pWhVVrDHKvSXTH4g2zW3X/4oGhtIvC
	 9Fw5Pj4joGXLEfEx/UjdPpd/rx/2HvKRXESlFeD8rvRa1CQq7ydTttccFbcN+15MaWVih
	 SWyTKkFRbxfy4JcyipLGhoL9+nRXEQvw5Ohsq7XSv64T1dSoOOoFTrKT/DYtiEupJFGFd
	 xSLFG12zp7P0LPRTfc1dh9xbB1j+1O6E/ajK7ceGmkkuWuhqZ+RPKU3Ato/a5aCyFpC7Q
	 T94S59QzTsc97xTtp8oCU4NmDYAdmN8zMz9bo4oYcfXIbF0pIOf5d2st4Wz5AMRAJbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjVLe1A7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6A2606A327;
	Mon,  2 Nov 2026 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjVLe1A7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D61F000C1;
	Mon,  2 Nov 2026 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793613500;
	bh=0tR0C5wrSJK8oL3NG4NwgFXSd1VItIjr967cGvPECk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PjVLe1A72Lan9Thr7mP0/FCl3sMiK9qhVNV/5ZyXPaBKA0S3mNHvWtbpkh1eSr9kx
	 FV+F3hTy4o8DKlrNBuKmLvpNdrR1YJqyNn8HKalTBmOYmUQqC38jZcvZzBFdW91m9N
	 wa/nWJ2FXpK1Dz6tzQotCzl+qlWLCduThKGq6GGdZNp9Xx0LdCArYW/c9QxlBwxbuG
	 zP+lFp9tYIV4nTwXUpPEzC8H/M8EMQxPfXbpLCW/cChxAbuaIPFO/WBlJg9dMn38zv
	 8ynzj7A3f/mvzea8xe2bcCgva73+PRHjSr5qITJOrN4ZlAkPzy7WLFMGnSVgxYjA2W
	 L+CuNQaMQC4KQ==
Date: Mon, 2 Nov 2026 10:58:12 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Birk Skyum <birk.skyum@pm.me>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v11 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Message-ID: <kh74or65txfcprntqqljabnszooj5ppuwizj35flv2r245zbvo@nfue4wdblicr>
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
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
In-Reply-To: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 10:57:58AM +0200, Bartosz Golaszewski wrote:
> This is the follow-up to the three smaller series fixing crypto
> self-tests in the QCE driver. It makes the crypto algorithms opt-in via
> a module parameter and removes the BROKEN label so that the driver is
> built by default.
> 
> The dependencies are:
> - https://lore.kernel.org/all/20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com/
> - https://lore.kernel.org/all/20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com/
> - https://lore.kernel.org/all/20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com/
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Hi Herbert!

Gentle ping, can these three series + this one now get queued for v7.4?
The three dependencies have no more sashiko comments. The ones for this
one are minor about missing module params docs so can probably be
ignored or I can send a follow up.

Thanks,
Bartosz
