Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3841EFFA1
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651961; cv=none; b=hQDDqssk2408k3R0ecsIj+bUd93M9T39eqAdqku7wO7RwcQa88lUzpSl0B0tEz+4JclpxZNPF4jMxU9iJtPAj6D0q0dwojFD+NEKvYT8wpQjDex79FkVKGiZvaZD4Ef+kKRsXpWfGlvqZfqWpGVMILEwdT71i88ykYEddQzuohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651961; c=relaxed/simple;
	bh=IxzE01Z6z/9URguM4aBzxWHBPb8eJreZXthAH0xGgX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1f72uHvhLT/xS02PEnjc+bWG+LYOJHcWk2LoFg3wbEz0nz9lGpfO5iWEtzIHqH2+TXb/QjCMc8xhZCz2gdQJh6OObNxp09G6I/jQeBW/c8J6BekvbibS7v4BGisjHlNGnM1von4F5b5ANDXXs8ecPofm51FznBCghMDlD2YAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHKs6AUU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHKs6AUU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ba0fc8b1f0so64280285ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651959; x=1780256759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngfJ4S0HLLbnVGnzJRGuSetDpPWqvEm8s3fR6sruCTU=;
        b=AHKs6AUUDC+VFhe5coMchPTk1YoeLLVuH0cc8QZ2eZEpeHeBYEd+zeRSyJCqT4SW7f
         N2H6f8ZruCH/a7pD7yBBH9/cCSepMwkuG2I562reIRrNKNsS5akvQkI0uTZLFoyFJQfY
         Jpnu375HU+zK3l4ZYsM8gNnHckS+IKeSQYPVByaBike5ebnYvRDqTPrn07TjjfQYwEt2
         R3sP1vXGGWJISRzmXmVaVPoj/mF4Nnmdx5BjA93+IOybdCTwtvZOKZB02jz8z/u6At/x
         xXEH2yJsfqtl3I1n23yWqclmXiVMqRs9Sv3qj2CA4i+LjUnkNZQR+VDGXyfJRWZsVHfG
         oclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651959; x=1780256759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ngfJ4S0HLLbnVGnzJRGuSetDpPWqvEm8s3fR6sruCTU=;
        b=GCNyPGDk1OU1sjtvMAbhb6XQDQDQZ2NH9gG05dE4x+ltB8ZfAhg/i9+fGT5ew1xHHw
         4IOt6NgHvmz2DfRR+QbQbVDtOs8ur0D4MOuxP1ql5N0twG6pOyMTazg5BC0j/RCpHzuW
         nz6kjKsTcNZc34XSTZib6G++W1DEwNEoXUYfnW6ZwtMSlXtTGXP7I4wU97PxNswYkIuH
         jbtwyK7c3Jqm/OSSz2FkoMqZhDSlWWAaDPWQF/SVxfp3rb3Auf4e/KXbw1wIUlNuHgxV
         3yOSS9jx2doX6ZAVVNNKov7AVKLQESVArnBckMTu+YcknEeKdo0knOqFbfUg/cTZ42TU
         72Tw==
X-Forwarded-Encrypted: i=1; AFNElJ+CAPpfUOkfAeEtO0xliwp2qRvbziQxMiUZ6d8f7/Xs2VFUiAln4Xdb9Gh4chLUsNF/ckaBnlor8qKq8/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTAwrxlrc9MlS8+oHUQaA2A5iqjQ0E9vwH35YPtZgMXdIAqXaX
	ghPK37+BtNchwGiOYUcxUka1PztmKJLI2VNEkfSoj0z/jQwcVVbORTr+
X-Gm-Gg: Acq92OGuqcO2I1H2yvEAphlbhhp1caBIomiNUbZmVA+piyJx3j9AwicGLx4ShKMRaa+
	YDHRkaErm1V1gwMmxmhiOO5m5wpXJvoDlTtWGyfpz8RG1yXOm8IfLZmAQs2H42lQ7/ij8ZIeo3N
	7EpTnAPfXDFOSe8VWYa6O25HSlSIEACKjZD7uTxYWKXlleeW/VdWDz++6AKGJnRnpZjQjjN+3CM
	aRZkkJkogh2+kChPtG2WqoUL4zJa8E0naEGKnM84w/OKrrItFbtofr4bBA+Y+WMIFLe/UksiKlL
	8DtR2IfGZL1br9RaRTFffq8rrg6ryXzbAbgid4r/JMRD9qhmlrLfcJx6+LrWzaiP3FK2/SkgZL0
	SCT4DcaPBUS/J3uxhupfO19SlOVUwrRSZvYm+B1OazRfrkfzE8lx+oB9xMtoC7HOaVykXMo3rS3
	ucnXQO90D8NJPVgohq1Lkrwmwg
X-Received: by 2002:a17:903:24c:b0:2bd:9067:58f with SMTP id d9443c01a7336-2beb067480emr125078795ad.22.1779651959544;
        Sun, 24 May 2026 12:45:59 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:45:58 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 5/6] crypto: eip93: order result descriptor reads after PE_READY
Date: Mon, 25 May 2026 04:45:27 +0900
Message-ID: <20260524194528.3666383-6-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260524194528.3666383-1-hurryman2212@gmail.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The result handler polls ownership bits until the packet engine reports the
descriptor as ready. Ensure later descriptor reads observe the DMA writes
that completed before PE_READY became visible.

Use the value already read from the descriptor for error parsing.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 276839e1a515..e3bd28cc0c67 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -224,11 +224,14 @@ static void eip93_handle_result_descriptor(struct eip93_device *eip93)
 			 FIELD_GET(EIP93_PE_LENGTH_HOST_PE_READY, pe_length) !=
 			 EIP93_PE_LENGTH_PE_READY);
 
-		err = rdesc->pe_ctrl_stat_word & (EIP93_PE_CTRL_PE_EXT_ERR_CODE |
-						  EIP93_PE_CTRL_PE_EXT_ERR |
-						  EIP93_PE_CTRL_PE_SEQNUM_ERR |
-						  EIP93_PE_CTRL_PE_PAD_ERR |
-						  EIP93_PE_CTRL_PE_AUTH_ERR);
+		/* Order descriptor reads after device ownership is returned. */
+		dma_rmb();
+
+		err = pe_ctrl_stat & (EIP93_PE_CTRL_PE_EXT_ERR_CODE |
+				      EIP93_PE_CTRL_PE_EXT_ERR |
+				      EIP93_PE_CTRL_PE_SEQNUM_ERR |
+				      EIP93_PE_CTRL_PE_PAD_ERR |
+				      EIP93_PE_CTRL_PE_AUTH_ERR);
 
 		desc_flags = FIELD_GET(EIP93_PE_USER_ID_DESC_FLAGS, rdesc->user_id);
 		crypto_idr = FIELD_GET(EIP93_PE_USER_ID_CRYPTO_IDR, rdesc->user_id);
-- 
2.53.0

