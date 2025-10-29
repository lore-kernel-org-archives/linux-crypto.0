Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B58432D45C;
	Wed, 29 Oct 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761759428; cv=fail; b=VnOMEhMRZ0bkZyjk1c/tpLeCkQdP71hKx45SODHKCTaJiaf2ubYtzijnzX0SVIQAYCMIpTRZPsFdiA7Jkw8if7UiQesLk3sfNoiAojr5tFvKjpeFWBryDA2bGxSDvrz0S3jDx6/BcKQY1iCqMuSbu4qrljorx+g5KcQvx0NjNBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761759428; c=relaxed/simple;
	bh=2FltPLHI5VQw6LN+r02iRDIFW/p4ifoRhYq+hBzeGAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ct/opJUIWPA+VzRi9LfZL3Oou5EJmvHTGHr1FUFl92viPiTuD56X0/kGLQhihRJHl+tRTLi3C+mWs50GKr04USk7GRwEL0I6GHuqy4Bhi8HkLw5+0GfCmCJ7ZoD8gCMrtl/D4u2GlN7d6PIxEQrunyJdo/sF5Xtsd7+O5W39mCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=rcW4Eab5; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="rcW4Eab5"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59TCfB1h3600477;
	Wed, 29 Oct 2025 10:36:55 -0700
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023095.outbound.protection.outlook.com [40.107.201.95])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a3has9kus-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNqVKVgNNvJqMsOlFuBP9i1fzJqAPoV6pu857gRskHZAWb9p2npRvtfl7pjQmOOvC+fhnoLFrOHP8QnkGCE0lsP6G8mYFUC8PZ2tsRCStsIAUbGG65jw2xI7fEu3KfCD21v804eLW/YP0HDeuZRrmGP+fqXCZE6ZfbKkdIqEqjRlSixMPQGcLBSlG1x1tOccMtKlA8UElm+fRw8NusadyEUJcofmDN/5cWu7y2s4dBJ7/gpXD3fyxiiK0t0qKadVMaTQPRxag/9mMYvx2zu1niGtLx8krVzTibjQUJJBiim3LZEnUqmSEGwwezn6EEv6IL+7+7x+a70rlWhDVJTuAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qo6fxR04pEcKr/mvqhqLG0J2Cxdjh85EWWhCira0g1U=;
 b=gxB1ENWgItDPRtJ0qbcm8Z24a36AxyZPQQLubRVA2DVSXOx8AE606rQcXB0dRu6d4AuD429xgSSkA03rbNMGr7PKwCGErDPCCqa8B1OAoUmOmLqlO0mWe5T9ZCBK5qf0Y1o6G8HJyiNM+4VyU2K9rwbfcVa7Z8kKvsK3ATHnbP8/opYTLbXlt/tNXmK9mylMYguUpTeFxhKzjWdNCh/SRfC41ewrDMnR/xvxKSkEKZ9DMYrC2JpEC0gG7Fky6DsSJyB/y+NB47lAax4GS4G8Ly4qBegNJvv5yNGUK/PpXmTe65RIwUr7ud1lgV6Sfa716f7hOIWsMS36/3TVPOkZbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qo6fxR04pEcKr/mvqhqLG0J2Cxdjh85EWWhCira0g1U=;
 b=rcW4Eab5FWbUMa7yZh2aDRMGZ3yWblPP3bDp3vwHaInN5Nq9QCM+ZjWvPh5ttHZ0M3QjN90IGCv2NpkWVp9lA65U9i9JwGuX/BfUK1KzDQsO0Sv4aSrllUkvQ5KpokSJ1D9mOkACv4+F01n0h5xp/f1Ep2hDeORCIyORwJMAEJ0=
Received: from IA2PR18MB5885.namprd18.prod.outlook.com (2603:10b6:208:4af::11)
 by DS1PR18MB6148.namprd18.prod.outlook.com (2603:10b6:8:1dd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 17:36:53 +0000
Received: from IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231]) by IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231%5]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 17:36:52 +0000
From: Tanmay Jagdale <tanmay@marvell.com>
To: Sabrina Dubroca <sd@queasysnail.net>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "horms@kernel.org"
	<horms@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Bharat Bhushan
	<bbhushan2@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH net-next v5 15/15] octeontx2-pf: ipsec: Add
 XFRM state and policy hooks for inbound flows
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v5 15/15] octeontx2-pf: ipsec:
 Add XFRM state and policy hooks for inbound flows
