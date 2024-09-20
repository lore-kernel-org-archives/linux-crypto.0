Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2076.outbound.protection.outlook.com [40.107.255.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90328E0F;
	Fri, 20 Sep 2024 06:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726812734; cv=fail; b=oW5gWaPcWSopeo1gPCNOe3AyDREGfqnIES8NmudUJ2ufSOhZXmSYLpdZgeLKghbobUvupzqxFDtO9PDqI6CuPLfXxMX2PQqfPUsiX+eoLR5D1LmJOY4MGuDR2JSutqS4a72JZBmC3SZ8IQpZ+z11CzVRE1AhnS30HtAqoFmy2B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726812734; c=relaxed/simple;
	bh=ZHp33LeyAeMDjPN4fKdgJ10jtmoRwkE3PyZ4OhXj+dE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=lJvozj2WicQPvqm5NYKc7zJz+dxF11AOvG2ManwaO5uAQTcsODntq4OSTnHiJoEIeD4xH+hz6BvVhTkTTvSGQ4GGJPRkQy6nB10eIOdL7u+fnwrqhxdkvCaZ6Sy6wstEQacexUvWEVvLhpza4ZwalhykIGP/3Bey4LyJz6Ft1ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=KV8GlRbk; arc=fail smtp.client-ip=40.107.255.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="KV8GlRbk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibjfguDcp1KiRoYfpA9H7OHDbuUFAxsy2PfKoK9rzfKfYDkBSZ2MXBDOTszi4G28a0x+Q9eX8VRXSGAECRIATLxQr0eInQlt5DJPvYIGnC0NCoITvqu7HI3TPhDjFou63OSw8VV3dQ/KlhWRz88fOH/d8C/ZZlAk3iIixSAqcYwJC4Gnfpgskkq6t/MtTx3HIfDTIgWLlaMCG7eMCsXiyCIZdCmS4xtH9DrRdU2PViwYAnzHiFRL5kKOFvklWqARAPbXHy3faoxsfFHtPuW+N2DPAUNVlci41Wr7SkO//46KPwKnoW5MzS0/GogJ7faF2wO0q2oS0ElkSQvAI7b4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qyrmxVJilMWW7UD9xMd6M1JzPgts+9bi0Ix2BQBjGI=;
 b=Wcqa6kgjrtJfPFo28HK0HNZwEu6rzrcmFrvkInIxCAQaxT7PcUA9O9GXNqyBX/g3El93WNCfrAIEOk6ifbtMO8exqejFQ9Yy9qAsRiYMJzrBnGFRt+9TWNVmEK2QYCHspPWIETBefd9dnuapOZTHtKEl3DvMQXE/U7BHT+qHDIv3sY2z8REBBO3oSaFVgdAm5UR8F4aT4a4eCxxVtjQRHDxAiggbxE7LbJfMbs0BAnhK/l+73JgNcDtk0OCKSuMuEjJ8utXw2h5vaGec7fVCTugM67iWumG43/zp08RIo0MPGhfed58RUuKT6tWQlzcpyxqb6RjSO/5y/bx8Sxv4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qyrmxVJilMWW7UD9xMd6M1JzPgts+9bi0Ix2BQBjGI=;
 b=KV8GlRbkFQ5v0sbxMzOn5UGbG/kZVQWymwqknphG9rZ5thnm9ktBTew/DnMRzrfzRKfaWiwPfQL3+GXitxREAIWqIVW/wJjFutaF4sq/fb9Gm4yIIIYAsholwdp7rPooaOBjLEFaBtfFyKFjOxrNVcWRDXB3fuBnezx61YAAmDtRnWK2MJKNRkT7Obf17MtyEHOfSa7pdjrKBJUfTg+lqtDj4WQfNltoVyI33U6TI5pDHNHD8DxIe9dK42mTWmhWhRuF9k0QckWs00JIEuRCwu9Wrl3DPks7GiFOl1sO8qwyDNaHLO12c6hY60UrRnbt9+dO/8oCYoGFieGGtu8LMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by TY0PR06MB5425.apcprd06.prod.outlook.com (2603:1096:400:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Fri, 20 Sep
 2024 06:12:07 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7982.018; Fri, 20 Sep 2024
 06:12:07 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	gcherian@marvell.com,
	ayush.sawal@chelsio.com
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] crypto: Correct multiple typos in comments
Date: Fri, 20 Sep 2024 14:11:41 +0800
Message-Id: <20240920061141.10720-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0156.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::20) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|TY0PR06MB5425:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce1ac73-8c5c-41a0-134c-08dcd93b279f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P8GRJImHiKnN4O9z13/c5YCRHuX2FAEN9qDc6FtakesthFW3bS1RjSiw/yxF?=
 =?us-ascii?Q?PfgzffjRzep18FOWAAaAPoxV2MTWpzQ1NucqQ08Di9gDARNpRUVgm2VvQtdH?=
 =?us-ascii?Q?VwDSNs9+Gem1xMQJ3K3CAWLAo6OjeISEdsu+estwJPjgZqXk/tn7qzYUuKNa?=
 =?us-ascii?Q?7CEq4Y6Z0XIDx3BeUb8u4hs2XQNZxHSLSvlUDO3AFeXAop58rJr9wI1mbyzO?=
 =?us-ascii?Q?9K19WfCepyzZAF1mMR9q7OXfTJIBFql3vLyDxsfqRkmiyRO7Q34yRTpGIJ75?=
 =?us-ascii?Q?SI1w+Tk+yQAtB19JBKb16pJ4DH4YsVg3pfnfne7nAzRMSdXizcu4yXTvJFly?=
 =?us-ascii?Q?HGkSubPlfauhdsMYeSnUNzlHX0g59X0wNmwGEZ9HlfK8JG2ts2OxTuWG3x0Q?=
 =?us-ascii?Q?+BTQePhAVwAGcnMm8UKvRyV02BXjod6rjG2tBUrKgN1V+Zb/K9kKddE7CAS9?=
 =?us-ascii?Q?iUrTECLlw51WJK7u/4txJxXUZCuDc9jICo8hljXMNKCoNtPtzo86DqW34Xiy?=
 =?us-ascii?Q?i52Z6Ht/Rlg53SWi9mESCBKAmBCX7g9j1eyW3b7aPnAFRowXtlKXkp59iS7J?=
 =?us-ascii?Q?mJ+6luYT+3zSlvoL6FxAZ/tuFKNGsZKRTtI4qpPKPhKFhGk3HzthJfXA4D8z?=
 =?us-ascii?Q?YkcjaCFDaXGmXCmoAk1wujMrBBZE/L5pbmoaRhrKYhdgGBUtVXJlYyuB2QQ4?=
 =?us-ascii?Q?DOXDPMOEsjVIR2K4kPwBU19Zv4fUE9Y+cxPvuvpK3Z5ifhmIUYMhfR9esi0b?=
 =?us-ascii?Q?56xFedCdUwpZVX9slJDIrxQkxNmNSpSURFCQBg0Ywd8gOvbrNxU+VjPhRiCF?=
 =?us-ascii?Q?f09XIYdQmIHoZQe3OiQ8nwBMG4xKj/R3uI/NSckgfGZVLhB2kotvYRb/t7aq?=
 =?us-ascii?Q?DSJl5eSBDqvYRJJyJ75HGpzPmLtBPpVg//n2t7oYBrn5JfWfQtHnMRxu2lrY?=
 =?us-ascii?Q?JfByaMgsApuHs2ZLm2YWhYh5btdaqbZpKh8adR2KgQcRtqa7Vwi6fNABVYq8?=
 =?us-ascii?Q?9Gb9O7U0cm91hj2L9f/WtvrS0kZb5896Ztl8zl7rgdxX3a9o/wXGSu6uGVsx?=
 =?us-ascii?Q?2iJBNKzwW0PmvqkdASWDRsSOst0cq15deg9wZ6V9U6hUm2xPvtXziCQlueKq?=
 =?us-ascii?Q?dipq4b51lgl2IO9bImVD4bRVNc8ByzRalYUAUDt9hLd3yE0L1PXXjF0hdCZO?=
 =?us-ascii?Q?XWAS73N+IoWS15hlYqLjvlWDUf/nAqR7Bw7RIzsJlmqVLKa7lOzP0AqvtIIV?=
 =?us-ascii?Q?uuP2DiO7Auahznzpjopg67GZu2exC11wPMMg+V0QmEm8p5IpDcAtSMT1tjKZ?=
 =?us-ascii?Q?nQbT5qHxUIu9LmsPr6hHnoOFv/Yw6MwDQLpdHlPZJUcpPWWI5onvZJq4JQY5?=
 =?us-ascii?Q?lhnOhtiRWajr1PJENFHUFmYjSOi6ysbc5kStH6THposDTbqHUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Es5AOwlA0bQb5SKzHyCW4UJk3gm/sFphxsB4RSRn9E9YgO5WYOUJzyXHbCmb?=
 =?us-ascii?Q?VoHFpayuFdZ8qmiqO4qLt2WzlNVRhSMFWTEyIf1IgxTVBKMqNJWzNq6Ng+l4?=
 =?us-ascii?Q?NeRmjQwFMA3qZ/c3DD4vvQPP5E4tf13jS07nj1gZ5bWRufWJCT0af5Uh1HWm?=
 =?us-ascii?Q?1JRGTQkX2c9lr6yfCmBw/xgGsh5n9aNhcm5NlAKjg+m9iKyyNE2F8OHHGi8t?=
 =?us-ascii?Q?3BNMXrjpYCjCNhUknKSpfH2jmL6ww7zRjT9TVYrA/cWee++vLOBESZz+MhTN?=
 =?us-ascii?Q?get2Ug+RsXy/3I+9pNJ5+Oc+5CDdQK0HNrxdVDRs36NK2dYWQuyiRKuvqAKv?=
 =?us-ascii?Q?CdwY7XBgv4CgjU+1FV5WefPthCQSC7dDzmsGIQDtwCkF8OGGrghYAn7gQOsh?=
 =?us-ascii?Q?cNsG/K2xjK2EqdN219sh51jfGuIavU9anejCuKMmDJC1pkr79hgQKaKYuN6N?=
 =?us-ascii?Q?eOkOJioipfGnDLWTFjCTpEwZklXkaKeQy5+tzEpk0aJ1VjaDcrEt28mdKHFv?=
 =?us-ascii?Q?Rby+05aO8cRikkQPefKgZLU7wUkdqzdp6JKQWsa67YQM+zfoQbhaGvpn4MwA?=
 =?us-ascii?Q?cdT+v4npbiy9qDkssKqkTqTsKXKeoTQ1YOn7wV6cSEgdq4vlHWs9zqUoXl52?=
 =?us-ascii?Q?661EIU9e9ggXgQyfQSZX+6TCalR8Pw92EDUb0C2rD1p6/y7Mh9waXufxB6ee?=
 =?us-ascii?Q?v5+dhUEFvqa+q1bZtLF2tsaOMhxXAfonduDNL3/rHJoQ9jPc8IrHlB0PxNfN?=
 =?us-ascii?Q?5phlSiGfw0TYx2sf/vSI6cOzfmJb4qwqlXvTjz4sNElQhla0yYXvW76Id8Ne?=
 =?us-ascii?Q?WghxOKRDnDlPVzq8sKdNqGIBVbaNr9tLR6MlsBB3Vcyf0G1OmjqpfLqn2W+m?=
 =?us-ascii?Q?5r412nw7lPdqvhDJv4tY07R70xcG+q19C6hKas+loc5AKrvxwEsFUEbWNFBI?=
 =?us-ascii?Q?QZU+b4+tJkERELIy2muhza0fu1tltCC2ZU9zV+MzKpBrGRBcp2W/iIp1IdFC?=
 =?us-ascii?Q?72sPv+1vlG/zWkDrPmCmIGwZDAuefU1kpWbRj2zpER2PPrSpZDzE95ukekD2?=
 =?us-ascii?Q?e5IS1B6FQ67vq9zH92FpnFtqmxSPxlCL3TRdrgeL5QdBoOApIK1zVjk/UyaA?=
 =?us-ascii?Q?fTFKvqDQDUQBKwoCbXwPUjffEzPPGzfrhRbmi17znDBwuX/ChpYdDwuNvaev?=
 =?us-ascii?Q?22KOyQ7wbe3rHwJ5K1yNwP8fFRGH26QHfJ8unDBgOHn7YhcFNM3lgq627nGe?=
 =?us-ascii?Q?uKyCAE5bz795TXUlhjUleUgNOyMKxB4ArnNIyUy362WYADpH74Q5jFXSW2io?=
 =?us-ascii?Q?YhGWOJDy6Cze9WfXiVvoXXlvrpgOap+FaC+Qhj7ht/PE2Lao92vcxz4KvKhX?=
 =?us-ascii?Q?xjlE9uKPEkIjAmsUnRY/cUdjycpm8Y58yCk7oKrmsNV6jAHhFfPaDlsiWxl3?=
 =?us-ascii?Q?uCoGwsfBxQYt13CmlINZGrtA6/qqvk+eRATlw/E4MdOxIWA51TcBWX6ZqSYO?=
 =?us-ascii?Q?Qq0xGXOu+zHeFI5YJtwC+vpnBFrUnt/w6qUHVvHsF+BQZULyFBrDjqehmKvA?=
 =?us-ascii?Q?wQW1NSRSKJeUK41+crRSP02vEB0rHjiGTGg8P7tG?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce1ac73-8c5c-41a0-134c-08dcd93b279f
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 06:12:07.2909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vndgy85aGADKlrVLNSfFtPicKeKQIRFsP7Mpl4Nd6coVQqMpBKplVM1xaMN7Vju5TN7b3PXyk7SNPim6BfSCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5425

