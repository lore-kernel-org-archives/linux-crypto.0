Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636BF33262F;
	Thu,  9 Jul 2026 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783562608; cv=fail; b=TG/QiUq/f+PhSnBF79+B0PkeeJfzrdX/AxgXux/uBLnusQHg7/i8jfeCM8Qsh8IeXpuwVeOYwetOTbKzZJxGRNq3wamjoWQdU6oH3g9O1TxK8LnDJ5hYOy5TJ8pGY9IXUGqRPKyiocE48hUwKyGv6gSMD80lc/3WkU/K0PZkKdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783562608; c=relaxed/simple;
	bh=QLNQD7JlF/5Kttk0mqCH4wyhODOhFOVYVLUlNzOmvPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QRF9wi356M18Q/8kvmdIxRlj13BGPigwLBKz+X4CyVpgfB47DLLym8HUxTmy9gmnbnY3a500r6YOxuMQSoQsKK+Sa98rmeg1ZyGw+bYwr+rpf+FOOvTtac0CNVZZUImvmAh9APXj+c+6PjZ/gyHAbXvWtSRJisXpVQWl1XdDVeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SGCpi1bP; arc=fail smtp.client-ip=52.101.61.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SGCpi1bP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pt2UFFu5H9qlqyKsl/WwZqJhK6GLtmYaXUwhMjp3YMw4pVi4NCUv1GDtTYdOW8izjF45bWsWOrG0TlfOLNZq/IZnV6Xb/S3oanRbxdLgLMt2juVQ64OH0zWkHiIHgyeGO6vjZ2TtSaZh6/yyyQu+lN3Zm+4dERGwGmJ5NTQZVoTMF6eku0CdpsRr9Urs8hbHUO9Rk8iHG8XRBJCDO4cVeYt53+GEBEyago6BWuC+lSHmD5jsH+gthe4WabkYnRZjh6l7o+MoyQ5PHN8Gko0KR3Uo7zCa5wYzOyL9eiJNxJke5AiBYEy4DKu+1UCr2TWcvYtoHRIxIt9c7HF+FGjMdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9VimBD8RzQmLSBdfYrtUSglHv27XksaR/eKs0UfPi0=;
 b=NWQ31iYkemvUPXcn4FaSU8IVGFdkGUKMQ8asU5QuPLVITLXA4WZ/t5bGfzPhTcbyqse4JZnFi4mPrHAuTIXJcuvVLWLn7P/RC+nrCQlDoWbpGuCDlPKdEp0bmVBTOiEvceHG6IPHCvsk6z3+lCrXhJLO3e5KS2xoEknfMGEuwlmMA7q97rP96dg40e/PxqMwlGSq7gCbP7q9YT2aFzuPegwcDVaOSJESrOQE/suXSp7nKVsIwnWdDjYarP9HZ+EcoDnJ33CaUJpfRDznO64sOuS9sLKjaWAvNemlyX81cUnskDdZuyfqFtVm3i0bymHUCkj8emG6T7lnV3tE1wgdyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9VimBD8RzQmLSBdfYrtUSglHv27XksaR/eKs0UfPi0=;
 b=SGCpi1bPzS1FYCJ5wAUXiYMMEkOXBoXKEaC3JgK79lH97ojBk58V1Fmy3z9Vh5O+0r/3E2IrOSzWDYuuTY9uQi5+UV6PXxuaWEx6IDi1mwAq7ssokrr3Nok/4u604BzFqVQDgn7g9H8YNOtSKp7/9nD1lBaRNzPwUO/8ViryE0g/GklX0xkSzMZDr/E61teGegxUY57SgjZ9UJSrSfctOP/l9mifWCjWuvLmZxjM3imstcNHsN68f+WnTds+ZZJjpvQLaSfwp7xZirhfqW52s35WQQyk7pvoIHRIA6yYWvQDd3KzlnGIIzfrfID1BFWuKN+IIBRP5e7UGtTl3V+8uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by DS4PR12MB9818.namprd12.prod.outlook.com (2603:10b6:8:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 02:03:25 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 02:03:25 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>
Subject: [PATCH 3/5] crypto: ccp: Treat bitmap size as allocation failure
Date: Wed,  8 Jul 2026 22:03:09 -0400
Message-ID: <20260709020312.133977-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260709020312.133977-1-ynorov@nvidia.com>
References: <20260709020312.133977-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::25) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|DS4PR12MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 6524600a-08e7-4b29-61aa-08dedd5e42ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	eYEaBXbl1P/sv2OCS/PH88Q9NY6f/2w0sLVnrpREk9uaJr0WaFVxa+i3/onCgV6O3yQXaSwcIxoBD9vv5XnOmWHx4A9fR7CAxyfgf3NOsrxsKmIMBaYVJqCP1vc1NHWBuJ0qrSG4Y5Li4bTm6Re5pxH1dcEebLP7Nh/dc4toLcAgXVeXKgRY0pdrIyDAdf+oBne9DACKjQDeZwIGTKL7SJ0nHUw8tHg5Iber1zAEPpzpE61ixY3HuCeyHFUH2HIh7fK0R5S7ePptq6fWHtGCdqQpYJqg7iP6BuySrxzaMjmmqhe0Hze6VLiWun9T5hhtO/1qzaE1x77SwftrL/ZEW91oWgr2nREKlqCw66g/oPjcIBi3hcYAVb1hM1ilbroWefeq4qGIgaTZhnyIJurVeBQrldpSNJaVNhljnmAjs9j8K3aVNUhKSIlqAPG5o01ADMt4SrhSkwv5pFbzZc/fWIum3+o/YkIsUoV61egyWRqLtwVhYXI3a4f5XjZwjWSwVKmLSQdJ54OPlGPlEJQ5xxAwNQ56zl8e+10mAZV2itXrKRe/NIcUzuVHF2yRSpBGBUBrFmfsj+z6Klx8hqx+L9ehMfb6s0XUTEHUUuH//5eTVnQojbj1GUOMbQZbLZtctnfnzcYceZTJ0rDKfVqd/t584mivdA+toRtHEt8pzW0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FHDMZaeNWFM+A1ZfnyJsuvetD+RvruKlFDaEwxaYJqlDHejQubctrKjR6nTM?=
 =?us-ascii?Q?SYCOKC+aAiklFkhmbZQ90ZKM2Ba02w23ah4RUPW5kT3VFUu9BJ2lqIhhwAgN?=
 =?us-ascii?Q?F9QYhwukP/1r4pyP9Al8siRS6tsYEDScV19SE45GbbmZQt0yMnacvLRxc/K/?=
 =?us-ascii?Q?g7AJCGWqFXacUEsMlNcQDBhDhPE+0Hgh7EqISS6ymTY1Ad/j/yl2df7o2IU7?=
 =?us-ascii?Q?teVUmdBfgoqmJ+sdAnlPDige6usfauw4VeRROwI2fcTv78H5v4icw20bqBnx?=
 =?us-ascii?Q?x8SxBygrhlhJ5Hp/62nJJL9h37l/8hfaVKMZKmHyvhWQaqDMeMug/PVrUOee?=
 =?us-ascii?Q?KKiku50b5oSv3zxJu9u5zMWO1di4RKrvxhynNGJlcArXh27lBG/g7Akay3s1?=
 =?us-ascii?Q?W1e359kuYtcEBXxkgp9Qakj4Q1aMj/3i81YpWbWLgvYIs4Y4ZWpsHtCUaLgA?=
 =?us-ascii?Q?KbFCm4v70dYkwUveLx5djvuxe2ZXL9L5VXnUQLiAfuyLVF6BHYfomhhiLqKJ?=
 =?us-ascii?Q?OTuhyPEtfakKVTsMj7yDcRXMU7GLiAundC/2RfbyXostD9WFFO1CxyoHcSgg?=
 =?us-ascii?Q?K0cC/naycVxsnkfUr5HsLVj9aAP8dD1wkKw1Aeb/mjBdqCEXScwyK0Sga/Q2?=
 =?us-ascii?Q?bX+DU6vMurDyFyTzJ4UmOzZYkt+4EKeefqBaPyQhy7QannwsQLnZVCkdaJTl?=
 =?us-ascii?Q?kgbChaKag0HS1Y8geeICuIf4ywhKelJ/pf73QF6cLHBrd6rxMxBg6x2zpI2I?=
 =?us-ascii?Q?R/rST6Llnk0la9Gf+9Ijmpew/jBTIv1GcrbmbeL5zbPTstyfX2Cit+dmx5oC?=
 =?us-ascii?Q?6g0CYvhQR+gl7wrYxk4j4hRS4r8EhDUH/5x6Erq4EeLgjUel9cISyyfePgXC?=
 =?us-ascii?Q?QkraCJlES7TUVEidN7dnyqkMQ1IDIjO+qv9iUPK0uZgPLb9RmtpDx+oQhbAC?=
 =?us-ascii?Q?LFjAMaqXdXaOOX2yeWlqGeN7klG+Q8NJ8+tpg1x2zqLjFaxNPTLQ2XXWWy6T?=
 =?us-ascii?Q?J2aHzWYvdruL169C8iU9yF88auhifm8vvcMRO620Jh7Fb+vj+bZu9G0qx52A?=
 =?us-ascii?Q?TRykYPrIxQ+io4lyNzVClbB6SBlyta6lk4UzWYCllX+Z8nYqd8VjR7HLd+IR?=
 =?us-ascii?Q?MKL/vR0WoEDLbX/8X22M8v8O+16LJYXS9YTBAPWBQaBqNKdWO0v+ispLE2FL?=
 =?us-ascii?Q?WgvtVQvGUH3HIJcifIJBZtZhzINaPs+ImErZqB8uiVH9jjv0loLk456otz5u?=
 =?us-ascii?Q?8CmylsPp7JnQ9s4FJ1XFHyakOlydnbBQub+e/F+kHXQ4NQRGDwuEhb5QOqSQ?=
 =?us-ascii?Q?06oarsIf7wZBkmQVOHMrbKA5r5UZ72OqwgcjVaxmJvYZf3euH9Ar2ZT+S0id?=
 =?us-ascii?Q?3HOPeLraM1LTAV5p4qpFfzNTIOc+Q1IEpeCl2X6doBRDaN0CsXoSaWC8F0Xt?=
 =?us-ascii?Q?TQzn/e1DRxLziweoRGE95lsghL6fIdjrdDNuWKlOYvWVv8nrdP8oXmL2bMNM?=
 =?us-ascii?Q?z6qkrFeiDzp3pyZatCmHQWhvjhPOmJucC2hfuToVKDFecZolM2o9h5p3SEgH?=
 =?us-ascii?Q?0qfNf7QUE3QwFEn3I2dVfzPdFKX+zI6lTQPu339IVxkZ54xrvPO1f2MznojW?=
 =?us-ascii?Q?Ouki8KQAkPG+b82/wxSFvNNPZO5GWL56BmlrnEqja2T8/PDnVb5qi3tuJtTS?=
 =?us-ascii?Q?LI0/irkwtxX0e7q4YfRg/cn9Zc13Kr/u0/sKguDb8UlDgi1k0WGI1vMBUtU6?=
 =?us-ascii?Q?QyZQW8umDg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6524600a-08e7-4b29-61aa-08dedd5e42ad
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 02:03:24.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpO+WBIIfhQRtie667/FUuKzQHFdem/UryhsI+hGE3RNTWWZXBdf2ph0RCly6RlGqd4+uI1Inn/J0rVR7XFliQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9818

