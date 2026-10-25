Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897123;
	b=n/tDDfTk5Utt+BG1Z9W6gsr8/8LMA23qcxKB3lXtvu+Ik8WaJBMhOc7F5W7wMqhpHl8h
	 5CnwsFS+619xuE9GBOD5lllfsuvJQRMYu+qqzDf9SclMFh/qUdFtEFWrF2QO2YSzlAbD0
	 x4cHvljXkeD2PudgnCRKqDbOR51Ul6TRHjji1ECHGIqA6o4pcT5WgEE9StgGoqoTC5P+8
	 AdPqtqCPH6Mpq7btmZSt8YsaYD9z++GyryOW1aD4j9o0EbJO6XaQulZCXGo+BWveWFaje
	 6+sls9pRm/U0HkqUtu05phyEIxcTGtvQRTSUhPBj/gF7ShHlAJy8dl65lGImNg/M26A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897123;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cv9hAJb6OOBGgjMXAhD6mSWLhoRdml/4YCRPOys+VM0=;
	b=MgohfAiT4A7W6PdnzWa84RAzfrfTGM6p5S3yjA4AalsV+DLsVJV8HqiuY2OCDNcwXV3X
	 pkyxcO7xnALTn7s9P9N8dbZpMISbBMLuh0b0pMdXw8kpqqAAiEQPNKiXHwdtB8BrhlQ86
	 azx51MAPe7fcjmwDrtpyKkhIe7QjqOXpv6uF9SX/EwAn+y1R4zuXOe8WsGHd33ufhwgYS
	 z318GFxsieUwTBGYI7FOjw67Sphg1t+SF6pOdwz7B0GN3zpOspyPE9sxqEY417EkGly6U
	 R6bDNN9I6nFwdYCnkyraO/D1EJjwtS+nm87G1EobJc74q0h7ma8bqxdFU8lbdFjYKJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=TDuHTHwE;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B19606A31A;
	Sun, 25 Oct 2026 02:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8B19606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=TDuHTHwE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=TDuHTHwE99WajUA2Hhc+0tvmyloDHsX0/zg4C/fCNX1uUriSmZL8Nx1v5hoOc2/6ZgUrxhoIEblC3
	 dzB5zMfJKbBxX6Pb/JLAsf2iGFxCW91SXExnPfPivFKE7rRKadFaUoM/TfjmRnEQe2FLoaAJNvaoev
	 Q9heKGgIZG/MEnYM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46add70574a7-e26e3;
	Sun, 25 Oct 2026 10:58:32 +0800 (CST)
X-RM-TRANSID:2ee46add70574a7-e26e3
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHA-W6400298 (unknown[36.137.216.17])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86add70534cd-7b194;
	Sun, 25 Oct 2026 10:58:32 +0800 (CST)
X-RM-TRANSID:2ee86add70534cd-7b194
From: Tang Bin <tangbin@cmss.chinamobile.com>
To: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] certs: Print correct error on pkcs7_parse_message() failure
Date: Sun, 25 Oct 2026 10:58:29 +0800
Message-ID: <20261025025830.2239-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.52.0.windows.1
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

The panic on IS_ERR(pkcs7) printed 'ret', which still holds the result of
the prior successful x509_load_certificate_list() (0) rather than the pkcs7
parse error. Use PTR_ERR(pkcs7) and %ld so the real failure code is
reported.

Fixes: 8cd9f234f706 ("certs: Move RSA self-test data to separate file")

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 crypto/asymmetric_keys/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index 98dc5cdfd..179b385cc 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -41,7 +41,7 @@ void fips_signature_selftest(const char *name,
 
 	pkcs7 = pkcs7_parse_message(sig, sig_len);
 	if (IS_ERR(pkcs7))
-		panic("Certs %s selftest: pkcs7_parse_message() = %d\n", name, ret);
+		panic("Certs %s selftest: pkcs7_parse_message() = %ld\n", name, PTR_ERR(pkcs7));
 
 	pkcs7_supply_detached_data(pkcs7, data, data_len);
 
-- 
2.52.0.windows.1



