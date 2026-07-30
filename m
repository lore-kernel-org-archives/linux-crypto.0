Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A34468C31
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 19:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785438036; cv=none; b=H6vm0kHEse1t36175UYW1WIFyuwJqWzeL7xm/ZE7ziAFKyB4C2MDPNH3D7tG7A8jT8kaPHQupsQ6he98QDfaMGahAfcZSU9ZDKdXKnt4pvYcRtqmqKT14uqvSQWvUnxJQwwC0jqsGRQaRMVoHdvmUK2qB476xVLWzgLKN5p4zZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785438036; c=relaxed/simple;
	bh=0GUHyb7aYOq+b6CtbhLZ6NBEgUbOJsO6qfUytnnHIHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dMCDz+n3wtRQKgxMIiSURQvGNu5Nr+oj6iPtltHJ8JDw2+8U0yoLkCrwklbLFRK9ZcqQqxP/itsALFa+iXNKpIlX9dTJgrJ7G4YoK672qSydCXdA0/WvySSOmmGA5ZiIlH7ckEeDM+WHAk5BhPfdYfc++wGXIm2qCKnBacJmmWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dO+ejY33; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dO+ejY33"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso236134a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 12:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785438032; x=1786042832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DhHvTt43uROMHE4cFDfuaU8o7pJfRtyKn1m37TaFLFI=;
        b=dO+ejY33fTB2erP8t2Y9VC8ows8rqM24LGGbTL04F0z14wXER97/ta3WcJPqCEZMML
         MzT1Jv9ke1y32j0GvGdi98TjEB3QXeLX7JXg6CKPqN0cxkSuLpCMzaS1Etrmo9mfp8F+
         kwPIRMQ29fG5w+FF1RnLPXLcn60vM3YuntEWLLsRo1egUHjcUdUkS0+AZtvJsqCT3Br8
         y+/w23yc+SI8CKtoK1sOCTmRUqnTsXLtIrqn7fcirwWbsNvczD6Dk5wDhx84jymPlhfW
         gD7g+RCyQDRzY15jX6uvKK/bk0HiBLyCySp0CIpZjMW69HlIMEbAK2U21iOcss92txBd
         SB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785438032; x=1786042832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DhHvTt43uROMHE4cFDfuaU8o7pJfRtyKn1m37TaFLFI=;
        b=dYNA1Foiunjx1zvjA+pU5JtuofTxVL7aajMy8K4VrOyfWWFbsCbgKDzdMoNFlz+LfJ
         Sy0I8SYUh/mD05YklxJM6a6xV6qSANBAtX6V20gsUhanZbYYAlHfYeCqJD1rJSy6bRH7
         +d9cukmDChoLG+cRM6E3mIYa1yft32X2ucI/drwCxPSHcKMG6se12Fv7zri1WpY6LMPi
         wWLb/gA/sjG3UTp0gM4xZmq5qLuBiYkUW5BOh6aJgsvj6xjZvD6BQSfcteZigV87Dkws
         H3/zEiO63IlL/lLPvoEbC2l1FZ/jm6mJWzc0KsZbcb1bfr+H2AV8EgCNrOL8pCRnG4ra
         OXCA==
X-Gm-Message-State: AOJu0Yz6eJjtZ4OISpPrSWava95H/TAAEIzNx5mDg+Fg43gZH1HXn5hM
	I69k6kT6fGpBV43Gp0eJOCY9EHwFGJAfwZ6+TNV61GZPb4ibfZMy1hSk1UqgfaFi
X-Gm-Gg: AR+sD11gLtnN8Jb2pgVR/kqwa42CG53ImaNqYSg/KrHCGVcYt0QlpDA3pDbTSbGEGdY
	Sf0SSplcvcNGctWUrqyJdIfWBagXbskpYD5/ZpslP4Fv+XkK4jzJYH15g1hfgfBi+J8iMI7pkTF
	6CtQyE2gSV0POt0WAitGwYlD1lAMCMIo9VNc9cVt5PbZjUScfGNwRxv4zkwEM2rZ34j99Q2elVS
	A1L/7PQ/7eVkhed4gH8oPP3OFY4e0MIiEnAflfIXlzkNmqNjc7yBWoz7J30B+vVP6e0esCtSOun
	k6eDMSTopDpHJOuVGNUHnlIJ2y6cqV5HrwBzGzWiCirWBuSrcDKhUfnmxbByYXFhTw9cghgX6+n
	ZdiTE71mbmXyWew7i4e8NSK8LEpYZvNvTltcbPKGnpMIIbnxY9kgl8bAWaG0rj7yrFoTO2xttM4
	NYBebQgtqXISoW2GsX6l/IyWkwVUTiabmBVynWzYi2+tq14LqVrEgiswq5jiWNlueGv6ue+ebPC
	Kp+8rbHQcFwNzJta30SGCNnQ3loDqm72MfchbuCmZMJPf3AsvxypZ4UBZbAbPGB0gMyKBpAQk/m
	axH/LHVUtTxK3oVBjAMYFSi95TOzBbpnB0QC6XpTt/p7V0HzTA==
X-Received: by 2002:a17:90b:442f:b0:38e:70d5:b12d with SMTP id 98e67ed59e1d1-38f9bd74015mr2100205a91.6.1785438032061;
        Thu, 30 Jul 2026 12:00:32 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b46a048sm1446326a91.7.2026.07.30.12.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 12:00:31 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: cesa: clear cesa_dev on _remove
Date: Thu, 30 Jul 2026 12:00:29 -0700
Message-ID: <20260730190029.1038946-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is already done on probe failure.

cesa_dev should be set to NULL as the driver checks that it is not and
errors saying that only one device is authorized.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: set after mv_cesa_remove_algs
 drivers/crypto/marvell/cesa/cesa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 4859ad2e86b4..564b09773507 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -544,6 +544,8 @@ static void mv_cesa_remove(struct platform_device *pdev)
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
 
 	mv_cesa_remove_algs(cesa);
+
+	cesa_dev = NULL;
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.55.0