Fixed some confusing spelling errors, the details are as follows:

-in the code comments:
	fininishing	-> finishing
	commad		-> command
	intrepretation	-> interpretation
	inuput		-> input
	overfloa	-> overflow
	Iniialize	-> Initialize

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 drivers/crypto/atmel-tdes.c                  | 2 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
 drivers/crypto/cavium/nitrox/nitrox_lib.c    | 2 +-
 drivers/crypto/chelsio/chcr_algo.c           | 2 +-
 drivers/crypto/sa2ul.c                       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index dcc2380a5889..d539f4422cad 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -872,7 +872,7 @@ static void atmel_tdes_done_task(unsigned long data)
 		if (!err)
 			err = atmel_tdes_crypt_start(dd);
 		if (!err)
-			return; /* DMA started. Not fininishing. */
+			return; /* DMA started. Not finishing. */
 	}
 
 	atmel_tdes_finish_req(dd, err);
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 153004bdfb5c..fb59bb282455 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -238,7 +238,7 @@ static int send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
 
 	qinfo = &cptvf->cqinfo;
 	queue = &qinfo->queue[qno];
-	/* lock commad queue */
+	/* lock command queue */
 	spin_lock(&queue->lock);
 	ent = &queue->qhead->head[queue->idx * qinfo->cmd_size];
 	memcpy(ent, (void *)cmd, qinfo->cmd_size);
