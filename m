Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F751370
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 01:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="IWiI9f51"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40A0pONX006008;
	Tue, 9 Jan 2024 17:39:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	PPS06212021; bh=M+MYSGdfU78gcphe0xPfVxEluN9XQy2CP3XZ8A9L2rA=; b=
	IWiI9f51OBjsNo1MlvtEVirqE7uk8Qeocj2zvJwS/hBcmQP441GZsaO6zWjh44z0
	cRpTmJgjXcOJQq1pU46yCnhs9/glQIUKuNXNPEhuMR5Do/kAh74IxGbXQgvk8Lbm
	tRhD0ncZOVHrLSNKK0PojR66ALI98ZS79+VxUSjc5idqT1yWgEI0kFK6JohmIb/T
	AYYSe7etQ+k+pVC4B93ZT0PrOMsecspQsBGSW+trGPrZa5Y/R0bSOYsPDsXkJd8z
	PfKyCcM1GJtG9/XEhkblhGzDgj34zeyLmbh8JVPlldwBtSG3Y+Uep4r15Oh8ZdB5
	iJcAvWYC0A+hsHNxZSQFCw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3vf78mbmqx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jan 2024 17:39:24 -0800 (PST)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 17:39:41 -0800
Received: from pek-lpd-ccm2.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Tue, 9 Jan 2024 17:39:38 -0800
From: Kun Song <Kun.Song@windriver.com>
To: <gaurav.jain@oss.nxp.com>
CC: <Kun.Song@windriver.com>, <V.Sethi@nxp.com>, <aymen.sghaier@nxp.com>,
        <davem@davemloft.net>, <filip.pudak@windriver.com>,
        <heng.guo@windriver.com>, <herbert@gondor.apana.org.au>,
        <horia.geanta@nxp.com>, <linux-crypto@vger.kernel.org>,
        <meenakshi.aggarwal@nxp.com>
Subject: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash 
Date: Wed, 10 Jan 2024 09:39:05 +0800
Message-ID: <20240110013905.2241490-1-Kun.Song@windriver.com>
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
X-Proofpoint-GUID: taX2H7RPLlAUOntiN2fH1vy0my-xmWAv
X-Proofpoint-ORIG-GUID: taX2H7RPLlAUOntiN2fH1vy0my-xmWAv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=750 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2401100012

Hello Gaurav,

  I hope you receive this email. I'm following up on a patch I submitted a few weeks ago. There doesn't seem to be any response yet and I want to make sure it gets pushed forward.

  I know you're busy and thank you for taking the time to focus on this.If you have any concerns or feedback please let me know and I'll be happy to address it.

Best regards,
SK 
