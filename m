Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2E3C1D40;
	Fri, 18 Sep 2026 07:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789718384; cv=fail; b=NKzIWmcgI9nEdK+MY28d/l+LoH+JypGGZDAYV6QAAMtj3DfS7RgeDCTFYLIAEZM63g2NCH1gzaaeWZu4j+OUtxiGRkVQHC0eNmNSITIitHGsFH5oO1eYWVNV2on6KBoxj2AcnG7E/ScDuwBK5p/MgPy92xQxtNx2GYxCaYQAg0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789718384; c=relaxed/simple;
	bh=OShWKmslHaYEyc3Ujir1Ehvbjzp4G5ZPyz3coHYx/5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l9PBhpH3dDff6XxFK2va+hGgtDSNd5xKNr0auK5AwIBORRt+4Ays490Z7opHoV51tpY/aTIWyHl92afL0vlWFrMuC7auSLks7LPvTFKNieF8qO9v67XYSG9kuSuST9zjex0hitSNqJB48M92Yh2k+GiUZ7Ra8HAc/WqsEOAqsoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PkYjnC2O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Uo6bf4lD; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PkYjnC2O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Uo6bf4lD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789718381; x=1821254381;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OShWKmslHaYEyc3Ujir1Ehvbjzp4G5ZPyz3coHYx/5s=;
  b=PkYjnC2OTQTBJ7qgfGw2QcxY1SMNCmGu2ztrSW1eTZcDIgTTPRnWc/em
   ZYsk917HgM25tVBwkWDmB+LSPljmHIkJcGqRwha+TQ+jzwZOdih6xr7KZ
   eUbROSaZZ7GRcychLxH5l8M7eYwckNAnj96dkOoMRJM/g3sajWkDdNfxB
   7kXStCcaAj0zzYdsBxnaeKFxAg3TGj04bCKdyuJfwU5x5i8qxIQAjVPmB
   nxwrIjt+L9z3hZtzlRVZcHyTyhgE713nYq0c2TSQg4rDlWDN0isr5B5Bv
   JzutiS/JpEpRTmfT9xXU60kSKyue0LHUyhw9rgo4VIJzPX2FYHzW7mW5U
   w==;
