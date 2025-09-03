Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013066.outbound.protection.outlook.com [52.101.127.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0722302CB8;
	Wed,  3 Sep 2025 13:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905958; cv=fail; b=OfqUiAWsq1MlgB1ouovoc5XB82KJ/0uhKghCRfhgq6lcbZZOlL75bmtLIfuxpk1WWOJye/1bYbulCgbqSMwBdAaIHN5zRNon/LTVtXVHr4CkgC4gDn9Cfcj8xHrZebUE6ir+hYWZlrMsscyZvWxqSs2vuqKG1nvck902UgDIwv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905958; c=relaxed/simple;
	bh=Ojekr0sF3Q6MGpzrwh7RzRFC5/GMol2hHN8g7J5BPHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A3k+oQPkOCa8qYTJv5xUdUN5mC3LXwkpwuuqML5FgQ/bTluOylBESyYIO172nEnM4jjsZL0Vc4cZpuOqhguOd/wn5f/H80uraY2Lk0uDd+XPIspNimyTIi4hpRWGeGN6gFXwQKkvm2C/DQiuMnbTuAsxn+FgoEwJnI96DBq5+f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Lt7VC3kb; arc=fail smtp.client-ip=52.101.127.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Lt7VC3kb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y03pIeq7tX25QIBpPcW2afdS8VeTL5A2XnN8898cKZdJlOcaNKiTXlLz2L6XJ3AhJ5WA04Urar7zuzWC6uUSFRQ6YHK2tXSC7JTuESeiTDUsDLoXfhce0c1OcM//bOrLzoFdN4NCgfvfe7YTf45honwpr8harTCAOYXNlnkvgV1AJC1CLmLUArhuPsH3IPdcMVFhxbLvMAJEVoJ4l8dPcYLJj451Ryur0EuD1hVTBoj22agPwsIqoked2T/9NpQZGWG4YyO5dP66rt9ebtpNMXd8Sfa5Jba9LmGEhfZftVQrxpYBNdqvXzv7kLqj3XDZAdkw4vxzsDcngHQ1ioEQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+tmr6CnSG39RALm0RatHW8lkGo071xkeQ2WgPvoeKk=;
 b=ABcKf1tUtA31kwtLFY6yZndR5z3YNHmy3QIf8tE9IWTIBrkoznUjBPHXVGtJUv2X9Md9XEDU3FXEks//mRAps4ZpTIBNYb3S6+wqQ1qICwav0S50IP6fbRFLw4E0E14sndPzsBrZcWWrkTpAcS1fShndoJ8GMgRPtH7+PcAUZ0JvbJ7fVI1eJED6Gs2COgAQyoMhJWbU0+rzIwdIKLoN1ihjZErVQG/Zu/UMQcujGqTZ6v2PBKfwxqlXEcgpKLhfdpf6o4/O1r3emKS96gACHVCCB1F2c8HS02raLo6+K/dJ86cHc96jn7bmABxeITunM+d8gEW0TaiUnxctSIhMrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+tmr6CnSG39RALm0RatHW8lkGo071xkeQ2WgPvoeKk=;
 b=Lt7VC3kbgt0ayYHq8t2wuk2Ft1vKXxBM43ADLHdA8QqlEwc0cvVzM7UeEnM5ggYcx8Gwmd6iuYsRbDcQq8mWTuk1GYSRq05yvG+cf58VAPkvYkQaow2HKZ7Z/sYRQWY0XXcbs0ohdLoJNviJksc/D4FpuXS85bTAVUphuGfaBymWybjS+D/OLfuUpGn+21/sn+6wIUS1YYhuxrvIK076exKtkDYcr05YkQ7f6cgQI3fXBt6MUkM4To6cqDAXLQQKn/XAEn7G4cIYq5TG9PpkYpGU6s5ifF3mlfix4exnHfW8rjZlhnnmqabzu2RJCNah7pzTmMcwFEo3pzoC0Np0VA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 OSQPR06MB7229.apcprd06.prod.outlook.com (2603:1096:604:2a0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 13:25:53 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 13:25:53 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE...),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 1/3] crypto: ccp - Use int type to store negative error codes
