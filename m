Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E32101D5
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 06:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hDqsJJdf"
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34B2685
	for <linux-crypto@vger.kernel.org>; Wed,  8 Nov 2023 22:33:27 -0800 (PST)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231109063324epoutp0453fa47bab0ab3b2e76daa29bf0b4d594~V4MzY3JQ93222432224epoutp04Y
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 06:33:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231109063324epoutp0453fa47bab0ab3b2e76daa29bf0b4d594~V4MzY3JQ93222432224epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699511604;
	bh=ppNzxXwPUh0I7T4RkRB9W3RyufbvyB9p4D+u/eMh964=;
	h=From:To:Cc:Subject:Date:References:From;
	b=hDqsJJdfVOlHg/xKhHjEqFTNJMKZjpAr8/157HBhhZyRW9jweGxUlgkW16ewXIx08
	 UNFMMwHp/V9FLYwjSK3ZDXRqDV+8oi+S/QSycrf3zHymJlRBmpRAT0q/JtRiGJZ8TG
	 vi64RgUtbMMd0/qPyMHyUH0nSetUEPEoNfrf5W/0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20231109063324epcas2p3802f2e7381aded43c65e6dc2998a653b~V4My-0jXO0043200432epcas2p3G;
	Thu,  9 Nov 2023 06:33:24 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.88]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4SQsbR6QRNz4x9QQ; Thu,  9 Nov
	2023 06:33:23 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	60.6A.09607.33D7C456; Thu,  9 Nov 2023 15:33:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9~V4Mx717WK1692916929epcas2p1P;
	Thu,  9 Nov 2023 06:33:23 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231109063323epsmtrp13d4c640a1b3f0952ceb134e152ad4a3e~V4Mx4byM80550105501epsmtrp1a;
	Thu,  9 Nov 2023 06:33:23 +0000 (GMT)
