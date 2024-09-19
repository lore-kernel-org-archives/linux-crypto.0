Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2051.outbound.protection.outlook.com [40.107.117.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A611922FA;
	Thu, 19 Sep 2024 07:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726731339; cv=fail; b=G7TAlDdK3sWOAXPTNs/Kggp5MCFEilKokllSk2oIz9lf1Hc12cxrKgVTQ3+btB8bUt0mqoQ2GdSMLt5CvTBFlWGZuBo3bNhTrrI5LQdQ9Iegb03OlZt7yatheuMQ2JamTU6AqAI0tHFDsy4FRDSAhco2PIKrtuAi8PW4bAxDusQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726731339; c=relaxed/simple;
	bh=Im0NHazUHrGMyLwZ6fL9txiRP95yUUm9PQ57r3RklDI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=gQ/n/scZyWHh6co3iL66U4oCckt6s12lBjIAI3V0YTPl+eg+efSWCZgUlqvwpMBJp6lRyEWcDVkHpxcRRTKIT8pmiOaQmHOuWl3Htk+XDbyCf6JN/Z1vRNSf02WqSXDvRLz+NiWJgzXuO1w/utVrmkZlDexornE3sXZShQtMzP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=VQBqYeSd; arc=fail smtp.client-ip=40.107.117.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="VQBqYeSd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZwvKjgkm/zBIX9/aPZ1BHKrRHmYaKtGwehpYiifoMWLTCp8YmjU7jmBYsxadpSycc3LXBL3lD4hS1k2GWWoXHFdsEWBuECXQsdeFV0WDKb6fvdZ0Vn/pxcsb0WX12p4hrGKERgBNHk09xEPn5kcXqs2u9hYDFhNhrIyeLx9L4oHw8zZDjrmqaG0RewIRzR1U089StvcOKwHsJWQilUbHNP+9rYoE8VTd2jRi/8wbGaLnREET21Wih58M6NRI5npKaMxnwPKU/ABPuEWX+0kCfTn69iG07GWHDqgow/Ik+PqLRt7ggBVcDApgozCsX+0Um0LRwfg8zNJRjwGHROrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqMM/vNfWBeSFyN3WRhNgtRO9GikQKPID/azMGLNeDY=;
 b=weuAQtb25IpNOEkHaMUEh7KdiNXlGCR1q52xiGSWv/AbH8udnQfChAsRuJTQSM7uxiBXUHcw/T9QtoDoiea0jzNeWlg36HynUhXk1aWAyju9gEK+tRyBAS7/6ZHOPepvt0497uFCfyAUPy6UJWYC2XJPzI3HvpuuxjA50nQw7wWqLmeTSa0Cvnqelaak1yjYsUOYPfMyVsJU7VQOSNK9fV+Hke2ty9GluLu9XT6qFbyLbTJPA5RnN6cqJVva5bNrGCtkhOeLTbLIUPywyBXGi5OLu5/9ukAfr87bEpESLRdKITmo2R5bFO3fjvEBd4P0Ef3U43lz7pgFT8T/DF7pHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqMM/vNfWBeSFyN3WRhNgtRO9GikQKPID/azMGLNeDY=;
 b=VQBqYeSdJbv1nEn6kCo7Pu/plZ1ZnjrAYrmFECXgFEoj0hAiAgyeffq+efzjaLICLVVJBk4ULo4kzT5JRzIq9oDTcM2YzlXrXNuT0qqB/xFC6nLow5rZ1aSuPmKxU2BpwE3xl/uZn3oDSmlT/l00/4zcH6FfFAZI7HhlRsdt690CrGkXkZCsYz17uCVOlJy64rb7NJxb4elkAsAiAIibCWMm986NAGFJTmQ4Ef/YljfcozajrR4CXdtYeD2skgjHh5PpmE7ZAfuvcpYqUq9SWFrnYYWGjtY+XXeMVVvt5BTqh9lCQWBZCpJ3tqNPa5vT8NBPPOp4E8EDWjpIU1pbNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com (2603:1096:400:82::8)
 by KL1PR06MB6865.apcprd06.prod.outlook.com (2603:1096:820:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Thu, 19 Sep
 2024 07:35:33 +0000
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70]) by TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70%5]) with mapi id 15.20.7982.018; Thu, 19 Sep 2024
 07:35:33 +0000
