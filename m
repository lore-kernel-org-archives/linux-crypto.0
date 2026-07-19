Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EA3A2E2E;
	Sun, 19 Jul 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473244; cv=none; b=ceDozt+NxCzxwPObyvRuLNvOyFXCTbvPa5b19WW+QI9X/AKnEaDL7HeRVSLRm+31k8rFjvlUHG72qpSbfpI8V9Ra1umaB4q6tn8QezJrE6fboBIfIAymrmXDHGyNvyYuwLNcZZ4/V88Ozy/WRSnQ6Ar2okPULzh4XnKXg/ju21o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473244; c=relaxed/simple;
	bh=o9gfjiSzj2tFJO1JDqZeKy2NHvIvhuopTYrqY9Liv3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwhL71kVxCtZUK4h1d0EBzIDmp8eXA/xB7gVQ/AI0noGxvYpNQfP9JN+dJeT3A+mKjOC4TTd5DYxFzWmjWuo0VgeWt5iNTqPAcJRwQLqcImZZ25193Y/j08O+JhcUIWSC9XyzLbI2Al9obmHA2xRDqQgfXSw83ECwEI81Vc7M8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6OCcGSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6OCcGSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6131F00A3A;
	Sun, 19 Jul 2026 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473243;
	bh=2NGL4urEv/CKlHQgUzWLHTtkqLj5eU+jSVh3wpzi0+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6OCcGSsuzahU5u4qjRyxkDneba0kBIKytwju9mgNNXwinFmbu0T9NfvRmEn3labx
	 JbL6a/7cGWjVeme3DIn8WvZuXTA3bD3j4AOH7TcFemCnYT98IBvYGXChSS4VWEsrxG
	 +rQDvHFi2eJCQU2XJIINOGQ3pKOBxtLslMJ4m3GwYm2vFTaa5YrkQMnqf/HDAK1rgL
	 pFS844QPq3VjY5ciifr9euorwP0iUXfe1lmub6/c3T4OHoS8QvFUF4g6B+V12tVmr/
	 k8P6c+sOmnFLooNWWLDocx5b4aWm9MVons7zO/UtAiD06l/NLmNOCIxr2pOv9W9prZ
	 Lkfqx3MZTrt/Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Tianchu Chen <flynnnchen@tencent.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 7.1,6.18,6.12,6.6,6.1] crypto: sun4i-ss - Remove insecure and unused rng_alg
Date: Sun, 19 Jul 2026 11:00:17 -0400
Message-ID: <20260718192718.0003-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717035058.352737-1-ebiggers@kernel.org>
References: <20260717035058.352737-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Remove sun4i_ss_rng, as it is insecure and unused:
>
> - It has multiple vulnerabilities.  sun4i_ss_prng_seed() is missing
>   locking and has a buffer overflow.

Queued for 7.1, 6.18, 6.12, 6.6, and 6.1, thanks.

-- 
Thanks,
Sasha
