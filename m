Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD09475;
	Sat, 13 Jun 2026 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781379019; cv=fail; b=kaDPGz6RwJo/WAdbpmZHlSy7f27twdA721GC38mTV3kv8wnpWYv1MQFcdZXppg5hkSUdtb0H118l+NVWgaDsigSUEzVoPM6OTHS7or+jWCWXWNB/BztOCdEKqViupC5wGvGN1DXklhXTTnzh0rgkcHe4ieLacJPCPVq20mg2etc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781379019; c=relaxed/simple;
	bh=SUaDea7b9UVvtmf2GAisPXyPRsJqV/B92wnbks6JGDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uVSHR/+gOa0GtlC70kZpMXWwKnNA8ILUk9oC78ipWowCG7N3FOwnSEg8yWq4R391O3CcoNCP2c9qG0Ta3NY2rq9a88X/pqOVkiVa1tvsRbCvl4cLUgaixk16N8QRAXYow/wxs0feMKOVUc8KQnhrJb1Oq9CAJ6MfMh/7z2CHcSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tkZOKP7b; arc=fail smtp.client-ip=52.101.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tkZOKP7b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+3PJdaCzXtE91UQrplv645ppiSxRqNZw3Ds537KzeZCNez/vsq+36aAjKKEtJyk79r5Axx4i12SDPbzFd8GhkKlDfPrHihCcc5Q7VsICzv6dMEnFd9c/Agl2OJyHk7n2vZUlpkdTmVQwNdsvuvw1prEN49IsJz14hhklmqooN3UOQB1M6f2UWy2/ZYj+V0FGjkqXBFXvGhCBBOJz2344QutnU3ZaUdreKoaWz1I2g8U2Y+9ZS2sKs5dsPeUGbsVrZ+66ph/UNIOZU6UAmD8Qvg8Kxcx/aq1CTiZyV/dipyIFxAwrXGpHinuUBUerWdc7gaUr0WWJ1TKfK30arUksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxObNn5xH2UzcTfaUEf49Gwy2OjSNyZndrvOaU9L4K8=;
 b=ZeKK9nfCErJ8eqAMg768FvKlR/rBiE+N3/PU9XBqkr0vW+c5VkJoaNLMN48hT38LySRfZfYKjWVooxnvgg8vY2Hw7tqtndoYY3xt1UGhhHbJOjrGvnsJ0ChQN5HvWBI3xPRfiPzjKQEj+T78rPuEEG0WoTuo0fD3eytyEzdgeaq/C/bQUd+C80KpzY5csKZTsOWkZngsVy2CWgvsfe/UJYR8Q9zdGImilKYvn+WuiUA/AsqnUJy7Fb2XTgjMMUkqiV79pgn3KknOzzB+XLdIbKF9FM61X01ahvD+uUnVdM0IuT6aI3OhHI/VQVwJsvn/9i6PAmiv7NkClPJ+wCDlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=intel.com smtp.mailfrom=ti.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=ti.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxObNn5xH2UzcTfaUEf49Gwy2OjSNyZndrvOaU9L4K8=;
 b=tkZOKP7bFVnI1pZqCeL/jlfapzu4Zl9LG45JAlz+N69ACbRni40+7oQITNQB6cBYpl5TVdiOmFm9VjZoXwP/xrUBZ7WHwGDIJpDIsThogezfaHsvLdbQ/hu1rEepkckuUi6O1yJo+s0x4IzKXselIwca2TrEXOWQVTH4IKtUfzM=
