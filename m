Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011013.outbound.protection.outlook.com [40.107.130.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121524A07C;
	Sun, 26 Apr 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777238758; cv=fail; b=HRIdcQoPSUtVZTruOUgw6zOVU2YZ2N3h1nSs7BBYdd94FzQ0fkXTZfT47mtv+oAXmc3Zf0WohAvN3jiICRZt2qDTyc5rwNnWZXdTng8zh7Ju/etFrbw9Itf21/uGdHPdzFUeG2OZPDoqyplvfzDy/tk0RdUQRGJ9/FUHcjio14g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777238758; c=relaxed/simple;
	bh=mCHFrvkjSEAxepZpfoEkftE/RemQmJ2crffukUcPYzg=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=iBuhBBh12du5xIQAOT8JH8NdpQJWCrqA50MhvujyzxlaEz9Qiwd/8jopQKh81r1MH6jSnipfLxiZlJwZy6DJMkkAq0D7xrtFSMf62wVC03CcWAggXXKoAqepXU+m2SLx9sxBeU/lG1K0p1rv9rRtQ5XzvmslzZ4qLJmet09d55E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=PdJJzdm4; arc=fail smtp.client-ip=40.107.130.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="PdJJzdm4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc3E3oVAv07zoybqhjTNFU4OiAUt3l6ly+JFDKo24vgM0Kk+v7GbWJb/7hyjY86z4PGIgvhE8DxDIhYzAOYTk8WWqxbS5IOvlm+Bpi7c//dAMh9hfWvsHXE1wLOvMiEFm8jiOmz8JDpp28I65EtfTfKmvHeiMm4o9iS6dX0kc2Gh/zPov5n8uH9bywLSObjPAPiQc6ycQ9dzarEGWQOeaVFuVr2kBApwAbouBVdogIwU7IUXhVDdgMs6uVb/0+nxYtxqwTu1qR3fgGHT3Zxczl7EaDEUDFZh0fgzWNxWWKF6dHDplyeulBLTCvnVeU0T+Zy1B6YUbAdzTgjroAoPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAhFQx3um2KKlnbqwuAitvdU3ChGxVCFvIyhB7ry86U=;
 b=JofYm959xDK8TumWEUKIUUBdIeCEoKFx61VEOZpYzHkXfI0QcThwjjUT55wE+bx113sQdI23HZKy2Ul9MUXejvcjT6Xbthkn2zxJI8DOBSVhEHzY5bgUOmpMUDbpwFEagJpiae3aX4t3GgmKhemDzP9cZGek7213NpHYT2uPzXXRrWiLr6diLBwrG1fYM/Ew4u32cLVME+EuSo+JPrD95WMs3WB9oc0URKShznhVeIjIcVcChaKkM1AEXCeuIwExW6pkHcSvSaEUpw/QT8OxNpzJLpF1r7B2ay71D5hUkCFuX0njobI3GRXDAN9iq3fFeAW6i70cngWJEVeDx8uaIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAhFQx3um2KKlnbqwuAitvdU3ChGxVCFvIyhB7ry86U=;
 b=PdJJzdm41dwb16oMqu2arGf5ERN2kvbmOMZTegJkxml7e7GUPZdCEt0zRyd6i4mZPy5bQqb4QzV0o65Q4xdBThE2HvJ3YxCP/yTRJ0jiCIQgRYwA4hTh61x/RaBSsg48DgLX/3rU2zPIKNCu7fgE2/XvENkZ6ygoydPKX+QdCeiUDDM7uDS1MBsjil9lR3vhia7tECBgqmxiGqu8BrLfba/zaSzc1rdPbQwxiGk3/feNHt2AiEPVW9mOPYGb/KV81C59ItKZ0bw5K3Kz3d5uLa2jgfb6vUJTZLfqQEJpNV+QyCB80NTCzSRcU5pMn662KeoWCY2f2IHNmrrTgsDWZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by PAXP189MB1973.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Sun, 26 Apr
 2026 21:25:53 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.20.9846.025; Sun, 26 Apr 2026
 21:25:53 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Sun, 26 Apr 2026 23:25:40 +0200
Subject: [PATCH v2] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260426-master-v2-1-dac9d1d99cfa@est.tech>
X-B4-Tracking: v=1; b=H4sIANOC7mkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMz3dzE4pLUIt3UpESLFDMLoFBikhJQcUFRalpmBdig6NjaWgC6zpJ
 zWAAAAA==
To: Tom Lendacky <thomas.lendacky@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Mario Limonciello <mario.limonciello@amd.com>, 
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>
Cc: Yunseong Kim <ysk@kzalloc.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yunseong Kim <yunseong.kim@est.tech>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777238745; l=1333;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=mCHFrvkjSEAxepZpfoEkftE/RemQmJ2crffukUcPYzg=;
 b=hmZVbM43nf50AXgn/VpIpo/MOaoCXphdFXnqjCWHb4XEhUq7VIltC8zQXD4j1Rp6qrBrOKjO7
 RAnQrPSxkNhAAKKT0SfUoDKaHW06p6kiEf2hvbSIgbiZo7VDz3IrDjN
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: LO2P265CA0289.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::13) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|PAXP189MB1973:EE_
X-MS-Office365-Filtering-Correlation-Id: 59301ba4-cafc-4458-5b50-08dea3da6530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	joHb1EHfICW07zoJUeR1amgjBVCH43WpTzNRdoXkFZdUx0jKn1KGJwoPE+qmefeM+HenuxAYhxwvnoisqNn08LBJctDXKYIx6KKJbSCvOO/wC7qDd8oH7taiTn/DYSPdY8J8/tjr9tYhQTNI2KJ4EnnrtxnQ8eRwn8+rFMkjxEu3e+TxjDHBuEjcpxpKflqUNgwXp2AoUOLcNIlnAALu8a4fxC+AGoJneyRZdpALfs/dpP4/wX43N3YTe2yDeAIOIquyl9mpWrscFZRAS0+9auhEcUlmn9WDlDhOCM8R6vz4TaU9M+pMM17wrwlr7nAij2xkIxTJFw2NK5+vvDoHcIwSOQZdW7kfyFGILImPb6u2AwkwWCvf/JDWm1Z7YM0Pjeu5oqZJb3aAxiS1k2Zy+zuv2xBGq47GmMDG9TVj71vC4N9F9e1lDMYtkaGNQWp2mZQ8D6AB7eeUP5hEWZGfaKS8+qejtGc5ZZpvRowhPPznc3iM+4wvR7NZoQj8sqqeYGSBtEjs+ikp6TPktbWik2E3TzdIYHoFyhSqu4mxWsYJl/uFlI+0GpnhIrjySLt+LAkUA9whGpb9+Jwh/X+TMzKCpKWYBuBOeVS0gWpPMC0p44cUwfBqUtvcN4SXMcX92/xQwKfTykWj3bb4yGAzzgB++GjjgSVsocfPWjxIul3+Ft3j9oLxV/MAmd6MxgKQvZ4uenNQArANrLQj+IT6jO1+tMFpqpwOkXAAuLwMQ18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnFQd1owYmVveFd3ajFUeURaaldwTjFQTU8wUms3Szg1UUp2eXRBM2NJY3U0?=
 =?utf-8?B?cjUraVJxOW9RWWRHWmNnblFRSGcwbVFoQlA5UzlCMmpBWS9NM1ovTFhaeE4w?=
 =?utf-8?B?VGpScUR1QUF2TkNoazU0OTZYeTNINnBLZmFwRTh6bk9ZUUxiKzJSNXoxQ1Ux?=
 =?utf-8?B?OWhveGJ3Vy9MOFQ1STBEZFpNckd3TnE1Q09Ud2QxRjZEOW0ycUkwSVhRY1Zp?=
 =?utf-8?B?NlVRK0RESjl6a0o3SzllTUM4T0QwOURvS0p2c1pQVi9sa2pRZU9Kb1Q2NXdo?=
 =?utf-8?B?MHdYbmk4ZC9YS0hmamNYQlJWbmtDeTdmYzY0YXM5UDBkNjVXT2FaOWM3NkVv?=
 =?utf-8?B?Tm1UcGJzc2k2cVZZYXNUY0FOVW1CWndPd0lmOGdqTDc2SG9tYlo2cHhMSlNp?=
 =?utf-8?B?dXJIVW1RR1crWkc3Y2o0MFAvT0Jha0FBdjR2VitGUFZvYVc0azI2VTE4cVBm?=
 =?utf-8?B?bWN6ejZpTWpYckxLYkNSRGV6bHM1QTcrbWpnTXBUV3pXZlgzWXRNOUlBUTRw?=
 =?utf-8?B?WGYveGs1K2V0Y3ZsZHNnYWROMTNHd1hBbmx5ZGl6M0NUOTliVjB1UHBxOHph?=
 =?utf-8?B?UG95REVOZHlyUGh5ZHBTMEtsQ3llNGVwR3E1c0FpR01vK0FqRjRoTU9zRXVK?=
 =?utf-8?B?ZVlkTjFGVHNpZnJJSnBiUlVDQjFQS2pTRzRNNk9HcStTQ2lQZEpqYnVTSVJy?=
 =?utf-8?B?anRuUVlmczk1Wmo0TCsxRzBjMThKbzB2blFkWGcvYitSU05qQkNuT29wWlRs?=
 =?utf-8?B?a0k5Qm93bFVSUVNuR0h4T1ZKQndTYjY3VEYrZU9xT0VXTHQ1ditHK1o2bnpH?=
 =?utf-8?B?d1hDWFVFVG9QbGZoRU9yQU9Td3A5cmdzUTJTeDBaMS9FaytJVGxTWFVPK3F3?=
 =?utf-8?B?RXpLTTJxT00vZGpFUWljekc5TUdJRVRJakQ4SzVRM29tUFhCTlBhbEhkNkVB?=
 =?utf-8?B?eHVVMWQrbksxd0taUW5FMm9OU2hEZGFvbDQ0NXpBQmg1UkZRUnlDRDVkYXpJ?=
 =?utf-8?B?b3hDWXBJdG5iV0NNamJsYjluRTQySHRLTVNyK2tSU1lDUzJtNlRXU0Y1RU5V?=
 =?utf-8?B?UkJtSFYxYXFxOU1nUGRMbk1nQkI2QlhNWFlQTmJaMEVBNmhLY1p5UzFTSnR1?=
 =?utf-8?B?bjh0OFRMNi9lSEhScVEzODB4cEd2emtTUlQvYVlwUUUvUHNmek0wNTdBYWZL?=
 =?utf-8?B?YkhhYzljMFZzTkVMZ0thekxWSkptRDFCRnlVQWlrQ3Awa0VZd3dmWnp4ZWh0?=
 =?utf-8?B?dmJFMXVLdU1BSVpKbFZBRFVVNFFYSk9RTC9IbkxERmcyS3lwRnVIMnpmc1pL?=
 =?utf-8?B?WlhqM3hJZWRlVS9VNUdNclJQNDkvZGRCS20wU1ZYZXdsS0w4TENqQkpPNktL?=
 =?utf-8?B?Zy8raTZCVCtxUkRLTzFoRTcrVXNkdmk1U0dxT2pCYU02bDhnVzdmU3hwM3c5?=
 =?utf-8?B?QS9XVGt1YzZZd2ZZLzR6UG9YeS9GYUlCRVdsVTQ2YTJUbGZyNCtSUXNXNXht?=
 =?utf-8?B?a2x3T1gyK2kxcW8zcit1YlJZZTJUK1RCMGk4QzExLzl5YzFCL2M3Q2R6NnUx?=
 =?utf-8?B?a3hnTkJ5S3ViU2UrVytqRndadkZocW50SHEvQysxS1FxU28va3M2aHNUcFBt?=
 =?utf-8?B?Yk8zY1ppdjdLVkNidVFNZjZuNkxhNy9vNXg2bEpRWmtyUmhZVlB1aFJRbndi?=
 =?utf-8?B?RVJjWGtFcU1wM3dFYTByK2xkdWpkSndWdjd2T280SnNZaGU5VXVhazV5bElN?=
 =?utf-8?B?Q2l5UjlKWklROWV6ZCtyN3NKRlZQa2pUSzJBeG5WTi9GSXV3RTBGZTltMmov?=
 =?utf-8?B?SFVmRnVJamp4WFlYRno0UHhBc3dRcHNkd2JXT3pzK2ZvK29PZmNiSzd5Mzl4?=
 =?utf-8?B?dENUN3JKdFVyMVFSWU0yUHRnUlB1bWMzRmVvRlhIS3pZSGZWYVBJeUlLdjRK?=
 =?utf-8?B?Ump5enN1R282WDkzK0VWNVExTWw5ZXBjV3hEcmJUcFJYUjNUK3pQYzNsUklZ?=
 =?utf-8?B?a3c1Y2R4TmxYemR5Y0piMmZnQkJGT1dDZ2N5NVowdzhZV0ljRmpkUlgybnhp?=
 =?utf-8?B?eUFITzZzUnhFU21FYVAvSlJ2cDNhMEJWK1FMN1krM2tiNTIyOUpkczRlZ2o5?=
 =?utf-8?B?eSt5UmZKNlhOVGZvVG5vU0diV1I1NHc1Z1RwSFA0aitHUWxxYWlnS0xqMnBQ?=
 =?utf-8?B?c2FKN0lQc1ZFUmNXRERMYURwYWoveXpkNGFqei9HbXJFOFhyR2xjaW1PcHJK?=
 =?utf-8?B?Y1ByVzFYaUNVL0FyTGJ6Z3RzYTJ1RWdKR0pEdFlTNEcybWdwY3FncktCbm0v?=
 =?utf-8?B?USszb0NyTTVFeU0wdVRqbGI4NW04SDlKa2RqbE9EUnhxNWdKaVFKbytmWDRK?=
 =?utf-8?Q?3zRLS1rnn9811L8nN0uI9QPLuffeAFKa2BdGuNV2vTPlp?=
