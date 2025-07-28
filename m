Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67642145A05;
	Mon, 28 Jul 2025 12:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753704417; cv=none; b=dKdwlF0XKr8uJfNifPWNBOjhv0CK8/y0htDFp7do7mK1845QkUsfaMc34FmX53DYcxYmLR/6uewzPWc0sbX0I2TlKlk+8rHJAe5WsyvgC3Jm3CFwmGC4RUo4xnRAGq4vF3h7QAstRAUYzYoFRgujduSza7aJC6eez/vSwy8ZvuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753704417; c=relaxed/simple;
	bh=CLkGPA1MK7tWDAlNtLWbx/XTTK5sjydfnQRwvifXPic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LKDhiEXvrT31z9IteHvvFbRzjYXBy5wvQK6CtWumX5aAKPOLfgIPyvJyDhECDdkMKDSbpVD5uFrdjsNzzIBGXmVxoOwwFaQci1ICbFPWNQJzC0YEnfyCezdkZYMmNgNbEVbyPemXywprkr86/yE2HgW+OQcfTIBW1tN3BDY/uWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cw8S83j2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cw8S83j2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-456133b8d47so2085085e9.2;
        Mon, 28 Jul 2025 05:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753704414; x=1754309214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zzbDKMGrEk79wTL6PL3rD6jgQZYfwg04CkTglnNnl8s=;
        b=cw8S83j2yerFGBWeoRCEhcZytePBvulrGymiEw9YBc2w7g8kl6w8tdsE/x3GEntYKk
         DM38UO1qdGpmWFe7bSD4/cHVo/mpHjjxUq2JQ7Nd/Pr3qnY4AtSm+VhPpP2El4I5+g+N
         PlBBIOYEnOBEJHgi35nxOT6i3zjQlwFUMKCHxueOhiH2k6I/uI/Db02DBdhnkODstd2F
         j1GuQGZtnVO0KXbZ5sx7+/lMKx64j5+J8NuEQa6ZaWwLgE0HdY+KSfQs/557JG/gSMnf
         2t164PtEWN/QZ7I0uKOqK6vfwmtqXyKSZBM9rzGzmO5Tjk5szDnTXJUZaJ3ILayat8Pl
         YkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753704414; x=1754309214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zzbDKMGrEk79wTL6PL3rD6jgQZYfwg04CkTglnNnl8s=;
        b=n1u+Qp8vhRP17PXrZg9ojFYC58jJsrwp3MZjznYq7mkx81HJLHIBdg0+VM1d9eRWnE
         l/aXGO+Tvbhgn8BDZqNQbB591OLdCf0njHqJTKbD7jHxtpHVDm6TY4SB/UXqfI7+w0Za
         ui43ot00MVqK+Ui4VMuBInwhoJatC7EotXy2smUsWC53rYlav47Zhelo8VqDEpd2fSgx
         Vgx/IIcBI8C1GUvTvpH84iySmWHNbC+i3OUjBlKN5qcgjJx9djN+w9XTA7E8cz0UdRrT
         ifpZ06GbCPKpKZr26yiV2OEAbYI41TjerUQcfGUdXz85XG6vYx+Do9jiqzZKzULowYjs
         lX7g==
X-Forwarded-Encrypted: i=1; AJvYcCXOQz0LsGHmoSbyU28zJoz6N+BItGiZGYPP6X1RKKQfsE8ETFPiftIGMZMO3z5Uv/HMr0iqUUGTnoAXgn8=@vger.kernel.org, AJvYcCXnvNU7ajD83nqMfkQVV0f81odbfKzW16Yz30tzXzbYZ4QBv3y4jZiZQ31GXxB1/oInSx+6im0NRiRjv2my@vger.kernel.org
X-Gm-Message-State: AOJu0YyyWzNgwuI/YP918lrEMGCYsra5zm4hd5q1jfjs7tJZO8Z5wgvx
	fcgUZbUOb5xhV3O4elBb+BIlfP1+iOohpWxXT2BemlA9O4blYaIZFsWx
X-Gm-Gg: ASbGnctx1GEQQ0t5PfsxRiqL2wv6K6DLijjQCb63e7eSbOj9ryE4r50GMH/cYZ0Xfyy
	0ObPlNtMf0FWgHfIEdXlF7+VNo6N+2jCuuB2zJge0ElHMQqD0T1VnwTenCCGURd1JqSr+JYZuF0
	MeAEFGCoN2Sy5YIoBLR9UvPm3XCRKMZFu0SAdR6mqYyyk+3VIZpTHaghuKCI2pwiTQmqiR6kX2e
	DA0yuexHzqS42CyjUeuv/KE42caPpJzr9QPaL4Banp2HwaNVd1HDjGbNzdaC5b4Ndq/dm9Jsb8a
	AzBwVyon8wJR/tP0rBD/NsUC3SvDCeyvkAz2J9WYc0f4ja4QqmPSZzEC56pG9t113VYb1RPNYe6
	DuYx7MX3/F7K7jpV/rnSwKPxCl5VFTefAwdyzKeuOep1Dc6CVgA75+/pSQlLoPg==
X-Google-Smtp-Source: AGHT+IHX/SDgS8zBj+2qSUHB9xsil9G/JXzpcdiuXqhNTGIomHVhaD9CExZJr9fTSYskXOA9qabl9A==
X-Received: by 2002:a05:600c:6209:b0:453:6332:a98c with SMTP id 5b1f17b1804b1-458762fd0d0mr42494345e9.1.1753704413257;
        Mon, 28 Jul 2025 05:06:53 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:10bd:be35:642d:a1c3])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b77b82c708sm7725870f8f.80.2025.07.28.05.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 05:06:52 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: keembay - Add missing check after sg_nents_for_len()
Date: Mon, 28 Jul 2025 14:03:30 +0200
Message-ID: <20250728120331.53342-3-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sg_nents_for_len() returns an int which is negative in case of error.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 8f9e21ced0fe..48281d882260 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	struct device *dev = rctx->hcu_dev->dev;
 	unsigned int remainder = 0;
 	unsigned int total;
-	size_t nents;
+	int nents;
 	size_t count;
 	int rc;
 	int i;
@@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	/* Determine the number of scatter gather list entries to process. */
 	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
 
+	if (nents < 0)
+		return nents;
+
 	/* If there are entries to process, map them. */
 	if (nents) {
 		rctx->sg_dma_nents = dma_map_sg(dev, req->src, nents,
-- 
2.43.0