Received: from SJ0PR03CA0291.namprd03.prod.outlook.com (2603:10b6:a03:39e::26)
 by DS0PR10MB6774.namprd10.prod.outlook.com (2603:10b6:8:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Sat, 13 Jun
 2026 19:30:15 +0000
Received: from BY1PEPF0001AE1A.namprd04.prod.outlook.com
 (2603:10b6:a03:39e:cafe::6a) by SJ0PR03CA0291.outlook.office365.com
 (2603:10b6:a03:39e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.16 via Frontend Transport; Sat,
 13 Jun 2026 19:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BY1PEPF0001AE1A.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Sat, 13 Jun 2026 19:30:13 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Sat, 13 Jun
 2026 14:30:13 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Sat, 13 Jun
 2026 14:30:12 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Sat, 13 Jun 2026 14:30:12 -0500
Received: from [10.249.128.156] ([10.249.128.156])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 65DJU7CS2573807;
	Sat, 13 Jun 2026 14:30:08 -0500
Message-ID: <50b80412-61b7-4c0e-8182-428ffdf6e377@ti.com>
Date: Sun, 14 Jun 2026 01:00:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ti - Use list_first_entry_or_null() in
 dthe_get_dev()
To: Mert Seftali <mertsftl@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Dan Carpenter
	<error27@gmail.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
References: <20260613085858.32580-1-mertsftl@gmail.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260613085858.32580-1-mertsftl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1A:EE_|DS0PR10MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: e1285eed-4804-4b50-02e5-08dec98230d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TnHXXcdej9wNDY6FD/FOCfA4T/arAlzjUyxcQAJif5v+3w2DfWfnHPiAWoqt7bXdkRfAQrUET3diZHw/uhjFJ5U2F/hTmj494DbM8/x8FF+Itu1IIrup/OBBPJy87U4cP9Z2yWRTwUzHaLS5c+amz54g04/2MncxppDnYagezzoSrIkYL/96hl7QbBCJC6piEmnMzneatXzAT4ntCFtfpOxv+YjyD9tox4Tx/7RZScFy6h3icFSzwgw2tJedLOTG2nlKWXUjDcVKiUyVbb6GV2q+FZzZ/pvYqZU+rVyapc9KLuh+mDsxEBfxyrlHAwo/dsq303iRV2naCM8D0T1PzQp7DotPlo/8OgFx73X2/eu3ujXyW7sG2VaNAmT3DCjzREdR5tM0FmhmixTxUyFS8bDkXrNdtzOgGgaDBICrOyevF4NSmJtRyKnz/IqmvXrPvasF7eXGj2eHPO9o5RBwTrrw/0WyJ28RhzHsFYqKapTFX2sS3EqEn1mCsJ+LjPz3S3KD3qadI4H3u4QC0RFHgdq5hPzumLlbSHqHqYq7vRFVCmilSLnp21EBDYCmJpiFwIZxIi2earTt32BDo/EMKlh0jJGQ7SS08DzM2EkVHZsK/vWYz1IhlyDFLG+hK1kKucEIHSLwAYCFXWKVdhppVsNLd2MGmpJwQMZ+RTjZoMz5wQegVuu/bw/ujyCNXa35BLG+ElEXtHKgrYrs7w03ydCcizn+cNyvZqZRbN3J1w4=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kpOAYdJjF/vrLAuOoUd0xcqi9/V+CRry3Wwyc8NBwqFyt6A6s2T6q7GOVgkwYp+gfhDedZjV/FBHSvMLIMmi8zTHRx/Dytxiw47I0v1/pFkYikTWJIq0/9/DyANyebxhxTzt5efKBFpF7/y26wWA6YdkWV9bFrUknFntqhXUucD5yMehTmpvZ2RU3QDpb599qUe/0cG9Dbw1r7lMC55tIfTEOiHSKkBf12SfzzJY6UmRAt8tzYRI913q21RouXpveA0uJjO8skrMipIpHT5Na1geBPgSMYwS4HeLE1lhuvKB9auiy7/wCKVE+nDWrPINb/UoHfN+mV08gFqlvn3HNYxuH+6/p9Ygg3OBdQMgCPK2/AHCedF+Cl5+TBgJwQxZhfnDZKvba6bNUreWSB+BzaZh0jZraj8eYs5fAX7iMDSs8g+yiwHEiCPn7Qh5W+Jk
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2026 19:30:13.4274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1285eed-4804-4b50-02e5-08dec98230d9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6774

On 13-06-2026 14:28, Mert Seftali wrote:
> dthe_get_dev() fetches a device from the global device list with
> list_first_entry() and then checks the result for NULL. However,
> list_first_entry() never returns NULL: on an empty list it returns a
> bogus pointer computed from the list head. The NULL check is therefore
> dead code, and an empty list would be treated as a valid entry and
> moved around as if it were a real device.
> 
> Use list_first_entry_or_null() so the existing NULL check works as
> intended and an empty list is handled gracefully.
> 
> Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
> Signed-off-by: Mert Seftali <mertsftl@gmail.com>
> ---
>  drivers/crypto/ti/dthev2-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
> index a2ad79bec105..cc0244938267 100644
> --- a/drivers/crypto/ti/dthev2-common.c
> +++ b/drivers/crypto/ti/dthev2-common.c
> @@ -40,7 +40,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
>  		return ctx->dev_data;
>  
>  	spin_lock_bh(&dthe_dev_list.lock);
> -	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
> +	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
>  	if (dev_data)
>  		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
>  	spin_unlock_bh(&dthe_dev_list.lock);

LGTM.

Reviewed-by: T Pratham <t-pratham@ti.com>

-- 
Regards
T Pratham <t-pratham@ti.com>