Thread-Index: AQHcRorBy1SiNl6La0aUsiJRcZOqObTXcdYAgAH0Slo=
Date: Wed, 29 Oct 2025 17:36:52 +0000
Message-ID:
 <IA2PR18MB58851AF05D38A69B15571967D6FAA@IA2PR18MB5885.namprd18.prod.outlook.com>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-16-tanmay@marvell.com> <aQCrWAVZh2VlOl54@krikkit>
In-Reply-To: <aQCrWAVZh2VlOl54@krikkit>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA2PR18MB5885:EE_|DS1PR18MB6148:EE_
x-ms-office365-filtering-correlation-id: 1727bc9b-9a5d-4c3f-7c51-08de1711bf6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?kXKEQj89i94RIwQCUmmKhWL4u/SBlALbQVBtM+u6mRiJlMWEUsBe5Bqhhc?=
 =?iso-8859-1?Q?5tvlMyIqLeOl8NPdV0uwF98armosI7OgvSHscc0sqqTvyv+RlyC0g1xZ8c?=
 =?iso-8859-1?Q?KxHXrs5eZGbHiuWopjLr82vjQc10nfvgmxrEgKbpjjUUU8qdi95RyL471K?=
 =?iso-8859-1?Q?WvjzUIzIWBv4tEcOycD0sV2iVE8mB0j3gP2IcKTrn0RbRkA6rK0tIxMdpG?=
 =?iso-8859-1?Q?ZE1sRo5cz5cnElq3NCwTiWQhBVCFpMAJD5uZJcgbWnlzRRF9KPeY1hiSFw?=
 =?iso-8859-1?Q?6y7AgQ/jE460rfuuwxVzlUejUwHjgpmFz/lx0JS13sygu93nEHwRDfuesE?=
 =?iso-8859-1?Q?A/sL5B33hAvcRg1FxmZ1n4bqu/FfDn5lPKlpWWMFg4HCUxWc6P+DqzCBNs?=
 =?iso-8859-1?Q?Rr3NKC7gWqqcslRdfReoWXyDN4qAw0cF33cFmoakRGPlN4j94vacfyhWHb?=
 =?iso-8859-1?Q?LWyLpPzl9h/exV6sKNwWR1xNXLDWAXr6o/02TzqeCN4OUD6Vs8xEsxNrr8?=
 =?iso-8859-1?Q?5A+Qd+pVw1rHtq2tw+qAO5yjEqAhwtb593/yfFHDOvmQvFJ0oc5GP0SACi?=
 =?iso-8859-1?Q?3fn3BgkTVlCtrvEfb6SndxYZbkOG7Eep5LtNtIgB2lGrO1bNg5jLAT9sHi?=
 =?iso-8859-1?Q?UOr1Jn6yEUINQb4PlYLcKOoHxJ3t5w7fRsL2374rgHplMzivITVdc9Yx09?=
 =?iso-8859-1?Q?I2aut11tMAkA8r1uKowVB8WT9h9W7L+6VeHloVPNuxfFdUof1SUoFHrc9C?=
 =?iso-8859-1?Q?QDUIfABPJgkzOIlMr4zc0Kdm2qGrFqxGtO6JQ5ivk9MhYBRqdBVrAf5XK/?=
 =?iso-8859-1?Q?Gx48QT5RNmEt8E4cr9BTJiRhJBNzAXGMrCCzm3T9nFVTCEXXbzvGhECxy+?=
 =?iso-8859-1?Q?s7Z/CcILRJrgYW5BqB5icp82KgYwftC8SjgTf3P6hBzd5TPvmkj8tAUAhE?=
 =?iso-8859-1?Q?ZBbLb3yBHRafCwfxxIJtRsSxnewOeG3aX7RnR2wKlLx415XGQCXRbCgb+Q?=
 =?iso-8859-1?Q?NSHoiHfkRUAKdud3Cwy4An9XOq1gfJwavYaZ3wxuHeKYsVn+dK7L0b8IpJ?=
 =?iso-8859-1?Q?UujWH2HS/OMGUHD6jyEOcPLorglwh0j3Sc7LP7tCpldEda8Q+w0qgc9O++?=
 =?iso-8859-1?Q?kJbIH7j0gZpk/CxyOMMUegRhDX29cqihCHOTfOodNXKSntvr2kWLQuw+lL?=
 =?iso-8859-1?Q?Sq7uebCu1D2QDqwYs67H+yFt1CRlzOY/n6WTt6A8TbXEvbQsbR3kH60ncG?=
 =?iso-8859-1?Q?lsv07khq2YIE1Z3e1udVehOml1JHorCCNlOna99XTft44SFpEpEfe7vI0n?=
 =?iso-8859-1?Q?oBoUWFb+5jFGKZdHidoh42jHKoa0giLd8ezWtoRd64QFeUwwW3j3SM+zGX?=
 =?iso-8859-1?Q?CmUVJ9iRxTqFIqrVECbORRGdzcfJi7rxbX2XAG/eWeO6bmIEah+vRWCXG/?=
 =?iso-8859-1?Q?PHBCNIizCGDOsz9oiMEG8n7fkFqIqdwJZbuETvesTEdwV6kaRamlEaGYc1?=
 =?iso-8859-1?Q?uzQLffwGFEDhL3NtAhF8QxTwa1VY562WcpeiURj+k2yNM2bdKGbdIxK4Yl?=
 =?iso-8859-1?Q?EUFlH8dgsqTG3zQUxobwTp38xk2K?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA2PR18MB5885.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?HgkabHK1oVcY35b6JgP+s2P+BaTia3seX6g6f3EdulPjo97ZA3dR2yeV+4?=
 =?iso-8859-1?Q?qGf3RSREdjmsJNLoR13COOWdArUmwgl5hCTdA3HI+Zu/cDL8HPznMuBNSz?=
 =?iso-8859-1?Q?WBsbkgdEukYSNcLMFkrV1SmzzVn8RaJjskRZk2M9fhcRh8scVxgCyjmbbt?=
 =?iso-8859-1?Q?mbDAhBUPhIl2yAp9GNfRFLll6kBWmJVrowKvbnLSpPAByBnmcGBayAvi3+?=
 =?iso-8859-1?Q?oes5O/ToMMWBtGI9UCFMAsNuzNMu/u3zTzN2zv0/GBIJ1CWEiWM2+4ZWCz?=
 =?iso-8859-1?Q?JimjVyhlyB/2vJqR4cQx+Ij6O5MlLXITzxudN4n8w/TFkc+QSLhRVgzN/K?=
 =?iso-8859-1?Q?q6Vr8t2udnw4OEvQQuY8oND4JVQUlwuwNyuQkhQlAaz89cFkzZNeHHcTr2?=
 =?iso-8859-1?Q?NdMqWRQxJ7n3+ohRYUdzWmzpcFiFpbwceopaPkTYeTUkP2dANrg4fwm62W?=
 =?iso-8859-1?Q?g1HlITDO0v6ORnwkzR22zK5oCCqKoKf0H40DQ1kHGSSLCia79nD0P69QRd?=
 =?iso-8859-1?Q?EyB9LmIl3M/0F6iIUu3YErxg8qQVJyxDsIw6SwYA4vRoyWVRXxejV0QJzM?=
 =?iso-8859-1?Q?k9Czl9vnZ1UPPqeyw3DiaswWLPsgfpa+oF1M+hc4OE79/JphIjOmrYXPpQ?=
 =?iso-8859-1?Q?8AvbDNo0vEJO1MJy+MQVmS0IHxNVrbmYa7f+96RImZXe1Y5pJuqBkrL/bT?=
 =?iso-8859-1?Q?ZU7//PdwcemdjmUcGVdzOyN3VFBLdXMXw1KEzDSt68Y2HRf4d3fpGyutg9?=
 =?iso-8859-1?Q?QIZZUI3OkbtztmVBEBpBCtvoeQDW3QuabbjWp4tyw9bRZg0rGBC1YfzBFV?=
 =?iso-8859-1?Q?p+mw0of9drRQIWYFM5+SZg4t3+GkjM9wFK1svrzbhy6Cat0QbH8K0Bkujm?=
 =?iso-8859-1?Q?1As8PDD1emavhTCDPl2ZSl+sdK29P+vyU8/xEOfFCb2RKqxUtjuYeO9nXn?=
 =?iso-8859-1?Q?TIi2ITPsR2Zv+RomT6YD7DSs+1YvEr7xGgF0kIyd/fyoHvMEoJdlLPCLud?=
 =?iso-8859-1?Q?grnH6AUDtb1C6q34tDlR44ifSKk7QRAGhAV879iBW+Lc9eRp5PL9VP9RaW?=
 =?iso-8859-1?Q?/0JdzEqS3/a2nwo/1rl7+dWX84P8Sltjp0W1Nl+8eZF07ySEIAW09zPI78?=
 =?iso-8859-1?Q?5EbRi9M5NVHhzYheow2JDO9Vd/8Q1YOplp+Xqkb7PbbHuybVArU1agYl7L?=
 =?iso-8859-1?Q?Ur1iTMLxVLf4HvuK+rUlxfWOmdUA9SxGTJPh9DdQ249gRq5yLZGnLSd31o?=
 =?iso-8859-1?Q?LoYmDWY8ZJIbMx5mXVAEg+emmLQNs966Ra05lBgWw2M6OwM2f67d7H14zS?=
 =?iso-8859-1?Q?HO9ZrEWbbGQSNfuaG8ftM4NyLFLRS2QL/Va46+rqx52+a9E5QINQi2yRCb?=
 =?iso-8859-1?Q?N5oDSp0qg4jOYhXwxYDrrRD8Y2itFJdu7+ZNSK5oxhvwlvR4G1GmO680CU?=
 =?iso-8859-1?Q?VkROzMUiVtzhv348GhsyfYuP7qGko695V9gZAkFMZ73XshNPGKR7WfJta4?=
 =?iso-8859-1?Q?VtjfOL2lBq/xxpVXrA9107Vg5rucBqy7w4frntuolL3aL74XP9O1yssoQJ?=
 =?iso-8859-1?Q?g2hIB2reSs7mJv0dzqPXzPwoXwBqfLvQJw6qT6vbWZttZsVj/vhjclMSnf?=
 =?iso-8859-1?Q?+TOMXm0JHN90U=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1727bc9b-9a5d-4c3f-7c51-08de1711bf6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 17:36:52.6525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gHpI+iz/WmCMYt1j5rMntCImnJRMRtq9GY0IgEl60DRF9pzxgOnAgPfNuHgV/cHRqCbGXBQuo6ZveCOzfirX8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR18MB6148
