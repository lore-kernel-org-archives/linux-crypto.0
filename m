Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5A815CF
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="USuF6Wp/"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8L2fM015315;
	Sun, 24 Dec 2023 08:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=PPS06212021; bh=PsCLVfto7WCZMLcR4C
	RADhosWht8PyVmxjD6c6D+Hvg=; b=USuF6Wp/f31VOpO5Bq/MousXtk3z8DFBh5
	xyKL5k6USTjC+gxOnvrPdbSJg+xLeQtWoqTWZNgZChCUAoAp4Rn+iGgrz8DW13UY
	hMWmRWQy7pZ6QzdpZbjMwXqoqNfSf0VCTQHDA34ogbONsmvAsYvetjY+hbdbeFpW
	wgXR24eVwqX3iWtnay55cp88wLr+r+HtwEsKSHcL4oZfnC3cUqACiht8Qi1MRkvQ
	vw/rrQf4++qm+VqxVI91nIfSRM61zqcUjduWoz+CnH/SLoECc/LCe33KJ44D6dsj
	mTSNR1/coPGGHCRodzh21MDRVc3B7VoGlJ2j9L9RSTjDKi0Pg2fA==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60rs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFxEsQqYFKreDx/jXH9BrBdk6EN/aV3e2rljiyT/AoXlZ2cogf0m3Y4z/tf8OguVY2QAsQ4MTwrb40Hq1OwPZYuSEJoC4thfbU1KJ+W0lZPtv1p9HLdp2FbtEY2j1OWcw8qI9+zLc25kQRkkvFetvW++pqENek0aQn2E5/SE8gH/ibhUl2R3OPbBEueNwpWHMMPD3OQ4agbhhpD7Jq/Ee9igA+sHIo5XAQW1YDGOmRopZfC5+Dv/Mhh7QRnh7V9SAlEXY0+3R6D0DYMsVxY+GcptlrUMOwvYJLTRjf7EHGQp5J4eXVCl+Dxto1CwoGdYwRzifzYdDd+e3TexC+4unA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsCLVfto7WCZMLcR4CRADhosWht8PyVmxjD6c6D+Hvg=;
 b=RgY00YaRswlPobAl13P0puCjofftt4Fi84E6YMmOVSX7Jk/vaq7sjtvF88Xm8RG9Oy0HzOSCvz1onjlq6muS8Ml6kzH/boSBWBzBCuZhmJesFr5pG2idpHhBlK3Rfqb/ysaAaGoT2pKPGQcI2UTnpAJ3MvHBXFNM1tRJTH1JREIlIEMDaqxH3imWzEaOO72vFO18iEQbc+Hvf+2IOID6FvfhJ9Gin5sJHB3tnFp8UKBJgedYcjuzZyGzx/3xNSYefsIeKVs5tiZx1r7eAgDa7qKMrAz2arzLpbEHNQHmoBjK4LVCQyb4elTaL1Oduz4etfx1VyX3VJN5ghVFajXBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:20:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:20:59 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 00/14] crypto: sahara - bugfixes and small improvements