@@ -510,7 +510,7 @@ int process_request(struct cpt_vf *cptvf, struct cpt_request_info *req)
 	info->time_in = jiffies;
 	info->req = req;
 
-	/* Create the CPT_INST_S type command for HW intrepretation */
+	/* Create the CPT_INST_S type command for HW interpretation */
 	cptinst.s.doneint = true;
 	cptinst.s.res_addr = (u64)info->comp_baddr;
 	cptinst.s.tag = 0;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index a5cdc2b48bd6..068265207ddd 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -17,7 +17,7 @@
 
 #define CRYPTO_CTX_SIZE	256
 
-/* packet inuput ring alignments */
+/* packet input ring alignments */
 #define PKTIN_Q_ALIGN_BYTES 16
 /* AQM Queue input alignments */
 #define AQM_Q_ALIGN_BYTES 32
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 177428480c7d..af37477ffd8d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1186,7 +1186,7 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 		else
 			bytes = rounddown(bytes, 16);
 	} else {
-		/*CTR mode counter overfloa*/
+		/*CTR mode counter overflow*/
 		bytes  = req->cryptlen - reqctx->processed;
 	}
 	err = chcr_update_cipher_iv(req, fw6_pld, reqctx->iv);
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 461eca40e878..3f056f56bd21 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -574,7 +574,7 @@ static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
 	/* Clear the command label */
 	memzero_explicit(cmdl, (SA_MAX_CMDL_WORDS * sizeof(u32)));
 
-	/* Iniialize the command update structure */
+	/* Initialize the command update structure */
 	memzero_explicit(upd_info, sizeof(*upd_info));
 
 	if (cfg->enc_eng_id && cfg->auth_eng_id) {
-- 
2.17.1

