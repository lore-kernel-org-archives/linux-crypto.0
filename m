Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="NL9pnYT5"
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539BEA2
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:34 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B1B31a7021960;
	Fri, 1 Dec 2023 17:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=WllgItLfHitvRna1QQ1b9KYNGztVqDTUjtTy82DSRZU=; b=
	NL9pnYT5BaXezECsaJaQ18rzeIT+931JWZEVRzrnVBzZz2mar+zvp1DXBAh88PHC
	MX3JUVhq+TzBD0zoDi0Z1EooBtMgD8+Ix6r5uxwwOKPE1DLYlAvynzROwDc827ta
	jnznZA2P7y0CnFVnJdMv72SyprfkbEoWhdYii+6VGeadTcd29ZRbtLz8MKwRSGGr
	5zUkspHNzmV7Jugr1A6NzZP14r0kpuLDSGlWdQIi3zRQMufEKYIgZx0YmFy0kyMv
	JBOkEuSMU5YK3uowTgceK8KTybgTSeXZx9YYlDl5SoumAnfpLokIGjXSfXF2cQfW
	+18ImfL+Kg97vneCoa6Pcw==
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph0w9xg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 17:05:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSLEwYYVNlc+RZAFxuqO+2/ntxWoGylnOstWWoyH2T3WKlU+9JeguIMtsP3NrsglLqH8VY5gLJyaj4lhh0bdcaqWpQgnq56FjYXD+e90/k2p13f+lAwN/oeQ1QPY2e0/wg+fHCtol8h6RTirZaLofabjJ/zLC1dd+/+yNhit3Tj1gs5mxyqd/I2OhwZ5A8YvKe3Fnd76vUDJsuLdCiMkKpRNCRtmdVHfpugunwio1wbGDJGlBt0ivcoaUpSjgpSWU++XQtSyNvA7VdzsataWXl17viMS+l+gqjz4DtAeSAkDBSScuyGdai+x86cJnoC9c3q0O91d6NayvhG4hWY2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WllgItLfHitvRna1QQ1b9KYNGztVqDTUjtTy82DSRZU=;
 b=Z+fkrtziol+/JVxxrieEWLdYMLEiop8tQrkcAdb4lLVpOtYYA77TYFbTUMythgV6WPH3UZkeH1xJ1I3skT/nZbQP+SVO2+RSk8SxOTkslyc3bSGqzhRR14P9U4SXcCN1RtIvYqgGaYDp7zRcmTHyMGXXkLISYL1atbeIOy9oyhcV4Mr5P3YD53XULJ6tX5n1fciZ8zCk9fnCxr9fREXV/zuMYLRmgR46WTcpTMlPMsAr/Wlr4NFVQOd85GDR8hDURTyXsngnNeqPRSccix7i24fYNsmiswZQZGdeHCcTb7e0V2Z7gq5BAtEloTqX8Cw19s7Sb/NzFXqeQtdj/2TKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:30 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:30 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 4/7] crypto: sahara - fix processing requests with cryptlen < sg->length