X-AuditID: b6c32a48-bcdfd70000002587-0d-654c7d338cfb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.1F.07368.33D7C456; Thu,  9 Nov 2023 15:33:23 +0900 (KST)
Received: from cometzero-ubuntu..
	(75-12-16-202.lightspeed.irvnca.sbcglobal.net [75.12.16.202]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231109063323epsmtip15868d31393a0d28a9aa34ce2d2d3c75b~V4Mxs45h62501025010epsmtip14;
	Thu,  9 Nov 2023 06:33:23 +0000 (GMT)
From: Chanho Park <chanho61.park@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, Jia Jie Ho <jiajie.ho@starfivetech.com>, William Qiu
	<william.qiu@starfivetech.com>, linux-crypto@vger.kernel.org
Cc: Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] crypto: jh7110 - Correct deferred probe return
Date: Thu,  9 Nov 2023 15:32:59 +0900
Message-Id: <20231109063259.3427055-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmma5xrU+qwZ+l8haX92tbzDnfwmLR
	/UrGYsHxSUwW9+/9ZLLYO3ELiwObx5aVN5k8th1Q9ejbsorR4/ZZXo/Pm+QCWKOybTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL89L18lJLrAwNDIxMgQoTsjM+H7nPWLCB
	q2LdulfMDYzXOboYOTkkBEwkJjSsZ+9i5OIQEtjBKHG65Q8LhPOJUeLwhHtsEM43RonuE6dZ
	YFr2/JjMBmILCewFqnosCFE0jUni8POXTCAJNgFdiS3PXzGCJEQEzjJK/F52C6ybWUBbovPz
	FHYQW1jAXqKloYEVxGYRUJWY/vcgWA2vgIPE1XnTgAZxAG2Tl1j8QAIiLChxcuYTqDHyEs1b
	ZzODzJcQOMYu8ef3VqjrXCQat29mhrCFJV4d38IOYUtJvOxvY4eYWS6xY1kSRG8Lo0Rz2x6o
	enuJHzensILUMAtoSqzfpQ9RrixxBOZ6PomOw3+hpvBKdLQJQTSqSxzYPh3qAFmJ7jmfWSFs
	D4lZ0xZBgypW4kVbF/MERvlZSJ6ZheSZWQh7FzAyr2IUSy0ozk1PLTYqMIHHaXJ+7iZGcPrT
	8tjBOPvtB71DjEwcjIcYJTiYlUR4L5j4pArxpiRWVqUW5ccXleakFh9iNAWG7kRmKdHkfGAC
	ziuJNzSxNDAxMzM0NzI1MFcS573XOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgelUniOXsqy12fXm
	HPZXsx/YMqocK3JOtdVx/rtojnrwZz3bgwfXzbu+2+TZm3uLrhxW2J34M1uG1b2wx9p4+peq
	dww/TlY/jH8X+GaZ0mpn5/b593aX/jk1Z+Lvm2wn3t/sXpo5V71+5YpF6/t/un+fwxV1Sn02
	Y1vgpx3p4fEHW2+vq/f6H7cmWjm09vDJnw31c/q2bU15v1gqtPYIu0qTg3Ls2V0HVm2fPv+d
	qTun/7aHBXkpU7ymC//1WrjSNfSKts6dgAnaLhvNf+80/cd8se+6tGjpHdmth+dPsze4cO7r
	hvjn84OfWn7ZFBYd+uvYx6aFshF+3/85B84KEMh8+4/F7Fakaszi+1ErLiZKK7EUZyQaajEX
	FScCAIfPYHIIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnK5xrU+qQeN0dovL+7Ut5pxvYbHo
	fiVjseD4JCaL+/d+MlnsnbiFxYHNY8vKm0we2w6oevRtWcXocfssr8fnTXIBrFFcNimpOZll
	qUX6dglcGZ+P3Gcs2MBVsW7dK+YGxuscXYycHBICJhJ7fkxm62Lk4hAS2M0o8bHhFDNEQlbi
	2bsd7BC2sMT9liOsILaQwCQmiQ2vNEFsNgFdiS3PXzGCNIsIXGSUuLxiKxtIgllAW6Lz8xSw
	ZmEBe4mWhgawZhYBVYnpfw+ygNi8Ag4SV+dNY+pi5ABaIC+x+IEERFhQ4uTMJywQY+QlmrfO
	Zp7AyDcLSWoWktQCRqZVjJKpBcW56bnJhgWGeanlesWJucWleel6yfm5mxjBIamlsYPx3vx/
	eocYmTgYDzFKcDArifBeMPFJFeJNSaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZq
	akFqEUyWiYNTqoHJ83q2w9dcF3eBD79WLIv0v7RJWX21Qtd01b0FUpGdXeezOj5enbPlsujG
	H6l7fxj/imF9kG/lsGGRxcPlj3WtzV3XPz/9U0HSeNmVF9tfJX8zb5wcEDzrjOtbfq6+OzuX
	FJ24tHSDygStjbblHjV9POU8nr1Wtx7qx9Quq/hgxrdVp+qP5xy/7qdsnKz/Nq20DNBTfHtu
	0rS32wU/11/IValf80UytD5tqdYr4ayiZNvTB6dHbtOQE4n14ww5euhs/fF9+xhdn6U/P6yy
	oPKNX43e5Ql8S+cnRcpffbj4XaY6f9uMWb/FM1nfTLvl8FW+blblQbmHc28JtP1M+Hdxw49b
	1hFrNR/blwvxuR7oUGIpzkg01GIuKk4EADuGflC4AgAA
X-CMS-MailID: 20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9
References: <CGME20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9@epcas2p1.samsung.com>

This fixes list_add corruption error when the driver is returned
with -EPROBE_DEFER. It is also required to roll back the previous
probe sequences in case of deferred_probe. So, this removes
'err_probe_defer" goto label and just use err_dma_init instead.

Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/crypto/starfive/jh7110-cryp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 08e974e0dd12..3a67ddc4d936 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -180,12 +180,8 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	spin_unlock(&dev_list.lock);
 
 	ret = starfive_dma_init(cryp);
-	if (ret) {
-		if (ret == -EPROBE_DEFER)
-			goto err_probe_defer;
-		else
-			goto err_dma_init;
-	}
+	if (ret)
+		goto err_dma_init;
 
 	/* Initialize crypto engine */
 	cryp->engine = crypto_engine_alloc_init(&pdev->dev, 1);
@@ -233,7 +229,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 
 	tasklet_kill(&cryp->aes_done);
 	tasklet_kill(&cryp->hash_done);
-err_probe_defer:
+
 	return ret;
 }
 
-- 
2.39.2

