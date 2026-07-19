Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E0639B94F;
	Sun, 19 Jul 2026 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473254; cv=none; b=ItnwEKCN/mo2PtWmUv1W0rwp683jgsl2X5DY46cVg3gH5214FzL6VvdAoLiuJAHxg1P6QhDnuBvuz/dWgC6a2fFtwMUZ/gGuSZxkvQMVHOKnYXjxhOEClIfH9v16FrYdGuyHrNRgTdFq/O/o7xCimRHRZUmU24uiA/Tf14y5WLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473254; c=relaxed/simple;
	bh=CE+hlMiWf+70H4F/wjibMWFJIsOyH+fAPj3UBzsHglQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfiAbgQe8POGBz4pbNGRjGjmyU2gi9/mzv46PYanmAywQQgsdOt58gQaRRMjtH9zm5hmIxWoZUyDLgCa7gWTTeTDKcyv9wSKX4D7De4QZUaRxRygYTHk5V6yV8PrhA2cYhiL7AWyN9z0TmmKgidgsuM+hFS3PVSiwuO7VSEC/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIHEd9IN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIHEd9IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4ED1F00A3D;
	Sun, 19 Jul 2026 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473253;
	bh=mn0k2TSUn83pzMiALXEBMWKjggEwBzkYro9YRz50NZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIHEd9INtriy9gXFOx8CW8pmUw1K+wLo7G5tTfdHGHiNzFY/utvLJthdjb4MR7P2r
	 tuyZPODoSaDR9tjYfXzektDnOidJwQC/m1eyUkh7xvW9/3S45NRseU4Kmy/ChwzkOm
	 EtQoF+XUzPsG3BtGr6Or78COryV2U1aTo1fw9shELa9NSjMMiBkFQPoYJmDfPtE3I+
	 nQEhFr91+g1G0QVJ/rAua1PIkyAP1ywakAUPYolXGWj05km8bFNpfn2ARBMdbU513b
	 9Y+76GwYu0Kewepyo+3YBCSWOQFb98Nt3oteChT8WE29cVjC7Cc/UY4441BAmJUS5C
	 47oojEX0N0UwQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 6.12,6.6,6.1,5.15 0/2] crypto4xx stable backports
Date: Sun, 19 Jul 2026 11:00:26 -0400
Message-ID: <20260718192718.0012-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717024403.87052-1-ebiggers@kernel.org>
References: <20260717024403.87052-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This series backports "crypto: crypto4xx - Remove ahash-related code" in
> order to make "crypto: crypto4xx - Remove insecure and unused rng_alg"
> cherry-pick more cleanly.  Then it backports that commit too.

Queued the series for 6.12, 6.6, 6.1, and 5.15, thanks.

-- 
Thanks,
Sasha
