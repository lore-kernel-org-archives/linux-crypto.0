Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988627;
	b=Wax+VmBvO2WBX/yyWCtSbaEB/2hbcwLg7recklo2nG6aXOtg9JBe4PESCapjn44w3yeP
	 2WKMCpk6EXjyuf95kMc1IkCdd674jKz3oAM3vmcEn5aW4On+d4BHXcwxzKKt/KKn9/Zqv
	 oRGXfNeUyqrXH9KgaLS7IYMrjvjwljdX1T/ebHFSIMjelaM0n2Sya7sTVx3Vcsx9b5jtb
	 39ndy/hCGi57XSGLELl6l0upPhxddYfyv/fXVc+jyL7U3KhDuweDvZEoFFZ2FsLTB7UvE
	 CAEtUNAceYSHxSPr18eiBmm10rVysNo2OwAw4MCmcRMwaP7kYpfw1wYFYexN388ttYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988627;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-Originating-IP:X-CM-SenderInfo;
	bh=28dibrGnCQWrCeRp0FPL7OuGdl2QsgSYjK73A7OhRfE=;
	b=Tog8OtwPbxGTTf8QTJz2SO0xDNa1Hyzlr6SGRwq5/EacNcWH/jFdQGrBIUsYH/8rceaS
	 Dr//sUqr+g5waMsEEJEjsXaAww1MeY41nrcHNDWjQ8UJ0xjfvsJorCn1+i8HvAfaqKqys
	 wtns8UAWb5Vym6ayHlGlSSiaGer42j4mZJvhFXfuzIfV7n0tk9SWNinzUZJpOevQKhP4F
	 pSkEGNi147xA1DFuAhpxlHofRQEvF3SV5FOKzFCreDPKJDPzFrMWPIdOb0OEzjxG7NQco
	 InNBNHkJKzoTNEkKUjoNx/ew5K0f0SbxiwTb+9XmFCMch8+kU7KNHrGoRr1LPDlgMOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mnIqw5XL;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C9606A325;
	Wed, 18 Nov 2026 07:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 533C9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mnIqw5XL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=28
	dibrGnCQWrCeRp0FPL7OuGdl2QsgSYjK73A7OhRfE=; b=mnIqw5XLOrI+1Eh0Il
	lOrBPDvS8TgO1jgrNuMthB795QGVTOcdsRxNI1J1vuLJHecw2Md7aKjF49wopuej
	la7Ak/G0ZzW2fGO5s14DV334djRfZV0EGcdT9YNUn22PjSbSf1CP6QdmiZ2JZ+vB
	vg/a6ulbMZlnkKyqmaXyKzStg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3P6M1Wv1qx8alGg--.56103S5;
	Wed, 18 Nov 2026 15:56:46 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: schalla@marvell.com,
	bbhushan2@marvell.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 3/3] crypto: marvell/cesa - Free hash padding when queueing fails
Date: Wed, 18 Nov 2026 15:56:36 +0800
Message-Id: <20261118075636.2152451-4-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118075636.2152451-1-haoxiang_li2024@163.com>
References: <20261118075636.2152451-1-haoxiang_li2024@163.com>
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
X-CM-TRANSID:PygvCgD3P6M1Wv1qx8alGg--.56103S5
X-Coremail-Antispam: 1Uf129KBjvJXoWrur18KFykKFy5Jw1rGr45KFg_yoW8JrWrpF
	4UGrWjy34rXa48K3y8Xa48t3Wv9FZ7ua4akr4rA3s0vrnxAwn2vrW2ya4Iq3W7XFWrZr1j
	qrsFvw4DZr1DWFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRuVb9UUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7h6-Lmr9Wj68RQAA3r

A final hash request rejected by the queue runs generic request cleanup,
which releases the DMA cache and TDMA descriptors but leaves padding
allocated. The request will not reach completion cleanup after rejection.

Release padding before generic cleanup, while the TDMA chain still
identifies the request as a DMA request. Keep resources allocated for
requests accepted normally or as backlog.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/crypto/marvell/cesa/hash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index f698d3df535b..d2fe96d865bd 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -796,8 +796,11 @@ static int mv_cesa_ahash_queue_req(struct ahash_request *req)
 
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
 
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
+	if (mv_cesa_req_needs_cleanup(&req->base, ret)) {
+		if (creq->last_req)
+			mv_cesa_ahash_last_cleanup(req);
 		mv_cesa_ahash_cleanup(req);
+	}
 
 	return ret;
 }
-- 
2.25.1

