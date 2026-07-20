Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010005.outbound.protection.outlook.com [52.101.84.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C8934A794;
	Mon, 20 Jul 2026 19:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577235; cv=fail; b=tQZHndrb3yTHHsbWHHlcZZlWKQ7asmuS4u8ZFVHdovanmzFD7Mqo4djZq0trmCH7cse0OdilJJB3pwH3qHCSRlCUycBy3Z6ok/vIFLey3ozAjI58echGUG9vnQsXMLO5MGZHkahR7MCLHlkZK40S6X2YwP12NnWt4huGfWNZ6pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577235; c=relaxed/simple;
	bh=3+VgoBmggbAcrk8hwtYnMAAQgWditUSo47cvlRCguEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aCiQJ+GJaMcg7jCief8l+94r+Z9JzAJE5wrSOrpsZNCS0QpMu1WwTPusu1LVdaam93GvDhJjdhndan2HgJCYGfS3M043MZDFCMkhAYXfOnuqD6/sumTasWLRcdhlsPmF4UY24YG4YlLVNJ2+VFLW9luv7qEpvFWyt7yyjOtUfDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=fail (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=amo2DfQP reason="signature verification failed"; arc=fail smtp.client-ip=52.101.84.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="amo2DfQP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etedaOicgVrrOk3L1UL5ZLSIdl2k3W5Ua81BMUyOMJuPMUN7Targvxx1oNsN9/mR9zVKLgU/4UZYWpvxg2xAekT48UH7DSFVM2k/TFGR7TXqkF/Th4kKdn3NDbLWbsMsGXFTGbgZ+Wrs7XVny2NyhHiiJ098EYiqOkMivEvnEG8EDPAWgYghSd//HNB7/+DgPmbYfOYh20OqOwV8kBFlLuc/ytCK8DOqVLVaXFM+vdsYQU9ijHc1iA9KO+3jpDyn6GrkjCVDPqcEg0DsSrKo/yDD7r5U8sfjujlw5oZOmTrcQbCPHC8x5dt3LEABJA9wXAw2xoyVObqLOKco46BL8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eASXw8brNXX5WtpSsbpnAp5fFggx5dOLFbYa4NTQw5o=;
 b=ko6gmKlk7AZqcQ/mNMAzkqpxEEIoE2UXpQBy4ppzhZB4s4yd4FwOOGA43uKGlWcis0jJrpuUkX+YdckZdA8wX1UTXlyIHTmNDO1bgs0zDkM/miyZlMJrcrTgWZX/7D9+Y9FDIwZ2IV54gdp+3XhYdVdA2x4ZWXDr57EWbZZVUJe9BIbnmb/aPEThkZX/n6cud/CPkchqYCwNUrk9sr3Isqv8ldQ8EMO4LiZoSKa+zvMMjLneAKtzPRAypYW9oAfmTdRk9nuShN1IuJnxPICeBMjZZoHtKMvt5G/1N+JsdaGZELjzRjdr+k9QnfPpszlwiMdYze5FfRKX/FP+A8yFIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eASXw8brNXX5WtpSsbpnAp5fFggx5dOLFbYa4NTQw5o=;
 b=amo2DfQPIoezWoSqfVoDPN6ebXzNC4FaodNIT/xxhC3QwaR/mH6CX3Z+jviK7GOYaJynQDYXblrYlgbCxglUtuxw/v4BgCwDrhq2t7BFSiJ70bLFRiISvEKzLL5y9N1sDWq7t8CRjQjrBqu6nP4unk2mRu0HK8P6RAL2AUAxqNV+a89FQhCWTg9CeH2rZvLzy+x6WXN1nz/qkaXeAZG2aHS21DgfctaVH5lsJRI7kztGmfhIA4Is52ICO945hWKnFKE6IDvOyWyIHVoPZX4jjViFxQb2wKP0aBc+OuPFrwxLZ5Xw3l+Nrz+98XpSJci1W73t7/cJXNSdnNnx7ioXig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by PAWPR04MB11707.eurprd04.prod.outlook.com (2603:10a6:102:509::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 19:53:50 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%6]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 19:53:50 +0000
Date: Mon, 20 Jul 2026 15:53:40 -0400
From: Frank Li <Frank.li@oss.nxp.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Stephen Boyd <sboyd@kernel.org>, Brian Masney <bmasney@redhat.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Herve Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
Message-ID: <al58xBD6B1i3Yt3S@lizhi-Precision-Tower-5810>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
 <acqT3Dh03y3JiLLc@redhat.com>
 <87y0j76p8o.fsf@bootlin.com>
 <177595635458.5403.1619739189587608339@lazor>
 <87jyr3gjbe.fsf@bootlin.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jyr3gjbe.fsf@bootlin.com>
X-ClientProxiedBy: SA0PR11CA0102.namprd11.prod.outlook.com
 (2603:10b6:806:d1::17) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|PAWPR04MB11707:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ef09f67-4dfd-435f-e35a-08dee6989e49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|23010399003|7416014|18002099003|22082099003|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	f6RmAJmRWQOW0K+u8L5EsxCuEI3IorrYYI9lAkk499pZXnhUWu5IHT7OykBhVYYkvTNwFNib+f4AkFdLBLJbTQ9OLSNjGzwQyM7Yao10Ap2RToKmU9IYynYBWICf6Zac1pag1iZ5/pCOG2B+aop4Vlp16wterWslFjzHt4QF02mkstq6r3D/t8Z+lBctvjsEW38RBwa3hhNdEBFgePqslEx4hSdyDgku+zC2l6SZU8Jsd8V/PmOhAb25bUXrYkVbgQXPefh9HSn8kxrOIeN6kWRNAa/RmNDZV1+gZ5dRfBvGcK7cryUprHY3elHFtV5fVzZdgusgJHPmN64RJEXDhbIRfHidwnF+7/3z+nGErsNnkkWhiFHagnmxQol9C9/WFWWlaihgSE5FCsFu199OzvUoEbBPTDjMtmfj8ScigLCOXLI/KrFyhW5zeb7A7jRw6twTrgOgUqTPB9AYFrKe7kVmWhBGGDWb9owxNpqQv8PYuePVS5RJ6StWBlNsQ1JYKP40p84maj6LABuMvH2A6tEKvTrMGKEIW7ovAhf626fyfPG+KCo8GbKl7AbnWJZyomjrTS1Op5ct39gP0yOWZUm3dQsjOSu4Jx6zKYbeyQ4wnHw3P7RZpVhncMR0nrC0Ld6e2OTUcYrZX6/khyZuKdVBrNzY/SlASKvkhO3HVgU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(23010399003)(7416014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?JwT/UgKdPgz1XeeWnyI1OjRlxXFcDiI6OY+sHtJHhYIkQAX3IZjM83820X?=
 =?iso-8859-1?Q?DXU0ULj1dfNx1ctWs493tzDE+8Ot+gDIKWk76AX/ghI+ML6H6ng7YJkBqF?=
 =?iso-8859-1?Q?n7IYCwOG/U7pRt8VJVxRf9c0+B0B+9BuykG1Rcunb8pep/VP1aqA7hyZUS?=
 =?iso-8859-1?Q?t6ds9/P/bZjIQvwLVaZK321iEG7n1RnRTGtOU1hu77mHwocDRQ7Rf9xSjK?=
 =?iso-8859-1?Q?b/mu31jMRlMLv73Xk5UdX3vMWSHZ3wlr7r81ERblWYqpoDymcCkLSXis/M?=
 =?iso-8859-1?Q?EpzrC/WCZLHswN/jIB7momczcxT+WpcPGfNN8VKD2atf3rzBGqNBImH3Up?=
 =?iso-8859-1?Q?+oEXuvJ9BM6UBNIBgg1n254hJ4utg/0c07MTkt7Uvh3ggRFPI0xPreAiVc?=
 =?iso-8859-1?Q?Vn+CwDOqHojAQMTcvynhy0XbnvVDlWVv0MPxh/m0IBiLvMIfY5PBYZRnoM?=
 =?iso-8859-1?Q?j7k+R+lPEMhP7kZ4GVxgvM73EZodRH+6xVMDPgE5nWERE35fh+J8Lj4tS8?=
 =?iso-8859-1?Q?a3MVYBLR8UFYXPHGqfzvd6ch6lCCiKFGt3ooRZottsHExe1mfBCFCwVHB2?=
 =?iso-8859-1?Q?lzoKESIgZghe79eUIqJKnC9kPMGLp/TAKL6Ejax5AHYByj6m9sqtUvX9Is?=
 =?iso-8859-1?Q?Zi4vCd8OsvJveBrsAcKerY5BzbHgC0nabkP9D84X+5sXSewHCqCZFlTWNO?=
 =?iso-8859-1?Q?DznsXMnk3HZrhU9AzdAlkZAxE7Cu2nCMt2EYcTJvb9mMZrpCzlVYniwHzE?=
 =?iso-8859-1?Q?wUfpIH0Y58ls1rpNNWqjcgOx4ndGoX+VFAof5mbqiSu1HZrF7nJZrAsuBE?=
 =?iso-8859-1?Q?XmMJKrqSlJH4y+uGNR+BudSjhiHG3khy6ysE8hac5hOl+hUZM6x1M65w2Q?=
 =?iso-8859-1?Q?LA41qnJaGI/r6lBB2Mg0QknvkG7P4KKl3ZctXm11MV1z6LyvGEKH9l0w2y?=
 =?iso-8859-1?Q?Tjj2IzxsJ1aAz4WZ3Zhy0TAtX/IDIyIzjysm9hFT0xORSJzI/qq+wsXPwR?=
 =?iso-8859-1?Q?kq0qEZALX4XPHKKTx2YrHF26yQynXSDvxd+dxRXWWjwjdHnj5tBLZxhzAM?=
 =?iso-8859-1?Q?Ctm1xDXTck2hTJiSRkOuPu6VfsslTuv2CJnQu/GWwKd+M5c9N6t39Tggzq?=
 =?iso-8859-1?Q?77kOmHyn98XwuxKbAY3I8S15v/zc3rVycxb23wWQrMwkzig0Uz39v1CGfF?=
 =?iso-8859-1?Q?3zDL8t/zfwQ3q1uQleb1ea2/a2I3zuB7GbTK53k34lNsVTcO6FquDVUmRw?=
 =?iso-8859-1?Q?jYZiBbD+tZEBNZv77VLQY5sHr+HipsB6lU2lU5jWILgVjfhWJIpzE/pTOd?=
 =?iso-8859-1?Q?jUDeBgtlWPJTa68kR/Umy3n2TRL89qMJ9YvFTHofcrD/dm7STJthF84fgp?=
 =?iso-8859-1?Q?P4neZ/Cy/5QLzeJXKAtjt/GZOY8AORX+bx+3vyZQ+sC3O6BPatoFO7uBej?=
 =?iso-8859-1?Q?i1XICeoMACKg5fKzsPllTI5VDFn51jBvgKu60LlWFFFU53gnvsc7vXYsOz?=
 =?iso-8859-1?Q?i/pxt9AzCcjeYkloq4OdgGDMoIjbDFi3gqQ459A4te2vuu36CLIrPII8eZ?=
 =?iso-8859-1?Q?KRb7f7nGnULOMXMC451BHXHB6IxhQ9V2soYKiwuZ7qsz1x15uAXdeBnOGj?=
 =?iso-8859-1?Q?m6K58ZM/XwPFuwnHiXCOCS0R65Ycw1Aj+ESpVdHjdFUCtjQE/celinIQF+?=
 =?iso-8859-1?Q?UPkSDKL18IvybPfv0WOI4VyU4AhQkvZVw4umoeUdxraWAShZ/ekNelXZWm?=
 =?iso-8859-1?Q?WnKcb7K1aMPegMC/zyHt03Tcef2OwCDk/kmvJmJiSkVcGEvOGPU5mtIaTw?=
 =?iso-8859-1?Q?cOcJifcqAwBTJOZVj0zG0TXRVOkbCVRE99ufgDaTrRSdqlt1JmeR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef09f67-4dfd-435f-e35a-08dee6989e49
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 19:53:50.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAt00BCde7xxKQPEvrjV1ms6aoR5j9qVEnO2qayaQtligVNtMHq7XcEZJwqZBDez6jeDA1qiYy0iRbQOInzyQZI24YZ3kXOBKecPFvk3eT2c7Bi20SDjSDs7JpYNBIXO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB11707

On Fri, Jul 10, 2026 at 01:44:53PM +0200, Miquel Raynal wrote:
> Hello,
>
> >> > Before I left my Reviewed-by, I should have double checked Sashiko. It
> >> > has several questions about this patch. The first is:
> >> >
> >> >     Are there other places in the clock framework that need to transition to the
> >> >     new map API to ensure assigned clocks work?
> >> >
> >> >     For instance, assigned-clocks and assigned-clock-parents are parsed in
> >> >     drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a device
> >> >     specifies an assigned clock that routes through a nexus node, will it fail
> >> >     to configure because the map is not traversed?
> >>
> >> The goal of the nexus node is to isolate what is behind. Are
> >> assigned-clocks et al. supposed to traverse a nexus node? I am tempted
> >> to say "no", but I'm open to discussing this ofc.
> >
> > Why would assigned-clocks not traverse the nexus node? If I'm a DT
> > author I would think any clock specifier should be routed properly
> > through the nexus node.
>
> Ok, giving this another thought, it may indeed be relevant to apply a
> default frequency which needs to traverse the nexus to be active. I've
> done the same change in the clk-conf.c file and tested with a dummy
> example, it just works.

Any progress about this? we are trying to use it at

https://lore.kernel.org/imx/20260629074734.3643227-2-chancel.liu@oss.nxp.com/

This is quite useful. Is it possible to split clock part to make it
progress?

Frank

>
> Thanks,
> Miquèl
