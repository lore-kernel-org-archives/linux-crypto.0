Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BBB48422A;
	Wed, 23 Sep 2026 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158570; cv=none; b=kNoUhPyuZRg0uTdsAW87WT2gKZ78WKK30nMItDI9BZ2O7t6dslj5sZA7h0HgF5frF//nsFMfuCrnnjk3UXzgmeWoAEa2z2TgFDVf00XivC+yPVqaLlgnQOa/g21UeE9H4YONUuGtQQsXYFTFovUu5ASlUD53JmdzPG1B0S9/MmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158570; c=relaxed/simple;
	bh=MaJskP6/diGjUwoycuIsFSR1MNaAh22N0ogA4RMv3v0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z7pv/fwWkt5xckliYPFy7vY1C2P32Xsi2lM7Bf62wvvowAv4BVj+tVhKfwLncJlmUI8+0as8YIlT6EZIOuCuibZWYA94awUSoFgDVudjBIb+xdTMTxn1oCbDsiJdluMXTf3jYaWhRUVcgkXOe/FaFSf+r45/h6q1NiAOxLKol0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=TDEJlpGl; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="TDEJlpGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790158529;
	bh=phlHMmByFQPe2QHmU6CchxcAyR99WoDvlE01J3a4vwI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=TDEJlpGlgFQ0DmddEgpzYrFiLjgTceREkkUb9wN+zgUE9pbJ/bOzy8L53eniNdq1M
	 jzxVGwU7HURyCxGA5zt5RYK2k6WzEcJbZQ8iqxiRn93/6d3GxX6XPW5cjeoMd4uQF9
	 hp1QXs+A/5jg1LVLnOFcMhtB6PPNHwxDt+Rf7eWk=
X-QQ-mid: esmtpgz13t1790158510t9137bab9
X-QQ-Originating-IP: 35IqI3CFwEkggQc9glO3TZdHFRGHYFK/fheLZhaLhqw=
Received: from PEN002676 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 23 Sep 2026 18:15:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13859201302944247303
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Radu Alexe <radu.alexe@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Wed, 23 Sep 2026 18:14:57 +0800
Message-ID: <FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N/bTtgZmY0ZebqJYj/R0e8ecSzVZCEFinVvecEZQ1w5f+HS8J6sNZ3Sy
	0Bbao7F9S636y1zCeTdqkcjE8qX+GcmIW3wmjfIKpX3H4vrIflMxNfq3fCWsOot/SwV9zuz
	sOTlDo8Q0g1a2getCGVjrj/OQ8I3EgAXUBXgc7jU2HicZdfLdA0vStzJN84TGerbyXQODmn
	5cmc2rgrk6/maVCf0pHMGVXRnGe8mxQLcFgzMQrpKe5ZR2/kgP+WYUM4FFxEoUKoHljvBke
	pfd201p+9BUe5E9i3c754wTG92hwI+USGHvvWqsDss4fOClxikSdkrUrqdPyqn8+ZfkuVp8
	iC/TUOQmG5MbLBHoqAk2uQ4FzPkUPKmekjfgnPz7PQYvS11sRoke+ro8Rzi7tD4hzPtAqmH
	hYF7lwj8CiHH7KRLkmrtAY7kVl1HXzOaNpnDIU94hevtQ7km3aHJFQrlwMoJyUXy4rvdtai
	uzYkb92iWEQBNjbOwdzx/rYSsJE643JOBRd/7LrJjMb6otgLeB1Wf35C30E6eX6Lq3GVf1Z
	6y5IprknrjUknhVh/bUHFuNJTr9vCELf06JvqIAHgpTAcqJ00VYM+RytPx4p3x3LtyXklOQ
	EbuUQTC0Q/sYgPklAOablQbFAZvBq2rOKSx2+/KQSKzrqV+rPssDiG5zPRNT3uSGy19QtxG
	FFiQD7ntjxaLhIC8H9wP9mo4GugC6uE3gefdFCTOAwG6wLqSxXCSOkAZr/0HG+Il9iPbZO8
	N34folbkJSAHFrld7ZNEw3bgMJp+s6g6jdz7or0l7Jcp1XmJNpz7nxDy93+Qr+5HcjGH1Wc
	e03yFzqefFXlhIIKEFLWE+36GWmddOPOmFeihI7x7A41tCCyXBac32rVnC5DhWedFCQsMpu
	J5ecsMu/6LM/7LYLI3pK5N8YP1P78i3BHVPUPYH7RvQyajoLLtSo1zxWNDMPEEs6QNPkio4
	XKzY4y1lbKQUlvmZauWsoJ6WO6WkhL+ul1iZUgEQLm5hwRv7M5ARw7/T1utjN8w57fYLVky
	GhUMe/Bhda4ou7+1UUlEwbSL4Zb1o=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

caam_rsa_set_priv_key_form() frees the partially allocated key
components (p, q, tmp1, tmp2, dp, dq) with kfree_sensitive() on its
error path, but does not set those pointers to NULL afterward.

When the function returns an error, caam_rsa_set_priv_key() jumps to
its err label and calls caam_rsa_free_key(), which frees all of those
same pointers again, resulting in a double-free.

This is reachable when the allocation of q, tmp1, tmp2, dp, dq or qinv
fails, e.g. under memory pressure, or for a malformed key whose CRT
members decode to zero length and make caam_read_rsa_crt() return NULL.

Set each pointer to NULL right after freeing it so that the subsequent
caam_rsa_free_key() call becomes a no-op for the already-freed fields.

Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/caam/caampkc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..ac515ed8c575 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1033,16 +1033,22 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
+	rsa_key->dq = NULL;
 free_dp:
 	kfree_sensitive(rsa_key->dp);
+	rsa_key->dp = NULL;
 free_tmp2:
 	kfree_sensitive(rsa_key->tmp2);
+	rsa_key->tmp2 = NULL;
 free_tmp1:
 	kfree_sensitive(rsa_key->tmp1);
+	rsa_key->tmp1 = NULL;
 free_q:
 	kfree_sensitive(rsa_key->q);
+	rsa_key->q = NULL;
 free_p:
 	kfree_sensitive(rsa_key->p);
+	rsa_key->p = NULL;
 	return -ENOMEM;
 }
 
-- 
2.51.0

