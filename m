Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55933A3816;
	Sun, 19 Jul 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473245; cv=none; b=AGNCjZFjN0pY5T0wfapmYTkVf3JUpCyJIpcSez/zKzJO4n1GnYS/TjONOFYq5EWYo6WRXWjnLlVTGB9Q9AQlxzhNzMduDKbnzHYL9vjki7ODwXbkUb5xVYUN+u1+rgoMko+04+f0IHLZMc2rvFRtbagLMb7JiKxbN0TG9vT2cek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473245; c=relaxed/simple;
	bh=LxOBkMm5ZsT0MjnePi61cEgHf0hWHGSC2Qon6mlFsAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMM6fWtnPil6R49svXuqzE7d3Rluw4Rl30rP1PyVntigJW+fav6nH1EnjTPMyEYgOX2nliQZZ5/5N5OzdiJIlhIVqNzGnt/Z1EeCy25/JsHe8fG03XYahdI4+KGdYwrG4rRCHOWjARolDoN77vAHJGlgYNuRqG6QFle7XG0Mfs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnotrGTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnotrGTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45561F00A3D;
	Sun, 19 Jul 2026 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473244;
	bh=1uXJHZnGnMMCOiMq9OY1Koo7lyDJ+5o3vNOK8ADWbcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnotrGTpIolXlvRevv2nFYFd39nwnooBdXk3Vs0SjpHYq3PRUEFOoBihy8FMAr9LS
	 wccO0Pn4MzmZSrxrCQklUgkq80paNbglSmAwpNSL7B89xXmaoR6Oh+Xm4XZlskHItI
	 Dh/w0LhCBD7FzNSZyK+iaYlDhtu3o6M5vakoQn3bV9uK1RXsUxPJ2mc/ZA+2uR328Z
	 +i6yypcJbY2sbbJdxxI4mX7wIaRUanWfcKa95KX/z8VQfA18D2iN/Z8Vx/yWBgh+Zw
	 Uww3FKRitqG/yv3cXW7re6Rrq9Zoe/nU+Qn3SXBQnnX09pX4+9NjlMvg3ROmTHTZCz
	 ZJ1VISB+7ODtg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Tianchu Chen <flynnnchen@tencent.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.15] crypto: sun4i-ss - Remove insecure and unused rng_alg
Date: Sun, 19 Jul 2026 11:00:18 -0400
Message-ID: <20260718192718.0004-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717035228.353051-1-ebiggers@kernel.org>
References: <20260717035228.353051-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Remove sun4i_ss_rng, as it is insecure and unused:

Queued for 5.15, thanks.

-- 
Thanks,
Sasha
