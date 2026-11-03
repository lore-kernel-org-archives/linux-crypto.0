Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793747311;
	b=ZHQ0ipvfOpVW+mhl3QC83G4uduvFtSUuPOOPpqR5J0DVv+b7Xc69UdBqxTRr2rWeUUGu
	 +E7LOIekqVclncgs5IudbqhSJl5KnwCgRr6LR9f+Q84pjQG8leF0p40mCs9dvXdioOD2C
	 3crPgqXsL5mYJUqmoWAN9Zkq+s6Ki4f4aI0g9zN9Rc/QS366mZRa6bgIgUJhDFevJIfZe
	 oJNZxyfvukfLlVBUQSPbRxsKKNATyL2HwNZrc1GY00dj8p9ACCG4xeErkdeTepLNZ+8Kv
	 zvMejHzGJuW3NTHLR25sEItSJzbSNNSskTyhcwLX56DBrUw4DiknTUEOEEfBVDrYiKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793747311;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IGTNflkPv/YNika7vMFmtkUnf7pEAhzj99fogLnfVKI=;
	b=fuJrz3GQPLknUzKuDyEvtfBHK6mRuIP9V/QJfPt1FSCA0E8Tkj0eQW+DkMMbV4B1pq5o
	 tjmOGTyCN5rygISHTkjFBvH72kFJGrpNTfHB2aCRZoMwNKhc2H+REpHxlw4r00P5j/jJa
	 /RqrGIHj903663SN3NewpWjUYAA+HssGj+mrW+EOdSZnYgXPNSeAnnQZXWky+jg3macuV
	 jBt11+abTYS+bOtv1LdFJJNJ7bOrYeaRtn75MbuRsnd+31rkkMjYIgC53wm3cqHESRvcD
	 eCMiFNuz/+dqARVMOs7kRKAmZ48QD8F9C2IB9T+xcHFDw07mcwdDc9rrv9aqQ4pdpdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHRwydEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BE0606A324
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHRwydEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A801F000C1;
	Tue,  3 Nov 2026 23:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793747311;
	bh=IGTNflkPv/YNika7vMFmtkUnf7pEAhzj99fogLnfVKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NHRwydEsM15zNU/VYaENAjZ/lyLTj0LrXuAmDuwGh416t34RD1bTqAzk/96VahA8x
	 SPQimadbVTwtyd+6+7D44i9rSZpT3nPgt+ML1a3Hdd0NBm7beI0ybVWvZE/Pd8Dk1s
	 tzuJUDaEm3MGrNpHtDAjP0G4WlhiJDN6Kp5PpUvvqqUrfXHBBv+q8CtBJuO/VZWNg4
	 ijs1Y36lh12C62v4L5fWEnGLabECHQEMYa3iXmFMST/s9xWF08yZcAyURSKKrpfcIA
	 VKZcuF6eXhiFd7Wpo18+QgdQq1OeT1GZ4wc36uENV+dFVIxpdJv0/8Lrj/EE6k++/M
	 y3PZZ+BA6y4zg==
Date: Tue, 3 Nov 2026 15:08:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Martin Willi <martin@strongswan.org>
Cc: linux-crypto@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH v2 0/3] lib/crypto: x86/chacha: Add a 16-block AVX-512
 function
Message-ID: <20261103230829.GD2281@quark>
References: <20261102113926.2765176-1-martin@strongswan.org>
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
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>

On Mon, Nov 02, 2026 at 12:39:23PM +0100, Martin Willi wrote:
> I don't have a Zen 4, which splits zmm instructions into two 256-bit
> halves, so I can't tell how the 16-block function performs there.
> If anybody has access to one, numbers from there would be great.

chacha_kunit benchmark results from AMD Genoa (Zen 4 server processor):

(I added some extra lengths as well:)

     | Len   | Before    | After     | Improvement |
     +-------+-----------+-----------+-------------+
     | 1     | 6 MB/s    | 6 MB/s    |   0.00%     |
     | 16    | 106 MB/s  | 106 MB/s  |   0.00%     |
     | 64    | 437 MB/s  | 437 MB/s  |   0.00%     |
     | 127   | 1078 MB/s | 1072 MB/s |  -0.56%     |
     | 128   | 1106 MB/s | 1101 MB/s |  -0.45%     |
     | 200   | 1361 MB/s | 1316 MB/s |  -3.31%     |
     | 256   | 1674 MB/s | 1612 MB/s |  -3.70%     |
     | 511   | 2950 MB/s | 2970 MB/s |  +0.68%     |
     | 512   | 3052 MB/s | 2976 MB/s |  -2.49%     |
     | 768   | 2674 MB/s | 3417 MB/s | +27.79%     |
     | 1024  | 3241 MB/s | 4514 MB/s | +39.28%     |
     | 1420  | 3242 MB/s | 3845 MB/s | +18.60%     |
     | 2048  | 3587 MB/s | 4829 MB/s | +34.63%     |
     | 3173  | 3088 MB/s | 4439 MB/s | +43.75%     |
     | 4096  | 3743 MB/s | 5040 MB/s | +34.65%     |
     | 8920  | 3606 MB/s | 4846 MB/s | +34.39%     |
     | 16384 | 3739 MB/s | 5105 MB/s | +36.53%     |

Note that mobile Zen 5 processors have only 256-bit ALUs as well.  There
the results are similar.

It's still worth enabling AVX-512 code like this on these processors.
It's just not quite as helpful as it is on processors with 512-bit ALUs.

- Eric
