Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="kjzYockN"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66A413E
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:31 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cf5901b4c8so32239235ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068851; x=1701673651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWDZyqBJhOVpYqYhwbudR4lRinTiZ1fIB/oQ8fHi3tg=;
        b=kjzYockN9LFJ6sx2k0sGTTv2ytJuV4elNRp7fBYMsUAQ9WMnE/5gs3P+8QSQ9lYcUu
         y0q54OvISdijCRal+GXbTQQM9k8P4lbgU7+Qi6cXrbec2Vy0BhNWcgObBZGenfaBM0pa
         WWfUkV5tBE3ALfJosouIAt6/wP/1T092eOP9/CmWzyHQUYfUK4BkAioZkNr2/Sly8FSm
         umWvG6sqhe0fLBciczQW2wL/PushexwwSJTU843BMvxw4DkiMzx+1G5AQJ7Ugi7Omh7L
         waH/IKc9Ewewq1bLR7U2nQWiX6+COnNYXo+fV/MpRKzFBgi9xpjCIy6jkqqN4dKvlNhK
         KIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068851; x=1701673651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWDZyqBJhOVpYqYhwbudR4lRinTiZ1fIB/oQ8fHi3tg=;
        b=RDJ0vB34FuWXY7EvAufgGtq8oHt43u95SmpgTIYOId2kgv1Vbyd/5Jqsob+fT9IGo3
         OJIqz1b46hjNHLJ8NzEW2Aow0MaoMPTbnmwyABZ9i82V8vJGnivezlWXERydK4SSYtdf
         x5SVi3mHkLv09Hv+iyRZ5up9Q4QyPqB7birp+jUM44FdjwkAJoilUzVLXUS/g7t0hGzP
         3GbhHlwlUzRCc/Z0JOBpz0A6V9RRVqLMxqn0MHG6ELInSlHZIbZyC5QerAa0UN81RR/F
         UTS/+cD0g/Xr/ShXPvIl+/WI3bLPNPAIkdZn5X7bE2jaHkMqsLqywCpcIDyk7DimRMFQ
         bsbA==
X-Gm-Message-State: AOJu0YwcURpubDhX5Jvdf/nO+BgiJmKF4jCD6mmfjKfe+KIEx39dJ5jO
	x1tFiDDDJS14kSM/d8g/C0Q0xQ==
X-Google-Smtp-Source: AGHT+IH+pvi642lKHelJCCdm6Sbw3UusLCtlqBwe0TaqWn+6ozeTKQf9INKnJ4k0xOSABXksoQFmKA==
X-Received: by 2002:a17:902:820b:b0:1cf:cd4e:ca02 with SMTP id x11-20020a170902820b00b001cfcd4eca02mr2699019pln.24.1701068851234;
        Sun, 26 Nov 2023 23:07:31 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:31 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 06/13] crypto: scatterwalk - Add scatterwalk_next() to get the next scatterlist in scatter_walk
Date: Mon, 27 Nov 2023 15:06:56 +0800
Message-Id: <20231127070703.1697-7-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231127070703.1697-1-jerry.shih@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some situations, we might split the `skcipher_request` into several
segments. When we try to move to next segment, we might use
`scatterwalk_ffwd()` to get the corresponding `scatterlist` iterating from
the head of `scatterlist`.

This helper function could just gather the information in `skcipher_walk`
and move to next `scatterlist` directly.

Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 include/crypto/scatterwalk.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 32fc4473175b..b1a90afe695d 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -98,7 +98,12 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
-				     struct scatterlist *src,
-				     unsigned int len);
+				     struct scatterlist *src, unsigned int len);
+
+static inline struct scatterlist *scatterwalk_next(struct scatterlist dst[2],
+						   struct scatter_walk *src)
+{
+	return scatterwalk_ffwd(dst, src->sg, src->offset - src->sg->offset);
+}
 
 #endif  /* _CRYPTO_SCATTERWALK_H */
-- 
2.28.0

