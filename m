Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80EB2581
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746176644; cv=none; b=Jhoh6EpsctWdXZcVXjgn9l0+uXHRwVnQi8feI9YFPO6QV8bTdlTbqleuvcrLpedubE/yz68V3CYwQNa49Kxb9Vlj2k02mlMYjTER5WZiVoBC30BZqRmSOJ/VFLs6WQx387G4wPIK+H53pTm2nfXnftRQAL44UrGTSxsRSxuFYsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746176644; c=relaxed/simple;
	bh=5xJxjatv1SXBgZWuHf/pcOnNZHixmTq2mur34YZVQWI=;
	h=Date:Message-Id:From:Subject:To; b=Ybhs0AN7RMZsjblKbZXnjoCH8O4n7IliVoElb5lfCk4PndjCJGq386+bJYTyxVNQcR1ZnqBWIUgU/IGpT5Q/jSw3YM3fsoJ7u4cWUGGhmt9Z405NfN6HkwQp3DsVLQxY7zhICSiDIkLIDLxQOMMlRn7D4mCrcYO5L+99+QAN0Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lC7y52qU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lC7y52qU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3gLiLWifk3nVPNK6MTy0c8gc/xHYCFmOA4uzNtcPE34=; b=lC7y52qU3VA/WPoJrTL8kq6BC6
	VohW+avW6iSEEDcA/thF9x9lO3ycgPpWMNftFIy0IhMMeQ8lKSBvZiTTD2A4Qafcz1DTuntfyw0c1
	Mvk8gg28o4lbnDV1Z5Q0eiDVwfQfh5kQhK9+nAKDlC2FLY0NTTwhmp7aeR7TrsTvDhsGU/pKy6iJH
	Jnf3uNS+EtMgnWIGtBoPT/8Nn24vG0aeYKMPtUvQ7+o5LH+D/i80Bm2v3YZ2aWC1BemRRxciNEF6A
	iRajS8tyZF46MCVov9uO5vedtGc+yw6YF42uHmSd766uOZF3IqmVEHQZeHz8YoK7zjSWYdEwb88nb
	TgQOJKdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAmJI-002nrz-2m;
	Fri, 02 May 2025 17:03:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 17:03:56 +0800
Date: Fri, 02 May 2025 17:03:56 +0800
Message-Id: <41f8d44fe2b46ac2e1f0c54e550aa8bffe9e1cf3.1746176535.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: shash - Cap state size to HASH_MAX_DESCSIZE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all shash algorithms have converted over to the generic
export format, limit the shash state size to HASH_MAX_DESCSIZE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index c4a724e55d7a..4f446463340e 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -479,6 +479,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	if (alg->descsize > HASH_MAX_DESCSIZE)
 		return -EINVAL;
+	if (alg->statesize > HASH_MAX_DESCSIZE)
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.39.5

