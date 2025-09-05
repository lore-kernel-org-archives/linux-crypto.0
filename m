Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D632C08C2;
	Fri,  5 Sep 2025 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757067136; cv=fail; b=IEWRXbejPrT5KYS3DWqk8nALnXdeLVDCuejMGdIOmivNIUoLNyiiRLbTtjGoRiGyadTBU+8CWsisKePCBbDbKb3qFBq2GiTJNUqyycGm2pd6SlK67273u6nbUpPepnEh8J+5cYTAK9SAgUhv+8bV7GeNc4c1dBExD8L+zMVQkHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757067136; c=relaxed/simple;
	bh=IKYT5mX8cIejcPrlDC6FFfWNDIg7iveK2UHK5nHIYAc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=K+6tH1WUpvKxmSPLKRAB1KLG6fPDWDGL9vc11mcyusKtIlWczFZT/XWxcJtAIkvAf5zlSfeAn6NrdEGZPczElusAQSZJ77Y/T1/EusnEf9bvvGJ7b/M+26Rx7niPjgAWkGVuFY7khVCGfTAjW699CNJwfX9mAy7UUpfFYcMOj/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=LSCJf015; arc=fail smtp.client-ip=52.101.66.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="LSCJf015"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEadx5Pu6J+WuQ5YdCXPU2ZBjF/L3WVpz1sKqqnql/ct+hMZgarExgSu8SBO/mWkbGFAp4MLZwQOovqd2tZF/vUdqhBmZ8hiBjFZBP9ZwUGMID4SlZc6NMyHD8T1GX8D61oz8YnQF/8EcbPjtPPbpL3E3GVB/8T+oXOP25h7+nxUvnwvDS3s83yJhhvkCD80WjL81jp1HZWTVvp4npgQKCtU4X+Q7IEsNUeiZYxfDQBiu0q3t28MSiLw6VqPr940Lo3kZnjgAR6FyA9ymnOx2EBbWO2Ynpnr5U6kzXdozU3xIPQPTGOifVO13jwB34gTooNwGgDxl2iAqDJQJDuR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbeed06TN+9ipmLaXBkrIev5q/1bvc215Ry8vERkvms=;
 b=NIwuuAEhA4jVBzxmBcqPfYCCX1rQltHps1sFqsXQx9JSHweozfiXFKs2HoB7rVbbFNcx3/CgrGrbSri1Psf/pPdbQh5j0iLOg78t4H/lNdM/UhtgSWN9e/Tro+wBweWYKqDDHmfnEBPtp3SWaK3sTmu2RZ0MHVuRzhHSotnHLDRUYzz6hpbeNzdGZbWwLpJNcEJx1KjCgWau1sK3rjd36EWdyOqyYekH9bO9HK6Q1OtdASgBJFU6CG6oDbKGmqfKmrdLnrrpJqRSxxGNC4twOn3+/tww2LQF/V95eHHDNPa7pK8sQVMYR5piw4y26DCu6wH5CwjtLwNiAPIQvolEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbeed06TN+9ipmLaXBkrIev5q/1bvc215Ry8vERkvms=;
 b=LSCJf015pKaltNKeiEQrjbr8aT6gb7zLQ3pGlAn3wG6+XwCQT/00RZe3sr6laqkqGGCXuh+J6TX0gKW4VEcDr3QNDfLxaA1izTuf81W4KnN0uaSDcMbqT6CowRGbSFitVuLYDBVmpRwsXVEuhhgBYGiuDer2qXna8ky8QYBORl21xquRdrqgT0+7FOiMJDe99OoCs9OhipVTCBq+Aq2KjVhxGIY5AOc13/My1iHZxa89Qg9w404t9QoKDKSgNTXf/+XUgXA3yq1riX45pxWSGWu299xERt6p12J5OtEPqZOlUsEVDxP8yamoIjxMSkL0TBrAzBh8uXe6jReHlAj++w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by PR3PR04MB7338.eurprd04.prod.outlook.com (2603:10a6:102:80::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 10:12:11 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%5]) with mapi id 15.20.9094.018; Fri, 5 Sep 2025
 10:12:11 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Varun Sethi <V.Sethi@nxp.com>,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam - double the entropy delay interval for retry
