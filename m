Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8E440649;
	Tue, 15 Sep 2026 05:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451889; cv=fail; b=b97i4XDw09a4QeqCRy51grsUSpXgSL0kN4as5RyzaOBKbBww2G0EUfcfRQagxc/FYj8vJRn/wSrnNQcL0hW7GXNs6bE5L5h8JynB0ieJsdOLA13pUY1ZpEV4r0uHnrX8UePTpbaksSwFJY3MQmIvk7anfalJjmwyDnTXAZfuOJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451889; c=relaxed/simple;
	bh=ojyIHR8MaN+JBkJx5V3mu0CuWyhxWCCB6p5udljE0NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T06xUkltnfq3CeRYloJJtEj7ZM6QjMvnhmdCAt80kvNCzvuPj+ll56HgwyEPzhinCH0Of3gL+8+CWcpQz0H7zmEW0Q417fmYIWGGCoKnijv3kdchJhmS2axFhkZj/3eosmKLlOWwz3DyRjOFdhROoEbnVZ8zXSH7Y4Ixc0pugBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UMPdsgXA; arc=fail smtp.client-ip=40.93.196.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UMPdsgXA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxDqqkxTpl/3HXzkOdWhWJPLbPGwvwXSbrHkQq7tbJECsEv/sFFWYrwfrneWHPj6c98Bu9Bc3yT89i2HkG84cw0H62Me7c5lCavze08Eg8Z2CfN/TZZ9Y+t1LzUzHATY7oJdCmFeTUyLlZFDPkkhyMo4I1pnMcgUpSYM3xwcquIgEPUA2w6s10/lv4CXgkjaWbD3o48K+XS3RIRxtBgKbFeEEjaboUTz5zuxlG0RJWlMrX43lwGDH9vXZJEMeGy/ZypYBVJnH9hwXaHsFlnwR/DFTsPjLlAkmGh3F71QhtsB2+FeGwW3gUXj7uhCtxRUNZZ4Y3WmPKtSUqiQpRzlow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9OLj7hMF7DCp3kIP761BT965zPE5VfsIJleHJ78rKw=;
 b=DNQ/YGWQuO371H2GQXOru9pHU3L6Qn3bXFi92hpMl1IK76jSS/0vggsMv3BkflHPX5v5bwdeVu4XplS6n76L22WIVSvUvWqkYkhIVBxThmlLZ/31mviAAGcpDnSlPDzjlPuP4Wcycz15Ik0Q4ReTAKiBFeb8QFgjta2OvLb5gy/EHs/RoiXFsWe8Zl2ueU+FSc/SfzLp/m+EEG36Bo9A0kMSSLHro13ZAea5XLAg/8yRIzCfvof05h576M1XnZEL9+Rh468wuSF14zR0kgD2Jol1gL24oTkhniBjOg+m1hbtcFV+FGTmUBz2A2ZRSm/W+iXzDN4KGK0vK/UnfwYcqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9OLj7hMF7DCp3kIP761BT965zPE5VfsIJleHJ78rKw=;
 b=UMPdsgXAnvVIeG9VPOyk+YxEZc5ubnjC5H8Lw/9l+4LCdSBzLARzcUC8iMHSY9aP3h0UUkXCHGlJgcErPxZ3ktNcLJtoULJiP6NOIinfwUJE1qN+NllRiyhLbf7d5JKm7Sm/w2KHVcFoies8LigUoIKjx0Sx2AORAbczXtl5ZN+0ELyvnoIAHvMtaNRHALBFqDV8MImAcMFHDnfDbvfkmgUO+elvsh4hsx1e0/M/OEp/nX4ArPxur1neq2EbPBR75v1L+ZPfR97RYtFkfrSHlYSv2weNOvC68eEPYw1AuIOr210lRHKoeClq6qqd6sPVmE9w8LOkLM75AIbqKw5N+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by IA1PR12MB8468.namprd12.prod.outlook.com (2603:10b6:208:445::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 05:57:56 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 05:57:56 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
To: akhilrajeev@nvidia.com, Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, jonathanh@nvidia.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-tegra@vger.kernel.org, thierry.reding@kernel.org, lkml@vger.kernel.org,
 Wentao Liang <vulab@iscas.ac.cn>, stable@vger.kernel.org
Subject:
 Re: [PATCH 4/4] crypto: tegra - fix host1x job leak in
 tegra_se_host1x_submit()
Date: Tue, 15 Sep 2026 14:57:27 +0900
Message-ID: <9pG38-bwQmiNFMwroL7LjQ@nvidia.com>
In-Reply-To: <20260915041426.1725149-1-vulab@iscas.ac.cn>
References: <20260915041426.1725149-1-vulab@iscas.ac.cn>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PUVP216CA0005.KORP216.PROD.OUTLOOK.COM
 (2603:1096:301:16f::16) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9dfe3b-4e7e-456f-444b-08df12ee4a29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	aFaGkpUN8x+5dsI8Z7ZvHhMk/d5EbSfDLU0zdHSU3Gxig6Sz4xXrDG5kgJ+/HhH63tBw01c+p055Xk3m7Z8jaZCS+nwKviakFZC7xTRSi5qUDwLvUDch7B4CzZeqZSF6sZKi6Fi+57NUNZURMgofUYmh31H3O3/YBOCAfZqsCnFP8TFgpE7MsAppHbbAAAJF9ch0WjhRR/R57wET24LYqxcNQg93mnomOADjGDzESN5YJDmdMFvvm7lTXEXPpyJsCZIDckbubosUJtUqEpPzI3NjMI021uByYmP0FoDI6UBAWWwfiHP+Z3wk9j8COYnQBjJ+Nj77e6tRydn4u2hhbEvNX1667el/oQbPCFiNKNgVHor/gpl55FkU3BWljpKF3QnC1ib++yoQbWljsJeQYYy3ExDk0dUEF0BvIcvlqf6NoFCSIqML9akijDnPBF3o4GSDtZ09qUWOliSXE11IihbjumNjp8/6l/GXOkYsnIANv7B9HjZkamiolO1+TNuwimTmBPp5GxFOpgL9Q6eYYmo7AkhDvywaHOdxJn7ADaLIG1Xihy2U5SSGfjTHu84vMGkLlGsmw4EHtXQXskrcGiVczBlmB+1v0+2Gvll3pyydwvuXTSymXPK8aEaUtCR+ipvQT7YcVKMHRlkRynVYQ65KX899eOOgSA91uFA1nIg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTRHSG5TcVQ2UUcvZzhVdmVJQlZlQk9LR3MrTjZ4RlJVOVNrckZhWThsaGZa?=
 =?utf-8?B?RkVpMTBFNlFrTWFjZnZQNTdyQWx5bk4zZGtlb1dDZ0VlQjdqVUExdnlmdXpR?=
 =?utf-8?B?YVRJWDU0c3BMb1pqaGc1N1F6ZFBMczdsSlpISzFjWEdjc3JoNTFpYlByVzlZ?=
 =?utf-8?B?OHp5WjMvY0MrNk4wOGtTMmNtYkJ0M2lCU1ppbE4xTTByNzVDd0tSU1Rsc2Jo?=
 =?utf-8?B?cFR6bGRRZk9XZk04Y3RlcE11VFdGc1NiQkk3c004OWQ4aUthN1d5Qm1XUmRV?=
 =?utf-8?B?L1hUUDZjdExiajF0NnhGSlJ1b2xUaTZDWFBFQTZDakgvRVpsRDgwd2VzNHgx?=
 =?utf-8?B?ZlYwa0NZcFdrSlhsa0JWNGg4c25Qbm5XeklUZ0M4ZEtZOXlNUXppVTNSSlND?=
 =?utf-8?B?WVgybVQ4VC9Sb3hoTEt1NWJxMDBkSnRVMGhCZmNFOUZKeml3NzF6SW9vT1R0?=
 =?utf-8?B?WDdxZnJHam5IVzdLME5wMTlOR012R0lETEFxK3hUTFBuNzkrT1RhVVBXcFV6?=
 =?utf-8?B?UzdoV1dmRnEwRXpYbHIyck9VVmhTbXNmVy9JVnVRR2FXRkZ3UW4xbm1ySVlx?=
 =?utf-8?B?TW1sNmZ4a3JOeE54T3l1a3RMNEl2VTdLSVV5Sm92L2YxdVh6dFBreDNLc0NK?=
 =?utf-8?B?TTQ0ZWJibE1xWDNXL2plNXhwYzFGeUtteXBiWk94QkFjNUN1WEFnd1IxdzNk?=
 =?utf-8?B?UDVISHZveHFaYmwxbVlYU1Y0bDZTOWtHaGZ6MjVvRll6Z2pWQWpQQytQbGR0?=
 =?utf-8?B?R05ZWFlVeWd5MUNmbWlyYm9TbmhudmkrU20vUHl2NnZSdlhDaTNmRzZ6cStx?=
 =?utf-8?B?Y0tjNXpNbW5MMlFrM2lEeitBcEUzRGJKWWF0Y2hzcloxcWRaVml3c25GSTdF?=
 =?utf-8?B?ZmhEODdVVjRaRG5meEJrV29RMER3cVJ4Q1haV3dEUlVPSzEyNko1dmxydzBT?=
 =?utf-8?B?OGxOcXVYa1I2NEhuL1BuQkZwSXdmb295OU8rZTZwYW5QWkkrdnpqUFUzbFdR?=
 =?utf-8?B?TGRpZ1R5UGE4VGxBUHFTUWU3bWppQThrUitJeFdGVjM0c1VFQi9aUFIxV3pa?=
 =?utf-8?B?OFZHbTByUThCTHM5dWh1U2lSWFJ1S2drTDZHb3JpVndOYTVUaEVWdUQ1a29I?=
 =?utf-8?B?Tm40ZkpVakZKMUFxYUpxNUZXdlU1VEJiN2liU0pBcDRtbHRNYVpkMGMxL0FM?=
 =?utf-8?B?UmZsaE5mamxlMy9DQnkyMWExbVg4VEl3MEQ4dVJScml4cWRpaWpRRXRyUEly?=
 =?utf-8?B?dzZKU3BvWFdPVGVVY0psUmxyMDVwS0FBbDNwZXpCUjh3TmR3R1VFYXB3N3Ri?=
 =?utf-8?B?MEJXOXY5WGdIRlArOFdvOERSYktEUnVwVHB1ZGVxaDRIWUZWTlVtYk00U09u?=
 =?utf-8?B?cERpWUFjZHExUDcweFBTY1hiOGd6QUw1Z1pkNlIrcjRLT2JteDJEWVdnYXR6?=
 =?utf-8?B?SlZsMy9VUXV5SGxDYlI5aW54OEhHQkJDSmNhVXlXaGxjc0g2RGdMdU5nbXNR?=
 =?utf-8?B?NHM0VDJ5UmVHZVNqcis3dlNQbTRSc1VVU1N4TmQwUVFFZlFVeWFZVUxqYUdK?=
 =?utf-8?B?S1lrelk0OEo4RGJHUk81cDBVSloraTd4em92TUtKUU5QU2k2WnNONWFyb2JM?=
 =?utf-8?B?aFY1cG5WM2V1YTJ3OGxYV21kQ0xkRFJPN3VJTS9OendrRDZ4aEJvL0FheEd6?=
 =?utf-8?B?YUNmN2I5QkpkU0hUTjhGdXF3Y1pxcmVLcE9oZVVjK0tENm1EMmN2bnlQc3Rm?=
 =?utf-8?B?VnRhMVdHWmhiZC83dTFEZEFuYnpKQzdySzJjZjZsWXNwOWlRckZCaWhKZEph?=
 =?utf-8?B?OU8wVVQyMk03NGgraWRjVnhtdmdZaDVjS2Nmb2twNFRFK25oeFY3cENDZGpV?=
 =?utf-8?B?L1ZGT2x5MlNHK1lXREtXZ2xFNm9MaGVKV3U4aVpNRzZWZ1dvbm14c3crYkw5?=
 =?utf-8?B?SkpOdEtsR2lNeThvRXNZSGxMTWNjL2g2bnoyQW8yMmJZZjZRRDJUa2FIQlBk?=
 =?utf-8?B?cnVVUDN1RFFQVllGQUVtL05JcGgwdGZzSmtnUGVQcFIzSEpDNzQ0OHdnR0h5?=
 =?utf-8?B?RmVEQmdNVHJpMkdabkpsNkhycVQxYzJ6dkYzTVhWcDI5V2RYWWI4Zm9sZGtr?=
 =?utf-8?B?cmVUT25QeHA5cDhLeFJIQjFGTjFLSEdBS21EWWlZZ2dUNTg5S1NkZEJjVjkr?=
 =?utf-8?B?S0pMSVA5TnNzMnFvcXZIV2svcmtnMXg5bXRldklhUFhmUmNJd051RUxTR3hk?=
 =?utf-8?B?NnJCOFNZeHcxUXQ3cmZEbXdDckU5QTgvYUszMWFmNnBSaU1IM2dOYVAvMlox?=
 =?utf-8?B?a2djL3BOUXlGRW10dXlGR3dkSnN0YUFUVG5XaUFJcTJFUWlQalYxbGMxSWpK?=
 =?utf-8?Q?kBLiaKi1tAYYGFPpcw/ZZhupcPvD0zxUOSUPUkmW9F3i3?=
X-MS-Exchange-AntiSpam-MessageData-1: Q5LLFw4CU8W2dw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9dfe3b-4e7e-456f-444b-08df12ee4a29
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 05:57:56.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcLZfjAxLvpC2deMDKD6Up7Fjco6brkO4j8FHV8Cdt0+l3iA5m5gSPeUJm5trMVabdrcpnOCSNgaSuB8I6BFEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468

On Tuesday, September 15, 2026 1:14=E2=80=AFPM Wentao Liang wrote:
> If host1x_syncpt_wait() fails, e.g. when the job times out,
> tegra_se_host1x_submit() returns without calling host1x_job_put(),
> leaking the reference taken by host1x_job_alloc() together with the
> syncpt reference held by the job.
>=20
> Jump to the existing job_unpin label so the job is unpinned and put on
> the wait failure path as well.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/=
tegra-se-main.c
> index eb71113ed146..1afbe5eb90af 100644
> --- a/drivers/crypto/tegra/tegra-se-main.c
> +++ b/drivers/crypto/tegra/tegra-se-main.c
> @@ -180,7 +180,7 @@ int tegra_se_host1x_submit(struct tegra_se *se, struc=
t tegra_se_cmdbuf *cmdbuf,
>  				 MAX_SCHEDULE_TIMEOUT, NULL);
>  	if (ret) {
>  		dev_err(se->dev, "host1x job timed out\n");
> -		return ret;
> +		goto job_unpin;
>  	}
> =20
>  	host1x_job_put(job);
> --=20
> 2.34.1
>=20
>=20

This won't apply on linux-next, because you already fixed this issue=20
(correctly; jumping to unpin is incorrect since after submit the host1x=20
driver owns those resources).

Mikko



