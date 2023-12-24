Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DAB539D
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="oEGKtU1P"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8LHEY028291;
	Sun, 24 Dec 2023 08:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=6hgaBw09txHZH0YxfSZGMqUzwtuDDReyweHC1Bg2UKA=; b=
	oEGKtU1PbuTmlHojzqQjY67QwgtK9S8+qLmHs0E1WlsD0Fx+XTshaf+DJfTB2tQn
	vVi81DgU0Gsd7tVyOb3ILHjd8vo3qLBaySUSV0RlVJaYnDhvG57H/ea4K6EbS0lD
	FmThJ85f49V5KbuOgM6KeH1kUHqbiTWGeGgxVfH/RTXYwZAftK0Ut0BHMGwcxhYG
	fQnHbo/356UxhtBieSjv6qGbLouHE4wan+7FY7Umqjt5SmcrE5g8YgKyirojhZFN
	pCdERUBSrdM09Y4mgXJbTjOAn955VJMadkS0wWR0dZ9hKRC1BBkhxvBPNPhiU36u
	kuyYCGIZWukVnNZX1JmsBg==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrtng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lr/vs8kJxVe5IItWJ/zyqcl5ux4cNQdhp+VVDqvksQ4Y/QdDHkHjHeZZTQXM8thaI5KVeCldtEK/TOLyQCH8E/wro52I0qYpoYv4NGezvHnjTKP40jd2ux4W5v2Um14uVXrswYFWnAyZaIxG47BAo5NX1IYEnRWesA9f7jIk8LkpMUmpL3VJ8vdmlr5t/f0vrBjpOdEPhMHSdvzBz3pHEs26E4Neol6w/WjTBfzv3qWI4+yxy/Q33Drlsy2wXNWX+dXz8x/Uqi0CVZ7UF1vqpUyS36lP3l46MQhNT+VBKYHrRvNMwT3bcgSOUjIsBq1NY9VfM0hMPG2ZllGak6uuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hgaBw09txHZH0YxfSZGMqUzwtuDDReyweHC1Bg2UKA=;
 b=e9E3wCk35kOrhpzcxkHIBNCADbSuS6EhC2cOsmljN636Ordwq8OStF1se3sQ213U/Bm/CKiO0pLrzBNzfKrjKJUHHhudxAeM/m5hOjC1TABPRTw0n/SvB/gvQTR/XPwI8f7X6bKU6rjH7tmhTba+tRkS5Fx2kJokkxGkafosjbNGUAzGeHLR1sNAj9h585tCm/G7H2ZpDCbnHpZD3rvDco0iXEB7PTHXHZkp6O/BfXrQ+kIJsYQUEpMkubOo7pDHdVx8q1uVRh/vs352Z9Z3PQtguejgdHgaB24SC0wE6SMInyK7Kvygho0/+aMd8GgaD8x9gjeyXQmlU2BIyhqm/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:19 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:19 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 13/14] crypto: sahara - remove error message for bad aes request size
