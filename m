Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945B93A1BE
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="nJzGS3GI"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40A5wivw002759;
	Wed, 10 Jan 2024 08:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	PPS06212021; bh=PB4Txu549Kriq75Ims8P1/IqTUMasS1QxpKCcZe7uUw=; b=
	nJzGS3GIun0/9v+60215UbQGk5XTaOhCknIlyrj9grEar8VM52LArSqm//aOSbFJ
	a4zqU+PY+WL1mxMIHPusTB5MX5CYOsd/cA7/hfNvkWJ/CbbT+zkJ/ygAXaN2R3az
	NeZN2i9zl/u2ZCK3okFi/WSn1msgmjCIXZxkDdZ1nBrTai66em1beFtscAFesc75
	/VKXgmlgk19+2rLrYTGFve012qdSFtzxUc+k5gzYZtQbr4GblOIfvQWvOni+xDsQ
	/7s9vrxN5WfCFknuKga9p7lRJTHfPQkN26MLNYQXhyRBYlhn/6KkoNn4+47jjQCx
	X2DmX2jAT4mhi6RfulTPRA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3vewu5ca8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 Jan 2024 08:25:37 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Jan 2024 00:26:07 -0800
Received: from pek-lpd-ccm2.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Wed, 10 Jan 2024 00:26:04 -0800
From: Kun Song <Kun.Song@windriver.com>
To: <gaurav.jain@nxp.com>
CC: <Kun.Song@windriver.com>, <V.Sethi@nxp.com>, <aymen.sghaier@nxp.com>,
        <davem@davemloft.net>, <filip.pudak@windriver.com>,
        <heng.guo@windriver.com>, <herbert@gondor.apana.org.au>,
        <horia.geanta@nxp.com>, <linux-crypto@vger.kernel.org>,
        <meenakshi.aggarwal@nxp.com>, <richard.danter@windriver.com>
Subject: RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Date: Wed, 10 Jan 2024 16:25:32 +0800
Message-ID: <20240110082532.2858045-1-Kun.Song@windriver.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <AM0PR04MB6004B82755A53A216D2EFA13E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <AM0PR04MB6004B82755A53A216D2EFA13E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 3VFuORSlHGJptCkDhD0RiVyac-qahwdn
X-Proofpoint-ORIG-GUID: 3VFuORSlHGJptCkDhD0RiVyac-qahwdn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=724
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2311290000
 definitions=main-2401100068

>Hello SK
>
>I am submitting and replying patches using gaurav.jain@nxp.com
>
>In Later kernel versions we have provided fixes related to job ring flush and there are other changes as well.
>It would be better to add these changes on top of 5.10 tree as we also run multiple tests and not observed this issue.
>
>Regards
>Gaurav Jain

Hi, Gaurav

Can you identify which commits?
Our version has added some related commits based on 5.10
-------------------------------------------------
04ff8e37a2df crypto: caam/jr - add .shutdown hook
f7ea4a6a6511 LF-3093-1 crypto: caam/jr - fix caam-keygen exit / clean-up
c41daf27fa44 LF-3079 crypto: caam/jr - fix shared IRQ line handling
1f12127de72a MLK-24912-2 crypto: caam - fix RNG vs. hwrng kthread race
04e3a61f9bb5 MLK-24912-1 crypto: caam/jr - update jr_list during suspend/resume
f48d9e23262e MLK-24420-3 crypto: caam - add ioctl calls for black keys and blobs generation
5c98742fbf60 MLK-24420-2 crypto: caam - add support for black keys and blobs
-------------------------------------------------

But We have no way to port this commit because its architecture has changed too much.
commit 304a2efe9d55875c6805f3c2957bc39ceebbc5c0
crypto: caam/jr - Convert to platform remove callback returning void


On your test enviroment, modify function caam_jr_remove 
Test scenarios1:
if &jrpriv->tfm_count is not zero,whether will crash?

+atomic_inc(&jrpriv->tfm_count);
if (atomic_read(&jrpriv->tfm_count)) {


Thanks!
BR/SK
