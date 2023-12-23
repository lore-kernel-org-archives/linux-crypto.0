Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7BD12E5A
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="jbJelIlt"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNIAheg016022;
	Sat, 23 Dec 2023 10:10:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=2/bBsHOnsse5CzDHR3+pI+UvwBS47SrmGuAP512pr+Q=; b=
	jbJelIltKrDaspeAw6f75saDzoz5u4YbgJ7BUFRi0KaJP2lwi79igo+G4VTjL0Jc
	Jm6isFPKnRQnaIlUfO8MdLIptD3d6OE1h5uljK7fZwqNLJeE3KHfml+wO77bILjS
	E3dqoD3xYFFaqpVGmk67f/G4icJI+WsIlVia17hE1YhFvXfQniXdx9MffwzqiSlL
	7Bg5dGXBt/vWbn8SiwE+lJ3NEd+9SNZwXaZwqSAoE7hiZX+/I+bbbSAD6OfkSb3w
	taGpitztV3lcSXY5H/7p02mVK9w9PEBgl5gogs27EHk6Mqdd0VdqzijbFl2WbxhS
	wj+EiTG2E5x7GDLaAhQ19A==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm04cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUmjFuiNUWVtHv+KpkLC3BknTRq1noKuidki0W/AQk7buRmkJ658yUlzXQ6weOtCq3rFsvjHRK7k2dRrX0BngL98c2NmeVxY5OR6swpnIRizYVvqX1Z7kwpg82ZQouy27FAPIm1RKT2QI8eUUcKFkUdVCtxbwOghTG2WcAftFCkHi5E3GlvCbSAOw9YoM1gSaW4611vY9Gi93djMliJcfpIlubJkxisxe0Rqz08Y+Z3d88qtSzEnnZBzad4h8e4V4hoOR7a9u/TTxpvq2hZyQ1NiTlk5E44Lx9RlvWBu2Tos4HwjoxjMXzbZFvC6LL+O52qyQDHTakp9QiOf0lZGNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/bBsHOnsse5CzDHR3+pI+UvwBS47SrmGuAP512pr+Q=;
 b=KuKpYyGniCW9ksmvS1UkJIYnHZTypqZRrNkI3FB8XgsSGHSg2U2Z1BIRXmbb6Shc0Y95OguGBXjdjMmjt5GcEiEYsSU/oeRBoXDnMb8v9h75WOPcDxU6xPWCaRNCU6ZJETZPR3bdB32CQQdTXZfy6bUTp2iC01Qta3MLSWbHFQ/3SUd5h3cXWEFsKZlE2xsVoHr82R5gMOzxluTi82Il+SjKG6J0DBAgkVL9CptyBqYxZgxKcAwaXyADQpGQiVV8P9Hs0vIo4kfyB46aKKz4ipX3il6MwzzfqVTcChYTBL6JPqAFV9UBH6/ThMRbT/w48A/i6lsL4Wz5i3DKQdYFaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:41 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:41 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 05/14] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Sat, 23 Dec 2023 20:10:59 +0200
