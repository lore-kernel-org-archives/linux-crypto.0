Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784BE3B8BD3;
	Mon,  2 Mar 2026 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460532; cv=fail; b=N7xmwPDp7kMJDCd1THB8AkV+svCLpPNm7++tblqxKVFGBJ1Pzxq2J7GiXD45/8iD+80ccZDigeIu6zdbFvl8w/QWtSaXcr4YmPGKfTz1x0INMxEsfGf0lBTyvPtMJZvAyiTrMVUqQV1byh9bQrfMAYaCBDrQsRRWdbORpw7XKBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460532; c=relaxed/simple;
	bh=l9sxWZTUJBIZ6nMJoiGGkdv4ZIVL4F6DO38Y5JEgC/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AJSuEYfGmjTqPEl1Bz7X46taPCZtTxeV9/2LEgi+2UJnXsrf3nbmMqnPcDqnCIr1g5QVUg7uUhMy+FBvwdNgLZWDE0qgQyuMCvlX9nrjqY392hDI+Zx2yStBnb5g7d7Ke6TOo3RxBSlEkNvStPrAgULwjFhKtztuJ6cBsQmQ3ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=WdGIAINP; arc=fail smtp.client-ip=40.93.194.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="WdGIAINP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ai2TcUrkCGdljLagFoEwsomD0J/QXU+7Mu2NcCnpxzLE5ULIwizb9hhblUR2dyXgcrs3ZLSR4qrptlZNUdOIUZjEium8BQjWQu8maBHUtxpP4APvjLR/+cIFVST5W1f6+tOdtOKd2rTkQNs/gcX9R5YvsvFjFJ+7DK4UEU0L5WuYyQn/EAVRoDLAC7fKpUHtjQ4DUHRvtGlaGPH7TIAoBLCQUs+mROu1q2zoSuNzC6vgo1D1uhQ33a0YyO9LAbJ5wW89JwJFJaTvWBP6/q6W3GesRg4wCx8f2FzvJJ8tZ1FFylBkLplYVQxR32OEL0TWmWRT7Y6eddJSWV9fOQLB9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEUrizsyCYHvW/pSmO+Hg1zau21t3KlfTMD+/mkzrLU=;
 b=x5teC9loLMxwN/Bl7Fg4FNNs5eo7px1UFxrXYYj8s0NvQEGMhHak+rGBMaAU7I+rQDoud5pYqO7aRSRSMxM1KX9hmvv5pDIKy38Yjp3KmIAr5/FRb4YQJpBQpAHgR0AtXZrXDdTe8JjiuN80YPZ90aqOZUFzyVj/VNQCMZ8EDeUh7wa12xfOXjhRRKgH9BC4qNiRhP7lH11i7gLX1KS5Ff3q2lu/fC2efVSXJ0tP2GnXnLm5TXgj7+Vvxf5Ra78HjsKPeNHkC9tbiM6jks1bgl0+Y+BM6SZKAyjeASjziUaexWwl2i86juvjzw8Rcms+wkF22KoL+VTh998OFNxQMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEUrizsyCYHvW/pSmO+Hg1zau21t3KlfTMD+/mkzrLU=;
 b=WdGIAINP8msBia9f2Qb4ujV4LlUSLHM93d2tH88+bpYDk06Q9lpUIWuNQbGqOXxxtpQL3BmIgSCqSI3YCfdV72lond1WKAqSBkJenvxi0dsxRulaxLbHqEQVm2cBwcyQhaUbeqfHZ6PL1JqmSrYXj8QoD+8J9SnYszXwMoIuhlM=