X-Proofpoint-GUID: BpLN-7ZIySdqukEDNOzdCReYDCc8-aqo
X-Authority-Analysis: v=2.4 cv=LJ5rgZW9 c=1 sm=1 tr=0 ts=690250b7 cx=c_pps
 a=iE0qjxSwE5SXcvk24aZtBQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=IyFJ6Qb-BQxhEc1X2oAA:9 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: BpLN-7ZIySdqukEDNOzdCReYDCc8-aqo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDE0MCBTYWx0ZWRfX0jyX9pnc66hx
 jsUuv26r22eI7XIBvpf3neGbmo4r5DO9DnRBAOYPyE3Os/JG3vrE2TVqg7YpegGxBqzMlOHBVwK
 csglOWAOcJQbY77AGYWhmHJeRd1fSpoJXmMogJjAkGKAVxEE060aplGbEWxfLrS7lyN4mg7hzAr
 YHjJEvvp46mD/ZctDlRvB+2yvJyyLNZGqqcNItBESMrmyMi9eC2973N6AXn6NzOD/FEJkbFBEsz
 OuNnT5Et1tihLMZwsh5aGmgG6KvUTvOzRvlghtNLs78tvamAcKDASVwZeUzvZrldbOv6QmKoKCN
 580Cy8a0//osq6wYRwhsnjfehr41/CsDiRnV6CvgPdmES1eNXd7ccUAgaRV7PI/U5+EgXTpBNIn
 U1j+PrrAWGJ+rGAGmunRQWC2go0g3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01

