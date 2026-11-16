Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794852327;
	b=GkIqbN5okNgQIdLcoiQRik8KkqWM6Scg4CjafvEVycHqnXgmLrMyENhWqgocBTEQUDcr
	 HfPb7XIZBd7Lxf8BBwQmHLd/8RlwLjABcEvCxLwu23QUewT/Hx5SPeB65dIdgxtX4i5au
	 fzv5xP3RXMp+OcQm3fu7FgcSggNMh7eQti9qlwYF2H21gn6RYWLuYXyUtuTcqdl9efmhp
	 vxyAYOGOMXGmta28hixQHzJLRl6HyeJqIONlOFXzqw+3rby4indZDLI+KkCR9qAO5Tqio
	 8FBYblenLILE9F7b/RAGnlOIR8j3LFHR43uR2BBWrzLG9YtfMY4nz9/efFRwW/7Vhiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852327;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yfbTZZMDf19Tb4FOksSvTCcLwqkf0rDzaRcTZlPMclU=;
	b=5JegGrbEwZVebvHbW55QdDcR9kKy912EemiEp71N9OigBi950vpUgSxvNmjpngUefITA
	 gjfHXMG9Jx8Kb/2Kg41pKImQaQCmVwYsjINI6NagtCdzp1ReXczJPa3D9mGXVsjVQ+Y2o
	 oxmM2INV8kQUZ2jsxVnLu2jVPsdBlKN4xGgRT+ZPXxU9ojMWXgmKAfchtIqVYPF1DUMPB
	 nknizykfS1dYN1c5bQ6aLT+tgxyr3rLfVyMp3KLdG38D7ycjex/t8ifchb7PslibCXZXH
	 ptbe2h31O2ZSg1LuyEILilV28j38BiKazkhVKL0uJAANjOJt+x2plrao5IF7VriSkJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b="B/8j9lGt";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.24
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88644606A31C;
	Mon, 16 Nov 2026 18:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88644606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=B/8j9lGt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZbIfppICUj645vak6ps4sTB/gBQuS7SjxDzdszVxRCCbJF5KsIc6IYHdf3y/yo7U37QFqMgX5//bGg/UyskLLLzrhrHJhKhnUj7aY2LSnsXLurATL2Q1FmqpHv7IOTYfsxR4CHRka9SQIpB+2aW7iJd8bKAmxPDTAJop0i31I3JYRVLk1OhKnHrCF0blJJDUPiI9MA+t0YJ7DmP2JVuzXNTTSIRbVtYBZpbc46x+oxOyGWmmputzXiKFaYfSOA//HckgDhr4vGIjEDGATe2ztcbxuSVmXE/3kx/jybKQw6dDNAZxx0O9KMQpqj4uLnBnugaN63Q89qFFTjXO+4NpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfbTZZMDf19Tb4FOksSvTCcLwqkf0rDzaRcTZlPMclU=;
 b=d06bu2YZSOf3hkGzdkkDvfeiz456DDDJXYJB2kJStSY1ac66vf5FDBOXr6djl43KtNybxr48HbPQtDKKhhUAAnKTCVgdGKnyizOw9I04f0d34eNFH6VkgdoSNvH5JkfVi7qVjDIQtyUoKCxYyJPGRD+DznxrsrX0SYw/fLpkNOxMUlVn3++Ua/KMOL72mwXtNt0SPANSwsu+bgQn5vIexnnW12sGTNs9efeU2UEYqXWtQYh8SFwC6O/AnxI4DfnzycdR8ipUf+p5QiEZn0SA29TE7c0C7F0TX+ki3W5Z17J2VrCG9YIh+XvSLpBNYxJ6qb59CXcxDTgqJ5hYdC9MZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfbTZZMDf19Tb4FOksSvTCcLwqkf0rDzaRcTZlPMclU=;
 b=B/8j9lGtWAYvj1c7c5hMWilyC0Gk1oD3JfTs/qF3Rl2jer4BbsdEa+QamdNU90VEuZeYb6MaDOXxtwsQYhuJ+3poGIknsMSjp9s56t42qf5SDejTKrsNiyLryvsK7bFE1hlG0Gho9Lig0lNUIcn8UgKEuhDrlckyKMc32AqvXb3cJOof6qRL8Tt9RItaWTjqbtlKfDKAkuKTQa/XrCwKbsLfQq5DKqYxwbS0PVNDogOWb9sfeyWnfjSuqUwUHXmo2LTYHdjiUxb96+lMH+4D1sz8qUQQ9gGcYnkUk+8HhD90cxag5Hz/8czcquWMVQSUU6azy/Bnq4y8i2wToNM6HA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by AM9PR04MB8971.eurprd04.prod.outlook.com (2603:10a6:20b:40a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 18:05:23 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:05:23 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] crypto: caam - Fix wrong unmap operations
