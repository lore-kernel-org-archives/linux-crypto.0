Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="W0hGkV93"
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED15F3
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:33 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B18o2dC004589;
	Fri, 1 Dec 2023 17:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=zNQhHGJGNQlpA3LdVx2jyMiVNoU21ERR1ZpoWGjXzW8=; b=
	W0hGkV93BRkFza+3NGYOFL7rCVtCDXApUhaNaB6ynjuEjPalxLJfXXa7F2EumZyS
	gFcrzwG5RYUzDtdzi0RggnGW+dLopl5vyIkYkyd9sKUc35n4LnakEpzkCOnTW6R7
	GzMN2nseXRihAR6/rQvXYidSANl3OyfsqPQdCxdjcUk/2ytXWHCVncCIBxIfDKx1
	QADeEV4ZXs7ZYVAE1EGIp8krnCbJozKiiSCXOzw2XZ1mvLLK/CzEQOBWfetOduk4
	se7FVqIGxT3C+5k4C5ySdhmvnbT67v96kbJlcvyIm4DYln6/qUIckdeRL96x4dZY
	A20a93Ck4dzf7kTJ/YA6sg==
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph0w9xg2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 17:05:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhyjfHPYq7wjOPPkxI16n1ucN8Xefbc0LLdVUoP/QutWYfNP9bnV7KL8TTMckP3xrsB8E9/Z2xCanb9DcMjFCBeUPg9jzLsT7F6pahY9TPwIurNdfqFy6N+Qxa1HITuk8V6PE9gkx1UFvb7xSl2tWr0BRcpFeLiAqDwhYijjcP4thfBM2+jL865+oGWmPlNH22yuCde1z8VK+pmZbq+hg/O4/Nq7BmBH8yY9rwixlDJv4JLgCpANrhjFIUPVOvLPkfg5JL8ccKEn7SNWCvMhpKnAsJTrEhXxzXffg9sR3BTSVsPr78q9sLa2Nx2gwtococqdMg72WMX3jleh/DsNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNQhHGJGNQlpA3LdVx2jyMiVNoU21ERR1ZpoWGjXzW8=;
 b=Md5YOz9MkXcTuAm2Dsq2JTUA8QaEkEkgUJgpymI7k5aFYqP45aFfSnNMG220xOND7w5UzbUzLLDrikyZbytZ7tYov3vZy5EUMDWqjw2qBXlW9okF4J6A9IoJajLiUf2ZtWIhE5JbTiWJNyIwuEbHHS+CqRC0yy1r5MlBs+/1kjCA+m8AZbOMqKhXaBiNHcHoQcMqcd9faBZTKaoRCWN3g3ykr7ezMQTute5PoN4Pjw+6HHOO+mO1ycbbjagGTZy+vWhr8YTIHXjQzBQ7K0PtycCpu3McJ8qCuzqrA8PmCQ1lpQTL1A3WHcAqywP5v0HCfBQLzp1JeLZwkFM6yqaklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:27 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:27 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 2/7] crypto: sahara - fix cbc selftest failure
