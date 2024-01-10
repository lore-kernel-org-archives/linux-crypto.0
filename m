Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDBA47F46
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 11:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="AGjdw4Cr"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40ABKm27007253;
	Wed, 10 Jan 2024 11:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	PPS06212021; bh=3Hfk2OA0HnzqSdXlKJzUHrmrs+orUbJxUGPBHwQyjKI=; b=
	AGjdw4CrTrof7bU+zjHOC5c+qa5fEUmBd3r+2PP5acnKx9aoZsYrQPngwnCbSmYF
	/jBGvJO7FABohCGA5DfSCA4HKcwO73B2Uvo6jZi6Jd17ConCoJj6oODbDe7Mlq1h
	bAZczC6TSvMKdC6QjO5f4cFGAPNBIsQp8KRrSMsxTSgqTgaJVrylC2PwFCNR5BFl
	fDn1Zv8IgLgYo9f/Bs5kZQtT0I1dJ/O3TShe08qxgUNwVo/djAKeCySGTtlhfXfq
	XthmtBkoK922Syp1FXvBk6gcauNyrnjA2G/ktTtq4V6eXPTFCgTRfz/QNgENJbOJ
	H7R/Ic0H4GRq6KSHQWDTIQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3vewu5cgj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 Jan 2024 11:56:58 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Jan 2024 03:57:28 -0800
Received: from pek-lpd-ccm2.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Wed, 10 Jan 2024 03:57:25 -0800
From: Kun Song <Kun.Song@windriver.com>
To: <gaurav.jain@nxp.com>
CC: <Kun.Song@windriver.com>, <V.Sethi@nxp.com>, <aymen.sghaier@nxp.com>,
        <davem@davemloft.net>, <filip.pudak@windriver.com>,
        <heng.guo@windriver.com>, <herbert@gondor.apana.org.au>,
        <horia.geanta@nxp.com>, <linux-crypto@vger.kernel.org>,
        <meenakshi.aggarwal@nxp.com>, <richard.danter@windriver.com>
Subject: RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Date: Wed, 10 Jan 2024 19:56:53 +0800
Message-ID: <20240110115653.3170977-1-Kun.Song@windriver.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <AM0PR04MB600455078CE01BE8246117B7E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <AM0PR04MB600455078CE01BE8246117B7E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 6ttKKB4f2FGyQlMosDqP1AIgMPHA9PGo
X-Proofpoint-ORIG-GUID: 6ttKKB4f2FGyQlMosDqP1AIgMPHA9PGo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=603
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2311290000
 definitions=main-2401100098

>https://github.com/torvalds/linux/commit/06e39357c36b0d3cc2779d08ed04cb389eaa22ba - drivers: crypto: caam/jr - Allow quiesce when quiesced
>apply this one as well.

Hi, Gaurav

Our version has backport this commiti(06e39357c36b0d3cc2779d08ed04cb389eaa22ba), but the problem still exists.

When crash occurs, the log will output

<3>caam_jr 8030000.jr: Device is busy
<3>caam_jr 8020000.jr: Device is busy
<3>caam_jr 8010000.jr: Device is busy
<3>caam_jr 8010000.jr: job ring error: irqstate: 00000103


Thanks!
BR/SK
