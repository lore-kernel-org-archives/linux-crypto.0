Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB2828C2AF;
	Mon, 30 Jun 2025 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294335; cv=none; b=h7UvjQ568wScomzNrrXnsN6r4qK0caA2tyuwH7PLXc+vuqIc2mD+dCyLWLtldA2sm+m+JiF0E/EdzP3zrXtAXIUTqNllTolSUJY6HFhI1V4jUbr4WITLGSS7uD0m+N811hB0Pem7LA/3tT6FLN6RB2o7mF+6amO4vBnmhOglQ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294335; c=relaxed/simple;
	bh=/iAxXW6FbvxTp0QaulS0wqiv/9rrGOG34RWaXC4nkP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lNAoABBG7KDFsVwr3yOYDzoqE4ydD67nJmKCEABXx9oZeqvCWnzB6qmCIXngI51rgIMWewfFnlkW7woLvN61V0iKx+96r+4vt67Ut/dsVTjMH4XPeMDGqmR5sF8gKebQ1txFDdiTtZgtBxjjsvWGYHoF0LCPq+0lZuxLIcMjFxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lALjW5e6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lALjW5e6"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55U8pP9h023538;
	Mon, 30 Jun 2025 14:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=eVXnPYrdhwrNl0WhAGMkGzMVySJUnLyM9PGWL+RRa
	dA=; b=lALjW5e6NI6Xk7sjgPxC6ly/BVQwr7Wc9NJVC2NuXdqf5+djNI79kIgaC
	egmCapqJ/CTCdal8mWfZEXuAmBCWRqh324oQig5Cqad1ks1PeJ5dW/bo0C8P6i/F
	AQWt4bsAAjjacs0g9OO9mXL7TKLNHkIullYZLXyTWdkyPfI+JckTTLvHlPvp0oj1
	cJBeoUDfmDc5MLlyw14G4JblzXopH3bR54B1DZmNn7SMBCg5q7ZMdnlaEWr1VBky
	xTMmEAtrqPjjT59cMEIhsbYpjZXLKPsOJj1hnxFOALvxsmQYBvhUOnAsmGSphKwA
	fgRvn/ahO1nbY3oUGlxFcq/FUc0lQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47j5tt2a57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55UECltw021909;
	Mon, 30 Jun 2025 14:38:43 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47juqpe88t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:43 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55UEcgB66947526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Jun 2025 14:38:42 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD7445805C;
	Mon, 30 Jun 2025 14:38:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFF7A58059;
	Mon, 30 Jun 2025 14:38:41 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Jun 2025 14:38:41 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH v2 0/4] crypto: Add support for shake128/256 XOFs
Date: Mon, 30 Jun 2025 10:38:30 -0400
Message-ID: <20250630143834.2748285-1-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vmYM851hNMGF9Gf-Kko21cvYlKK9X463
X-Authority-Analysis: v=2.4 cv=UtNjN/wB c=1 sm=1 tr=0 ts=6862a177 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=6IFa9wvqVegA:10 a=JFUMmdeob1UW1lXIWCQA:9
X-Proofpoint-ORIG-GUID: vmYM851hNMGF9Gf-Kko21cvYlKK9X463
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjMwMDExNyBTYWx0ZWRfX9kxb8Sq3J0JA knzNPpCfCXC2PXhJ/XB7jaCERKUgh2dpumkSbNSbhGh9w50Pbb6ExB9V4NKpFekoYv+5+5AUS5f TpvTw0p7ccpCoqPXN3qkh5lnRSyNe7IeZWVrxr/86g3CN2+CN19n1jNaf2m++rBJWH7AJ0gTXRo
 lHoOa5jjD7vQ+84e+y/ZFFLh6G2P74PO3xy82JwZ6kXuF3A4jWmBiD3ezSpbYJwEX1i2TaOOGzT 334pK5yiHtTg6e/ntmH/CTBIHeJP+1+u4ygyRhRHtxX6R5PMJCnW03wp5MVGPEU8gR7zO0K6vl6 czrftvfWxWSF9AoKpmiCMWEAWVWekDBNV/QLBez6AhOqgsKcOoJxIJ2ukkBrjeG7FQTvq475m/5
 r4xow01EJR4tJOrlLKnpTMlz/Cx8qMz+rhfiY8YUbk32xBqsgmz7PBbCxvYMSUFynf063YjP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-30_03,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=896
 adultscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506300117

This series adds support for shake128/256 extended output functions (XOFs)
along with test cases to verify the produced digest and XOF output. A new
squeeze method is added to the shash_alg structure to get an arbitrary
number of bytes from these XOFs.

Regards,
   Stefan


v2:
 - Refactored crypto_shake_squeeze_bytes to be called for arbitrary number
   of bytes to return
 - Adjusted XOF test case parameters to better test modfied squeeze
   function

Stefan Berger (4):
  crypto: Add squeeze function to shash_alg for support of XOFs
  crypto: Add shake128/256 to generic sha3 module
  crypto: Add tests cases for shake128 & shake256 to testmgr
  crypto: Extend testmgr with tests for shake128/256 XOFs

 crypto/hash_info.c             |   4 +
 crypto/sha3_generic.c          | 238 +++++++++++++++
 crypto/shash.c                 |   9 +
 crypto/testmgr.c               |  70 +++++
 crypto/testmgr.h               | 522 +++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |   2 +-
 include/crypto/hash.h          |  28 +-
 include/crypto/sha3.h          |  19 ++
 include/uapi/linux/hash_info.h |   2 +
 9 files changed, 888 insertions(+), 6 deletions(-)


base-commit: a71d3e1beb7a9637eb75929b995f01d20981f013
-- 
2.49.0

