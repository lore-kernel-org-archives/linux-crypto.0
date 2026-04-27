Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC653B389E;
	Mon, 27 Apr 2026 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286637; cv=none; b=TPsXAT3R1clmbHI4UZq/pB0Wau1N+IMiSUN4JLsRn9+BrIFl5wtv74vCtYeHfo7NtWRP/uUja4yY0A0j6P1onOa+CJm5oP9ObtUYQHzX0R8cs76zDKQuI9Ya1+fm9CxGZe2bJH2exqc1m9rJ+5+BRtrXfdcyzOA0uLsR5Bu0hpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286637; c=relaxed/simple;
	bh=1skfXNVPPT6uX0hh3vAmTDta7stRVmn+s783u8jmnQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtSdO54WHmJr5qtYOHUHI3DatclwcJhznq/0McWRoC2FHj9fsEnySHANcxypCpbGAX0JpJoCx4+ts+SMBdaHJnEpGu2tnyXaCR4j9I/8dBwW0IKmGi/ANFmpfp6WIYGHnzRASloiDRUdzQbjFt9wfNVaaj104ixm4voYTw6VWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uB14aOgF; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uB14aOgF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777286634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QEE6DYejUnp8i2ks0d4cjCAik53qXhYI3uzflodtENA=;
	b=uB14aOgFXp+eq10QRmZJL33z3MRRE4r9ufmiVRG6KnO25WfcLH8HvFvjVi2OPPbe2MI4Dj
	ow8SZgUI0hNiAwLFPit2I33K95TIRdLGwK5+RoXlWX7imqD6g/hu+4SQ6Fu453qKeyFySp
	SW+0kjSbCxSycLZZ1zvMWeo3eMd1Zso=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 5/6] crypto: algif_rng - use sock_kzalloc in rng_accept_parent
Date: Mon, 27 Apr 2026 12:41:34 +0200
Message-ID: <20260427104129.309982-11-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-7-thorsten.blum@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=727; i=thorsten.blum@linux.dev; h=from:subject; bh=1skfXNVPPT6uX0hh3vAmTDta7stRVmn+s783u8jmnQw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvbeMsI7+q5sbcZpnpukE4Tkvp+5lpxxV+m6/OWZPPa Vje0CHXUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABN5PYWRYROHT5rxvVnplirl a9zX773P/fwmc+jvB7fjbkVPMqpk/MDI8ER1TkqXh7jZX5uHJwSFD2e2/kjsmTEtQvXnqmY1LrH vDAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify rng_accept_parent().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index a9fb492e929a..f609463f9e14 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -244,11 +244,10 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 
-	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	ctx = sock_kzalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	memset(ctx, 0, len);
 	ctx->len = len;
 
 	/*
