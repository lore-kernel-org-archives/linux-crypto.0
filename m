Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C6119995B;
	Thu,  6 Mar 2025 08:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741249203; cv=fail; b=Htci14zdRAt4ueSzq6LVyfMVNo4huBUcFP8umSbPt/Y+fAvwTPDfWiUWDux+A0xv8Mn7/+seyW86rT4uaKO/QyVSdHk++ysabxqdsJ0hq1MraL3R0t6XKFJoG08Fsa5e7FrgMJ/ImUePE9vP6E62z6B3XiGIzSb0OJDqhKW5csw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741249203; c=relaxed/simple;
	bh=IePqWaWn2fCq1JeUWGtnidi6t/wZvGL/1XhWnFh35IM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SdByix45iSdBQD4WUutFmBlvWaATX/01PqblNW8RdT8vVWxIn/GlXyUJiczkxHLPux7287OInqtIbpwSRgjTfwxOnsnJbQmoZhGd53OKj3UFS3F4wb+KkwmU2NabryGoZKH4Mo9RYT7Vcu/SRh2oJPeO+AEPLJx3HwLdFKiIjzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l6ihRrkI; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l6ihRrkI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BphSKyFkZM+C5Y+SLOXoVnMRNFQ6fZPWMAJcVdI/9ythq0+ySRTBDI4TqD5aNentvAo/aIQty4IIwJh4er5YMPd3OuL8cnqhf/G/ZxHDCwr3jzbsrK0tpsbC4cAVy1XtrG5ULGuOt2VpT0akNLNCbUo988k+KZQm1sMASzi3/7bJGvRxAlrcdj7Py4JoxROjUhmEVrS2B8HMxq1XKqdve5Fg5dieY+eIueUlAW0QdTmHRN3pSr+uzNly+8QfGJ8LQsqFvb0LFBhoKVNwVUaZ2JedhLVyBl3CqvFHITwoESw0gCvRFu8wAlhlFB5kr06nEslJFgIEQUBktXfessHUEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8T/ed0EM/RlygpD8li9hJuAQgHB+wsJnhVou+QBBjp8=;
 b=BK+qpAPlaEwyV1XMCA33GIR6yKiDiHqmn1zFzVrB6xqKduyYyb5sPR92p9+CLVxDp2PecepZtFSDPwGfNDjsb31U4hNQWn0Ax59zjWYirRXN6qyUPRiEDJ0hkH4aeRcAHdnvQkCnCfoAA5nXb6r4M9Q8gJQyMcTLgOGPVo06t3LD741P6ET5FcZ6xDcY4f5nN6KvyBBoew4eQ8EcKxhNpxzirEydJqM/4YNeHBH6Pzu9qpqUc/TkKC2k22o0d/Te7ltQR1naZMFVKRrFkPX8cnfSfCixHzqQaL10Z7gFHuoDKqF3VVBgSDDx9lAohfbkTFdeLMr3qK/lvSsSmtHDmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8T/ed0EM/RlygpD8li9hJuAQgHB+wsJnhVou+QBBjp8=;
 b=l6ihRrkIMpigF7CcBW5JpxOEdlB4ZEamAwQvMA8rV3nDPYVdTbAaMNlPeUF1sm1ePXQQta0WhaNlgefBA1j7Cnb8pNNSefJcgFysvBIIhM4a1zUvp/9StQbBOrzRCzbVStMpDA4+02DD6eWsScXMd28IVfLUxHlh4xmhlQevq6cqcbHIa0AGKFUTp2m/pUIDWDmO199mG3c6k1C54W7nLSmXoSWMDjZLbCaZk8OB2VogEa63edE76DwREwM1HLkhtg5wW5fpSPHqqg/QOvWEZ46w7ApcAIIqu2n5xn/oYUi4+dkBFYabNBSc5CrvedAJ7+8mdxc5gHf+4JKkIcw4VA==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by MW4PR12MB6923.namprd12.prod.outlook.com (2603:10b6:303:208::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 08:19:58 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%7]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 08:19:58 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>, "thierry.reding@gmail.com"
	<thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate
 dynamically
Thread-Topic: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate
 dynamically
Thread-Index: AQHbhp0nML9qQG1F3UiTlayC2OyGxbNkKsyggAGm8YCAAAHZUA==
Date: Thu, 6 Mar 2025 08:19:58 +0000
Message-ID:
 <PH7PR12MB817850B81FB7CB9E65ED6F4CC0CA2@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
 <20250224091610.49683-10-akhilrajeev@nvidia.com>
 <PH7PR12MB8178B92B6ED11B891AAFCE0BC0CB2@PH7PR12MB8178.namprd12.prod.outlook.com>
 <Z8lY5Qd4g5eMDMnu@gondor.apana.org.au>