From: Yu Jiaoliang <yujiaoliang@vivo.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH v1] crypto: ccree - Fix typo in comment
Date: Thu, 19 Sep 2024 15:35:20 +0800
Message-Id: <20240919073521.1688740-1-yujiaoliang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0070.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7d::12) To TYZPR06MB4461.apcprd06.prod.outlook.com
 (2603:1096:400:82::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4461:EE_|KL1PR06MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 1072c98d-7081-448e-6367-08dcd87da52e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+s3zyZbRDouMvM95LMPrFLS7lueYAYU6yinIxI6ufSekpCUTEFafgKmTSZV1?=
 =?us-ascii?Q?2qCWROYeo1Ig5u7sRF5tekYEdlQZ0cv3iurMI6Eq6/6ynh+x0+4gzvnGpzRa?=
 =?us-ascii?Q?8agsom/gv6WNSRAlZa9ZIJOnmkFvcbcCB2grRKre//Xz9ED6ic7yQKwCmu+Y?=
 =?us-ascii?Q?qcoyPK96D1ipXeaZJrhupuD7Dpn/l+4JeMBq1pncEGIhXXUHzpU6DWqpEA1g?=
 =?us-ascii?Q?C+cyOfNnQxKW4p46J3wldmljAAowd89aWMkaWdpIYVfQBz7px5uzVHpNFTvF?=
 =?us-ascii?Q?r3ewVv/KJsLLzU7lip32F2g9CeUygoAO8jlEXoDmVg5UR3dHMso/jLU9gRo0?=
 =?us-ascii?Q?kIwFawcSYE5Vl1u4/11jLIm8vylxiVe75IzhfFB2pz0R17cn5CtKyVKHRK3W?=
 =?us-ascii?Q?85eOJIBYKn6A6JTs5Hm0v26kLI4rxui+HPdAgOijNhkFEOzalgO6CZjPOO+7?=
 =?us-ascii?Q?ARl5nj00Fvv+AdgqtznAnfkAmcqoZRWkLiwhCwKC6gfKT3iB3j4VMf8evB3C?=
 =?us-ascii?Q?7597YPUE6Wmy35aPiMUpVRnc5SRemWTcST3nHHQ6Ntgs1BW0+tY+3UAt9tKY?=
 =?us-ascii?Q?WxUlFuk+q77lgvLsI6LUO3rCRKkkjmTIaoxO3tNGXC81tr6N+X5Eq5lEJO5B?=
 =?us-ascii?Q?+zbLryCYR2MwSXJMurYeZz8ZlfvDm1gKZWrYzdEGD1M5TqqKopdtR/WozRXx?=
 =?us-ascii?Q?TTBSzeLfeq0wOMOPY8+K9KW5demIufzJnwLBv1FMtX+2THlozu9I7N8h6E2k?=
 =?us-ascii?Q?tfjgr7cOdp11AyZvHgB1cKx3VB4nT4EjlKCu288uY6zG0uCZTTBuxd3dUwxz?=
 =?us-ascii?Q?UCRW2JpVKKVh7sLgyGR71pZHqrgmGId2dlombkdlohl0lmbK7u7Ze/AzrVuS?=
 =?us-ascii?Q?5UzTlYccHLDxyDaElSOoa1uFQShADj1t0ActUayl9/KulQTijPsTOhHO5Unk?=
 =?us-ascii?Q?8n1DfOxVSm17kEIZCaK2kgPAA9QuRLHKmR0TsSFgdK808bO2FRAdOQwtGlD6?=
 =?us-ascii?Q?GgKv9+CnHFapi0Tjdna8Ipc3EopZERL1zc+9NbB6Ll2+Uh6EEsI95Oq3Sy3V?=
 =?us-ascii?Q?CgxoeCtdeafV0hQgfdrPbaeom0xwaTh22ogutgRLsBYBQpIldhaL4MzIaL3n?=
 =?us-ascii?Q?LRU9Indmrr0pMMGdQDdD3ZuFBaeH8t7L2D5UeD3+v1+XYswosLWB3zOSWSXq?=
 =?us-ascii?Q?E1UxmD/BmcwmLFAlu2FqMcLiH7L+kscsRkfcDqkvwHpIF1GqKQRgCC5C99K/?=
 =?us-ascii?Q?RLJV0V7LZ5cs0kcRZIQRtZ8SQYPPxRzOkeDFKtUfAuE0DFALb7MYBXtAPKCw?=
 =?us-ascii?Q?bcIUIPwVHSbYwyiYKCAzexboKG5T47sTpIGYqmY82VPOUN7m/fqYfdCipp8p?=
 =?us-ascii?Q?giktq3iBkj/RHSLHHscOFXdV1E38gDJCKWdHSAzjzjcYaJhNCg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4461.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TEn7+7VJCJiQahC25IHZK+vW8lbcDsd099dFchxBm/0l1rfmlPb5ApanGefI?=
 =?us-ascii?Q?pQH18sMr8C2c1sTbbRKJo2BFVt6ummjKbha1MfD85YL+8vuPL0PFzJwpqFqq?=
 =?us-ascii?Q?vzq4DJySz3/UBLKWdyr7d63o0dmVZI96IpexHsd9kYRQ+5p7ZgGKgfZIL24b?=
 =?us-ascii?Q?/T0uycr9+hdelpIg6WNNx5h3yInpfWrGAyU6PTOertERyCRw37dqRTM4luB6?=
 =?us-ascii?Q?9UKnybmQBLnQfSLFuD72a+kcK+cDIre1OO3EidHknL1+4Yr5QayEXm5gMQ43?=
 =?us-ascii?Q?W82oveAydBpyWoDLT+8pclDOdVrv/e/yI3VK8VR4WcI8pY3vD3Vjh9eUlZdP?=
 =?us-ascii?Q?ZF4gyuo508RZivDnS/wZmJQob3z3OIOkJDKOQ4WJ3z9SXmfQYh808dySfRka?=
 =?us-ascii?Q?vWr5uXwCXKgC4SSoJeyyKbqMntvKEJMn7CvaCCFZpC7AgiyljZKkDNQOvET9?=
 =?us-ascii?Q?g9owWW+OPWHQfhdUyNeB5JYW8dT39BkTPuCFdJZKGpLjZLt4nseEgdz2tr/Q?=
 =?us-ascii?Q?d5mv0ZaWlpXQsOH4+4YYuuoYafqEJQscUyw3ZQMxIGANyBCh/jc4vwA/o6Bx?=
 =?us-ascii?Q?tE6WX1dDHGXywvLBRKb377clIJl2HP2Q9xk7jNscFXd67oaJY+lZTn4R69aJ?=
 =?us-ascii?Q?Qlb1RQHaK5cn/lQEKPWJB/Xdl0TXvbGoE7XdmlJRpay2S+X6CzyMQNjCU5hb?=
 =?us-ascii?Q?93XTM9aDy+UNcECK/hGfx+T+zoZB9MwgijQmQuOFIFSY1ktDHA0EBypJE0fd?=
 =?us-ascii?Q?9d3Y3L6l1KpbfrwQpNb2TKbztGosUCrELzp/HDu6xVRlSCZ2zJxL5qiWwPGI?=
 =?us-ascii?Q?7AVtnCmid6UYXlKh7RV0gLxrD45nc8Zizv2hvaCkzC+neTUarNe2L/CaaH8O?=
 =?us-ascii?Q?vGYzjzF4Xid/ywk3J940cgjIfMq70hiRtof1UP+JV3+KES627bBpmtqNzo69?=
 =?us-ascii?Q?fpiQl6qE4fhJX22fQnhmlJf/YuHqY1/EvZNGEqaRbM1i3IrF6EnDX5G2c27y?=
 =?us-ascii?Q?y19qd1VucA36wSELU8x3hdMfO4fAF8t6VZjV0Ed4suJl2Aems5LruAkQo6UU?=
 =?us-ascii?Q?DirpXZnV7p9/UABgHpRvaLSiYr5VYEWAGvnpIEymn8ZO/JvfOapdOsbaH+/o?=
 =?us-ascii?Q?DjMnrhhBdLX65t5FtPHvHbOjML4uWEn6EAnjft4wRWHmCcEebv6J3csND/wb?=
 =?us-ascii?Q?pIpO5AH789VEVZvodAv1XnAQqBYwKS2HQ+sZGHxyHObEIRDtDUapNyEjsz/j?=
 =?us-ascii?Q?veUkL0/MUU9VMz1S5+0WOizVGsw4lykrRVefHK92w+wgvICAjP+wvAses/f1?=
 =?us-ascii?Q?Hz66JfZjcq3UYz/B/B9EW0bAEahInMIUwvuNSQtLMARHj0BvfsjSzsgPU/ey?=
 =?us-ascii?Q?cozVGTWtfHIGWvQj2It/XneeGwPceqleoVlv+u1+TazGjB3W2Y84YY2QuYO6?=
 =?us-ascii?Q?OOjNV7wwottDPuHSAJSghbLnHlouD4lF7KeCzK7FFSSkkEWaz+910/5/kNOy?=
 =?us-ascii?Q?HcZf1/eKR5CFCO2zu1oaGfm55ByqJip00GRm07lsXdTkGBWt98UAaDi64FpN?=
 =?us-ascii?Q?pch4SvXPiJMY1vukIY5PHdboSVep5YwRwEt7/2Uz?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1072c98d-7081-448e-6367-08dcd87da52e
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4461.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 07:35:33.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFwR347NExbSdRrm14GVh0J/oYr4WwSBOorjKLu6eyd+sibRnIq79lCfj8vjYA+YX7n4c6TS6gydXnwXHOASQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6865

Corrected typos in comment:
Asynchronize->Asynchronous,
encryped->encrypted,
decryped->decrypted,
fallabck->fallback.

Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
---
 drivers/crypto/ccree/cc_aead.c   | 4 ++--
 drivers/crypto/ccree/cc_cipher.c | 2 +-
 drivers/crypto/ccree/cc_hash.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 5ef39d682389..81533681f7fb 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2226,7 +2226,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 
 	memset(areq_ctx, 0, sizeof(*areq_ctx));
 
-	//plaintext is not encryped with rfc4543
+	//plaintext is not encrypted with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
 	/* No generated IV required */
@@ -2277,7 +2277,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 
 	memset(areq_ctx, 0, sizeof(*areq_ctx));
 
-	//plaintext is not decryped with rfc4543
+	//plaintext is not decrypted with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
 	/* No generated IV required */
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 3fb667a17bbb..d39c067672fd 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -179,7 +179,7 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 		}
 		max_key_buf_size <<= 1;
 
-		/* Alloc fallabck tfm or essiv when key size != 256 bit */
+		/* Alloc fallback tfm or essiv when key size != 256 bit */
 		ctx_p->fallback_tfm =
 			crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC);
 
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index f418162932fe..d0612bec4d58 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -1577,7 +1577,7 @@ struct cc_hash_template {
 
 /* hash descriptors */
 static struct cc_hash_template driver_hash[] = {
-	//Asynchronize hash template
+	//Asynchronous hash template
 	{
 		.name = "sha1",
 		.driver_name = "sha1-ccree",
-- 
2.34.1

