Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C04028C4;
	Tue, 15 Sep 2026 03:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443658; cv=fail; b=n3W2F08PmCYAnSJEM8DZG82ZdC1oaun6JzIMc2p94P02gg2Pt/znKM9y1LjOUwt9XmXb0I7gCr2U4jqEbVBhhI9mEkGiWERwxbFNtXXETjH71LBze0a1E8gVl1ZfWicWpy8r6UF2JWQmnwI7L2iYwqEXe6IGI1qIBFUP6NyLAMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443658; c=relaxed/simple;
	bh=wUE5KhyewbDXUPkYSTsCOv1GQ09GalmQE+D+S08aYpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=atPqkHDNX06ukSwr0vjGbcLkokfRm2x72E+NCbPS9OrxRjOCvkRJghPUckoIyQiLmWz6x0CvqH3kMqsLbIgQqUu3dNfTvbQgcBgN8kx5nhL5UIZFFm76j+icWvPO9PvMq9MpdcOj5s16UT1Lt4fihdVDpnREDGJ8pw0HAAeMxQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SwZwaFSx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=anmczJni; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SwZwaFSx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="anmczJni"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789443660; x=1820979660;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=wUE5KhyewbDXUPkYSTsCOv1GQ09GalmQE+D+S08aYpc=;
  b=SwZwaFSxNKxWj3ucTknDMDrGp3tuUFkHPf0UvXH6KrFvBIYOzPokqOP1
   B6vvoUziP07dtrh3VVVlc+MfQuRqh5f8PxjXWLf33gEfj45cwUue8eaop
   aDzHWAxxqv5KgwCVmYxdFfGiC1eNsYXY+R3MMA5o3vneMaIXUrfm3imQq
   9W1nTf19rwKp9EWewfXIgsSgPMBUu3OKP3BiVRVsAR1jy0C670IrhxbLR
   CF9XImgg6tQ/XSVOBA8N8u58GqdybYTqwWiJsdzzNUjQncD3fSz1T7fT6
   oxOtfMcvFgH4krhUWjzoYWDU3x0bI7P/qkUOS9z/9f9nfweVDc/bj3VY9
   g==;
