Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9001D3AD518;
	Thu,  8 Oct 2026 20:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490800; cv=none; b=fbhuimh8zieta254fOZLrivgc0X10//sDx1yEgcR+vQonr3eTm7Dn+hZJF2r7GvZbTkbPOE+uOkLfatzXI32DuvWzQe6x21d04qUvpJj13/5hE5vEo8n0qIuDBaWJMP2P74nfVgchMFur+TK+j8tkrXtoWM1OfVgyJV3PAGNlZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490800; c=relaxed/simple;
	bh=KR7+jUrtcYygTJmVMzbBLiKIAzEX9/KkEgQ5IFPohxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s9QfGw/FdhbhRuCSYUZ2J9xT3i7ADexulJLCYEfGUxaIyO86DoukRZzZAdd60XhlFS+4iIjUJC+GcJj8GeAJ3d/6wVIJuDEFNwUgNfPeLGPXpG4VZt0kqyC5dTWfJsPPTOhKZ70ERfheLh+d+22a77TqW5h2uRZ+/nmb7SgdcFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=R5QqlMgx; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="R5QqlMgx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=wc+zNN3sCFh6YHkSKTb1ekWFIZbMPF5BPjYHSpJQJ6w=; b=R5QqlMgxUKICBQwTt9kQrE/vZF
	bnk2A96CqGGOm8plp1oN/FKr/2+o4OmJzbmAwzI8xBj3WtyOFm7TjjUdUADaQzI/rB6VumfTT4ZHE
	4NDsZkWfaIV1hj4HGA+Z8TOvJG7i274bm7cv/O8mZlcVCqfTRFFCRy/bmXvnhFnb58nRzS59SksH/
	V4NOy+7NOygu6lxJ7oscPqGXi+15ybNQ1cNwBbMxwdYS0zN38Q2YYIkb9qts2rEjJAwF4sKqqcnAp
	PnqbF+Prlch83ku4u6c/ezntzZdQxP6QXlcJXmADJJz4kApebuvO7vN4SySNKsqD7LtD2OobrMhra
	kyZn1jsQ==;
Received: from [151.115.150.205] (port=38102 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xEuar-00000002wY0-21Sz;
	Thu, 08 Oct 2026 22:19:57 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 0/2] lib/crypto: arm64: Fix Poly1305 NEON resume carry loss
Date: Thu,  8 Oct 2026 20:19:48 +0000
Message-ID: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

When poly1305_blocks_neon() resumes from a base 2^26 accumulator with an
odd number of blocks, its base conversion can lose a carry into the top
limb and emit a wrong tag.

Patch 1 fixes the lost carry. Patch 2 adds a KUnit regression for the
split-update witness that triggers it.

Changes in v2:
 - detail the computations reaching the bug and improve commit message, 
 - add a KUnit regression test.

Jérémy Jean (2):
  lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
  lib/crypto: tests: Add Poly1305 split-update carry regression test

 lib/crypto/arm64/poly1305-armv8.pl |  2 +-
 lib/crypto/tests/poly1305_kunit.c  | 31 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

-- 
2.47.3
