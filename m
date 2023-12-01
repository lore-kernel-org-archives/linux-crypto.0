Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="XgCkNjqL"
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC81C1
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:33 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B18o2dB004589;
	Fri, 1 Dec 2023 17:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=PPS06212021; bh=KVFlhhIEzQkUuWUDZU
	w+AZIRZgfRV6TG9bz6p6Jq+aM=; b=XgCkNjqL+vbUMefl481lGD1jvpuMsh+BsM
	1YTKoUsaPr8DDz5CbDFkD1YWmvVYQydgI2K4j0wEIwqyQXX27avGNDou15PU/qrU
	mG1EXF3m9m4qlVr2CtcCNIq8wmUXD9e98N4M5g1Xyze746jQ0mCEnHZXASUsTvBG
	mY2BD+MGJH0zJfQ1FT8iIOpyu8V9Dr/TNu5oVl2iGUMZUgGcBeUCBBQoamQWI3p/
	/IFZHEUi9n6ydRyWyyM3Ic6kUuQjXIm/1asigKveD4HKki1sqeoZgT3jJ+z0siXS
	Lasqk7G2E7jgo7hN5Xejetn9HKioGTu1jnck/MY9rN+hfriqS9Hg==
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph0w9xg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 17:05:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuhRG8IQHFiUmjmyTq6Hmx+OEaaEkOAtPPpXri/InVX843b6abcOs6gbZ20rJifTw9RyIn3z0AyYtCGWkenJx2qLK3a5J7+tmOyhVFapBlPoU6m4o0HxdQT1Ug+fOdmpB7GPvCi/XWRCWPCVvfMU/WNagNN/9BySs7MehED/Udj+0rOC4fmapqbJ9wzMir+2dzs1C+Gtu5kRx1YokwX3jVUvvdSSihZQBAg+feiqueEEPJ5r+PqHnIgOLV5lJPBsuna7DRft1IFqpqnx25Qp0dxgao1yp+Dam0zt1Dia56cyspK4I3tqeHKCT2TcuvjzpgXHHHBjCpeY8bh8rioPnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVFlhhIEzQkUuWUDZUw+AZIRZgfRV6TG9bz6p6Jq+aM=;
 b=F9F5Fn5ADBeUJiUObO2gWGu7FBT42IWJPLlZijKPcStyIhh4KCbmRDXZ+a/jLprzIxFF0UwBhcCc3MfYmmNd0918Gtzdrk+MCPyF+K5l8rjJERtDCO4QiiG8IMj/zT0Wny/tdOgF2RcGcjIYkH7Fl7+3bJN1p41xNDtjMolzPjK/4giwxqHba4vSMS7XhuJXqenmwLK3e/8sgwLvNvVhOpV9ftKusK2WKf6plGrDI/iJ5s0GnZqmd4kAC0ZD3FerVJSgqecB6dv0INEi5aP8Pqp79zC1VKag2y8kTWUtocY83095IYcBSovbSVQuG+/+pRRp6Xa3vgQ1vQZ75rIiLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:26 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 1/7] crypto: sahara - remove FLAGS_NEW_KEY logic
