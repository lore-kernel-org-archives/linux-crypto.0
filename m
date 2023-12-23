Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EB614F85
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="kYJ/l7NK"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNIAq6m002185;
	Sat, 23 Dec 2023 18:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=DymI1x1+TfDEJEeaOFWgsyfb5euAu8Jv7FdVJPj7ys0=; b=
	kYJ/l7NKg2bDMs90+E2Q+kx6Ku2KSFiaMMap1gSKoN0n2EpLdnwnMsfiwIPsUS5Y
	Yw3qXXQayDnlpMvcuFlr/DcpptEmr38W8e/tpB17S/z0vVZqhlfMnx9qlGicP/Bn
	B5Z/9wqske9sacDlsdGEMOn1vwjUv5hy+0X5HS9I0s2e3dhuU4S/OKBK1XLc8YSs
	/rhlbG2QEOZhkaSuiPz2XlvETRVudxuS3RSx56+poBAfaSrN3KgTGSLwzHvu65dS
	OUluy053eUPXYuUo9ZYkQR6ywYxR8T0ZsF36jOvhnKZh+45QxF2Mbmn0Qz01Cbj1
	ntiiAnjraHcIvOmxbHpF4g==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrfj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9pjAbHlHIE6aaZYAzvD0JmlFRllsBtiUFu/Ji+A3w2+a9SJ1KPu1ZO5aXfvgWuqsK4f8104ER1ugNRq8/TokFYv5SkrfTlGbUT3GX6Gc8Hx/EiskvMbRiAnNcmdB2CZuqXfhTS48HWP7992uraWfiakYUA5wkA0PomgUzrI7m1k3EAQa3mlbZx7E7AQGKY7FVWqCmR7Gw3Ix3LthD19n1Uv3rKzYeanFPV9c14UxCbckWs757u+4ogqWJPOyqMwgTVXIrMPMvHh5TuB7S+L0MPVRxhhVoB9dqGlnHvmlzbackFllYbockZt7YevXkDBxEm97GfCqA5T78qxVYD5CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DymI1x1+TfDEJEeaOFWgsyfb5euAu8Jv7FdVJPj7ys0=;
 b=Z1Gm4xNQItbCOFBPqKWd++ifxOD1+eA1VtjHaLVk5gSDcfUKDOy0tJpFOfSNWtkK49sxy3moFKy244xcpGvaslLFi2PQcda55Zs0DRqZq79ezt7y7t7KYWxY0bvT36qrfSHjMYKQbtPezN6zh45qy42jqrlvYY7l2DcgyrmNwyHhY6pMbX63vbk6ndAqbWHmdIVqvOQfpwqg8gEiYoaZVkeD1vm/bYgZjIzOuZ10g7EOClkYdmdmNC36H7iA1escoDC8W7Z2tF7/JcVUv49Oy+hHpxkgXgV9IYsUoWAllhRq5p0qfGQtHzXq0TpH3NgGfD6xoFg4yKZ2VgMI8I7Kvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:51 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 12/14] crypto: sahara - remove unnecessary NULL assignments
