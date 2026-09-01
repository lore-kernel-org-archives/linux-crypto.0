Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A84A386A
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 20:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788295062; cv=none; b=tiL9sLm7ecg10Pl+byd99kDUn9EJgm86T8a/bEMsSAgbNVxRdZ6VZslxbyPZ4nU/FazmWXpHMYuQ2BGQOvriHqCZo0cYbOTOvlyhf+uMdGfHUZutzpM7ZzXsseE+riBy+t0QUoOcduLDih6LcXfcDVDqOreU+KY9qDXOL01B1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788295062; c=relaxed/simple;
	bh=7kWtNHnkgon39160jWf0bk9sq15XmJRpmJ8WMiYmKjE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=adfcn6aEo9BM6zFX4IQGe0yp2OchxQ+uHHBkVFbyGMnyjV9uUgs24pjcEYi6fi2IlRU3LXsAuKfZwhnCs5XZK9sJzPtUDgDCSmiwr6ijTTrNAQLDQxnYdX0GOFqEEKzMmy0yzbcNSY9RxX4+tI3rr26tahVWwdeD69xiBB9cTnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=keTKunij; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="keTKunij"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-398d2b28acfso243795a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 13:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788295059; x=1788899859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=trO+aYhWZ0cKdRoRTUvzCd7Am7CExDkHP+dQWJTMJHc=;
        b=keTKunij1gq8rW6ly4tNjmer4Lpi6FLtJdZcPkfaGDxG4ycwFKU2IKrNSqVpLEJ97c
         SbL9YhOW388SLnvrxfPDmthP+dwvjHJKbA+ms5Hrrv9Zy/upzwCzT8ERi3c9BBVkUUTh
         YC6BLpBVf3apNn6pq2EWMGYa5wYqVsXJHhF1nWypqz/KYhMX92dQEXiptM3B5GHoBYaN
         0/ttTlu+24HK7aIHcRiYZrmdT2XfOJ7by7CakPrJ+XrUBx2/MayRsk0b1ihnRpBZsfb1
         qHhXaLB8LRYN5Xq+SQwIV3zoZnS47k2vnhJuxI/TUP4hJ8zEwSm873WT9iDS6ajktaDs
         sSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788295059; x=1788899859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=trO+aYhWZ0cKdRoRTUvzCd7Am7CExDkHP+dQWJTMJHc=;
        b=WnJimainfovq3pM3mtx/LipL8Ihlj5pgaLXkRBTnO+aEzT/UmUG4C2za0IZs5A60p4
         oZ5eIXk6SWr8D3dUB1NVapJv762B9c3Qz5QGm0sYUK+qpkh6nqX9P7+yAceTwI3XXwgy
         T9KFJv435PlyzszwGU8hmAUKNO0XKXB9uPhQ+orWjKZJeQd5qw6JJ4ZTqmDCa7A65HLX
         u2IcgyGoks81J5Ih6qvX5bjkquijXF3bIEbnEbM2901H6KgLSLaKf5/eKcg5Q+sjHCDz
         IRPqVPPULTUkUZZ6YHfa+eNikJg0GQmUwM5AJW58NHdvqS0rQcJg9TR/1jcbKOjCadL/
         qcSg==
X-Gm-Message-State: AFuF++nJo+xBmcoWCD5Ca3PM/o9Z4ywlAR4MxV1/35s1I02g8q9Qxi3A
	PKM+8qh9w7bWso8LuR+jIBnDj3Z+QMddWGklrdisvp7LznWtdjggeSsuyZ+aig==
X-Gm-Gg: AYBFou2LRrFwKhwZqjS2MUAxQSwJG1BuBfQH1pZMjFLM/G4uyu2RcvqrsmCm2qXMEvl
	fBekDLNXgABmG7eppDCVJgXy5eujYOZhlVl92nWCscjAY0weKBg7wlwKgpQ/w+fUx1NySzoWV0y
	f8v7HreUy80qzEK3Uhe/pCezPta2w+iGG9DQdNpW+IRmqe4QWwUfFhBvH2LdHPEx6WIondL4InC
	csrXr2M4Csxcv7thBXlfTuXZdWxuTXW713dJSv93CDs1l7mSJQPHzKP3g3j99r9uK4GhqstTGVX
	jHRdltU95dsAKhiQnKF5ypQIABH4NV8APtU+3jz3NbD5oFllircUIjTogrZSOwIeJaf4QCB53sH
	IOnVvlgKdpuoYKXGic3gyxg5q+BCkrbTAXGUj2NkFLB9fqTa3lO0jiEAlze/KW2lG0RtSCddk2M
	C6ehcqvyzSdhmq/m3X4Vbes3aL539i2Nz4GJo2uJIi166hCg3oTvx/YLCoh0gDJz7vKsmoibRqZ
	XcQdark4oXn3jbBPN4ikqXdT1ui6QWvsr2rn4k7SUoE2siObwpS6q+QY4hTRa1Qa8L/TKOemrza
	VhdRg7JWo2A/LStp5/Y/FL4feWfmLN/YZ7uJHw==
X-Received: by 2002:a17:90b:380c:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-39907b170f8mr15313233a91.7.1788295058594;
        Tue, 01 Sep 2026 13:37:38 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d75fc49sm7430467a91.12.2026.09.01.13.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 13:37:38 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: caam: map job ring registers without claiming region
Date: Tue,  1 Sep 2026 13:37:36 -0700
Message-ID: <20260901203736.13248-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

devm_platform_ioremap_resource() ends up calling request_mem_region(),
which fails with -EBUSY on i.MX SoCs:

There the job rings are modelled as sub-regions of their parent
fsl,sec-v4.0 register window, and caam_probe() already reserves the
whole window exclusively via devm_of_iomap() before the children are
populated.  Every job ring therefore collides with its own parent and
fails to probe, taking the hardware RNG offline (seen on i.MX6, i.MX7
and i.MX8 boards such as colibri-imx7 and verdin-imx8mp).

Map the job ring registers with devm_ioremap() instead, which does not
claim the (already owned) region.

Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ handling")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/caam/jr.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index f9e029945b51..2ed8229d4733 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -583,12 +583,29 @@ static int caam_jr_probe(struct platform_device *pdev)
 	struct caam_drv_private_jr *jrpriv;
 	static int total_jobrs;
 	void __iomem *ctrl;
+	struct resource *r;
 	int error;
 	int irq;
 
-	ctrl = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctrl))
-		return PTR_ERR(ctrl);
+	/*
+	 * The job rings live inside the register window of their parent
+	 * fsl,sec-v4.0 node, which caam_probe() already reserves (and maps)
+	 * via devm_of_iomap().  A requested region that overlaps that
+	 * reservation, e.g. from devm_platform_ioremap_resource(), would
+	 * therefore fail with -EBUSY, so map the registers without claiming
+	 * the region here.
+	 */
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "platform_get_resource() failed\n");
+		return -EINVAL;
+	}
+
+	ctrl = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!ctrl) {
+		dev_err(&pdev->dev, "devm_ioremap() failed\n");
+		return -ENOMEM;
+	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-- 
2.55.0

