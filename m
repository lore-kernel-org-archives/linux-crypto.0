Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B92343882;
	Wed, 26 Aug 2026 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740695; cv=none; b=Euxgk8lHYmWCXk5UA0JhaylvueZ8EFaXo2zQv1wlh9oPxbWgHocD3Kz89lSHLhg4RcO7uYffsIttvdP0S/2Sd60Gor8SP9mT75cJrMiGMNcxPCFgDlJ90ODKRs7+U47eKx7jPKBEHmoi4mo5GtY5gEK6AKXmbvWnXCJtCgr2nu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740695; c=relaxed/simple;
	bh=xOtq8N0yTXbVgqWVbdE95NTVNt73l2Q02hilPm+V7BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q39YdxT3/6i5ACv6TJnmDybgYbstf4lv4XA8UJNVLRaIutjRuyUgh+/pqjI/VGlEWWPqhgvPFmQpwZX1kpCPGyKIYc3J8ghp9BP9XPT0gPePUnjxf7BTrYGgLIMds96Kf5a5O5G4JcC8xnxS1LMBvMhvRrZYiVz1pd8GwMWWnVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=jaEZlLHo; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="jaEZlLHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q/amVWIVI0Gt7bEWVLy3Dj/gqdFme/iJdzcMmIU5NiM=; b=jaEZlLHoQQ2ANp5JtCtkgBWexu
	q6FoAkehNiewSqj9ob+Y45cDYaZRfonZbdO0Lfjc+AcJppy6bP6EZf1sCbCSHxdfTrdNHQgQpvlT1
	MZcpb3jpxhMTTe57M/Q+oUgPhTF5mp3FrUYKT9j9D9z+UOmVOnlTv7I3V9u9ZNhKkEAr0XFM2TEzj
	ht2pVNUJue0HRzmlpa1XERNvAKCBtcXadvs1q/8jOq+NwmO6vDGIiuId7GrN2xTZBZiKgcA3JlVJr
	73lEAdU7htqoW/DkTrOTS+78tMfsYgtfFRd5k9SaUK7+i09ib3Ilxi1ZX8EsxN4GZy+4+Wwir/aRN
	mKHG4KxA==;
Received: from [151.115.150.205] (port=37352 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wzB1H-0000000GmVI-0kAW;
	Wed, 26 Aug 2026 12:38:11 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH 2/2] crypto: rsassa-pkcs1: reject undersized keys when verifying
Date: Wed, 26 Aug 2026 10:37:44 +0000
Message-ID: <20260826103744.1554131-3-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
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

rsassa_pkcs1_verify() accepts any nonzero key size.

With a one-byte key and a zero RSA result, the leading-zero handling
decrements dst_len to zero and advances out_buf past the allocation.
The next out_buf[0] access reads out of bounds.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_verify+0x79d/0x900
    Read of size 1 at addr ...
    The buggy address is located 0 bytes to the right of
     allocated 73-byte region [...]

Reject keys shorter than the minimum PKCS#1 v1.5 encoded message size.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 crypto/rsassa-pkcs1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index d0e4a885397f..39137476ce81 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -231,7 +231,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	int err;
 
 	/* RFC 8017 sec 8.2.2 step 1 - length checking */
-	if (!ctx->key_size ||
+	if (ctx->key_size < 11 ||
 	    slen != ctx->key_size ||
 	    rsassa_pkcs1_invalid_hash_len(dlen, hash_prefix))
 		return -EINVAL;
-- 
2.47.3

