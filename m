Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292B129CE3;
	Fri, 13 Sep 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726238876; cv=none; b=BLYyhtkV9cPXMrAAgcpNr+8CNAs636ACUmMIcN0Bfbl+WFNXmVPmSe/7wt6V4jGlpCvlRR+EsdI7QzJgbsmaalpnef8hylLkwLdrEDh2DQOZho6nxA7nYr5n9zSN8NYW66O+bSkKcX9+Vs7K8curvdKHHZR5p68IXKBvV/Hn4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726238876; c=relaxed/simple;
	bh=FsvMNSjsqkmpovx3KipovB3Nr37RFysiVdtAEGJB5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gecMYcY+QhKBZtT/mBO0gGGzePnaO7lv5lze1FF3YywqI0m3NI90aqsJsOdou/PjBE9PHEMY+e12BcoXh7uBOlPECC1WBwkcKxjf9N9n859I7uc6z9/olChanKWQw9ZKf8GnFcyPFpORolT8PKJBrEjT/QhIBUZNsFdACF3F2NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HZ4lmL5D; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HZ4lmL5D"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D74ZVp028394;
	Fri, 13 Sep 2024 14:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=aA0VD6ILZwVsRCqF6gyMIXcvET
	Ry4AHsm47dMSMexos=; b=HZ4lmL5DfAEi7SrWDWljVLFu/HrpBbdPmmOfbd5XNZ
	DalIyxewb9m7uYdGawvPM3GwWsNir1FVhgzJPUx7n1qghWrp4Jrn5/p230j2NLvB
	PzIwecRik9bz/0aOX3n90CY8ecNCcvyNG+L22PaFgVkLsKaZUTBzoeXZO9vGQ4Xr
	2VyKbbWO/sRrfwv6qgDmL4GISwGTM5IGB7UJxjn0+pq8+XSHh4LhfiJuNmbQ0vNO
	SDXFhI6gGUzO+IJFwMiVLVxOkHL0l1PvhioAVpWqOyFIYWGszElhjN7WRyKx6pQW
	4ZQBSQOOhuTfjtfTAfT6s+j6szsR67+P3HmG+1j5sLIw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41geg02de4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:42:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DCgFTA027389;
	Fri, 13 Sep 2024 14:42:36 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h3v3pev3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:42:36 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DEgYu522413890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 14:42:35 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B762758058;
	Fri, 13 Sep 2024 14:42:34 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BD9858059;
	Fri, 13 Sep 2024 14:42:34 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 14:42:34 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH v2] crypto: Removing CRYPTO_AES_GCM_P10.
Date: Fri, 13 Sep 2024 10:42:23 -0400
Message-ID: <20240913144223.1783162-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -CEw3quGPWS97YQJeKZRXaB0Yg4lcMyu
X-Proofpoint-ORIG-GUID: -CEw3quGPWS97YQJeKZRXaB0Yg4lcMyu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=808 priorityscore=1501
 adultscore=0 clxscore=1011 spamscore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130102

Disabling CRYPTO_AES_GCM_P10 in Kconfig first so that we can apply the
subsequent patches to fix data mismatch over ipsec tunnel.

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
 arch/powerpc/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 09ebcbdfb34f..46a4c85e85e2 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -107,6 +107,7 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
+	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
-- 
2.43.0