Date: Sat, 23 Dec 2023 20:11:06 +0200
Message-Id: <20231223181108.3819741-12-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2150edb5-20a7-4c35-cb9a-08dc03e27f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qHkljqIFbXxsQW4kMcmClFHQVyWHyQqt75nYahO7/hLgisWM4qK7kh9qXUNXQeW+qS/td8YzcWZpHxjZajHTQOG7WtciAnemkJpHhen9GRDV4mQ0RAmvTgpQN2PB/n1BNTvkXUBn81qHoNrU92x6sxA0RYuOHBpERoxgg2IvugqqrgY1DVZAh9xxY7KdYsvUc26xRRF+P4ONZhz5HwRvyhJpe6Qub2t1h9AHyl+USGhNVlKF1dCFMMNAIDcibdMxl+cUD8m6n1yIdY2OwlnRud0NeR715sgRmfxh/wY6zuw/Y5yxPbtDB9jzNN5/h35jsx4W5QuE80+MGM6cWCmS2j9+Adyw/0Rr3J6XGHG/5aTMG3Ot7Wjfp6n8IZTiJv+yXKEMv1shVbpcN8yYYots/SeH5PpOSOgwMU54UOlMib975cIATQsQWXRDjK2iqv4vJWh95hpDbIwCVg3XTTNAQOcbfthFYGbCiSKh+IDTUX1bMs1arfwMt74jRgaequUio3C5py0mFMFq3MzcP5lsGKl3rZYMtGQeuihSvB1iYj9wxbXHnXLBlc64+GLv0tuYq4n8XwgJ4Fzr7lXURdMM6kZZjSoBQaDw9UyMBotYjhB46lhjaLITDCkfnXZ88KuX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(4744005)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FJUaDQKLpIinehMfAff0RATD8q7UorYfr6jzwbNC6rY+GuA9jRzy5EWU8nLT?=
 =?us-ascii?Q?RgTdMlvRKoVzc4mUkHDKLRnBw1PhRup0foxiVR4GfF+rbD1I0sLhiX79hM1y?=
 =?us-ascii?Q?+T+jr3dbDngG6nCnfLzSFMzpY0Ucn2Ydc8u3/Ue7lDTBDpO4MzcJcrqrSIJv?=
 =?us-ascii?Q?xbPvL2PK9hpXzgFz5mg/86ur8Q3HN6+/3aoybNs/t1OTT5gnR3LQnH8HxJsQ?=
 =?us-ascii?Q?4raY1Jumo5NYUEjLslqURBy1wRiIOaxfYkNW9K7G1pM5mCdhKb5UkyUGMsYD?=
 =?us-ascii?Q?nWUU/tvpiladBco/WpoK7dL7BneCKz02P4CMuRiUf1v2ixtLbcaOky7p1P4u?=
 =?us-ascii?Q?I2wZ+CoRfWdTgs9q/RF8ngquj67kYMim2RigHEFSlPDEqdk4DshbRKDn3XWF?=
 =?us-ascii?Q?+P9rNmPGEegEwfgumGhyn3qDL2+vGjXda7bVCTVnKZl15ICyCfj3revN/kYt?=
 =?us-ascii?Q?KSmhuk6n1bewUXjIyeTrN2bcLGIzhaBId8eZpJkd/VCRfWO4ubQqhudjLy7Z?=
 =?us-ascii?Q?38r4PXhWxUKddDeHzCwWmhkateWEvpAptS1NVMwoa2Zd7PTwSsHHikhOUAYv?=
 =?us-ascii?Q?a5XbWMB/kj00xjemAJjF0dgzAaggqddahn6CcwkEos2eZouJDbpZHORErMUq?=
 =?us-ascii?Q?b8MxMFcuf1eoHUxZtrz7paN83lxzrZWfXf4QMjA2THoYImFWtLye2tYtFgaQ?=
 =?us-ascii?Q?vWRVZvMuBkK2utsFnSI9EjDEY3pfSo6qU/vNsOaH7ZLFdRBv72xIyg6VPz0/?=
 =?us-ascii?Q?eGrM0eojHKnYyMSakWz5V7jCBKn7QDuFtf+9sWKddm8Jh0M/SRcGbMfoAt4L?=
 =?us-ascii?Q?DLTyeXGEd9DbBDwtSvUhFnBo1gduQaJxEv6SGui8g5Xj8symqTBZD6G+XI3S?=
 =?us-ascii?Q?4r9YPrjigmPZlfgaWWjt/G8agWysowdOS3402UHTL7oJJuz0srFGeuQzdrrm?=
 =?us-ascii?Q?LPib0XoH9dGwj1w7vsHe9qGzBCErDOvTmFizF9Z6TjjSQWHsUhHcaYTBn6Mr?=
 =?us-ascii?Q?GLN7XsOPSol3CXVyXyGyZUl/LlWisp9lAP40CjZFshnTUpBgtmjGCu2UrwmQ?=
 =?us-ascii?Q?W4wlQbnCQbR6cn6OKhN94QpzkCf1kX158yuU6Rs4pZIcs14E4XNOVq0Gn0zc?=
 =?us-ascii?Q?/FRTPwFSWAu0ZU/GOjTF6q+IwtlozE7nRNhVBkfISBqBylphUbzn8aLTT/N6?=
 =?us-ascii?Q?gpNqk00+/dF9zljwmyY2wMP+rEneRUMQX6KwN3HGUgzxVGPPsF2WO9ESCttG?=
 =?us-ascii?Q?4lLOum8WnqpiXYB2xRuRd7TmBj++BpQP7wONNf9Efua4uWCrvp6Dvs/z1tQa?=
 =?us-ascii?Q?XJnzcsEgd2CJ6ISEFWhOK2sWqQAWpC7a7LIJSeokuVpaBeMmbgl9bvtw5b8v?=
 =?us-ascii?Q?dYxA4prjwp0U0yKH1JQirCR40lbUKCXAcn7l9wRdKf/vjDysnq9erh+SJJN1?=
 =?us-ascii?Q?qELXyCuo4g7vO0PVEtYoSUql8irfTfMBoz/5TG1lFvbVtF6BduEAYnHbeBTc?=
 =?us-ascii?Q?+vvOBRwUQXcntAPjYzq+2mhhHu+wtjRXyvX4gHhkuaPWOHQKXunjOFYPJWdC?=
 =?us-ascii?Q?70JOQqwP8HuSJ/n0eRsEvdsOxGK4LZXKkJ4UkOc1g0bsF0gDddkLJJz1i+A9?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2150edb5-20a7-4c35-cb9a-08dc03e27f19
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:51.2299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZBnw4LI9nPjnQQi5aOoeqgtpnyyn9jAb2cfivY4L7TW//dhs7zG33+H1o1F0DZQsYiTfjDNhEOvoOI0R7VPlhDctDJyQc1pKFRSG+A1oDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: sZ5bz8yc6oearonllABCRzr4sHaHaOgI
X-Proofpoint-GUID: sZ5bz8yc6oearonllABCRzr4sHaHaOgI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=994
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Remove unnecessary 'dev_ptr' NULL assignments in sahara_remove() and
sahara_probe().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cd14514a43bb..fdae8c7e7c78 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1440,7 +1440,6 @@ static int sahara_probe(struct platform_device *pdev)
 
 err_algs:
 	kthread_stop(dev->kthread);
-	dev_ptr = NULL;
 
 	return err;
 }
@@ -1452,8 +1451,6 @@ static void sahara_remove(struct platform_device *pdev)
 	kthread_stop(dev->kthread);
 
 	sahara_unregister_algs(dev);
-
-	dev_ptr = NULL;
 }
 
 static struct platform_driver sahara_driver = {
-- 
2.34.1

