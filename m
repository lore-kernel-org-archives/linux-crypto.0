Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871C21CC43;
	Tue, 14 Oct 2025 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476627; cv=none; b=J1zJ0mNAUGpL2TGMSa9w2k67buLYvBXGKiK2JO8lZ9CU/J+ukUAv9fly4156UubdDL5HQuzgl3SZuOOtD/LCG6KSLtb8cb++PjJOtaftIQFvZvVwvxDAigbRJcyNL+za5H60EYqQfQyM+bK/mslrFY3iGa49doBWTZEwq2uBezc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476627; c=relaxed/simple;
	bh=cOc6bdNLU9i1kl8mzGCiKJ+jldix6+oZ7CV/WClwJqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rC/6RFqdknFpzVpXM4d4kXWdPfYmAxYDu/ANNtIgTsaFQEC9iggTUBrg/JFYOE3EXH48Ux348rOzPwiwM7WiytOTuSu34qBUDN/gklLlxDYB4Ilqj8SHWQu8PFx+2Kc0+ZB/SdWoENIz9RojtmPFv6LNeyIydgbRyMKP7gHRRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpUWAhvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpUWAhvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E97BC4CEE7;
	Tue, 14 Oct 2025 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476626;
	bh=cOc6bdNLU9i1kl8mzGCiKJ+jldix6+oZ7CV/WClwJqo=;
	h=From:To:Cc:Subject:Date:From;
	b=cpUWAhvC3bDC+QlkoVJnYrvPLkLW0Uuru0OsZnGj71/8Xecv9pEiHIDpEdGMy+DSZ
	 YfhI0xW2aubrcjahHP/Fh9HopGN2mzct7mxfmsLCS8KTmeQPdqy9fOYlJRqazOt45R
	 KndYRES24haadfwNtSOwSqboOdHuFMWQ9YgfrcEY4WfdD3HlxDSkT5VaQsforx71B8
	 b3TOG0Li2+1GmyQJE56+NoLO5D0qatALdnMmtMWmjC/dUEeiP9Wrec189hERNsFw/K
	 dpERMSaNbYEkG5R5sBI+8HMA+I3NvHA1KJ3qwJuMoSW6OtUEt1N2pg1cptOXgd65z3
	 RWVkEcQW+TD6g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] Optimize dm-verity using 2-way interleaved SHA-256 hashing
Date: Tue, 14 Oct 2025 14:16:53 -0700
Message-ID: <20251014211657.113603-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series makes dm-verity take advantage of the 2-way interleaved
SHA-256 hashing code that was added in 6.18.  fsverity already does
this; this brings the same optimization to dm-verity.  This increases
SHA-256 hashing throughput by up to 98% on x86_64 and 70% on arm64.

To make this possible, this series makes dm-verity use the SHA-256
library when the hash algorithm is SHA-256 (which it usually is).  That
actually provides a ~2% performance improvement by itself, in addition
to the larger improvement from interleaved hashing on x86_64 and arm64.

As usual, I verified that 'verity-compat-test' still passes.

This series is targeting linux-dm/for-next.

Eric Biggers (4):
  dm-verity: remove log message with shash driver name
  dm-verity: use SHA-256 library for SHA-256
  dm-verity: reduce scope of real and wanted digests
  dm-verity: use 2-way interleaved SHA-256 hashing when supported

 drivers/md/Kconfig            |   1 +
 drivers/md/dm-verity-fec.c    |  21 ++--
 drivers/md/dm-verity-fec.h    |   5 +-
 drivers/md/dm-verity-target.c | 203 +++++++++++++++++++++++++---------
 drivers/md/dm-verity.h        |  52 +++++----
 5 files changed, 196 insertions(+), 86 deletions(-)


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0