Date: Fri,  1 Dec 2023 19:06:19 +0200
Message-Id: <20231201170625.713368-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: aa4a5ec5-6ad2-4126-347e-08dbf28fb674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZZD7VDUK7b57b3lM8PnKheQh46BZHyxFPMg7BywMYM7pSSPVK1ZfFVKPTU+xsnbLhuKZJzDhrzCXkIwDfCWgmEsJv0d2k3mNQdkaCF2AG8oG7UldNQvjucv1znXLIwuabhDEIbl/0EMxDriV/pa3jUa2kA5heLnrPMzV89/ZzxXvcdsKLRY7+Q0Jj+8dokmdR8Olaj7kkCdz7UHggjPN+r3JcBPIJV97429fyYjqNKCciRx7/K0K/odo6XHnWAqFqdGCAVnRqleNlMOxB0Ml81IBxOTPY+KF44D43uyNsfXNovs7xaAmyLDrBGfQkrm8KB/iTueP5hRqxrYNpg4RkxX8YGeMMcKlLZpDEXX6JKii58BLXwHJvRrHSnFkEdiepWmWtV2hZn3Y8XeE3D3+2XjLAAfi1HNAWkaXiqOHCWOzmmN8SKerN/onPGNgESs6w0r8lZ4DAol8y8tgJhDXuNhEh+UeGzWvRDNN5TSYcXcOh2qhQ3zmmMDgwIv+tiRoCCTzXT0czvx/Hw0kDLxkkK0pDEVIdUL0BR4dG35WhMug3I9ezHrvzKphest8VQ9jMT9EsJWypw1KoWSK86De7A35U260BUYkmph6Im0biVEf1rZHiXIyze3/VBtdnCAJ
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?gDHDLBxKc4N7dnFQFrIe5t5Hx5h8+5HhEZa3bc2Clj5YiDe1P0AjaTrw5WjE?=
 =?us-ascii?Q?nV09DOTaYX631ks2Bd1ir0ET+dycwFfi2pJ299pj/7+5Zk9tGIPzuR/ABhL2?=
 =?us-ascii?Q?WGb4C7nMmSanTcBVVBgE980Kq49erMZNfxJyJDauqH8pGuLFXolRg6xu5MMI?=
 =?us-ascii?Q?JIh3os5x9b/2OhMAdsqjsxRVCgpCHZAONT5teHguh17B3yJjWl/W31WohcjW?=
 =?us-ascii?Q?slhE7Cj689o8ZVoM0IO/guVsYHAwt8ZbAzxHL1raEyv55jg3gfDDutPbf+XV?=
 =?us-ascii?Q?e7FWTt11HaiGUtptsbONa+cmx+lUavUFd9TA2ibmAn2cWb6Kz+0QvYoLSOmc?=
 =?us-ascii?Q?5sVxTnRHo/4WUoiHYHAQOphMjKRTw7vsD/tY+tcfsp4HhSgukll+dJM7syja?=
 =?us-ascii?Q?btR8dS3i7tpH6Egh6VOhhy3Zlsx4pL0n7p5tyqGMBo6H0w4xA3sNeccK6XFZ?=
 =?us-ascii?Q?K7lehE330T6VlFRLV/+vXybupDEcyP9BryDoo9HBjt1WsbAzZIgEhERVkhZn?=
 =?us-ascii?Q?Dse4vUH1WwHCVT+wt7oJpKFPJdi7kk0WAJuQ5gbt2LYn5QrftT4Eastls2ay?=
 =?us-ascii?Q?hBuoxMcqBIGIniL8GfCxmP43JbiKh4ZY8hlYVXbIv6NNf7PWctWS+FeG0wa/?=
 =?us-ascii?Q?z/wg80ki+HSHQGTk5zt1wJ0E9jEVu4yRsWu6qlxIFK6vxDg4G3jWTdpWVT3v?=
 =?us-ascii?Q?1CY7bRCn9bNIn9tQu6hRHvCGdyRzWVr/20PoKzLqpm8yclma40xL6SU82LTa?=
 =?us-ascii?Q?GGBXxCHKOkTmIeiABJNWBXSkxXPIoND/9UIJDV6UOBQud2gpWi75WeXTon4X?=
 =?us-ascii?Q?fr8eYFuMgR0GxtNKbfAP9Lw9QF23hwmAA11SnrsrGYU+PyuG108dkT5E7iIG?=
 =?us-ascii?Q?ykuIci/cLwTRTHrkADJlTG8kDN/tfQvxWLoDfbyDkfTI2Iwas2TtXtNm76bw?=
 =?us-ascii?Q?nJPd4NBCXV5zoSqE2ZYhYEntYQG6Hy7MZR2WQPCfju+aqjt/GUPyKn6CsJ3Y?=
 =?us-ascii?Q?RcHWUFHDUWauV5QNLxupzVuJKzxYNUybd0qzFoHv53YFrHxrzRUhVMV5aCWo?=
 =?us-ascii?Q?MQtL0P4iC+5x2KhCic1PmY0b+yj7AtLD+0frXM3+U8bIV9wCGPPN9ZCQHjS4?=
 =?us-ascii?Q?HlFcica1uoL2PjMO34Km0IRPul4RW175dold5jrHa22njvVPc+SfMpXgq5uE?=
 =?us-ascii?Q?1ihUHBOWD8zJhJ2GK6j6V+TjPeHWZyNonbYZU+rg31FdOQEjeUGlC+a6tNz+?=
 =?us-ascii?Q?Hv75DkSl8+j1+yvSKgTEB1I3A5LN7CMZVnc+qo8ZLjizdhseo6TJjrM/+8n5?=
 =?us-ascii?Q?9XQSz8KWlOFm0mLg2M80sCRpU5CcgUhY6+HhwUH1n+1Ox7rFn2bLToTtMXoq?=
 =?us-ascii?Q?kE1t9IS5XdUB/zhytOOZZ+78X7pLbcXCZOFE4Yiknqep3gglaWyhdHlbWBsQ?=
 =?us-ascii?Q?0zu0Ja9gbhchtnDwKaAFZyvERFPFYWqThQjhrO/XoD7npOGZotiy9rIsqJzh?=
 =?us-ascii?Q?tgQYR8lIvIKk8xSo74+PQodq0tMlOZ32vm4xzMNkTgchAcNUnnOjODh78LKv?=
 =?us-ascii?Q?r2pxHtuSeU9lfv6o6xYK32oTb19T7J3SvVH9Q41a05RYJyQ1aXeF4eKq3K06?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4a5ec5-6ad2-4126-347e-08dbf28fb674
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:25.9862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoa1b9GrYmuWsmrlkPiIsPbp0EcaxtsvIKu8HzBknlyB7vkTfjbABygxNvnn2e61j7xv9hH9P0io6J3KtZ8vOGwOYIA53YGVlTJM7DbWsog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-ORIG-GUID: UiiOHEhsHCnOG90mXDlR0_vRA0f6f_ni
X-Proofpoint-GUID: UiiOHEhsHCnOG90mXDlR0_vRA0f6f_ni
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1011 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Remove the FLAGS_NEW_KEY logic as it has the following issues:
- the wrong key may end up being used when there are multiple data streams:
       t1            t2
    setkey()
    encrypt()
                   setkey()
                   encrypt()

    encrypt() <--- key from t2 is used