Date: Sun, 24 Dec 2023 10:21:30 +0200
Message-Id: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 5405aee1-dd99-4761-f1b9-08dc04594243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MhD2Mxc2A5EB1hECd0qwccTQTJXVZ4LlFMpvEiFKi5tTgQtcsdJ3tqogDOrEDTKR0wJ+UuT8NrAGJlsaxOeUmSoZTvIclABF5zDWw1UQ9iyHZwx/BovGj7RuO2nnqSRNq5DGe2UuwueI9VaSFmkuTRMAzNuD87TBtgEk9PHWIpMvrphI2Wb9o1YaxExzJcQCs88u//QCz+Tp0asmru0CHrHXtjiTlv+zjM+GklU0G0Hyz2cFH7ahyCO8aVU4QQDgPYEpCeDZuL2spqwZq34coq7a6Ve7Zva3Rzd3cUfsmMa3k9cHBycsnLOBr7TWoI9oWIDW5RUSTQ4mSaTmelyD/cUmh++GSFNyDp5FHuLwRfJ/Mu2TCyc/cpmaqfAfaKg8vQEZ/GRRMpMjxr87X+1AOxym3CdEQhRWtG2lLZ3tLwPe94y/WtUv5UWpxVHEkLVdiRzbeUwlx8hpP5lOT1dDE1/xB3510kN3BhBvL5AsVkeTaAtY95ri66Nb9xd6PAPDvrvii2mUFw+fMt8FhbUigVDPK8mb2eVPpNrKrvqcbr+SH0fddHIPy553LXpx4nMF+06E3P1n8cT5HcfGEByVfSl9OQ8UeEsrZUxXJ+i63R8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(1076003)(26005)(2616005)(52116002)(6512007)(9686003)(6506007)(83380400001)(6916009)(86362001)(8936002)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(966005)(6486002)(478600001)(38100700002)(38350700005)(2906002)(41300700001)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JFegnIARl7wuj9nNfKlPUY4OoOHWCnMIh2mTG52dJWOkOJktPk/1EFh3lD6a?=
 =?us-ascii?Q?4C8bEpDH2DeBiXwQbxt2BdmcqMxICiP2QsXBVQqPrsxCyqWJ126OK5gtx+jy?=
 =?us-ascii?Q?VnDW2Oq0vkUz7066Sl0U2MDQrl5atQ8/v/5KTL6C1sOnRWimACSwFigW5XeI?=
 =?us-ascii?Q?zzWbARvR5jQIU/QWA/3jQ5ReEvX+hiUBEhvKHDwH4XBOhp3IR+Kk+WZcliAg?=
 =?us-ascii?Q?cgHU4qpPIt+gATZd563Kfw6yZVslvsjM6IDOsI01ySQKycDlx2dcrfp6yde7?=
 =?us-ascii?Q?5idukhtApf1vfdppTPsqLg9lhXODq65HUOJ8sgt6BhJXS+p/4gT9EQBbNMXn?=
 =?us-ascii?Q?ogG/H/hJ1HGELOxcjfl61vGLD4xx9E70LxGyJnVEQKcLauhHa0OVYilUVHts?=
 =?us-ascii?Q?4VZUe+UGWILbHywXlYOKRVHDzD01B3jOkODaR1/oFFqJVoO2jX+oDa3dbCma?=
 =?us-ascii?Q?N6ihYdVZTM4fUbbHkK3LM1dV3DhSt1t+NkxwRNuwvCpUL49kWoPXIm4TM2Yi?=
 =?us-ascii?Q?7N6hCDEjNCYT1xtuDzkr8UxZdx6xJ6H8v/uIc/pILtNtgR+bLHLppRpAlBE8?=
 =?us-ascii?Q?750hTH5PW0ZpJFjgCkjUbfiSQ+1ayzaUUYAdaJR60ej1LTq2oG47psi3pgxf?=
 =?us-ascii?Q?tAOfotU4E2ZOWXGrVW1D6qrdx/EJgHI+FixuVVbFh2TpbyfrepKIE0afvTSy?=
 =?us-ascii?Q?mHOAAXm6h0a/Tg+ogY+wvMRaPX6EqMdsfZ/1VWRJ5igdm1TSyLvz1P3d2pgR?=
 =?us-ascii?Q?nTysTB/8p3+swJpw8ezynyfE7YJrYhGUI16NyNM8wa5iKmLulUbYfQR4s3/D?=
 =?us-ascii?Q?oUc1pybfHxthHzmYn1B54PCdBqt2vNLauvdo0JVjkq4XQgH1ooceN3b2sVFc?=
 =?us-ascii?Q?WTpCYsI58amDDA4l2G4driFonvgWsjGnBBJ5wwvgIWALFh1ZZhm4d4HYT11e?=
 =?us-ascii?Q?l9IUVhfPRy3IU0Y1NBdD2EwplkaJDilofv77mSZ7bM3Pt5wCQmvHmPuNy2Zj?=
 =?us-ascii?Q?uSp7QWkXmMACNiRzB6NZionrlDZIjmGHVqRF4H6p1Z0TreoXteWSGDPbYiqc?=
 =?us-ascii?Q?VKmNzNKielCGFnA1R605JvzZKK+l6BNDPl9AOHvknCkXSQyHNLLL9rw6F0gv?=
 =?us-ascii?Q?A/ran9FTF0+ACD5JWUb8SPtju0NTLyMKKPT5wIgfaGSOUldUzjjP7Vmkj4N8?=
 =?us-ascii?Q?CnsDATl11I2RJHNowQrLgU7vbqJgyx85yDb2WadbFLcsy/qAbMYEMtZuwaCR?=
 =?us-ascii?Q?DRFQgHBG2Q51QNkdAky9r7HNjNyHo4AOjj+8WwBGF5fSiCOjp8vSgtLJ4Wz2?=
 =?us-ascii?Q?NHuztdRqBVVYNF+/6UjJHhEsWaVJ4r8O0bHMZ6JVOfmXQ2MyGRy0dxktJdpk?=
 =?us-ascii?Q?3yBjUWab72vHAme3tkp6S58N9Rg+8cVKWS1Gp2TxhMA2basHa0/UalgEFW1H?=
 =?us-ascii?Q?YouA8pjFvCopsq5F7HB7jpjAKncxdlS94uDg6zFbwAxqusrRoPWJUQ/DjgDM?=
 =?us-ascii?Q?9UsQN5p6yh4quxwRlUpbjHIDVafVWR9m4Gp0/yhJ8Aww8dpii4SFKDMXeQwm?=
 =?us-ascii?Q?cT1B0FXd9o3Gkegdz1ncDjBL/DGETznC25uYDKvLpXN2qVFiCs/8hzp3IRb5?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5405aee1-dd99-4761-f1b9-08dc04594243
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:20:59.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vj7ZFQVvED1/QdsFaoarku4GSik/XrWpg/DKasDoABgmjFJbC1nszi76TLihyCxkJDzFjoagqUYOIacyjuKzszyli1fdDVf4Kr8XEOtosxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-Proofpoint-ORIG-GUID: ReMIQvwrzVwQlDbFMzw5tUhw6QMGZIN0
X-Proofpoint-GUID: ReMIQvwrzVwQlDbFMzw5tUhw6QMGZIN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=771 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

