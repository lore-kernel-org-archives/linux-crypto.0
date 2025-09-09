Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B009C1D6BB
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 05:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394065; cv=none; b=rrPrgaKz7Yfx5t3GF4X4Bp5vBAiKWAaT7F22EahHHVNFz1N9RB6rDZgfsIf+qghoBTllN3fRof92xUPn4bR4o1zpCYPrnmRDGpToORGo2CD/gS63I5fzjvfP02qD7axepnUR4zfzopo2bq9/qeqHyY9P7RYzHXU9Kain04G4ZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394065; c=relaxed/simple;
	bh=Aj4O1Tao+kHw4JPDIbAZzTselS6LUgve5hYNNtupXJ8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Wpt/1KHSD7T1+gk0AD3moKjqipuwES0G0h3Dn4sOO3Yb75CW1roBmfgoVOEjhuABHwUeC+JUhjw7nGL3cgOjf4p1xFz/HD6mNBqKslindifUowilaY8/sPH71f1ZaLS3CZ+I7ASR20FE2M2VOZgJgKSLYgwRH7z0mhSkA94BNhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FShuvnrP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FShuvnrP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zDJ9retK5NLagDdDPvqJydfHh2cXm/XRBfTcrLgRz0E=; b=FShuvnrPvjnyi4OVVCr8BGXWn6
	dv2RyYdfoa4u1FRetWoL9SdR1+clPEC+x2Eokpjvc46YiUSpCk/TkpSx7XZuzt/Irwy6NJIX4Cn5O
	RffMj535Y8W5w4ZZHFnxu8l7pTDi+3wNxsI7tUtuCTW2jQClYIykqqIga9Kivsxz52FcRYrFoIxxp
	NEcLUCNscra1gz0Py8RlseGeIZdN1r3v+qoJY8k94ZWAYEZKKZK7hssOGOKKyKBwV6jCRO0LceL72
	iqYdpxER0x447qjn/fuYRxSAQ4T7ohfgFWooxHUOhRv3Ad0PTLglXOW40Y9MLRiJDlbRtjCFTFprP
	Wq/YJLhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvpo4-003pnf-2J;
	Tue, 09 Sep 2025 12:34:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 12:34:09 +0800
Date: Tue, 09 Sep 2025 12:34:09 +0800
Message-Id: <fbe544633cff54aeeec05de81215533b1907f8d6.1757392363.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1757392363.git.herbert@gondor.apana.org.au>
References: <cover.1757392363.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: s390/phmac - Allow stack requests
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As phmac does not perform DMA, it can support stack requests.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/phmac_s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 7ecfdc4fba2d..ead4c0d3523e 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -932,6 +932,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 				.cra_blocksize = SHA##x##_BLOCK_SIZE,	\
 				.cra_priority = 400,			\
 				.cra_flags = CRYPTO_ALG_ASYNC |		\
+					     CRYPTO_AHASH_ALG_STACK_REQ |\
 					     CRYPTO_ALG_NO_FALLBACK,	\
 				.cra_ctxsize = sizeof(struct phmac_tfm_ctx), \
 				.cra_module = THIS_MODULE,		\
-- 
2.39.5

