Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010021.outbound.protection.outlook.com [52.101.84.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A762FD691;
	Fri,  7 Nov 2025 09:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508384; cv=fail; b=fP12TJ0g/PW1ETv+IIMnYTrkE3DhWwb1BkW7MFHPK4p6f2I7FWxCDYTN0wWcVhZkGVv3Vv6/r8EqZreJQDfM3mSjKDhnb021xcJUUumo/2Uu8L9HRJdShIdkF1/wY6rI/Vyek7pk+yu5E7reSr6xx7z6imtcsG6Xhjim4AfAItE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508384; c=relaxed/simple;
	bh=BJlydVjP6cFvSj7kDkDOXgmWBHTjytj0FEcxhT9sNmg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mr4V9clUdQMoWDbTWbm+rTNI0xF1txRm8nefSwjnKsbNULAJM7PvhSrpUk+3SRtY8tXCuLzYSPxsa+zBkYHb+0jsD9YypHNLc986Mc2Exj73HRJK4LR79gLx1MOQ0J6sni66f4tp742fE4ksZ3rqGON+WIMJKFnZBpK8ffyDgt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=DeVUo5eB; arc=fail smtp.client-ip=52.101.84.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="DeVUo5eB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVcdrsCNoEQX6LoppphbbnCtQpvyg/qeCChLxctf80uDiW+cVJ9XofIAhIBk0PVeeUa08aQLUuV6I37c5YTdAJM9HOaPHXGe/4z3i+P6BR1v89HM1VhnQrY1tyDOrrIUo/CzObQvMVmYrgD8iHtPhkLqJlia8xu+vX+tPnijZoRsbINtpLzESzPOBeanMnXOdWK6GPMDGYEAQxQkkiLq/B9pZdRaty5dP0H8wnht/fh2bgJPVGT87ZNHTNkKdzNQ76jxueQCsEI/Y8wCgJ6oPzUcwksGa4rmQSoJ/6Cd35lSrK6at6mAgEXUXQRxzFcQsy6CmDs8cQEuJvPLhn9m8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbLAGwv5apbywanuU2A2GkL5nILXL3ZLe6fTst3Dc+Q=;
 b=sy2QghfxRdnVCiFIq8lEXln6ulma8/QJBvNlkfGOZbQSEyXLJR2eOSoD2QMFM8vcS2xNm6Mv2kQivCUju3UgMQ7Drylqllxj8A/2qyBqb6P4+/GM3WPT9Ga9vbHMpk/E8vFcB1VFgFa2trfV1oJBhkM9cgzQnIDS8H6343BFNu0eaFlTtWpmYV6GbNKR7VmZV2YvTuE7RiQK9hQ+KjGEc5pPhYLNuHwEb0i3KIEpVauZZull2yU5uo0bLdKJOHufuWrqPZBAR8e5J/nEN6t7JHrRU9JX+PSZdZQ154L8bFsolsuRmIBjop9JeiE5nHZCkhTcEnGOWXzcQE9TYuzI9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 195.60.68.100) smtp.rcpttodomain=amd.com smtp.mailfrom=axis.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=axis.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbLAGwv5apbywanuU2A2GkL5nILXL3ZLe6fTst3Dc+Q=;
 b=DeVUo5eBo0qXkxd+fzH4/Zp72gAXVBt8yR7ySxu/9DCFln1H0sdz7UPjirsd7CZz1oObnkOI9KsnEIWcciuooXU7uKb4ViYd0DcVHaT0pK87QndANlcCda271TBvz0t43KROe/ukWl1map5x34pZCsGsewWpc6J7bKewDMhBHZU=