X-CSE-ConnectionGUID: cvz87VUeREqVAYkM6y+uKw==
X-CSE-MsgGUID: mPjETST1SnS+5lCCFN/OOw==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="155490712"
Received: from mail-westusazon11010061.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Sep 2026 11:40:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAj5z0rSru9KEt5wt7VaWNkPb7o4rXnBuBAaH90s6i293SEa2lELE1AvUHgostnfYYCyQfK/CSJSH83EiCrfWnlO6b4bEnK6kqaozvHskkyfWCSUAjjRdUyGHiT/Z9ezVvwD4+mRoCjxWWh699dcuqva9HXV2FoTlaG9XOQ8vhw55VeZnj/L7n43WdPqj28HiFHQ3+6lm62dqBxf9MHZJO9930/6yz+qnnlmOQyMY2ruekGsTSW9BLVnZzPqfXrv780pdUibcEnvSTOf7Z0wZtqELc5ZvFmNxpVtxSSFdfOnWzRsJ5kzOYdAmon4GACKfw6riy8ZjXTNLKgz/TnSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35hQkXpNZjPn/7ExI5Ek8d6A0SlUOeOa0hky+Mlg9wA=;
 b=vvwNj/H2xSFio2vHqdBzKyKYdlrAohF2tTPmT0ZVuU6pxAHlRG4jlWvs/4jH0/pOz9ReDUlCNnqgYVCIVrQm9kWkFUwQLjRMShLwVP+JKDJo9dTie/snWMTfuGdf4Vb2h3hGinK/nD1arixOpm52PyhWxDgSZxSuId+qH81chIFKehFC9JqzgePB3wD2iyEeuDF5ULoMer4JMdklkPkxXNrmgrm/3Xe7uyjrnRUiCkC204waEgK6nNmlwxYrXwDXMkhQaoKW3jtapfHStSMYZ0NWLJznk7Kvdf3BxMOxFXJF77CSPD4l++EvECbui/JT8aY11gWx2tTtOmYKqMeOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35hQkXpNZjPn/7ExI5Ek8d6A0SlUOeOa0hky+Mlg9wA=;
 b=anmczJniWnFmzI+N9Bbn5N/tqpevjfkET14EQGeoMWLayW53+keGGWtbjYRFDLRxNM7Zqdw5FC65mCNmOmnaOux2m+z3QTq4ScGN2RUQpgdwGinc1kq+K9KTqT6QOvo6PEj8nK8lLzXcI8/ZlylJ4qxSuzLLbgEu49JypiDjSU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DS4PR04MB9746.namprd04.prod.outlook.com
 (2603:10b6:8:278::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:40:46 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:40:44 +0000
Date: Tue, 15 Sep 2026 12:40:36 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: syzbot <syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com>
Cc: bridge@lists.linux.dev, davem@davemloft.net, edumazet@google.com, 
	herbert@gondor.apana.org.au, horms@kernel.org, idosch@nvidia.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, razor@blackwall.org, 
	steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com, Thomas Graf <tgraf@suug.ch>, 
	linux-crypto@vger.kernel.org
Subject: Re: [syzbot] [bridge?] WARNING: locking bug in match_held_lock
Message-ID: <aqi7fpazv2KDDdvn@shinmob>
References: <6aa5fcf6.f2639fcc.29487d.0048.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6aa5fcf6.f2639fcc.29487d.0048.GAE@google.com>
X-ClientProxiedBy: TY4PR01CA0007.jpnprd01.prod.outlook.com
 (2603:1096:405:26e::10) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DS4PR04MB9746:EE_
X-MS-Office365-Filtering-Correlation-Id: f2977869-c2a6-44ca-150e-08df12db1f8f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|19092799006|6133799003|22082099003|18002099003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	KMDbjrCAeZIW2yzkTygMTLRqXds225+kXCNYOy1NNjdgnI6n16AUKKb6dMe/kcM7Sv/FiRRqT2Mz+laVPTzv7nBPX+cgCLCsnE5M9MCRlhrcAIWUutXaYWgL2QDy66nvX21SaufIUvXstORVRKTQ/Nohux6EM4TMMIMrPYAh2jvFjN8MfDGzw9jbE0ChBSWrRvL+4+lQ2G47ICfZezDMRHifMpmwg6b8wFggTNoJvIhcAvfkuhocNLscCjDZoS7jiPF9NiMlHs/PG3bifBvIpcuTYYdxoTnNjBUlZNOI1mTSPXtjp1loLKVkZPZ9Mw7tMrOwSz///MJgOGdkX7j04gsGsgXDgs1LnHI4nkcNjL7Y0LeUUmbMMhCwun5sujZHcFyetfcQdmFKsB+r3zD0FEVZwrLcy5/sM0kQ7ZyVYiqLKySbY5YVc3FC1ELbmtpZZRBfGzkyaUnLthqB9u4gw2SaPiT4q1QinxrQizjH3X8sjOvol3weJ/Qebp66vX6gKemZh7FN5Mogy3PGt90R2P59HlNgCHPOX3h210xG+dRIqG0D95LDRM4RoUTRrRztB3PT+fNBf4f9iocRuBWqQPXYlrwqN1kSiiK0fSPQUi0x9CMLhzyLf8KPHfpedhql
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(19092799006)(6133799003)(22082099003)(18002099003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T3jPaWX1PlY9pSlw1nmxta0uM5FhksaB8W8/bsEvYRwdipbATAxBHt5JSRqU?=
 =?us-ascii?Q?ev86FxDXNAGmEMq5hQeiggJNfRhUcdCD13QIw5st44IBXh9bs4K43VbhbXRn?=
 =?us-ascii?Q?m9cB9GbhrImxxOxzocmtgAkpii7uK1POEhKDl0q/PgoHjs1WyW/k+I6HRpWO?=
 =?us-ascii?Q?XD23rgsCQh9p1RkqO6w2f20GqrGPoT5quf1ESetWgvrJrHrWfGgfs6LJjdVk?=
 =?us-ascii?Q?/yxvmOYrgi5W6NC3EVex6d5mCf5kCzMjFAElAIJ2cbjgrnJTACamFhaKlU8O?=
 =?us-ascii?Q?xyWq4dInUsBV8yVJIY0J59UbINVL5ZMESO43GrcAibjXwHiNZFpGPvq+al9s?=
 =?us-ascii?Q?RqacKgd1JmZ+XWP+zSohSRWIYEEEKWN/uyFXzFA9k0nGnu23DaZWxHw7RjqY?=
 =?us-ascii?Q?As8xYnikOeWJ5/p8Bh5UmMiW0UckkKwdx9GfTD6Peym6bTuK+SX2feaiMPBR?=
 =?us-ascii?Q?dxU3Lymi+GiGcqmUjoH4pq1m+MYodWYQBKBFx4kwqDAug5rYxcT6i0gX/4tq?=
 =?us-ascii?Q?6xddA9LsXrIp96SShPTpn0sGt1TML/StfgOeKYHETxLhdkH54z6DCDSnsY0P?=
 =?us-ascii?Q?cK+6hAMYEK+MAxdU1XHfZ5ALZPhF4gUC4Jz+JDiMsGFHfkrQa4DAnTTvLFyj?=
 =?us-ascii?Q?vKujoDdX/IYEz4hSObCvHOK4w2qAGXfIZEQ2BJagb8gkDagtnzt4i5jPfyau?=
 =?us-ascii?Q?TqhlxE9kXqCix+FwSJAZjhXyZrBTOmzBYXzPEu5PktiGkmHWyo9isO20cczU?=
 =?us-ascii?Q?4ycdsP1hb+odkQBceo2htWk/h6IVSsscBKGWYS2ozzlMdxZyhXbkZmo6dfIV?=
 =?us-ascii?Q?W0UugRCJ8PwSVlnhBx4OAVDLvrmDUkAyPz9wBsGxDUm4E6oL5DUheaR/29jF?=
 =?us-ascii?Q?LYLcVSFp6rQttZC757q+EWnjphioaRgAlYfB+yZdGC2UP20hq7hAdpOhij0e?=
 =?us-ascii?Q?BrVWxk6Es7fkh6xhqTFDOAhHH0bfX2H1WDemJU3up3jailqsdcgmKycFZDRx?=
 =?us-ascii?Q?nV54yiJLWsmL9IaF2O7IE3HKwcAtyDFVkJH2LRW2+oqLe/U9KydWIo44cLgn?=
 =?us-ascii?Q?JjS+UcTxTCIcd6JAwE2PG66v4HGCDb0e/iOq8gYzX2eHuuxXM3TCHoO0wJd2?=
 =?us-ascii?Q?ji+lFwk58xb2eu94XCJrYxHom0XNBTpHlzV9ly8raP/gmkdNwxRUKuoyETe0?=
 =?us-ascii?Q?3I2gsdO+9WWRdNo5/iio4J9/hmNSRIqCvLp+Xu43i0TAFJgh6GwLptsKely4?=
 =?us-ascii?Q?X8zIO1HD2Gr5iOk6XqudkrNgHfV3YtavlPXZART90aPVpNBBRWm6jY/8agN4?=
 =?us-ascii?Q?Zkq7/q7MhojVbdILhTYJdOLP16inByIGUwOH+u0ZFX8dTHgwsOTjKQXFn1i8?=
 =?us-ascii?Q?QN8D89US0Kup+BrPDwFBAR7nUpNQV8W10Gaj4cXW+xfzSNdqw57VYB9NBbyL?=
 =?us-ascii?Q?4COnAos2LMoTgWxDh4wqzkgu8/wYVEsPD0ZUbbU3x361EC1cfsG+OZXs1zXK?=
 =?us-ascii?Q?FUZZfSOrRtmFiQ9xKG374/1SnvekWWzFYsec0ggqfbQdzKaHAigqMpXBC4VM?=
 =?us-ascii?Q?+qLaBsIpJrPlwZUSi7HTC0wpHJjAMFpyIvIsMIkdPFE9eLt21siz0yn4kCqh?=
 =?us-ascii?Q?Be8rk92vtWV+AKs9GUx8rzlML26ov6qpPO4mQNix6OjbhwBo2IQRJy/aptzD?=
 =?us-ascii?Q?YPDKmZGYS93SH+4Ya3BTc/ChYQhp9v+wsiM8nG5dghcamFZ6WKDkORE1rwss?=
 =?us-ascii?Q?7VBXycX6JWln6kbe2rD6XlwhJX4AYuI=3D?=
X-Exchange-RoutingPolicyChecked:
	HOikwoigujxxCwV1yljzfNezaaA80SqCVZ8FI4hv8z4wEbRq/a4iccaQRjOf5D3Uoo2kq1z9aQOQTOkdL5J3V9imkH11hHamg22Ay4vNdYq5u+ssj2lT+V2xFsi3QIrGed0uXHOmahGW5/jetyk8yDbSlPihEYBklem/H7s79ubsb05yx54JOm52ir7y+kZynfWtRoGvLRdPFwqXJw/xv86Nu5MGtMD5oi+wyS69BU1ytj0cQSkBCY4jpdQ4j9w5y2PR7W9VJeMXfbK12VwzffYPqfrXkbNKk+xRG0GoKOyrmL2tlqtexU6rj4Oe9UEqCx55K+PKlMZC0G595AFL/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iaBKxhVygGLHXQY8uM8+nUdtIGgEIc/MbFfrJkaf3H1X/qeJpWWgRThlUYvbSn91/tlqktIW5LwWfAxWnsXy5JI9PA4IA+fxoN466BjldG/yylPbYsCWM3qqMvzVgs/kS504BM6I/9dWOarvosMb3U8O2CXLE/f9js5t/9kqs/TvmtJVacDLGlbdG2e/Men20+jo/r85zO0XnHeqIGOJQavsQ4y8iAEhgYY9GqyU5/ad1BJvsYGvEaPhTDh+29gA5+XouXF0WxnR14hptGTwiMI1Snq0F6KNVhWuj01jxcxzB1ucBcLBw6McHKSdcAXQTmKUOldc9yet3j4/61fvl0V0ZYRp0KSgKn6coX7QXMp4+hUgv3chM/uHl9A34vhp3iOLFmYXne4Dfuk1annSmImuOYBixD7dmE6hYSe9he8JUX7GoStr550YnJa+4pbTeXQdrOPbmicYJzjhCZAzBYH+YSl0cAmkfU/3eG9rdn41IaXFK9UoBHJlxpKcbcIg12bu4mdcrLOxMJyZLmTJkwXaD7V9Ylgc+3rDdSl08D32caZCccbs95FzzxXeOpH5/8lRMEE4CchYlwGZRr9WBtW+f8U+nkv/yeicTR/k4fvAaV2p+sSl384xyTC7OVG1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2977869-c2a6-44ca-150e-08df12db1f8f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:40:44.7553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIISPHX9uX6rs5KmfnB3sG4d1BMC8xtILRYKfn3bULLDyfm+rUVKzPjfgdI3iXjICRdyGJstfPTJsEkNm3VxG/P5j8al+t0ZsnH7GENx2rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9746

CC+: linux-crypto and rhashtable maintainers,

On Sep 12, 2026 / 18:31, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    a9d7ced84989 Add linux-next specific files for 20260908
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10880f4958000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D17eeb09695a2b=
3c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4d0e4d2db6dfde0=
1b52f
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e25=
5-1~exp1~20260613092250.77), Debian LLD 22.1.8
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4f470407358e/dis=
k-a9d7ced8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/858b9d7ba687/vmlinu=
x-a9d7ced8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ef971d22d75f/b=
zImage-a9d7ced8.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com
>=20
> ------------[ cut here ]------------
> Looking for class "&ht->mutex" with key xfrm_policy_init.__key.84, but fo=
und a different class "key" with the same key
> WARNING: kernel/locking/lockdep.c:958 at look_up_lock_class+0x8c/0x110 ke=
rnel/locking/lockdep.c:955, CPU#1: kworker/1:6/5751
> Modules linked in:
> CPU: 1 UID: 0 PID: 5751 Comm: kworker/1:6 Tainted: G             L      s=
yzkaller #0 PREEMPT(full)=20
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/24/2026
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:look_up_lock_class+0x9a/0x110 kernel/locking/lockdep.c:955
> Code: 00 00 49 3b 46 18 0f 84 82 00 00 00 49 81 3e d0 44 58 94 74 79 48 8=
d 3d 44 f2 94 04 49 8b 16 49 8b 76 18 48 8b 8b b8 00 00 00 <67> 48 0f b9 3a=
 eb 5d 90 89 f3 e8 67 0a f4 f8 e8 32 5c be f5 48 c7
> RSP: 0018:ffffc90000a38070 EFLAGS: 00010002
> RAX: ffffffff8c6bb940 RBX: ffffffff94478508 RCX: ffffffff8c6bb940
> RDX: ffffffff9af23440 RSI: ffffffff8c6bb900 RDI: ffffffff907ddb20
> RBP: 00000000ffffffff R08: 0000000000000100 R09: 0000000000000004
> R10: 0000000000000003 R11: 0000000000000300 R12: 0000000000000246
> R13: ffff8880307a8000 R14: ffffffff9af232c8 R15: ffffffff9af23440
> FS:  0000000000000000(0000) GS:ffff888124db7000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b3401aff8 CR3: 0000000074540000 CR4: 00000000003526f0
> Call Trace:
>  <IRQ>
>  match_held_lock+0x9a/0x120 kernel/locking/lockdep.c:5364
>  __lock_is_held kernel/locking/lockdep.c:5654 [inline]
>  lock_is_held_type+0x89/0x150 kernel/locking/lockdep.c:6016
>  __rhashtable_lookup include/linux/rhashtable.h:623 [inline]
>  rhashtable_lookup include/linux/rhashtable.h:668 [inline]
>  xfrm_policy_inexact_lookup_rcu+0x60/0x750 net/xfrm/xfrm_policy.c:2068
>  xfrm_policy_lookup_bytype+0xb35/0x1840 net/xfrm/xfrm_policy.c:2193
...

FYI, I also observed the WARN at look_up_lock_class() and match_held_lock()
called in the rhashtable_lookup() context [1]. I used the kernel next-20260=
909.
The WARN was observed during the run of blktests test case block/008 on dm-
flakey device, but this test workload does not look related to the WARN. I =
tried
to reproduce the WARN by repeating the test workload hundreds of times, and
succeeded only once. The WARN looks rare, but I'm sure the WARN happned.

The call trace that syzbot reported and that I observed look rather differe=
nt.
The common part across them is the rhashtable_lookup() call. So I think it =
is
the better to involve rhashtable experts. I took the liberty CC to them.


[1] WARN observed at blktests block/008 for dm-flakey

WARNING: kernel/locking/lockdep.c:955 at look_up_lock_class+0xa8/0x170, CPU=
#14: kworker/14:1/309662
Modules linked in: dm_flakey iscsi_target_mod tcm_loop target_core_pscsi ta=
rget_core_file target_core_iblock xfs target_core_user target_core_mod nft_=
fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 n=
f_reject_ipv6 nft_reject qrtr nft_ct nft_chain_nat ip6table_nat ip6table_ma=
ngle ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defr=
ag_ipv6 nf_defrag_ipv4 iptable_mangle rfkill iptable_raw iptable_security n=
f_tables ip6table_filter ip6_tables iptable_filter ip_tables irdma ice sunr=
pc libie_fwlog gnss idpf libeth_xdp libie_pci libie_cp libeth ib_core intel=
_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_c=
ommon skx_edac skx_edac_common nfit libnvdimm x86_pkg_temp_thermal intel_po=
werclamp coretemp kvm_intel spi_nor mtd kvm i40e irqbypass iTCO_wdt rapl in=
tel_pmc_bxt vfat ses intel_cstate libie fat intel_uncore libie_adminq enclo=
sure i2c_i801 spi_intel_pci spi_intel i2c_smbus lpc_ich mei_me mei intel_pc=
h_thermal wmi joydev ioatdma acpi_pad
 acpi_power_meter dca fuse dm_multipath zram lz4hc_compress zstd_compress a=
st drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper nvme drm nvm=
e_core mpi3mr nvme_keyring nvme_auth scsi_transport_sas scsi_dh_alua pkcs8_=
key_parser scsi_dh_emc scsi_dh_rdac i2c_dev [last unloaded: null_blk]
CPU: 14 UID: 0 PID: 309662 Comm: kworker/14:1 Tainted: G        W          =
 7.3.0-rc2-next-20260909-kts+ #1 PREEMPT(lazy)=20
Tainted: [W]=3DWARN
Hardware name: Supermicro Super Server/X11SPi-TF, BIOS 3.5 05/18/2021
Workqueue: events drm_fb_helper_damage_work [drm_kms_helper]
RIP: 0010:look_up_lock_class+0xa8/0x170
Code: 39 6b 40 75 ed 48 8b 8b b8 00 00 00 49 8b 74 24 18 48 39 f1 74 34 49 =
8b 14 24 48 81 fa f0 31 7f 9a 74 27 48 8d 3d b8 66 4a 02 <67> 48 0f b9 3a 4=
8 89 d8 48 8b 6c 24 10 4c 8b 64 24 18 48 8b 5c 24
RSP: 0018:ffff888e40108088 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ffffffff9e852a78 RCX: ffffffff97838ae0
RDX: ffffffffc271a2a0 RSI: ffffffff97838a60 RDI: ffffffff997aa470
RBP: ffffffffc271a2a0 R08: 0000000000000001 R09: ffff888133ab3018
R10: 0000000000000004 R11: ffff888e40108360 R12: ffff88812d59e1f8
R13: 0000000000000003 R14: 0000000000000246 R15: 00000000ffffffff
FS:  0000000000000000(0000) GS:ffff888ea59d3000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dba25b8c90 CR3: 00000002a6911004 CR4: 00000000007726f0
PKRU: 55555554
Call Trace:
 <IRQ>
 match_held_lock+0xdb/0x130
 lock_is_held_type+0xb0/0x180
 nft_rhash_lookup+0x541/0x7e0 [nf_tables]
 ? find_held_lock+0x2b/0x80
 ? __lock_release.isra.0+0x69/0x1a0
 ? lock_release.part.0+0x1c/0x50
 ? __pfx_nft_rhash_lookup+0x10/0x10 [nf_tables]
 nft_set_do_lookup+0x1ac/0x2a0 [nf_tables]
 ? fib_lookup_good_nhc+0x104/0x380
 nft_lookup_eval+0xcc/0x590 [nf_tables]
 ? lock_is_held_type+0xb0/0x180
 nft_do_chain+0x2a9/0x1680 [nf_tables]
 ? __lock_acquire+0x690/0xd00
 ? __pfx_nft_do_chain+0x10/0x10 [nf_tables]
 ? lock_acquire.part.0+0xc8/0x240
 ? find_held_lock+0x2b/0x80
 ? __local_bh_enable_ip+0xb4/0x150
 ? ipt_do_table+0xa10/0x11e0 [ip_tables]
 ? ipt_do_table+0xa15/0x11e0 [ip_tables]
 nft_do_chain_inet+0xdc/0x4a0 [nf_tables]
 ? __pfx_nft_do_chain_inet+0x10/0x10 [nf_tables]
 ? __pfx_ipt_do_table+0x10/0x10 [ip_tables]
 nf_hook_slow+0xbe/0x210
 ? lock_is_held_type+0xb0/0x180
 ip_local_deliver+0x2d0/0x4a0
 ? __pfx_ip_local_deliver+0x10/0x10
 ? __pfx_ip_local_deliver_finish+0x10/0x10
 ? ip_rcv_finish_core+0x75b/0x1470
 ? lock_is_held_type+0xb0/0x180
 ip_list_rcv_finish+0x7f8/0xbb0
 ? ip_sublist_rcv+0x106/0x2f0
 ? __pfx_ip_list_rcv_finish+0x10/0x10
 ? __lock_release.isra.0+0x69/0x1a0
 ip_sublist_rcv+0x8b/0x2f0
 ? __pfx_ip_sublist_rcv+0x10/0x10
 ? __pfx_ip_rcv_finish+0x10/0x10
 ? ip_rcv_core+0x619/0xd00
 ? kasan_save_stack+0x2f/0x50
 ip_list_rcv+0x2dd/0x440
 ? asm_common_interrupt+0x26/0x40
 ? __pfx_ip_list_rcv+0x10/0x10
 ? drm_atomic_helper_commit_planes+0x3bd/0x1040 [drm_kms_helper]
 ? commit_tail+0x204/0x4b0 [drm_kms_helper]
 ? __lock_acquire+0x691/0xd00
 __netif_receive_skb_list_core+0x6bf/0xa10
 ? __pfx___netif_receive_skb_list_core+0x10/0x10
 ? lock_acquire.part.0+0xc8/0x240
 ? netif_receive_skb_list_internal+0x382/0xc90
 ? lock_acquire+0x11a/0x140
 netif_receive_skb_list_internal+0x603/0xc90
 ? dev_gro_receive+0x1e0/0x15f0
 ? __pfx_netif_receive_skb_list_internal+0x10/0x10
 ? napi_build_skb+0x55/0x1e0
 ? i40e_process_skb_fields+0x4a6/0xea0 [i40e]
 ? i40e_clean_rx_irq+0x96f/0x2140 [i40e]
 napi_complete_done+0x1a4/0x900
 ? __pfx_napi_complete_done+0x10/0x10
 i40e_napi_poll+0x408/0xb70 [i40e]
 ? __pfx_i40e_napi_poll+0x10/0x10 [i40e]
 __napi_poll+0x351/0x520
 net_rx_action+0x446/0xc30
 ? __pfx_net_rx_action+0x10/0x10
 ? do_raw_spin_unlock+0x59/0x230
 ? lock_release.part.0+0x1c/0x50
 ? sched_clock_cpu+0x69/0x630
 ? mark_held_locks+0x40/0x70
 handle_softirqs+0x1de/0x830
 ? __pfx_handle_softirqs+0x10/0x10
 ? irqtime_account_irq+0x3e/0x2d0
 __irq_exit_rcu+0x164/0x290
 irq_exit_rcu+0xe/0x20
 common_interrupt+0x85/0xa0
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40
RIP: 0010:memcpy_toio+0xa3/0x120
Code: 5c e9 d1 59 9f 01 48 85 db 74 ee 40 f6 c5 01 75 49 48 83 fb 01 76 06 =
40 f6 c5 02 75 29 48 89 d9 48 89 ef 4c 89 e6 48 c1 e9 02 <f3> a5 f6 c3 02 7=
4 02 66 a5 f6 c3 01 74 01 a4 48 83 c4 18 5b 5d 41
RSP: 0018:ffff88811b3a7538 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000001000 RCX: 00000000000003f0
