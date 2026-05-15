Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E84C3FB05B;
	Fri, 15 May 2026 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837841; cv=none; b=SRg2NvtHUr1vlA667+ukK6bCdDB0NhTmWTOHRzz/scMUHZ2diDXeB/RoVZkpzqMSEnqtATn9xas8dpnRdmT9uRdgPjiCs4rOowoE0ZixGO4utA542fs5cBN8QdxYk7DSdkR3FHT6Q8Oy7PCIikfO6rW+gVnuM0qdY4j7XBd+6hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837841; c=relaxed/simple;
	bh=0b4BdhUckGbHIH7Zvw1t+Ozj9qaK07ep4Ace3EYPJW4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=twe98DC2w5BtkD8unGmXxYA6UoFgzRmZbL+RkSTB/9sQ/N7dwU2tR6WAUIlMVD/LOJ/Lu+SABmdzEvy6UT5NGL57Pa3aBcYpdfqhk+fYgvr82rwXVx92v2bMM2J0aAs2Ln7zz9vV9wrvfuOS1kvj9AhT/baPhcQ6uJpzT9hNGis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=d5wmKAnu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="d5wmKAnu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=UcMqsDtDEtY5iiMDUvFI7OPfUYFVARHM+HhGDzhxuCo=; b=d5wmK
	AnuJyB0ZKbmIzAFOqnkbr8j0vGTiOGjMmjUHvhiwaN2IgHkQ3hyI6l8l3I3fOutI3cNEENs1kTJg7
	efvLIx2Wququl41LbHrmYL6DmtEKCFCc+n4Jl5ZYuuvcVtFvZBD7XiI6LKIJucvPZ896+APQiv/im
	apcm2qwoQ3zWyRqfE3V/geV71cCEJa0Db3MorDZBKEJab6UVrYkAlH+ZONny4EAdXm5b2nxBK4zeY
	VbkVRkjJ6mawcpGR8D0rYHYxfdchjJrGo0uTYy1Tjm804IqTAZ3V5V3WU/Gspk9a9ddaCEFXaYvTt
	QCmOs0LeVfAaVC80STnu27qrW0Xlg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNoyj-00EMnK-2p;
	Fri, 15 May 2026 17:37:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 17:37:09 +0800
Date: Fri, 15 May 2026 17:37:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.1
Message-ID: <agbpRZ1OdUC-orcg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 7fd2df204f342fc17d1a0bfcd474b24232fb0f32:

  Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p4

for you to fetch changes up to d1fa83ecac31093a550534a79a33bc7f4ba8fc10:

  rhashtable: Add bucket_table_free_atomic() helper (2026-05-05 16:12:07 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix potential dead-lock in rhashtable when used by xattr.
- Avoid calling kvfree on atomic path in rhashtable.
----------------------------------------------------------------

Mikhail Gavrilov (1):
      rhashtable: drop ht->mutex in rhashtable_free_and_destroy()

Uladzislau Rezki (Sony) (2):
      mm/slab: Add kvfree_atomic() helper
      rhashtable: Add bucket_table_free_atomic() helper

 include/linux/slab.h |  3 +++
 lib/rhashtable.c     | 33 ++++++++++++++++++++++++++-------
 mm/slub.c            | 16 ++++++++++++++++
 3 files changed, 45 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