Received: from AS4P190CA0056.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::27)
 by PA4PR02MB7134.eurprd02.prod.outlook.com (2603:10a6:102:10e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 09:39:38 +0000
Received: from AMS1EPF00000040.eurprd04.prod.outlook.com
 (2603:10a6:20b:656:cafe::b4) by AS4P190CA0056.outlook.office365.com
 (2603:10a6:20b:656::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.12 via Frontend Transport; Fri,
 7 Nov 2025 09:39:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 195.60.68.100)
 smtp.mailfrom=axis.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=axis.com;
Received-SPF: Pass (protection.outlook.com: domain of axis.com designates
 195.60.68.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.60.68.100; helo=mail.axis.com; pr=C
Received: from mail.axis.com (195.60.68.100) by
 AMS1EPF00000040.mail.protection.outlook.com (10.167.16.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Fri, 7 Nov 2025 09:39:38 +0000
Received: from SE-MAILARCH01W.axis.com (10.20.40.15) by se-mail11w.axis.com
 (10.20.40.11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.39; Fri, 7 Nov
 2025 10:39:37 +0100
Received: from se-mail01w.axis.com (10.20.40.7) by SE-MAILARCH01W.axis.com
 (10.20.40.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.61; Fri, 7 Nov
 2025 10:39:37 +0100
Received: from se-intmail01x.se.axis.com (10.4.0.28) by se-mail01w.axis.com
 (10.20.40.7) with Microsoft SMTP Server id 15.1.2507.61 via Frontend
 Transport; Fri, 7 Nov 2025 10:39:37 +0100
Received: from pc36611-1939.se.axis.com (pc36611-1939.se.axis.com [10.88.125.175])
	by se-intmail01x.se.axis.com (Postfix) with ESMTP id EFA3518D0;
	Fri,  7 Nov 2025 10:39:36 +0100 (CET)
Received: by pc36611-1939.se.axis.com (Postfix, from userid 363)
	id E9836604ED; Fri,  7 Nov 2025 10:39:36 +0100 (CET)
Date: Fri, 7 Nov 2025 10:39:36 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Florian Fainelli
	<florian.fainelli@broadcom.com>, Broadcom internal kernel review list
	<bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>, "Scott
 Branden" <sbranden@broadcom.com>, Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>, "David S. Miller"
	<davem@davemloft.net>, Tom Lendacky <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>, Srujana Challa <schalla@marvell.com>, Bharat Bhushan
	<bbhushan2@marvell.com>, <linux-crypto@vger.kernel.org>,
	<linux-rpi-kernel@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@axis.com>
Subject: Re: [PATCH v2 3/6] crypto: artpec6 - Simplify with
 of_device_get_match_data()
Message-ID: <aQ2-WHENLhXN_TAH@axis.com>
References: <20251107-crypto-of-match-v2-0-a0ea93e24d2a@linaro.org>
 <20251107-crypto-of-match-v2-3-a0ea93e24d2a@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251107-crypto-of-match-v2-3-a0ea93e24d2a@linaro.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMS1EPF00000040:EE_|PA4PR02MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: b8981ec9-7fc7-43b9-ba91-08de1de1921b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sYDuWVNOz0qiVVNPSa7vhdKoPGumrJAvWyu46huwck8X0u7AkhHlVfMsdRmz?=
 =?us-ascii?Q?ht0C+qANKltqP2gRryywudIG387Bwk4CfpdnaMvnQNWZ8V4nmrhlecuPA8LX?=
 =?us-ascii?Q?UFkZzBM/7QlbEgRKUDL3GfnvD30SIaKIJaRQg/tq2IheqQeJaxUVWHqthTVb?=
 =?us-ascii?Q?8krDrScyJ86QOPFdsbLrJytg67QY6oiu1xCVfktNtyUy3ZaRP8UZBivGMAX5?=
 =?us-ascii?Q?XtbuSKn/14oHNw2c6yq19a71fp/fT8c3GrGHNpbnLaMIGjvUaoX1QoHKPzVT?=
 =?us-ascii?Q?UkmxQFrY5gxn14A+dL9bhZUzguc4L4TG+RVHJir8nvJVIjfCBFtOfRlg727X?=
 =?us-ascii?Q?Ga0MOf8j2THsXlf8P1rqGu79cm2bgUL1eYOVzOzTp7JRYBcuEubWd7//865N?=
 =?us-ascii?Q?CaPwtS1Nlnkem0BLdrNLI/3PiMcUzrFEpIFgqKITWm47suemzPL9etqLBKWd?=
 =?us-ascii?Q?JZR808c4u/XDHaqU4KtFuIcFnK1emE4UsjOEIH5Ms36MWV+KodbB77r1TLXP?=
 =?us-ascii?Q?vCJPXKfn68GnwudPJKjUoPT9RlbZ1707H2Vhq6NPF5VFhTXtWP7OI1LavD4A?=
 =?us-ascii?Q?+BSdS6rg4EdoPrrkrg2vzDsQo4fPxFPXNZ+xrkQL7u0tRDaGC6C4NmfBl4gx?=
 =?us-ascii?Q?TV755GRTqnp0aulQhfTTwlTW/uq+ZRkdI3I7wIw1FoqKuSKTDINZtxAA6ITx?=
 =?us-ascii?Q?mmBeW8qlxBGHhdNlhkBp7ndPUu2BKW8zPbV0eZW/m+Cprq7XBEdj7VJKfJll?=
 =?us-ascii?Q?sCXQhqBrq8AWUQ5SR4BTLsYKl4yKS93Yp6bMfUS1wqI6eBcxevQSHVsGedWb?=
 =?us-ascii?Q?GD5nVUcy1xeK3isou/kMDwFhM8fmpIY47GECfPzYN3JMR79bCqMWTn24EdKC?=
 =?us-ascii?Q?aYR85lbd7863ggo14lfRXw1g2hYvuws0mGNXqJ5SHJiJuRK9vh8WqtUzOL2e?=
 =?us-ascii?Q?als6m0N0FkQIYY29WI/uDhFSdc4Rnf0J4My1H6yuZ9CCt+mQW6zhEAf3K9m2?=
 =?us-ascii?Q?PQWCR9rT1ITqtYiPyML8kLfkO7KYucSrJGZJEgjeekzG3CxpHtN+pG/CcQ1p?=
 =?us-ascii?Q?Eh2jl40goiB0zfUt1EJ8l9WNXlnYjDFbqh0OG0d81ptbnWkqzOB+K6rjZqFv?=
 =?us-ascii?Q?aPE/xrVl5EcAOA4cd+WhmpO2rg33vx5ERRQQieGqh9DZD/CYMGGpJNbv3FV2?=
 =?us-ascii?Q?ZOow5h5FOYmbBv1VHn/6SgU6So/HJiXCmz818tEfmt7I5CXIHHX6Z5NueoYW?=
 =?us-ascii?Q?cqNvi1JTrHgaG+k5WnlHB7WEVr6HWvgdRfrlBCL8nNuNNmycio9tpBB10KI9?=
 =?us-ascii?Q?k/WKnEBfFTjaa+mYdFhQ1VKrHMlYfbDL+mZ8QePGMkEjNuwXmmR8aM0zDizW?=
 =?us-ascii?Q?+bT2exfFhbZLECHivuImfEAKInoOWPsnYG//qWM7X81H9k/opC09vPfGGzta?=
 =?us-ascii?Q?Y9MiSDrH9yrLC1KRlU6LMCP0G7YINNschTwqsuctxHzQSJGvuq23uyMBiJiQ?=
 =?us-ascii?Q?MDeds+sJHqEDSB6yyyV8zv1Csh1WKuCstoIa8xLDjc1iVxhGq/mtigOEtHfg?=
 =?us-ascii?Q?YFLnzssowpB8bJNAfbc=3D?=
X-Forefront-Antispam-Report:
	CIP:195.60.68.100;CTRY:SE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.axis.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 09:39:38.8894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8981ec9-7fc7-43b9-ba91-08de1de1921b
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=78703d3c-b907-432f-b066-88f7af9ca3af;Ip=[195.60.68.100];Helo=[mail.axis.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB7134

On Fri, Nov 07, 2025 at 09:15:50AM +0100, Krzysztof Kozlowski wrote
> Driver's probe function matches against driver's of_device_id table, so
> of_match_node() can be simplified with of_device_get_match_data().
> 
> This requires changing the enum used in the driver match data entries to
> non-zero, to be able to recognize error case of
> of_device_get_match_data().
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