Date: Wed,  3 Sep 2025 21:25:35 +0800
Message-Id: <20250903132539.416439-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903132539.416439-1-rongqianfeng@vivo.com>
References: <20250903132539.416439-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4PR01CA0077.jpnprd01.prod.outlook.com
 (2603:1096:405:36c::6) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|OSQPR06MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: a396cf85-b97f-4296-7f5d-08ddeaed6847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EROwGI7IGL6w9K/SuegSmgvB8Ty435U0gCgcxfSs3n6P2nCA5pqf2M36JS4k?=
 =?us-ascii?Q?/oNPWmFK6qbuJuAZx42++NyvaWEydvE3BhTxyfoYAsmQBIrARqT0ZxpbnGw0?=
 =?us-ascii?Q?t3BB5YiUF6w5hZUX0LJ/tA/v05afCmZrI+v9z03mVwATY5f8McQwKpd0Iv0w?=
 =?us-ascii?Q?hlHQHKBO2oql2g6+D3SEO3+OH63Doiupuw1Kxnn7NLOVDgrELrWtq98z8m1R?=
 =?us-ascii?Q?cffUb8PX56APgvLhbzVsE78cqf34t8t3Sh0hqGbAHlYQrBYbud8HFKNdlnnu?=
 =?us-ascii?Q?rsCMwXDbbMwnnc9K8n1Z/ZENnXLYeaOHN8ebVb4v/j3SE1rxOfyER9ZdTX2d?=
 =?us-ascii?Q?PPLaWSK1d9Zrbn9w0L7NCEAT4mdKcg1dQnMshujEGf/58x7PiDCMGpQuyepo?=
 =?us-ascii?Q?d+mXNwpYsnWogsoWTsae8zBW4RGJiEBD+yYqfJePTOVYF1+jdNhokNmgq16g?=
 =?us-ascii?Q?13lBJpLM6Jx/x9bSAiEAf7Sfml2N1K2zSvlt5IUmXlwvQK4xSyHWmj57rR6c?=
 =?us-ascii?Q?wYPnm/k10yowrazayOn0eo3fKhHq4kghfJ1lX5lJ7mWj4t+h/bKQWH3IlhRT?=
 =?us-ascii?Q?68CDfiA0m31A8Z7dJ2jbaDustFoS29oWeqBU/qT+WAYASKemML3a1XFnMe90?=
 =?us-ascii?Q?o4jRQzObUUVOzP9WVV82JMAQbYX2OAh6Wz7+RHYjxNs6JMW8qCE2XA3FT3hX?=
 =?us-ascii?Q?CQYZM5xU8pUZhXrIU0gJLpvyiUq4CmAgRF48pgf+NvgnmYmNVmmyJ+gRge4U?=
 =?us-ascii?Q?+rEDVaM3/NvY77GoF3bJWOKhmZ27hAGz2FNWqmpdVZScaIHUJVqTM6CxBY0Y?=
 =?us-ascii?Q?G/dZ9UieEicwrbilMiWcwxis5hYpZud0xOmyAo+URmODufAr4p4yUQ1qSrZ7?=
 =?us-ascii?Q?rCrJGRIm3Ve9xHa5C1xNT+yhmcXEsyn8/l+DlPLxdLus6l5ukZ5CpiNE0qkL?=
 =?us-ascii?Q?pBmioGFrstiNmPabdGicbQYqwYOOjV+GpWH65OT9rKrraY2mZHlTQMFEoVlZ?=
 =?us-ascii?Q?ahprvxd09jNP2e2Orjm0129tZkekQsL/y9yuatNoy61EWZ3iO71sEqOLvbNL?=
 =?us-ascii?Q?hQvB9OmqxVKNvfnUhfWdCYqBo77RrOs0bCfULK7ICCcMNjM9qYzKxw7m7kz3?=
 =?us-ascii?Q?0Tk1aaiKr3IZU7c7d7/XS028As81axEK7doenrp8Onk9hN3/zbk7437BtsyQ?=
 =?us-ascii?Q?ODRpkcAPp1h8WucgvF2ySWmn2cWoSImeZ3BmgnhYEJPsmsz97ongUM8Q67dl?=
 =?us-ascii?Q?brj3nrlBrwfqX7IlgU7E0fXyRl4bZU7mDRdYOKMmBC+EhLnUojbHmL0K9fSo?=
 =?us-ascii?Q?ZT0hUlZS3gUOxWWHTDYg16yUTa83VJqFjVhWru1d0vy0C4D/ILhU1I4GToAB?=
 =?us-ascii?Q?5lNFqgtgysy+EPBkvpc95VVGTa8XVATvLAXTgi7A5Tu0gow3eEg92fxg1CfM?=
 =?us-ascii?Q?NPbFh9UcOb8Mt63w+gvZ1vgRi6QZtAjeQJaxqxJOts411DbcbvulMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GyERWJIRbeP6D+2Bjk0Vvvs/yRXxZEer+YbGSYklJczkDp8FVS9M9AjTg+u8?=
 =?us-ascii?Q?ZbwZ+2s4BrjCLn1oBEGufHqyTbUKfw6z4wYrZOL1ttvDq/5CxamR8fTC0Xwk?=
 =?us-ascii?Q?BZKSRl+QFFnNhaO0QpFcuNEOEpSmOyJQz6+/+tSH+37r07Fu70m8CpJmVwtA?=
 =?us-ascii?Q?pb1Djrbtv9LFpzPyyXZHEanBOdVV6teHqm/Mq1Nwu81SCh0zPZcnkCDrmOBD?=
 =?us-ascii?Q?9beL38XARr055zYfyvuIgGjgQ6UwyitXotfokgxLFWO62aB7BEJdu/T+K4cA?=
 =?us-ascii?Q?ZpCPAkySprHkFyEQ6iHon02R29HgzRbDanRHmj5/voxyS9jZuK3wbyRFPTo0?=
 =?us-ascii?Q?WwXpnG2gFkXhsu59ayqfnZ+ifubQA4t4NeiYeszw2ELZzfqTMdDlYIoDoGey?=
 =?us-ascii?Q?J2N6e33n3jEiTTu2+fy5RLlRwmyisv0beduHZi4bY8ZJHThE3kMjYNInH8xX?=
 =?us-ascii?Q?Ymxo5/JAnpTYxhqmX87CbI2yI6QBdXp0Xgki7LitcpxdvVAWIzpX2XiMV/oz?=
 =?us-ascii?Q?p3/vsV1RjK81wzCa4fGzin0VcI/aqtrhVKp4qBBsMJujSpFFVql5/U7Ve1sx?=
 =?us-ascii?Q?VDI46fGInzCtsejYy2TaC07FV3mrVFDNjVRzLQLs5hm8gZUJpo9JWrkf3gE7?=
 =?us-ascii?Q?Z4Aj6Nb2KJZhqi7WYcqES8jsM11o+vuogpC+KkUuGf/9kdWXsBj20UcutaPo?=
 =?us-ascii?Q?YOvR1hk4RRo2QP10f019i9xBeiS4wSvNBdgsMF/2omA9Mr5HEzMrnjMwEpAh?=
 =?us-ascii?Q?Lw3YSaBcvPZrnBhybaW8BV2IhAPV7/uK8s5WmZ6j1m341lqRtYv5D3Ma67aK?=
 =?us-ascii?Q?Ncz90i6zUJ4MdkPGuv2jDW1ENwZPaK/oZTSZh5QApGsn0tm85xlw4szY9Iao?=
 =?us-ascii?Q?1mu/tAhoSS6KSmziHVgIUzmLaoJFRQeSA5mVYab90o+pO16WBgWXKCrwUa/7?=
 =?us-ascii?Q?f0zuaNh8PWZ5WQISe0y1JomvNh7TdHOvK0P1EofmYhaPCIhpmQSG9Cw3rP1r?=
 =?us-ascii?Q?ur2SUSvYICnRuSOZWojbhpBkfMmrXnqqNeFDZHR4HEhLm0F84nKAYcoXs7Cy?=
 =?us-ascii?Q?23H9rriaeBXpdMBUAd66UqDqx3FfNa5KEWZx1C6lYLFr1RgatR+p7ElHHCo4?=
 =?us-ascii?Q?I0p+K5ntrD5bX01ZFMMiV6FYKeTrELAo20ZQtE82n+f44L1zMuMMx3BKX9ks?=
 =?us-ascii?Q?Dd8kPci0y/FyA0KP1gKW9xi6W/plTiVrXHd5LOx27Ge8c5i87iwqdzSAgRjJ?=
 =?us-ascii?Q?mZlIDO5T3cE46BAUXMSupHln5nwpkNqOn3jWZyggVnTi47mQva8q2np8JkHu?=
 =?us-ascii?Q?jmAWBEeFELCGscKNxt0bkpkQls3P4SDVJ40LygWbG+6o0DeQ/9AGOw6Txoii?=
 =?us-ascii?Q?t2gjdkYLRzm6LxrtmDtwgjFsZN4CEWLEIowZFpFyxAAyJ4ydZOBngP5MeAeZ?=
 =?us-ascii?Q?o5qOL3+qZEcD6FM9H7jM5rzd6wSjGvdGVtCEpCFXyRsPe8kGbhgu/3t/UIeZ?=
 =?us-ascii?Q?ocieMdXmh0rtJrFXUOjPRXuKTo86zODMUC6InubS5nz3pBr+YKPCyeuEMhoG?=
 =?us-ascii?Q?tjlq3ypAkcgMS+6t+MxhZl5ad7IutYLGEkY5OAiA?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a396cf85-b97f-4296-7f5d-08ddeaed6847
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 13:25:53.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTi0FVGXM2evEuWpIlBlDb3LrIVBYACpUUX470Sldai2oE16ibFeFjmronU3w+y9ZzTSvsDMkXG0+OmzQdOUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7229

Change the 'ret' variable in __sev_do_cmd_locked() from unsigned int to
int, as it needs to store negative error codes.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4f000dc2e639..6c116f6f9b79 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -848,9 +848,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	struct sev_device *sev;
 	unsigned int cmdbuff_hi, cmdbuff_lo;
 	unsigned int phys_lsb, phys_msb;
-	unsigned int reg, ret = 0;
+	unsigned int reg;
 	void *cmd_buf;
 	int buf_len;
+	int ret = 0;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
-- 
2.34.1

