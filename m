Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402611DF27D;
	Mon, 26 May 2025 08:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249817; cv=none; b=nxQdCx/UaY3iVWqqZsGPiK7LKbsxG1VZQHY3xEJN4h0huUSwm+KeIjWn9DCx2kS7ZEoZgaaORmnsaYzbG7P1so41y7VNqfWmzB0e/4d1wv+Ijx2LCGwCdB7m6TlWOoxiSzmJTc76ySszSL4rPIB8nXOg200DYDWCiH9Xlu0ytgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249817; c=relaxed/simple;
	bh=ACaCXTsX/JV/G9Somxok0XhPX+3Q4WN2diZrG8Ds1/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFcQGDF8TGzUOEFaBgNJHLl04S8L3wcm6UHMvmWBvSrvYiPgE+uLe6J5RKBnp/ILkY4tMwXFmnS5ya2Fv5M4q38V/v2bBP5UTo7Z9p2u6WTWygLSFQOSFYJK5gOdkzQPEHl4KkRvzInMn1Kvxc5BxA7/Pum4WCaMWii69uQdwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tDSS/uYK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tDSS/uYK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N+ed7TRO7YVkIfVE/BMRhHjFPLqVh2IhEmuljMHZeB4=; b=tDSS/uYKGc5bHRQrlQXGCsw+38
	viE8Z7m6eL53Tudjdjecm3gQ4oOpoLXZBGhr+sGE5yCfBEcLbyh6sOrqwiXYBxkKmCv6JULHqJWCG
	lwKCGNibhiUSCD42U2msCim6q0I/kv0bdGndiMdSkYimzEsu/hIbteAeTKaEI5TCCJ57Hwe1O1SLU
	DYsq9n4PBMrXhGfgdQvAbbwWWwKgUh959bZjtpsCERLsJ5iYMgqJb8zOoorqRiN7c/nJPkfpyiksC
	iVgWwk2BtBPIcum7Ur+BQKdxrf2y6VdVlks3F/Nj9sbRfscR7XgDengG1X15pTTjeegxRmQeFBGwm
	eykWelTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJTdW-008zzs-11;
	Mon, 26 May 2025 16:56:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 May 2025 16:56:46 +0800
Date: Mon, 26 May 2025 16:56:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+4851c19615d35f0e4d68@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] crypto: shash - Fix buffer overrun in import function
Message-ID: <aDQszmcfKfEt4Xdd@gondor.apana.org.au>
References: <683428c8.a70a0220.29d4a0.0801.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683428c8.a70a0220.29d4a0.0801.GAE@google.com>

On Mon, May 26, 2025 at 01:39:36AM -0700, syzbot wrote:
> 
> syzbot found the following issue on:
> 
> HEAD commit:    176e917e010c Add linux-next specific files for 20250523
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=175c1ad4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e7902c752bef748
> dashboard link: https://syzkaller.appspot.com/bug?extid=4851c19615d35f0e4d68
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f92170580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17bd88e8580000

This patch should fix the bug:

---8<---
Only set the partial block length to zero if the algorithm is
block-only.  Otherwise the descriptor context could be empty,
e.g., for digest_null.

Reported-by: syzbot+4851c19615d35f0e4d68@syzkaller.appspotmail.com
Fixes: 7650f826f7b2 ("crypto: shash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 37537d7995c7..4721f5f134f4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -257,12 +257,13 @@ static int __crypto_shash_import(struct shash_desc *desc, const void *in,
 	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
-	plen = crypto_shash_blocksize(tfm) + 1;
-	descsize = crypto_shash_descsize(tfm);
 	ss = crypto_shash_statesize(tfm);
-	buf[descsize - 1] = 0;
-	if (crypto_shash_block_only(tfm))
+	if (crypto_shash_block_only(tfm)) {
+		plen = crypto_shash_blocksize(tfm) + 1;
 		ss -= plen;
+		descsize = crypto_shash_descsize(tfm);
+		buf[descsize - 1] = 0;
+	}
 	if (!import) {
 		memcpy(buf, in, ss);
 		return 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
