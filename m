Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E153659EE;
	Wed, 22 Jul 2026 00:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681657; cv=none; b=qLbD/2+5HUqfNlp/djhPwvmWdYLkQTgjjtUUu95AwZyptJu4mdwlGHkzMg13Vj1jdeXqJwGgqO4NpDTyx1fI6fgDfTGMIzJb0pGXE0EQWv8TvnhOwpwTT6l2+ma6WgSS2AsUkXwgkNPjgp9XbYTBd0akWlB4quez1NhHLfBbwvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681657; c=relaxed/simple;
	bh=KWnMi61FNjHinVzT6gUpMiVJIMFpqgdh2H1vY5gbFYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS/zRbwXco8I4JXhUy2hIVw2wvNS+fml2Cvq3bLA4xNY3C1P0nYeDa88KON71Q2B1InsNkXZqBESxAZZFfq2+yOzyfAW5r0z8z6trGbG7Yz9J0PAis7TO2nOdW2eJcMNikI6h3CG36t3MNcpfnmm2cYyrbFROIWIpFO5i0ocCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6pQKAfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6pQKAfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC961F00A3A;
	Wed, 22 Jul 2026 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784681652;
	bh=R4ayou3UvpGmxsPStcQEMVsXXPWhtGpQkBiQ9SnQOpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6pQKAfTj5QiW6iXHvj8LIcSrsvY5b1yTb5hHrJf30jGklf1e/vjdMw2aaqPIv55w
	 OjOo/4OQUrKk14k19nmkbUuiEKG+4QpqCGXRZG/5ZLWJqeZWufEEedJfNh9P6wrz0H
	 fCsRPW4eKAxMHUTiSGpPYAmm/trVJKQi77ZoH35+DTdJRmvb/Dj7P1ByJ7gSU8Ra68
	 bT6v1cNDVdEUNCIefkM72MzjePvBljsAfnb11OHP/5ieBPkOdDqpVkWuO6Dgmcjeth
	 BVxTCOjq2ZqYv/nenWLTfGFa7Cy2BV+uFQktO4HRc4anl9UprX9GliRoniiLZd6rxV
	 QMj5E/L2f1SZA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doruk Tan Ozturk <doruk@0sec.ai>
Subject: Re: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an empty digest
Date: Tue, 21 Jul 2026 20:53:59 -0400
Message-ID: <20260721201114.0012-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720191525.15450-1-doruk@0sec.ai>
References: <20260720191525.15450-1-doruk@0sec.ai>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
> digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
> length and the request reaches pkcs1pad_verify(), where the empty
> digest is rejected but only after being passed through
> WARN_ON(!digest_size).
[...]
> Mainline does not contain this code path; commit 1e562deacecc
> ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
> pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
> affected stable branches.

The fix looks correct to me and matches the mainline end state (the
sig_alg replacement rejects an empty digest with a plain -EINVAL and
no WARN). But since this is a stable-only patch with no upstream
commit to reference, I'd like a crypto maintainer ack before queueing
it.

-- 
Thanks,
Sasha
