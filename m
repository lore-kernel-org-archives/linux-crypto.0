Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0212D77E6;
	Mon,  6 Jul 2026 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346909; cv=none; b=MlM4daIFyR4pDUB3th9+ggVw7D6bWuK43NUW8YDSEGNL+/I7tp08y6MgSDf8aUgH1UYO1CzjmvDV3AUj02KYPNPUY00bs2QpPtxTF9GTznXb6Rqsc5mObaZDK0C0lX8T9W0LEXC4bzgslwnZnjhftRDyjhBAYCt99fvjZLy4QQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346909; c=relaxed/simple;
	bh=SM4aWnbm7RsBfUwHz6vkiJ21lXQjcH2nKP3T3yF3HCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl3mQ83Pc0lkN5XiqFbyh8h0GoG3wZJ/DGoj4dl+Xeu8ENNx55WaTNorAIziqx3u3XiLRPnJ0neJsuiRkQ9FQfBlw5VLLPmF51lIsfbGcY44FmEWcfBg8xBXqM0ZOlIeHF0VINoXfD3g0dEAWUGTY6tO9eTTy3qDRhhLve1G/bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFIKU4G0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFIKU4G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4181F00A3E;
	Mon,  6 Jul 2026 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346908;
	bh=qlQb0PVUO5Hol2XhPhJ6eJkBVD7VOzhKz+sg8TsSkYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFIKU4G0ct+RqVtLn60yA1VfUq22NK9QdQh4CJohZkvq0mbWDGf9WZcRJiYrlRCjf
	 TUWCYDc/axHQ/jWayzDo08OLUtbCg+oDf/uJguTkj/PaU7/1Ni5d5AiPs4wG6pP2pe
	 ZGYaUfAITvNah9ERPm67bisR8tfaTs2dDd8Dn8gIMH5DBy3Ty/TVRBC9f/gD1MIULY
	 srZYUknFpOOm1Ronq19K4OkJjg12BIinNYDC3BY8GJSet+TCoJZ+ngkQLz0isrHDIH
	 qeW4dDK3j/s/VBqi3dpvNByIpteAhJ8RdxSmEdsKrVYatCRF8KFzqFtgrWiMH7TIDi
	 dRnPfQ75GGurw==
From: Sasha Levin <sashal@kernel.org>
To: herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: Re: [PATCH 1/2] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Mon,  6 Jul 2026 10:08:19 -0400
Message-ID: <20260706135124.draft-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260705220112.2522-2-muhammetkaankilinc@gmail.com>
References: <20260705220112.2522-2-muhammetkaankilinc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The AIO/async path in skcipher_recvmsg() passes the socket-wide
> ctx->iv directly into the skcipher request. After io_submit() the
> socket lock is dropped and the request is processed asynchronously
> by a worker (e.g. cryptd), which dereferences ctx->iv only later.

The race looks real, but the snapshot here is taken for synchronous
requests too, and the updated IV is never written back to ctx->iv.
That breaks implicit IV chaining across MSG_MORE fragments and
back-to-back operations for cbc/ctr on a path that has no race to
begin with.

-- 
Thanks,
Sasha
