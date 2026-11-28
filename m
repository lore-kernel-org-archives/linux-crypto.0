Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840861;
	b=MCn/meFbm985iApEebHS9wWFezpUkf51Tq1s/2mZFolYUCi+SXGdHmUCoO6QSygjcbW6
	 c28d3rFIkPe88gsxxn13Ho9v6Fs0JBANb0ZxJPfgNTcKxDjzb2/D45X6HfhWmmuTgS9VQ
	 pzSero4C+hOrATfsSd7x3jp/2XkiSq0w8nXOeLoIUCglObRZdxB4GpDfYtd6/B/rm/V2K
	 fn0kl7//F1kHHAnFxWV0Uisl9aLFUvHv2iBc7gUH2iRGXk/AnVpYRmsKgMI0jO6gpSv11
	 5745YN0eSdSrDf4v9uD8+D1SA7SX+SU632PjLicKcG2IZ/m03+35hbvEXIyNM6+7Pjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840861;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+Us9tpfzzDLDdkUkSziqd+1j2O6M4UZEsHL8trtds4k=;
	b=4S85CEAYizRI+sJIDMo/NfGrOoPi9NO2zfbPrALRUov2N2sOrboAbCp99Kwe6uau98rR
	 zvq21IQgvOFUwaSy+5x88M9IE3uf8OQWJhdR9qPNhE3lH/VKjasKzIntUctpHgQY7f5HL
	 +q5hcVlFKqORKgtQH4WRXUzj1xo6ONusTdQgNNUUAnKf0G0QS024u0J7usca9qAzaIw7D
	 kJEjpO8Ms7ky9tIvxTmB7sDBqeOb0XAdOxbPRZtAu45r0J3t/wtoCXolc6evI40knN9mK
	 C4myKXmTXsRdB/ESHk5A/cDwweCZyzda5+y/7p+VoccMK04QpYPum8yEmvWvzdlmXLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uR0ptSFe;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C09606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9C09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uR0ptSFe
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b542b4d7bcso352622a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840860; x=1796445660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Us9tpfzzDLDdkUkSziqd+1j2O6M4UZEsHL8trtds4k=;
        b=uR0ptSFe3kesOQaBYh7tue6sJ6IxlWz4FtDG9WL0Z29hr1i36Q602tvfKHuhZh+PYr
         ERMrcjUB0U4vza9f8/qC4RhFRJh1gB3gsnGE5BfP/qCirpKxnqydWnH2/V17zju5yxaH
         laanPjn9hJlRXhOQPvDV/ACnf9lzGBiz9NI3QSYI9K/3G/9PJOhJmB0LECIX+kI4tXZw
         KG2CQpm+2rx9nZuUy31EGRF39l+io/+piKLAZBN6mSzieaejVF9BHYEfsmgPAXfRiNr/
         gjKcTHWLsZ+qVu2gtOGhbEgH5gzF1g9//JCB3DnikVM3qEGdeU58jbK8PNY6t1s6sYVw
         2dKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840860; x=1796445660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Us9tpfzzDLDdkUkSziqd+1j2O6M4UZEsHL8trtds4k=;
        b=okBjGmwXHaOnsXOn5r2SFS7kvz2nlY0fl0GVG6k/nqQiAr/f57FvnSzLjjFhTeSXuG
         IbFUf8jyn3nTJEf4IRuWuZkU7hugZYDHM78hMx3WW9EzsqzJqxy4QvnpDs8/hwRdOSNN
         9/N/JjSAIPBoMyXGoGDvDVbp9AIOwNpEE5n3J5JNQy4h171GdWQ3TxIBH1Z3k5qPEyMy
         4esOZWkFPA1csQYqgatzyulhRokDfwTHOivHytsiznyjAWq4r2ULzB8RtrLP2VGZKAMI
         x0EyZAFbmAnf25oVVjKMj15Ji3khPma4XAztBTmc+Lcf9YX3CB0I9q403jdDR0z68GUf
         QcBA==
X-Gm-Message-State: APuU4Z/LGHhkwObA7YxPtC0oF7eALGp7wwGvcsjl6+j9Qwzq4tZ07Sdw
	7IChKdjnKr/bzOxeToQOrmDTjU70pSoX08lrDKOpWJAKBs3ER+nwOYQtjso4Nw==
