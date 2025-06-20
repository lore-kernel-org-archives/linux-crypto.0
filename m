Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B37801;
	Fri, 20 Jun 2025 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389475; cv=none; b=ENtZzKTRzElL/tpztxaXqLc8YIik3LLw/IrfjL1Fa2kWuwXzknjs5kmMHDaSpVHP422ZmQsxYiq/xnRAJj63c9eTnaWSYhlnDmuVJL8BTlP1nmlcEMAXJZWrUG2maQxsoSt6m47K78JhBdp3SWXfcape6aQhU4izMpMsw15ce6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389475; c=relaxed/simple;
	bh=f4WAufMQq5ggmSNmCwoJqGR4KXxe3q9/JSCnVafH2zQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b0D8WBlQ2GLlEHcswY7UlJsUyCdZbUhsoUvXec6c+Yy9Z4CItwrYOO0ON7XDto/oxGy/AbQRNszeYVrhij1Li22kO+sZIgHx8jGVjN4fRYfZuC+hApDxB8z0saJcvZavr4jAxYfbJs8qCR57t+gWOLm/3nc/46gu23EmG+lz5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oXfvvIux; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oXfvvIux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mQjZYQXHuM7O2SlRUBbFiuHe1vtibvQHiSpaNsCAw+Q=; b=oXfvvIuxaqH9EOG75UkLdv1B+C
	3HtP6hO7lT2rA3p6XfxzeAvwJxGWyJdAwwbfloOWJMhrjEudqtxKqxCpSIBbJXU7WQrpVvvEi4Z4W
	8cW5xe/LG/DyP9BzIkeFoFV+yd1l3eK8SZKY+FM1Z4S/qrRDhzUbiBp6og6YuxdalbGFck+A0Jdgx
	9YAY6r2oxgPE40MTX18HtuKEmUqEwIuPZTu33Hv+h0K83mpFPVnBcPaejbxlyGSZpjAMeOR0jGDrV
	r3XgLDPIm/7dz7cT7M/+mN8c0mraosjJHvtWBjpPG2NWREoLEy8Zhkrio/ZxdILSp8uTrFpDa8B8u
	xZiyk2Hg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSS0o-000T52-2z;
	Fri, 20 Jun 2025 11:17:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jun 2025 11:17:42 +0800
Date: Fri, 20 Jun 2025 11:17:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aFTS1jNQ6DB51gUs@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 40a98e702b528c631094f2e524d309faf33dc774:

  crypto: hkdf - move to late_initcall (2025-06-11 10:59:45 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p5

for you to fetch changes up to df29f60369ccec0aa17d7eed7e2ae1fcdc9be6d4:

  crypto: ahash - Fix infinite recursion in ahash_def_finup (2025-06-18 17:02:02 +0800)

----------------------------------------------------------------
This push fixes a regression in ahash (broken fallback finup)
and reinstates a Kconfig option to control the extra self-tests.
----------------------------------------------------------------

Eric Biggers (1):
      crypto: testmgr - reinstate kconfig control over full self-tests

Herbert Xu (1):
      crypto: ahash - Fix infinite recursion in ahash_def_finup

 crypto/Kconfig                 | 25 +++++++++++++++++++++----
 crypto/ahash.c                 |  4 +++-
 crypto/testmgr.c               | 15 ++++++++++++---
 include/crypto/internal/simd.h |  6 ++++--
 lib/crypto/Makefile            |  2 +-
 5 files changed, 41 insertions(+), 11 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
