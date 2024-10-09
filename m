Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F2A18C90C;
	Wed,  9 Oct 2024 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728462881; cv=none; b=GyDhRvt6Vk1g++WN7bN6RXkBVSNHy3koTYREtIQJjZbgBfNFWE14L613NlUKcwx9Ap+MPRX16Sgmp3oIrDZWnQIgRJmMjIBwl44sDOIJhO7f/IgOCOst7HVCHQ6uTcZE19afMzAnnojqRUfxCvJwwmE0eSnpCkdYzu+WeUYwlNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728462881; c=relaxed/simple;
	bh=DURfCzNm14S3kcD36oPUwdwkaRsCbyoEFVmAg+zXraQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvPrxZaTlFlQILOADsVmzPC36yzKqxtoPTU13OdRIyb38k5uFw9/TMUQ53Xpgwi/NFjLL/KUcU0Hu0sQcLSUaD7dD9dlXcAp9nAd4RzvcQ7tZ2c/ToQJsHcU8DOptgJOgu/N/IVz2rdDj980fsGV3E85IbkYDcC87bqR/j1tPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TS6vRhlq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TS6vRhlq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PtwpbRKWqxB2jBjhgHzQ6zioERMfziYSGMTo9/kJ2vQ=; b=TS6vRhlq5SNkoce/bP7O1M8E76
	PxYUMUtbhzChqYCRvFZDrdd7yARkRdDSZnozcoNr/Iokauy2kn8Q3zjWc+LQWWQ8HSXxPhqnnybca
	HPrzUFVJEkNUrqwcxhM3edJnZ63jm6lMM3emzpQlh6p+vXLy50Po/lTBBPWI0izATqKHv9QK9s6Ml
	MRXJSx6I01BAVKXbLnf6hKCH9TSwqbyMkFsAq4YtKNacX0LmQdp6wwKqvSzRdoY593cp9CMw35vXy
	VR1qoe+1swhgdIb2S70TrTzyxWPG3ph+y2qsxFqxXVQ6rqR4kZEY71ACJ2AsZs+ABOh3sBj+j4So9
	rd698BtQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syRzS-007yYc-0Y;
	Wed, 09 Oct 2024 16:34:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Oct 2024 16:34:27 +0800
Date: Wed, 9 Oct 2024 16:34:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <ZwZAExmK52txvHE8@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>

On Mon, Oct 07, 2024 at 10:57:00PM +0200, Klaus Kudielka wrote:
>
> I would be happy to support development of a fix, by testing on my
> spare Omnia.

As a first step, please apply the following patch and send me the
result kernel messages.

> If the above is true, the only other option I see is to declare the
> driver BROKEN, since existing CESA users are likely sitting on a time
> bomb. Some file systems do use hash algorithms, as far as I know?

I'll send a separate patch to disable the hash algorithms by lowering
their priorities.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5fd31ba715c2..d1f069169f82 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -127,6 +127,8 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 		if (!(status & mask))
 			break;
 
+		pr_err("mv_cesa_int: %d 0x%x 0x%x\n", engine->id, status, mask);
+
 		/*
 		 * TODO: avoid clearing the FPGA_INT_STATUS if this not
 		 * relevant on some platforms.
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 8d84ad45571c..ec4e9db1c8ab 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -167,6 +167,8 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	unsigned int digsize;
 	int i;
 
+	pr_err("mv_cesa_ahash_step_req: %d %p\n", engine->id, req);
+
 	mv_cesa_adjust_op(engine, &creq->op_tmpl);
 	if (engine->pool)
 		memcpy(engine->sram_pool, &creq->op_tmpl,
@@ -397,6 +399,8 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	}
 
 	atomic_sub(ahashreq->nbytes, &engine->load);
+
+	pr_err("mv_cesa_ahash_complete: %d %p\n", engine->id, ahashreq);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -418,6 +422,8 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
+	pr_err("mv_cesa_ahash_req_cleanup: %d %p\n", creq->base.engine->id, ahashreq);
+
 	if (creq->last_req)
 		mv_cesa_ahash_last_cleanup(ahashreq);
 
@@ -796,6 +802,7 @@ static int mv_cesa_ahash_queue_req(struct ahash_request *req)
 	engine = mv_cesa_select_engine(req->nbytes);
 	mv_cesa_ahash_prepare(&req->base, engine);
 
+	pr_err("mv_cesa_ahash_queue_req: %d %p\n", engine->id, req);
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
 
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
