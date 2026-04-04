Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376F023183C;
	Sat,  4 Apr 2026 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775262620; cv=none; b=LeIvM/2rwfp8FGuBvzNKSRWJRIpag6EQcYVUwItCYU/swQd92DpAUrVS5Xn2DQu8ULzMtr7Q4s8Y+Sex21KvhprJ8Qcgdor0fUBPU+xkoWr85TSVwkRimxxfqX175MwtggOuZti7sC1cDFGGtSLbZ2hDnAYaRQh47tG/TFuZqJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775262620; c=relaxed/simple;
	bh=qS9F9bHbKyBQFiGO+TNG18mEWPxq6OtWf3yMAdne4hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNWEeKAB87FwMwbbPYkqrXHZMwZWATXlw9Sj4GHDxPn6Uo2nwrECMdeOG0JYdF2fJvm8sTuavU66BRIlG97HQKWOqM+etL96G0wsHePmJeze0xxOIN7gUrs/BHv5Gyy+CMXIyMWq2qENdu6GB3MNp6oZW9Nc/IRN5zf2517r0mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RPQQ6zvF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RPQQ6zvF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bARN0m3W0ksLlQYWu2EKoor0GR42vnQQ1rDyGFLdAGg=; 
	b=RPQQ6zvFtsKFd1FiVPgpv7+N3d38LqZoFGjc+G/SKonrNfSyPqTTdMD/hvVgOFt+TuaEUrBR/mF
	u1mB2yP5EH/7j799130UXL4+IZjkb1EVZxUc54DQKJvIWrKXHZbDYNyn4Gz6GhnGMXWjiGADqrrXm
	p5zkCYdcF+kx8y+65ciEL01lG6iPWB+5Bgp0dUDcgt9hez1r/kLXVt1saK0Tr37ArQQmPQE7Bb/DJ
	gSeEuQkEyVwuLJF19ZTGXZHAhbR4/5kn1SCm4eiUStW/GzEqOXu7sOtGyIQmDMQda6ZX3c4Nx0VAB
	YjJposcD5cWav341WmXZcUPCyPRGXHCtdNNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8oUF-003hc2-1q;
	Sat, 04 Apr 2026 08:29:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Apr 2026 08:29:58 +0800
Date: Sat, 4 Apr 2026 08:29:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: af_alg - Fix page reassignment overflow in
 af_alg_pull_tsgl
Message-ID: <adBbht8ERe0z-z3B@gondor.apana.org.au>
References: <69cfeb9a.050a0220.2dbe29.0011.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69cfeb9a.050a0220.2dbe29.0011.GAE@google.com>

On Fri, Apr 03, 2026 at 09:32:26AM -0700, syzbot wrote:
>
> BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:131 [inline]
> BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:162 [inline]
> BUG: KASAN: slab-out-of-bounds in af_alg_pull_tsgl+0x1c6/0x740 crypto/af_alg.c:711
> Read of size 8 at addr ffff888079ebbea0 by task syz.0.17/5997

This looks like an old bug exposed by a recent change:

---8<---
When page reassignment was added to af_alg_pull_tsgl the original
loop wasn't updated so it may try to reassign one more page than
necessary.

Add the check to the reassignment so that this does not happen.

Also update the comment which still refers to the obsolete offset
argument.

Reported-by: syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 437f3e77c7e0..dd0e5be4d8c0 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -705,8 +705,8 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
-			if (dst) {
-				/* reassign page to dst after offset */
+			if (dst && plen) {
+				/* reassign page to dst */
 				get_page(page);
 				sg_set_page(dst + j, page, plen, sg[i].offset);
 				j++;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
