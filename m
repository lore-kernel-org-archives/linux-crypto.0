Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A301BD9CE;
	Tue, 21 Apr 2026 06:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776752065; cv=none; b=h7TIg6F49t3RLYO7wbwXomPucTaEoAG7sFfTTa7QClvvC2vY+fsKbHxeWbsOZLwr8lJZc79Xvy4smvKbj+PZFIc0OrfRzc6FvGLd+lUxG944a1NVfKM1mt5eHJApbHWjny5DIkGYLbqRZAQDCckRKD6PQpCP3wXKU7sU5aCkfW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776752065; c=relaxed/simple;
	bh=X1qWUWU/mI3GlbGQRyPkTsT4l5qeXQ3eRSLT9MEkLjk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=I7NneASwtqSKH8m5QIho1oT7F9ntl3HpjtPrKbkoSt0xzlQohCCsepyKidR2b42PdCtDtisvkRVq3L3NNQ1EXRfhj5F+e6PzQn/7MrXspZmIAe1cQjV9drg4YaWvQKESHQeHaGc8Y4JgD7al3SjqyCDl6Frq/WYS7hFdgSnzQ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUfmmEaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUfmmEaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF88CC2BCB0;
	Tue, 21 Apr 2026 06:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752064;
	bh=X1qWUWU/mI3GlbGQRyPkTsT4l5qeXQ3eRSLT9MEkLjk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WUfmmEaWVlNF0Zp3ron2jiTn9whpDBud+/73OhqlrOKRmqGCVncpvHoeDa+r7+5la
	 oRBvsH7PV3gQCqlcbJp/pPDaesI+wbfmuwPFBKVTFfJJ7AvjUwvTKgcAO6WBxj6k4x
	 QI4KGE7RUlkBtcklv9ISscK7MzO1Fh6hcprIyTqaMW2HIx1CyK1LfeiKgFGGH0aph3
	 IxbOflRHIYm64u984otE74u7bNtijJ8mBf3L1EG787VBJz2Pdr4nn3U7y4e3QH6YHZ
	 vP6aCvbpMjAsuLs+ycPDNLv0f75U4dyfUuDHxLFrVVYQx3/HpukD/R6Ks55Ca+yEwg
	 7js2XMZcn0nkw==
Date: Mon, 20 Apr 2026 20:14:23 -1000
Message-ID: <618031a1ba31f2a92787b22fdb209e91@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rhashtable: Bounce deferred worker kick through
 irq_work
In-Reply-To: <aecT_nyT2cU6kmlF@gondor.apana.org.au>
References: <4ff731fc-3791-4b96-a997-89c3bcd2d69b@kernel.org>
 <20260421060326.2836354-1-tj@kernel.org>
 <aecT_nyT2cU6kmlF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Hello,

Applied to sched_ext/for-7.1-fixes.

Thanks.
--
tejun
