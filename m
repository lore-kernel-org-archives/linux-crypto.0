Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FBC22301
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488205; cv=none; b=IDoDKs8fA/2knVj7Hem0lLGfn1neaS5+p55j1KLFuPR7MryCMdt9ScTfOpdBdwBfb5nXfyIziK2ywPsLdpi6UWTW5A4M3wqdZ6oQU+RyDtOIjCfOIP2HyLHDrgPlPC0fmmaAJOcPzzh+oEGpGFcur79964uv4YTUJbXjVhgGavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488205; c=relaxed/simple;
	bh=xfXW8JxR5BTCMer+XkDuiE8wayIwd2HRTA+ohm9QnoE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=TZ/rWxlMbfboQA0IBm33dAIxePCKtLrSuT3rvaSJz2MDojuvq0QqgA8HNPwiWzTi9afFYTirPzHBpYmdqA1fTEZ0eFydDMt1P7fSiOslFJX7lpf/o97fY1qeeJU0eqdajb/1R1EGM1ikSPeaHcq8ZE5LrRWoHCxxGcZFVxcUNHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FMyXlBUI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FMyXlBUI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rS4Zgm4PDBWuNkFIbpI/HVOAOWGpbKNwtHcMX+wk5Fg=; b=FMyXlBUIxIVj1zox5LghYBGOax
	NaXTuUSW6A5YjuxGUPHGm+pSSf7xBqz+6aneFRFO34E9hYsftr5V7CGwQlK9IUrMChUyc9MxGfr6T
	EyMwEvLwDgzgC+Z1vBn/G3h4MlXwe8KODXHOAL2i2i2/SyMYN6fCGUsOGrv02UDVQ78jpHICLpDK2
	27no/AKaaz1SPcJg5VMpePEgTmhCgBQZn6MsRNPYywRhur3N3+vMGnL3X8USmKMx0Vn2BE+35bDPj
	8epjsaJeWtfK9Wm8BcjMkKWrZiCF+Npo8Fl/hXKS9+5QCYFAFZSCDcqy+VOTKOrVmOivZn6EWHdUB
	yJc0DbMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dL-004zHW-1B;
	Sun, 09 Mar 2025 10:43:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:19 +0800
Date: Sun, 09 Mar 2025 10:43:19 +0800
Message-Id: <a828ace6ce7af8eb17819b9ca93d8a6dcec4ef4a.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 4/8] crypto: scomp - Disable BH when taking per-cpu spin
 lock
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Disable BH when taking per-cpu spin locks.  This isn't an issue
right now because the only user zswap calls scomp from process
context.  However, if scomp is called from softirq context the
spin lock may dead-lock.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 9b6d9bbbc73a..a2ce481a10bb 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -182,7 +182,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	dlen = req->dlen;
 
 	scratch = raw_cpu_ptr(&scomp_scratch);
-	spin_lock(&scratch->lock);
+	spin_lock_bh(&scratch->lock);
 
 	if (sg_nents(req->src) == 1 && !PageHighMem(sg_page(req->src))) {
 		src = page_to_virt(sg_page(req->src)) + req->src->offset;
@@ -230,7 +230,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		}
 	}
 out:
-	spin_unlock(&scratch->lock);
+	spin_unlock_bh(&scratch->lock);
 	return ret;
 }
 
-- 
2.39.5