bitmap_find_next_zero_area() uses an out-of-range return value to
indicate failure. Accept only offsets strictly below the bitmap size so
the callers do not depend on the exact failure sentinel.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 2 +-
 drivers/crypto/ccp/ccp-dev-v5.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index fe69053b2394..60a133e23e5f 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -28,7 +28,7 @@ static u32 ccp_alloc_ksb(struct ccp_cmd_queue *cmd_q, unsigned int count)
 							ccp->sb_count,
 							ccp->sb_start,
 							count, 0);
-		if (start <= ccp->sb_count) {
+		if (start < ccp->sb_count) {
 			bitmap_set(ccp->sb, start, count);
 
 			mutex_unlock(&ccp->sb_mutex);
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7b73332d6aa1..e18ddb881bf5 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -25,6 +25,7 @@
 static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
 {
 	struct ccp_device *ccp;
+	unsigned int nbits = MAX_LSB_CNT * LSB_SIZE;
 	int start;
 
 	/* First look at the map for the queue */
@@ -43,11 +44,10 @@ static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
 	for (;;) {
 		mutex_lock(&ccp->sb_mutex);
 
-		start = (u32)bitmap_find_next_zero_area(ccp->lsbmap,
-							MAX_LSB_CNT * LSB_SIZE,
+		start = (u32)bitmap_find_next_zero_area(ccp->lsbmap, nbits,
 							0,
 							count, 0);
-		if (start <= MAX_LSB_CNT * LSB_SIZE) {
+		if (start < nbits) {
 			bitmap_set(ccp->lsbmap, start, count);
 
 			mutex_unlock(&ccp->sb_mutex);
-- 
2.53.0