Date: Fri,  1 Dec 2023 19:06:20 +0200
Message-Id: <20231201170625.713368-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231201170625.713368-1-ovidiu.panait@windriver.com>
References: <20231201170625.713368-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0244.eurprd07.prod.outlook.com
 (2603:10a6:802:58::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY5PR11MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6d8ce6-3535-463c-9195-08dbf28fb730
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GyO4h7WutDS1OGe3wyPfQDgGeK10j9lBPlRi6QSPFu/fXAZj5GaOBBtejLDURPA27kgJs4ZvRd68Kmq1YwW1ucfgSwUBD391vFtH2zaC2fAJlB3+1Ifs61fXZ1APrVLkVw/AaewIH/cicfWzmOw5+wy4AnV4U/YAFaLTbEWZeb+D99s3x3IibWJzoPCI/aamYvJNTkE2EMJb9gMtLajmJrz0gekvDF4l2diQq8yxUOsuVuyZX7N0LoMMb/3gNJcQi3tg+66hjNs371NrJO1/yx/FxwsanT4ibKON5wZPLwy58mZ2Gz+5oZ4Db/ZMu0jB+wXOa9IFuXESw+7njK031R1zd1CdINg2cchvSzi6Sw0IvQOrubblXkp+NUDR1WCgjTMi1KDztAMDaCRifP7X4TXvLKIPwa3uusiDwV7uoAJ4TZr/gG723ag60NdUen7ETsc0MVaxivnClfldTOWfccNM5pPV41hSUi6Ppq38a+ak1MQ1Bm+c/3cif+OGVpbyR8vUr/BeIUFhyC8M7cYJEaXLwPpFj4gt/cNsSbBFKYsvKDCDjPs3y/M4Db8gS3LLhtIkSi1h/aoIoMs7rw73CqqUaMQqN2wB0BvAXOJaKwPNBpJjtIS78Aswbvu8k/YD
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?2GhHNhBem27pYclydk0nIekcuKZ4Z2BS/EYnmtPFjuPB/rwxO6dmBKTfeRzy?=
 =?us-ascii?Q?t1tVO7WIW28xQnAL88kvKi2GlKVtdK5t0w0WJkbPMd9EdeFx4/dSmh/hn6Rv?=
 =?us-ascii?Q?V9kWyZGwIyh94fC8IaGMxyv48rYV9iHWLN8qOiLUUcMln79kOxy2W/Jx3GZt?=
 =?us-ascii?Q?vBhgE/YM2W9bS+ibbPu6RHkEx3UMYzGoxZAUsSCdvVmgbu+9gzm8DEt11HWY?=
 =?us-ascii?Q?fisA0AJ/52jPq8NLI44uG8QeObczbpdj9ZKVnClLYW0KRchuNHFVyAPMdPW8?=
 =?us-ascii?Q?3SQOOYax1YlOPTPlaPfrgSUv2GKZY4CtZc7KoRD1o26SzQyMrlvrvVGmkwzh?=
 =?us-ascii?Q?wWttWriR0KNx5F+oTd4biRXCYiByOufsRDu+7h2nbT2WjBwvZGwElxh9Mq+k?=
 =?us-ascii?Q?J1EUbUtGVzxz0KoNfeaseKRZpPgo491P/HLdX+SpRgcXpyjSQwC+TW4kl8W5?=
 =?us-ascii?Q?nDFC1tV6c+0AICKSC1dglNk1m95Mitunf9mIGlt25/Xcy8Uu6/pWUa6PStV7?=
 =?us-ascii?Q?kQGW71q20ejFvKcMrg0MVz9lgU51DHYZniFzjRKHubxNAOxWRsRAa0Sg5rE8?=
 =?us-ascii?Q?xT5m5Lb5WwtqURljEHNsKf8SQhQQDq4j6nH+z+THyZsfsulGeABu+WwN2BCY?=
 =?us-ascii?Q?yTIMJijL8j1EM/wLuYwf6ifMaxSsXE8u1wzSf90ETt0F781I9jri1cOZIz30?=
 =?us-ascii?Q?WEgD+jKyngj117mApzSE9kHz29iP5iJysv4A4gZVLEAQ7LeQSqO93oeZ28KE?=
 =?us-ascii?Q?JxU1m68dCqPkN9LPfbgbAmxHXgNxYPDHt25/ItpLeSti/qM9JpX3I0OxzAOU?=
 =?us-ascii?Q?faavmLYVimWL4D6hRQYMicxplEgEX6A0owvppjE7MEviY9nbZuNIhPe8Cj+V?=
 =?us-ascii?Q?5qErd02aS+/7meL1zcSNW8DyqW9q6uDgjKzbJ0bCKGgGlvaWeHAFtN7Zzzto?=
 =?us-ascii?Q?IF9BTu1p9OQFOltTe+LIu2jEnpvD7dmkJrnnc5PXmvVCMTl97esbeEJjuooY?=
 =?us-ascii?Q?ZZzWsfUa4OmHuLvnom2Ji/zP/6a+H3WRptbPGF4GRv28OGNogWdTxbID09Zh?=
 =?us-ascii?Q?hBNEBffLaINCVaChA3Q8FrahlXYy7/ZTxd6SRxZ4VEwm/0hwJVO/uXKtZYLv?=
 =?us-ascii?Q?FhIXXGMkJk0UXLhnpcYTSkZpPU7lSmi0w0ZmrdEgNjAzvZP86+ieFhUPRbtL?=
 =?us-ascii?Q?xPILIOfvyQhWwor1BDWrPDM28bQVAvT7Borr1EMp2giyD+JAZq3pt2DUaFAJ?=
 =?us-ascii?Q?rn489NlvtoFb8cBiMIc2nbRt9TXS9GVDyDyGqRzGx6GTRMIp0mRrM2XHp2mp?=
 =?us-ascii?Q?kXRA+rkwEE7rsN5UsrRQXAY6hdMSSD+9UHVz99188TEWdm5Nvr53v5/dTlrv?=
 =?us-ascii?Q?nzhy5/MQkqJVCg4K6f7W7KzwjMgwyFrVGq9iswStpc1O2criHUgwig17AQVG?=
 =?us-ascii?Q?hsCJgaa5534MUmcVkTnWA1+/6GptdbrMVq0H6Ym05bgjS29+qavvifI19bAR?=
 =?us-ascii?Q?kgQm9bZ2ZY+YbepkVXiqTbTtrYtGeVNtIKTHGiPLk0VN/sql/STdzmheYBBO?=
 =?us-ascii?Q?mNPioCMbQCcTkyxOTR1ODqqHxVTU2Y7SE4QaMmsDOIAqZc7dv2em7idiqXMU?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6d8ce6-3535-463c-9195-08dbf28fb730
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:27.3159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4d5IqPXXBxV3/q62CyNNH81UdTZVjpym6yTY5wMqHQbbXBtxMGBwR3CzWVf39EWyaiUXvUGzJqzAAWQXokz0Rj8S/FYdebTQ/Cm+f+GqJ8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-ORIG-GUID: aojkc3LqJR-wOZ1lSv2BPFbIgWU_RUw3
X-Proofpoint-GUID: aojkc3LqJR-wOZ1lSv2BPFbIgWU_RUw3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=985 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

The kernel crypto API requires that all CBC implementations update the IV
buffer to contain the last ciphertext block.

This fixes the following cbc selftest error:
alg: skcipher: sahara-cbc-aes encryption test failed (wrong output IV) on
test vector 0, cfg="in-place (one sglist)"

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 5cc1cd59a384..888e5e5157bb 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -148,6 +148,7 @@ struct sahara_ctx {
 
 struct sahara_aes_reqctx {
 	unsigned long mode;
+	u8 iv_out[AES_BLOCK_SIZE];
 	struct skcipher_request fallback_req;	// keep at the end
 };
 
@@ -541,8 +542,24 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	return -EINVAL;
 }
 
+static void sahara_aes_cbc_update_iv(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	/* Update IV buffer to contain the last ciphertext block */
+	if (rctx->mode & FLAGS_ENCRYPT) {
+		sg_pcopy_to_buffer(req->dst, sg_nents(req->dst), req->iv,
+				   ivsize, req->cryptlen - ivsize);
+	} else {
+		memcpy(req->iv, rctx->iv_out, ivsize);
+	}
+}
+
 static int sahara_aes_process(struct skcipher_request *req)
 {
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_ctx *ctx;
 	struct sahara_aes_reqctx *rctx;
@@ -564,8 +581,17 @@ static int sahara_aes_process(struct skcipher_request *req)
 	rctx->mode &= FLAGS_MODE_MASK;
 	dev->flags = (dev->flags & ~FLAGS_MODE_MASK) | rctx->mode;
 
-	if ((dev->flags & FLAGS_CBC) && req->iv)
-		memcpy(dev->iv_base, req->iv, AES_KEYSIZE_128);
+	if ((dev->flags & FLAGS_CBC) && req->iv) {
+		unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+		memcpy(dev->iv_base, req->iv, ivsize);
+
+		if (!(dev->flags & FLAGS_ENCRYPT)) {
+			sg_pcopy_to_buffer(req->src, sg_nents(req->src),
+					   rctx->iv_out, ivsize,
+					   req->cryptlen - ivsize);
+		}
+	}
 
 	/* assign new context to device */
 	dev->ctx = ctx;
@@ -588,6 +614,9 @@ static int sahara_aes_process(struct skcipher_request *req)
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
 
+	if ((dev->flags & FLAGS_CBC) && req->iv)
+		sahara_aes_cbc_update_iv(req);
+
 	return 0;
 }
 
-- 
2.34.1

