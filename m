Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18383A1A22;
	Sun, 19 Jul 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473256; cv=none; b=ozkx14s8l1EMSui2eKXFxwjO/KNh7mBAPQsujGds2MCE88O10jKF4S6BoKQYXvzrzeulUarFSamhTYtfOW22iVAAByZxhz3HsU4kh1rmmMkgmdUXhXFE02B10GiI9sIFB0rgCnE7FAZ1qr2zP69Ij34di9ChxE0ivzLIHB0zr+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473256; c=relaxed/simple;
	bh=+Bv6csjvuLizE4Qj+tcIYMmmb5Spx4APeaCNohdQX9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFa5JRP8i3VQft6vh/3pwRzjTosNFx0I/unvQo5fcKEPUEdWqtPcrbAhZOjMUYzCZjfsCg/705Y2QxNj6TRS4ey/6MbESocVKhz098pkb3PleUvGrWrMBKem/3AZKU58jkDa6PH1QaFDv77A5tLo5RUgyqfH5ijn+7Q3dK0GQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmLFlO9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmLFlO9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80EA1F000E9;
	Sun, 19 Jul 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473255;
	bh=9B51VJf6mVz7q3RgWaCRf1miC8GHsslFmxVsNvLHBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmLFlO9pLqWO/28xBh28XnEGiBPYtzVRhPL8vXhonYh9G/LvXlLEjykOSnbdtAMdH
	 Dpllwid5F1Q7kpgh52TtetxCYxVcZ49DmaGf+mwvVv1UHqCkKBRxuAtMz+teCiu4zr
	 D74kuYQg0Iqm1CoqF8dcA7QTaHLFiDXVWXci64W4mA5P/aEaAFkgWeYP6qG9709wq/
	 yLT8RJZ94VkeXSPVXh7saeO4Qil3eCWFkVIaU08nwp5FEEan1ToyYVpJgPW2/qS1hc
	 +tl9WEnVbenZqgRpJd86Dqg1xL5Pvls7eG9rkJg8QRaoZSsVB6Yd3Tl0rFuH8zlqWo
	 yASTJsfRwX+dw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	Weili Qian <qianweili@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12] crypto: hisi-trng - Remove crypto_rng interface
Date: Sun, 19 Jul 2026 11:00:28 -0400
Message-ID: <20260718192718.0014-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717033907.295395-1-ebiggers@kernel.org>
References: <20260717033907.295395-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> drivers/crypto/hisilicon/trng/trng.c exposes the same hardware through
> two completely separate interfaces, crypto_rng and hwrng.  However, the
> implementation of this is buggy because it permits generation operations
> from these interfaces to run concurrently with each other, accessing the
> same registers.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha
