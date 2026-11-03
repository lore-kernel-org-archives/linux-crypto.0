Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735600;
	b=TxnzD7pML7cGiqvJMT9KFGdJbu/XB5AEtZ2KiOohWRfM7kGPehM/H94HzQkbU00DyUu2
	 GJVzZMjtLMlda8hPEcWKv7+/Oftp7p2aH03xBdx4ZPf7LpVmmgiHPmgvVGLvTCOR6UIOX
	 tZCpANzoB2jEkn4v/yUcn0dHWk5ulO1x0eoKzrAqtaylnzcwSDn/6pm7kH29LVDv1itiE
	 QKnh+VWaLXSOAA8WkEsv8EbKz0XsistPl+3pDWASFNyuwMR3Lnag5zoiSJQLg+1yD9O6t
	 Lohshof5Gk84ZfAEM9vRC+Hkm8V9eEQWcLlFs+pfTIfGfsRvnZIrxnpsM7uwjMImqJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735600;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=snKf8wp7FLI4ltMW/iDbLX1Lh5wOfuRDY6Z5E0jYbw4=;
	b=U7hJV3zDnj+QU3YhdhoODNdCf+q9R21AwjaAtBArBrUsqsOaw9023SL4RTQJf0ESXR+N
	 n9qFCREOarJ7RS4tlkHvXgu24BiH71us+zXZxHlq16gpuJJ7vh9+W5jTOSZX460I6Wdfv
	 nLN9t8re02cc3HQDOJ4rcEV7jBKnNypNDcwnR5LZAROlKDpIs9ljr0RMxzu2ns0Oo7SvR
	 1cNWI5EGQWeNdoZf7r2s5yP0jSqUQRxSAO7kLP8+vg8S1sKMPUi71mLCs4d+gw1h6QaRl
	 qOPPZRDhc4TwgAs+Sp1KWSiDXkiEoLekww8oFmQpDR640NDiS142h/aj/BC1+IJBVhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=buqAiABD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.9
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011009.outbound.protection.outlook.com [40.107.130.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5387A606A32C;
	Tue,  3 Nov 2026 19:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5387A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=buqAiABD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NrFAen53Q4eAkfXfNhrnNtv6k9w+ZQ/alSkBZnTBQGiKWY8WwGJmF7HFb0tcNpubvxfAe4ftRY4PT7ek7qvfhcD4ShDWSM+tzgbzQ0mXp5nKUxptm6vePfYUGvdFDOv0I6axB322n+qrhLaflrHJtOB8d18Vr4aSoJi+1URYSGZhEIHF5cyen86M1MJzuwlQL7UWgviI9uwF/S0FKqV2+zwUzAKgurCaNsXsyP8w/1WNWMvjbjg7IOMyclAABq7rkjWg/OaW0Xs8w63MhTiJXhcaIv/H0CZUu8PicdhDsw1S91wor9bF9+NUnYhHk9HMRFdnUow/eGCAaVlAVbwBxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snKf8wp7FLI4ltMW/iDbLX1Lh5wOfuRDY6Z5E0jYbw4=;
 b=ydh5M0RwrijXbwgm19tROHvQcOAMmqiFHOPRVIuiYoUYxfyVnewXjGI4Ei0gKqbEHdxPY2NtY14dDJnVbBR5XAGCZ4lQAjZ0075HHqJmp/dBA5bb4zGVbGDi3uLjyxjLKyc2JRE5T34IlrtMIyWecLtJjpsUJMxrmgCGh6u2Js+j4rYVcNayis23kx5I8f4mOGeBtXi6cQbwbMy5AinwrLrO6jmzolnj5Q4QW/N306M7u0q5sFmJU4Hv/Vl4CnWSX8WSXs2iNEECRAktMO45Nq1A9igoON0sUfg9Cyli9KB/+9sT6fIsD1jfJ0D5AiKZ81ujOOzXXRGMHPGpuSxYVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snKf8wp7FLI4ltMW/iDbLX1Lh5wOfuRDY6Z5E0jYbw4=;
 b=buqAiABDCnDxug0P+/OEgACySJFJ6v3J5jTvwl8Wj5TJjY6yClLlQptG85zbmWjepjj8Krh71WFZSTG7cC5uBRgtDzL6z8MzkUrIngJIYhv0NEVYn8mnEDyZCIF6TfpFS9i1oIr+ygatEZvSS8LQVoJ7BrhZz+ASTXR6mjtAGYLXKDnVylS40yejJp9nRaan4xh0mQkLknG2cJUq7jCy+A2wpn3FZPGTfhz+VPzwHOKnEcbi4gAoISqaPIEkSR1NlcjrXZ0LJ6nKyKAXteZGSDt+Mjr/wnBW+f5mK5Kxs/Y7at3PFVIHx5eOcFPyW3iW8vbJmAqCYFJE2u0ilb1Cgw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by DB8PR04MB6857.eurprd04.prod.outlook.com (2603:10a6:10:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:53:15 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:53:14 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:37 -0500
Subject: [PATCH v2 6/7] async_tx: replace open-coded cap_mask accesses with
 dmaengine_has_cap()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-6-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=901;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=Ua7ksOzMgW+7IFPTn56kh90d4xbT+Npq7t1T8oC+S8Q=;
 b=Z3Np2+9LiuJnIBZwAqnnxmYnWqqtlwpIZ0omm5SuBt8TbLmHKpiMSuB6h1nMEHnfIADfQmYAE
 aZvttmhGn2YD2nQy/gEl2hGzkArQs9YagtlFyAl8AGCNO9qGd9a+wX5
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::13) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|DB8PR04MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: b397849d-a2a1-4e0f-dcbc-08df39e418fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|19092799006|261022105027099003|11063799006|261021121427099003|56012099006|261102123227099003|261009223027099003|261028144727099003|261026140227099003|261021123027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5utX2yLnQ7q0UJAPktOtWNBpN+ICqvNMVcNXo+jfZWYL9TXQ44YNp+f8IwAankjRg4kMdv7snm7yMlWH0kFRCt4ovXU35yz9d1TCv0WNoWlSGwIJ/fjzl851stLsLL0rElefCdVhwL24e+T9LXTqTKgTffA7q/IkG1PeAfYsZpIpTziUj/oParwSMEIvnAxXJf6U5733lpbTLpho9JHLZY6Cvde8WYx0YSk2DauP8ae73Dq8Flo8JDpOWV9ZYOHflZ6DG3R5Pfch0Dn/nvhIpWHTRDMTUxBGIsPJcnjrOjRm6Fjqns0iSw5rgF9eCnx+zU1HrQFj9RUr6Yyb6jmMPLNk7OMYyv3VqTRh/9swwkThtG5UO0ut+8ool8eSzOo4ZULwlN+Coiqehv10gc1s12MoGWhXA1RxrpUxD/S914cfpEz5uGlH1320+T6jegW0XkyX15w+b+FjPEK9PhkuqoTPM9KkdSznEUdS9mKxhX5nC7GNSsZwYgQ1IdexmFwL82+sWt0hrxToupaW2YWsQ/79CjTFUOndTIqkrgHWJ7/kHFbgB1eroXsVWwqlOInsFrm9lJV9zIohU/FF6NanfHq8cFHRdmEnRySc83hAiG3orgBKrJxb5TYZ9YAsP+47sxh20MbROo9KfxjQVR6kY8UfdbDpzs7MZyIsdbCWs9I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(19092799006)(261022105027099003)(11063799006)(261021121427099003)(56012099006)(261102123227099003)(261009223027099003)(261028144727099003)(261026140227099003)(261021123027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SERlZzdUV081bUVsSm9ZUFh2bDRrR2h5dWlwTEZNTytKbERzQU9LNTBHQVRX?=
 =?utf-8?B?dlNSRm5XL0orN1RDTzE5WDg1T1pOdWhqb3dSemFOcEVBS202TXgyd1VGc1Jw?=
 =?utf-8?B?U0ZmM2JndklPK0FQcXpFTXM3RWxTOWVoR1RRY29leVBOa0NOTi91TmQ1SWNO?=
 =?utf-8?B?YUdDVWJwMllWcjRGa292QmNXdy9zZHdmcmZsamtyNjdWQ2tncWF1T1l6TmY4?=
 =?utf-8?B?OGFYU2R2RHExY21Fa29HMXlRMzBuNjJWZFgwWjNiMVVhYVljS1g3MFh5ZmJD?=
 =?utf-8?B?VDNCZEVQNEQ5WnZwR2JZY0tNU0RjUThhTXl0OFg3THh4RWQ2NElOYXFoOGE5?=
 =?utf-8?B?dlhhWG1XbkNwak43NkNaQ0szSXJtZjgySllVU0lCYjFDR3p6bC9XVkJraS9h?=
 =?utf-8?B?Vi8zSFpTT29nZ1JXcjBkYlNYSzBPWnJGZFpwV3NQZk1LVGU4a0lHeWZ5SEJj?=
 =?utf-8?B?TTgxR0dTeVV0RFVmVEIyOHB5cWplOTAycGNSWERpL1pEV1pPZXhST2dLQlJS?=
 =?utf-8?B?RWhGbWJOSUIxdXp0bjkxeFBmTjZKLzlQMVE2amFsV2hjQnpWem9zZnlmOEZ1?=
 =?utf-8?B?RStoTDEwaUJseUxGZjMxZ3luSHY2QjhHL2tyTi9IRmdnV0dFWHNtbkI2cUJ2?=
 =?utf-8?B?dFZMZko4OGVCeWhzaDFYNWhOa2puWFZpRFc5b3g4bHlUSmZxWmVWYy92dVN3?=
 =?utf-8?B?aWdZbnZDZ0JZNnRHWGs5NVMvRFNJeDdCMlduWXFyMEl1aGhsZlJWbzZTNFcw?=
 =?utf-8?B?dFZuSXd6OTh4UE9IR1MzWitmNXJyWERwcnU3QWFEYmF2R3NJb0hNVy8rRjZ4?=
 =?utf-8?B?T0s4UlFYY3BEdmxXNjBZMUJ0YytWOW5mOVJRZ1dicSs5U2tnYUJKOGRWc1V1?=
 =?utf-8?B?clVtQzZuRW5nY0tRRU1mRnoxandwQ2lJZTNidzdoOE9qL3B2RERlcy9yYlBo?=
 =?utf-8?B?YXI2VVJPeXRvS28rUmdDV01sdEZnbzBNR1JtTURtbW5xWCsxbnhxSWcreTBj?=
 =?utf-8?B?dXcvNnpwNzBVWjJNYjF6NXI3MFUxa0x3cUhCQXlPR2JPSGxEd2J6VGdxZ2Fy?=
 =?utf-8?B?aGVFRVpzdXA4OWdEZnpEcjdvcWpaMUt3dlUrd3krd05admpKSHZWVlRuT2Mv?=
 =?utf-8?B?alliamIwNDc4UEt2NEhQUzJFN0hEcVFSalNvdElwNjB2elE4RFpLNnZPYzk5?=
 =?utf-8?B?MWtoZUpiYi9vQkp5T0g3V1M5aUdCOUNRZFBXNmFTMnROaTBpQjZQYWllZ2ZU?=
 =?utf-8?B?aFVxSHBwdU1nNnF2aGoxVFpJQTVvMVc4STdscks5OG50V1FWK3V1VWdDd3FU?=
 =?utf-8?B?dWZXZUpuUEt3WjZ3ZDVLK05EWENJaGxScElMaDhlZHdGMUdERFhjcU1FMXFG?=
 =?utf-8?B?eWxMSjNjWHNJUENqdGpiV2dwcWFFUVRMMzdoU1lqNWk4ZUxRVDdiemo0ay9X?=
 =?utf-8?B?Ykl2LzRwNEtvOTZPN0xHVHpWaWdxKzlGRm1kRC9SbTZsZWxaN2pjdll1UWx5?=
 =?utf-8?B?MTNmWGQ5RDF1WkFtaVcvL0Uvbk1yeUV4ZmVtS0hqOGlXRTJUcnd5Q3hURWZ6?=
 =?utf-8?B?eWduRHFBSWpnTkI1TWpncTk0czhIYTFhMjV4bGNCMjRrV2RpSDhJcCtUbVJI?=
 =?utf-8?B?ZzRVVStUR1l3b1ZZeVdscy9HOEJBYkE0UlRjbDNFSGVSbTE1anJkZ0lEQVpL?=
 =?utf-8?B?RThwL3NodElWbFJzWE1ndlFlMXNNaWdCN0IzY0MwdHVKMndWcS83ZHNrU1VN?=
 =?utf-8?B?bG52Y29UNFAwb1BqdlpHT3A4ZnVBOTU1Q2hRREhqNzgxR2RYYW1aUDJuK1h3?=
 =?utf-8?B?Q2xYbEdPVHd5YUhud1JLK0JNYS93cUNZdTBPd01DWENqMWhUYlluN1FVQ0lh?=
 =?utf-8?B?eEVVV0p0b09EUHJ0YVM5TE5iV2JQSHpVN0JzOEx2RTFIUjYwaHdFRXdPdHBP?=
 =?utf-8?B?dGQrVnM0dXB5NFFYUGNRR0ZUb21nWFlKTFlqYnJiM1duN2oxSWt2T0xHeEtB?=
 =?utf-8?B?S2ZJSXo4T0tiOUdXaUNLWVVWZTRlZFhDS0tDTzdNclM2bXVEbGd0U0FKbU5p?=
 =?utf-8?B?cVZlN05DSFdZMTlLRmdBb25sbUlZaWNkY2FJMHRCOEZmeExrWmxJQ2NRcEtp?=
 =?utf-8?B?KytscUcrdkxLNGFlaVZvcDF3K0xMQURhRmJveFJxOGVmR3dEams5S3p4dFNT?=
 =?utf-8?B?bVRNcE1zd2ZISkhQRUQxV28ya25Ia3NrSVl2d1JIMER5MWptdnZsUkN2R0hE?=
 =?utf-8?B?UEcyMmhqRVM1UFNvMktRVFY2YitaQXR0SjZ2T2lJYVExaDBaazRpckJraFZ2?=
 =?utf-8?B?RmhLeHE4TGgxSGk2bG9neGdDTURRUXlHK2hQd1FkTFJmT0VRa0ZoSkUvU0ly?=
 =?utf-8?Q?JceTZCYamA7N08AY4VRjX1kG554aEkvUJlMAb?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b397849d-a2a1-4e0f-dcbc-08df39e418fa
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:53:14.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUGQiLgnuUtv0U2B4ylUaH+hLMGHP3S2d/Qgk8B+CI9tAiGjD7te8VMlnQFkQcF/PG4chuMmMDRF51bPuyL/Z95wIEx3jdb05+0d9Om4qIn4EWZYKYjYApDqatpwCMnG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857

From: Frank Li <Frank.Li@nxp.com>

Replace remaining direct accesses to chan->device->cap_mask with the
dmaengine_has_cap() helper which already exists in dmaengine.h.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 90d6df9f872cc..afb829d7641a1 100644
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

