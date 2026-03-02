Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38A33507E;
	Mon,  2 Mar 2026 23:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495974; cv=none; b=D0tsDJjNMZgjz9cR7gW9tlEHnXUFFwByqwt7sltfmRGd4s03TZl3Zz8Uca5pm5bGcYAO+3ROE/vfwLpTsWvCKEsTC9ebimfDVnZzIj912CT+Pu2C0EEsHUfAXaEPUUZVGlnwq3tLNB2qNFTpL42/KK5FcOsWExB9RzCjtgoFe0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495974; c=relaxed/simple;
	bh=ByTZHXXMZXQ7rFxOeNnSkGQMQfyoYh3farPRTwm3Ozc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pKM3hdxPFMkh47bbHmXcTHsLe7XLgaPCmsjCQDRWPVYJz6NLee1gvpIJ/VR/sLE6fIvS8fYWcyklCZWPRwbytbfYz1EmN83EchID/ZpjQixA2B/C3K4BkbfoQYKwIbmyz0V2+hXcgVvj13GZjh1ser+06yqHmZ80U1RN9azBf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RTxPycXf; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RTxPycXf"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622N8dmu308732;
	Mon, 2 Mar 2026 23:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=qm2ju/ZhJdcOs05AeV/22m7qXJtFW
	zWIGciHTydfFqU=; b=RTxPycXfRFulx+dCXLMM6lMWrW/jW7Bf684D8mV8KMkom
	diqIE/5hz52MRF8F1F3iJFc2IpHNT26QJUk1fhkyD2Gvh7ZOb7oOYfOWn7OZd1dw
	A9Ml8tlBgM77vEVRESr3dJVgbYIodpVWQO3gB5dOwDEHUzN/55KHT74otUfH0xXG
	45aUt9KwBJ+cTXBtcZ1y2KuSlXJO0GH0FvSZgQSikRFZn8D0pLvsLYc3dgeiOyaI
	4Ospam7sQO59AdA6Euf101zW5bhpiwIC9AYV6dG0L4ujqEx/3GWHt6Efko/Y92KX
	FJf/5zK3ehtq51gSXE3Mzr5PB2R2XcCCgR/OTRAWg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnky3r1ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 23:59:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622LNqPR037437;
	Mon, 2 Mar 2026 23:59:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt9bp58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 23:59:22 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 622NxL6X021673;
	Mon, 2 Mar 2026 23:59:21 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt9bp4u-1;
	Mon, 02 Mar 2026 23:59:21 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        ebiggers@kernel.org, ardb@kernel.org, geert@linux-m68k.org,
        kees@kernel.org, saeed.mirzamohammadi@oracle.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: tcrypt: clamp num_mb to avoid divide-by-zero
Date: Mon,  2 Mar 2026 15:59:14 -0800
Message-ID: <20260302235916.769942-1-saeed.mirzamohammadi@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020174
X-Proofpoint-GUID: 9faPgIC8fuhHpQDqS6OH4aV9MK6vuLG_
X-Proofpoint-ORIG-GUID: 9faPgIC8fuhHpQDqS6OH4aV9MK6vuLG_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE3NCBTYWx0ZWRfX39FORtLHKunc
 fvO+APnhzhq4ybjkY84Le7SpA8hOP+Efx8nd3l8r9YJqkBzqOfppFSX+DZG7tWEGdNuKcyrq3Pg
 y+zjhSWIWFsJCdk9nBdG+Cwi3qt1rwGZ8h6s/yisweBqOfVG+J4lbnvqMBYbmKnRBvnUOiHIUey
 njDAAAJB4nyfELFky53so4UWCWrxKw/b5uUICIpgJkl6+j2BlbCsxOTD9+7JK2w38Qswesg9lWX
 iZXXoDmnFwLRJ1b7g/glX33De3R5wiVrDzFgvpDhCuR3/7ge6mZ9EJukbSviy81tuDGEjaLekwK
 q+URQbSow1F4gTjiq+C7wSNSg1vfDmOBJRpIVRe78K9w52w0MyXNgp6kvU9MnMJqDtouXOlCJip
 R+f6ppgEyUPWn1SkS/M1LF5PCj+WnJZBi5BmGZEPA9a+YImOCKYUfX0mWqDAChOnYeAoBgzVfwC
 3O/S0NqyfSVgPbafd+w==
X-Authority-Analysis: v=2.4 cv=EMELElZC c=1 sm=1 tr=0 ts=69a6245b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=DXMEOIiJseVBieOFI8IA:9

Passing num_mb=0 to the multibuffer speed tests leaves test_mb_aead_cycles()
and test_mb_acipher_cycles() dividing by (8 * num_mb). With sec=0 (the
default), the module prints "1 operation in ..." and hits a divide-by-zero
fault.

Force num_mb to at least 1 during module init and warn the caller so the
warm-up loop and the final report stay well-defined.

To reproduce:
sudo modprobe tcrypt mode=600 num_mb=0

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 crypto/tcrypt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aded375461374..61c8cf55c4f1e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2808,6 +2808,11 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
+	if (!num_mb) {
+		pr_warn("num_mb must be at least 1; forcing to 1\n");
+		num_mb = 1;
+	}
+
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-- 
2.50.1

