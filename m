Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4743C7CF
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444569; cv=none; b=QpHXXXWAoez6oWWZEM6GxoFmobZtafRaGNgeev0TGGplaB9iuzpOVhXUrLAWWeG4y3rnf5el1OxHzZJx8inxYuX9cRkkjH9CZ7mIqlbv4L+8kZF4x5Hj05dZ9FUgEZwlzhb2A1lRozAaaZqHaZo6z0MWRdCc2btqr+it3oEd9n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444569; c=relaxed/simple;
	bh=EdkYxmuAxMDvoRfEoVxhed/QnBhsDq7sE9L/vZzhE5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC/rMiiCU2BMD//cOhmYDFm9v/qsvC6Pwku4Oe9LGwbD47QSXbL/Mhnsh6HIY0Lk2V4FlDoVi8x9gecPnolae4HGFRWzrGPwCxZL6iRyHjC9V+oJtPyJ07KtqIyV+pn9FWQyy2oBouWdgPzTbeXG/a3akGiwaeT/wYAZvw77Yy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nuotl0Va; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nuotl0Va"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8478a25f268so3510822b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444568; x=1784049368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zETzyEEmsJ2x6ddKsdOxPuAwqC9YpYU0V1LAJerCiGo=;
        b=nuotl0Vad76Tw3h8/2wN+BoZPyEo+MMvKHqx/bXzxhDvqLEAD4ZwUz7SwOrJydIPbv
         gydgPCI7ZqBMwtRPoU2hlEkFmDflBW/QdNkoJkB1vMwpTB2RdZxqcSGerP8lH4C8ex/K
         llhpoYh1Po5EWSNV/I+yJdnXe4ZMOGlKyAVzTVD4JKeCZ3Z0eP/M5etkpjejRs65iggg
         YLXnlDYw5bHVCl9biU01skRS5nWl1tjRBcWL/hZg90bZ5WMsCJMPTnfQ26SigzV2Zxy/
         viyheeutGa+XDcQTox3NZYC4HF3pDPuc1laSdykD6maTG7BIIeDWMMWPkjereBsWyH9A
         OLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444568; x=1784049368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zETzyEEmsJ2x6ddKsdOxPuAwqC9YpYU0V1LAJerCiGo=;
        b=b3NGRZZYQMxj3DExq45tvb70w205EEpNTEdu3Mqu6OVfq7KOsIQla0Y+sufyWmnd7J
         xeX70IZTsEuPPm6iOdpnhs3pNy53q7SgYd+XCsgGSNMqeLwIU9QZkEJz4KEFs+beDMAJ
         DSKTMEEjQcttHvPMkGVKEEjGP7Pc08IVxjJjPbUPyvy3zvMjJ7XbKOGseKR2q7AeG1Rk
         9f//qjhucl54ksnMyHHsVPQASEyIpgbpMjodbKid+AveVWCncRgjZlxQpUIC2tqTUHjL
         NGaSNxsuHB7DCKzt6g7mcVozRkYX9YxbTQ7xgwE8iqsJHdzK08fFhHrh4a8WlU2dgcFb
         7KLg==
X-Gm-Message-State: AOJu0YyKAzF7RPWO8F6Nz9M9TMaUfFwK0xN0QlI6wLAWK9DNT8dWVLkS
	dDW7ehv1mfkJPE8+Po6DNaqJBLYQ/2QuXfgil6KeuMfkYyqETHa7WHrS
X-Gm-Gg: AfdE7cmtnndeICan2VuBJBHfROPqwF75zwowCTwqqWdG2U02vzh8t/LwM7I4H3F8ooq
	RojT344wnoj2TALoD1Kg6+rN9P8Qj1ghkb9Gv0n2x1ePmZuUTwS56nUXLPf1ODe7/hfPwfezK26
	Axo+d4zecqZU0PiS8kfDuKjxprpmXBZUIDGSUVGJwnPwoyS4oumJKGPdql+oAGJGBoL0HdW8PA/
	IdG0BRVJNiEtFM/TGw/J8SxE/P5RwwA4Dr+6bAeHVgbYQihMJds68OqX0zfz2Ymubu/NBUY3xDZ
	vbCwwdZA+iAhoi1X5TkF5BDoL2zX8C9Gme24B8XLukgmsofIiz+RjYHZY8nd9jQih0Y0cbiopBQ
	SVl+gICzyy9LfJsIFtbTy8pTXi0pDM5BzeqV11wydWzs3n6RMgeI9cXidb80wKw/iDlF6Mf1Qsv
	UJfqepIWqVnRxP
X-Received: by 2002:a05:6a00:84d:b0:847:86d8:5937 with SMTP id d2e1a72fcca58-84826d9e1bemr5655538b3a.50.1783444567473;
        Tue, 07 Jul 2026 10:16:07 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:16:07 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH v2 4/5] crypto: eip93: order result descriptor reads after PE_READY
Date: Wed,  8 Jul 2026 02:15:36 +0900
Message-ID: <20260707171537.467608-5-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707171537.467608-1-hurryman2212@gmail.com>
References: <20260707171537.467608-1-hurryman2212@gmail.com>
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
index 1a8dabc4ada4..eee5fd8f9e96 100644
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

