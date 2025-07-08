Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2D21ADAE;
	Tue,  8 Jul 2025 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752003711; cv=none; b=ZsKVsIq1ZoiEk4iZMkdoNAb4XbFTS3Cly/K9Le8y/sObnG+TX1EljoTV64vHH2iLy5QexZraw1RwFAixZlEgU19ZjGfKVwm5+VoeqOoUc9bR0iODKb+KNcc5twUo/OvYbclMSz1/QxWXAyd1ABFhnSBgCN/XQIGAmqQD/W17EJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752003711; c=relaxed/simple;
	bh=ASVIGag1Iljcn4wjjI4ObOm37+x5zt0kmgSjG4XxnOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u9cSb2YRcMGcADXlQbOhv6AznEVcAHgpES2Aahz7c48wpZK20DOIGBKxgQiHsMqcpgweakJfLk/3BUQa1kGx7qi1pQEuqjDyG+1pj1nb0SvgLTiGRaKSJAIMAC3byPvHf8DYU0hSy6YOx6z4Tl4+j501GghM51mUF1OEhZj3I1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pgvKYoKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pgvKYoKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B399C4CEF0;
	Tue,  8 Jul 2025 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752003710;
	bh=ASVIGag1Iljcn4wjjI4ObOm37+x5zt0kmgSjG4XxnOk=;
	h=From:To:Cc:Subject:Date:From;
	b=pgvKYoKyyNtunYyyh/z6u4yQ/GVUvUMkb+Dl1DD3M5YI+jw5ZqBx2jLG4w4u9O1im
	 JkToZ+b1P7mXZNlhXz47nHuFmdp3eDB47hyeGABYzknXFaQnl6YdadJOGw3S0a5z2r
	 EzpNVQgzt9nX5ShZ4UHmhsEdxIur26ekmAqvnJZPdG5JgDq/Imb4lkDXiH08EDqUB4
	 WXqL9QHzQwLHx9KvUj24Hq4z7EMAqno7so95RZ1NcYvRurAZ6K0fx+/hNzU46pRwCx
	 4y80N4EM+0/tsTEkP1UWy/s6adFgHoKyD2g1yDCJlbPbQgN9/KuWzRRGd+YsRm1IIs
	 GHboInCMNtTXA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-rt-devel@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] x86 AEGIS fixes
Date: Tue,  8 Jul 2025 12:38:27 -0700
Message-ID: <20250708193829.656988-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the legacy crypto API likes to randomly allocate memory, the x86
AEGIS code has some bugs.  This series fixes them.

Eric Biggers (2):
  crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT
  crypto: x86/aegis - Add missing error checks

 arch/x86/crypto/aegis128-aesni-glue.c | 40 +++++++++++++++++++--------
 1 file changed, 29 insertions(+), 11 deletions(-)


base-commit: 181698af38d3f93381229ad89c09b5bd0496661a
-- 
2.50.0

