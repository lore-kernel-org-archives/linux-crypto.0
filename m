Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA231C07D9;
	Mon, 10 Mar 2025 07:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741590433; cv=fail; b=qAIMVMYpI1i4mzPBV9CYd4lzLWap31BXdBHG59jfL574/+5pOh/jfAvDeKsK59DRvL7c2ave6G1RELsjEkZjzPtGM8UEQNmOxThEFvLxrGndQLAn/ZS+LNWzhYdDMwekxw+PxZypoQWMUsEAtRux9tMfGbIcPbB2JKb5u3pyAq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741590433; c=relaxed/simple;
	bh=WnNKBpOh6M3XxScmRQ84kkVEkIPHi90DZkJgu/S0an0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9RuU1En0H+Z3O2ZRnfdtHnaKxQjnHC3EMpH+yDBQD1RYgTCzQzE9+XlP3vbVCyHOQDwS9PUfJ5oSwie8WTJ5F6mgkYERhShTHF9XwEen0qZrKwNjt2Ldbd7Tc7/RYp4FCCEFWyqjJoZtZYyCxeUqjOui01gUEURC/cvo449n44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=jW5wxITQ; arc=fail smtp.client-ip=40.107.104.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="jW5wxITQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekdWbNyhy+iTdbtIclVNkZoRdNXTJP2wR7es8HPSXuhlEROtz0+WeN10iG6ENKgi6nHA2tC9QGtFABa26eKftDRVn3iy9+5NECzSrx3vHpJHKPqZ4ZQASoV8WKKS4YSVuubIbvt0q1yGtYvobaNpW1OOhmy42KoBliYVKzt2hmZ/uKfFP5LInSm7R5/rzyM+gzaG231rjGYwo9QYCfhlfrX/w86xcvhkVr2AR2Pr4+H82Yy9WhIdColZjQ1JdAh3cYvVSdFhsJmmQBBfLi7mw3c5qImeLFbPjPq8+3pzEBkobi+bcyF6OwVrVYfVM/jGnLtu41vtFWI3KUuDEOyPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihgaDUQj0wrQh9le5tH0nMLqetDJak09tzy/if9X3wc=;
 b=eS0T9B0EM6DAnW8/ODedMl2lISHdNFMf5LCtzIE0RhTXFGybLRQ1n3JFHFO+LSlYfSxDCINdq90d/wESm+4R45Ion4yfv7vswsOowJT6H7paiaQ+8Pvgsy1ngUDqYlqz8fbxMCrJSyk62yJxuAtlku7jn0hLZtpMxntnCFJTqmaykrQmh0zBbbFPR2aK/Nyn32RKj010opgmQ/4BCIcAvl1aPT4/S1tGZCf2k+qE2FgAaVB1R8+eikXGcn7h+KSUV2DMLLyGhDKTxEYsI7Xx27+B22Krv7ahg85FvEU80gMTnpBX5fNyiqlkogRGHbkxoCQLvQKIC8B9xG6A5KArSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 195.60.68.100) smtp.rcpttodomain=davemloft.net smtp.mailfrom=axis.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=axis.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihgaDUQj0wrQh9le5tH0nMLqetDJak09tzy/if9X3wc=;
 b=jW5wxITQ7o5EUUmTLvSxV33mV7cIzpLSG0qKyhrlb0Em2CIEG0cK6/D14fEBY0v9l6sLhJsH62uZTI1rHA9EdSU8JEOHJrEx52J3n20wgI1KEVfTkHy6jFOjKlg+Jm9Vtw8SM6g1ILLlK6f4jZOrUiBcd1yIWIUXszuFdVopGiQ=
Received: from AM0PR02CA0151.eurprd02.prod.outlook.com (2603:10a6:20b:28d::18)
 by PAVPR02MB9449.eurprd02.prod.outlook.com (2603:10a6:102:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 07:07:06 +0000
Received: from AM3PEPF00009B9C.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::bf) by AM0PR02CA0151.outlook.office365.com
 (2603:10a6:20b:28d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 07:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 195.60.68.100)
 smtp.mailfrom=axis.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=axis.com;
