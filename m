Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56025305E28
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779549113; cv=none; b=M+L/niRjfO4ADHdPgoEZ7UXpCohxqVFGeGln+pm0KLKpioD9fygwJAJXDDGuu2c1QPcMv+gOvrJqfFY/QrXQNfo5jfALIPrdW31tTje+Khc5epCiCxZgfRTIm1+oBScRtwVAjVIOURMrROrxnmrThkPkiZp7V1aYMZqLP4CqcM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779549113; c=relaxed/simple;
	bh=JJhs7PUZUuC935hqyCTc38KzzpT0bwtRxfLZ6/wYq/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC96hHkKMvJMw6wesUQ2uHdJe/0yzUN+3CJJ6oLGNqvmJRnTusgKHnhmcU1Zj6dQPpMBbxZp+cfL/ej8LznMq/hLwkasKiRfgwFgFL8IhFRnzEUHeuiZuYzPnDykJWJP5+H2BRfJH69s4x4aFzve4aAS6cf/bRkd/uAwU+gXMn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyS8qk7+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyS8qk7+"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-449d6c68ed8so4808605f8f.0
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779549109; x=1780153909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVuj8i39CNd2OnE6+LZlzBZ3d9svD8GeaE/Z5pzjuck=;
        b=kyS8qk7+e+/jh9vT5X4AsJ80OeRe0Y9IYHdvMqsXgKipx3NBGg5dS+T0IiM3MajzxV
         0uglI1yMF453tk3OSI6z22xjchQbJQsl4q2L9pV6xW5uD+c+qYM3XEsBdjHy/qouLTiQ
         CywY/VlNfSHdl7fRj/yJz/cVQfR03uXWSNqD+WXSN9b2gelmbP+JSxktPvafQyEdMfoZ
         DgJKChEmqYv4qBGAvRNZACbRkZXXz9P2LHA38KwVJOJvnAmPYjWEE/jXYL6VSoVaXEt5
         fR1Fx10DtVy1IsoDtBg1l5AvdukIVGSMPK3aEireQW5R0haZiSjbI4lDMSAHGTkLOixu
         Wy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779549109; x=1780153909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GVuj8i39CNd2OnE6+LZlzBZ3d9svD8GeaE/Z5pzjuck=;
        b=BsjwjZgzZnlGcDOg/tLX3zveOlv+UFIw4QE1G226vVfOwsW2FN0k9HKs32fbew0H/E
         HfUkXkN856jAf5ItA1bom3jnyTVtOADwmjXmnFeTC14OtWXB9QNTntEEQ9vsJYhH/u8U
         p/9xsorX0WYgv7pmQ1PfdOCYgMTpofE+MpbSPO+GHyFrs1dy1dq2cYfhavY2ai286jCs
         MfDBon7cvqUdUN2HID9MLs3F8WgTnDU3fh5NCHYZbdu5Wgmq5LkDwlA5cfzMOJrk5h/S
         LWBQf4CuTWXZSr93ex9iqa14i7Aiam+/WKu2CsW/3eEbaJ9cOPakUNR/WWfdp8+I0+Mk
         N7pg==
X-Forwarded-Encrypted: i=1; AFNElJ/8KOmoKDOs+UAiVXcNyCEdYux6oWJTBb0XUcFl0+Mv9GjSfCn06F3nR+G74GRsXDP9bnvQBmfYgRpyOW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHY2rM1gejhF616mUQjEGYAiWsKZKvycrul7F6LVhsA4WdJMeP
	DXwMg79tDf0VxUL/2ELy8vLlmcCaBq3NYUgywXCXTKjwdsWJ0N0v+FTp
X-Gm-Gg: Acq92OFn1WiSzokfoJzf34AIRLyyWZkteJcp2JOouz43jj+Ja0ORGLXZo/zVYvXAcJV
	WHQ6lz9g1aNRjcws6srHETjQSyFjOQF3w24XY+E57tPm4Ndrv6FnUyZ1gqOM4ocO66fo7D4ZP1X
	YXGHt12+Q0RLvM+y0vbfoevxGBMUeWp8yoFRtnp8rNb4uU+2b0pFRh9jneZaK1GRPUg3s06BbRV
	SaHjv0q3sXYWE1xEYy/kn4NKcIOLPUXIMdnmWY9tcDRGmwIaHgqJ2Uw7+kQuyy77t9yct8zJKJq
	cO4XgpoObJFaOtF2IJ4TuV6djrGV1xmIM/zlyMhTb3OHy3fUf8trxfdO8Vq2zogbALobxbw5D87
	iSoAEPCzcPyZUtbFfQK+V5V2lbLYM/fz/Pyt5KuD8ezpPCGv8fpMyowDUurTKa+EYXnzjzGdvmg
	ZijCYfZ9mSOhclfXXeNo+ynK0v8yyWqRTO
X-Received: by 2002:a05:6000:26c3:b0:45d:b14b:23fb with SMTP id ffacd0b85a97d-45eb369c7abmr13363260f8f.11.1779549109378;
        Sat, 23 May 2026 08:11:49 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:36:c98d:902c:348d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d7167dsm12629156f8f.35.2026.05.23.08.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 08:11:48 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com
Subject: [PATCH 0/5] crypto: talitos - fix rename first/last to first_desc/last_desc
Date: Sat, 23 May 2026 17:10:43 +0200
Message-ID: <20260523151048.14914-1-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <2026052212-aged-amply-7bd8@gregkh>
References: <2026052212-aged-amply-7bd8@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a1b80018b8cec27fc06a8b04a7f8b5f6cfe86eae
was backported to 6.6.y with a866e2b1c65edaee2e1bb1024ee2c761ced335f8
It renames last to last_desc but misses one occurrence which leads to compile errors on mpc85xx

drivers/crypto/talitos.c: In function 'ahash_digest':
drivers/crypto/talitos.c:2204:16: error: 'struct talitos_ahash_req_ctx' has no member named 'last'
 2204 | req_ctx->last = 1;
      |        ^~~~

Instead of renaming req_ctx->last, commit 9826d1d6ed5f8 ("crypto: talitos - stop
using crypto_ahash::init") should be applied.
Ideally before commit 00463d5f864a ("crypto: talitos - fix SEC1 32k ahash
request limitation") to avoid any compilation breakage and ensure correctness of
the code.
 
> > Greg could you please backport the mentioned commit to 6.6.y in the correct order for the next update?

> Can you send a series of backported patches in the correct order for us
> to apply, so we know to get them correct?  Trying to dig out from an
> email like this is usually quite easy to get wrong :)

Hope this is correct.
Goetz

Eric Biggers (1):
  crypto: talitos - stop using crypto_ahash::init

Goetz Goerisch (2):
  Revert "crypto: talitos - rename first/last to first_desc/last_desc"
  Revert "crypto: talitos - fix SEC1 32k ahash request limitation"

Paul Louvel (2):
  crypto: talitos - fix SEC1 32k ahash request limitation
  crypto: talitos - rename first/last to first_desc/last_desc

 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
2.54.0

