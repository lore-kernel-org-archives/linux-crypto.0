Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD651F95C;
	Tue, 25 Feb 2025 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473651; cv=none; b=lSgsQfmBUVon+gehO//LQdRNcgn1U7vjHwQMXo0QMG5yC4JrTHgiK+7rU0lk7nWxKGEgSg2q7FkRva745xXTgCrUuJNIkZyhh8RIB+iY3hk50DGZcv7bbkIoiXKctxFLo9oxlMPdbKVAi9x2ak2mVRS1+0nz3/BLFlqp2/QCO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473651; c=relaxed/simple;
	bh=yaXbbybvqdIZS5sCRuYjv1ZkyvR/QGry9ofzxyYxLFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mxt+AzGuSVeb0APKT+fK/30gfHxIImudU6bYzxMOpBXAxBBbmUqW54tSD0l+ZpmoKDpRe5JpdPAzG2WfBEWq36I7ekY7tPwlTkcHt68x3zKB26tPGAaBHG+h6pIhSGdbb6IVI1PI4oCKuOQvBdJZ/Ev2o4UBpbU1tM7QwtqRVp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MBQ0fVm2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MBQ0fVm2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m/uE5AbjUgTrqaB5TvMD0hL1QbOzaO5ZccZ+IZl0Aqw=; b=MBQ0fVm2AHhupKDLf2RD8erw6D
	89jeBLcCBDOXI4IOJH7xufAvPx8+87/YbUtM35d10R8wWycbobGy7Z/E2dHkTc/fmsmHmIwiKPtiv
	V9TJ6jRvdd04msxpx9Df/9Fr5CJpSJt9iLh2w1EFH28KdRNSMEYdAwELY/X/WC97PTYgJw19GlTbB
	4aS1hQXJmskPhqpPC58l/2Qdz5NZzLpmYt9W+lAnWMCZCc+HNf1mXcy9PhWd9Kf0lTFJFT3RM3du6
	vMYh3Hdns/Wn5AFTWPYoiJ+2vQxnepUBEmP/KM/CbrbeH51OoKZprvyyAsBE4ZpfE3XVyKIH6tNv5
	3wrQLmZw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tmqhS-001Xuy-0c;
	Tue, 25 Feb 2025 16:53:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Feb 2025 16:53:58 +0800
Date: Tue, 25 Feb 2025 16:53:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org
Subject: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Message-ID: <Z72FJnbA39zWh4zS@gondor.apana.org.au>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>

On Mon, Feb 24, 2025 at 01:53:21PM -0800, syzbot wrote:
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e9a8cac0bf89 Merge tag 'v6.14-rc3-smb3-client-fixes' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b667f8580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61cbf5ac8a063ad4
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a517ccfcbc6a7ab0f82
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8441f1b50402/disk-e9a8cac0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/65b1f8d2f790/vmlinux-e9a8cac0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1d6f6d8c3d6b/bzImage-e9a8cac0.xz

---8<---
Call crypto_free_acomp outside of the mutex in zswap_cpu_comp_dead
as otherwise this could dead-lock as the allocation path may lead
back into zswap while holding the same lock.  Zap the pointers to
acomp and buffer after freeing.

Also move the NULL check on acomp_ctx so that it takes place before
the mutex dereference.

Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/mm/zswap.c b/mm/zswap.c
index 6504174fbc6a..24d36266a791 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -881,18 +881,23 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp = NULL;
+
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
-	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
-		acomp_ctx->req = NULL;
-		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
-	}
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+	acomp_ctx->req = NULL;
+	acomp = acomp_ctx->acomp;
+	acomp_ctx->acomp = NULL;
+	kfree(acomp_ctx->buffer);
+	acomp_ctx->buffer = NULL;
 	mutex_unlock(&acomp_ctx->mutex);
 
+	crypto_free_acomp(acomp);
+
 	return 0;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