Date: Mon, 16 Nov 2026 19:05:22 +0100
Message-ID: <20261116180522.863479-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114060032.872141-2-changwei.zou@canonical.com>
References: <20261114060032.872141-1-changwei.zou@canonical.com> <20261114060032.872141-2-changwei.zou@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0049.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::20) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
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
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|AM9PR04MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2ed695-b002-4b70-07c9-08df440c2f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|366016|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	SR5kzZ7zJmtaKt37Dg0qCQemUJVF9xq22kHYcRP5aV+LPQvlUJsXt0mchEsi0G11mtOecUpj1i+JBG17I/yGKkyCZNXof+pVvnzY/YYSdT4/FZxytb01Z8WF0J385dlyKMFodWT3aC1auAWawbybJoeBWrSaZcbShQbgPjC3RgHgU36BhUqBQdXWah2VRwCGTrQluveWTbShihd/bdvfXV1rpZme4sJ6pduDKJ6DDRzIt55+SHrWSHkqHW2qqJDhXCz6lom6ceWEDuUOPDpsdDWxED/VgEb5LoQb0riJ532U0WkknSRuUMwt4xlt93Fm56kt9+XOGo/dd635lH6YdvdkcjL4XuqkDE9ihSCnhwmzGve6fQylPAR6pan/lo+Z48x45lVwZhMBO1pvVlvjZMjb9AQpweyOq2eRXWPqRKJJauqNfzmoycvHXzZbKl4xj94Wealktt0xhgGMhIruwvF5AQfDEz9oTIUiHvzuJ7K1A3E8BbLlxkJeM+qWWdKzw6ukxfbdC+z8bhJIuf06tb5iMTF1WIl8rgypJZHcpoBmKk6zhFAD3ROX/WWlBcUeHtOiqHUDPS/CF1/W52id1RZIy/bcTELfNAnNaRPlSqqfl2LfbhcKpLpdJo0PTvvpYs017Wye1lmO3IQluJDqQgbMzhiMvKYNDTitJGGLJpc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkFtbTNYc2ZRTWNvUWJQRjhxUHc4cnJHR1Q0WFNjOXV0b3pXWm9XVW1XVEdw?=
 =?utf-8?B?aEJlK2s3d1UyZHNiMmNkT2JqQ0wxNXM0WmR4enAxaFJJaHhUMEszMDF1RzJS?=
 =?utf-8?B?eFZUaWcxUlN5Ykk0OS9LaThobCtFb2lJYXVoLzVBMkpmZGt5dEl0RFE3TkFw?=
 =?utf-8?B?bHZoK1g4a1lndjNMTE4venFHMkVielZDOURMcUVmT1pvcE5LR3JsVFdBdjlE?=
 =?utf-8?B?cGRUSlU1UXZyUytNTm4rU005UVUyQ05RYndlZ0VQMmRBcnpCdzEraUk5NjlD?=
 =?utf-8?B?TXNUR0YweU9kbGJIOVczdTdiNHRVR0FyS0x0L1h3ZHYyMDB3MG82eHorZHYz?=
 =?utf-8?B?ak5lcnZYVGc2RzYyenFuU3FTYWdEWENpdm1vTTd2SkprNWd1OENLdzlseE1K?=
 =?utf-8?B?aytQOENqR0FYa2NHSlVRTG1aRHg1YkFRUlFjN3E3Q2hWVDB5Y1NoTWROVXRH?=
 =?utf-8?B?U3hvRXJGL0h3bk1Ubmdodm9rMjFITFNmcm1HTFU3cmFSbmg0QjZmZjhqejFI?=
 =?utf-8?B?akllRy9yL2NpZzZScGdjQ0pPa1VlWGZQRW04ckFVQ21pSlpRcjVjdlpvTnRT?=
 =?utf-8?B?QkVrZFhDVGhMMXBuR0FPRHJlQUtIVXJxYmRORzlxWEowdHVPam8zOUt1OG1m?=
 =?utf-8?B?WlR6aGk4ZjJtM0NJdDcyMEt1R2VJcXovMUhHS2lEODR0MEtQVFNiWXo5VDBV?=
 =?utf-8?B?WnRSTkp1NjhDRDNQRmN3M0ZCRy9EZE1mMTRDeG5SWnYvSmNFNjVaZGhwMUhZ?=
 =?utf-8?B?WEZja3JhSVdxZFNFQUpId0UvRy9TL0NTTG53R3pTRDJ4UjF1eDVlNlFNUDF4?=
 =?utf-8?B?MlhkZVdmaWxvSVlsMWladkN1V3d2SDBQYVZzSGxKWmVoK1dOSGdqS0o1NCtT?=
 =?utf-8?B?WTREV2hoaTBBNkpNZG1WbW5vT000dW1EbFJhTlJkRXNDVlBZNkF4NVpZUjBV?=
 =?utf-8?B?VzYybGsxN0JuS2J2NlRscDlUNFNkc2x1dmluNEpzSXNFcHNFSHJES05BSVl4?=
 =?utf-8?B?QS92RUh0Qm1najkwNFF6RGIxYTJUV0FhYTdvYTJ0clNNZ3NrT0NpVDRUam15?=
 =?utf-8?B?a2VTd2VDb0RUNndtYlpjdk4wSk1WT0xxa2V5Z0xoYWt6bUpQa05PT1UweThO?=
 =?utf-8?B?UFRsa1dSd0JzTjV4dklhUXBxQmpyaFZTVDlXU0pYS1p2RzZDc1NoUkhYWjR3?=
 =?utf-8?B?YmREZGk1OU9ad2xoMEdTclF0NHVWYXpPVFVwSDRObXJaTFcwMVZuS3lGaXBC?=
 =?utf-8?B?NDdOM2t1aEFOc0RZVDU5ZHJkbFJxUitmaEJhQjAvLzJ1cldhWFBLbUs0amRW?=
 =?utf-8?B?RDcvNjZCaXhsTGhpU2VLZmdERC84QmtEdGtYcFlMc05lcXVmeUFwZU1QTVlJ?=
 =?utf-8?B?bHl1VVdtNnRBK2FwbFBERDBJcEtsT25NQ3JmeFJvaEU2cjhYQ3BSalFycmhn?=
 =?utf-8?B?WUZsd1JmVDMyQnlaN0pUTEZwTUxGR0M5OGFEZTZaQ3A0NlI5MzI3eWMrWU9Z?=
 =?utf-8?B?K0xaUlcxNE50ZFRSMitlQS9mT2NMUDJidEVaUVkzUXI3NUhrb0IycWdhNktR?=
 =?utf-8?B?aGQrMjlnRS9NMGhSWlZoYndPN1lDR3dOMThGOUkrQjNnQm13U3AzMTZaNTh5?=
 =?utf-8?B?cjBQdmlwdE9QS2lkbUYwNWM5MitQc09Ma0RzUlJsQkFkcU1ZNkwwRzR1dnlK?=
 =?utf-8?B?SnVEakRjMVBYSzJFNVlDSXZpd0J3S1RMeklLcXNTZUgxU1FDbFBVcW9VeVhZ?=
 =?utf-8?B?aWplYUFRNExzS1NNL3kwQm5VMk5LZVZUWlZubHNWMVFNdk5NYSs4NVczVlNy?=
 =?utf-8?B?OHV5ek5FOExNK2NCdWlqdEtlcS9ac3JZbmlOc0ZYcmxRamlWUTRsT3dYc3Qy?=
 =?utf-8?B?L3hEdXluRXcxQ0hFZHJMN0FUeUUxMkhBQUo3ZXZubjNuWTFLUzNBNGZYVnlt?=
 =?utf-8?B?Ynd0R1V5NDhDUXEwTGpydXNRYm1iczBPTDIvSTNHTTBTUjdkakRtSlk0R0kr?=
 =?utf-8?B?RW5QdEtCR3RYRno4MGZIZlpZRm1TaEtFL2g1L3ZMU0J1YVpxZ1MrWGZWTTRn?=
 =?utf-8?B?dE5WYk5iUWxNTlJGUlU1bUdqVy8yTHByVlJtVU5Gczl4SkdUZXNoZmlUaFhn?=
 =?utf-8?B?RWQ1ZFJJb0w4aHZPTVc1NDVyL1JRUXJtcmdaOThQa2pxVldENTVhalAwTUxS?=
 =?utf-8?B?emM2UzFJRTRuRDBmbEp1QVl4R3FTL2tZbXJBb1ZXZmZZVVk5dlRRNDdRZzZo?=
 =?utf-8?B?S2RSZ1oyeVU2endPZGJOZTdyYjYrZjdDMlczMUlQdndmbXlOcU1aMnd4Y1pq?=
 =?utf-8?B?RW1MNC9tYU1tTkNFbW1Ddlo2UTlZZHlNRWR6TTd1bDV6ai96cFhSa0xTMGhw?=
 =?utf-8?Q?ADnUFAB6qP9TNx52PJSFNweNhqN23qAxZW4OD/i4HrodG?=
X-MS-Exchange-AntiSpam-MessageData-1: ddLjp+4XVQWWmw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2ed695-b002-4b70-07c9-08df440c2f65
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:05:23.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1iqgY/IOFMPd/PwK9UAFTpAq6hnWUgOn+Sv50jgx8iAQws0sr/X3L1ZTnr5qR83KoeGNKe9X7uHoKYGBmluKnBhVT14nn+yT6SZVAcAu8yoZ73B+1kweUrBz2GbjTeu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

On Sat, Nov 14, 2026 at 05:00:31PM +1100, Changwei Zou wrote:
> Since priv_form only takes values FORM1/FORM2/FORM3 with no distinct
> public key enumerator, rsa_pub_unmap() was not called correctly in
> akcipher_do_one_req() and akcipher_enqueue_req().

Hi Changwei,

Thanks for factoring out rsa_priv_unmap()/rsa_pdb_unmap(), looks good.
Since the code changed after v2, re-confirming my tag on this version:

Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>

Thanks,
Sahil