Received: from MN0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:208:52d::13)
 by DS4PPF376CF97B3.namprd10.prod.outlook.com (2603:10b6:f:fc00::d13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 14:08:46 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:52d:cafe::7d) by MN0PR04CA0002.outlook.office365.com
 (2603:10b6:208:52d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 14:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 14:08:45 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 08:08:44 -0600
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 08:08:44 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 08:08:44 -0600
Received: from [10.249.132.17] ([10.249.132.17])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 622E8eHX403914;
	Mon, 2 Mar 2026 08:08:41 -0600
Message-ID: <845474f9-a809-4b6f-b10f-2d79284b0a60@ti.com>
Date: Mon, 2 Mar 2026 19:38:39 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260120144408.606911-1-t-pratham@ti.com>
 <20260120144408.606911-2-t-pratham@ti.com>
 <aYWsJAmf05EdotTX@gondor.apana.org.au>
 <b3b9f41a-adc3-408f-9fc9-69618c4aa2ba@ti.com>
 <aaKqD5FP6w8dp48p@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aaKqD5FP6w8dp48p@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|DS4PPF376CF97B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2fcba5-8066-4a80-e7d3-08de7865379a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|34020700016|376014;
X-Microsoft-Antispam-Message-Info:
	in/KGvJy5JC1bACdvY5+GZU6UI3wcE0zXolBpm8fG2V2SjZtHEOOTG1+JbCpCg6ya7RWk2IisGLwj7TaX0b74l3t3dMGBTBbDAelBsCLHKXhStw7BKbwxuctMby4C585zYjBaScsfrsOJgzBfyCFu1bjOS54F5PzFfk8dCeO1R2MK9eZSjkbTh4835jYLNyVtpIHDMZZWSoie7ruypt1B2AUU+ccF22aAiM1UBeXLxyZa129bw6AkOyNVKzX6gpDOcDphEh6KH7jBqPOCvaO81iRcUNhTgkRqki3l3+MvWelBlCbu0fp3xbm7E3uQFiPYwiUctlu3k3YRorj3o5ywi6pBIoHz6vtSRPJyHspy+zyWHM37VRTXEC5yKAdPnAZ+SV9LUfJWk4i6987pbxSJFhYObaZzugXH3MyLhsS6Bkm8DXZt3YpQm/1K1Cfzbkl7np1IntJEmVsY7rPuKmwf+vlukK03hN/iHfhsoBePuASetLW6oJiexz/P/xYd//XHIVGpTupTVFQMUMezZ61m4vk0+OIKLHjwf8MlPRADmO7XehTWMbBRwdYAJDOBV4ej8nGf+alJfQcFOepPM0p2tCdiAgECjgLB0ctkHQGyTOrWScssGl26NA6dirprFAzUr5iKSLa9+Mcg3n1K7gAQ/zscRSOn5aLyBtQuHZ2lBvfxHIl7YcfH+mV1dzh4fdRFqnpSk3cIRoSuKM7CtR+jhXuWrGv6SLVAQQgzJolmM1Zh4shzC2CJuxrD6zrPfOIcTM16Hwo8gLzVN6THB06JYUCVcq+i5MLSkb3OhhTG4L07JtLxmOHP43c0iLYHFwDSosmQewCzUHRmgU0Jhiopw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(34020700016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SBE4+7Wk9GXVj6AQFJyarJd19MXqcXXg/hizyn4dy/0pTwT2Bi2uWcBqp3KHF/4FOLaYG2a3YgVd53/HmchRsf21F7ummpFZ6MwXbCaTiiguKxybBjWK6WSVjCR06TdBPyvjyv1OF6su59Rznsxr+OKVnsSsbodL34hP8dp0RRXLE1XN3m9OY01dD06C8tHIm6BDR7tN05eI4fwHZpUeofLHIEhBMPhHrJTxCNC8pEPlbQSkacrJneZItJcmU94r9UuW4bvi+mboUVpVqtokAVxQ33rPdC75nWVlT2laZ9x5lEUTGOKrs861MpiT7tltYroEWUpqaxSqLpCdMCM6NIe7ayKzZgUsZtv3HqHpwhY9gLMZS1K0Rg4kj51AAF3Y7qsSBxxTJ9qCplpE2Fquu2O7wMs35l6F8LTGstonwce+3/IBbKTkudiYohiqiJwD
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 14:08:45.1877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2fcba5-8066-4a80-e7d3-08de7865379a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF376CF97B3

On 28-02-2026 14:10, Herbert Xu wrote:
> On Fri, Feb 06, 2026 at 05:07:13PM +0530, T Pratham wrote:
>>
>> The DMA (at least UDMA in K3 SoCs) sends/receives all the mapped length.
>> If I have the dst sg mapped with length (len + x) but write len in
>> crypto hardware, the DMA gets stuck waiting for hardware to send the
>> extra x len. Similar issue in reverse as well.
>>
>> Also, FWIW, I'm restoring the len in SG list correctly at the end.
> 
> If that's the case wouldn't it also break if the caller supplied
> an SG list that's longer than req->cryptlen? There is no requirement
> that the SG list must be exactly as long as req->cryptlen and it
> can contain extra data at the end.
> 
> Perhaps you should use sg_split like sa2ul.
> 
> Thanks,

Understood. Will update accordingly.
Also, sent an updated series twice with other changes.
Here, for reference, is the latest one:
https://lore.kernel.org/all/20260226125441.3559664-1-t-pratham@ti.com/

-- 
Regards
T Pratham <t-pratham@ti.com>