Date: Fri,  1 Dec 2023 19:06:22 +0200
Message-Id: <20231201170625.713368-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 56e0134a-6d26-41da-d468-08dbf28fb8d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9UAG5zZM8o7wZfAil4KFsWzkDA4l9+hwpIsyYlZv4qG6WE4JyfOsq1/e1uXB6rYvdpLrAFOAeVtkZc00ombeKB4AcR1RTtOlIPdgJiCcsjgu1m8UcpBb0faPbcOyo8kL80052ZYTtrwxOfBBzcCFIS43Lbj2WBMHO6uufFXaBouyhVuTNq+tbJ4rTJi3peXu5QqMtqivY8hkC5EkgKg6zYoJEZOIHaHJvORQB6B6ywvTLvDgdxYuCEk7cEHiEgvnCkHebMK0j/IdJRl61HyYX8PmzSfVqyX6LYlw6++N8aSGvDDFbptjDkX1PzS2X4G10Qj6bSHbcIL2DpMAmzxBIxPyj0+bA5vPf93iforvAcyqSOjMetqIt4xbEejrA25P4XUHkejuPesno+zoIH1Z+Ht5xkixf0nlFv/gzk3kIhgQvW/cJ8GYI/iMkawtLMars6G4qHNp0HV/+X4jQg8iaIqma+9PBelrxFQseugYtCgN2GGmlFX9cvE+WaXM88ELoDqGQjKT1k774Fr0mgYEKriQYxLcFA4wRiDAP2HgqzdK1SBbTQdOs5f86bSqxHu1JFuVwmXkqVdtAqglKzS9iT1fiN3dDTB908V2L0qT5IEPGUp+CcxKrX7BjkJQztGE
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LV5Iyl+uvcF842uIOjdGmo1L93DJACW0+jqZ0I3EiE/U2Dy4xi0+Y+t4N5Cy?=
 =?us-ascii?Q?nEPES9zOKakVT2u741NHjikH7Qyp6WXqE2/TV5lFSWFO5z0wLGmTR9WxUKZl?=
 =?us-ascii?Q?7jGmL5DGYSjm61JKowCHesP+ydyDA8xq9E6ZBCiXasI2Dfnk5Ey6p655KEV8?=
 =?us-ascii?Q?eaLvSo9+Ul7fe2VNOKskruqAtm2zTsF8Mlqk9c/dtGGtJFzoaL2KpErvxELv?=
 =?us-ascii?Q?yRINQ1smrBJRnuSn0eiNLTHjzrAsoppxj9PDOiYaS/9LLHDXYGbRenxJvaRL?=
 =?us-ascii?Q?xsj7Xs0v58wF+eZu1zndXxNmZ2kSuIejkNZ/VDt794LNWLQvC/GlD6y0atwg?=
 =?us-ascii?Q?rNgiqgwnhh553gN+Hf+AEwGNqMJdUVDo0dP/Hln9uqzhhG83FPIVBY33ECGv?=
 =?us-ascii?Q?IqGP+rkE+sFTFqJ3UP98JSS1/3RZ/5nsI2+cztTxwd5yOuL7O95IvIsZ2aD9?=
 =?us-ascii?Q?WsdWGlRcRCndDFWnmtr8/j2W7g+U1sPRqOhvCLxbgmcUKneCTHfkWz6Xpr7p?=
 =?us-ascii?Q?f+bGh88CF9p2lHXZk1lAhsLIWlP2RU506JecpANzUVuCZK7Db7k53jt68muJ?=
 =?us-ascii?Q?ShtrUj/6s4Oybn0mlPS7+H9OK2T0eU8vLMTrsbt0dEm/t8OWB8b8XEzOmGnf?=
 =?us-ascii?Q?zizhQNExgIx9T2gRfSZPpGcHManB0ilbRnjUWrjP6A1Cu0K3Ep88lhsnYm+l?=
 =?us-ascii?Q?cHPFlULg7MthV9q2KMpEtAShQw6EfKe276zwMJ9Ka2IXE6Glr1zPEix9MHIB?=
 =?us-ascii?Q?bLTs5P9hdeOHE0Wy3uVF1yDcgNmlspWjXEIqHegjNuY2Gf12Mc8fvs1SrQuZ?=
 =?us-ascii?Q?tM7CQ7bitWYg+HtQCbZ9DijGTgoQbWwehuBTZ9C27Bd91x4Y3GK26I5O1TOg?=
 =?us-ascii?Q?cn/fsArZP7UOvqzXCJ9i5poB7Ljtlgmiheg9zZlOAhXVg9yREFszgNxD0exY?=
 =?us-ascii?Q?h7fFdm4sI6pfIY1FujuPP1fMIQAXz5oljzwfB18+i/Ns+gStalRLlgM2LYeT?=
 =?us-ascii?Q?Xe0DsYsa1fITXwIlkoqdImHOqMhivwD+Iyq5FJYf2UESfHkCr5CofKaM90bF?=
 =?us-ascii?Q?GWnP2tJ7w70Mt+kV4K0aywoeDmBVFOxmdcA3kCLpUbXh+6BorMjC4Xax+Ue2?=
 =?us-ascii?Q?dOLbzuqBYpOeDqcM2v1Ftyz18AjK6XLS2ADsacl+6fkJ4tjgs2amjkiVeGsI?=
 =?us-ascii?Q?RyqH4TRTq8I9OP4kq55GA82WwsL9njvXX1MASzp7P6kLGWbOJkTDimxhJMgd?=
 =?us-ascii?Q?tTYnebj5l3Ff7r0uWHkB/MTZM1HvPERj9ETyLYFGba64i7UNgH2bezrL/v4d?=
 =?us-ascii?Q?Nry5zHtVMeLijZrCp3OigfmmOkULU4BZasiRQibORhZEFD+cwsRypx0IE4/l?=
 =?us-ascii?Q?A+gXULjM05Iqk81MXPnu0mnAsvKLidQZZP9CMgHeXU7mjw108yiXxwnT2Erw?=
 =?us-ascii?Q?0RgSXWtpXgIfrwQLxJk4J8g1uQaek8mi3sl3+xCZ3I0SKO9YtBohIUl82k+M?=
 =?us-ascii?Q?ZIxTSc9AbTooqa7UZ1azZygyBAdLFHoCnHVtUsrruHB2Z1Y/PbS6H1bQu2cx?=
 =?us-ascii?Q?PmcqaGUyDtiwG4w7pAmH+QyB/+Q198XNRLh9f8g5+ZBBycwPtHG0UvtoegS1?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e0134a-6d26-41da-d468-08dbf28fb8d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:30.0380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EI98gIIlkT/2mD/g/HkieWUHtTJOwpqd9On8W4b93sKD5ER59ujp9cqEkcQeHRnsbNniPTBs96CPWXn2EYm+QZCO301mYmbGjoXEgmB4PdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-ORIG-GUID: -ZiTCZnXw1RhaPWcJb-fI45CpycIfMO6
