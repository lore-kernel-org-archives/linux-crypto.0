Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC7727AC3B
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747229927; cv=none; b=P/SX1RNBodvb7cx78bv4oIUUTgT+N3xkRUCpjcSyLGHufevnBNff34Lk0grAsphD0Zid2PNtF9H5/3AL5L4RLdRgbf8z2/AkminOFQHKcOFfFWJOb3MuSRCcKCkQVZaWeAZ0qJSossgvcDjMNnkdz+nuWYAXrzDPfFikTzkuYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747229927; c=relaxed/simple;
	bh=9ZNgZQCbtcPxnTqyGrYCvyJqjfRD0L62nFhxkrgsqWc=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=asCcW/8k9ed3OXXwJu5SQuIHoKZ8P+BNGKN+hHZ8AbIvcCl1Q7LmpPCU+etX12h74s+xZdYnErqEk9WmBzvpl5OM4ilnchZheKi5eH53/dxQLJg/zHrfN0YBvVz6ZkWoXG+ieHg2qbaf5gsSJenFfANbhrujr+fMe05uPyYSDVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hbv5tEVS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hbv5tEVS"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E6IPqB026383;
	Wed, 14 May 2025 13:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:reply-to:subject:to; s=pp1; bh=ZNa1zdQlEmBpvY0ZmdY
	jBEMKTOnWbpZCPSdMPO8eOiQ=; b=hbv5tEVS+EK0UiQ0sNKFUzTrVe4PcQuTHRS
	RgmMixuaycCcQbek7lXpbs3APd2hBf5ELoNFnBMKFfpsDTfGBemGY5ZYcUcA+IrD
	aB/DFUS85Z5YZZXVvbAka5kV0wGvP0dKduogAXegeRFMsHZwoaeqiHZkoWt49Cfo
	/VPlcdby+kJ4CU68SDuR6oSiqDUthLxpYsztJMgD0h6m9SQQPgchpVR8qoiMlLfp
	U0iikKkJIxaAOl6f1A+PND+orLWMwW8phVRcSlm/5PVm/MQNwa0raYYvW7HYvjSy
	WXQb2mRH1vxr7540UgRpcMBrzRLUwJ8YUTJMZwQ14wbEc4o2q+A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mnst21dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 13:38:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDU2hC021797;
	Wed, 14 May 2025 13:38:38 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpmed6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 13:38:38 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EDcb8I29098524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:38:37 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58DA65805C;
	Wed, 14 May 2025 13:38:37 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE71258054;
	Wed, 14 May 2025 13:38:36 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 13:38:36 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 May 2025 15:38:36 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Franzki
 <ifranzki@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
Subject: CI found regression in s390 paes-ctr in linux-next
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
Message-ID: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gCTk--LIM6fkLxmYUPE1ZZLUXl_GIL4p
X-Authority-Analysis: v=2.4 cv=V+590fni c=1 sm=1 tr=0 ts=68249ce0 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=2zvBOVA4p3uQqtaWFzsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gCTk--LIM6fkLxmYUPE1ZZLUXl_GIL4p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEyMCBTYWx0ZWRfX3Dja0NyURsNc KokLep3rQJM+nqCYcWx29PJaLMxqP7soQuRgmLJPfLLZmkPGYbZ7N4SVP4OGvv9xyC8uLkryROL +4cZT8a7d39ldRghdIaoFr/Z9E20WlNyocoJ74/ZU/a2QJBhJF6KcWwfz7hPZRFGoR+8gQ1GhIa
 fKHBmjvB0MScFL4EvBN+cxOgXBKq18cW/i39Zq7fwbenjUluFW/ixGSteCzyZwFybpTEPRRrPTP DOfdt1e8eRn7Lb5AUMaQPdCNZshovRmb/zZHYrKihfbdrbRefmv4ufXn5oIWcN2XwJvNLlMIJO+ fMmxNc07fnIj4VSN4cu1vdm7oZFqZLc7rZTt5J5JnsJ1sEmsqG6S4GhCXgjBhEgGavY2RIHOUzq
 k+2FG6zA6Lyih8lc2ECaX7zHocd2OxSBila9ifnbicCN1lCyUW7ZN6KX0Arn3EKkr0rjnUWn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=581 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140120

The nightly CI run stumbled over an selftest failure for the paes ctr 
algorithm in the linux next kernel.
With commit
698de822780f crypto: testmgr - make it easier to enable the full set of 
tests
the "Enable extra run-time crypto self tests" are always enabled and 
there is no way to disable
these tests via kernel config any more.
However, the paes-ctr selftest now fails with these extra tests.
We could have seen this already when we would have enabled these 
additional test - however, we didn't.

Investigating...

have a nice day
Harald Freudenberger

