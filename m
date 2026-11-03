Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748529;
	b=ihR0BR3MnIpHefJrOYfIoJg9BzQfi9sEGnvAkyBl5TynWlhFZZilLh4ucwSTxqhPHo5X
	 Pd1rZQffgBMECyVH9n18KQ5cGxqMXDDURfQd8rTSVIaRAMJb0Mk2e6xws0KcwFzAhsts1
	 s1SakIGa0w0PFmsUApeNnlrFLzrIHR6c78nQPR7Ey/6aSQI4TiI/nRFzvAKUeGE2GYsur
	 +pH4vmxP+9eCUb0N3J0q7cIKtxeKEvRSJM20lPGCD/HJIO7ibotM4Q9uvnF8Mce0XYO73
	 X1al0l7XP9iByKDE7QgNHmm+368XcCzw12f1dnHbBlswAl5vKNMj0e3RXtSNTVnJjwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748529;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=j7CvH1cUmFqtnjFVJZ7kRAIpHWIOhvJ6lWGtaOF4Z7I=;
	b=viX3BElJWWIrksBaLfWHBWdQ4HYt7GLVlCbUdOMDi68H02nnHvo5R/SGi+gB4kPRYz26
	 ACoMcUSUNxGyFWj38tDFOmq4D1sqRvC248yvwdQVDcrfa5dbx3btxpnufrxLsHtgEb0PQ
	 y/JO/gJIxJ8CtdC6ziozqN3D/+s2LgyJ+AECgGHpxBBA5r2Wqju2/Kg4HqLFkjR2Drtds
	 7lP4iGddOOWNMReCkfgGpe7ScsZnBXnp4Y5PbXHMHN9cVTsseiGyqVGqVUsPzzRk/9e3d
	 NDgyeBil2b2e6yxD0sM7Pvtr+xBBoroVhF1NkgkfTFXUV21TOHxva5fGYImsh3g7XRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IF4tZLvN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560C7606A31B;
	Tue,  3 Nov 2026 23:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IF4tZLvN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876C41F000C1;
	Tue,  3 Nov 2026 23:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748528;
	bh=j7CvH1cUmFqtnjFVJZ7kRAIpHWIOhvJ6lWGtaOF4Z7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IF4tZLvNYCyEmi6//YgxHFpHFBW1MnhqEtb4016oJ0ZdmOI6C+zJdN+bo+6/M1emN
	 UMO5TadDhzWDWW/nrOzOzQIQ0HbXmHb2TVPSYk8X8l3x8DA70P+FeFU/ov3p1lIFPG
	 16w4dUlMrL8GMIz2JpDoINE0Gc6GE83bwdIWhw6CyzpE3vHLUJcy5q2cZc/Jamv5/Q
	 PxX/U99sTiKbrFvPJlV/8EyRT5eH612Wa2vD4m9wHgzCQTuYj0btWW/GeEMvWdkfNj
	 6j02Jo0AD8k9l1cHjGr8mIO/D2evLR0rhTOSVUUeN1DXWGB6js7HlgXLUE8qPVWpH8
	 FSqhf4RYuQ1Gg==
Date: Tue, 3 Nov 2026 15:28:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/crypto: tests: Add KUnit tests and benchmark for
 ChaCha
Message-ID: <20261103232846.GK2281@quark>
References: <20261025234758.3219829-1-antonio@mandelbit.com>
 <20261025234758.3219829-2-antonio@mandelbit.com>
 <20261027015313.GD2395@quark>
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
In-Reply-To: <20261027015313.GD2395@quark>

On Mon, Oct 26, 2026 at 06:53:13PM -0700, Eric Biggers wrote:
> On Mon, Oct 26, 2026 at 12:47:54AM +0100, Antonio Quartulli wrote:
> > +	for (size_t i = 0; i < 10000000; i += max_len)
> > +		chacha_crypt(&st, data, data, max_len, 20);
> 
> The calls to chacha_crypt() with constant 20 argument should be
> chacha20_crypt().  Mainly so that if people copy-and-paste this outside
> of test code, they use the right one.
> 
> Otherwise this test looks fine.  I'll apply it once the merge window
> closes.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

I replaced the instances of chacha_crypt(..., 20) with chacha20_crypt().

- Eric