- switching between encryption and decryption with the same key is not
  possible, as the hdr flags are only updated when a new setkey() is
  performed

With this change, the key is always sent along with the cryptdata when
performing encryption/decryption operations.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 02065131c300..5cc1cd59a384 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -43,7 +43,6 @@
 #define FLAGS_MODE_MASK		0x000f
 #define FLAGS_ENCRYPT		BIT(0)
 #define FLAGS_CBC		BIT(1)
-#define FLAGS_NEW_KEY		BIT(3)
 
 #define SAHARA_HDR_BASE			0x00800000
 #define SAHARA_HDR_SKHA_ALG_AES	0
@@ -141,8 +140,6 @@ struct sahara_hw_link {
 };
 
 struct sahara_ctx {
-	unsigned long flags;
-
 	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
@@ -447,26 +444,22 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	int i, j;
 	int idx = 0;
 
-	/* Copy new key if necessary */
-	if (ctx->flags & FLAGS_NEW_KEY) {
-		memcpy(dev->key_base, ctx->key, ctx->keylen);
-		ctx->flags &= ~FLAGS_NEW_KEY;
+	memcpy(dev->key_base, ctx->key, ctx->keylen);
 
-		if (dev->flags & FLAGS_CBC) {
-			dev->hw_desc[idx]->len1 = AES_BLOCK_SIZE;
-			dev->hw_desc[idx]->p1 = dev->iv_phys_base;
-		} else {
-			dev->hw_desc[idx]->len1 = 0;
-			dev->hw_desc[idx]->p1 = 0;
-		}
-		dev->hw_desc[idx]->len2 = ctx->keylen;
-		dev->hw_desc[idx]->p2 = dev->key_phys_base;
-		dev->hw_desc[idx]->next = dev->hw_phys_desc[1];
+	if (dev->flags & FLAGS_CBC) {
+		dev->hw_desc[idx]->len1 = AES_BLOCK_SIZE;
+		dev->hw_desc[idx]->p1 = dev->iv_phys_base;
+	} else {
+		dev->hw_desc[idx]->len1 = 0;
+		dev->hw_desc[idx]->p1 = 0;
+	}
+	dev->hw_desc[idx]->len2 = ctx->keylen;
+	dev->hw_desc[idx]->p2 = dev->key_phys_base;
+	dev->hw_desc[idx]->next = dev->hw_phys_desc[1];
+	dev->hw_desc[idx]->hdr = sahara_aes_key_hdr(dev);
 
-		dev->hw_desc[idx]->hdr = sahara_aes_key_hdr(dev);
+	idx++;
 
-		idx++;
-	}
 
 	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
 	if (dev->nb_in_sg < 0) {
@@ -608,7 +601,6 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* SAHARA only supports 128bit keys */
 	if (keylen == AES_KEYSIZE_128) {
 		memcpy(ctx->key, key, keylen);
-		ctx->flags |= FLAGS_NEW_KEY;
 		return 0;
 	}
 
-- 
2.34.1

