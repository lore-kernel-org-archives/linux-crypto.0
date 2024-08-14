Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBA145B05;
	Wed, 14 Aug 2024 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673167; cv=fail; b=VNrc8ZecQ6ZEqR37sejrDmtgitbVeYJs026L9qgTYRLl2mYzI55sThuYpsOkZOdQXcgz2UneMVDeT5uNlnfc6WwBAoWA/PXlWyrmRHMGTl4q08NJTA7uMQShyoPVGCrXtXlC8HSS9eNu06cqPKc4jpK7fZdwcuM0OsguUuL9kcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673167; c=relaxed/simple;
	bh=DAnWXBVfsvSnMTzh2IuZhpDewfEtONVvZXbnvZBGJSU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aEv5yB2zJCjPg1XZwHtru6aCnx4a5N9SoFeGJrmP75ZTB3da8Y9XhDxrwsGZ3bWxSUfTD3JpoMKNixbGwbu0E0xkkidHP9iJEYc0UZRegluUpQwgQcVqWoU/vBNmMAf21HLafD3yu0i3WU8dxOw3S9FeGI2XD7zGQTkQbfKybcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lwBbQsT+; arc=fail smtp.client-ip=40.107.236.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lwBbQsT+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X//Edge9iwIC+NzQWyqaLfs7/DqOadX9J4z9g2/ii0cqIem+MjaQRvoy4iNa1w/4BOu+QYn3dac7nXDqsegpR/bIvXRmgsgc9moX2wVZfxS0rrMtobhbrAu5G3I6unKm1xm3jSYtYvQcSTaLN7amfYJsL8eiBtmZ2aAkpSktVmEVGcd/w9HnlRSL/gcKP8ebmZXzo/GeLqobxSBNbwtR0qrwC/Nf/ayoTyUImD9awRjNUvRXGCwWLiFHbrYAJwBklDWFP8kl4N1mOaW8j5M43N/JzyM2ufpX5ZljQ88tJu5R54cDfmpkWsBI1jTmbJ7yId7TTJ6MQELWbWGQHhExwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/fciiym0czuApQtcgzkzfKnxmM3XURGHOTpiV1t5Dg=;
 b=s9dAuSec/9aSuTTNVJ5Il0CNCiYip3ponXRrgUMAdVZmhR95ZOKt2uXS/DI5LLbx2TaKhlj8fnKGQq6iG2Ov+6hf+qLFy47m8FrB+QtnCAYz5lM3yJSv93u1984v7ZEO+4SjLEc5QQe1cFbRwEuKVf9H3JUgYRwO1RPxAw38/63OlihlrblCREHYqsVUzG9TLIpCKAkn5JyjMf7YGNTJ4FLSyI9/DCzIMGcfZ91etvdbyTMfkoMIR7v5xYrCUVuEA35oINpWQkMhux6Mk7pFI6weTU9c86Z+rhTKBFIGawdDVOeW1jpkmTq79CAjulTp92llWo77iCgwusJNquPo5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/fciiym0czuApQtcgzkzfKnxmM3XURGHOTpiV1t5Dg=;
 b=lwBbQsT+KEfi/XqKl5GwtFkhGmHaK/IjUQ7QUMoSMBWyX1Lv+6AB695t6QdyvyJPqfrI9WKD0xDzRXnT95sZYyK4EXwvmjrkWYyWKwEbVznWsjG0oLxl9wDZm8KA3lceo2OaENuynbAlnJuR3Zx+cRGsTDRytfIQoq+JWtMg57I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 22:05:58 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%6]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 22:05:58 +0000
