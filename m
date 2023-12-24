Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33603FF5
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="UnzPIzGw"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8A1a1001819;
	Sun, 24 Dec 2023 08:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=Uz655i0lnZajLzx004uBUnAj+0q5ECAJU6oreE+oOAw=; b=
	UnzPIzGwrA8Bzv3TZaYbywMpd2P8HdfY4+oycCIMKzEgbJGHvnuTon4k9jbxeuVu
	8pLwUKEwGviNSs+YsgS2NxDSV7vAfSRtFRNZ0gjuA/ohjEcZos0gOR2V1Ibj897G
	bOcU3snV4b4uUBhvU6ymX12sNxoctJ2zI4gr8/IC3PJaZ5zasiNWIFIWNp/GdHNn
	XS/V/flOIFhV6mZeN3qpbXUhyIMd98lHLg/pFkAF6FJHMj8ohE+pnMhg6G1sTz00
	nFS7y5PAXziIRvDYWJZsFY46sqrq5ZSSqw6KRQfiMl8iVIE7MqKrDiAjGTFFOmvB
	Zpqx7OxvKXo9X/796VpGyw==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60rss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/gavy22huyPPubnSFwx5M0h9fyYb3jew7UDnYdMpbP981M7gcQgnsqACDvfGtUI+qOy4dBnsDQ2E2MpECaCk5lrV86cUDcknGgZGnjh4O6KQTmIhOPoI+uJG17rzzxvFp5UXlsuFSrTRC4GPThKXkixq+xe/nb5V+tsIRok3KRFTG771jjlNDCTlLf4WPNjGfP3DtfqiwuLSzDYmnt0p+tuypsUZV201Oy1CS/NbRA1p6UDCHTJ8s2Ie6tc3aS5prPra0dzwi67oUejmLj45dqQuAtPLR3UWfY4gxPwmlftZkkSm9KUMa3a2aYx2AGU7Hw91q62H669HVd7cPgZhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uz655i0lnZajLzx004uBUnAj+0q5ECAJU6oreE+oOAw=;
 b=NihVoD8Gb4TGLzKVW9Lk3x5vtHEkiaLpgMPcQYfxXKMXbcwvjUhop7Fbouju5uMkxr8YAFnaKEoWBj6l0PzQN3E3ksiIqtZffZZrf/5uaYbJWyKwguxc0K9xA0Uk7bCDtJpxTkuHKQ4CDO+y0FFs3wpRxbmaEo2RoTV7AZP/movFMAKusGtkpeWdwMYN34Gyco0FgXxkn8GxY4q+MUbcJGXpag9tuVXu/seNXSQCyUtcvXcP5qEYUlMbPS/9DS9ym/pivVdzgIbSpm2QDrphCB+OeYH3SrmpcVPrPbOy3vECHJwo+JAkpo2WLJaWe3xTWraqEf+ySiIctN5B2NqfwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:14 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:14 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 10/14] crypto: sahara - use dev_err_probe()
