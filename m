Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BDD24A06D;
	Mon, 23 Jun 2025 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684728; cv=none; b=NrSuRU4SMQPwLjd+o0nW7dGa95sPzsqu2D9ZHZlJ4N4A4W7lPW6hYlKBwzapY3lkAUX5GNHVwxNw3u/G3sJfBVJU+BBArff3Tn/u7wYwpIY0VOt3DE441pGbhF1AnNyJeDrmzI4D9agzNZ9JSf5KLDG0o7/SPRwQbVn7eMgzgMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684728; c=relaxed/simple;
	bh=wMGsgvucVLfYkbHXDDKTBfBWO+Z21DjXdQnoic/p3Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p/w20cGita/o+59w7EjlBMlixdQ3e3EQpToXYoRIWBuYoS4Ww8C9B1K5d38QgC16RIVOj0XvRp0Be68oXCd9r94rH7y/D86v9WfNvBWmNIs6RN2Tn6dT8MpawuoVQZthQPk0E4SogAF/8wgTOQ7KEWqo2IVuoKvnndDXPGZ6yUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lAB2kcxa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lAB2kcxa"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NALo9S027421;
	Mon, 23 Jun 2025 13:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Fm1TgEJqD4pkBL0AQWKZeMMZSLmfKyy9sV2Yq+pUN
	mQ=; b=lAB2kcxapN6l+BeUGFYK4nZugOEGX5+OGYTjiw3s2NTkQt/UFlJpBBvSI
	Aetb7c6+TR8Q6Qeae8muA+/5wXBD4Cv7r9r6py8NBC/Tzv8Qsy3nV357TODfrBaB
	8hp/RB/LSZyjnge/lxZfPVdfEyqEpzqeRZTWrtdvIyaKZthfgCuFgm+HyjjnQrQg
	62DQrl+M7u/JFzjkRNpX3KG519UJbOYW4lKyWKQrkQUNcMRqBKYWmeagVVvi4sqY
	nJkSszcfgAAbHfJd5dkoY7EJ8+pPE/7OHOhYZXKPDDCv8UFyt3ZWVbv2xLQwK/Bn
	PNpqfWQeOWBNsk/jl3OHheShhz74w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dk63j3sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55NDI6ns015028;
	Mon, 23 Jun 2025 13:18:39 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47e72tf01b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:39 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55NDIcSI7406200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 13:18:38 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91CF658043;
	Mon, 23 Jun 2025 13:18:38 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1660358055;
	Mon, 23 Jun 2025 13:18:38 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Jun 2025 13:18:38 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [RFC PATCH 0/4] crypto: Add support for shake128/256 XOFs
Date: Mon, 23 Jun 2025 09:18:26 -0400
Message-ID: <20250623131830.2194643-1-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDA4MCBTYWx0ZWRfX4Oz46gKGOtb5 69gLl/xGVOUhyGnJDyVpWyGAKLq+vKHMKdSrRSzpk6tB6+tmqSaU+dI0rFvSq/2PND/fxxWsVI6 CUcCCF+ZoX0XCpwbLWmDDDOfpd4Wt6jvJ0jaGyUaQF3wscangwwnvJZy6CDJeEfxlFA7AVklUIq
 YDBO+VL/rOVd2aNAACdbLkF4oR6jL8i4NzZkZOBSHlmWd4GvUPDeoE3/dgVqhuBOk1/iYuOUC6U CrmxklaZKzaF9IOd8v+eBdLgoMkx4FtJ634V2KyIFeU0ptgmGH58aCOHvx8/JjdYF+3IOvpgDDA IMLJLXAfsZsGDLVlCi1IRZGDNyRVkt+zsHeo6zkMvU5AaUkjXou77AbxMaRvIcO8zncA5bs47g7
 nUX3pIBqgEBIQo5Ovsp1b0JPdMSgazY7RyxfUjW0Lrce3g9FSTnBDDKVhx6Pm4sEYzxQU/nW
X-Proofpoint-ORIG-GUID: AkDESnke_8RBEtgfl5LSaqp4IhG8v3rJ
X-Proofpoint-GUID: AkDESnke_8RBEtgfl5LSaqp4IhG8v3rJ
X-Authority-Analysis: v=2.4 cv=BfvY0qt2 c=1 sm=1 tr=0 ts=6859542f cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=6IFa9wvqVegA:10 a=JFUMmdeob1UW1lXIWCQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-23_03,2025-06-23_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=686 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506230080

This series adds support for shake128/256 extended output functions (XOFs)
along with test cases to verify the produced digest and XOF output. A new
squeeze method is added to the shash_alg structure to get an arbitrary
number of bytes from these XOFs.

Regards,
   Stefan

Stefan Berger (4):
  crypto: Add squeeze function to shash_alg for support of XOFs
  crypto: Add shake128/256 to generic sha3 module
  crypto: Add tests cases for shake128 & shake256 to testmgr
  crypto: Extend testmgr with tests for shake128/256 XOFs

 crypto/hash_info.c             |   4 +
 crypto/sha3_generic.c          | 211 +++++++++++++
 crypto/shash.c                 |   9 +
 crypto/testmgr.c               |  72 +++++
 crypto/testmgr.h               | 522 +++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |   2 +-
 include/crypto/hash.h          |  25 +-
 include/crypto/sha3.h          |  19 ++
 include/uapi/linux/hash_info.h |   2 +
 9 files changed, 862 insertions(+), 4 deletions(-)

-- 
2.49.0

