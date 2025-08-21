Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012053.outbound.protection.outlook.com [52.101.126.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5440C320CA2;
	Thu, 21 Aug 2025 13:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782814; cv=fail; b=ueXFAN+p0zW0F63rJvsxJbj/oQfz6V2IFSVwwIUmO+1UXPKiiMUG6Wcgo5csW/pmBkt/SBsedqzRXjstbASPwgNmxtRCG5na6O+MhL4NliKSJYTXIur5B/NIO6896bZShbWgP3zCmppLBnZviPX1RlTk8Ice98HMmiKHRUNeU48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782814; c=relaxed/simple;
	bh=5IqkLNfeMMLIFDLy7JlXfhrynda9SIfNlsQnvALMm+M=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=HWh+dflpl+Jr3I+leRnYXWoW+tUbmmze9NJ49PoX5MpeTmKitNE7oXdeeLKOJg3VAj7hr5Wxh9VcS8aNPTSeJaT2SUrZR+zecuSxujdXqRRr8LcCzE8Nk5z7TbfMrzMARRrTHGlrbRLt0wbXICJlzxS6rqtMUN9+CloE9bYyFvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=BQRcmtOa; arc=fail smtp.client-ip=52.101.126.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="BQRcmtOa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VHFL5DZNPeZ6vBMMxX8WkAJShElnRpMoKLAhxvwxJs/8RPE6Iv3WQ7UELIBkPDNevl4+WeTbrX1htLyvlYzI64LBea26wpd6hNkR4/gP+iulsRun99oOznVYLKanj76n8GDSnnXC4aoyROqC+TXswoKchzdEDS5bru+ZHqaxiM3dWOeAvJnytDV1SuZ4+BVCbYVt8ycfw8dUT+/2ntaT2ZfSrzUn2OJWhOjW5JyySk1oOcTcj2JarQP9fvYWD1PqppSRFRGUCBKP1inL8g59OsPUBQ2z7oR6Ygdb6w6C9jMjlhFr1nUqIQULFrJQ4HWvrp4LoNze+x0T+0z38WiKBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgL/6I7H6ebVPq0u3j7X8gbBgwlK7AMgKtpf0S6yDOM=;
 b=UkJ7TVWtZmKCmxQ6LijT6p8EuzNVIx6cybCLNe8TzqthnARj5WVVjzZ7UQ6lTDwyqvJBkvIVIV4M1/yD1jrRdsJIa48ix0ZZvyhR/6L0YcPv+aemEiS9xcfybRWKSWkdsvC7Q4C7sJBXioqa8+BPIfw8KQ/BphL3t43pwcRyj6xfombO2y/iBu3Ix8GZ47fkkmJ7t9ERDojLzBZFYUyfjRfr4MhFwhsK7DIyNfIvmBG/uRvFSQjoiLbvwUhtKXLm679aGgyjs0sCWO+6gQ49Nh/fK3a3EkC9fPSb7ZIcePDfxuSrRr4D6qIt0bEjaypdMYx0b/F7y32AUJQLRrBuEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgL/6I7H6ebVPq0u3j7X8gbBgwlK7AMgKtpf0S6yDOM=;
 b=BQRcmtOaDjB7qxi9xDxMrw3s7ev8eULWzLr+AptD+ImtpbXzqxp8othpp3o0ExfeNQPdiHQD+VGa7WwPBIEHMfte2IDFG+TZ53ZVaplMslcASIWwuCPGmxovphy+hCWijztLJAJUaL6qrX8Dfuj7I/smA4QNVJsekQMB9gxEz3ZuaJFRnJUz/e9EMz8ue97aDqhEe0byVDdO7RNA9HkiRRMVZrwKBhSkckXN/m13EnKwItUPYM8ERX0XwO4PfSg714UCMKCq0xkHzwEhJemke0X3QJbxkY2xOW4+Hee0ib9VNZhbMvElqab4b47ME7fzTdU1n3hzIe1gGxxujHGbvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6636.apcprd06.prod.outlook.com (2603:1096:101:175::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.13; Thu, 21 Aug 2025 13:26:49 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 13:26:49 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Thu, 21 Aug 2025 21:26:31 +0800
Message-Id: <20250821132634.654864-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6636:EE_
X-MS-Office365-Filtering-Correlation-Id: 76017789-b977-4cb6-ae87-08dde0b6622e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|1800799024|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RsUPPgWVpZWwpbiBsL9JtSj+UAQUs8vDDM3l9Vk6/WgGNI5nMOS4UQM85ynR?=
 =?us-ascii?Q?8qYNqzlwBzGSBZIve2WWTOOX+FEDX9rrZ4eERDMcsTqnPQiskibNG8/248fx?=
 =?us-ascii?Q?tn5/64HC93xjy6f5cY7A4bloaql7ms+pfnbnUK8IBibxgvKovJpP5ImbOunK?=
 =?us-ascii?Q?hkcQe3zNKEjpBv1h3dvquc6wuGSxMEHOrbbWj1BEpWAt2TEHErU7EmpQP2/K?=
 =?us-ascii?Q?BKxc3gqOsL7pFaxLqCitTF/7l4AqEHDOt0paNifh45DcV/OACd+xJ46j5nls?=
 =?us-ascii?Q?ssp8G/Z4ujG+SWj+qvyJMxDTKqU43kOklB23Uyr9QObWORMloKRQsnPtZ1dc?=
 =?us-ascii?Q?3NkeLuJLKrEhDqOzSyg/94a2dwencJ+/EApJ4f8NICarx05RI6R0MQaluRfv?=
 =?us-ascii?Q?kcpx2c9HgaSxccRSt8YMgZEh9mr34eTj4OT4PGWwU8JX1LCNKtp1ME8PiOBi?=
 =?us-ascii?Q?UpaMpaJQ6shxqKGWc80aMsVOUagGUK3Kdx3UGUtAAK8nLnWKbjnXPkNgDF9A?=
 =?us-ascii?Q?iN9ehaZXgB40uXRnJQaBPnQqO5AfFluf/6UZyG45LR1JLTNzQdOiUoB+0rj7?=
 =?us-ascii?Q?T8NvWylriDkjkPLj/6LECdZfW2chs6m0skatiPT6zj+xtb13pRh+WaFBHyny?=
 =?us-ascii?Q?vREyDJyE4gMGg7VOK3etyjNBUrsY7TnHudaxRsvAftNdVxcGMQAOcbxU8zH6?=
 =?us-ascii?Q?6lbqZoIXNkYj3jsboAWGJCYO8VjJP7gfbL8ywO6U2+lgmvhSiyjtoPx79KST?=
 =?us-ascii?Q?A08aZW+i0affhrrcvAmrEo8jOP0pNzW9+lkE9+Vpoj0VfEIZoympFbv4FaLs?=
 =?us-ascii?Q?Agpm0XM/4gzUKTX/SDEtEho6smvgDU9ENC+18YASLtc3MOlcdvgBIb6gux51?=
 =?us-ascii?Q?6k+gG2Wm25JgV4XS/G7v1J5otaI65yaIvapn/Hrv6nRnRW2W777Q06rwWDc3?=
 =?us-ascii?Q?g2DxE+DHj30xU4dt4etqkiouovzbhPK5XqcVfIIq6vzZ9j+iv1eyK+FVqWEo?=
 =?us-ascii?Q?sTd6aL+IQuG18qjLxablh0nB0Ww0lF8bFc5t8UiTdi3Sqqy/34ypP3Rpm+Vj?=
 =?us-ascii?Q?F5k8JF36L8sYzToHVKC6KQkcnRyzNg13O16T6CAptJa7tSM3cmkCFIF40a9W?=
 =?us-ascii?Q?APo3tRZlj5plZIuftszG+M0sFuhtc91zLYkrSkh3dwzod8k8OHkizqPukp5G?=
 =?us-ascii?Q?CRNb6Y4VTSOCzIcWV9uZ4K1/2BSn/ztjK/nxdTJEWtiYlj+BmSkjuDQBeVXJ?=
 =?us-ascii?Q?cTluMndE9gQ3Y8yq5/5RYoEzlLByHMQ7odE+tkmzs0Jm7F1pKSkveUxKoNGC?=
 =?us-ascii?Q?tzzl5hycPjNc5SAN0YlHW3oVX+DGi6qD2kyIuwsmKOiYX2zg21iKjgLh5qNK?=
 =?us-ascii?Q?IgVoFteMo72d2SEfz+9tUBs0zve4evRA+NHQ9OmARArp1Zmisx8hdemC7fzQ?=
 =?us-ascii?Q?sm016JdMTwGNok2ma8hP1/Fe1NIxvXKabEQme+dtf6jTZDzzJOl3GeBt+nrK?=
 =?us-ascii?Q?sEuSF0FAJFCiR9JiguO3OGY9Ib/mCxcpxkqx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(1800799024)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WwmgzdktOEdfIxAwTQAawhjOL1lR0tsrctqfnV/BgMDZQzPdc2zBH5cJosfb?=
 =?us-ascii?Q?N6xf3Xk1xmKcQF15gjvcdxoGq1kcvUnOOGroV22SZXBRUS2vTXn0gGBc0LZN?=
 =?us-ascii?Q?VeeVitmCm0lC2RImRMFFRSWqqkSMwqYJpYEnb0//DDMlfdh5+MkozizUPgpo?=
 =?us-ascii?Q?gYTTXy6s2Vj3K8p7dxbrtNprs4+xHGqO4Awd0k8m6hOb2Jp0FeUJ9Sg5nK12?=
 =?us-ascii?Q?+3upUPDTKeBqMdHj8AN8oc80O0FQyld0f00HY/vY2iQtXNH92bXggju1jdFs?=
 =?us-ascii?Q?GXfHsfTiFiWrbKhIHhhJzA7eOBLfNk2NnPc3ovezAmoiuuJml/C+hfwMQhKd?=
 =?us-ascii?Q?HYTvT9A8NmRnJAABoZoelLFLMVZoUPbz0iUpllcd6j2G+Ne9LfGwe0gJMGv4?=
 =?us-ascii?Q?zL2/bzrF5KAmDzCmYY54j5BWt1EPPVvBNdT+9HtNkt7hROLWmibfYlh90Jos?=
 =?us-ascii?Q?f+6Njp76EkDuDuY5hMFPIkqBlQlC/RLrB5Z/euQR6KV5/KOxJWtoRhN+aYqp?=
 =?us-ascii?Q?nip4MBkWN1jyULQGVXUAN08C22g2rRrzexUO9WPOzje7XWh07aaeH7p26e3R?=
 =?us-ascii?Q?sAlzQn7lTTkgdrGzLupx/GDgKce3nrKjisBmIi9mNb36WjvuW3PbzQtgNbeL?=
 =?us-ascii?Q?qQHVnIwrcmAI27G+g8ZYAoWzKuJq1ZrkQWvnXk7Gi3zg4T78SOvIerQepu7A?=
 =?us-ascii?Q?V9yrYOB0AlPfI5g0FlSYLfAteF0Gj7rCrPTSgelA1hIsLUbJVH8MHqx8RXW7?=
 =?us-ascii?Q?0bYuyNV2nVwdmRWUcEyQj3c5Lmx4BBeJdaxrMiB5ADZdaEQrw5sALrLv+Ox8?=
 =?us-ascii?Q?yt7YhBhtbi2MU/rZLjlFdTlig7krHAQz2pDZ3HR18BaYwrfi/VnuItZEfqYU?=
 =?us-ascii?Q?u6GRz16U7agyW3NEOOgDq0Ql3f9qB0oI7yUxSE6FTqOLFbDbjwHG9XSt31UO?=
 =?us-ascii?Q?q13Gt5Cb00P84bIaKYjngVSa4IlA+mEZ7CYNu40H706zLy3W+l/ovkk8GNT0?=
 =?us-ascii?Q?lFZRogsZ+r6q3XGTZFxiTcXpaMNZB1b72oEtZj/zbWZc44I+qs1F93Wac6kV?=
 =?us-ascii?Q?HfjzwnryLlLPH8trdLzGhSdE/67E69NvbYY6QS01l5wAaM5vD1qel88oREwa?=
 =?us-ascii?Q?8b5VUHNi/5Q64zPqsuIA64xWJJUElWr6GJ3Qc5DC7w4y99Xg0gcEI3KJ3b1e?=
 =?us-ascii?Q?soWXOP220/Z+dOfvAHbICF9p9fhhVkSyOebnmTZo6JlhejzqlB2INEqL+fwW?=
 =?us-ascii?Q?z8OsQS29FX2I0U9ncDunP4JMleVwXpSdadc5yDwbiIW1Sp2CcwSY4iJK8p+y?=
 =?us-ascii?Q?cs3GbbbpipxmmXn8RHKnuiQH2xgcCSkZCvwWlmhjy6+VhZmX0XoQvqhZljR0?=
 =?us-ascii?Q?f7nR/uSXK9baaiGZcxecizXvVZtJSsjlB5ZbEKLRSI/x+xYUq9FEj1/glFGD?=
 =?us-ascii?Q?gH5dbWK7yLDcTMA2qi2J5DiuxPxp/Q47fdWqFQtyYsfjB5lRQ9DiMPzR0VeT?=
 =?us-ascii?Q?tflvAQG8GPeguqGrELAqP9ySn7JVY8i4PyDEOUTtZVHuTxmny6KdsmL+ypGC?=
 =?us-ascii?Q?aJ0LGjoWGWEbER8yc3tXEampwDnT6oJ3ng9zT/aR?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76017789-b977-4cb6-ae87-08dde0b6622e
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 13:26:49.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: va/21gr2zBTROrl37F16AyGIY0q9VG0mVVN1jNXuhepRlv1MJ97r0aUQmlbehFqVRkmnX/WhECRHaPnHVYsjwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6636

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.  Similarly, use size_add() instead of explicit addition
for 'uobj_chunk_num + sobj_chunk_num'.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
v2: Changed explicit addition 'uobj_chunk_num + sobj_chunk_num' to use
    array_size().
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 21d652a1c8ef..18c3e4416dc5 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1900,7 +1900,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.34.1

