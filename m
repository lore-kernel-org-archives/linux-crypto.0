Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F916281366;
	Thu,  4 Sep 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001343; cv=none; b=YCW9nm+hbj/7EkzI9z1eSOtck/xxtrnxj4Y1eOD+OIF7tbyy8nz0O0cREyUUyaK5P8Woeejoy39yB5JzWgRX82hT0QdQfhqHVGa6A7aCTxJpxhCLXet41nHshvLMAH1FZUUq4KhDGWKEDYRj9Bhspdot7rLoEBXpnXIi+2rvhEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001343; c=relaxed/simple;
	bh=J3rVPEA4/1BMwE2GxpEvEu0op0zo67k0SPW7/jJm700=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rM9sT7km14pnAq5KnivyIRTfWUTCnr+5VPmkSplDqgm/+31IaOyA9uUajHTuzZZvSY1w68VLbY6b442jLLi8C/Mj3GivE+24/wMSWhVUcrmTemI5snuew/R8unOCfpoKHlCufLkzMbRLNfuYf2UtRp7urPDcmH4UH+BtcwkcqiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ESlDrF+U; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ESlDrF+U"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fjprp026747;
	Thu, 4 Sep 2025 15:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=8ZjPP
	SkaOLbxoYQFdXvGLHuAbaZP97XZAQxfmZvOqFc=; b=ESlDrF+UjFC7RxXhRVtnV
	7eexviLQBKKL9dqiJoK7Fb8n+eEDNMtdxY5s7g2d/n+xqvGqQnlUDTVTYdPM1h0v
	sQ1D80AsGqclCvSgav9EisPZGD21wETiqZurs8PMAbp0705yWaFsTj3iYM8Ex7te
	yp1bSIOJb9QBQZdbsKq6+lY9aABt8hOTxb5bklKWYWpi172SaKf6SRiQnMXscx+q
	t1CDB+82w4qD8bgc+xL0/fUt2eUfSByqt+b7gvxQiJFK3pq6dLqLcfHgFVCqiTNE
	A8SUXB89PY9vrRpm2Me8nJLPfZlMShlXLWoofz0ZtB4K3F+y1AoWSGvASUKrPzn7
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EsIQk040070;
	Thu, 4 Sep 2025 15:55:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtkyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:17 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4s000707;
	Thu, 4 Sep 2025 15:55:17 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-5;
	Thu, 04 Sep 2025 15:55:16 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH RFC 004/104] crypto: api - Disallow identical template names
Date: Thu,  4 Sep 2025 17:50:36 +0200
Message-Id: <20250904155216.460962-5-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-GUID: xpUKf88Jos_LOHnIrQntPAcLS8UXw8kg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX+QY5zy3l3ZUY
 AKkpPPaaD6U3xULvlQf7dNkmKBDQOg87mMB3JMpicIZVlw0uYqEA2yldkLRdwXQ6r7CkHUxHtwZ
 Bkum5owhK05McyqGcviXKpFZ8ZSL5FGBRjK8oC1CbH93ELofAwokFSwR7O8mgVuks9eTHYVYK/n
 L8wPwIF/tHOE9HUqDovZK+tlKCtAvh8CmRrVVQQIDTWy5KmPQc3GoQ9wwDqUkblvE1gStcLoDs5
 z1QFETXNhsV6Ej8uxj20gMwGWcVRhFlSCCZ8+gEMV79N2knQHeuwd3Bu4oCo36EZF+hObQiRrqg
 bK5gQBC7Nr0tOIlh5c+7MLkQgVv2BhhE8kEaJ3EEgsUQ73h55AHquM00uBalk+/cCIeetmC+l4V
 fGjAJt368OFUANLG99XBX7AimsjxkQ==
X-Proofpoint-ORIG-GUID: xpUKf88Jos_LOHnIrQntPAcLS8UXw8kg
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b667 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=t7CeM3EgAAAA:8 a=FNyBlpCuAAAA:8 a=yPCof4ZbAAAA:8
 a=-3I4fGBVCJMWvowuSIAA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=RlW-AWeGUCXs_Nkyno-6:22
 cc=ntf awl=host:12068

Disallow registration of two templates with identical names. This
normally does not occur naturally but results in very confusing
behaviour when it does.

This is similar in spirit to commit 27016f75f5ed47e2d8e
("crypto: api - Disallow identical driver names").

Cc: Ovidiu Panait <ovidiu.panait@windriver.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e604d0d8b7b4..e11b8fdb0865 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -546,6 +546,12 @@ int crypto_register_template(struct crypto_template *tmpl)
 	crypto_check_module_sig(tmpl->module);
 
 	list_for_each_entry(q, &crypto_template_list, list) {
+		/*
+		 * If we find a template already registered with the same
+		 * name, refuse to register a new one.
+		 */
+		if (!strcmp(q->name, tmpl->name))
+			goto out;
 		if (q == tmpl)
 			goto out;
 	}
-- 
2.39.3