v2 updates:
patch 14/14 - ("crypto: sahara - add support for crypto_engine"):
  - added back missing SAHARA_VERSION_3 check in sahara_unregister_algs()

v1: https://lore.kernel.org/linux-crypto/20231223181108.3819741-1-ovidiu.panait@windriver.com/T/#t

Ovidiu Panait (14):
  crypto: sahara - handle zero-length aes requests
  crypto: sahara - fix ahash reqsize
  crypto: sahara - fix wait_for_completion_timeout() error handling
  crypto: sahara - improve error handling in sahara_sha_process()
  crypto: sahara - fix processing hash requests with req->nbytes <
    sg->length
  crypto: sahara - do not resize req->src when doing hash operations
  crypto: sahara - clean up macro indentation
  crypto: sahara - use BIT() macro
  crypto: sahara - use devm_clk_get_enabled()
  crypto: sahara - use dev_err_probe()
  crypto: sahara - remove 'active' flag from sahara_aes_reqctx struct
  crypto: sahara - remove unnecessary NULL assignments
  crypto: sahara - remove error message for bad aes request size
  crypto: sahara - add support for crypto_engine

 drivers/crypto/Kconfig  |   1 +
 drivers/crypto/sahara.c | 657 +++++++++++++++++-----------------------
 2 files changed, 285 insertions(+), 373 deletions(-)

-- 
2.34.1