X-MS-Exchange-AntiSpam-MessageData-1: rrr8hldNFn79Cg==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 59301ba4-cafc-4458-5b50-08dea3da6530
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2026 21:25:53.0172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IN9gRMqjEIpsydCBZTHf0FN7CuyHY8T28T2sK4chejDQBw6/KmmmDTV2t1fZtxrWJ97Yi3BgGMcEPI1YnPy6gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP189MB1973

psp_get_capability() is declared as returning an 'unsigned int'. However,
it returns -ENODEV on failure when it cannot access the device registers
(i.e., when ioread32 returns 0xffffffff).

Since -ENODEV is a negative value, returning it from a function declared as
'unsigned int' results in an implicit cast to a large positive integer.
This prevents the caller psp_dev_init() from correctly detecting the
error condition, leading to improper error handling.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
Changes in v2:
- Address feedback from Tom Lendacky.
---
 drivers/crypto/ccp/psp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 5c7f7e02a7d8..664cd51bbf0d 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -141,7 +141,7 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static unsigned int psp_get_capability(struct psp_device *psp)
+static int psp_get_capability(struct psp_device *psp)
 {
 	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
 

---
base-commit: 7080e32d3f09d8688c4a87d81bdcc71f7f606b16
change-id: 20260426-master-eba8d68042ab

Best regards,
-- 
Yunseong Kim <yunseong.kim@est.tech>

