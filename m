Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F67E1547C0
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020690; cv=none; b=ji3zy1YCDV4LuLiROCfhVY9MILW05kiKBE7tdENSCnO5lm9m5Fn6ogLtERQfw6ZwXhpsp3CcCF1NKql3CRlS8sVtgzb7Fgl+D619FKSOqm/7ZCw3wYVNWJxAQre07GniwLjVo60KcV4sp+rCJLfU5x6Q7e6UoE1LPWH6iJFlQTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020690; c=relaxed/simple;
	bh=5q3OPDEkRrAFYfHtoDXAdZR8h1q6q68LpZlezPGORfQ=;
	h=Date:Message-Id:From:Subject:To; b=SdVdwU0RqwIbqf7JTdY7Mec62vXCVgjhHkRYz9jC/vNtmph1Q5j2zbzhqiCMlfSlBBuLs2yT+PGxcU0+cGR+HLd0rGUQ0oNIzeI51c0wO/4r/5A7CJOpEL+WtsOrN6+YOAZQv2OV9SIGwBLkoepmQRI0fkIX4g9sVm6wjY9V8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I9XI7aYh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I9XI7aYh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bnXzRuupcVhLsTbF7kS+YvwWTIXcBZUry9rFblnGrQU=; b=I9XI7aYh2x3LeN9Yb0xn9iElT/
	kP1fD4YiPX//B1eM407SvYGJco1c0R2EcDZ1STxyM1G6EPGLMl6bTN3bW9TE4Ld9ynguEMxue7++z
	9JhifuaMgJmM3q/dMAuKR6XmSHFiYWIXyGt3cOPrm+hdkdEyYHUVtxZfG2SO458uchTtDXwh6tY8I
	MJ3mQ48RxfJ+kCx1qG5BtDZygHE9SJR7WOWc/g9YediqJgf3XD90mTJY8Tb8KIvk8FYvvjQoPZluf
	2AJ+GDiODwRAUOp5KJMX99Vjp8IunlZqYQEr88Y3+vQhkqZCj9hlMKRNx9tcI8UWVREd8kPpDsv43
	EdC/grJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jRs-00DTPD-0I;
	Mon, 07 Apr 2025 18:11:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:11:24 +0800
Date: Mon, 07 Apr 2025 18:11:24 +0800
Message-Id: <cover.1744020575.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] crypto: ctr - Remove unnecessary header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series removes the unnecessary header inclusions from
crypto/ctr.h.  The first three patches adds missing header inclusions
to the drivers incorrectly depending on crypto/ctr.h.

Herbert Xu (4):
  crypto: nx - Add missing header inclusions
  crypto: ccp - Add missing header inclusions
  crypto: s5p-sss - Add missing header inclusions
  crypto: ctr - Remove unnecessary header inclusions

 drivers/crypto/ccp/ccp-crypto-aes.c  | 15 ++++++++-------
 drivers/crypto/ccp/ccp-crypto-des3.c | 15 ++++++++-------
 drivers/crypto/ccp/ccp-crypto-main.c | 13 ++++++++-----
 drivers/crypto/nx/nx-aes-cbc.c       |  8 +++++---
 drivers/crypto/nx/nx-aes-ctr.c       |  8 +++++---
 drivers/crypto/nx/nx-aes-ecb.c       |  8 +++++---
 drivers/crypto/nx/nx.c               |  4 ++--
 drivers/crypto/nx/nx.h               |  5 ++++-
 drivers/crypto/s5p-sss.c             | 24 +++++++++++-------------
 include/crypto/ctr.h                 |  3 ---
 10 files changed, 56 insertions(+), 47 deletions(-)

-- 
2.39.5

