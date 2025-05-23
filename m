Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32390227EB9
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 11:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748000484; cv=none; b=LUwFigCed/+li/j93V6nASsRJOGr/Tn7heSNsRqzfDlrq67A99wCFtMqRRa/Oy6o39H6TGzxVM+r6/IwWRZTvECtKR03yuf6yHNYAChLJv9i7JjT20Iuev/IqcHzq/6AEPElVthzg1PU64/SR5OfDQ2GmQ1Z+1REGmrsvUbtdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748000484; c=relaxed/simple;
	bh=2cOCArNnzGtKd6F79959zZ4PwMdaEQ9xJtNviT2Roy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LekiRrp+RZAlNiFaY3VkrvJtGsoVj0KtBYSucQorfgI0JgDrFT3yKrp662kIbeB7yBGrrSPRusx/QWAgv/VTA9+5DF/5OZXCWQJ0G2sfGu8NhtpdVl9gjZeigqd4id9MZWq4CabXwRFLToeLQjbK3cwf0DSXvxANBpt2mYibPiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Pikx6AVZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Pikx6AVZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J/wylu1Zfkkvds5l3vVMskN8QT14QEihHGxYdRDqs9I=; b=Pikx6AVZbeChU/43GMioI+77L7
	kEOJWRjNvavkMFUkWoLDP51M4zrPi5VIDSclM2CP8HoNDhby124soGDPlCTHIxUrn05klOqSEJ6Ig
	o7GT7GXvLrgb2G/BH895VGqCxIcX2VhuBaO2sQfadLSk9YLOo/AGY4rpw51JOvxRnBjI0e6zFhItL
	p9I9ZUq+hNHglWDmAGtzzXHR26AySoUIm8ffSBwDqfDQLvr8802YQKT5tgNp44tALrth4QAo1KflN
	gjW2WEru8GFUchbTbo4qx2otd2hJ4QXCKEnJJXHb+XZsJ3W7xVpk/0C9Ht8sn32OhT2CDfIR2Bg7L
	aUY9OhwQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIQm6-008LB5-1X;
	Fri, 23 May 2025 19:41:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 19:41:18 +0800
Date: Fri, 23 May 2025 19:41:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: CI: Selftest failures of s390 SHA3 and HMAC on next kernel
Message-ID: <aDBe3o77jZTFWY9B@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>

On Thu, May 22, 2025 at 04:13:59PM +0200, Ingo Franzki wrote:
>
> May 22 15:59:44 b3545036.lnxne.boe kernel: alg: ahash: sha3-224-s390 test failed (wrong result) on test vector "random: psize=388 ksize=0", cfg="random: may_sleep use_final src_divs=[<flush>100.0%@+2585] key_offset=82"
> May 22 15:59:44 b3545036.lnxne.boe kernel: alg: self-tests for sha3-224 using sha3-224-s390 failed (rc=-22)

I have no idea what's going on with the sha3 export state, perhaps
the hardware just stores things in a different byte-order?

Please apply this debugging patch and send me the results on s390.
It goes on top of commit 0413bcf0fc460a68a2a7a8354aee833293d7d693.
If you've already reverted 18c438b228558e05ede7dccf947a6547516fc0c7
you would need to reapply it first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 737064b31480..42aaf2e7c164 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -158,7 +158,7 @@ struct alg_test_desc {
 	} suite;
 };
 
-static void hexdump(unsigned char *buf, unsigned int len)
+static void hexdump(const unsigned char *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
 			16, 1,
@@ -1485,6 +1485,11 @@ static int check_ahash_export(struct ahash_request *req,
 		       driver, err, vec_name, cfg->name);
 		return err;
 	}
+	if (!memcmp(driver, "sha3", 4) && memcmp(hashstate, vec->state, 200)) {
+		pr_err("alg: ahash: sha3 export state different from generic: %s\n", driver);
+		hexdump(vec->state, 200);
+		hexdump(hashstate, 200);
+	}
 	err = crypto_ahash_import(req, vec->state);
 	if (err) {
 		pr_err("alg: ahash: %s mixed import() failed with err %d on test vector %s, cfg=\"%s\"\n",
