Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030D3B0ACA;
	Mon, 27 Apr 2026 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284091; cv=none; b=Ac4jJlw2Jz7gdjx/m4khCZa9H8taumd6MNHhgJ16YQwniWc5MmnkmbjDFKWLJMm2kiNp3CQqsJ0RLCd1OmNNFB7ggbwzfpaywJZFpJq/tkdod12e6ksKV1UbXe86zLgaL7o/Sod70fBOk4/WeucRywSwaxJnObwm/iD/sAFTB+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284091; c=relaxed/simple;
	bh=uzgaBr3/gy0BiPKNuVtfiYRLUSOLMrQVqn3rQh6e1N0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SHF8DiO1r5XdqBoleo8xTPSRJtrx/DEyqXquqX+BLIUaLf5fAOC/TYkx07ooy0hHhxRI+rW3TtAfBqbCkJrjAzlJbqqekRIqkpEHkbhNL3chhozcmjIIBHV5kNd10q5NCojmass/HmQrINpY2gQqYA3OurlIYjnX/cN4ZW7wNfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=LLsoOPsv; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="LLsoOPsv"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3013941098
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1777284089; bh=dAAsHzIohRCs7E69E+rpVjyFTWWgacfSQ85RrgmeH+E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LLsoOPsvrCnkuSUviR1k1Met+YdkgY3i3VllilTFt83TiPNxfl/hm1cK3AaXxco2p
	 VpaLdYfLIJT7u2QZlhJZacI6VTmC+dRsllSEnVoxgur9fcH9TD44R1Eopl7MzAndmK
	 SUCPHaaML58XDaVxNR+e8ApgfjbAW9jzxGV7t9T4/myM8Ss6e4CUPYloZXjisLEwcz
	 8OhHD1n0BFribYfA86Xrtr8Sj4+IzYtsSYgxEfp6tvXGlaHFQwcvjty8/t/RAreg5/
	 BkW11gisduSodNrvweL967k8JMxDGyrRIOKWoh5O97HZFcVr4b0h3UHJQmU6Wm7rK2
	 chE4NwePqEIOg==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3013941098;
	Mon, 27 Apr 2026 10:01:28 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Zhang Xiaolei <zxl434815272@gmail.com>, ebiggers@kernel.org,
 andersson@kernel.org, mathieu.poirier@linaro.org
Cc: ardb@kernel.org, skhan@linuxfoundation.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, Zhang
 Xiaolei <zxl434815272@gmail.com>
Subject: Re: [PATCH] docs: staging: fix various typos and grammar issues
In-Reply-To: <20260416105854.788-1-zxl434815272@gmail.com>
References: <20260416105854.788-1-zxl434815272@gmail.com>
Date: Mon, 27 Apr 2026 04:01:25 -0600
Message-ID: <87jytspvre.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zhang Xiaolei <zxl434815272@gmail.com> writes:

> Fix a few typographical and grammatical issues across several
> staging documentation files to improve readability:
> - crc32.rst: replace "decide in" with "decide on"
> - lzo.rst: replace "independent on" with "independent of"
> - remoteproc.rst: fix word order in dependent clause
> - static-keys.rst: add hyphen to "low-level"
>
> Signed-off-by: Zhang Xiaolei <zxl434815272@gmail.com>
> ---
>  Documentation/staging/crc32.rst       | 2 +-
>  Documentation/staging/lzo.rst         | 2 +-
>  Documentation/staging/remoteproc.rst  | 2 +-
>  Documentation/staging/static-keys.rst | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

jon
