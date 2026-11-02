Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793582583;
	b=GV/uXFxioa7xkLoT/G6dDc6nPMHRrut7ig7FD1atCLNcm0MBQy7GJ7cHwBEVrMjL9PCF
	 X9Xmv1gZUAUer1iXKhoIFvBYtwCMry6EWjGKUjrcH7KhjM/tPlERdshB/GGq6qR5nSDMz
	 9PYq9AtClzNBXDYOMznTsBykpKQNgUEg90omDU6xA6zee9KfALQTe9VfytFQOLDv03s0w
	 LES0wmn9hEPjofttDO1mLndS0XWk5HQ5tT1HwPHu6tOt3z65UKajooLhZv+vrgn3JFiPF
	 9wSUem9XMGKyNC8WHOte0K7j9iU8AaTec8nD4QMhE7eDdbNJdD7ioFmK/RsFlBNB4mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793582583;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6vkcbO3vU90BX7fhYTtlK6Zz0qwp7+sMSXT/zTqq1BU=;
	b=XqxuHkufHDLzdc2KYfRAP+2AkW4g6l/YpwQGDt6t7upLas5buljvWzsyfAUu9Wm5XhuO
	 0fXQfe9dlD+/Vyzwd2HK/U2vR+oGEbP7r1R0fk0mqkM8cO0ld5wGwRnRHDBN85O2r/lq5
	 EPuJgCLC8cE5cBj+7ZBYez3F4ofW0Y35DJHJgMfnIlvjmgBAhgtNK8U3NSupMbLSJ4Frp
	 nHIm6NYCjdZ4MfXifq9USoWoM8AXD+UJZKpybBrTJ6n9R8hcq0DxnMwSvqdSZvkAQumrt
	 779UYse74kBNLAZAfM76OjDTgqL+n/MQ29j72yBE01qHQN60aT1ZgBsCq9AqixifX7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbE2Puw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C4F606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbE2Puw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1196F1F000C1;
	Mon,  2 Nov 2026 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793582583;
	bh=6vkcbO3vU90BX7fhYTtlK6Zz0qwp7+sMSXT/zTqq1BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gbE2Puw4nLZ4lmz0Sq7bLEk3hNB+dJG3oXYR1tm89wIhBrULa4mzE9Q8cDG+9powr
	 4r183/34l8aVlGDUWLzfoLL4UiYnQMmfI2mDnprmdT24JakyxUM2FNMdJ7xsFD/obz
	 C50unzgUyCyjYZ8vZC9wel/G/keK5jD1fypIKLzMDBpsOsEtPgPIPkB9UxkwxUwLMY
	 hi2c8WQTQHrSMBcGZ8ePRqTSIbPRw3UNjHIzCZ1ugMtee7QyISYrehL2R14gXImgi1
	 E+ieMh6n/I1GGwp+B499NyVMWpCewRr35v+8fugCsoymK13pjQKEzijpda68f1tAzl
	 XJUVVvfoyEHag==
Date: Sun, 1 Nov 2026 17:23:01 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/14] crypto: Remove the unnecessary crypto_rng API
Message-ID: <20261102012301.GA4764@sol>
References: <20261018204618.104876-1-ebiggers@kernel.org>
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
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>

On Sun, Oct 18, 2026 at 01:46:04PM -0700, Eric Biggers wrote:
> This series applies to cryptodev/master commit 666d66df25253

Now that the merge window is over, it still applies to mainline
(v7.4-rc1).  So I assume there's no need to resend this.

- Eric
