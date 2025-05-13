Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1E417FAC2;
	Tue, 13 May 2025 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128017; cv=none; b=e5cxmGgDcS++i2qnyb/OXGLsnTRj9vm4kNUVN7Cag8a+oti+aXqb9SBMA2JAUulQndZGbasA47L6XMrbXm3mrsj5xRrkUxfaR3XgjZlfLOY1JppW9YdV5RWESkrYJA06pFf0PUJ9YgmFK+tii//VPy2165sirNT/6TNdR7QkJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128017; c=relaxed/simple;
	bh=a3HdxlXncWI1w776qXRRfyOysZby/NwAboYU6kKpoBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sxq7CFVZi7NajK3i/0ywV0QkG27MZM6iAfw+D5fr/s20XBq6m5f6BJ1xp/BhadVLQ22Kr6JSa5bJmd57tNRP6JiutAtSy+Rk6OLeHo1O/JZub0i/6+ElRPzW/x7DLag0cQ3eB014/rWd7MreKVTEb7V9vBatDYAYLvFjFvgsBHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cet+Wo79; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cet+Wo79"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ujdQa38ajbtim3vKv/37DL30QUuxBtRR1SWz+JPonBo=; b=cet+Wo79Mk2Rq5JOvCFUb5ZOOL
	zLLcQDodIaxvX6NkNygY8RH9MlgLkHEVHQsd//TeHk8Xf17+NYpUCDnzGCrWYdKfH04++Xjq2APG9
	BSppjY+zMe0ibNULuipjvVjefzWcBRoKjRE/G7SxvNnHCmJnT9iAXcO79UP2yanexiK6N1Z9+sdod
	gd7ffo8/xFGrVRT8Zg8iHp3vUdNsGD3gdbCrJSSjG28AKS+LxSKR68SAjuByULWkAwb3+0VHxx4bc
	UvZR3KhTRmnozNdyFpKMEH+eOZrpyiyTEuA+HfReEdLuuv4IiF/6R6aZj96FRanoeMXnLZEuqL/NQ
	zKq+Vw8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uElo1-005iPI-03;
	Tue, 13 May 2025 17:20:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 17:20:09 +0800
Date: Tue, 13 May 2025 17:20:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCMOyWVte4tw85_F@gondor.apana.org.au>
References: <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>

On Sun, May 11, 2025 at 06:39:43PM +0200, Klaus Kudielka wrote:
>
> Here the log after modprobe, with the new printk patch:

Thanks.  I'm starting to get the feeling that the partial hash
is corrupted.

Please apply this patch on top of the printk patch to confirm this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..230501fe843b 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -374,6 +374,12 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 
 		memcpy(ahashreq->result, data, digsize);
 	} else {
+		struct {
+			u32 digest[8];
+			u64 len;
+		} state;
+
+		memcpy(state.digest, creq->state, digsize);
 		for (i = 0; i < digsize / 4; i++)
 			creq->state[i] = readl_relaxed(engine->regs +
 						       CESA_IVDIG(i));
@@ -393,6 +399,21 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 				for (i = 0; i < digsize / 4; i++)
 					result[i] = cpu_to_be32(creq->state[i]);
 			}
+		} else {
+			HASH_FBREQ_ON_STACK(fbreq, ahashreq);
+
+			crypto_ahash_import_core(fbreq, &state);
+			crypto_ahash_update(fbreq);
+			crypto_ahash_export_core(fbreq, &state);
+			if (memcmp(state.digest, creq->state, digsize)) {
+				pr_err("mv_cesa_ahash_complete partial hash mismatch\n");
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+						16, 1,
+						state.digest, digsize, false);
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+						16, 1,
+						creq->state, digsize, false);
+			}
 		}
 	}
 
