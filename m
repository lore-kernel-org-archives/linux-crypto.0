Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5234925BAB6
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 09:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736506; cv=none; b=ItwQKG8kvJsfwzP1uy1ovDW48LEOnVMwRoIppsjVObgBUyC2b5eiyGjar/DqkvSVEFUOcruuoex5cL2EShORMIyd50kq3BDkGRH4ymHAbZ8UJuD/baGa3ygOjbiC/JIzE4G1g2nPzFbMDgfk0ycZAdf2kY0LkeFf91trF43t7yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736506; c=relaxed/simple;
	bh=nr4ZJKmMxW2kSu9quhR0LwpNMUi464HkdZUnkApTtrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8u5tmqKxYWqckZ0odDyQ/4iXdhT9bFVgXR0ASl6lRX3QOIix5uQVTo/qGNrnrt1TAs6eq1H88b/9srNdOjY2vCZrU/UnGxzO+ctYYr+k4IumGzOCVOKUFUkXTWjqH3qJY1FmsKXH1jfpPVoaKMA7vXaM27Lrl4ezQPxqt3y/3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=A2OX01+o; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="A2OX01+o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3QxnKmPCIrpbafs8gtBdhqxy0ZPebazEt9nrU8BgjK8=; b=A2OX01+oOL3q4Tt5zHvZlhhlf5
	h37RmCKoUNihQQFTL/Kymqg0P0VJlmnFmQrwsLhyOY1MLaV9uH1UxDZaqea5t1Iw/E8g1DpvVxRMK
	g2kA6FXbCvNUFHJHWy5wZ1MtSyAt38MqWRpFdYKYqedWcVwDTIlU6twN1TavsExoQg2y/p7ILnWCZ
	KvmK8XXdX+S9XfREhdAmmUanD1arYnll5tf62o0VVjCkVwTgQZs2W8sr1asiN2yWJBNCt7ygVym2N
	bGQfrd/1UdMBTn/XgD8V+XsnvL8WaddXl0OZ13LBh9VfFD6Fkn8zC8wJWZ9spkLzDQILTgZptB1KH
	vvOF/qWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnx53-002XTu-1H;
	Fri, 28 Feb 2025 17:54:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2025 17:54:53 +0800
Date: Fri, 28 Feb 2025 17:54:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>

On Fri, Feb 28, 2025 at 04:13:08PM +0800, Herbert Xu wrote:
>
> I'll respin this.

FWIW this is what the interface looks like.  Does it look OK?
Longer term hardware offload drivers should handle these non-DMA
pointers directly by having their own buffers.  For the time being
I'm simply redirecting these to a software fallback.

diff --git a/mm/zswap.c b/mm/zswap.c
index 2b5a2398a9be..2fd241c65f80 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -994,30 +994,16 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	/*
-	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
-	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
-	 * resort to copying the buffer to a temporary one.
-	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
-	 * such as a kmap address of high memory or even ever a vmap address.
-	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
-	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
-	 */
-	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
-	    !virt_addr_valid(src)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
-		src = acomp_ctx->buffer;
-		zpool_unmap_handle(zpool, entry->handle);
-	}
-
 	dst = kmap_local_folio(folio, 0);
-	acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
+	if (!zpool_can_sleep_mapped(zpool) || !virt_addr_valid(src))
+		acomp_request_set_nondma(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
+	else
+		acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	kunmap_local(dst);
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 
-	if (src != acomp_ctx->buffer)
-		zpool_unmap_handle(zpool, entry->handle);
+	zpool_unmap_handle(zpool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 }

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
