Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5923DE448;
	Wed, 15 Apr 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776267455; cv=fail; b=ikxuF1FqiiGJvdEhfrVI4FCctU/lwklNW7+jBe83HZ3Jm+fu69FK5MMZL+o7Nj7WSBXlEylPBpgmFW8d34lAEYrZ967ubDDLof0WsGyEdpZN7Qr5Q9GcoXk4iWurujpuWv8G1W4oM3C/s/Pd6bG8Yke8OaauSN60qFcOZmGKvEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776267455; c=relaxed/simple;
	bh=m8jg8CR1vrpPJx+/Ux/otA4/fD1FyVCk282Dq2qFCk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PKyF6LgHA0dEpD9fazyI6i21+PZEto7hwPry7e3/6DBGYztEAffhVEb71fxHjRyqDbg+OEPIpt9kOwUTo7E8MrywYLwT3qdghxg5C96yrG5pEfpYBT+bNL0aW/2+LvIWfkWTx98Zme7IyMpBygKonsj++QrOu51mrQ/TttLfbyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=f9Ek238+; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="f9Ek238+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0jxaDoBrSBNn2l9hgVxxOlxbZ4eY6oMd0zNeqOPnM/MSBsw+w1tBctL1kkpY1dP/fgWlfSjBqS80MYjwd0frIdgz289DozcscTPi2ZWpUS2jokVV5vW2VhcJEHbH3WHaOeWBYbovZvF7l9xiainiRgqDod+Uv4n/rWMtL2NreZtobWjEZ2ZYMrGW/Ndsp3KSfvniKxRkelwrxo8YYjlMpfj1VZoBjEK99RMnSaxX3KsvYoNetVR+eGOzC7WrfTYEE3i3IliooUEpaX3z5+KdsUzQEep7tqP1BSICWsJA6UU1ppJeQnP98K/vI1wYg5HZ4c14aSUITb6891xuANYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dBzKog13aylQga6HDIC1FcHV9GhimQLYrgrJyZCa38=;
 b=WIpSJYwYplU9sQl04oXN6MYXmozl9Q+kOMDCvxZsT6vaxGez/lwX+a5HGLdCMbWeJXuqUEWzD67Qc/eLZ6cnSJn/QUS25TA+walnwd5StXBhamimwgMjOWw+huvJFdeQG2hOPe1YviV+9FXHysYa1ANvrdqUWkNs5n3LO7W4qNGA1618cnMT6ZDQy5cDUmqaKD4Vi52/QGU8YFyhQJgW38jQny0f9WCTvJ6titPQVvxuJI7SLykHJNxboDCLA+GSK0oA/ctqFZJvZfX+9YpDjK5nHg2zoT1IakOQPcdjB8G0eUDCZSwDDS7Uux8QyarnO9LafjOWHXgQMC9zcNuF8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dBzKog13aylQga6HDIC1FcHV9GhimQLYrgrJyZCa38=;
 b=f9Ek238+22pRnkuBvciNNU5bSmsI1TWGHDnpeaOuIEekKyMt70FJnJaQ/EsI97YC2pmyfvN4LRHLc4Rfl4YDr4ta2oAnEvz9i3ikM5hW16LTbIEXEyV5F1GKC9TaWrLel1QNoOI8S6l2ABaRFHvvRGf3OHCRdwhp27l8sNGY8oY=
Received: from BN9PR03CA0569.namprd03.prod.outlook.com (2603:10b6:408:138::34)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 15:37:28 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::5d) by BN9PR03CA0569.outlook.office365.com
 (2603:10b6:408:138::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.44 via Frontend Transport; Wed,
 15 Apr 2026 15:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 15 Apr 2026 15:37:27 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 15 Apr
 2026 10:37:26 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 15 Apr
 2026 10:37:26 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 15 Apr 2026 10:37:26 -0500
Received: from [10.249.132.102] ([10.249.132.102])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 63FFbNJA2480056;
	Wed, 15 Apr 2026 10:37:23 -0500
Message-ID: <e8e9770f-b674-4fcc-8483-7c90163eb21c@ti.com>
Date: Wed, 15 Apr 2026 21:07:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] crypto: sa2ul - Fix AEAD fallback algorithm names
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, "Tero
 Kristo" <t-kristo@ti.com>
