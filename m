Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7FF33B6D0;
	Wed, 29 Oct 2025 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761758926; cv=fail; b=njoODqXzC3gVDbgAjgmVeE1YlgztQIe/4d7C+ZnZZ6pl+cwWutHSOBA0xVKUZupVBeGQVw+BVbAy5wmrv2PVGCxgVp1zKKlECLQz7qT2ds6GPcqMOEF4Lxy5W/fxIPNYGQMrgajALs1Ub28ueu1umynqDAn+UDgaI58i0mvBn78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761758926; c=relaxed/simple;
	bh=wD3DoytCJMk1Zz2r/IoGywNqQxZCt2HSAVV4m6wFYp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cEi+4ai6sDAumQnRACtkfnbJcqtD8SssL2rTF5oaWJ670mNAXKL7VsKgYGN9BfUG6TBZuVQi78D+i3lKrTvWMundjK1+z5y7Jh5QsLVoAlQl9nQVDJ1T/zWJC5jGICNOCfJkeoY1et0nFAeT8FxwxlqmXU4iEIVJvvO+LwPJjf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=MyNi028X; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="MyNi028X"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59TCfBSN3600476;
	Wed, 29 Oct 2025 10:28:38 -0700
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022131.outbound.protection.outlook.com [52.101.53.131])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a3has9jjq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsQKCioTV8k67Dw5JtMMF4vhCMdQLBba69o6fCVqYZT/4TNnwQqAsj7ffutmcqoPfZEqe3/ywReNMKKvK+IDK+GG/sc658W1RrYU0/ek3TKTIWx0YMKd1W459orsY958pD0zyqcnq80YA0OCHNi1e+RK/gyzOD0VINby4e9onTAZA1lU+ziu32QckGPhwx/e5PGSZqTRf3IICyf44ta18oDl1FgrHd80/hh3GU07APVWL89TJgFM8CXLrpLMXSItIqaHfq4ZbshRcPOGXeE6vnT83igDHavsyP1jeCLlg5nV1OuuF3xh8YZLEDMDHSA2apNnYdc5WYZXvyKh/jH4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wD3DoytCJMk1Zz2r/IoGywNqQxZCt2HSAVV4m6wFYp0=;
 b=NBqMNyUuN+uHS7731AZdm4WaVNKrqlbHnJw8qgQ7tlHMJ81tPY/bkQ3A5ck2GyvNoCflK52/ay4xiPs4nvORGvokTup4fBKq2gdEMIlh0b087w+Bfb1GkHFWjxbiukPul14SgHUcg5wAyt+ds0txaEG08jfERH6A28zxsm20HP0mwWXiqHSpUoBp9bYN8buGWTUc2oCRCyXmwTubGr4Qj9npSZW2ewqXXais8xP9BEwBT1/xn2nqVSDP+ExbXYgBQSLNAAzqcSO4ZL8evXbbPdk9qMaxPmw4MXRljavkOTfRVZp0EJIXpr3dPQQT5lu5xWKV/D1NkFMK+zAMn2vF2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wD3DoytCJMk1Zz2r/IoGywNqQxZCt2HSAVV4m6wFYp0=;
 b=MyNi028XhReKJUkT1Tthpi6EYIevVJVUQE172tZ3ADajU45GAq9HhgaU1QotgwX6ONn7RKBYt9qAZWBOQJFDQDhaRmSqdbJVs30FfoHJ4Wj6mh+1BXUkZe49n4Kv3NUO4X/gGgvtILCCeZ5i8ERdk0u8n65KiYeWf/uZiBbAZQw=
Received: from IA2PR18MB5885.namprd18.prod.outlook.com (2603:10b6:208:4af::11)
 by PH7PR18MB5552.namprd18.prod.outlook.com (2603:10b6:510:2f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Wed, 29 Oct
 2025 17:28:32 +0000
Received: from IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231]) by IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231%5]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 17:28:32 +0000
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Sunil
 Kovvuri Goutham <sgoutham@marvell.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5 01/15] crypto: octeontx2: Share engine group
 info with AF driver
Thread-Topic: [PATCH net-next v5 01/15] crypto: octeontx2: Share engine group
 info with AF driver
Thread-Index: AQHcSPlyodYgFNRfcEOxxdt8jDsTkw==
Date: Wed, 29 Oct 2025 17:28:32 +0000
Message-ID:
 <IA2PR18MB5885505093B8624E20DDC799D6FAA@IA2PR18MB5885.namprd18.prod.outlook.com>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-2-tanmay@marvell.com>
 <aQCkKB-0ocnvM8II@horms.kernel.org>