In-Reply-To: <Z8lY5Qd4g5eMDMnu@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|MW4PR12MB6923:EE_
x-ms-office365-filtering-correlation-id: 707c6eee-ed80-4e93-a865-08dd5c87aef6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?HfzzILMuzV34e2bgOMCZSj6AipGClhMNM+VtTUSIERwcqDYlYR2swp2wX48a?=
 =?us-ascii?Q?JIRntLfAP/6hHVyHFDRDM0OKC+s9dTYgFxoaw5lpLFOW+wyDBOqiXk8I7ln0?=
 =?us-ascii?Q?4VE+9gKh959RY0RoZfg0wMBQE8Wf5s4p3pPc6RgKbNabrTFaq5l77v/XfFKu?=
 =?us-ascii?Q?G9TF5LwkCrSYXRNN58U/nGsPE+mCeycZVxp/1xfXvhIyO/1GVLmIxVlbNlHj?=
 =?us-ascii?Q?1Ym9bg+3fc3Oe/Iv82WbOiU7e1XY0KIuwIuHm5Yx1kftwtKAfOmrY/XGNd6q?=
 =?us-ascii?Q?smX3SboaRI4uiZ8OAoCFRJhor38L2Aiw2DXi7XCmpKwgkmDHvU9KGYjIsIIx?=
 =?us-ascii?Q?/yF9KV9Edvj00rOY3zmSgxGP8obNn/kKv5Cg1edYKD6yCHzzxmj1vnftR7hK?=
 =?us-ascii?Q?LspiMe0dMy76hAl96pCewrqHqjYyYA+pBYe+bReMZYnmU/gHZ9u1SJKsKqYp?=
 =?us-ascii?Q?MmFp2tQnLPNHCo56vtV8IVwnKon6+cR1k/CmoZU2GkQRca0wgqHeRYz3wJTo?=
 =?us-ascii?Q?unTngiv+8EUI+hbMJ87FvMlHB1g8xIfDk9WjvVWpTRTgY9+M7wXid48UZj5r?=
 =?us-ascii?Q?+efR81KsMfvMsxZ608Hkklcy7EPJvxqkpz+R60GCNALlBgQ1Gb6no1OY1SwQ?=
 =?us-ascii?Q?fhHw5IDwskuY+LBB1a55eBKRlAlfWwiMEoHhlca7spfxhS+BofTByNYgQIsY?=
 =?us-ascii?Q?r8xY9my5a/kt9q776nobahSGz/tWP4+bLCwuQBtz4sd47pI4QEt8STHwGIZI?=
 =?us-ascii?Q?rftMKjqtWGu5pBiZ2xMV2g/JGuQm4JsAQmHoA8Y9MsHq1RQxgy3fPGMMH5s6?=
 =?us-ascii?Q?srZIBIry5EdaROnIeP5p/clpAE02+qmg8AwvwEcxxNPSXqhLFcQi/ZGBFSv8?=
 =?us-ascii?Q?mwBBpzefbZudkcaC6W0RuNiuzz8NwX4r+7ttcqh/z47w1E0xCZgnZZk0oDH3?=
 =?us-ascii?Q?RH/5RhyRCLh0qVBBQYh6C1pNqGvyMB8t1lY+EMEQXxJynBLqTFbZZGiG9/DU?=
 =?us-ascii?Q?KmI5wQvw3pkN++0qmugvFF5yLPoezOTn5eGv5w5FWHMb/GgEUU5f9elmrIFD?=
 =?us-ascii?Q?Rs+umKLWZkFGve3Y1pTrem8l9RcxM9tm5iou9Oxmx+MHtayOkERR0Weezovn?=
 =?us-ascii?Q?/A7ivhJsH43l9z0zS9yNz5wrZx7OzxipKRXA2B/L7vcDTJXM2cTATcZhDVqa?=
 =?us-ascii?Q?TrYVMWIKf0HMH3+ufSFJw0Zyk4JxjizzKqZtK1bkOEGmpvXIfAUsmR9AXsyo?=
 =?us-ascii?Q?ih4G1lrWlvTwc0ywKEXr6VqImxJw/2WfAMFIprooXkTLiWsHFZrBHAVam6OQ?=
 =?us-ascii?Q?w8lrvlKuDR+tWIYvI2ay2HNcR5ncdO4uqPijN3OwwwC9/QN1Szn3+ZP7JgOR?=
 =?us-ascii?Q?5qF9+uKo4KSQOrnjusP+0+UYMRhEjA57tNI3MidhJRV0GlQ06njNVNDiAQ3/?=
 =?us-ascii?Q?V1WpiKNLOOhJZwMfd0X9SLHfKwuLVQDv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?3l6r/qVZ3uo2NIrnT/X1+IucCiDtc/F4g1P+gkMW62WV+BW9+jyKNu7O+71e?=
 =?us-ascii?Q?/IWgzklu3NfzTp9OjyAduiKQ+seREZBcSROK1kVchZf58+IxdScdhUNIwdqz?=
 =?us-ascii?Q?MvodVBpQkl+lursMDJ8XLOFGV+RXrpgZKG8LScan4/wVberDlnCzRF3Tw1Ep?=
 =?us-ascii?Q?Ytf8Zx8jF1aAvFcah110t2+AiRfJNUuWP3/jTGkJo44HzMzizqFXGdv+I3jB?=
 =?us-ascii?Q?r7yIaOGBcbpOoZxvfPAgv4stGy/0SYaO/D5vDhxV8/nUkOQMmYWf34lOMpsF?=
 =?us-ascii?Q?6dP/pyABISF0BUnqXwriL9rgEXxA12I08JDPZcmmxSGkNFrdZjqRzosLlDsC?=
 =?us-ascii?Q?XxbxYONNcp7KGvVq9kv6zh58DBmPjrh9Rscv5lLZVj+fWODYIdtzidDOPf/O?=
 =?us-ascii?Q?DwExNr8MmQ3+0F6Z3hQd2ArinMtFwL01hKzgTZBkAVjzhmUgAKiEF5Ke3j0j?=
 =?us-ascii?Q?8pmtzGtsfhmmEpBHt/xdKnFQtP0pyX6Jcz8hln/xQ0cM53UWEzJwU+p733sR?=
 =?us-ascii?Q?6vWhYQl/uCrBTb1ko4F+WCkgiPKBQm4ETmXxmQFmAI3nO7baaocNLOUEUady?=
 =?us-ascii?Q?TpYacHWL0v5i4qnDgnE8HnyvlOEJ9kib0XHcbXS8B7KPuCOvAwVAjzyhXXT3?=
 =?us-ascii?Q?RC7CIoz+4GQaM/pM4+YvjObhMcvIitTmF9VyhaLzYb1YtuXHsMADmIpg1FOk?=
 =?us-ascii?Q?FPc7Lr3SfC/kj94Ej3L3bXS4kCTN9recB4IVwRYOPwuU5WuW9UEDxXzztHym?=
 =?us-ascii?Q?wGgTfyB0cMmC+cngG/KtBZYxvAa4FX4wVr8zStcCIO5mY72KtDPZG3ykTxPo?=
 =?us-ascii?Q?NmJhisurS2SrnsJJ03VG5nvGWoG/o5q6AYXFv3zU6lGCV+l6lF0p2lAoBYiq?=
 =?us-ascii?Q?nMh0479ATYQefBiabsb4TAVx+86JMwazl/ol4BpXtR2gseMSlH9aN3vhaWfH?=
 =?us-ascii?Q?c+jcEYHF7JZCTcAN1erJHyAgG4EvAToyWe3zhEAYCk1ogIdZjB3dysY4XT/d?=
 =?us-ascii?Q?F7oSBtLgK+Igc7VAoFPqvTN9c3YDw3mjwl8pa3pK6B8n/rd9fIWv4gkzN8m7?=
 =?us-ascii?Q?Mhlqt8qBl3wxtsdhSkkmQmyQAIwTH/6/vtHHLzukN5ZRq87pPJbJzvkGYzmB?=
 =?us-ascii?Q?FLoJoMdM3DkBYFlqYikefCrn2rXEZ9mU2N+MtYV4Ee5NgXxPD+CCu+pgrvmK?=
 =?us-ascii?Q?0iHgod6jH3Uig1eLG4E1lvYw5fDwuksFAEbrN15BpDB5vc/q69YpOlkkBX+/?=
 =?us-ascii?Q?uNPbnKT/+Wya7s5uIsC4gx4MAEAkC0jWX2ny4UG5ZnrGlBuIvZQ+059diJS4?=
 =?us-ascii?Q?LIQ53Yn/Gybjba2KY5K615D0+XrdXoqrbm4ddo/0OIDfsXCvIOHRTO2R/Xfn?=
 =?us-ascii?Q?HVGAH0x73AN5jhomAAT5KH71nJX8TBd2dtu8TWt3Gm+Avqzia2DzL/rU4+G9?=
 =?us-ascii?Q?FylGWltAY6GxhvhhqrdM86ftosfQrjYC6pcq4RsH+o8Yzcujpe8Y+64iIQ+i?=
 =?us-ascii?Q?1u3bxRrQI766awNSof8vaXxhnSX4148q+OucWi0H2gMe+ivh7hlCzMlrp8/F?=
 =?us-ascii?Q?2VIfNAqED2BY0PCAIX6IBLeMWF19O15iujUh+x7n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB8178.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 707c6eee-ed80-4e93-a865-08dd5c87aef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2025 08:19:58.0565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WURlx1tpVklzwXvDxwqgDNo7c4RQRigBhP9selaO96W4Bc+WffjdWBYzMsOX115j1FknOEF2UQnWM85qM7GgoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6923

> >
> > Do we have any other concerns with the patches in this series.
> > If all those look good, I can push a new version with this change inclu=
ded.
>=20
> I have no other concerns.  I can fold this change in if you want.

That would surely help. Thanks.

Regards,
Akhil
