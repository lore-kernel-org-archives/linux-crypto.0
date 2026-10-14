Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC72D8DBB;
	Wed, 14 Oct 2026 19:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007082; cv=fail; b=GrH6n4D4S/DM1KNGYTxW9NmR7lO3uQqe0gvq3Cq0Q2Hq4+DXAiX/cUm5JV9L0Z6L/IYQlBp5IrtCB1d44mEOflhn/lZvgfDsqT/6X5ptfMFJwf2hi8ARk8UObL3MacYsoNQHmN5FyokBCGOFQumxq3dfdWYDdVn39ehaEsO2Ltk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007082; c=relaxed/simple;
	bh=mIMtRZc/aP3dP+jhwzAxQ/FHZxXC9C/bUsZjVktjMeI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=GsuFyKeImsDSh9VD18UjHP9W/pW74AbbGr0QeVEcdO1RALPYyJ8tXT4ba7w0zqqynYC2tSCHXjLA3gC3YrAl7nahrHakAgvS7V882aHofzzgB8yhXKXFf7Qt6CHVPIkPxZrWWHAgCMIEqMOdjnS/opt/IZOqwNY8QT0r3ouLwX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YiP/iTff; arc=fail smtp.client-ip=52.101.70.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YiP/iTff"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9di2Tsb3488NIMRTAFBDLjyY3uVwZUq0A6wvh+0hkLmA6O8Ug5LFjdfjveO5KC5cDZ33ns8XQ52mv3IIG/7rqRrajl0/66TUJwO1qRWw1rqioREDzkG4sUv2gxIE1W0PGG2KCVkGHbSgRJKXueQBRGYS6XB0ELnSeP75D1UuW4i6yjuNhtKkBczybFJ+CbV8uCNRUnKSUViS3JcU6fKTB4rUyXPnM0DNniDSAPHbC6tTf4V4qm1K2NWs/H7ZUTJEhOlbOPn+0c1rm/iUGRn8hrtVZBgAdE4XF7/ErUBIA/8BsUOcBcjJrzqFCeddG4UkTEAHfLYmf93A0a+MEzQ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5w/lPJrmc3m5j9IWNs0d7LIt4GcVNfKkkmTHK7HL1xQ=;
 b=DhgCbeCtsxro+XvM2C5lZJQYbNnCtSrUmqfdHM1WIsHHqqloK3U/ksffe0f7MnMDbIIRqM6f4uODUD0hfjGAOOh6UtLY/pf+xP21xvRZPKdNXx5ZA5FMzZ1Am/KzyUmnYbkmPaQUIz5vn4UismtBt/xZCrJsiOsn7oMhL7/GUVp7/k83d4Cdzto5ltVRMtn+CpYMMQqgqWDUdwqXoyppVRNUOoYa7/UmbSDFVNIIa7y7VnFSQvXktjDuBtFPM3Jcx+v9roekr4Doc8LP7KT2omdQzQgrmooIypdT9dlpqE1efPzBkl0Dbcyba9pybAgipvJg7rCexMPn63HWs/legA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w/lPJrmc3m5j9IWNs0d7LIt4GcVNfKkkmTHK7HL1xQ=;
 b=YiP/iTffm2ffW9rjoYIq2nSoBSBCNAIVkVW7P+JAGH43EmYHeH96hlc6HX46e/Y5VDdrTBP0IjRh6asVgM5N2Reh81cey+vgrL++CqXyaodj/uSwLNUFOs3xkcejc+DApiGtbc1xlHPuMaBn43rHLgSGfPl0ob9Fbr/xyzgCAWcyy/FhTzkcaNp6nXKIFvgH6ZDJ4a+9Dm2klFhQ5bIcLPTTNTJoyw94n+wMYefqfS7lsE45ZZNwsndfrTjB5VE7p9hIrYjzTucAW7V6C1mA1c8jwaoYzQHYlWS71MFgmZAxfwvhSVPMX1lfMUzYTCuXGMmdsxnriE5QeO1U/huzrQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:27 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:27 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:49 -0400
