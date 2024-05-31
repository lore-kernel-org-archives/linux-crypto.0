Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2049.outbound.protection.outlook.com [40.107.13.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3EB74BE8;
	Fri, 31 May 2024 07:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.13.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141700; cv=fail; b=iPjytEeM3gDEJa/7GYInTxUJYBZ7zQiPF8DS5C248P+mHdeuyeh4/g4LphLE4b972pGMOBHhAmXX8fy+GjXEusSh1F1wP8Uj5Zlo0v4EDNMYWHHs4YVTBIqheXaq2mjv3qdYvOk+7ABX24OHs5xQ3hs0WJPyAmZfcSg3XSpUVFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141700; c=relaxed/simple;
	bh=OnNwCfmwVuYg8aaMEODDrdtrqzc5w3PtdkLOYYKpoDo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeZZsPcVhm5N6kOolmWhNsj53Koh8Dj8OO+svEHb99o9z1dhr8JxUDNsjCbtSilMKyYhs4z1HPAjC1DQj7bON/HoL5xY4n2oqaE+924Xb9nEpj6ST50f4tFsRkYLxpgjOVIOyoayzgG9Zi34xBvrMVDBLzDzDxhLCoKSyNOT1Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=ArvRxJEC; arc=fail smtp.client-ip=40.107.13.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="ArvRxJEC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ocx0SmuvUaxY2jQ69wBYcmqOtnV3O79GcKNiD/m3b+VS6Ci2G702N8FYnHtlpdFWTiuSVNDSqLnIq0l7HYil8bMj5FvHR325L2Oj61wE11MohxvQKQHfvzsCbHaXSwhrnLGJNlSgT2FVAwEyI3D4lxERbdu+g0jWE3Uz+BJpwpWsI9s9d8YTNh7QXNKpw9C0VqfO9L1h3MasUDbOKsXYJyjNgE30uGi9ZuaN7NGTOX9ty19vP/Ka/eZmA+gYPKEfUstdPrLf4O/sdRHKm+eFX6rcNB/cp44tevQzZ47VYtU2kj+h7jas8Ibc3IHpaJpBpaQJiMgFTgA9hHFRPMoTMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlTjdMlOYJbfJ9tPahwD2FAQLGHX0BbMzeW5qzZsRSo=;
 b=RWmSNmCMWErbcOOx0+eq0+fSmUd7o5Z2gevqpN59Ok2ofi/Aw1Qi9lAsS/zfucTrDvpPGvUMGdDYcM0azszUPGTPuEg3D1zgczYjXEJpEf1VBtYdfkI/+ta5vbDYMQSJ78lsregP9veEOXvTP8npeHAPCyckIKAL8TOigwthxyMFRGvn5XPcwdZQv1QO7oTkAbF6H8kSLRbzr1vU3ZH/uuhyXOLxmcKp65LfL5KbDGdiNYHZ2bRyfK4/ldiPKa/3ztFS8tHnzm+tbPPzQSHQddOOnDCoV20RGMz4H47FlceV01gDImqkrqKRtkmcgJDSAIgL1PMFsfkEEoZmAigcDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 195.60.68.100) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=axis.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=axis.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlTjdMlOYJbfJ9tPahwD2FAQLGHX0BbMzeW5qzZsRSo=;
 b=ArvRxJECqHM9zv8lO/MmjJLx3zAra8bh7+T9t/SytRjf540z+Rib8P9vWNcci9tiKsQUBt7U9JeRdGrUdCUJJ+lBozbCWGs6XkPWFGYcB/8bWP4tkBrng6D2wb+2kIYF6mGJOdYeVjEy1p02RoTTVzw0zJWygmwVhITofDyNVic=