Date: Sun, 24 Dec 2023 10:21:40 +0200
Message-Id: <20231224082144.3894863-11-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: e390fe2b-4b7f-403a-ca61-08dc04594b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9DGAI+IBrxD+eOPPF3BjiBA4MUVdIs9gKldC20nlouG6KGGoaEWn82+7tjFKyYC1OHhu+uR/Iu8F+lnq9t4u+nTfz4+6rNDtC/rtKGCYv1UtkX5XNH4wKNn9qK1tMxkaQg41Axj85t//F1Do3vmI8GUV9vsXtPvxAsbE3aCuwSM38+ljhnU3evwffkc0+Mt3dlBw9kGs2Q8JguoK1WMC+T4CaujnswH/bQWQ7Pn2fao4Ck6xotDJWjaHRousOBjNyTY7U+/wVJ0Qm6D2f8f88TXQcAr6K3nYWWzAkNy5bjA1x5t+iy9cp2eWJak+n/OZomMWRhl6mMsm0V1RCcaGAj0a6tjoC1D/P79VHo8TXcOD9CVloFHmHMwyauHihoyEZlVsacyL7yhFPkXlw56VAfrFBcclJd1svOqUh8CaEeVcizJWt110PXQa8ge44pNCNHUKze8erP2baVhO9nH683OWx/Txpm6D4B1klA0GMsqL8K80Ty1q6sQHrryDbM0dWZgxR3R8ZqgV5iT3SLY89ZTYLOln9iSf6e7QTqKH2axeWM7mG6SvnTxRisOBjhmhfXeIIi6iHEilxmzjPzH2hdP2Tigr0PeK1/Z3QHKXR9IAXJMsnTUxSHIP+LNYr5G5
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5VS2W+R9sGgyv3DwsjcyGeVk1zwVvuJLfpI3B9VT+M5TFz342+ZRzH7AX4A7?=
 =?us-ascii?Q?lhBxxS7qAgMtSbD3jVwSRx+4+9s6hJcrcn8dxdA23B0K9npPJhCFCbFBZcdw?=
 =?us-ascii?Q?wCQ5bDms7X7SVZAtmRK3Fqu4/wGqOYgqsZu6eT/iwMh93DOS5s7jalhaJtrP?=
 =?us-ascii?Q?K6zPG5yH7VkhWh4vrEXAv+hyDnfO3I9fdAAL/eIfcxEOFLdVloTYcWq1C+77?=
 =?us-ascii?Q?W7SLgvlNr308/7jV3kMbofaUvpKxB88cxlN6NScLEUGFqNkuNlFDfVCfmJxO?=
 =?us-ascii?Q?z21ytkaDA4Wz+qd58O119YF6qcXdOfqUB1oocAtPcKWBL3fWA7qpKpOpVNU6?=
 =?us-ascii?Q?dn8iARte7TuUDzGtV4vIA9pbh2yXIw/76KSKRlfldo3heqiyB8tEQp1jYDAy?=
 =?us-ascii?Q?h5SI5J2VGx0QQwDfltpSeey8Vk6+xwJXBoEXiJsB0d8glf1L9F5rHuhvec/9?=
 =?us-ascii?Q?uEdJUJgkjQlnpBlBs48vILHT7LPxBXRym5j3EmQYPMeIX4jnNo8pSA+jJCBO?=
 =?us-ascii?Q?Gj8CCZ7FT3fRXCymcYz6+CPkwW6RYr1kcTkLUySdDQfeBnK8UJK0DAG/TmHN?=
 =?us-ascii?Q?1IYEgwmC5v3r64YbGmk2qhq93U0WwyFHin0+npi4oS4IzHzk+Y8tdy7gXuP2?=
 =?us-ascii?Q?UjysPGLFtvlf2xvcePkzzSCrfGSyMcfHqEQN+ut405r4Ebqk/vVqQgCrGXR9?=
 =?us-ascii?Q?tSFvES43S4nLwikCpKaAZL/MHmEDCETVNwR1OXFewvsd4fFdMfJG5Bv2Botp?=
 =?us-ascii?Q?VMTudqj9kQM1djwTyUlM7pZ2Oa6ktg1ta3DJmf3At6jS/pXFFWB2BBfj4AJU?=
 =?us-ascii?Q?G45y5ANKEFEEcPSvn9KTEjrr7dLsXFR52Hyblyt0cqQvhKIhT1tfBkqIKxca?=
 =?us-ascii?Q?xu9d7YSKOl4O6p7p1pE4xcy63zz+NCXsNyNp6GKi3n+i9dErPnzGKQN0CE9R?=
 =?us-ascii?Q?IdaGTiE2b+8SbH//lzfxcJ6mCGaNxMpIBZwrQk3vHDkkwTj068SzqV0FFxts?=
 =?us-ascii?Q?h9vKqyWR9DdjD5SEDvNvW7zyeU+h3QHQ42A4sKgiKdXtqV9GzfKhcedJA550?=
 =?us-ascii?Q?Pn/HcGsr9OTAIsWPGAxqAa+98YisU4ygIqb4zIWsW2oByAU/fXljsDRxnvch?=
 =?us-ascii?Q?FIEQ3dTbIsbddDOp9nttSvE1yQwDvt3I9laZ8YZJfvgF3cC5HKH9/OWcYvYL?=
 =?us-ascii?Q?sB6X8ciJbd6n+2sAAqk7BzHbWs8KXyWetDfUUYGD3umGy3EAIfMnHCqKmt87?=
 =?us-ascii?Q?VclgLc76qKWmZ8c8WQYwmNpKKyDHt5ovUlHVNS9A06+MZYPYQn7ilKeEs4Zv?=
 =?us-ascii?Q?CJ0Jcp/I4VqSjr/yp32yzVewvPrRQvvN0iX5sA24D+oBgoDx+pqZ6AYm7Vio?=
 =?us-ascii?Q?D4xsKJGyUitY5S65vT/Xbjy5voJePoNzEZgu84wcT+tyIgPkuoq5Pw1Po+Ty?=
 =?us-ascii?Q?eTKb7CLSeJVbJuwxfIbMoGy5pvdXaq00wTUjxy45c5KBcRPxjwsxc0U9dyTo?=
 =?us-ascii?Q?O4XlK6cVEKusNPI456hf/Y+F3jLqs4r0NHcp+YBK+/7iINm/QVVuFOQXK93O?=
 =?us-ascii?Q?018boGrXJw88ELQjv2oscJmn7iACaxyj2d4y0Ca+DtFrSACJk6MxPk2/vBAC?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e390fe2b-4b7f-403a-ca61-08dc04594b72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:14.5820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XmgqTiU4BUNU3uPY6jh8JRZJzPyPU1S6TCQrmCtLVz8mgacd2Qsqf3FUhL0asnZj3NVIWra2SLw1NT0YBD8fjGjpXIRaDPTXgJcyhtOK7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-ORIG-GUID: tlhS4KvElg-AzNiDnyHk4qpmW557Of5d
