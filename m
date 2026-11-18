Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988629;
	b=3fwUfEmYBZlF7AFZdYpdbzwLEHGy62B+uuH+cm7bMzNRMbrwglhJoFtKy8/v3rbtDgZs
	 /O5nU0F2XNXEcXQgi4aSO9Pb1+XwtHrOhpvMa0/Uddy/ki726ydEaAL5pgOHzsQ1rlXTf
	 VhaVmfG1ziGgjaumWCKsB9J+W2XMzIutAP9PL9bC23CBsWnzw5a7wA7FCRMFcpaZoyze+
	 osfQw4DlauKRhC5OTEHbT0keYbPrGFUXgGOZ9wnp1YwoVVrSbJirAfQBS507S+oBoe9Fz
	 ji1+7T5sHqmVFv5izm0Ybs0OTs1T9CeDwplnepULx32s5ms5eUuvK29talfiR5sIG4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988629;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=KjrArLb9IqfHjfAy62DXYGUT6Rnc6Kig1XxV83nQhEQ=;
	b=w6Aj9/z1Qhc2LvAFnTUQfIqxROgHE6dx9nHBpBGOeGfGy7E8MnENjej1mk/lAJ+fs/Jq
	 3cClEIjlGVCVrjLW1gud6iSJ89o4ghq3tNfpFo0RM/Hsj/YdNsOdCVPEE72tr2TxFTcPT
	 Yk3LYOWt0zxs632ivdpNjiE/Rmoirx5NwB+MMHDXxGwD6Zls4/v3bFG9GO9t6UbYUG4lL
	 /XwY9xnX5PU0QOW8tBgKSXGxoJjVeYckTgsNq6cRHDKDw263YdqS2Id0Cpv4k2uJIEEO+
	 954srebPzjCp04LFmPmt4tDnHSMOAa1KnkZvckSTuovxx6Fl0ztOVIQkDhKz0FnBF0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=PGvxmTEz;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74064606A330;
	Wed, 18 Nov 2026 07:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74064606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=PGvxmTEz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Kj
	rArLb9IqfHjfAy62DXYGUT6Rnc6Kig1XxV83nQhEQ=; b=PGvxmTEzOgWI17Vmj5
	m2eB0suLjP6bQBBp957M7D37LRNn/cJV3Xz6QjVK7nloNg6ysuJsvXtFFJqE7zK7
	6UMUYNF5zQ5syO8WGFSE5ZxLiX2Ha2q064w5/A65oI6zHzv+RnXgsoAEi3mES5iO
	wyt6eZ0ObMkiyy3eVZ57ZNCH8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3P6M1Wv1qx8alGg--.56103S2;
	Wed, 18 Nov 2026 15:56:39 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: schalla@marvell.com,
	bbhushan2@marvell.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 0/3] crypto: marvell/cesa - Fix hash DMA buffer cleanup
Date: Wed, 18 Nov 2026 15:56:33 +0800
Message-Id: <20261118075636.2152451-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3P6M1Wv1qx8alGg--.56103S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw1Dur1UAr13JrWUtF1DJrb_yoW8Gr1Upr
	W5WFWjyr18XryxKwnrXay0y34xWrZ5JFW3GrW8tw4UArn8WFyIvFW2yrWxXa47uryfu342
	qrn0vw1DZrn0kw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRLmiAUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7Re9LGr9Wje-MwAA3d

This series fixes DMA cache and padding buffer leaks in the CESA hash
request error paths.

The DMA cache is not released when request preparation fails. Padding
cleanup can also be skipped because request type detection depends on a
TDMA chain that has already been cleared. In addition, final requests
rejected by the queue leave their padding allocated.

The patches address these cleanup paths and clear the DMA cache pointer
after freeing it to prevent stale-pointer reuse.

Testing:
- ARM compile testing of hash.o for each intermediate revision, using
  Clang with W=1 and KCFLAGS=-Werror.
- Userspace mock tests of extracted driver functions covering allocation
  failures, queue rejection, backlog acceptance, completion cleanup,
  retries and non-DMA requests.

The mock tests, which is assisted by codex, validate resource lifetimes
with DMA pools and hardware interfaces mocked. No hardware testing was performed.

Haoxiang Li (3):
  crypto: marvell/cesa - Fix DMA cache leaks on hash setup errors
  crypto: marvell/cesa - Fix padding cleanup on hash setup errors
  crypto: marvell/cesa - Free hash padding when queueing fails

 drivers/crypto/marvell/cesa/hash.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)


base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.25.1

