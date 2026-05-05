Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D94BC011;
	Tue,  5 May 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003650; cv=none; b=oEnFQJhIa8Ys52WMascAWW7xb7W/ztF2Mj0dBeT2BBvWWg8ZvoyBEOQnvs9UVxyAuV50Pfdj+irUifG8acdQ+JDym25IrzvChmHYY58xFncJ707GU7NzMOkm09RtowvkfpUhOo62ImUGXi4ICT9X/q+AhEBCJ/9Ja/PBT+x1NSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003650; c=relaxed/simple;
	bh=cGFtgo0CIneYft26pq9frkKi1YpE+xAQE6MAWw9sMmU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jgiSWXvRX7/smQoOaBhHAv7JfImxMPW2SDVi01D3yrqikwC5bwxXCdFhstC2+4tRRMdReK1kmPkeYHqa05l05xEkwM6+xzbx6gU5DjuCF0JBCH2oZNiMjBDXF+sqGQmGW+soPZc3t1Gcm+JOPB3OfnIEvd3njmm9FMZ+qco4zgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=0JcXFFLp; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="0JcXFFLp"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 20C8FC5CD66;
	Tue,  5 May 2026 17:54:54 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 35DC26053C;
	Tue,  5 May 2026 17:54:07 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5F6DD11AD0419;
	Tue,  5 May 2026 19:54:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003646; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ZpnQUXWUq73ELudmYQPs1N2edbD7ZmXBu8vaxfEusmQ=;
	b=0JcXFFLpc2mcFKNtctLHftsQV8GLZMXeW3BH5nbpBsYwrT9LJEvj6w93TbbOuKG4PrTXOq
	YWT4HLYujC/lWpbIbX2jIwv6j4vhAOopjyjtjzTnjMlD2EfGI2nf6JhUrv1+6GA2zCGTu0
	jxpQ2x1jd4QPIomYeftStrr+aQTgui2H/IoRqi3BKG4FYClVUVUytYpFQIn452TpP7nsnU
	4LtPhVtmm9DQWyfOjRJHYOjecjbh8CFy/8Pa72a+CiwC54tO6rpz2PhBFGQYqJu8K0EWGg
	0MmYPhSxNRJ1JHB2xIkvaYeGLYvtjUERqcyRRNl/pZklun5zYN3N+qojGdNvig==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:13 +0200
Subject: [PATCH v2 12/12] crypto: talitos - fix invalid submit_count
 initial value
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-12-5818064bd190@bootlin.com>
References: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
In-Reply-To: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=1086;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=cGFtgo0CIneYft26pq9frkKi1YpE+xAQE6MAWw9sMmU=;
 b=USC1Hgq/0B0WglVQceOviDvRDBQ/+0qy4t1foyQAu/Ywogb7wiQrvMzWlxjteAGBW3lhngkwK
 +D1QQ8mYjFfCtN0fjj2akX/ZO2H396hTKXAClDHLbsBzHASUmXF+pL1
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The submit_count atomic counter is initialized to -(chfifo_len - 1), but
since atomic_inc_not_zero() rejects increments when the value is zero,
one FIFO slot is always wasted. With chfifo_len = 24, only 23
descriptors can be submitted before getting -EAGAIN in talitos_submit().

Fix by initializing submit_count to -chfifo_len so that the counter
reaches zero only after all chfifo_len slots are occupied.

Cc: stable@vger.kernel.org
Fixes: 4b99262881213 ("crypto: talitos - align locks on cache lines")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index cdb6823d7038..6a5b0b053479 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3566,7 +3566,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
-			   -(priv->chfifo_len - 1));
+			   -priv->chfifo_len);
 	}
 
 	dma_set_mask(dev, DMA_BIT_MASK(36));

-- 
2.53.0