X-Proofpoint-GUID: tlhS4KvElg-AzNiDnyHk4qpmW557Of5d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=861 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Switch to use dev_err_probe() to simplify the error paths and unify
message template. While at it, also remove explicit error messages
from every potential -ENOMEM.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 619a1df69410..253a3dafdff1 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1346,10 +1346,9 @@ static int sahara_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
 			       0, dev_name(&pdev->dev), dev);
-	if (err) {
-		dev_err(&pdev->dev, "failed to request irq\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to request irq\n");
 
 	/* clocks */
 	dev->clk_ipg = devm_clk_get_enabled(&pdev->dev, "ipg");
@@ -1366,10 +1365,8 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->hw_desc[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
 			&dev->hw_phys_desc[0], GFP_KERNEL);
-	if (!dev->hw_desc[0]) {
-		dev_err(&pdev->dev, "Could not allocate hw descriptors\n");
+	if (!dev->hw_desc[0])
 		return -ENOMEM;
-	}
 	dev->hw_desc[1] = dev->hw_desc[0] + 1;
 	dev->hw_phys_desc[1] = dev->hw_phys_desc[0] +
 				sizeof(struct sahara_hw_desc);
@@ -1377,10 +1374,8 @@ static int sahara_probe(struct platform_device *pdev)
 	/* Allocate space for iv and key */
 	dev->key_base = dmam_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
 				&dev->key_phys_base, GFP_KERNEL);
-	if (!dev->key_base) {
-		dev_err(&pdev->dev, "Could not allocate memory for key\n");
+	if (!dev->key_base)
 		return -ENOMEM;
-	}
 	dev->iv_base = dev->key_base + AES_KEYSIZE_128;
 	dev->iv_phys_base = dev->key_phys_base + AES_KEYSIZE_128;
 
@@ -1388,19 +1383,15 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->context_base = dmam_alloc_coherent(&pdev->dev,
 					SHA256_DIGEST_SIZE + 4,
 					&dev->context_phys_base, GFP_KERNEL);
-	if (!dev->context_base) {
-		dev_err(&pdev->dev, "Could not allocate memory for MDHA context\n");
+	if (!dev->context_base)
 		return -ENOMEM;
-	}
 
 	/* Allocate space for HW links */
 	dev->hw_link[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
 			&dev->hw_phys_link[0], GFP_KERNEL);
-	if (!dev->hw_link[0]) {
-		dev_err(&pdev->dev, "Could not allocate hw links\n");
+	if (!dev->hw_link[0])
 		return -ENOMEM;
-	}
 	for (i = 1; i < SAHARA_MAX_HW_LINK; i++) {
 		dev->hw_phys_link[i] = dev->hw_phys_link[i - 1] +
 					sizeof(struct sahara_hw_link);
@@ -1431,8 +1422,8 @@ static int sahara_probe(struct platform_device *pdev)
 		version = (version >> 8) & 0xff;
 	}
 	if (err == -ENODEV) {
-		dev_err(&pdev->dev, "SAHARA version %d not supported\n",
-				version);
+		dev_err_probe(&pdev->dev, err,
+			      "SAHARA version %d not supported\n", version);
 		goto err_algs;
 	}
 
-- 
2.34.1