Hi Sabrina,=0A=
=0A=
>> +static int cn10k_ipsec_policy_add(struct xfrm_policy *x,=0A=
>> +				 =A0struct netlink_ext_ack *extack)=0A=
>> +{=0A=
>> +	struct cn10k_inb_sw_ctx_info *inb_ctx_info =3D NULL, *inb_ctx;=0A=
>> +	struct net_device *netdev =3D x->xdo.dev;=0A=
>> +	bool disable_rule =3D true;=0A=
>> +	struct otx2_nic *pf;=0A=
>> +	int ret =3D 0;=0A=
>> +=0A=
>> +	if (x->xdo.dir !=3D XFRM_DEV_OFFLOAD_IN) {=0A=
>> +		netdev_err(netdev, "ERR: Can only offload Inbound policies\n");=0A=
>> +		ret =3D -EINVAL;=0A=
>=0A=
> missing goto/return?=0A=
Oops. Will fix this in the next version.=0A=
=0A=
>> +	}=0A=
>> +=0A=
>> +	if (x->xdo.type !=3D XFRM_DEV_OFFLOAD_PACKET) {=0A=
>> +		netdev_err(netdev, "ERR: Only Packet mode supported\n");=0A=
>> +		ret =3D -EINVAL;=0A=
>=0A=
> missing goto/return?=0A=
ACK.=0A=
=0A=
>> +	}=0A=
>> +=0A=
>> +	pf =3D netdev_priv(netdev);=0A=
>> +=0A=
>> +	/* If XFRM state was added before policy, then the inb_ctx_info instan=
ce=0A=
>> +	 * would be allocated there.=0A=
>> +	 */=0A=
>> +	list_for_each_entry(inb_ctx, &pf->ipsec.inb_sw_ctx_list, list) {=0A=
>> +		if (inb_ctx->reqid =3D=3D x->xfrm_vec[0].reqid) {=0A=
>> +			inb_ctx_info =3D inb_ctx;=0A=
>> +			disable_rule =3D false;=0A=
>> +			break;=0A=
>> +		}=0A=
>> +	}=0A=
>> +=0A=
>> +	if (!inb_ctx_info) {=0A=
>> +		/* Allocate a structure to track SA related info in driver */=0A=
>> +		inb_ctx_info =3D devm_kzalloc(pf->dev, sizeof(*inb_ctx_info), GFP_KER=
NEL);=0A=
>=0A=
> I'm not so familiar with devm_*, but according to the kdoc for=0A=
> devm_kmalloc, this will get freed automatically when the driver goes=0A=
> away (but not earlier). This could take a long time. Shouldn't this be=0A=
> manually freed in the error path of this function, and somewhere=0A=
> during the policy_delete/policy_free calls?=0A=
Yes I agree. Will free this memory in the error paths.=0A=
=0A=
> I see that you've got a devm_kfree in cn10k_ipsec_inb_add_state, so=0A=
> something similar here?=0A=
Yes sure.=0A=
=0A=
> [...]=0A=
>> +static void cn10k_ipsec_policy_free(struct xfrm_policy *x)=0A=
>> +{=0A=
>> +	return;=0A=
>> =A0}=0A=
> =0A=
> The stack can handle a NULL .xdo_dev_policy_free, so this empty=0A=
> implementation is not needed. But I'm not sure releasing all=0A=
> policy-related resources at delete time (even via WQ) is safe, so=0A=
> possibly some of the work done in cn10k_ipsec_policy_delete should be=0A=
> moved here (similar comment for the existing cn10k_ipsec_del_state=0A=
> code vs adding .xdo_dev_state_free).=0A=
Okay sure. I'll revisit the policy and state delete/free routines and=0A=
see what can be split between these functions.=0A=
=0A=
> -- =0A=
> Sabrina=0A=
Thanks,=0A=
Tanmay=0A=