CC: Shiva Tripathi <s-tripathi1@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260415143700.1168634-1-t-pratham@ti.com>
Content-Language: en-US
From: "Chawdhry, Manorit" <m-chawdhry@ti.com>
In-Reply-To: <20260415143700.1168634-1-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: 063dde98-78e0-419b-2438-08de9b04e605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0UR4LRQxgnqABNHQweYw8XiCCU+AxcqUiDHMsxHwOeVAK1lApY6jHElimpNVDApHZaeKQH+EHridkx79cMiPIHO5bo44sCjLVLTSgc+YMde1GxpnMJ5pNNw9YycwfmfeECI4c6+rkAqjxrip+ZlQkIadhwUr4NbCGxuuv25/DZcpSOs0zSmdC/WUUrncHvmzkOHyj74PNAHAyUggWMr2UMI2oiV/gMrwVmGryAKeaLggKWq9ACtLwKS9EuPmmpy6OCbl6NGpAsLn3qXiq1KBZVs4jqSaNthuPJEsABNyhlO2epl1bJQ7b1CvPzNQwTvSktK+mzEh5XfiVImwtD0MBlm7PdmibqluoZtC8RukFIj8qIxlimyV1lhFTjEQOlAs25GLHhpb12o2U5r/gmzc6mdi60L81P0QNRQGkD/EIyeT3ihm4By/hdVgjx+ftvqfThkj5MRcAvA/IeHLQ90BAnh24l3wa2JayyMY2rolZBzLXpC+rtDhteOBHa9iEYkut/XQ7ew/CFxVUPuOFgxUUmdBWKJM6rowxzS5lVrOQ0b8Iw7ZPWDDKWojQ9HElZEjVL/0DfnfLoDNz+pRuB1hAFweGiMdKjwdyunNLCxUM+DVcpShRERDhkSwh5oPhBiCI/AtKw9V99ztUjZzkc+9gs7AQXxRa1Ug/ZifdCauA+ORfC7PVJaj8TUK/boRjqbEgkvOo/IBHjI6MdzwbP67+nP4N/X4XTcJH4n+oFHFEvf4Ou5JACRqw4MRwXUsb/cEeUIvwGW6g+9LSngAjFcx0w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HGw067AWygUk3L/5UYJVRkitIXVntiffi1dvZ447al2A0uJxABurOCUtNjLK92rCMlQxL9JtiR7Lf5nldwh4XywMw+M6ujWFa+9wQv9dsWbyhYasHldVheV8wLPlUFq/gQhDXraau+DYODI4DWOda0c0j31q/rxuHdXoqWG9Zx9WMdiUt/AjkSElYXpEZ1RNCT8ui8uP0MsLMaX7tSljPel4vd1Zxas4C4rkBGsfpjdZOc2jvfPRy2Z/wXi+YLW4+Qx81Ex+uxV8ViHfjgZjZja/gYEeyRU+0v3lh94R0KQ0Vx1pW2zgT7kJdbSKLjQ1TznBNKvIZ2a924D2CucGdPjfkOXvXfDO9R9toF6tCh7foS0QRgMbEVFoNEQ1vs15jaJursH92j8hvFzwXttTXP+zU4ZTMb3WdG5Xl/wkTTjJcAAhUjj5sT9/QBkFc/JN
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 15:37:27.3217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 063dde98-78e0-419b-2438-08de9b04e605
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782

Hi Pratham,

On 4/15/2026 8:06 PM, T Pratham wrote:
> For authenc AEAD algorithms, sa2ul is trying to register very specific
> -ce version as a fallback. This causes registration failure on SoCs
> which do not have ARMv8-CE enabled/available. Change the fallback
> algorithm from the specific driver name to generic algorithm name so
> that the kernel can allocate any available fallback.
>
> Fixes: d2c8ac187fc92 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>   drivers/crypto/sa2ul.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index df3defa1ef4b6..965a03d5b27ae 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1744,13 +1744,13 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
>   static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
>   {
>   	return sa_cra_init_aead(tfm, "sha1",
> -				"authenc(hmac(sha1-ce),cbc(aes-ce))");
> +				"authenc(hmac(sha1),cbc(aes))");
>   }
>   
>   static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
>   {
>   	return sa_cra_init_aead(tfm, "sha256",
> -				"authenc(hmac(sha256-ce),cbc(aes-ce))");
> +				"authenc(hmac(sha256),cbc(aes))");
>   }
>   
>   static void sa_exit_tfm_aead(struct crypto_aead *tfm)

Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>

Regards,
Manorit

