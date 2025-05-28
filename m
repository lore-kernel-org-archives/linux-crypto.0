Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010051.outbound.protection.outlook.com [52.101.69.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2053D1DF98D;
	Wed, 28 May 2025 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444509; cv=fail; b=GfwrJv8HG5AUmyL4mPjH6hgFIglx+YPL6GH7z62LAT0aqMt9XNrto1mTN9+jta9kIvsd5tqT4JK7pSEGxsCaC8YXZNO8WXdaLtqH4toGMyEVsZuCgpr8iS4dNNF97Yh3jVl6rsVr6okK8p0P5wMh3+PC33kF3TKw1vTts1muBoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444509; c=relaxed/simple;
	bh=lymmOo+0loRXqQTgjbWa8JL31ZwvMWIL2B5PPoik74k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jT7pg8kMh/j5Tx6aWqeLZVLTZgA6TFZL+uMcmPgBeEaV284cMdvREjNwzIgaiHB+iGJU7E5Gq4xNT3lZnoWCvYa9mTNACAg6UPiXnzQxapVK33KOxR21EJsWLowhD2rwNEFvlHrPcJLmCmScT52DDbUvZzFSCAku0xGQsxHfwQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=PgF+hwDd; arc=fail smtp.client-ip=52.101.69.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="PgF+hwDd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5gZmQnbjRjzh11nlN6KRuHtqcLxEPGKtyPaDBaBZmDYFFU10mwtzon+GvWcYoLgHVhMSYyOfvySKH5PifLKxb7/grPI84osOn8IXiUWUhOnTp2tWl69qCZ1q7e73AnR629yEIupIicg2XhzfhHvir3YWAZnKuII18bpFVf2WXXV0uHJLRi5ssKznPROGTdArziyhaq7ALBQinE7+H/r66sQepdeTAz9WOuo88cHuUqOzFbKCCSymU1EV93OAnQKFNPBu+7nqZYw2v9bhMbeUfe1HqfsSACfVbp75sWrYIyIVtj8NvjcCcX32zGOetRgCloexe8i/eYRn6zHa2EGQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sjfUW+ZcXX4x+xhmDE5Om1Vg9AojvW+UmIvpD4LNmw=;
 b=jXmllfW1Crg7wyMJTqFmOv59RX+DI69WzIfkAhtPiFofjX+Wej4YU0ig79J2mcLUO3gC9ZXcym0oqo/l1pXYK9CRRxSFI4aVBuo3T8olZXmpZax428umcrjlekSne55PSEW9rvQUX4VJur8zloxsK4631y4yyUvIHXVF84b5zXnBzprKedXRPWt0RkwH7UGbnnvAuL3a8/09AnLb/ROtPKjXC2Hiw8Xhjrjma2uD0qabxhTue7BtnKDM6jdorcMbO2dWPeFETQI+RwRvgmiOB8T8MeQ/EyAl7awrTYZNHutueMqc62amxy4l8LBa/lEyQxniMrAfx4JsZl5Z1lKsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sjfUW+ZcXX4x+xhmDE5Om1Vg9AojvW+UmIvpD4LNmw=;
 b=PgF+hwDdQ+kbtFezvqInq2V5e1FsPhjOe9NeWxrzqebr+LFRhhQnHILsFkIsiMwHqTEMLt4goLRauuBq8hzB+0EpRSgzsH6pecbFtz0siEUImdA8JDDjUxy4MfjAZ2Ue/dfe2NIUSw3mwTTTj258fswXUw7P5/0/GkctYXD45fYlaS1qJH6jwwfEALRKjCaUBdgUPSaeZ3gU7e3NyJemdL/cFbuwkIXZdXX3ch7US7UdG9QKhTI9UZkm3pT3wqc4Xr5pKrHT3ZDbSR1lL7El4oRZc/bE7LK1V7UtlKjx3xSmX2Jhder+Ihs5igiLj0063FO2IiHlZijy9QMzJrR2Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by PAXPR04MB8960.eurprd04.prod.outlook.com (2603:10a6:102:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Wed, 28 May
 2025 15:01:44 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Wed, 28 May 2025
 15:01:44 +0000
Date: Wed, 28 May 2025 11:01:33 -0400
From: Frank Li <Frank.li@nxp.com>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Message-ID: <aDclTQ8Z5WcHMxgT@lizhi-Precision-Tower-5810>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-5-john.ernberg@actia.se>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250528144259.2603914-5-john.ernberg@actia.se>
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|PAXPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eea6d63-1b11-42c3-5de7-08dd9df88f46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|1800799024|366016|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk1PLzlrR2ZkZlJ2c2pwakJERE5BUlVTbFpyU1dDTWVWYVUvNEpSeVY3aUZk?=
 =?utf-8?B?UWNVOXhCTTdJOEYrSHhqZHk0S1lmQmtlTm5tZWZTWENtWUZUc2xraytlbDkv?=
 =?utf-8?B?MzhmdDNZc0o4WkNpc0tCc3ZkaWpOcmtxYUJIN012ckIzanVGMjd2NStXcmVN?=
 =?utf-8?B?NjQ4WlJidHRndU9rVVAxeC81WG1Gd1BXWm8yeElNbnN2ZForNzNHK2dVUmdk?=
 =?utf-8?B?RGdxNnJqL09SN1l1L25xUUR2c0ZId0ZDQzdkR3lJeStmV0dFMVlibFdwVXoy?=
 =?utf-8?B?NzFHdUVnY1JtWnhMVTZUeHVYOTIzMnVPTDcwc2tXSjRwektIaTFIV00wQlp0?=
 =?utf-8?B?RUozWXpFeU1kVVlpbXZVVWd6OTMwNHhaVlROa3QwM0NTNy9XcGRkYzlXOTQ2?=
 =?utf-8?B?SWJ5T3E2NndxdDFtbVQrOGljaVNZUFUyQ2dDZzVBblczR3dEd3lwVnhYWWwr?=
 =?utf-8?B?WTYvbkdraGdwSnA4R284cUMrS2tPWlE1L3kwRmg0UjVCZ09yY3RMZDVJNkRP?=
 =?utf-8?B?UEM1ZUdYT2Z3djlmUDFEay83YkxrWXBaZ0g0U3RHQXI5bGowWjExbFFleVBW?=
 =?utf-8?B?ZTFFR2dLQlhSZjlBREZEWUk2aEhwMWY2K0s4dzl3VDZwczNUOHZSNExjSDJa?=
 =?utf-8?B?cjRDb3p4UDNJWGNKNy9nUEREODArMWZCY1BSY1ZxSFJFWXc0dmF2ZGpIb0lJ?=
 =?utf-8?B?OCtFdHhDaXQrNERCbEM1emNoSTFSUldLY0FjZmg2L2FEUU1sbFE4VThpWUo4?=
 =?utf-8?B?d1NmZXNvUksvMTlHTmg4eWs0cUh5VVhpTzZrRk4rZmx6aXg1U2QxclgvS0tu?=
 =?utf-8?B?QWZKdmFnWGRZN2t3V21Wa290Q2JPL3BpV0NjZmFmTDBDQWMvOFVSTnpwK25y?=
 =?utf-8?B?Tll4a1lmOWZnUHpKbTc2Y00zSWhiOEVPbmgvSlZaLy9XdUJudzlDQVdoL3d4?=
 =?utf-8?B?a3JKcnpqTUZyVU1rSGxla2U4OTkzV2hkNkRYODFWVU03NHozMGN3ejUzSERr?=
 =?utf-8?B?cVVrdXhRS1lMdXFNVXczVHFHcm02ZWI5c29WQVhySllsVEZoSkR5YVVqYVM1?=
 =?utf-8?B?SHNGRGc4TSt4NW0yQ09IVnZiNG1aVEQybzBFWTBHS0tvTEJrTFY5YUd0R3JQ?=
 =?utf-8?B?OXg2MjF4MmRtUjVTRTU1S2pzQStkZ2tITVN3RldYdy83eTdHRFhzb29FNC9j?=
 =?utf-8?B?WGREOE5qaVFMMkxiY2VieTdzeXVocTQrcGxKczZTdldGMFJDZmR5NmZDZVBm?=
 =?utf-8?B?V3NyRmE2Q3lFcHhSM0NWd2NQL25rcGpFazlsUkNPK1g5aEJhNlI0VWV3dVBi?=
 =?utf-8?B?Z2E5STEwUXNZNXRXdmYwdjBnazZIM2NJRXJ5bW82TEFtTUFQQU5Kc1NnMlV6?=
 =?utf-8?B?MFh6UDZ4NXdDQW1kMUZmeG5IbEhHamliUjhocHJjMlBaTkp0NnJWZi92UVl2?=
 =?utf-8?B?NjNHcGFMUk5ucXlRWC9FeFJYbTZVUUV5cGdpZ3VGUThDYkxsQ1ZFQytYeHlk?=
 =?utf-8?B?S0RieXk4cXBjeiszc1VSeUpSbGlMZEdGVWRIRGVoYWsyNm9LREVvamN1UWZ5?=
 =?utf-8?B?aktnSWNsOUozZERaR3ZOKzZXck1YYnFWMHJZVU5DSnVEdXIyYWI1TSs5ZlFq?=
 =?utf-8?B?c1JhQS9iVHVMQk92TjByY2E3UG5jU2VJRUVxdWtwMVg4eUcrVXVPbUVPZWZT?=
 =?utf-8?B?MmtWck1kL0pqVWtGU2lFKzNncmdGSUFGUHZ0ODhIZ0QzdjZGSkoxdTlhWlI1?=
 =?utf-8?B?YlJObDZxTUdaWTg2QzBXUUhlYUhoVzdicnAyVFVZbThkd1BTbk1aSGk3VkVS?=
 =?utf-8?B?M3pTdmg3UlhyTW45aXNqdzJBY1QzWDJJL2xQMWpGRzJkUTBpQUNCWElTSC9F?=
 =?utf-8?B?S3FlQnVLUW9rdGhVVFdvSzB6VVBYbXJKTW5vWElKMnFqTCt4WUNoWnJpcnBj?=
 =?utf-8?B?SlQzazExUFRrYWVGRjdSRjBUcVlOTUdkSXQ3YVYxM3J6ZHNiVnRqYkRWeVZ3?=
 =?utf-8?Q?9DZ0e7tH3X/XOxoGkaWWwlGyXC8M7k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(1800799024)(366016)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWJZZjdtS1NNK2pLUXQ1bXFmKzBKY2xBbWt6a1drdUtBcE1OUC9NbFdrNE1W?=
 =?utf-8?B?djJhM3FBU1ErbWlSRnVYSi83NHNyR1dDV2F4S2VBcHhuNmVqSTFJVzNBbFVL?=
 =?utf-8?B?bFNYaEhOeEpPSU1wTjVsdzV1QXh3UFJXOWQ2T3pLejRIQ1pzSTdlVW5JaWk5?=
 =?utf-8?B?RjltSzJkRTlwWkExSklBTEg4dU13KzFBWlpxWSs5RkxxZkN6djY4dmxMZVla?=
 =?utf-8?B?blRlSFhIK3lxa1lUZ0xjWjVxUGIzR3ZzQjVpMjdOcXZGQ0tPZGNkTEQxbUhl?=
 =?utf-8?B?MFoyTWcwcUlDTjRPN29RVGtxTTFIU1dqck13VDJQNjZjTk0yZFczZXJiMHV3?=
 =?utf-8?B?UGJSZVBLdjNnSmFRVktwa3ZpbUl1OURkdTBNcTl6NmFCY0JwcStRN3RNa0tB?=
 =?utf-8?B?T0dIOWk0bG5HNkQ3b2FTZU0vT3JGVk16MG1wTXVQWGo5Z2ZFdDJyRWlWUHZ0?=
 =?utf-8?B?aWRoU3lQVW8rclFaZmU3V3A5K0htK0pEZi8xK3ZPRlVqK09pY0NzTDBkSTFu?=
 =?utf-8?B?SnVQSDlLT3JyRHY0KzB3WlFJZjJtOVJmVHhSd1JQTjd0WkZNbnZVVTNUMlNN?=
 =?utf-8?B?aEhXR0JVNFpxQUNDUWdDZlUzRmZJTytsZlU4eXRjS3IrMkhmUmo4U0dVK2Zy?=
 =?utf-8?B?MHhHTDdPQng5TXdDeG1aWUhGNlhVb2h2UWlDR3UzcWtaY1RlRUQwK3ZIZE16?=
 =?utf-8?B?MGVxNEN4QWhrZlI2cnFTT2RoNXllWkF1cDlZaWYxYjRpYlcvUzVoOS9CV2Vx?=
 =?utf-8?B?WWRmMk1NVDFCekQyeTlOVm5FeGNTSTZLL0tYbEUrQXRhaXJSc290bFRsS21J?=
 =?utf-8?B?ZGNkbjZzYXFTSTVSbk5pOUtyV0EwTG44VlRmOFFGSnBvRWRQU3J4RGppbndt?=
 =?utf-8?B?RUVVUERPMzJmbm1HMlZLUDhtd3pIUmZXb1Z4eERQK2NTQlJ4VG9weFdUNUp1?=
 =?utf-8?B?U3ZSTXBaTU54WFZCcERGejBiTGo5Q2xoaFA4eVhub2NsYVl4cm1mbmVrTWFT?=
 =?utf-8?B?dnloZEhvaTBQN0RBVVU3ZU9sb1YwK2x4dnhyaFBNNmRBQ1BaNkViQkd0S25w?=
 =?utf-8?B?SWJkQ2JYaGdIY1FCMFpQaktodFJlblIwNHFuSjlMK09HM1l6SHV1Zndnb3VK?=
 =?utf-8?B?dDFFUjA4WGNTUFg3b2NGYlR6WFVSVWsrUUVvcFpPYlZuRW95SXpvbXU0dkVy?=
 =?utf-8?B?eTZvR00yU3JIWkozUnNoTHBuUWV5YS9FZi9pYUVDYjIvdldhbDBSMFdSTlhH?=
 =?utf-8?B?NVV6ZzhmSW9QMXB6Y2tOUWxhNlNHUFB2SFZuTnEyalUyMFZIRFM0TGs3Q2Y0?=
 =?utf-8?B?cGF3QUJuanZ3U1NaV0RUOTdPaXhtYVVUR05BQVk4WXlhbTJmcVNNTm5HcHo4?=
 =?utf-8?B?QVdJN0FVK0w3anNmN2xscWlJdDJDZ3cyN2x0WGZCMnJlMTgrUSs0MXBLL3ZE?=
 =?utf-8?B?SUF3M3hYeUZRY3lKUlNPWHRHTmkyT3BnY1JoS3RTUG9GdTNLbkNveFZkMTRr?=
 =?utf-8?B?S3NycERQU3AvNktPWFRmd29ZNjh4ejR5ck9RbjZTWWdvSWIyMTdneEIrK2th?=
 =?utf-8?B?STJIV0FLRHpxUGxWOUIwazlEUkF4cHhWaFM4dkhzc1dRODJiU0g4bnlmZkFP?=
 =?utf-8?B?ekhaM01Ub2ZtOW5vVCswcjFIR05rNWRVcDRlbWkzSkprZnRQMUtMWGpBUTBJ?=
 =?utf-8?B?ekJNT3RvOGQvdGl0c1lHMzdjREJ3OGV6cDFyVmw3UlRXbFRodUVSc1JzVEEr?=
 =?utf-8?B?dElhWm1EUi9RS0s0M0xEcTExMUR5OXhJUlo3QXNoc3haYlFwM3k5WkNJQ0pa?=
 =?utf-8?B?UHFRbURNODV4Y3RlUW1jd1FKMmx0Q24vL05HZUprMnlaQXVGVWFuRWZocUht?=
 =?utf-8?B?VE1HbzQzSlJkUUNWZldFUWQwaUtIWk5UQWlhS2FYUW9GSTFHR3hnZEE4SGFW?=
 =?utf-8?B?VHhvYnl2Q2VRdVdzdy9sVW5vOGo3TFR2QU9QVmpkK2ptVUhHV2RSeFMvMTll?=
 =?utf-8?B?bDZUbE9iL1lGY2M2TDRRa1VFMXkwVWJSb3cxdkNFMVBjakU0VC9KMmtWb1BZ?=
 =?utf-8?B?L2VteXU2Ym1iVTErU0NBWFZFZnhZQThaVGhXdXU5d00vZGVGaXJ6SXRIMXFN?=
 =?utf-8?Q?Y8prAaZuEU6iqyXrv5lxVZpgZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eea6d63-1b11-42c3-5de7-08dd9df88f46
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 15:01:44.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbqM0TWExjEGsB5wdkoJ/4865mhSG2PXQkcboypvDX975Z2Q73oiWq6ao5NLv6rAvTWzQDPBqe/eaOSnlyW6NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8960

On Wed, May 28, 2025 at 02:43:08PM +0000, John Ernberg wrote:
> From: Horia Geantă <horia.geanta@nxp.com>
>
> The iMX8QXP and iMX8QM have a CAAM (Cryptographic Acceleration and
> Assurance Module) like many other iMXs.
>
> Add the definitions for it.
>
> Job Rings 0 and 1 are bound to the SECO (Security Controller) ARM core
> and are not exposed outside it. There's no point to define them in the
> bindings as they cannot be used outside the SECO.
>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> [jernberg: Commit message, fixed dtbs_check warnings, trimmed memory ranges]

what's this for?  remove it if not related with this patch.

Frank

> Signed-off-by: John Ernberg <john.ernberg@actia.se>
>
> ---
>
> Imported from NXP tree, trimmed down and fixed the dtbs_check warnings.
> Constrained the ranges to the needed ones.
> Changed the commit message.
> Original here: https://github.com/nxp-imx/linux-imx/commit/699e54b386cb9b53def401798d0a4e646105583d
>
> ---
>
> v3:
>  - no changes
>
> v2:
>  - Use new compatibles introduced in 3/4 (Frank Li)
> ---
>  .../boot/dts/freescale/imx8-ss-security.dtsi  | 38 +++++++++++++++++++
>  arch/arm64/boot/dts/freescale/imx8qm.dtsi     |  1 +
>  arch/arm64/boot/dts/freescale/imx8qxp.dtsi    |  1 +
>  3 files changed, 40 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> new file mode 100644
> index 000000000000..9ecabb2d03e9
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2019 NXP
> + */
> +
> +#include <dt-bindings/firmware/imx/rsrc.h>
> +
> +security_subsys: bus@31400000 {
> +	compatible = "simple-bus";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges = <0x31400000 0x0 0x31400000 0x90000>;
> +
> +	crypto: crypto@31400000 {
> +		compatible = "fsl,imx8qm-caam", "fsl,sec-v4.0";
> +		reg = <0x31400000 0x90000>;
> +		interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x31400000 0x90000>;
> +		fsl,sec-era = <9>;
> +		power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +
> +		sec_jr2: jr@30000 {
> +			compatible = "fsl,imx8qm-job-ring", "fsl,sec-v4.0-job-ring";
> +			reg = <0x30000 0x10000>;
> +			interrupts = <GIC_SPI 453 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +		};
> +
> +		sec_jr3: jr@40000 {
> +			compatible = "fsl,imx8qm-job-ring", "fsl,sec-v4.0-job-ring";
> +			reg = <0x40000 0x10000>;
> +			interrupts = <GIC_SPI 454 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR3>;
> +		};
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/freescale/imx8qm.dtsi b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> index 6fa31bc9ece8..6df018643f20 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> @@ -612,6 +612,7 @@ vpu_dsp: dsp@556e8000 {
>  	};
>
>  	/* sorted in register address */
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm41.dtsi"
>  	#include "imx8-ss-audio.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> index 05138326f0a5..e140155d65c6 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> @@ -321,6 +321,7 @@ map0 {
>  	/* sorted in register address */
>  	#include "imx8-ss-img.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm40.dtsi"
>  	#include "imx8-ss-gpu0.dtsi"
>  	#include "imx8-ss-adma.dtsi"
> --
> 2.49.0
