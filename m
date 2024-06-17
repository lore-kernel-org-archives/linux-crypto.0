Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CD1188CB8;
	Mon, 17 Jun 2024 20:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.147.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718656505; cv=none; b=EmyjCO/p8Z1d9kpU3PzTRcx6Ukro282aZ+woRghIVRf5SnpKmcN+fZtVkipatq8al5/VYdR1Xsxxn1KFah3pYz9izAUF+2Ms2K6UkjykOwz42dl8/pDn0dVcJMjXlhPXqYFzMIfo8w4KjnnzKNho5Q2oBMot3kT+aJZ/IXGJAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718656505; c=relaxed/simple;
	bh=U8kMqA+HvhuLjwCTeLGT69En/TRPgnNHEnKor65AfMc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q24lBAffVoBEKsXyZwW6fksmicYQcoFTxQPiNVfNGuOVEGfqmU0wTTCPMhagJ/xMyGsthjkS0gNS7JMYYwaNHGi7AjNS1AKijD5309E/tTk0zgT5lJ88ochtSNU+u3nkrv4IAdcG+ZyA6IbZRUSXt4ViIKJ0Cs53C/3zMWoklN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=aRJys0Oi; arc=none smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="aRJys0Oi"
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 45HJcopL027367;
	Mon, 17 Jun 2024 20:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc :
 content-transfer-encoding : date : from : message-id : mime-version :
 subject : to; s=pps0720; bh=4UqGo6+WrKJpq4MkZGs/bGPAF5s4ci65K+blGZyAd5k=;
 b=aRJys0OiwUa2ICz/UpfwPOPGyjJdohREeEdYZWWGuO4d3FSF2w6/m0Hf7QKPZXZkZQFE
 kw3QvRhqicCVZvfQsxl5KTb06NpuBBJvJLtRQKC1tFt0i5kFWtrCA8JRnoOslte26i+u
 9qcQLiKpimL+OjiWFWtilkTh7eseCW0/d3mLYR7xN6YYQt8W02jcN/C3WfpBZqKlzVqI
 b8kNUmBHgMrWXmmyeUNL/1ZzYEvO/K/tmyLMXmTDxappurj84f7feloRlKEw6GiyxgjI
 x1zVHP/gbgN7P+08zDKxp4MJoYlwC+QeKD9ooQ6T7HbIiB9yr8tA8i6dlwm+lFdRWaNv Fw== 
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3yths450xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Jun 2024 20:34:53 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 435F0147A2;
	Mon, 17 Jun 2024 20:34:53 +0000 (UTC)
Received: from cat.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id 5652180A815;
	Mon, 17 Jun 2024 20:34:51 +0000 (UTC)
Received: by cat.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
	id 80345B497B; Mon, 17 Jun 2024 15:34:50 -0500 (CDT)
From: Kyle Meyer <kyle.meyer@hpe.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        tom.zanussi@linux.intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: russ.anderson@hpe.com, Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH] crypto: Add aliases to deflate
Date: Mon, 17 Jun 2024 15:33:17 -0500
Message-Id: <20240617203316.132697-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jSwhyTJ82NIcjJUJYCh2EMj7fG9cZZ5q
X-Proofpoint-ORIG-GUID: jSwhyTJ82NIcjJUJYCh2EMj7fG9cZZ5q
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406170158

iaa_crypto depends on the deflate compression algorithm that's provided
by deflate.

If the algorithm is not available because CRYPTO_DEFLATE=m and deflate
is not inserted, iaa_crypto will request "crypto-deflate-generic".
Deflate will not be inserted because "crypto-deflate-generic" is not a
valid alias.

Add deflate-generic and crypto-deflate-generic aliases to deflate.

Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
 crypto/deflate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 6e31e0db0e86..98e8bcb81a6a 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -311,3 +311,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 MODULE_ALIAS_CRYPTO("deflate");
+MODULE_ALIAS_CRYPTO("deflate-generic");
-- 
2.35.3