Received-SPF: Pass (protection.outlook.com: domain of axis.com designates
 195.60.68.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.60.68.100; helo=mail.axis.com; pr=C
Received: from mail.axis.com (195.60.68.100) by
 AM3PEPF00009B9C.mail.protection.outlook.com (10.167.16.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 07:07:05 +0000
Received: from SE-MAILARCH01W.axis.com (10.20.40.15) by se-mail01w.axis.com
 (10.20.40.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Mon, 10 Mar
 2025 08:07:05 +0100
Received: from se-mail02w.axis.com (10.20.40.8) by SE-MAILARCH01W.axis.com
 (10.20.40.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Mon, 10 Mar
 2025 08:07:05 +0100
Received: from se-intmail01x.se.axis.com (10.4.0.28) by se-mail02w.axis.com
 (10.20.40.8) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Mon, 10 Mar 2025 08:07:05 +0100
Received: from pc36611-1939.se.axis.com (pc36611-1939.se.axis.com [10.88.125.175])
	by se-intmail01x.se.axis.com (Postfix) with ESMTP id 34DDE14D;
	Mon, 10 Mar 2025 08:07:05 +0100 (CET)
Received: by pc36611-1939.se.axis.com (Postfix, from userid 363)
	id 30AE262A98; Mon, 10 Mar 2025 08:07:05 +0100 (CET)
Date: Mon, 10 Mar 2025 08:07:05 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Ethan Carter Edwards <ethan@ethancedwards.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>, Lars Persson
	<lars.persson@axis.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, <linux-arm-kernel@axis.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] crypto: axis/artpec6: change from kzalloc to kcalloc in
 artpec6_crypto_probe()
Message-ID: <Z86PmeRhNKGKGkUt@axis.com>
References: <20250308-artpec6-devm_kcalloc-v1-1-37886eaebd16@ethancedwards.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250308-artpec6-devm_kcalloc-v1-1-37886eaebd16@ethancedwards.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF00009B9C:EE_|PAVPR02MB9449:EE_
X-MS-Office365-Filtering-Correlation-Id: 0be5eb46-63c3-4e25-f7c5-08dd5fa22a85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?obXCl/ew5m6160oAS+Miz+spjGGXJPQ1Usm3+FNYOuxK07XRzwDpKnvgXQil?=
 =?us-ascii?Q?HJKTbtK1k9lp2LDJwLAnbeotcVL6Aze9fmEH9KCy6IFyumFLuZhRTcI5/F+f?=
 =?us-ascii?Q?wQ7GHBvqZwuzLs6NHdTyA3o1jZTTDrZbn/ndVXcCwAj1WR0VfZ06DDMBxSlv?=
 =?us-ascii?Q?9gITs5m0V9UUS2HZ+qqp3u2sWt+t2EpCOnoUipuzYpFFo2LYmpxdkV2iVhCW?=
 =?us-ascii?Q?9ACt/232oaosMnctBXS7Oy4B5FOI06QXiffHg7viTYYBUHaZf41sjta+STbm?=
 =?us-ascii?Q?YT1GelKLyc84xhSBrhnufsIMVGpb6bVzhsgsAR9d+WkmQey9V45r8arHid6Z?=
 =?us-ascii?Q?bT6lPOPffLzL8CxQ7qizMy6jmrJjL5Esn3Oq9wLfNhWrPv+hTr+4Z7DAd59+?=
 =?us-ascii?Q?0tgvPzK4wFB9yvlNYwWoaSU1A01Ue4mL4IEBmAZ7Xt5L8BUs+IRjXpJ2NoXn?=
 =?us-ascii?Q?7XpCwhLx/vgW+sRtBrwgtItMZRk+bK9gclwn/HJTwvzmurlSgU5OqKEFcFWd?=
 =?us-ascii?Q?u6vz75pMvUH8p9zPAxjxxKHQb49V7WmTua44Yq8Tv3B7x4ASwkp5OwadWBE9?=
 =?us-ascii?Q?hDYhm774FFVoaBeA8YuhrqgjAj40kFuXZ83R9dJstezOzNsjMwciBrhbzF/W?=
 =?us-ascii?Q?MfAxJCyrT5S9JtDUVtiAzzXVS71vPLAkuoch24Qn7q63u4MGXhXk3+pciwbY?=
 =?us-ascii?Q?T579UCooCiCMu4mQJOV0Ehj8LTUc7yyILHqYFofQ9YsoqmRgo8lNeOGfv5Sz?=
 =?us-ascii?Q?5FAsEBjOePbJ4ZPIr+WQHviEG27F+IEFx9QP2SSlwGLrGwVsrsmtia2hQk1R?=
 =?us-ascii?Q?ph7QjB6ET6D8OoY8AiPeO9AGAvrBoPuaDiqxjA5OsvQ1VlRQ4BEyssFGm3XN?=
 =?us-ascii?Q?PhdO1UJKlqUUMLh6GH85Uc7ctL0PpgZVqxzkGzvNbpc+Iy2pICbmdb+Sg5FI?=
 =?us-ascii?Q?5Am7TkpvTh6BGWzKJKP+rSD5A/+NFjHdhKva8RcTOc/BhNpbwiQrOGVSf9U9?=
 =?us-ascii?Q?hc53wZ9ZxrYzbT5b9MN/snFaJdzo6j1ad2IWWjTw6gs3gwuX5nG5JX9e5pCQ?=
 =?us-ascii?Q?/Zl/JUp2jhA+3dA/DbJOG8cgqiQz0X/DegRYZJxhCygakysX2ylImOsmM7A9?=
 =?us-ascii?Q?mBhkANWTeynyxKsT0kHyZgfS0ImePYeC/3Av+308owWdmmTgDiyXBUQ2Zp2+?=
 =?us-ascii?Q?eaMDTnRfVNEi7BnFAMfUBIg/zoI21kHHrMiqZX0+6MPzr1nP6awn3AjxjM1y?=
 =?us-ascii?Q?FZOYvQVTqrNuMrYKsm/ULRiLaXWcof5ktANaMVKY2g5Dssp2Zkku+mAYJvbm?=
 =?us-ascii?Q?mkQ0yVH2y+Kdtg0juXGQgkICXccHWvekyPAFD2eAWAbRysEZozBMT7W817A6?=
 =?us-ascii?Q?3BkB2HOd0ybIWVFbNzw1gvdnNj/ndutyV6nUqKj4FyymjYEKkGFzvzDmKAVM?=
 =?us-ascii?Q?E7G5fnvFfQM=3D?=
X-Forefront-Antispam-Report:
	CIP:195.60.68.100;CTRY:SE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.axis.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 07:07:05.8773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be5eb46-63c3-4e25-f7c5-08dd5fa22a85
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=78703d3c-b907-432f-b066-88f7af9ca3af;Ip=[195.60.68.100];Helo=[mail.axis.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9449

On Sat, Mar 08, 2025 at 07:30:52PM -0500, Ethan Carter Edwards wrote:
> We are trying to get rid of all multiplications from allocation
> functions to prevent potential integer overflows. Here the
> multiplication is probably safe, but using kcalloc() is more
> appropriate and improves readability. This patch has no effect
> on runtime behavior.
> 
> Link: https://github.com/KSPP/linux/issues/162 [1]
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  drivers/crypto/axis/artpec6_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index 1c1f57baef0ea9f4ecf7ab39f2c0e9e4327ef568..500b08e42282608348481b759e0b79d25f0b5db0 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -2897,13 +2897,13 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
>  	tasklet_init(&ac->task, artpec6_crypto_task,
>  		     (unsigned long)ac);
>  
> -	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
> +	ac->pad_buffer = devm_kcalloc(&pdev->dev, 2, ARTPEC_CACHE_LINE_MAX,
>  				      GFP_KERNEL);
>  	if (!ac->pad_buffer)
>  		return -ENOMEM;
>  	ac->pad_buffer = PTR_ALIGN(ac->pad_buffer, ARTPEC_CACHE_LINE_MAX);
>  
> -	ac->zero_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
> +	ac->zero_buffer = devm_kcalloc(&pdev->dev, 2, ARTPEC_CACHE_LINE_MAX,
>  				      GFP_KERNEL);
>  	if (!ac->zero_buffer)
>  		return -ENOMEM;
> 
> ---
> base-commit: 0a2f889128969dab41861b6e40111aa03dc57014
> change-id: 20250308-artpec6-devm_kcalloc-9a11cc6acb84
> 
> Best regards,
> -- 
> Ethan Carter Edwards <ethan@ethancedwards.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
