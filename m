Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238278;
	b=alCaMyPWBIAlWnbEvKj41y+chEOLLr3MUBOkDMTeBpFEAyKUPnsUa69ho8TIOSFclctH
	 BsmiG3ZWrt9R2/GNcQ4j8Blgs4GbJHZimjHzsI/iWGx/QmEFif6NtQcOCrLqH/qsooRWh
	 cCvjglM9v34GZUJX9qOXMjwSY4F3O9Aly80IPO+UkTPFtwZQIWfFnNdtfFizTmVu/BmI2
	 ump35hCh1kFTyOM/pWkp4E+7mIJf9wZy6o8ndg3LYJ2xE3T2+4dKtnAI8t9jpvtD0NiTg
	 ywTt1NdM82dRo3lEqa7N4XEwjHXN8vLP1fnf5URQWgOJPm4BBQX2hKDFYQpnkJP3VtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238278;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fi0YROWxKAfCaR/6RwO5ahpQ059B/d1L1wzMqOaDnTI=;
	b=Y2lohxiIZtaQMXMA+6r01N9iMy3j6LVJ/FhOQ+tU8xIXqS24EYhsn5x+Db6h1nq/mGUc
	 w6dLgIhAsm+FuHCWUmkyyr8qgS3yp+4Cmf4UX/uGs7OZc5lWLPPlhAwy3dIgLCQwEvSnn
	 mFKOCDMtlicSca1ckFzCFEIlJR0pDgb23NKqaaP1PIrKo6th5+Fb5vecqP8fFYn9Y4BbC
	 yXmkv7+IorHjhMNW6YYv888WBxSLLfsrwxqJDcdP8Qgy2an+EuXyGE2dAwi9zk67wuviB
	 hFVZ8DBNgvQGZfw2wE4NYRHti7fSH/Z/m2WWSRx3uoOwIBSdM0ld53KhLm8/8EpJYVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=d27Okpss;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2D3606A31A;
	Thu, 29 Oct 2026 01:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F2D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=d27Okpss
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fi0YROWxKAfCaR/6RwO5ahpQ059B/d1L1wzMqOaDnTI=; b=d27OkpssG9O6lP1E7oerEdfH0g
	z7N/Rr5eBE9xEsAt2M6rs0WCWpqSmP1faavvIMguqsvRoZmSVPxCnfvxQB09I2F6PoKhXZrXdhoG6
	28w0z6d+Z3+hmeh9CSQDXVkqvvAA/13yKn5oR3LYaNrfXXLNJ1znSQIMmXS4Fjuh881mv0pjXqtxl
	d8VTscXgeXdsTJUHeYglj/o6VtJ4ocjf7GPaBlaW5HbFjnlBWjKC+T0exMLzw8KX2EgczukbsT+yJ
	SOPhPf9owCueDa9eNZ/gUB46zAc9MgjXS/e8udYx8TXrY6vZI14l0kz1N4c7n09RW83pL40VtyyLs
	B6PybQKA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMFBt-000000089ch-2gZz;
	Thu, 29 Oct 2026 01:44:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org
Subject: [PATCH] hwrng: octeon: add missing MODULE_DESCRIPTION()
Date: Wed, 28 Oct 2026 18:44:27 -0700
Message-ID: <20261029014427.2364317-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
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

Add missing MODULE_DESCRIPTION() that is now required.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 drivers/char/hw_random/octeon-rng.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20261028.orig/drivers/char/hw_random/octeon-rng.c
+++ linux-next-20261028/drivers/char/hw_random/octeon-rng.c
@@ -116,3 +116,4 @@ module_platform_driver(octeon_rng_driver
 
 MODULE_AUTHOR("David Daney");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cavium Octeon HW random number generator");