Date: Fri,  5 Sep 2025 15:41:48 +0530
Message-Id: <20250905101148.212722-1-gaurav.jain@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::12) To DB9PR04MB8409.eurprd04.prod.outlook.com
 (2603:10a6:10:244::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8409:EE_|PR3PR04MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: 989351b3-8e52-47ab-7a3d-08ddec64ad84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|19092799006|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bma7N3lNLaIRlnVp+NrN2KXFUN6Gs3eEGTr9dZn3IJNChAHac5yX8WMapc2M?=
 =?us-ascii?Q?38OasX/68FoWd3t1/KR61ICmjPqbXWSrNwzFgjAlULEM3SnsMNBbva2+N8LW?=
 =?us-ascii?Q?ChpfMQYgQMBNP01S08F+B9SgRl85cx+7Q33Lm/Gk3HRNm2skSOFt2NVgBUb5?=
 =?us-ascii?Q?QWu3a3EmNeTpqNPJ1MoDN+XtJa1Q04/qMbOL1J+cewEu9nwRWd9yNjKODXyT?=
 =?us-ascii?Q?QruYYihYvWK7pHDqZ0rh2+OkBmRmiHi4d3PVWCj+zTlOpDIh1N8H0ot3oL2r?=
 =?us-ascii?Q?ACKdtCkmsWQPHT/EpzaJBvwlkKsWo3j2SHzg648fXbvExTnd0zMCOM7+nWnB?=
 =?us-ascii?Q?RVyGm8slUQjDbASLvh1SXKD0ur7GztKlRbvr4suAqZy5sndD8ieWMf7QQ6RM?=
 =?us-ascii?Q?T3/XKC8ge7Thl4Bd001/ZBfHa+iyarsG/XYcgZX929FoUQ6t1NVcohBnB0On?=
 =?us-ascii?Q?MQ83j26QZaPvbZ6MF/K9JMcZ0O+YVfkeKc2yrZelctTgVcXnCWhmQKfsGWlD?=
 =?us-ascii?Q?yITNirYrbCPwPUSUquJLY0ze+X9/SHpEWIWV3ENCcbfzvZGb9qw0/AJSNIF5?=
 =?us-ascii?Q?j9qY+0spX0RFKcHo/xe7JYvMhAKldccOHSaiVIfrtMTLVUBB7zTISO824y7/?=
 =?us-ascii?Q?YYsgcCsPJJS3ePuIKEWFMzemtwN0yirKBqbEK55lz15ZJEyH7XuaFdNva5pA?=
 =?us-ascii?Q?vnyhhsxEQmuaPbNOfveqjv58Le2+P//0tbCDSEr0ZBDkLnMHYHnIWxecYqpb?=
 =?us-ascii?Q?ml5styuqyt9dRrpvGPAFWB68sqM7burDyGk6wXFxGzr4ijh6XsWRsXFrHC5W?=
 =?us-ascii?Q?C/wb+i+5kIqAGqmLCuXgKDRr9hx0av1ZZ58eF59+/dOZEMpjbS1d88J3V+Yz?=
 =?us-ascii?Q?Sb4S32MrWgthoBPGtVdVoqnf0ZgmPPMjQsTPhm7q43x8xLnKRJhYvBR1mwwX?=
 =?us-ascii?Q?4LKZY10R3u/twJts87GfjL6BWOvk3KDO4cOwbzZuNBIuYmk7fffVMuUMa5pY?=
 =?us-ascii?Q?pxHIQ5Yqku3TBRABUx9c85nxJAKRuYCH7nbgrFa5gprX+ob23e8R1oztHdtQ?=
 =?us-ascii?Q?0+ogpmL5Qaxlqz7MsBVgi8zksO0j1C/svShdR2jnRS1RNYO6mFxhR4WPLeKg?=
 =?us-ascii?Q?bI6yF2GGD+KE75UjP+ZMsVsRgWyAL6Z1ILwDtd45q+WOvVDdnNryvAnHUhwJ?=
 =?us-ascii?Q?oNI2CVa/AZxPGrcQywSXybf875LJCppvzizB7u65PtwIeHd8J7rPtiHGFP1z?=
 =?us-ascii?Q?CabLUlIIdbCu/xm5ZkY5qvz0+bv0eCQ14qkLJgeYWY4nP4WSAH3R+iaKAnZQ?=
 =?us-ascii?Q?tTIPuRdJ2qkBLnKKviW+8kugCvFvvAMwmADNpKVw+33WMeP0lqCvourlC4wR?=
 =?us-ascii?Q?cJU3FBVCuzNJR6UgErBzpueesTHleKXYbZRYCmgPDn0zRmttj7Xw2cPKAGQ6?=
 =?us-ascii?Q?ZL9+d3qv38DRDnnFCLwfjWIyN7cuH85WAnJmX8H37LOMq128fxTqgg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?coiOvqpnmOx4JsX1iMNOQOsD/3+lCEt1D93rVgTI6wbQHiae1kOr+8tP12Xt?=
 =?us-ascii?Q?IDiHdT2+aRhpry4EZORX6WnS/7jbMtplv/C2wK2wXf7DVdHiLsfzBTCfcdL3?=
 =?us-ascii?Q?j1489DTcGec1I8sH+n1l6+s/iie9bWxBXXyXS3moVzTOnXfwTZME+4hpw/mG?=
 =?us-ascii?Q?wk0Uvev0R1mAeRjAvGc6babNpImVax/gJAhkWpFbegLH3tM7P2BHG6jPLHev?=
 =?us-ascii?Q?fXWcnD7r/pm9syedXFX+lrib3yJMYC6L+/9bn/aDTpSCYNySemp9TxjW6BBM?=
 =?us-ascii?Q?M+svATM9YmpSxYF7bwEunLaZubGiQ24lk5RgCMhGviJfNDTELEUyeM5x0Aco?=
 =?us-ascii?Q?NBswbkrYqKNZ/fIkO0NVxSSci4EY7aUyeLuRQMEU8I4+OmWqSQaJMrL384nC?=
 =?us-ascii?Q?/GFGOhO8XrnUiSljIpCqRpqYUKDV1Oq4glpih4ThDoyD4qOw1nbjA/OG6SS4?=
 =?us-ascii?Q?9A0TF/iwam74NyVUzVfdT9lHe05VwxD0AZYHLdC9eW988yl43HTKsMl8Ifuq?=
 =?us-ascii?Q?n75DVDMCKx1qM/LHs3xFaBDKR/G6DAFV0ly46jpdE92RuY4pEIQyJdwYDoHf?=
 =?us-ascii?Q?f/8SiSodh+CXGWVsOF4KzzYMedYGXHsFznKC5Er6FymhO+gzQnV/s3AKoPnu?=
 =?us-ascii?Q?d6+XOoKb3xbpQJkYjlninAXQFW2Ddq8nmUNAT+Ajg+1rjBCrxErla97crOzt?=
 =?us-ascii?Q?dTHOYsMt/QozgVp2P2YY5JywParQmywYnIF0idXeLTgdGe1vA4ny7BrTCNJr?=
 =?us-ascii?Q?JK95GfjgNyvIRxC6dB7DJs8eBGYJlMn0l4EUUNiRA8NYV65X3A0+1M24GR9m?=
 =?us-ascii?Q?aFtObUZRb3KU2WpLcA0tmDHmmkczOKpax96uf69iPQsK5Nd9bTpiiYnKk8PM?=
 =?us-ascii?Q?AGmBCO6UODiGDfoJZelbapnyNGJwL64OoWQjrWjibb5ZFxIGw/0ML7ZyOlnW?=
 =?us-ascii?Q?vYBu9/amDfBa9CjNBASVj//oVyFF+fqX7njv1ZpHel1uqw0ZjzLhUxz7MLjn?=
 =?us-ascii?Q?+bFctgadh5TmluV9ExYvEaxJggFGOHeqU57JVRy2sBYUFSPloa+MBWWfbxNc?=
 =?us-ascii?Q?6mhYrinh2UnG8GfJPQ8SymqoKd11ZCBZIrJGUgJnjaOCuh+zth1gVo9D5QR6?=
 =?us-ascii?Q?0G4kfMPa1SriPKgM8Cg+hZGVvOrY1F7voigkkMiHiRFPhfuWoNV3rrTMBxKX?=
 =?us-ascii?Q?wVjKQYRxxfRnlxazA2Xi6pOJcsJHdwhm10IcCkt3tFBig/Dm1YoEhurwywaC?=
 =?us-ascii?Q?b1E10vSaeLeFvAdCdnWPhPvB6J/iVMYmKGW4OmN2PUcb2OtYzJZE9vHySOue?=
 =?us-ascii?Q?rF98MH29nX9ZjB5uq2/wiHVSXhKs1PP6PVsS1BLuCtqiYEowIr5PpKbbwi5R?=
 =?us-ascii?Q?YEW9Fw0TfkTpRwHk7Udnf/BWulknvLB5jwKfUC0mk8U7wWe/cUyhIooTdBaL?=
 =?us-ascii?Q?M9xJNfhtUc7wjyfzzyutuZnOMR/SAnzOHnWZSy9/cBgDhLFVBk8WlevR/Ga/?=
 =?us-ascii?Q?6GU0x55g2AQZryIVVIuXfN0nOWRhFhMRcn1fuP2lrMuSCLliR3Uz2nfiSXuN?=
 =?us-ascii?Q?2ZnZd6+7Wy8nndlUzbEo62cKuhZLhBT6o9eu3uKy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989351b3-8e52-47ab-7a3d-08ddec64ad84
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 10:12:11.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QF6q1B8Gw6LC4BN6m8nHpBYSUddl0wH/+tjin0/0D5trkkZHKcrs9wVoMEjbYkJWfDwhAySzBvQR7za5VLqLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7338

during entropy evaluation, if the generated samples fail
any statistical test, then, all of the bits will be discarded,
and a second set of samples will be generated and tested.

the entropy delay interval should be doubled before performing the
retry.

also, ctrlpriv->rng4_sh_init and inst_handles both reads RNG DRNG
status register, but only inst_handles is updated before every retry.
so only check inst_handles and removing ctrlpriv->rng4_sh_init

Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index a93be395c878..18a850cf0f97 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -703,12 +703,12 @@ static int caam_ctrl_rng_init(struct device *dev)
 			 */
 			if (needs_entropy_delay_adjustment())
 				ent_delay = 12000;
-			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
+			if (!inst_handles) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
 					 ent_delay);
 				kick_trng(dev, ent_delay);
-				ent_delay += 400;
+				ent_delay = ent_delay * 2;
 			}
 			/*
 			 * if instantiate_rng(...) fails, the loop will rerun
-- 
2.25.1