Subject: [PATCH 5/6] async_tx: replace open-coded cap_mask accesses with
 dmaengine_has_cap()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-5-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=811;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=+z4r5MWtbaMh7Do/UsFrhQ12/nuY+GHP7Q0JHyFXttc=;
 b=XgSySD+7CsKvRVijgdVdixcWmX10kUcM0YW/Pjt9l/tH2utqf1bo735cuFMQarD+dmEV7tdhy
 BY9j3c1wwFPD33QjKO7V0r9B99CscSyd55emKUepXhXZax2blWdThAC
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH3PEPF0000409F.namprd05.prod.outlook.com
 (2603:10b6:518:1::4f) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: d9062849-949f-47b5-97e8-08df2a2b8e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|11063799006|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	qWXXd85cioSaf0m2IgAhpq002Z0JUNwLL27IRtDcSrD08cMrlPihFHsazr4Z46iMITrMJ2nfKfR1rIs24ZFS2E4PrcIKzHthesKzqGJ4U16ayQPsJBmfuxWvGEZqfctJ/y1ApQWD4TE+7xAcVVLA86hW2vE3IEAOrNuxFlhfcJAJLzaeSxaudBfe4JGBQaBjC9mYjGEZX4rpbgrkQzjBdBSQ5GKSnN8+C5sbCapGnjGTpa57fpN9JTzeQdIWjnwZc3y8lOugvXFkrnJww+Pd4cIIoowaw31DinF8KZPa72VJ0QjioJjf75Efb6ONKhQQ8ModZH60gisp3/CSkhje9qhFsZl+Msko1RKFUiF+Z5JtdzCSDCWt5bpPo35Gnh4MJk7rSctemsA96sNLiZfc4zcvZoPYsLm2DRfvAeCp683++48D4WoiO50APbiEstZnEVqhSHkZa4Aw6pLmN6cDCi8uRE2FFeswToizyz8vpNKUgimZeujMLxW6z66HorgLvTQzQimmW9s1gutRudha+Sg3VuwaDN5bxHMAK6oJicpgO+wBcSrVeBR3WLDHe2iENiTJJOTHxH0LLX493rP4EEXNKC6UHhv5hATzYL2xbc+WqHpsK8edw1s63MQsFTMBHCl0reJ/JDZREuNgmkTJx0HwtCw2vEUnP2O+CLBWD4g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVBPRCs4ZVhhWGxBVThVbUVOemF1cTYvQmZnbXhxaDliOXRyTkVqNEtFTStz?=
 =?utf-8?B?U25VOHdjZWtDQlJ4QjdZZGFya25mUndlRlBnWEhnS3BvTk8xbHpScEFUQWd5?=
 =?utf-8?B?VmtmWFlNZkUxUlVaam8ybGl4c2ZJMW50K2h6UnhoUy85ZmdOSXBmUzR6WmtG?=
 =?utf-8?B?a1BQRzhyYi9ybTB3YlVJQ1JHOTFhMkNENzh1Rmpnc21wZVhPZ3FaTEk4YXF4?=
 =?utf-8?B?SmFmUmp4TUk3S0tZVDd0ZXkvWlhDazFjTm93ME1LakVoK0VOQldra2NieTUx?=
 =?utf-8?B?cDNscXhTOEQvaEdwYXlWQ3NsaTQ5ZFlyanNZSzhOSlJnN0M3NmdzYWh6Z0dS?=
 =?utf-8?B?c0VBYlZXaVI2K0NVZTFzQXF2ZmZ3UlZZM2FkMUJZcCtJNThUTHNmVkJmYWVV?=
 =?utf-8?B?Zm1ZbTZVbllBT2pMTDNrUGZXb21vVkRkMjM2MERJNC8veFU3QmJoQ0lhMlNG?=
 =?utf-8?B?aWZ6MDlFdHlCK3M0SEdBNWFMbGxkV1RFLzlJdEc3ODE0K3htTGZwYzZyQmI3?=
 =?utf-8?B?MzBFSUN3V2ZSZDdsNGd3NTBJdFpaUWdwOTAvek9aQlROUVZLcFRXdE5wc0Iy?=
 =?utf-8?B?eTdNSmZscTlqQ0F2VVJ0eFNtamR1cXhxamhyQVI5MVcybW9CNUdmWHMyek93?=
 =?utf-8?B?aG82SDUxbEVnSExUbGVNRUhmay9iNk1QOFlNNWp5RWc5UGV1dkYvSkVoTEdN?=
 =?utf-8?B?MGZkc2FQdmM0YVNZbnY1Q01heGM5ZFBRMTNaMDBlV0xybFh5NUtQTmgxRFY0?=
 =?utf-8?B?VDRnV3RhdXN0Z1Bkem5CK0JtL2dsdDRRbGU4MGpMclJSczc4cE5zUkxkZHdW?=
 =?utf-8?B?aytQdUx0cnk1dHk5NENxTXJQQ2trdmVINkY3eUk5YW5lT3VFQmxFTzFwNDVP?=
 =?utf-8?B?QTYyL0R6VmJKTGRuQ3k0RnE2dEtMakhhUUdPeUhrNmp0Vm9UTVpiTEJKYWU5?=
 =?utf-8?B?V0pZUFNLYmY1Wk5aSFJtR2JUTForR2N2bkNqcTd6K2NXcDlQV3UwRDRsaVNi?=
 =?utf-8?B?RXZFbTc4a0krcFZQK0VlUU9sSUJMMGR4a3BpcnU0Tmo2YTU2RDg3aTlDLzZG?=
 =?utf-8?B?ZW1XYUFTVmovdHlDZy9wajBXc3Y4M1ZwOG5nUjZESkdaS09nMXN6R1VhSFBx?=
 =?utf-8?B?c2tLZTJQQ1FSdUEzYjR0VmFIcStCM2wrUVJQZDB5RFYrYll3Snd6RXZXT3RK?=
 =?utf-8?B?NERxaUlLbTZqQ095TWwycndNTGFFejlQMU83cmR1c282SDBMS0pwSVE0M21G?=
 =?utf-8?B?OTNySml4N3hhY0U2N1RYUVZmaWlOb0Zvc09OUytFQkJUUmxBc2ZCQnorbHJ0?=
 =?utf-8?B?SVU2N2hNVmJNNlVVQkluY0NhSXV3MzV0MGJTVDBrN2x6WFBubk1vdVVDUHFS?=
 =?utf-8?B?SVUzeTcxMXRJNGVua1BiVEt1SnVpdDhmaFVsTXZjV25XTEN5QjlsUEt0M1lX?=
 =?utf-8?B?ZzEvd25vOUZQV00zUGl5aHZBTXY5aHdabnl2U1F1RG5JR29kZGtvTndabHBn?=
 =?utf-8?B?ck9VazZ0UmlMcVFsdzFFQkRZbStVNGl0Z3l0SFgwZGdoNmxuSVNwbWxtU1hX?=
 =?utf-8?B?NW5QQm9LUDNBbFc3U0xiVlhjRVA0bWpQRXdnUDhzRnRVRzZ2UFc2Z1BQUVk0?=
 =?utf-8?B?OElUOUptd09TTUFwRjNqbXhVS2NOUjBIemlzOUtBQkFCUWhoM2lPcldNOVRO?=
 =?utf-8?B?eTRkWnVheXNxUVlvYVJrNlNDdHp4YVpZVHF6YmhlS2JlTG1KRU5QWTJXcTdF?=
 =?utf-8?B?U3RocERUWFFsenMvUmU1Kzk4WUM1V1lXMWZJMzdVRTlOUlZPNCtCcm1yOVVT?=
 =?utf-8?B?TnlPMW5LbVZBbU5qRW5PTDhXaTJGdlgzNDZ1UGRqbEVScXJTMnZyRG13M2Jq?=
 =?utf-8?B?ZitiaGtCcXJsbVdMUkxkdDFzSnh3U3JaK0YrbzJlbG9aVmhQS1BqYXJmRWZa?=
 =?utf-8?B?djF1VHF6dDBodUhtOGcrM0JQNG5XNTBQd3FxNWszUklhUFV3bzJLQU5wcHBW?=
 =?utf-8?B?Sm5SMWI3SkZZWEtwTG5tRDcvenlVcUhBeFNVeUZyR1hycHNTdm5YU3krNmNB?=
 =?utf-8?B?UnFLN25iMEg3aU8yV2h3WXJrOE9sWHI4UTNZbzludHk1ZjloRHJybU9wbS8z?=
 =?utf-8?B?b1BoNnNFUDRSRHhUWXkwT2ZmZy83TWxlMThjUGxZSHF1NWt5dWtoOC9mR2RO?=
 =?utf-8?B?eWhxakdyb3FtZjFHWEJIRk80aSsyZjhtaGp6Mk5zeEVoSEdUTDl4QmdNU2Rz?=
 =?utf-8?B?bmVPbmluOEgyNXZTMkc0eVJzOE9SY3ZXMVlOYktqS2VaZzEzN08wSVBxRGdI?=
 =?utf-8?B?WFg2TW16OTFCYWh4aWgxN1ZjaFNjZTZaK1VDSlJBSmkxcml4RHZoN2xuejZL?=
 =?utf-8?Q?hD+bTzqxQqKoHaCT/HvkP99ZioAoiywnPJbQe?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9062849-949f-47b5-97e8-08df2a2b8e66
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:27.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGNmi385zpJIMed8VVm5AIUvFRl0AYqkOwN/k4CRBLpAn57EvGu432ZP+DkOPWoa04F8cpmNuag+hwo4BOidLhAw+uav/9lmv4BcySh2bhiwUWqJmZaSGyfKY1hKB9EZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

From: Frank Li <Frank.Li@nxp.com>

Replace remaining direct accesses to chan->device->cap_mask with the
dmaengine_has_cap() helper which already exists in dmaengine.h.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 7eba152ecb97b..5637c95be6b3b 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -47,7 +47,7 @@ __async_tx_find_channel(struct async_submit_ctl *submit,
 
 	/* see if we can keep the chain on one channel */
 	if (depend_tx &&
-	    dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
+	    dmaengine_has_cap(depend_tx->chan, tx_type))
 		return depend_tx->chan;
 	return async_dma_find_channel(tx_type);
 }

-- 
2.43.0