Message-Id: <20231223181108.3819741-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: e07ffeab-a3d3-42c7-a863-08dc03e27947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	90Npe5ltpIG8kdH+/qJ8Hj8mTH6HvOq1E6ta4GIO16Aq5zGCxgmvJOKdfdXiOZ6RIw5gJk4SKy+463Kj7Op+2/T1HZHUS0tBl/B2F1zfER4YZ1PvpZ93M56JIEQQOlvTeimVPu16tjiBu64VAqB1+rQKMJ0sfhXBihiQjj/+7whXsKjlML752k3GH7xz4B0CJQ+gx2OAhnaga3MJVa1HQydtIcnIXnRv/iy3luWsmxofAH4nUwuY+RNUaZKCjJV6SNlldTnJAjkoEpZ+w9RWkSnJ2vjHqaZI5qMqj4aBcq/jljOYD9uX7o5Nnl4qpuh6om5PMfMiiL64ZBbgNZbIV8+Ie/PBqH0z85omwHtztT/YLriRG4Qgn1PifGTBBSJiIWbjD97xPB9UcwS3W2r/tkAAvIogsU/ZFV4kDu8QLTMdFV89VZEsDTLoSs2Za+SYQJt4WFKmL6dfwBuqiGMilcNr5vH348GzxBVkTQty2Idt0w6dI3g6LRN7CXadjVK02x9zmvWEK2m//u389EE7Z8fF0V4T8sOltAmo05ksjAvlR6a9SwSph2TB353FP28YXOEe6RFx0qo79azfssMzd/HvykUnsDctaOikXiY+Rt1LtsSMytfIwmrlPJ7FBSFL
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XWiCkAzaGNtn1krNpFeM61gWpsuGz3lPxEo/kJpBpqxeTn6GIuNZTDXLOBjg?=
 =?us-ascii?Q?zah+iedY/dndaGUXRX0Jw2v0enZnc0lLVyqKRYv9beRWKnRGd9rr9h0vhNBR?=
 =?us-ascii?Q?4UVEO/kN/YMmbv1m5ZeKdoDqI7xRyX66cmZVx04GQ/eLACm3bLvHeLoNi2qW?=
 =?us-ascii?Q?Tm/e2kANMVCbNnro9Ob9oPfJ0p4AjDqK2aBIxvbZ9M010rPmWHuB/O8k7qD/?=
 =?us-ascii?Q?NqNAhiDrN5ug+qcG3uHCU3sFvdG8QS6RaJ+DeZxRB888+4pCyjcRQV8k2t3W?=
 =?us-ascii?Q?Q70drkJTzLgZ07dfEBjQ/F3xcxxKxxonD46zPruAAjqTtkx34QDb1haRZb+l?=
 =?us-ascii?Q?cdl4gzWIrCbA8QCca2DjY3BnNvF5xhbU8cXJIAT0Kypb7cCIyM5dOFStY9Ah?=
 =?us-ascii?Q?tJKJ+xmxXVLzBpt1p243649+GsOsPzozxUUeWkDQP27TS5+r4wNqjEEtWvSE?=
 =?us-ascii?Q?q85bL1Jjn2UW9aRRCgxrXwaHpj4yWCZ2VFiZ9C82je0C5naGv5NBXi/YamcL?=
 =?us-ascii?Q?rR+31keDBQE5QWsCSimfHCy3s0B1v6sDTWdxCITSnTQHg4RkungME0wM5F8P?=
 =?us-ascii?Q?xqCQDAhrvwefD0RLzVAk1ni6VCgRSgYMt4TmqPKayb8WisTIBj4s/GYI2VW1?=
 =?us-ascii?Q?5apQekaf5auw6pWG3At4xGdvxkVPeUk5YdPrx3cLjlVrLKPi9dxUZmIs4PBN?=
 =?us-ascii?Q?f97MQXdryub+g75wrb/qj23mYFZaziTu7+p8z+bLEuA5Ul2K+LihgtkNe9pw?=
 =?us-ascii?Q?3qNPz+uXtBs38nXpkSOHKPEP2qrMGntODTje1l20iAFcvGqHJef1q/z8NzKl?=
 =?us-ascii?Q?NYZuirrSaQq7UlXp4vEdrpNMDoOJIqklQeWWZrp6SAYfscurNo/Z58k+z8ti?=
 =?us-ascii?Q?3lr6ZjwiKsju/BxMJs8ovgc3Fyvblt22tIypCemNvy5xZ9C8UpRJsWddOU3A?=
 =?us-ascii?Q?Xw0CG7/d2LSQGpZ0aKIdSo9ECtmq37Ntkdz0Npn5mLQaVlF5e6UcCX7HSQa4?=
 =?us-ascii?Q?6GKwFLNo79VNT242b3DQVISa757o+gjRmMgc5bXkjUUJUjZO/Sa1YzEsEGUD?=
 =?us-ascii?Q?GbQUL0+2xR5OxMOto01spJ33fx0bBmrPZ39ylUk2K5MVk7XkKFI7XkXG/nmT?=
 =?us-ascii?Q?lxdKOA1bjYruFFYUTBf4b3nZ4LnFJjT0pGkWNtF6dhiy1KwIr7g7u1VAPC4z?=
 =?us-ascii?Q?7+ZM4o1kNTjDTCcbfux88V1vrB/uGAC40Tlk2UGapLzB79bOlR5lME+2RhQH?=
 =?us-ascii?Q?1ce/mo1ElsnXfLHPK6yTA/tazfGqLQRjB9sbwss0H1sRvW7YEQpwYNxKIVtP?=
 =?us-ascii?Q?ylc2n2ciedSnST32aYgcqP2oafKrxgmnampd4DM/O5R9shexRVE5fBXdcHPL?=
 =?us-ascii?Q?pubK8pI6C9m9szDX3KcfpxvT+EsGEw0oXTzEHu0bcVyWnfpjYCW8jJBGgNe+?=
 =?us-ascii?Q?V1xYJi10Z4WpBXCE0f/1Sm8v35DSE9JKt+bFhFMi4u83nGj4eoDQD/KFNclO?=
 =?us-ascii?Q?5SUHvbKWGPNE4U+G3TC2EGOrXVTGReABAAC440r7LUFMVng1Eyz6nvh+Gqx6?=
 =?us-ascii?Q?TVh9DcU5mVC/U2SPT+SSMikVAOirm8we8y8F8Fg+NiNem3BdLWund6S246ur?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07ffeab-a3d3-42c7-a863-08dc03e27947
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:41.3281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VF9vMlb1RWL8meUJYAi5FvPefc3hmUsJE1YyNhk3KGb1xdZEoOssAVCswtGdrX7HXB4CABXnHUBiz+cyINx242E9QOPco9wKx1Rb4bsS5Y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: R0XWlfYx-YyCC6_5K0NhMUL6JZpDnXhB
X-Proofpoint-ORIG-GUID: R0XWlfYx-YyCC6_5K0NhMUL6JZpDnXhB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=920
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

It's not always the case that the entire sg entry needs to be processed.
Currently, when nbytes is less than sg->length, "Descriptor length" errors
are encountered.

To fix this, take the actual request size into account when populating the
hw links.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d49659db6a48..321c11050457 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -774,6 +774,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 				       int start)
 {
 	struct scatterlist *sg;
+	unsigned int len;
 	unsigned int i;
 	int ret;
 
@@ -795,12 +796,14 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 	if (!ret)
 		return -EFAULT;
 
+	len = rctx->total;
 	for (i = start; i < dev->nb_in_sg + start; i++) {
-		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->len = min(len, sg->length);
 		dev->hw_link[i]->p = sg->dma_address;
 		if (i == (dev->nb_in_sg + start - 1)) {
 			dev->hw_link[i]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
 		}
-- 
2.34.1