Date: Sun, 24 Dec 2023 10:21:43 +0200
Message-Id: <20231224082144.3894863-14-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2a188bc2-1c00-4f81-16d4-08dc04594e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Oafm2DO4cxU34Dkn9YmjsjzkgZ3o8Ir8ijUzy4hzn+5I+FYpHP+obQccAEPZP+IUyu7tE+ber51r47f2q2J1KeJjVMxYCkloC/Aefig0E5apcijTRnwet73+iYyEqjZq/IZVeP0+jJ8Gtz72cHXCDVMI4kZ0vyPtbX8MdDs5klorSJ6jhYl81CK05nB318RhLBTPY3EAV2htCIuzKs089jE9433/uQTsM4PC8qS8Bsz+dUdoI1YnSO6oMIVZxqvjjK/BRDpApJI+d6vPZKnV9M1F3+JSOqv/K1Hq2jJcw4bBXkp3nC5fcS9IGKXtjajrorijMeNdNnH9FhLw0EdNobu2ldOX1K65nw3TLjpn6rCwF8c/KDSyP6wmSrzOCkHE0DgOpeq48HjjmpNXzwa0Fll8yBUcQ8SfpoccDAQ7vVKY/PwK5EJJSC8JoEsM6lH2v/yL2zJpHPrHaav5LIRMxh5TWWz1uJDNucjF3fW+C+ApPnDZLME7L6AKfTgoIgYqS9obrcuuNQZmhoFSlYmSNixMrRuj2DIxWNbvvQbcKCSV4g4CYebxOZEIFGFraEe0dx0IsHtlzk2gz8sSeYY6serfoP88y9eNiObVFQ/YEAUtr2dzMlqI+8hZo9D5GGZv
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(4744005)(2906002)(8936002)(15650500001)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?eLjkkMJwyaOqKFbKGMUr8BpTCFO+UycungucQbjgW32mHPRIceYsxXKzspy7?=
 =?us-ascii?Q?ULZAfaNJwhkx+Ih74A5Scjdu32ocQN0TTDufySbLrIIo2ypCAiIxjijfcueY?=
 =?us-ascii?Q?YtCZ4eZakrQCovvKK/gpBlhmgdjTy5XvsiZjL2o64e+MlPcaXhRV1QMIoV37?=
 =?us-ascii?Q?pDK9sAkNbpQWNzmQ+KlqykC/rW0pUZVAaVU0sKAjziYrK8peazW55SPvF1B8?=
 =?us-ascii?Q?civolBcV7YTNKKzwuG+5+vjuqRLvmwysjL5wmB6bAiY5MXqATO8ICeugbFP3?=
 =?us-ascii?Q?h+ixLBpoQjmFxi+hT4KKN/qlHserfsjQUFCy8HZDcXUzPTV9R9MO74xSBSbV?=
 =?us-ascii?Q?roLbp0ECuDVZJtn1jbH/0fVghgBh7sICRHjP8CmR5TFWsVqjHJG+oEVJH857?=
 =?us-ascii?Q?cTGJxTMTvpeqRfXwWE0L/POJeu1DaNQBnLsTcF5Deo5NYaiTHbwD5oEYCyzC?=
 =?us-ascii?Q?u643DZsmun/BqIWwahdnHqy3wcYcY7cUhX7FiIEtHIfMtMDQ7zHLcZycVwtz?=
 =?us-ascii?Q?AhDwkUF2hjwrplM7eVz6VppBRKzhFAcnVebvp0USy/pdIoZIhYT71L9fmrW2?=
 =?us-ascii?Q?FnxS6ec6MNZRBR1Fxx5mIcctE6FG3r+7WsaOtvVYs3ZTdUqbN5gZTSsQbOXG?=
 =?us-ascii?Q?x3PaFsV+UPXovJ5pXAIIvqHOhKv2szIqPsL+uWI6nDCKQq8SdiX6Qc6pnyq1?=
 =?us-ascii?Q?RtyfDjTZCz0nnrxFRbfSVOzwgHxBkdkRHCg18CeTQ6IReIZh6vUQ6i4s8qqQ?=
 =?us-ascii?Q?SlGhVaeHX4s4zXJ2OxYmWi9Sk4gT0+2VBcXZIX3+CzK/QwUnaseqFOlNKVXa?=
 =?us-ascii?Q?U+2Ccxs0YG2C0DLjDByMtHIyKcs7RXLCC0kk+PHmx3+hsAgp8kNu91ryz3Xt?=
 =?us-ascii?Q?FJSbZ2xgQ5mNXuJqbrcK9je0kTpknV9EX1opc2mORqsC5rxm9xaL44g6DvQ/?=
 =?us-ascii?Q?9F11WGvr/twHu6E89OcmsrlMS4RG7HNbdYtck6K3B+9eUKddV96EbLuuRlsy?=
 =?us-ascii?Q?LhJHyC93xWQBXcZkAy4PlOFkEJintCAhxcxrueh8fAUXXsZAJJGUqoGkstOs?=
 =?us-ascii?Q?U+3Yu6P1fsMWDSyjnSsC6fUwi2Qtqkz1y1ISuhRF5oiYmkkffAPVwHyKSH9t?=
 =?us-ascii?Q?YzBJKry2w+DkM5X/sNObMYUjcI5LShX+mELo9FvGeclEWEJNC3shbVogGN8N?=
 =?us-ascii?Q?4KrzbmzKHT3DVEkk8WLisnqKpTurJ2NxQdFpzFncd9/sNZpt58IAmiLHxwl6?=
 =?us-ascii?Q?0d8J+uOcRQiDC3OB491SnPgJ/7GoNMFPUyqxEbA9jHkN5RA3z48al1OPy4Qf?=
 =?us-ascii?Q?r4UwliWXL+a7PfDYkxOEgag3zvbgbKonVaHEyzwVysL5F6VWpwUnu2pcOMew?=
 =?us-ascii?Q?+WEc3MJ8f2C4nZU1AvkwlmnRALwPflihdPLxNCwSHLItl3AAjaTCkHhnlsHw?=
 =?us-ascii?Q?CcEw+HmrzSgCSA1nCSRBeSiEtWkfkryLPQquyBjh1HJ3txtkY+C3RMk0trlW?=
 =?us-ascii?Q?8ne4JET3aH6qEVA5fcD4BVnLEEwDnqsq3bBl4q/x/vrWN3pHeyicKyeBVMVj?=
 =?us-ascii?Q?mpSup+fzi0hDOUNJa5UVH9a6UF+zV7YYO9im/05h0PpORPCerkRUE4gAq8PM?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a188bc2-1c00-4f81-16d4-08dc04594e00
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:18.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeaMckp+3wWua2EjmRXuJewNl6VWtx9NwjgRWFz90YQZz6xJOmFfEWPuUNtmr9KrD/R7m+AZnHphzCfFnTNZOiG3dsfqhezami1mOYfDSfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-ORIG-GUID: bcoaBA_6mvra74bGmi3RF_Ux7xYe6TY5
X-Proofpoint-GUID: bcoaBA_6mvra74bGmi3RF_Ux7xYe6TY5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=889
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Do not spam the kernel log with unnecessary error messages when processing
requests that aren't a multiple of AES block size.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index fdae8c7e7c78..886395603a3a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -682,11 +682,8 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
 		req->cryptlen, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
 
-	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) {
-		dev_err(dev->device,
-			"request size is not exact amount of AES blocks\n");
+	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE))
 		return -EINVAL;
-	}
 
 	rctx->mode = mode;
 
-- 
2.34.1

