Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B823F2C3261;
	Tue,  3 Jun 2025 05:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748927009; cv=none; b=sVDQBVYEAdcjA2WZMsnFIlN5cdSF1Mke7/4XOZt+QnQH0YckVtATEXqtXLffuSVkiF+gtWzK0sg8VGG47HKLuifuZiDBH9RqKq80Or9lRp1579OpFFO/xgt1i++HD/zMXJQQ10vG59jo6KfB2LbbMGW1+GVnLRkXHBrJ7+I7YhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748927009; c=relaxed/simple;
	bh=W0OlLUg24npmRbi7FaBwFQJ8Sz1kEcWRUPcpU8Fsw+4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iXLMDcOkQmR1y5W52L1uB/tEjbXbjPouUwi1Ym40Z/Rve+LLOBnFj8DVfOTCJa54M7qiMy3SZjMJgxZg14MhwQjhT8/XnCvaBW81u03lfybTibTv03kn5dsVFQ/+vq0JNMtaoRwV0nryg7nRGZflTRNxae36ApICyFFuC27z9Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aDovO5fi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aDovO5fi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ojVvU2aglR1btkL9Xcwy4+f2CauLOAnpQP+oJKyOOz8=; b=aDovO5fiGQuOBmVN7vw84eHsT4
	XPgHv/7Yx9H/W/mhSdX6C39qkUhGbTyfYJmwCRGq/ejPYosJnqSz30DURJB9JWo4UbIIkB4RvVhTp
	Q1oxLxwBsxAQZlYFQG5fNXYRzYoBAyUSNET6FUKfaRbGCagvGr07NuAq9XJRJg+YUUDy2WqmHTjq1
	PVDcaVwY5UMkt2Krbpesctqgo5qebdBBYm2tBHqOG9JHBdL3b/axzaHlBnG7rYPYrX2dUE3xcGEjN
	M9uOlmb4Bmp49UCyjC3tdFqGBsSlwP28Srh67pRfoui0PPJ1P4dFWhJp6XT6yeHErNoQlHTeV+kb+
	yLjG2RDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uMJny-00AU2T-2y;
	Tue, 03 Jun 2025 13:03:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Jun 2025 13:03:18 +0800
Date: Tue, 3 Jun 2025 13:03:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aD6CFvN-fgiCs_-6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 0a84874c7e7dde5cdddc80a82093120e924a348b:

  crypto: shash - Fix buffer overrun in import function (2025-05-27 13:43:32 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p3

for you to fetch changes up to b9802b54d41bbe98f673e08bc148b0c563fdc02e:

  asm-generic: Add sched.h inclusion in simd.h (2025-05-30 20:56:48 +0800)

----------------------------------------------------------------
This push fixes a loongarch header regression and a module name
collision on s390.
----------------------------------------------------------------

Eric Biggers (1):
      crypto: s390/sha256 - rename module to sha256-s390

Huacai Chen (1):
      asm-generic: Add sched.h inclusion in simd.h

 arch/s390/lib/crypto/Makefile | 3 ++-
 include/asm-generic/simd.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
