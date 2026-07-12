Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAB023C368;
	Sun, 12 Jul 2026 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783888067; cv=none; b=KDZ/xEnRxVNCQFSnFpdsfrtq8U5kdAWyF8Hr72XdYB0tOK4NcGKY+36w/8sS9ncpv/rNAFFymC2B1r5HXYcZRN3noOmKKd4UG2Mw36Q8UUusykk7nDFfq4+SgfsHVcEZ+De8FcIsQK8TYqxW0gvUmibf/yNDQVV68Y6uZ0viNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783888067; c=relaxed/simple;
	bh=cMQ7qKy85aI0Ey6pmR7ab44Po5nDh9ffT2own44a108=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwPrxj5+f6X/POL8n099J6ZADrOO35oQT7QzQAW9MZQacJCOjuDpmc16SnPd56FqOAtfpaXo9amA9UIKuEx9Yd5uMiBt5/TAJDa0pu0urEnsUrqalQ6TeWq//ztlxAqI+7mlfCPc3p1iVC1f/McnNPyBeuNsNXqWmOGjbZOf8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2OeG+SV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2OeG+SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B8F1F00A3A;
	Sun, 12 Jul 2026 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783888065;
	bh=fpgKaZ+xtnuszV5MahSHFMgtA0JNZtFAhs6G5RrS3NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2OeG+SV9D0Y874MmRvzPmPlULvfcvikAF3jdQfdAlacr+LBOiGw04UIHATEs6uz/
	 6+eTEy1ZYi1Kg570ZWwq9X4qFceT4kp8kg2QK8LmEAuXUpQb8vBLfbl1QZ5NAgkK1Y
	 GQlJE8ig+Jw7/ZiP5uz2T0TFgTalaCEQ87OD520Q2LhzZ0+P8Uh6R7Ya4b0RMvXliQ
	 4ZIetnJxIByR9lHffxJdgkgLLkFar1KvQPWPvl+S8f4lZkHUG1Qimtl5T7FBCQyhbo
	 fW2UqXWCYFUtwOjs/vnSyHmi3/yHzTJ8euR5gEsA3br/so4bQm9MKSbecqf0guQO1k
	 o5jD7QgFpzF0g==
From: Sasha Levin <sashal@kernel.org>
To: herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Sun, 12 Jul 2026 16:27:39 -0400
Message-ID: <20260712105304.agent5-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260712022618.1665-2-muhammetkaankilinc@gmail.com>
References: <20260712022618.1665-2-muhammetkaankilinc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> MSG_MORE chunked chaining is unaffected: it is carried by ctx->state via
> crypto_skcipher_export()/import(), independent of the IV snapshot.

This isn't true for cbc/ctr: their statesize is 0, so export/import carry
nothing. The chained IV propagates only through the req->iv writeback, which
this patch redirects into the freed snapshot - AIO + MSG_MORE cbc/ctr silently
produces wrong output.

-- 
Thanks,
Sasha
