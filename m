Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC38EC5
	for <linux-crypto@vger.kernel.org>; Mon, 25 Dec 2023 03:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="KXRvNF4g"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BP317fp027964;
	Sun, 24 Dec 2023 19:05:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	PPS06212021; bh=wGzr1mVpSR696jjzLjWLxj5zxflwko0al1v648oQhkw=; b=
	KXRvNF4gNaQyO8Ttqg7LQ1Q/nS9aTzGp9mfQacXHXK1g49Wa2y29e9CVAuD6FTIl
	X9J1l0VX2nalw8mLvmhH/by6yCaYQiXREZjTa4muYDpy/KdAoWpFvHcD3HVKb9rX
	k8Y/Frqz/ABr6Sv0Ox8uheOJWPwIwX5S8rbgHDJHtGnpgtIPgXzm7pFD1x2Q9E9e
	Zf9ctp+V4gUmTYnY3HRIvWtf+O6D9WwH8BqmJ/sM2bv8Rf9qHuviC0YmT/+Kn3u0
	ElwPi4ocdJABxN22kdND+xGoY7vClzwjdHkz7ytCMfpBx34M7sgpuuWM5vwLznTj
	I4BdtZxGkiWyl/5seTOx8w==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0ydn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 24 Dec 2023 19:05:15 -0800 (PST)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Dec 2023 19:05:18 -0800
Received: from pek-lpd-ccm2.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Sun, 24 Dec 2023 19:05:15 -0800
From: Kun Song <Kun.Song@windriver.com>
To: <gaurav.jain@oss.nxp.com>
CC: <Kun.Song@windriver.com>, <V.Sethi@nxp.com>, <aymen.sghaier@nxp.com>,
        <davem@davemloft.net>, <filip.pudak@windriver.com>,
        <heng.guo@windriver.com>, <herbert@gondor.apana.org.au>,
        <horia.geanta@nxp.com>, <linux-crypto@vger.kernel.org>,
        <meenakshi.aggarwal@nxp.com>
Subject: RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Date: Mon, 25 Dec 2023 11:05:10 +0800
Message-ID: <20231225030510.929218-1-Kun.Song@windriver.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <AM0PR04MB600494E7DA11E8853C57566EE794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <AM0PR04MB600494E7DA11E8853C57566EE794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: JRi0Ulzb7n648zD_CRB-seiF3n6nClAn
X-Proofpoint-ORIG-GUID: JRi0Ulzb7n648zD_CRB-seiF3n6nClAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=486
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312250021

>Hi Kun
>
>Have you seen this issue in later kernel versions > 5.10 ?
>
>Regards
>Gaurav Jain

Hi, Gaurav

This race issue can only be reproduced in the customer's complex environment.
We were unable to reproduce it in our test enviroment, so we are not sure if the same issue can be reproduced on the latest kernel.
But by reviewing the code, it should be present in later versions.

Thanks!
BR/SK
