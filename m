Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EBB25393E;
	Thu,  2 Jul 2026 00:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952724; cv=none; b=ScLDx/d2vBNmYaUP/qolOj7vUTP3iN8fwhOEhu4udTJ0qJlAwORco0FRYs+jbpXJ1tNUe6QZivQj/tUNyRqszOuWHDIHwZxMhXywNjPppTKXj0g5TxJLIQoDg0fASKsI+8aiBiD7Pg0o0cYm7EsPNcSsM5p/hbPAjcim2xUcmas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952724; c=relaxed/simple;
	bh=jmMbfSqO4cLFbCH/DZL8gp+p4l4LgF7rKkYkTDjefOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrhnpOU2eCsrUL9pZ1D4WGf3PsOBCxKGwQAsAU+vfhWoVVAeMHOdN+l0foseNUvIXDIHf2wqwW6pW2tGw2C60XtPwr5SwmT/YNpQjiyQ75Y404a+kI+JXcPBdLqk/a/wxPXzIXKHwNw9NUdxwu7tdYm0oyry3ApPKQ4JmFR0zFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVeR8/iA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVeR8/iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EB1F000E9;
	Thu,  2 Jul 2026 00:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782952723;
	bh=5Z0A4+GySrF2D2B8jkIYsS1QFz1i0QipJD8gmvXAfWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVeR8/iAnLLveyabREcOJXgbTsERoG/eCYE63tmRBBIIfGnzNXaRbYWkrA6yfVam1
	 1gLg1E9+eXZPMFOePDlfnciajvqyXqR829yQmTHz44P35+bBB0t9a+sLUACtFG0Pei
	 xKoVUHs4Lix0IoHlkEx1+NBehgpOo3x7Cun3HCK7sYcy5W0kzBXmIaTlPdRMjDZMsf
	 +usyT/gWSl/0WTc+RNZUyzuHha5MvIhVuZP3QyG82Fw8R6bPPi5zip81PtvOLxPfoP
	 L589StVxHCGflaVu7mSMvOFHwg4g5XSeye7FRiweNmaFp6VSZXR0LCf8pBHItXLgjZ
	 LBFD6uaAFOkjg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>
Subject: Re: [PATCH 5.10/5.15] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Wed,  1 Jul 2026 20:38:27 -0400
Message-ID: <stable-reply-af-alg-merge-20260701193800@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260701160121.100720-1-mdmitrichenko@astralinux.ru>
References: <20260701160121.100720-1-mdmitrichenko@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> If an error causes af_alg_sendmsg to abort, ctx->merge may contain
> a garbage value from the previous loop.  This may then trigger a
> crash on the next entry into af_alg_sendmsg when it attempts to do
> a merge that can't be done.
>
> Fix this by setting ctx->merge to zero near the start of the loop.

Queued for 5.15.y and 5.10.y, thanks.

-- 
Thanks,
Sasha
