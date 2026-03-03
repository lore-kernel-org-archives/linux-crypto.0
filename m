Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D74C2628D;
	Tue,  3 Mar 2026 00:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496420; cv=none; b=qHSokysbljghdX7v0nWAti4J1qqqs5jisdGjgsJ+Uz1mzftVJ7Sw5nOgYYOmwXpkRtf8bG7wUHlGrxrwTk9akij/EwypIiMa/pX1witoYPbaXt3PKpXMC2pfqAROYYhGkFitHbpETzqCAb7KnyOZWa+cXYtq79fIQrOVwpd30ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496420; c=relaxed/simple;
	bh=VovqX+dDBeuZTMcIBY0gBDKmakdpAmXBYTEBVdbKK2A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=j9RzY7tyF9VGFM7iBnaYCoIAMJGVZxjf9U5lezwmcw+XkZ4M/Q75fkkCZmBzfTqz9QBT0xczRTEor5TQNFZwWJVVToAM05mmA6ZY7fU+kh79zev1WCIqV1VIbpV0Xoos0KCU24G/gV6x+IuFXgT8CealX4ZPKj1WsBKWbWHx4jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D1lAtq1f; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D1lAtq1f"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622MNuMX2134799;
	Tue, 3 Mar 2026 00:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=trXVyDpBDjACb8mt5A8r/6LkUXyWS
	2ZkBgQVUUsUzus=; b=D1lAtq1fsKhmzpRZEWNfVTLLYdLK2Eg8Ynu5MbrSs5FEt
	ESLj0NwfYSfv/mGVyB8eyrErWG7+WXWtHyCiT1YZ50Ve5f0Pjn5VZ1YZLItLyihR
	uhDHJssTK0giU1+nxrgq9df2fYrQomckOVQesiRsHNISVhOME9lWiVZCMuEQvp3s
	3/J84NzXjiWmlfsInT8RhLK94FDjiXLket0TzbBjf+xYnnqXNfT4pEJEeoqNN5V9
	HlrbO2ASBsHHGyDG2rJtkKJiNplqOh6kYiBMBLFH7qfN/NgdwpqgnFzOuwqI+vcY
	lOVHUWp/cfUkYNRN33p0ZgjrhPZVQsPqSiZxhXZNw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnjw304hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 00:06:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622NU1Ch029749;
	Tue, 3 Mar 2026 00:06:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt9ms1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 00:06:51 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62304Ux2035712;
	Tue, 3 Mar 2026 00:06:50 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt9ms19-1;
	Tue, 03 Mar 2026 00:06:50 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        ebiggers@kernel.org, saeed.mirzamohammadi@oracle.com, ardb@kernel.org,
        kees@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: tcrypt: stop ahash speed tests when setkey fails
Date: Mon,  2 Mar 2026 16:06:40 -0800
Message-ID: <20260303000641.770327-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020174
X-Proofpoint-GUID: inu-KTc4vgqV_I34VwhrmhEbxIN0ZHqt
X-Authority-Analysis: v=2.4 cv=O5c0fR9W c=1 sm=1 tr=0 ts=69a6261b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=wgutD-Afl_WS_EJhig8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE3NSBTYWx0ZWRfX7avAY1bJjRpT
 ccAA1iFwboWSKjIuCbQkUtLG1ZNtIl/ttGSEIkLyDZL5W83/EpXlY/AY+VmITllmamjAX1P/EFH
 tFXFi6VOmW0k8cYolgnq66l+MX0Q++Du6MhhP3HEbO/uEb70KTrrALPNY4Umu8rEOvXxHm+U9OO
 cN0xX+dAb0IaTR5+3Cb0L/V2MeigQM3wTGwkUnsxYqwuwKB/emao8LQSbkef4pEFU0iwK1OqfDe
 8Hrv/mK4WkHulgjLPy+rQT8bEqEaU3ksDU+vn1y7vDxwL0N7pbbWd3h23ztl3csZlVfoaMKRMa6
 lI84gipnIwq6I4LSPoL9vipEpBbxiues/eWg8CaVD3gg/a3SDQ2Z+wLDkHQcyW8cngHN36nVjKZ
 EfqeLU3LUESLUuoZszYxh0NzSui+OZrX9iUMo2OOEum8E4NxuyNDqPJVKIzhI2kC9zzfOxxRWCd
 5g9OKQHDNKF96bP+B0w==
X-Proofpoint-ORIG-GUID: inu-KTc4vgqV_I34VwhrmhEbxIN0ZHqt

The async hash speed path ignores the return code from
crypto_ahash_setkey().  If the caller picks an unsupported key length,
the transform keeps whatever key state it already has and the speed test
still runs, producing misleading numbers, hence bail out of the loop when
setkey fails.

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 crypto/tcrypt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 61c8cf55c4f1e..db860f45765fb 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -911,8 +911,14 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 			break;
 		}
 
-		if (klen)
-			crypto_ahash_setkey(tfm, tvmem[0], klen);
+		if (klen) {
+			ret = crypto_ahash_setkey(tfm, tvmem[0], klen);
+			if (ret) {
+				pr_err("setkey() failed flags=%x: %d\n",
+				       crypto_ahash_get_flags(tfm), ret);
+				break;
+			}
+		}
 
 		pr_info("test%3u "
 			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
-- 
2.50.1

