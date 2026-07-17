Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEE22F8EAF;
	Fri, 17 Jul 2026 01:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784252282; cv=none; b=AjkD2yka7mtthgrIOg4pfbHbGGoyxzWK3OSaNC85jPpkf1pC52HOEq6B8Xh2Ci95gGiG6pu5J43skZq2MuFkfid9cJIlAuL/gmEgMVw8e4Ju01mse8jqsYWUouOdPUxZe777cHsrldvvrmDACXXVSmFh1tedKnAAb8DqqQXN7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784252282; c=relaxed/simple;
	bh=fgfs3864U4h07+DPuTdtvk9MMLTqND2m96YHsi2iguE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lIAz4FrtIQpOhdFlc2Q5QTsemVNbD5qt/JBhB2kyx3ZkgiQOC0REKVA8n8KrlPdX1p2xSF5W4hP1faIePwK/rv0ruwbNLWFc/48YbqT50Tq8nl2NtbybL8OnvshLpYvBXfR71fNYlIJ3Jn688piEo9yEUyq2rICIVkSI+Hs1qew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI2u9vuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI2u9vuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9591F000E9;
	Fri, 17 Jul 2026 01:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784252280;
	bh=ZXyerKeZ1u8jCiSEP53+blEh6jD0vsi+sYETX4wOML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eI2u9vuRSYeqp86CVpAsvLX8YopAwvm43D1TBqj2UsYwkHuoQ17tbR9vTgpg9vvQA
	 CTu+UPDl4fUpufvX9d1lQZvzjoh5ydzxN2l6LZzL7KxnQTVmqvB1gu6M+UpzrcuwDE
	 Tifh19+TB9K5vBVSs3kiRubPSpcccjRgoSgtu1l+QAU3zuLGyBcqyg/gCcArXXDTIQ
	 ZGokH5UtrRVQ1zEXnvx62iVBIkPyUNSoIPGD/6i30Pl70CscHfNMFzA/iPKE5yPTeG
	 /nD8stwKxi/cwc9k/ubtw36Fe3d23XdAfQ58giODrw5UeZlF7RVQGsT24jQWrwMa5h
	 AjK4Ty5xTLe5A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: Re: [PATCH v3 0/2] crypto: algif_skcipher - fix AIO IV race in stable trees
Date: Thu, 16 Jul 2026 21:37:38 -0400
Message-ID: <20260716232340.0014-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716025838.2672-1-muhammetkaankilinc@gmail.com>
References: <20260716025838.2672-1-muhammetkaankilinc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Jul 16, 2026 at 02:58:35AM +0000, Muhammet Kaan KILINÇ wrote:
> Both patches fix this the same way: force the operation synchronous, so
> ctx->iv is only ever dereferenced under the socket lock held by
> recvmsg(). They are split only because the surrounding code differs
> between trees, not because the approach differs.

Queued patch 1 for 7.1, 6.18, and 6.12, and patch 2 for 6.6, 6.1,
5.15, and 5.10, thanks.

-- 
Thanks,
Sasha