X-Proofpoint-GUID: -ZiTCZnXw1RhaPWcJb-fI45CpycIfMO6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

It's not always the case that the entire sg entry needs to be processed.
Currently, when cryptlen is less than sg->legth, "Descriptor length" errors
are encountered.

The error was noticed when testing xts(sahara-ecb-aes) with arbitrary sized
input data. To fix this, take the actual request size into account when
populating the hw links.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 863171b44cda..cbb7153e4162 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -444,6 +444,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	int ret;
 	int i, j;
 	int idx = 0;
+	u32 len;
 
 	memcpy(dev->key_base, ctx->key, ctx->keylen);
 
@@ -494,12 +495,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	/* Create input links */
 	dev->hw_desc[idx]->p1 = dev->hw_phys_link[0];
 	sg = dev->in_sg;
+	len = dev->total;
 	for (i = 0; i < dev->nb_in_sg; i++) {
-		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->len = min(len, sg->length);
 		dev->hw_link[i]->p = sg->dma_address;
 		if (i == (dev->nb_in_sg - 1)) {
 			dev->hw_link[i]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
 		}
@@ -508,12 +511,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	/* Create output links */
 	dev->hw_desc[idx]->p2 = dev->hw_phys_link[i];
 	sg = dev->out_sg;
+	len = dev->total;
 	for (j = i; j < dev->nb_out_sg + i; j++) {
-		dev->hw_link[j]->len = sg->length;
+		dev->hw_link[j]->len = min(len, sg->length);
 		dev->hw_link[j]->p = sg->dma_address;
 		if (j == (dev->nb_out_sg + i - 1)) {
 			dev->hw_link[j]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[j]->next = dev->hw_phys_link[j + 1];
 			sg = sg_next(sg);
 		}
-- 
2.34.1