Message-ID: <5ef62b3f-32c5-47c8-bab1-397dc7084a17@amd.com>
Date: Wed, 14 Aug 2024 17:05:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Add additional information about an SEV
 firmware upgrade
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 David Miller <davem@davemloft.net>, John Allen <john.allen@amd.com>
References: <bba259429fc14c4cac9ee4995dfb05d82065b67b.1723668160.git.thomas.lendacky@amd.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <bba259429fc14c4cac9ee4995dfb05d82065b67b.1723668160.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0089.namprd12.prod.outlook.com
 (2603:10b6:802:21::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: af35bbe2-fbc9-4c4c-0c34-08dcbcad46b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjNweWR6MWFlT0dYSDdMMjlSTkdlbnFFMEw2R3dZNlhoT2JWY3VPSXh5MnFF?=
 =?utf-8?B?ZkFYSkkyMmwra0VnYUNNcHdoTDdoazcxTnVLc091Ym8vQldiY1o4ck5aMG5M?=
 =?utf-8?B?OC9yVklKb0tYWXMvOTZFRDNUeHNvMDhJZ3dHMmJyczB4cHdlc2hYeUZOek1Y?=
 =?utf-8?B?NlgvZ3gyVlJVYW4rQkdTTjhuc0RxVEptM1B6S001R0RGY28ySEw1aVVONnB4?=
 =?utf-8?B?OGFZNFMvR0RGeTFwK21mbXRKVzhwcUhQTHh4U0g3NWpiMTRQendWVGtkNW9Z?=
 =?utf-8?B?T2M2Z25uekRVcXJCMmtGOGFkeUxNWHNuVVVLL2JPSS9iYi9Gdyt4MGd1TFRk?=
 =?utf-8?B?TS90b1RzQXJwREhJZkpVdWQvMjdWbmc1OENTMEtsWGJNUFlkRDVHK0wzeWYw?=
 =?utf-8?B?TDhQQXRBT3FCVWRsMVhGaFdEQWdSMFlyeUh2MlNhUkhHNEhXZDZlcDd6eW9C?=
 =?utf-8?B?KzB4UXVaVW9mZ1RiWnM5T2JGZk4xRGs1eUU4KzY2OENNaU1HaG1oSFIzM29p?=
 =?utf-8?B?Ym81QzdwQmlPMDF4SVdJWTh4K01Bcjk2QkRHSWxOdjlkOHdaTjBPK2pTRU5Z?=
 =?utf-8?B?VHN5MlpLNytsVWNVVjk4b2Vrdmd4Wmx6MkxCMExZcGJIVk5ONTJ6N1c0NXFt?=
 =?utf-8?B?T3lXRWJjTkNJcTlDdXhMRCtuQXhsR2RBNThoVm5tVVN0RWpmTGttL0pSMXJp?=
 =?utf-8?B?SWRnKzNhYk9NVkRLajkwOUFkSlI5S2MrVlM1enZTVk85QlhzOFIzZmhxTytQ?=
 =?utf-8?B?RXo5NUdwU3dtQzA3aDlWZG5ESHcvVTFSNDR4UWpCeldubEVoQlNKRFNFQVBv?=
 =?utf-8?B?MTVPcG1xUkcwWE1mbTJCdnBYQnFnS3VxNzVXbW9TQjBlYjhyNFQxY0FtdUJj?=
 =?utf-8?B?RlRCTTZJdmRlWUlDN0NXdkJSZThRMEdSaUo2bng4RGhzeERicmZ6cS9DSDlw?=
 =?utf-8?B?TlNHUk13bWNLdGN1Mng2K2NzMkROd2pucFdENmJtZXRCOGtJTTFpTFF5UjlB?=
 =?utf-8?B?STRERkpHY1BBZ1ZEVEhSbTlQbS9vaXVKQ0FaamdJTm5BbVA3akpDWXBJem0v?=
 =?utf-8?B?VGJPMnVrYVJXMkI3MVVLWVRwVTZodDl4a3RjRFpLQnVUbkw0WlhRN09haHp2?=
 =?utf-8?B?eTdqbUl1UDRpQUZ1WDZIMzFkbUNWanE1KzBMbUc5WW5jRHVyYTB2NzRnMG5Q?=
 =?utf-8?B?OFhhWTB0ZjJoZWRFdGVFaVpGQU03bHJhOVpRNDU3Y1phSENjTFo3WmxNcGZw?=
 =?utf-8?B?YjRweEw3eTRZTlY4dURuemI2MjZKSHQ2dHBjcE5USDBmRkxrT2dSQnltenZ5?=
 =?utf-8?B?OW94N0pzMmR6YXJVRkx2a1NDSUJGT04rcDJyV25hY01KOXZaTUx0K0pZTS8r?=
 =?utf-8?B?blBJWXBNSld0RHUrNWJ3cnRqV1hrL2gyV1Q1M2JvWG9hOFAvajNBaWZhQ1My?=
 =?utf-8?B?a3RRZEdYbjQ2WTJiM3lBN2JsbGx3NjJFV3FYUnF0R09MQlZHSVFJcHNxVXRT?=
 =?utf-8?B?cFR1Y2ZjZ0NzUmxQK0puRS8vdVFMRTNmSG5SK2w1L0RXcnRUS2FDajRlcXJP?=
 =?utf-8?B?VmxraTZjMDR4cWs1cnF0M1p2Y2JPbVpRQjFYMkdqVUhMVGNIbWxXcVl5bDlV?=
 =?utf-8?B?Z2J6ZTVMZ2dLSnRqWXpvMmF3Sm5MU1pvTUU2UUZ5SENBMmhob1FVZWM3ekE2?=
 =?utf-8?B?OGpRVElwZkl5cTFqWmNmam9TczBBTjZYaUdFY2RwTnRHeU5wRFlCTkNJeVhq?=
 =?utf-8?B?NjROSmM5bC9pbWlBaFR2cEt6YUJ6K3RjWGszeDFSNjNMc2xJYytmMzdDdEVC?=
 =?utf-8?B?WGJrOUx5bkZWaGRGTkpkdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTNjQkJ6TGlCUFk0RW1lLzM0SFhlSzhDditTQ3RtTzB0a2grcThsR0FTQytP?=
 =?utf-8?B?NnpaZDRRS2dPelhDazhvUlVxeGdRKzJXTXJReUg2MjlHeVlMd1VJQ2puWW9j?=
 =?utf-8?B?ZkFFS0ZERFllK0M0NTNQMzRJS2RMYlllNy92VkxBQ01yYWF6WUJOdjVoZ1pr?=
 =?utf-8?B?ZkJ3WEdOZWRnSW5qZTZkbEdDYlhHSWxVT2QvYVp0a0RVSDVpV2xLT1BoTTVj?=
 =?utf-8?B?YWVsbWs0M29GVWtleXZPaHViWGVtWTJEOTVmSjhnMHduNmJMbmpPVHNhSUlj?=
 =?utf-8?B?d3BuNnQ0UTJWdGxHVHBhQkt3QXRkQVdMdHdUUlBkMnJ0QVNvWHVaRDNZdjlX?=
 =?utf-8?B?WDBUV051SW9yQm5wS05XUzlZbmpubnFWYXBPN08xMW1VN1Jlam5FYTRDTmZa?=
 =?utf-8?B?QWhQdFEyWGZFUVZDUVdVbXJ6M1ZTbXhYZGJQL0NkMDYxYUdZeXI0czJFNWtk?=
 =?utf-8?B?OEZRUjlibkthTmo2bjdRajc0TVVrVGFzYk9LUDRKRTY1SjNGYmVzYmhMWC9I?=
 =?utf-8?B?SkF5QmlKR3Z2c0hEUnRoalZjNjgxWkc3YWxXOUY1V2JNN05jckJjZ3NScTZa?=
 =?utf-8?B?bGNkNTY5N1hIeVlsUDVZZVd6L0cvcUoyMFFCUU5CQk1YYVBuUmRycFBPKzJv?=
 =?utf-8?B?WUYvT0V2bHZRWWQ1NTBhZjBYZHdtQThkU0V0dFllSFMxNFMvQ25uRmRSRHpT?=
 =?utf-8?B?a0syMWJCS2RpWUNobzV6RU1sTWZod0ZSbjUrajR5dUttYW1waXQyblNKVHZz?=
 =?utf-8?B?WTR4UTkwZ09IQUFRMkdvN01wQVRjcVVKYmQ3eDFGT0N0SjV5VWYySlIxZEp0?=
 =?utf-8?B?SXJXeUhlNWVZai93bzk4UUZVVEVON2U2OU42c0JENlZqeklWMzUzb2krS2hS?=
 =?utf-8?B?bS9sc2Q3a29PQ0dIa0lMdHZOeUxjR09zVHpIZjVIWXZxZlRyeFZWbUduQkd0?=
 =?utf-8?B?UlFObVBLNkVMU0F0b1lPbG9JMkRCalNpeHNFRUdxRG1wWlJsdFJnYWR2V1lO?=
 =?utf-8?B?MjBVd21XOXVsTkt1NjFTaGl4blhyWmx4RlVDd3lpQzFqT203UGJ4MkZYRURD?=
 =?utf-8?B?WDlTcHBqaEYyRHdzTWdVM21WVVlleGxGWmRHejhHVk0zMGVrd2MvOEk0L3Mz?=
 =?utf-8?B?WWdma0FUZ09EalEyU29jSE43MEVUYytKWXYvQjlrWFNLNVhMN05TQ0FLY0N5?=
 =?utf-8?B?VGg5SHVGdUdoUWJ4WlI0WkUrMGxhSjZwMXMyVCtSUEI5cDRTU3FJTmlBdFpp?=
 =?utf-8?B?bk90cURvSXRlL1RDV0FkKzVzZ2UzMXRpTXVJT3VFUkxIaEZwN2FRb05qZkFr?=
 =?utf-8?B?SUpnUzliZ0c1d0ZYQzhwUjdLN1BnMzVnMnV6djVnRURPOHVBejFocS9nZVFk?=
 =?utf-8?B?ZTVadWwrZitRaTArQnB4bWJnMzZkK1FUZHljZjVCNW5lZHNTR1Fkd0FyWmMz?=
 =?utf-8?B?NHp6VUtBRWlzaUVJOVBjaERmUklYOTRyajhJZkh6c0V5ZnBoRmhqYUlGMWtY?=
 =?utf-8?B?aHJtS3c3Wm81R3pBemRocStXbk5VZnB6bjJqT0RUUjRjaVZxSWx2bFdFOGhq?=
 =?utf-8?B?Y0hZU1d2M1RHQkgya0VtR2NvWnJHelloM2I0aEFaZWdTbVVjei9iaWEyb3k1?=
 =?utf-8?B?cUdyWFoxa2tzK2d4VnNVcG5aSTZnZU9Oc2wzRjNhZXRZa1o4R2dhRzBZbGRB?=
 =?utf-8?B?M1F3ZlRlQytWbnZSVTB5S25zVG4vczU5b21GY3RCaG41cEk2TUkzQmlXSzRu?=
 =?utf-8?B?K01NL2pPZVRlRzl5MzltcmNZS2VuaXRiWWdFTlpwSzd1Z2h3VGVYS0xIeUZF?=
 =?utf-8?B?VkZ6OEE3RFZFQ0xoWHhHZlhVcktiOHVuWkNmTWxMWlE3bWZOOUcxNk44M2tj?=
 =?utf-8?B?SVJxY1I3bzRJaFh1c2k5d2p6QS9SZEl6MWhxbVF3MFhXU2VtbFcvQkxZRGd6?=
 =?utf-8?B?TDBTeE5WL21jbEpLTTJoUUVMVnh6NEpNaXV4c2V6L3JKbWJyU1BnNGJML1Rs?=
 =?utf-8?B?czMzcTFaeUFLdjhCcHpPNGFHeGVnTG5Ed0Q3dzd0alovTVVEUGtmY28xZ2Jh?=
 =?utf-8?B?VWFhb0JBQ00zT3JZZ1E3cG9mNDdtVUNXSk5Kc08rbWp2S1Z2VzZMYnBJM1VU?=
 =?utf-8?Q?7iL7pBLC9mpDX4q2G5YtHzCC/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af35bbe2-fbc9-4c4c-0c34-08dcbcad46b4
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 22:05:58.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3XoD/1ZjsCz+glB+wIENhHaQ6kyKgkOxkkiN5VGqiL6x1SMdUGlF1JRb0VS3ZSZsly+78KpXj0BSoyIjCYSUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038

On 8/14/2024 3:42 PM, Tom Lendacky wrote:

> Print additional information, in the form of the old and new versions of
> the SEV firmware, so that it can be seen what the base firmware was before
> the upgrade.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9810edbb272d..3b89f23afcd7 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1629,8 +1629,6 @@ static int sev_update_firmware(struct device *dev)
>  
>  	if (ret)
>  		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
> -	else
> -		dev_info(dev, "SEV firmware update successful\n");
>  
>  	__free_pages(p, order);
>  
> @@ -2382,6 +2380,7 @@ void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_platform_init_args args = {0};
> +	u8 api_major, api_minor, build;
>  	int rc;
>  
>  	if (!sev)
> @@ -2392,9 +2391,19 @@ void sev_pci_init(void)
>  	if (sev_get_api_version())
>  		goto err;
>  
> +	api_major = sev->api_major;
> +	api_minor = sev->api_minor;
> +	build     = sev->build;
> +
>  	if (sev_update_firmware(sev->dev) == 0)
>  		sev_get_api_version();
>  
> +	if (api_major != sev->api_major || api_minor != sev->api_minor ||
> +	    build != sev->build)
> +		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
> +			 api_major, api_minor, build,
> +			 sev->api_major, sev->api_minor, sev->build);
> +
>  	/* Initialize the platform */
>  	args.probe = true;
>  	rc = sev_platform_init(&args);
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