In-Reply-To: <aQCkKB-0ocnvM8II@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA2PR18MB5885:EE_|PH7PR18MB5552:EE_
x-ms-office365-filtering-correlation-id: 70f792b3-dc47-4ced-128f-08de17109511
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?7ZUYiahweYthsiwsIHSoVC4K1TsVes1uFvD6j59teFgWrQMalp+Na/hAHG?=
 =?iso-8859-1?Q?if1HWHQ5W1EnfIXiwxlrrKkqYW6dMxRj9xPzzALOIbxs4wEdERZIXF687q?=
 =?iso-8859-1?Q?c/Z8V7XxewSpoRAazZjhvQO7YhakZrc3zufb/m/STz/O6acy3tpPIMWgso?=
 =?iso-8859-1?Q?keum0dmdW+y8ZwsL8sUowXnl4NPGcEkozR3dZMROyOcIOZPlHZS9qbGvRU?=
 =?iso-8859-1?Q?BteIfnvVUzAU2+d0Cvu/H79OxnXP94Az8I70KYpbqIdHzc65u9fp7H6bwV?=
 =?iso-8859-1?Q?brv+tHOcL94OtXllpR5n5+ojMmH6WnHriDyShfi/UvaUZ3+SFQlmtyPifU?=
 =?iso-8859-1?Q?s+G1bnkhMhmwiWRkWdPkY3E3lI/urHhQtP4i6b86SXpIXp3N/VpVGmT238?=
 =?iso-8859-1?Q?eREKAVkt0T5ncjk+9dXCk7EHWjllbt7Orx1PIywwWK1dZMg6zva+rrbx/v?=
 =?iso-8859-1?Q?YDrganFBstN7dT1Jo1juC0wb81E7Tod8W5ajUsw6LYPzq7dVJNO0ygQN1Y?=
 =?iso-8859-1?Q?jVzqF/ilg741LA7kxNqn97UmodIQxVR8bPj/QuSs8SKby3mClTcc4/JzkW?=
 =?iso-8859-1?Q?n6ow9efglj62PWTxIK6pketudMd2dNCUK8+30fENQp6VLQ/e2XVeIoVKcJ?=
 =?iso-8859-1?Q?xRJ6lZwWgCQuU7xBqeNL2rrGgVDM7bqANnKQhgOk4iR0eQNoHGfDSM5UUb?=
 =?iso-8859-1?Q?Bat70kZYLJfbsEUeSlTZZdEKfnMuBDJbVOZJgz95/J6NicDlFXOv47f8yd?=
 =?iso-8859-1?Q?1kqUcFrlXlW7cr7eGXqZ4d2bC/UWYUEayceZAvljX/QI4Aq15KSELJYFvY?=
 =?iso-8859-1?Q?gump4P04H6IhO6Pp+NUc7xH81H4xmC1u1gHp1cSFyd2n7MLN+T1/0xgqVR?=
 =?iso-8859-1?Q?zJxt3KVdn7bv6dFZrqZCVw0j0SontyYSRcJ1qxYT3rssvqW3FT6jl1vSFT?=
 =?iso-8859-1?Q?UI/uXCbQRqLlQRi1otKcqCObGg2yTYoAgOwcPSIjSKkf5OKrFUdVN/S5w3?=
 =?iso-8859-1?Q?g1K+bqmUZ8KKXHKHD4lymOy+s30Qlq9HNQl5ysRwwiiDEXMHayHb3NIGeE?=
 =?iso-8859-1?Q?vGYI/vdOKa5e1Mm7W0U1GcPc4FNtiNpmqEkePs2p72jBPo4TYJr67z5/Ua?=
 =?iso-8859-1?Q?p6610yqGRlUKw0C4aJ2IRSYXbCOnK9LgEeiybxDNu+oK6N6MIOXdq0Rdwh?=
 =?iso-8859-1?Q?n7Sud3yHZkGLotu7NCbstGb7SFZYTp1Q/cBgztCLZbkiSDTUyC5o1fUnvz?=
 =?iso-8859-1?Q?dgwAV+i5lU++Sh4mfth5DdqkjMeXcDbOpwrPRq0rqJCTysLet8XXQLt+hH?=
 =?iso-8859-1?Q?MhNVvYgCBLQy9Kh4QeC1c7Q73g6Xl9ZMAEobtKrWrQ+ndKlgY27W/wWc1u?=
 =?iso-8859-1?Q?WHDu9GyMDBGZzlI6z+Fbxp5vqfVCP1Iyoq/3P7mkVSCsvfLhJQ+HJl/kLZ?=
 =?iso-8859-1?Q?SFuJKD9q3e2Gy8ETRSs+hwBNDfuViEnwnwKfc5kgIEGeFXVCBQdyKt/s0L?=
 =?iso-8859-1?Q?46wwtFFyyBPaNmYhMIzym0aKVs1NPkn+0aRnG0XXz5QfzOUc+/tXk16i00?=
 =?iso-8859-1?Q?f+Hey3MSiXInXNmYTvDuoKyG7w1p?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA2PR18MB5885.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?5sfmCYW8/0xiVqZ6xwGCzEZdZvFg7KcQmhh8akLGSy+Eut2KV5P+hMFwGe?=
 =?iso-8859-1?Q?dS3DGm3AZoWxKtbNE8abe6mM94yc8FfhCkTbStI3FYDlUtpl/QoYzEjOMy?=
 =?iso-8859-1?Q?YFEJ1fAn3FIuzEqi5SONMH919D0fdWecHh6whPk8SwPkYop7i2lu0M4hkp?=
 =?iso-8859-1?Q?IbPZJJzQrxy5VAuUX+jBrb7SgF3cRxIy1LVj54M9IR4d6M5t8gDBZrX/LD?=
 =?iso-8859-1?Q?5BfLB6Jgf4YpO1NzLai9Z3Rosu+sycx+v+svvVsZnCIwmUCk+nNgfDGQK+?=
 =?iso-8859-1?Q?Wx9S25VMY7cjs6m2gI4ZPgO2D55WJco/SM3+kUdCDayCNlObTmf0WDCEoA?=
 =?iso-8859-1?Q?k5SdWVxMgjcSLYgTvj2Zv2bYVskfUgX0f/0X7Ldk8vypntLmzBz5lt2bOq?=
 =?iso-8859-1?Q?PN3Ut4u5i/1GYQZnqdW/dOF3BOCUD/GQ165W2kpaMdaP6lKBDcQfsD9/Ov?=
 =?iso-8859-1?Q?HM/pXUUWvBlWlBu2V8CZ6F9UscHJycJCypVia2K7hoUQ78M23R0NPkpDk/?=
 =?iso-8859-1?Q?9vYd3ex8ay8wcdmsBN7CAV5F3BYJI1blykzjTXm9zSywz2fxU4Bo+5NcRq?=
 =?iso-8859-1?Q?Jps6S3nGgbWD4bJH29FnNkIvzWTtDIiwasqMx4lGCZ4AP2lYK0/WIoIrWa?=
 =?iso-8859-1?Q?Asr1e0VDGIrCqpeKkcBM18xA0aCZaDRUCFmo8a0TzY8OCYqUoYNICJa/bw?=
 =?iso-8859-1?Q?gKzX8jQUANfehhkJ/Mn0arZapQycnuuMnLkcBbzwon0yGSP3ExLt7yRcpZ?=
 =?iso-8859-1?Q?ohSGckDYBPU3+m4fa1ym6Je0jY53fq9wG0QM3cc+Qbdpc2R7Re0O8L/C98?=
 =?iso-8859-1?Q?LdczaXDaW69GU6Nxr+gBNJW+j3M15IQD57hvFA0I0Kf+HA+InHYU5W7sQa?=
 =?iso-8859-1?Q?r67sczmAxDnceMUqpmSdIbLHHvDHSEt2C0QgOXojkvHJ358bHTHTil0hu2?=
 =?iso-8859-1?Q?NgXuAVXqMk0RU7XljzPIjSt9ZRvSXMdhGtzaZbNwMU6y0UH/luyfNXAsy7?=
 =?iso-8859-1?Q?2CvxuMySqS9uLdhBsUirM1V6OQ0ZnKjavVY2bG9XQXzSNSfzNi9/bQkpcJ?=
 =?iso-8859-1?Q?8DJbd28xQrj8WBHs2rkNprYXyGhGkkZOHtZHx5wAEJ7b+8r9dPKrMNSYKt?=
 =?iso-8859-1?Q?69ZMJPOutoUjPZme2NQgvI2HKbIOuQ7Yx8TY1uMnawFqF/p38qXdoww1bl?=
 =?iso-8859-1?Q?8Gej/gwQJMPGqTmxzzTJn4Pfx+1naUAK813tiiJNt1AlMUMXJqIqOSoxpc?=
 =?iso-8859-1?Q?pqo7emi28XTETnCzGdrNpvPOGPUwM1C1fNfoVdV2Bbm5t6NCZmPdg454lF?=
 =?iso-8859-1?Q?FD8XHnxr5BBY9ZChsncrLKnlE2LBmabYBBFquBIk+04/Dz9lPkoOEJLDTs?=
 =?iso-8859-1?Q?mQ9uuplPK+YyljNRIHooxxUyYrAHktixNDDebcBEbn4oajLZb6GQTh/vO9?=
 =?iso-8859-1?Q?EgncMx//fiGAOsfjGuwsTg9gqaPWO3IH60dOjRTTm2RfYG804ZP/nyxsMt?=
 =?iso-8859-1?Q?e86e/mAuSwKiAg588E2wwxGrRP/dxwMTe12D3e6FZzPDZeTRMBIwS5qF+k?=
 =?iso-8859-1?Q?7sVKyuTXgwpv0w1835Qe7Vxa3vZRIwZdJo9A6T4qxMgvR6gDeTtvsuMlpN?=
 =?iso-8859-1?Q?xohzMFznZ/jv0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA2PR18MB5885.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f792b3-dc47-4ced-128f-08de17109511
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 17:28:32.0387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eoAm3gZKiYcZ1EzAnLw2X0PLWAQUhQItEscspnei24MTIvx0WfO9/u6sj5pZFpDUhM17vQH2Lpjz89OP1T8O2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5552
X-Proofpoint-GUID: u239wKQ78Fs8QyapXCctNsVkyx4bWZfy
X-Authority-Analysis: v=2.4 cv=LJ5rgZW9 c=1 sm=1 tr=0 ts=69024ec6 cx=c_pps
 a=6tOaaN1fXmJE/LdyR88bKQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=NlUuB7NjQpKwvMUzNAIA:9 a=wPNLvfGTeEIA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: u239wKQ78Fs8QyapXCctNsVkyx4bWZfy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDEzOCBTYWx0ZWRfX2Q1y2PXHNKQn
 UWhn0XHBmuIlNKpusXghwY8hrRb9+dnA+IWdNR9wlF+f3/Sd3jFZVFmnL2h1IgZc2F5Im221vgw
 zvJ7LS+fY0rVvjqNbZLiHO9dg2MsLeUU7Ugab5tTL/HRy/DpB0XglpN2l6Tivz6XexY5v071uJ9
 FUDZZy8rhAJh/LZJUxyiNsJvQRxR956FHuQfCz/mtHMVOD6VJNz8tcu52uB7KKtMkHKIMZ94YFF
 rrYrav4yybGdEGcwf70bs64+07AGfIbgcH9utl9l1dyZyd2tS16UrqhLQVe9D1M1yxNAA3wupcU
 CLDqiKIgCumnaEmDBxuZF1xhHRSshCONroZCfXsyCJNXA7N2B7oeamACVHjmmn+tfgVkN/1jh7J
 cW49BUXAjY9XcJ1JO2VMckKrn4up/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01

HI Simon,=0A=
=0A=
>> From: Bharat Bhushan <bbhushan2@marvell.com>=0A=
>> =0A=
>> CPT crypto hardware have multiple engines of different type=0A=
>> and these engines of a give type are attached to one of the=0A=
>> engine group. Software will submit ecnap/decap work to these=0A=
>> engine group. Engine group details are available with CPT=0A=
>> crypto driver. This is shared with AF driver using mailbox=0A=
>> message to enable use cases like inline-ipsec etc.=0A=
>> =0A=
>> Also, no need to try to delete engine groups if engine group=0A=
>> initialization fails. Engine groups will never be created=0A=
>> before engine group initialization.=0A=
>> =0A=
>> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>=0A=
>> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>=0A=
>=0A=
> Hi Bharat and Tanmay,=0A=
>=0A=
> I realise that this patch-set already runs to 15 patches.=0A=
> But the 'Also' part does feel like it belongs in a separate patch.=0A=
Okay sure. I will think of a way to split this patch and keep the=0A=
patch count at 15.=0A=
=0A=
With Regards,=0A=
Tanmay=0A=
=0A=
...=0A=
