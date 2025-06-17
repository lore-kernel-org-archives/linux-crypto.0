Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F61DE4E5;
	Tue, 17 Jun 2025 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167891; cv=none; b=B+9rcqSMI0NWp11+tjMFEMkFh1ENQnv6sVTVyVzk5gejyyrpd5SnA8G+1Xin59eHQJm1pFuYmdZNkD6v+RLDW/sPiHyQTpzvXs/6ydF5nOtgjVKTnL12w/yCpf8In15NgwWLLSpuEblGk/OtjOvRxi5/NXj8R0scUjq3CaWeCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167891; c=relaxed/simple;
	bh=esMrRUhVxQ0I4vhlRI3G5KZvPL6Pi3i1HuA20IDydEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH3D3D3Wp556EBMAzDDnkREE8vO0NMWgZTLwu9/AX7XeCP0RT3M1Drgic/Wf3DZuMsiaEb4KXpWg64Er6bX4bu8crGa7sqpqGJNh5BMRoovb8H+O5P2Eum9dD1sl580yDT//rxocFaowgMvLgKmHQeXIQHHpgplpvoaaUkGw/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q2WCbY1T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q2WCbY1T"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H62E3p022181;
	Tue, 17 Jun 2025 13:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bXgwKY5RrrO1AjJ4J
	p0QF3c7EzQOg+1sfGkjB0l8q+g=; b=q2WCbY1T2hjfPNDppQJmkHZ5oPJ0mpZBd
	BcExf1tqsHcnGuFUEjqKbninad+WUn5E+iuXTwdriKFSpCfWrSBpA7hzwPs6rvlc
	2o8Iq5O5z+/UxUmMcDqeRZc4GvnJsQ3IC3zM33pE3f9fBAESwrdSvuJNb3QKKPq6
	Um98jc/diPESWF+hyLwv8xPLuWfMZxti4bo8wZrROjg9bkxwsas4IMCAvyAg53o9
	+MO41ZyXz663zzIyENH6LefqvI9fOkmpNuU9zCM+a57ThXLGUiLyVAOD7F/lofSk
	ddb/WZB1N0QjRWmwnDGZqeOyRvAskX4Wv6DXLzhJT9JIQuu+fvfXQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790ktgsnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HBYCdT010853;
	Tue, 17 Jun 2025 13:44:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 479kdtbxuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDig4020971890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 330D020043;
	Tue, 17 Jun 2025 13:44:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3C4920040;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 2/6] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Tue, 17 Jun 2025 15:44:36 +0200
Message-ID: <20250617134440.48000-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H9nXxItGsaQ2_vCLHc1imU2mmr78vTgw
X-Proofpoint-ORIG-GUID: H9nXxItGsaQ2_vCLHc1imU2mmr78vTgw
X-Authority-Analysis: v=2.4 cv=KaDSsRYD c=1 sm=1 tr=0 ts=6851714e cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=ZStr9B_HsUFEIA23VokA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfXyhZknCgdg1sy IbZmxzKCGuvw+S6/zDr70qBysVVSz3SYsmzuSZTI9y9MEYKTdQhae6UHtzvgUnPaZvFgDsLmD58 24/SNgv+rfsK1q9xpkC66gDLSLymkgymIekgST9exP5r18ygpRRtz7MZeOxbRtKjbif6PzJNOis
 k14Slr4l9qZFI2ccePMr2IfSaoi59JN4PcafrheqKUQzJTsIVBTCKlDansQKwaidAC5Uqd6OeD4 laZuublcP3ePhJbET9BErtFOLS3Q4UYwmHWllTNpTu4uipVFeCwYs9HLIXWwDAcjHJh4FyyTcaw N87G5Km5xjn/logF6K0j9FsZTtLvnRXRWBpGNX2EvYD63ea6Fo1JwV4KIQK/5HcTJ7DacudNH9s
 1vDwY8eHDPrxAAdjscSDX5wKK1UGV8bAiXbvDtGIApCbVzsyzy1182jxy1uG4o7Zig4nj1xt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=599 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

From: Holger Dengler <dengler@linux.ibm.com>

The CPACF KMAC instruction supports new subfunctions for
protected key hmac. Add defines for these 4 new subfuctions.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 54cb97603ec0..4bc5317fbb12 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -129,6 +129,10 @@
 #define CPACF_KMAC_HMAC_SHA_256	0x71
 #define CPACF_KMAC_HMAC_SHA_384	0x72
 #define CPACF_KMAC_HMAC_SHA_512	0x73
+#define CPACF_KMAC_PHMAC_SHA_224	0x78
+#define CPACF_KMAC_PHMAC_SHA_256	0x79
+#define CPACF_KMAC_PHMAC_SHA_384	0x7a
+#define CPACF_KMAC_PHMAC_SHA_512	0x7b
 
 /*
  * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
-- 
2.43.0