X-CSE-ConnectionGUID: Agx0RN8FQD+KlnbUiLfl2Q==
X-CSE-MsgGUID: 3CNZvPbcSWWpBFOyPulVBQ==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="c'?scan'208";a="155020281"
Received: from mail-westus3azon11010031.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Sep 2026 15:59:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxY+fMagsOYw4tH9CwXj8BmDIHBiCxJOwzAUIQvK2aRfYSA7OsET2ne4lPKtO7trrbARdMhy6fL6oflN2tMv2UnOU78YB6Ib32xGDTBdGTw1CpH9H/lKQ6NU4s0U0KIQUN8L741U44znYtAeqjVQQ+tyIIWRl7lKitX9469SzWHEfJBGM9cWB2PGRGDWkg2AHOIkaxoKi2/fR50b+YP4bmUn+fykCPNcsNrEFRwVJB7PB5SdsqeY3asrx7MC/3PwaGlqOXnWJFJLkyrYruoxi7oFLoyQPecluEy6etwdYyyUt1NtuCDTTZ/+Ghk4NxRHTLIQLr6dTJiR8YCsMR8dNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHNjz0G1ehylBQW4IqacNRcxdZfWCXn5YhW0avpHZRY=;
 b=cHAypkKBwnrRNfLgw6wHkegGhSHaBvib0+mgcvlIfVd82WmfWQraCZTKWqWQr7267hIIMYF8aRA9jKzDtEfJCQJgG2C5AihB+LpIhTZwAI7MC7bPELgtwA9X0QXHEu9wFqomFJsIIYqEusTWrZiS/uQOQodmr7vWb7Y/mmQGpx8p5EZmmr45VRwZBRGYbRGJvLVzfSZmLcZKfDT2od5yaRv1ejbSF1YyuFNsDTGJUZjbV8prcbVY57qgxgd1YzcWjlqeFNMspyF+ZwL1W02DmcE/dfsRXKOT3MjbWuo6z/Tei/lG4V8fnFtef/2Z4HY0nSaD514Y040XlVk56KsMXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHNjz0G1ehylBQW4IqacNRcxdZfWCXn5YhW0avpHZRY=;
 b=Uo6bf4lDDtUUObCYvI5pHUlGYyykEsSV84AU0rZZGKzKgEkTpChv1p0labFz0F9K6582gwv1BpTpcly244HeyDet3E8eACYq1BfdczAiJfV/vM6BhYZBKd2F5NZZQJtqOscZRADsDLi6ZP5jHAckT1YzobXqHnnhbqp2oQarBWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by BY5PR04MB6520.namprd04.prod.outlook.com
 (2603:10b6:a03:1c6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 07:59:32 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 07:59:32 +0000
Date: Fri, 18 Sep 2026 16:59:24 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Dumazet <edumazet@google.com>, 
	syzbot <syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com>, davem@davemloft.net, horms@kernel.org, idosch@nvidia.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, 
	razor@blackwall.org, steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com, 
	Thomas Graf <tgraf@suug.ch>, linux-crypto@vger.kernel.org, NeilBrown <neilb@ownmail.net>, 
	quanyeyang <quanyemostima@gmail.com>
Subject: Re: [v3 PATCH] rhashtable: Use separate lockdep keys for each lock
Message-ID: <aqztNV8fLEDsAtZL@shinmob>
References: <6aa5fcf6.f2639fcc.29487d.0048.GAE@google.com>
 <aqi7fpazv2KDDdvn@shinmob>
 <CANn89iJd0QnoDo0tjrFED2myec38U8joyqR05d6BVnJ-sX=NVg@mail.gmail.com>
 <aqjf7LNmE6InABpw@gondor.apana.org.au>
 <aqpMjQn0g6XxXtyq@gondor.apana.org.au>
 <aqpXcMuAChVSxoaz@gondor.apana.org.au>
Content-Type: multipart/mixed; boundary="z54sx54hf73sufwb"
Content-Disposition: inline
In-Reply-To: <aqpXcMuAChVSxoaz@gondor.apana.org.au>
X-ClientProxiedBy: TYCP286CA0149.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::12) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|BY5PR04MB6520:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b44c1a9-b4ee-4d67-140a-08df155ac5e8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|1800799024|7416014|376014|6049299003|366016|4013099003|4053099003|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	GazSsTTigksLnAdLG2hEth+7/O3cEuB2ILytaYgi+uX2EarH56BbFjZouke3NAS0gussdLP8Og8daoRGEufuKfekCv605CaWVjsAxpM6gfbvEETJWJyRV0tMBLuYxe4s5RhbS+IcieGLLUg27M2sbAtnwIQJUH3nCf5lgBz41I4n1XghbRFXJyIg+W8QgEz357/KIDebtH+cdPZTaDpesPXJNmHNm7tuoPGNpX4OMa/AhJzMPk782nWqB4hiqBYnijdwfOwcPWCVaH2KNhF4A1Z7LIt6tSzJgKgWiCuhYz8/2oTYwLJeuMlTqhkSXAtSp0H5qUUwBJC8qVbtfsjUsoT2wGK6f1U1tGuSsVDJAvRT3jv7BzXwcP6qR0pMc/974sAaV0t1C9v7PEbvWjzuUk3TaZ2oJ55tkh71K223HJJTgHPm1ax6OK5piCoZwnT99HP98zMoD6QmyaGvsvd4BBzejx2/0pbr35EewD/vxwExM75syv30VFwl56T2hdOr/+GAqvFw+KXvCz0FeGiCuQ/dy5kt/t1vK79Yu6hxEgqul/Zij9FxSwIUDDbF+ed7TvxukFBvwgCRXD2K9rf8p1j+ufBmmKlHe3aSuKZ3g+zeVYhC7O0RzH41a3cE1Z+D2iBFXEsxpypyquy9k9SP8QjLV6Zk3gGSazAMSNU1W5w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(7416014)(376014)(6049299003)(366016)(4013099003)(4053099003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cZaftgNus2OIBwfSrbOB71htGky6Ih4+2juqegtIOhGXZVZjGzyYWiszWm2m?=
 =?us-ascii?Q?0DQxoegUFYtKZoGDjkI+Cauf9NSgrA7OCZb8fHNd6W3edwZP/5A44NuVEfuj?=
 =?us-ascii?Q?B1VP0Fv3mzLdRylqEaRNA0+CMHqRBg2HZAP7hcArl4i0sstXJviIzz6AqCc2?=
 =?us-ascii?Q?egq5xh667LPyBSn6iCT1GUO6LZwdCgpbCivvLlsPaHhUtbFgKYc9iuF9Onnr?=
 =?us-ascii?Q?/4MgUoLpXGJXLEyN+wt+40ifkd94+TVV8hDR3Q8xkoaozpSMNnSqT6Nv7tA2?=
 =?us-ascii?Q?NFFsSMrhb0SM3Tzx90P+tEx2+Kx7rs5yOpn0T2EP8Rk0Ljgz2IaVVyqkR5Gm?=
 =?us-ascii?Q?nMaMGxfWZSEpd/VX+11ypwzofc9yXHgM4PQpzMH3S86FtUVxLpCk0qyxgiE+?=
 =?us-ascii?Q?L4wFyhxUJhtGWyONWvoUQppgSevJryY/M9l0lVYjZ01zVnmQOLR4Aby52xcC?=
 =?us-ascii?Q?y5YMEakzf+QP1V6ryrA7z8d352qH8i27EUxWmudzOsu6ktwOmf5kgrrkZ4kQ?=
 =?us-ascii?Q?EhiFTRTlegZfWxbLJrdxptkxIEZXIMhT8mpo5G9INjrxuUdJnKwX0m+Xl6T1?=
 =?us-ascii?Q?3k/MY3H/dLr+3gOVopvrHdZfeRqia0WmliaH5pIyBbbKMCG9JmT1st3OVx1h?=
 =?us-ascii?Q?c6aUkYRrLZSHoklGwFHW2QFJfUlm2v191FsmgWgo/a6DSfBoAJPdQ3BYjdfi?=
 =?us-ascii?Q?4RyPVILd2FZNUDrGzt2ubx8JgCPQ065+/ssiGb3tm2OENW7pSz4RBwROqHnl?=
 =?us-ascii?Q?DXiCJkshd9T0uN3r10PwDSOyx+mOhTQSiZ/BU6HzhK2F62S2acnxKJdnZzvQ?=
 =?us-ascii?Q?9abuVNKIxyzbVBrNxizqu0WmlcgtAjxmxQ4gK8RLShiguKh8ABhA725K7lWJ?=
 =?us-ascii?Q?Q1lGaKyGj2YzDrpfnGCyNUlCyutlu+/qZwqEkhpyCsWDkyjixbFs7wofQ1uH?=
 =?us-ascii?Q?OuQ2a5fr8CclNkBKjzAIGYo2jKpmPiQcFv9J1ZWorGYNYHlUvuxgWPgYGizH?=
 =?us-ascii?Q?KKKmS4q4AEJVM237NgAd+qgab42GdJLMO/wB7rxVSyIcUcBCV4sgI2Linhj/?=
 =?us-ascii?Q?4wAodY7sgg5YcMxrsOZcgEKSBzcliEYgqbn5DetCe49p/r0f/D8XR8A38eae?=
 =?us-ascii?Q?cASqHEpx2fEQq8V+YhTxYs8kXG8cI3kz5m17UJBgQT8ax23uqaU16DdFh7UM?=
 =?us-ascii?Q?ny/rWSK+Uy5gQIA0n9isBuTKf7w5fEsO7uUSqE68cUGVPylPUwelFtofLndT?=
 =?us-ascii?Q?BebxKlj+EfhCR02YViTCOJAg/sw3biCwkg6zIwaKXc7AiL2/ZwoY3wLxY/wM?=
 =?us-ascii?Q?0y13unay3qaDkAHVdMEau0jWFzxJQhVYBCRydGtgA1iIOovQzkwiURG4C9PA?=
 =?us-ascii?Q?e1nOvvERF+ccSoDc6jIHGXSwosNs+5GJdvy2V8Lx3y1qv1SIFKWuCS2l+n/y?=
 =?us-ascii?Q?FCm5+X5TaTx64bxzT2T/I7+hni5UtLJyDPr51Hoqx+LAyQFJtllGxcDTRdFM?=
 =?us-ascii?Q?+Fq6gKY8d9rWN/sRR/1BTgtAE7H8WaECApaYTZmcDF9M39kKY34lTfTXkSTA?=
 =?us-ascii?Q?LypdYQJSnzNxBmnmWTl51qum34IoYvadm/8xO9BT0CrsF6vA7Vqm4I46HD14?=
 =?us-ascii?Q?h2aRSSN7FrTQs/SkzB9B5yn0enJJDIeW3BiuVsNS1GgK4ekfPbzzKO5Pg8MG?=
 =?us-ascii?Q?/WQDutbufeH5mq4xHsCfYy5xhVCTnTqPLwfwfE6Q1sfDr4YheWDI/+oAyDcG?=
 =?us-ascii?Q?A3B47jKsfapkfHBbRtkCybt6IaOiOkI=3D?=
X-Exchange-RoutingPolicyChecked:
	ISOzj/+GU5Gtfdnp7G3B21uYtMM6ldzUK2VHIgg6wLfvtAjTluTm8POkCe7OHf5ykGo+lAnYnk161WDqhWreAHdcIUMeQw7uDA5eq3m6D1CfjZuJQjiNkMhgefQ+8n1+5S0XH+51JxAPO45GK1bbdQi+h5A3HgpGWTIE/zYfvt6DFVUikLFEc7eO1y2wiU7KgSgbR7lSpGQ0A1+b+Who7E8J+bpF9xhfEKodojxOmmUjEG+Jxn5GrZqeJuqCtVuht3q1NSLRnncN/RyKUcyipiqqtVoJMBDRW1TLAGvFUONOmeltSnReiSHUHYBjsNR0b8laVP6xCqEPbzsbWTd+8A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+e4A7i2OPgrDrOcng5yCZhV5EgCl8lAlWZfCgOWSVTRWlP2236u4iJNtrzoHUdoo0AqNb0xPOdWB8IqPuWjiq205lZpBErEW24IwVR/DfaIcIQ7m/dXrF26rQnbOcEezKSL+ObUTdNivSiDHfFz511kA2Tdga1z1/3+kv7qsa0RlqF/j9mHJxPig1DOWaAj6rdXKzlEg10aYkD2MFLeb/0oLzYzV+hIazFQnblInDkYsXxusPnfjkerGrvbKqrKSTC+YI3yvYeG8QT9mO57IAmQ519hu6qTXGV6+L45PVkLP+KzZYbqkwOk2/agnpBL5NoQ3f7ZTSyPZEsu9s5uR1N/72y2av3eB+997XpxZh+YCaB/gn/PblH9YuU4s4JSDEF6fsJf04qz2Z0Rz6o/pqW/P56q7QSXgA3tsS8+VjM0pTAjk64fDlwGCZfX+UbAygFlmZ2OHBUtveh5zxlE+dS5ElyO5ZUhCeN5FN0l5R0qO1mbsKDzXtsObOt/R3cnwQKWhTL/5MQqwxgGLjwUYSbk6U0RHOigrYAWfRCZxmLZNu/L6alUGd9xocTYFfgfuvWDFHSNSm+geVaZ6X30e6cY8hXDVKrrjKiv9qJOxItDguIFFVYp4ulKS2BYzH+sQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b44c1a9-b4ee-4d67-140a-08df155ac5e8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 07:59:32.2424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNd0whkszRmIn9NrcmLjO/QQBbIDfqnHT3GubzzmIPUzEBNqsyaTXu2lhy9NcpNOzB974PoUEAwDowLTa2mSuKJS38XDs0veVUcMrJ522Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6520

--z54sx54hf73sufwb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 16, 2026 / 18:46, Herbert Xu wrote:
> v3 removes an obsolete comment regarding the use of nesting level 2 or mo=
re.
>=20
> ---8<---
> Use separate lockdep keys for the different types of locks in
> rhashtable (mutex, spin lock, and bucket locks).  They are
> separate and not normally nested with respect to each other.
>=20
> Also move the rhashtable_init/rhltable_init kdoc to the header
> file as that's where the macros are defined.
>=20
> Fixes: 4333ab90aaae ("rhashtable: use private lockdep class for all locks=
.")
> Reported-by: syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com
> Assisted-by: Gemini:gemini-3.6-flash
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reviewed-by: NeilBrown <neil@brown.name>

Thank you for the fix action. I evaluated the patch. It takes very long tim=
e to
reproduce the WARN with my test set, so I asked my AI to create a reproduce=
r.
The attached source file is a simple kernel module that recreates the WARN =
at
module load. Using this module, I tried three kernels:

 v7.3-rc3 kernel                                    : no WARN
 v7.3-rc3 kernel + 4333ab90aaae                     : recreated the WARN [2=
]
 v7.3-rc3 kernel + 4333ab90aaae + this v3 fix patch : no WARN

The result looks good, hence,

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>


[2] WARN observed with the reproducer

Sep 18 15:39:28 redsun41 kernel: ------------[ cut here ]------------
Sep 18 15:39:28 redsun41 kernel: Looking for class "&ht->mutex" with key __=
key.2 [nf_tables], but found a different class "key" with the same key
Sep 18 15:39:28 redsun41 kernel: WARNING: kernel/locking/lockdep.c:955 at l=
ook_up_lock_class+0xa8/0x170, CPU#2: kworker/2:1/78
Sep 18 15:39:28 redsun41 kernel: Modules linked in: xt_conntrack nf_conntra=
ck_netbios_ns nf_conntrack_broadcast bridge nft_fib_inet stp nft_fib_ipv4 l=
lc nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_r=
eject nft_ct nft_chain_nat target_core_user ip6table_nat ip6table_mangle ta=
rget_core_mod ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrac=
k nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security=
 qrtr rfkill nf_tables ip6table_filter ip6_tables iptable_filter ip_tables =
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powercl=
amp coretemp kvm_intel kvm irqbypass rapl intel_cstate iTCO_wdt intel_pmc_b=
xt sunrpc intel_uncore pcspkr i2c_i801 i2c_smbus igb mei_me lpc_ich mei ses=
 enclosure ioatdma dca binfmt_misc wmi joydev acpi_pad acpi_power_meter btr=
fs raid6_pq xor dm_multipath zram lz4hc_compress zstd_compress ast drm_clie=
nt_lib i2c_algo_bit drm_shmem_helper drm_kms_helper drm mpi3mr mpt3sas raid=
_class scsi_transport_sas fuse scsi_dh_rdac scsi_dh_emc scsi_dh_alua i2c_de=
v
Sep 18 15:39:28 redsun41 kernel: CPU: 2 UID: 0 PID: 78 Comm: kworker/2:1 No=
t tainted 7.3.0-rc3-kts+ #85 PREEMPT(lazy)=20
Sep 18 15:39:28 redsun41 kernel: Hardware name: Supermicro Super Server/X10=
SRL-F, BIOS 2.0 12/17/2015
Sep 18 15:39:28 redsun41 kernel: Workqueue: events drm_fb_helper_damage_wor=
k [drm_kms_helper]
Sep 18 15:39:28 redsun41 kernel: RIP: 0010:look_up_lock_class+0xa8/0x170
Sep 18 15:39:28 redsun41 kernel: Code: 39 6b 40 75 ed 48 8b 8b b8 00 00 00 =
49 8b 74 24 18 48 39 f1 74 34 49 8b 14 24 48 81 fa 30 a1 92 ae 74 27 48 8d =
3d d8 c5 4e 02 <67> 48 0f b9 3a 48 89 d8 48 8b 6c 24 10 4c 8b 64 24 18 48 8=
b 5c 24
Sep 18 15:39:28 redsun41 kernel: RSP: 0000:ffff88b77df08148 EFLAGS: 0001000=
2
Sep 18 15:39:28 redsun41 kernel: RAX: 0000000000000001 RBX: ffffffffb298831=
0 RCX: ffffffffaba2e200
Sep 18 15:39:28 redsun41 kernel: RDX: ffffffffc21822a0 RSI: ffffffffaba2e18=
0 RDI: ffffffffad913390
Sep 18 15:39:28 redsun41 kernel: RBP: ffffffffc21822a0 R08: 000000000000000=
1 R09: ffff8881c25a3818
Sep 18 15:39:28 redsun41 kernel: R10: 0000000000000004 R11: ffff88b77df0842=
0 R12: ffff8881c25a11f8
Sep 18 15:39:28 redsun41 kernel: R13: 0000000000000003 R14: 000000000000024=
6 R15: 00000000ffffffff
Sep 18 15:39:28 redsun41 kernel: FS:  0000000000000000(0000) GS:ffff88b7cf6=
9c000(0000) knlGS:0000000000000000
Sep 18 15:39:28 redsun41 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008=
0050033
Sep 18 15:39:28 redsun41 kernel: CR2: 0000000001791b40 CR3: 000000015e8e200=
5 CR4: 00000000001726f0
Sep 18 15:39:28 redsun41 kernel: Call Trace:
Sep 18 15:39:28 redsun41 kernel:  <IRQ>
Sep 18 15:39:28 redsun41 kernel:  ? ip_local_deliver+0x184/0x4a0
Sep 18 15:39:28 redsun41 kernel:  match_held_lock+0xdb/0x130
Sep 18 15:39:28 redsun41 kernel:  lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  nft_rhash_lookup+0x541/0x7e0 [nf_tables]
Sep 18 15:39:28 redsun41 kernel:  ? asm_common_interrupt+0x26/0x40
Sep 18 15:39:28 redsun41 kernel:  ? lock_release.part.0+0x39/0x50
Sep 18 15:39:28 redsun41 kernel:  ? lock_vma_under_rcu+0x15e/0x3e0
Sep 18 15:39:28 redsun41 kernel:  ? do_user_addr_fault+0x3a6/0xf30
Sep 18 15:39:28 redsun41 kernel:  ? exc_page_fault+0x98/0x140
Sep 18 15:39:28 redsun41 kernel:  ? asm_exc_page_fault+0x26/0x30
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_nft_rhash_lookup+0x10/0x10 [nf_ta=
bles]
Sep 18 15:39:28 redsun41 kernel:  nft_set_do_lookup+0x1ac/0x2a0 [nf_tables]
Sep 18 15:39:28 redsun41 kernel:  ? rcu_read_lock_sched_held+0x40/0x70
Sep 18 15:39:28 redsun41 kernel:  nft_lookup_eval+0xcc/0x590 [nf_tables]
Sep 18 15:39:28 redsun41 kernel:  ? lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  nft_do_chain+0x2a9/0x1680 [nf_tables]
Sep 18 15:39:28 redsun41 kernel:  ? update_load_avg+0x120/0x2c70
Sep 18 15:39:28 redsun41 kernel:  ? __lock_acquire+0x691/0xd00
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_nft_do_chain+0x10/0x10 [nf_tables=
]
Sep 18 15:39:28 redsun41 kernel:  ? __local_bh_enable_ip+0xb4/0x150
Sep 18 15:39:28 redsun41 kernel:  ? ipt_do_table+0xa10/0x11e0 [ip_tables]
Sep 18 15:39:28 redsun41 kernel:  ? ipt_do_table+0xa15/0x11e0 [ip_tables]
Sep 18 15:39:28 redsun41 kernel:  nft_do_chain_inet+0xdc/0x4a0 [nf_tables]
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_nft_do_chain_inet+0x10/0x10 [nf_t=
ables]
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ipt_do_table+0x10/0x10 [ip_tables=
]
Sep 18 15:39:28 redsun41 kernel:  nf_hook_slow+0xbe/0x210
Sep 18 15:39:28 redsun41 kernel:  ? lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  ip_local_deliver+0x2d0/0x4a0
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_local_deliver+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? tcp_v4_early_demux.isra.0+0x5c4/0xb20
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_local_deliver_finish+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? ip_rcv_finish_core+0x75b/0x1470
Sep 18 15:39:28 redsun41 kernel:  ? lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  ip_list_rcv_finish+0x815/0xbd0
Sep 18 15:39:28 redsun41 kernel:  ? ip_sublist_rcv+0x106/0x2f0
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_list_rcv_finish+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __lock_release.isra.0+0x69/0x1a0
Sep 18 15:39:28 redsun41 kernel:  ip_sublist_rcv+0x8b/0x2f0
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_sublist_rcv+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __kasan_mempool_unpoison_object+0x128/0=
x1c0
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_rcv_finish+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? ip_rcv_core+0x619/0xd00
Sep 18 15:39:28 redsun41 kernel:  ? __kasan_slab_alloc+0x6a/0x90
Sep 18 15:39:28 redsun41 kernel:  ip_list_rcv+0x2dd/0x440
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ip_list_rcv+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  ? __lock_acquire+0x691/0xd00
Sep 18 15:39:28 redsun41 kernel:  __netif_receive_skb_list_core+0x6bf/0xa10
Sep 18 15:39:28 redsun41 kernel:  ? __pfx___netif_receive_skb_list_core+0x1=
0/0x10
Sep 18 15:39:28 redsun41 kernel:  ? lock_acquire.part.0+0xc8/0x240
Sep 18 15:39:28 redsun41 kernel:  ? netif_receive_skb_list_internal+0x382/0=
xc90
Sep 18 15:39:28 redsun41 kernel:  ? lock_acquire+0x11a/0x140
Sep 18 15:39:28 redsun41 kernel:  netif_receive_skb_list_internal+0x603/0xc=
90
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_netif_receive_skb_list_internal+0=
x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? igb_clean_tx_irq+0x10f1/0x17f0 [igb]
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_igb_clean_rx_irq+0x10/0x10 [igb]
Sep 18 15:39:28 redsun41 kernel:  napi_complete_done+0x1a4/0x900
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_napi_complete_done+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_igb_clean_tx_irq+0x10/0x10 [igb]
Sep 18 15:39:28 redsun41 kernel:  ? __lock_acquire+0x691/0xd00
Sep 18 15:39:28 redsun41 kernel:  igb_poll+0x18f/0x1f0 [igb]
Sep 18 15:39:28 redsun41 kernel:  __napi_poll+0x351/0x520
Sep 18 15:39:28 redsun41 kernel:  net_rx_action+0x446/0xc30
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_net_rx_action+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? do_raw_spin_unlock+0x59/0x230
Sep 18 15:39:28 redsun41 kernel:  ? lock_release.part.0+0x1c/0x50
Sep 18 15:39:28 redsun41 kernel:  ? sched_clock_cpu+0x69/0x630
Sep 18 15:39:28 redsun41 kernel:  ? __lock_acquire+0x691/0xd00
Sep 18 15:39:28 redsun41 kernel:  ? mark_held_locks+0x40/0x70
Sep 18 15:39:28 redsun41 kernel:  handle_softirqs+0x1db/0x870
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_handle_softirqs+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? irqtime_account_irq+0x3e/0x2d0
Sep 18 15:39:28 redsun41 kernel:  __irq_exit_rcu+0x164/0x290
Sep 18 15:39:28 redsun41 kernel:  irq_exit_rcu+0xe/0x20
Sep 18 15:39:28 redsun41 kernel:  common_interrupt+0x85/0xa0
Sep 18 15:39:28 redsun41 kernel:  </IRQ>
Sep 18 15:39:28 redsun41 kernel:  <TASK>
Sep 18 15:39:28 redsun41 kernel:  asm_common_interrupt+0x26/0x40
Sep 18 15:39:28 redsun41 kernel: RIP: 0010:qlist_free_all+0x2e/0x130
Sep 18 15:39:28 redsun41 kernel: Code: 85 c0 0f 84 16 01 00 00 41 57 41 56 =
41 be 00 00 00 80 41 55 49 89 fd 41 54 49 89 f4 55 53 eb 3b 48 63 93 cc 00 =
00 00 48 8b 28 <48> 89 df 48 29 d0 48 89 c6 49 89 c7 e8 d1 ef ff ff 66 90 4=
c 89 fe
Sep 18 15:39:28 redsun41 kernel: RSP: 0000:ffff88810284f848 EFLAGS: 0000024=
6
Sep 18 15:39:28 redsun41 kernel: RAX: ffff8882958a3200 RBX: ffff8881003aec8=
0 RCX: 0000000000000000
Sep 18 15:39:28 redsun41 kernel: RDX: 0000000000000000 RSI: 000000000000000=
0 RDI: ffff88810284f7e0
Sep 18 15:39:28 redsun41 kernel: RBP: ffff8882958a3f00 R08: ffff8882956f350=
0 R09: ffffffffa8df51ce
Sep 18 15:39:28 redsun41 kernel: R10: 0000000000000000 R11: 000000000000000=
1 R12: 0000000000000000
Sep 18 15:39:28 redsun41 kernel: R13: ffff88810284f880 R14: 000000008000000=
0 R15: ffff8882956f3500
Sep 18 15:39:28 redsun41 kernel:  ? qlist_free_all+0x4e/0x130
Sep 18 15:39:28 redsun41 kernel:  ? qlist_free_all+0x53/0x130
Sep 18 15:39:28 redsun41 kernel:  kasan_quarantine_reduce+0x19a/0x250
Sep 18 15:39:28 redsun41 kernel:  __kasan_slab_alloc+0x6a/0x90
Sep 18 15:39:28 redsun41 kernel:  __kmalloc_cache_noprof+0x219/0x660
Sep 18 15:39:28 redsun41 kernel:  ? drm_gem_duplicate_shadow_plane_state+0x=
6f/0xf0 [drm_kms_helper]
Sep 18 15:39:28 redsun41 kernel:  drm_gem_duplicate_shadow_plane_state+0x6f=
/0xf0 [drm_kms_helper]
Sep 18 15:39:28 redsun41 kernel:  drm_atomic_get_plane_state+0x227/0x960 [d=
rm]
Sep 18 15:39:28 redsun41 kernel:  ? modeset_lock+0x164/0x620 [drm]
Sep 18 15:39:28 redsun41 kernel:  drm_atomic_helper_dirtyfb+0x45b/0x770 [dr=
m_kms_helper]
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_drm_atomic_helper_dirtyfb+0x10/0x=
10 [drm_kms_helper]
Sep 18 15:39:28 redsun41 kernel:  ? find_held_lock+0x2b/0x80
Sep 18 15:39:28 redsun41 kernel:  ? do_raw_spin_lock+0x131/0x280
Sep 18 15:39:28 redsun41 kernel:  ? find_held_lock+0x2b/0x80
Sep 18 15:39:28 redsun41 kernel:  ? mark_held_locks+0x40/0x70
Sep 18 15:39:28 redsun41 kernel:  drm_fbdev_shmem_helper_fb_dirty+0x1a0/0x4=
40 [drm_shmem_helper]
Sep 18 15:39:28 redsun41 kernel:  ? _raw_spin_unlock_irqrestore+0x45/0x60
Sep 18 15:39:28 redsun41 kernel:  drm_fb_helper_fb_dirty+0x3fa/0xa60 [drm_k=
ms_helper]
Sep 18 15:39:28 redsun41 kernel:  ? process_one_work+0x8c3/0x1760
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_drm_fb_helper_fb_dirty+0x10/0x10 =
[drm_kms_helper]
Sep 18 15:39:28 redsun41 kernel:  ? lock_acquire+0x11a/0x140
Sep 18 15:39:28 redsun41 kernel:  process_one_work+0x947/0x1760
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_process_one_work+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? lock_acquire.part.0+0xc8/0x240
Sep 18 15:39:28 redsun41 kernel:  ? lock_is_held_type+0xb0/0x180
Sep 18 15:39:28 redsun41 kernel:  worker_thread+0x601/0xff0
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_worker_thread+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __kthread_parkme+0xbd/0x210
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_worker_thread+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_worker_thread+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  kthread+0x361/0x460
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_kthread+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ret_from_fork+0x560/0x860
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_ret_from_fork+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ? __switch_to+0x473/0xd50
Sep 18 15:39:28 redsun41 kernel:  ? __switch_to_asm+0x39/0x70
Sep 18 15:39:28 redsun41 kernel:  ? __switch_to_asm+0x33/0x70
Sep 18 15:39:28 redsun41 kernel:  ? __pfx_kthread+0x10/0x10
Sep 18 15:39:28 redsun41 kernel:  ret_from_fork_asm+0x1a/0x30
Sep 18 15:39:28 redsun41 kernel:  </TASK>
Sep 18 15:39:28 redsun41 kernel: irq event stamp: 332632
Sep 18 15:39:28 redsun41 kernel: hardirqs last  enabled at (332632): [<ffff=
ffffa81e3134>] __local_bh_enable_ip+0xb4/0x150
Sep 18 15:39:28 redsun41 kernel: hardirqs last disabled at (332631): [<ffff=
ffffa81e316a>] __local_bh_enable_ip+0xea/0x150
Sep 18 15:39:28 redsun41 kernel: softirqs last  enabled at (332492): [<ffff=
ffffa81e2802>] handle_softirqs+0x632/0x870
Sep 18 15:39:28 redsun41 kernel: softirqs last disabled at (332613): [<ffff=
ffffa81e2bb4>] __irq_exit_rcu+0x164/0x290
Sep 18 15:39:28 redsun41 kernel: ---[ end trace 0000000000000000 ]---


--z54sx54hf73sufwb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rht_lockdep_repro.c"

// SPDX-License-Identifier: GPL-2.0

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/mutex.h>
#include <linux/ww_mutex.h>
#include <linux/spinlock.h>
#include <linux/lockdep.h>
#include <linux/rhashtable.h>
#include <linux/slab.h>

/*
 * ww_mutex machinery used to give a held lock a non-zero ->references.
 * All ww_mutexes of one ww_class share a single lockdep class, and
 * ww_mutex_lock() passes nest_lock = &ctx->dep_map, so acquiring the second
 * one sets ->references on the first one's held_lock entry.
 */
static DEFINE_WW_CLASS(repro_ww_class);
static struct ww_mutex ww_a;
static struct ww_mutex ww_b;

struct repro_obj {
	int			value;
	struct rhash_head	node;
};

static struct rhashtable ht;
static const struct rhashtable_params repro_params = {
	.key_len	= sizeof(int),
	.key_offset	= offsetof(struct repro_obj, value),
	.head_offset	= offsetof(struct repro_obj, node),
};

/*
 * Run fn() while holding two same-class ww_mutexes under one acquire context,
 * so that the first held_lock entry has ->references != 0.
 */
static int with_referenced_held_lock(void (*fn)(void))
{
	struct ww_acquire_ctx ctx;
	int ret;

	ww_mutex_init(&ww_a, &repro_ww_class);
	ww_mutex_init(&ww_b, &repro_ww_class);

	ww_acquire_init(&ctx, &repro_ww_class);

	ret = ww_mutex_lock(&ww_a, &ctx);
	if (ret) {
		pr_err("ww_mutex_lock(ww_a) failed: %d\n", ret);
		goto out_fini;
	}
	/* same class as ww_a plus a nest_lock -> bumps ->references */
	ret = ww_mutex_lock(&ww_b, &ctx);
	if (ret) {
		pr_err("ww_mutex_lock(ww_b) failed: %d\n", ret);
		ww_mutex_unlock(&ww_a);
		goto out_fini;
	}

	fn();

	ww_mutex_unlock(&ww_b);
	ww_mutex_unlock(&ww_a);
out_fini:
	ww_acquire_fini(&ctx);
	return ret;
}

static void lookup_rhashtable(void)
{
	int wanted = 42;

	pr_info("doing rhashtable_lookup_fast()\n");
	pr_info("rhashtable_lookup_fast() = %px\n",
		rhashtable_lookup_fast(&ht, &wanted, repro_params));
}

static int __init repro_rhashtable(void)
{
	struct rhashtable_iter iter;
	int ret;

	ret = rhashtable_init(&ht, &repro_params);
	if (ret) {
		pr_err("rhashtable_init failed: %d\n", ret);
		return ret;
	}

	/*
	 * rhashtable_walk_enter() takes spin_lock(&ht->lock), which is what
	 * registers subclass 0 of this instance's key under the name "key".
	 */
	rhashtable_walk_enter(&ht, &iter);
	rhashtable_walk_exit(&iter);

	ret = with_referenced_held_lock(lookup_rhashtable);

	rhashtable_destroy(&ht);
	return ret;
}

static int __init repro_init(void)
{
	if (!IS_ENABLED(CONFIG_PROVE_LOCKING)) {
		pr_err("CONFIG_PROVE_LOCKING is required\n");
		return -EOPNOTSUPP;
	}
	if (!debug_locks) {
		pr_err("lockdep is already disabled, cannot test\n");
		return -EOPNOTSUPP;
	}

	return repro_rhashtable();
}

static void __exit repro_exit(void)
{
	pr_info("rht_lockdep_repro: unloaded\n");
}

module_init(repro_init);
module_exit(repro_exit);

MODULE_DESCRIPTION("Reproducer for the rhashtable lockdep subclass collision");
MODULE_LICENSE("GPL");

--z54sx54hf73sufwb--