X-Gm-Gg: AZFdTZfPydkMw1cjxgit68/jprPXSm0JwLy4pD37axP6ikaVaf7ER2zRCV6//u5z/nm
	trR/rfUgNRvrdo7i/t1fc4cXITwkJZWfNWsy/ha2S2FhsHspQxI6AN1sj1rIhSzcl9hnjou1Szv
	1TrUoswhteeY3Qi4Hl9E8uQF7spfvFyGYqNvk1sRjwoU9NtXRX7kFCO1j7N99wyGGaxNvYV0gpR
	/wdhxxWCrFcD/yts0hL8eqHIlCrgZLA9iTdnbCTVIp6OJTRx9qI4E9ZmgW/wBNWLnkUPgX8Rcf4
	jSFLOm+pCR09b6WqtsV8ORyfF7pD5HnaGHFbs6ivaRtm8U7FBfBVKgpZJVzZ73gGASy3dh+xELo
	JKQ6sErdZDnp1ue4Ps3vv+/DrKCoN0cwjUBE1q95Xtc3HkJl0YOavJ5JdL4GUeaRWJN1wndch05
	cQNNvGurWT2rD/q2HovQ0p/wThHWqUp3Hlfy8BFdhmYwmu/3K/zshMlpyRy2taSeDAm1FV8Xg1T
	T/17hW6laqTSCI15g7jbw4LcCxkM+ZOS5KaACrknfVUyzc/tNK5fB9l+EaNiPOUfveBmxLeeFhW
	sg3Z/wVb9gXiUlGHf9jNK6uwsv6gUFs6Zapn+r3tMQeC7B9PF89hHJmCrfDPtT4+MRatgTqfMSz
	MsC4EM8Jy91c6GKYy+oykX2M6z3cfwtSsfRp6+eRHHuPFJN70yPKejbgHWF3i0fY01eCNA7+JOj
	6xNA==
X-Received: by 2002:a17:90a:d607:b0:3ac:9e5e:d195 with SMTP id 98e67ed59e1d1-3b41c9759a5mr25096820a91.61.1795840860227;
        Fri, 27 Nov 2026 20:41:00 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:59 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 5/8] crypto: cesa - keep the chained IV on the non-TDMA cipher path
Date: Fri, 27 Nov 2026 20:40:47 -0800
Message-ID: <20261128044050.722617-6-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
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

On engines without TDMA (Orion), a cipher request longer than the SRAM
payload is processed in several steps, and for CBC the engine leaves the
IV for the next step in the SRAM context area. Since commit 2786cee8e50b
("crypto: marvell - Move SRAM I/O operations to step functions"),
mv_cesa_skcipher_std_step() copies the whole operation, original IV
included, to SRAM at the start of every step, before the copy further
down that rightly writes the full operation for the first step only and
just the descriptor afterwards. Every step after the first therefore
restarts from the request IV, and every CBC request longer than 1920
bytes (with the default 2 KiB SRAM) gives a wrong result.

Drop the redundant copy.

Tested on an Armada 385 (WRT3200ACM) with TDMA disabled in a test build,
against the software implementations: CBC-AES and CBC-3DES results were
wrong for 77% of random lengths up to 8192 bytes, i.e. all of those over
1920 bytes, and correct for all of about 38000 after. ECB was always
correct.

Fixes: 2786cee8e50b ("crypto: marvell - Move SRAM I/O operations to step functions")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cipher.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 3fe0fd9226cf..fb9ea9623746 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -91,11 +91,11 @@ static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
 	size_t  len = min_t(size_t, req->cryptlen - sreq->offset,
 			    CESA_SA_SRAM_PAYLOAD_SIZE);
 
+	/*
+	 * The op is copied to SRAM below, in full for the first chunk only:
+	 * later chunks must keep the IV the engine chained there.
+	 */
 	mv_cesa_adjust_op(engine, &sreq->op);
-	if (engine->pool)
-		memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op));
-	else
-		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
 
 	len = mv_cesa_sg_copy_to_sram(engine, req->src, creq->src_nents,
 				      CESA_SA_DATA_SRAM_OFFSET, len,
-- 
2.56.1