Received: from AS9PR06CA0414.eurprd06.prod.outlook.com (2603:10a6:20b:461::26)
 by AS8PR02MB9768.eurprd02.prod.outlook.com (2603:10a6:20b:61c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 07:48:11 +0000
Received: from AMS0EPF000001B2.eurprd05.prod.outlook.com
 (2603:10a6:20b:461:cafe::35) by AS9PR06CA0414.outlook.office365.com
 (2603:10a6:20b:461::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Fri, 31 May 2024 07:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 195.60.68.100)
 smtp.mailfrom=axis.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=axis.com;
Received-SPF: Pass (protection.outlook.com: domain of axis.com designates
 195.60.68.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.60.68.100; helo=mail.axis.com; pr=C
Received: from mail.axis.com (195.60.68.100) by
 AMS0EPF000001B2.mail.protection.outlook.com (10.167.16.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 07:48:10 +0000
Received: from se-mail02w.axis.com (10.20.40.8) by se-mail01w.axis.com
 (10.20.40.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 31 May
 2024 09:48:09 +0200
Received: from se-intmail01x.se.axis.com (10.0.5.60) by se-mail02w.axis.com
 (10.20.40.8) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 31 May 2024 09:48:09 +0200
Received: from pc36611-1939.se.axis.com (pc36611-1939.se.axis.com [10.88.125.175])
	by se-intmail01x.se.axis.com (Postfix) with ESMTP id E85C8122A;
	Fri, 31 May 2024 09:48:09 +0200 (CEST)
Received: by pc36611-1939.se.axis.com (Postfix, from userid 363)
	id DFF5D6279A; Fri, 31 May 2024 09:48:09 +0200 (CEST)
Date: Fri, 31 May 2024 09:48:09 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: <linux@treblig.org>
CC: <jesper.nilsson@axis.com>, <lars.persson@axis.com>,
	<herbert@gondor.apana.org.au>, <linux-arm-kernel@axis.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: acix: Remove unused struct 'dbgfs_u32'
Message-ID: <20240531074809.GJ2174@axis.com>
References: <20240511145017.226166-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240511145017.226166-1-linux@treblig.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMS0EPF000001B2:EE_|AS8PR02MB9768:EE_
X-MS-Office365-Filtering-Correlation-Id: d61818eb-7cae-4fff-ac98-08dc8146048a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TljJq+aK2BRLkQyfgi0iEC4DXe0RUFIPlGjurryHmJPU2HmnQytfdSgFcYoD?=
 =?us-ascii?Q?uPsnrGE454fY8vuWh9OU7cr37/ZMPz6Oycrx1kbuQPEVgJRaqerkyY4rlk5O?=
 =?us-ascii?Q?m0qasSwBKeU1i8dMD4UU1yO0akT6EdxYrp6zhYuZfg+YBgCWviildvnzYKe0?=
 =?us-ascii?Q?VwuVFzGvZQbpSlrGdJiB0hnZu1BMHUoDWDqwtB+ec4TrAEU6LMLP+AZiWxeo?=
 =?us-ascii?Q?50kZRKoVINmx+thSQfsa8eyFBdEsgg2y2s/j+5/3UIzRVh2xxf7ULagywdxo?=
 =?us-ascii?Q?WfaZAqw/endg0sgI2Jna+sraTcGKzYi8JHzuwW/mYpGplzLvFxlTrUZF6DI2?=
 =?us-ascii?Q?DNsnA2/os6Tvj1ROfFKatK/Szy7kPD1G1qs6BYAYLn2V1m9UEHVKETy1twly?=
 =?us-ascii?Q?RGxVaVyG4eW7GFxVD16lgGQoLaOigUrpWSoxzDn7IIGkZ0oAPfbGgkfdxazV?=
 =?us-ascii?Q?4P7UdX0Df4p5g+bT30aOw3zKrWydP3T7KzWC5jCe2syxiv947qf+FQ8E2BB7?=
 =?us-ascii?Q?a/N86C6foJof7u9bfC25JxNpuI4F4ig0UKX4mnXwTevfCc+x0sKwt49WpMiZ?=
 =?us-ascii?Q?l/B6HEDArMchU1X4Vkq8N8lDrIXuuCJm7D0vnv13szpSEhEfKHSQW1YFuN0b?=
 =?us-ascii?Q?/czHE2UzDmi7F/eGQcjgdR3WlNXI4y9kuV8TYl27D3fItD5dRx/O2CG20yHE?=
 =?us-ascii?Q?DWRI7gKrWMh84uK3FkGTxVWCPJ8+kRxdrJuKB+Yg+mg38kx6sS7i1hDK9lTU?=
 =?us-ascii?Q?MhWcig+nGFAYIBxCgtEYwMS6SWZfozu9IjEgrZRdvWiHB6bANe6/aaLD1iXn?=
 =?us-ascii?Q?gm5BvuqvBXGAkKzCc5hxmmI0AVaJuRXrqWu0CJQ24sv0k2ozCZlOwUM1XFif?=
 =?us-ascii?Q?I9F7Vc3oWugRBnlDOB2O33EHfLMT/IM4V1elh9c+mfHdR4m3DU3zyB74E9uu?=
 =?us-ascii?Q?GaBckURDLglHQhKVPLUT7hOidCLG2VRrH+TWqaKvlVn3xC+1vYIA8kkLYpBp?=
 =?us-ascii?Q?HNAi0Mq7Z7j9FdmoZ0PXl7m+XbxwXGkBOWr3xxeFKZf9kWqKMEK+7GOUrx94?=
 =?us-ascii?Q?X/xYBSH+tJ0swXYje8aApOSTlLslrd1I5wu4lAAy/oNig0NXxE8+KZa01Tiy?=
 =?us-ascii?Q?kNf9Ff1sjhMMmSKaC9AFUbM9q8ak3KIfqS8Ma6FGzxO32f0TVKxQgxxG3fq2?=
 =?us-ascii?Q?9fJCCBM2AZHMjbB4LF6+fIPfAVfk+//F0L0yjfXs+fZVqYHBNnk9bfA0R95s?=
 =?us-ascii?Q?HdckskvvTy7ez23PTY3dDMep1xQ5CKYiJcQL/UXEDh/njQWd7gkjsjae+vgP?=
 =?us-ascii?Q?FBWE9otl+tM951Q50IZGs3EzZN5St7jOBMV7WEDceh03OHBqU+FCNVnnEcSx?=
 =?us-ascii?Q?avQqNrHWqh728Y/Uwt0hLAd0My66?=
X-Forefront-Antispam-Report:
	CIP:195.60.68.100;CTRY:SE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.axis.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 07:48:10.3189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d61818eb-7cae-4fff-ac98-08dc8146048a
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=78703d3c-b907-432f-b066-88f7af9ca3af;Ip=[195.60.68.100];Helo=[mail.axis.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB9768

On Sat, May 11, 2024 at 03:50:17PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'dbgfs_u32' appears unused.
> Remove it.
> (pdma_stat_descr is also unused, but I'm assuming it's
> some useful layout description of firmware/hardware
> so best left in)

IIRC, the stat data is of this format, but it is only
checked for "non-zero" as indicator a finished job.

> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
