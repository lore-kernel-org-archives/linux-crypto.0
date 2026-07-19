Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C143A1687;
	Sun, 19 Jul 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473255; cv=none; b=mA53cjDjv4HSLy1HE9x6dCuAPIm5LBLhKZNvyGCz6ssD9Lt4kTQ+wEJL7W1QqHrdVUM08+CegNtTxzJGYmv4Ff0+bNRB1ywQmrk+5DXnN7+dXGPqSNRUOIi3tCJkuX2zyPG2E1grMn0mv4sa8F55rBG77E2zVmTZbcqSe0df5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473255; c=relaxed/simple;
	bh=XQfFFzYGwY1IZGIGHaqgkBidEFYaZotWE/QhXzi+7kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swZ3fH1zPbijsJBT0FHXVnmCATv2tFwuyMMLW4sLBmmOAiIVhyqz+sxMvjznM05tcmEIo+yAMmHYThlFn2A5PzxTgQ5ODTjZ09Wx+R3vVgIhxsn08ZoA/dNh8xkhoO/G6+CZaYtpvBmnJTkuZrqMIS6+OwIf8804nxjJtBUiVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQQUn7kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQQUn7kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82DE1F00A3E;
	Sun, 19 Jul 2026 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473254;
	bh=fpJT/bTEOlfGEkxSCq/5SUJIZspWJwTzJ8W2EvzKwwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQQUn7kxzdndCRiitcdSjUCCozi27jGtgdMKXlomk44GEN+CCwa4Vse5roqD83WUa
	 +Q0ZQG9IU9/LCJD6LyEgLDU91VspdXZ56A/69JPjXtM6BSQdXdQ5B2hYvcPjY6MVaw
	 boHceR0u2GQ9qyd+dTfdT6vmFwmq5j1rQVjdST0iwpyfJ9DFhicRiK8qw+uyywAlrI
	 vJ7OnVMZu4gikWgDLLLScZPD+wT7qoSlwXaUN5Ise4YwCYek04ys/SXQzvHqA34cjF
	 OH2ZHlTyolWVlzPLicz5XZx/+akQs7eD2w2fLnAi8NnSuZsAl0nQ++8V1nMt1DoT92
	 r0rwHtbTU/D5Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Taeyang Lee <0wn@theori.io>,
	Feng Ning <feng@innora.ai>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.1] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Sun, 19 Jul 2026 11:00:27 -0400
Message-ID: <20260718192718.0013-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717033312.285557-1-ebiggers@kernel.org>
References: <20260717033312.285557-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The zero-copy support is one of the riskiest aspects of AF_ALG.  It
> allows userspace to request cryptographic operations directly on
> pagecache pages of files like the 'su' binary.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
