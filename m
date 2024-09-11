Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020085.outbound.protection.outlook.com [52.101.56.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273E4185E73
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726060627; cv=fail; b=LUTk5eocttWm8kY/LIy3NW1HrA24FaXG0sx0Go6F9hBpgXb5qZsiHdXLaOim0WZcDTlvRAaANWgI+QZOd22zxM5W21AF/7cjStKfbplTiObq6gzmFM4CXCU0mWBgPcvZFOV1/oUCrUfxsgAwODg+s4E1uXeLGnoBTRnboWBKFAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726060627; c=relaxed/simple;
	bh=SYOcrASEXPmpVF5ie2KrqEcom0fnlkMj/z46sxZsn9Q=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RLOYywYhrjfM1gRnuh+maX63u2BSQSoZQAYDICPejP3TCz8pVRmH7TU69suENVP7vHE6oSzKp8HDIWf98MW4muHx+ztFDxWtbVkawisJubnUDIqQg5w3CeA33LX9b1i0wv2FR1KEu6YJ8+tzJKT+vm8io4pTMd4di6GUgssCqDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=DPMwmojc; arc=fail smtp.client-ip=52.101.56.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="DPMwmojc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s80+KRJK/SYxejRAhYZ4nz77mKQTfwnbkdxnx7afXyY8T78uBX7ig0nGLxrXR7C5jhKhi/Gs5me0uVAp4K33CTkfTznkC4r6CRpS7Ev/KmefJBzQHMNAOLKgojk29QEGnBHVp11yU3ISRk4T2KYrWTxmI6hqc45y4yQ1mWZU46vZwaFUovCrNi2M5Y/CSHgtOUOK4bh6AtIFRcBIHZ+Mo20V2tlCZ7LV7bLvBCqSstHluNhMUdlinb9gUQLsJXicUpgydQ3MJ5khAboM9d78yxU4Mbr0YjLVynTV+HzBrA/kKSMI/qO/99c/EOYyHopdDTrZ/Q7q3OyaL0jRI6dgyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saVHINq8E9k2iDXHyKFwuZZtKDSJGnFKpFGeKiG7GfQ=;
 b=e+J6q9fC0I9WaekiUkgbPhkj3Ly/sa1w8FUOk/Ogu3032W4egKLMCOA3BqILdpEFqn1Y8XR7E5NEDjc4op7c4R9sd5BzJlVi+Vo19LD+U4QHXjzSIyzvZF4+SYwmUn2gk+2zEC+5KmB7J4j7Nq1DVkV0RySSJ3od5JOqRTyT45Op/VpZbAOCg2CA0xLgFlG6jXmLmMJMSHix2mGQrALaHs/Zd44MHDyy6bGC9dzXYeWIH594NYmH/gG3ihs6i7AR3MzcF0/pI9BBLrkVoKTqcuxBZG31HTlF21BB26BGnxo+Xb8xkkKtIHX+/zADB5GNNm6WRgeqMsfqibIAr3TVTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saVHINq8E9k2iDXHyKFwuZZtKDSJGnFKpFGeKiG7GfQ=;
 b=DPMwmojcaC3Lk6T6QPChv23cqKJtMaB/YMqlCUTE3pxABiOettDFCioJl9dnKOIrBl/p7UrSoe3VmIhs7Vg89B7570kbMWIB5yKd745nhY4j5dhyyYTDQBIXyDgBAqAbz2fUkhUToUYSQ7zS9VLdJEZivhoLssmZszKUEgmO/MY=
Received: from SA6PR21MB4183.namprd21.prod.outlook.com (2603:10b6:806:416::19)
 by PH0PR21MB4434.namprd21.prod.outlook.com (2603:10b6:510:331::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.6; Wed, 11 Sep
 2024 13:17:03 +0000
Received: from SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e]) by SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e%7]) with mapi id 15.20.7982.003; Wed, 11 Sep 2024
 13:17:02 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Incorrect SHA Returned from crypto_shash_digest
Thread-Topic: Incorrect SHA Returned from crypto_shash_digest
Thread-Index: AQHbBEwSCNhYTkgAFUirBdo85cqkSg==
Date: Wed, 11 Sep 2024 13:17:02 +0000
Message-ID:
 <SA6PR21MB418301113B9F45171814851DC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-09-11T13:17:02.346Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR21MB4183:EE_|PH0PR21MB4434:EE_
x-ms-office365-filtering-correlation-id: 58af94e8-2478-4557-242c-08dcd2640667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?rupkmcG1mV1W9p67qb/IB0FI/acJB2r5PZdyknavYol3KjAI3jCqG51sjS?=
 =?iso-8859-1?Q?AIu3MtSmK5D9vRzieceOK4suD6vCunTiQukJcUiuTpUAG5y/4z1AArF/GJ?=
 =?iso-8859-1?Q?oyccgjQgOxqPqeJdt5UjTFNt3b4QM+OnW8X+AtKyDmgKFesYEtCkb3D5Ah?=
 =?iso-8859-1?Q?H6AmQwvr7UV+2qu3Hir0RIa7EyXWn+4ekzMIdA0olHxCPmNdUfzzGHpyjK?=
 =?iso-8859-1?Q?LNl5A4Kz/BUXf8YTgzbngp5mCjeOcNDtO69Vz/+K5MIeWXWETUF4Ouvvdc?=
 =?iso-8859-1?Q?bmtOINOhdSvB34T3ej264vx/ewuL3Rr3BjEUDCKowDMoKgVERD95dfbBSB?=
 =?iso-8859-1?Q?K8ff8PdSqD+s0kGtMLSzcHx0N8+tb5Do4SQfAgXcHI6g6w1f8MaIWMMvB1?=
 =?iso-8859-1?Q?XcBfSGN2dj4EuwdYzidfBfKbAmYofHeQovHcD7Q9R/pLrvwS+fV/yPPX2o?=
 =?iso-8859-1?Q?Fs3j6QYTd0BnkvfgJG9CkDbonXLdfRGJVjtHYocU4YeqjUxuUI5iQvBLCV?=
 =?iso-8859-1?Q?nqXldgxFVlDIg+em/dmGy2C1AkNtwdWQf/qYh37Q5NgQc1ax0IQ91Mk2vP?=
 =?iso-8859-1?Q?yR+q8sqGv4vvoeHr1WDYi2CnYljxNlOrD8IEE7Wxf3v9qGAiBoeHSaeadN?=
 =?iso-8859-1?Q?EtiOFdQusmiA+vmNKim3g0LdW4JjJRdQ0bRFOzDbfWBgKcobOy55YGr1+O?=
 =?iso-8859-1?Q?dij23IFaD+D4dm7WDl5fUQrI7vC35HGzCVizktR3ByCeBlCZs9H4+yMtIF?=
 =?iso-8859-1?Q?eKe15ykf+5WwdxItQYzYRb0R8/xEVniS1OUoOyB9lyzd8lvlJk+BhfFQcA?=
 =?iso-8859-1?Q?IKjC9hBRYCYhUs8sAKiUobpFNyz9n4LMn0hA5n/+DNFDa//lmZLTy3b6T0?=
 =?iso-8859-1?Q?pOAjfxwSf0ydP0HQLejZ9dg5i6y+vpvQl3VKRWQUiadtubt8siVhLolow/?=
 =?iso-8859-1?Q?+qUlPYZqSuwUbHtxWMqSakQeX0IWKajbITPsPiIg4Ckn0oAA0SP4Pld5Hr?=
 =?iso-8859-1?Q?VlF2xit6IstqVb26wlsD2zKcF3OiJ0C6ANm/k+B913FPnrQjCfuc/tDOEw?=
 =?iso-8859-1?Q?2ivIwfJk/ZG/3wl9dJ1FSr2Z2NyCKlaEc3/OEKj3nJ5OLv2SGI0TL05Cv3?=
 =?iso-8859-1?Q?uyIoW2Rw8Qxc336wd/z4ba8+QIWJbcP/WjG55CSXXqXi6eBPgr3AEElU7F?=
 =?iso-8859-1?Q?kN878eFZFrR46aqce/EIgpQElkPkKNH8Yq4ZsI6MXs2jtYVb+jl5GrNIWH?=
 =?iso-8859-1?Q?9qr5PEw97hFFgljCspQ5S9egryZxqm+oPbS0cFn4X4/0ZlTet+GdH+hH1i?=
 =?iso-8859-1?Q?uNXglpJWNDaOi7bj748/BRK6Tx6NsWoboDbe93PbXXfCEOe8sE994jx9V3?=
 =?iso-8859-1?Q?htxp0KKUhoS9LbhlPLqilG+2cpfuZ1H8WVUMVTGQe6pi3dpbI3NR2uvPJC?=
 =?iso-8859-1?Q?LX5IX9rZimTUsv0AM6FiZBd80Xbqm4d+YyuAtg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR21MB4183.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Ime9owRcspa35Hp/GKKord47RAAESes5R/wWNfeuAKwS4JGvA7esmdR2cg?=
 =?iso-8859-1?Q?sMPbKKqou8nNRkk3Tl0i/x6OzyNjsD4+fJZ6lJQx0hBFMqWaX5WlkyH8bg?=
 =?iso-8859-1?Q?QYxPE3/WvtFNJMy3hMVel3D61INOt3td3L44laU3LrBKzwuSnghvGl6h95?=
 =?iso-8859-1?Q?WK+NHMOVujm/UuG47BCXeMFf7okw/TIA9cS0VmrWZC4TH3Ppmko4yGQcLU?=
 =?iso-8859-1?Q?cGg41HOl8bhpZ77D8BClDNhXF3TOzra8lXEjTnB7Z8AgHT1I9PBY7dH9s8?=
 =?iso-8859-1?Q?vOSLpV0O6Bmkt1UsAOfkFUXWTQXMo2sWa3pi3hy4+gQ2LJzBhfaeIa2Xsd?=
 =?iso-8859-1?Q?cl0tJ8eaINTDg+0dec49ePlxrzNLZlp5WEDGx2AsfwZUAQtm324X5mRnJ2?=
 =?iso-8859-1?Q?C741dLlGj6Xwl0BDUCFXa6lu9aiJaZ7abiFjdAOSe/irGx4BXP4qBL9jgv?=
 =?iso-8859-1?Q?ZbPp9A70z9qZc7X7nKqI1BF4nin6b8MXuio9WOfuqHLi+JX/iL9F8MvZ7K?=
 =?iso-8859-1?Q?07pS75WM0feFrWoUxRTQTNmtMCSjYuj+djwGkUr5Kv91aNOY0MN7OrwAC/?=
 =?iso-8859-1?Q?l2bAH+6FXyZN+KrWXdhEHsx45iXoVeW0nAA+YEzs/TSgIwOWZ2ZENSA5bl?=
 =?iso-8859-1?Q?/OC72/teWx7om7DhDUdxW3iUb/eOZHbBwKgasNFwXW38FrVQVMBlxyWeDd?=
 =?iso-8859-1?Q?BsX42un03zDGhXsuRnwI5obODKOqgOZaUf2ychXisWd7w0TVrOoDUYb9W/?=
 =?iso-8859-1?Q?09g7RAjZJ/L6uJOB6IumEi3SEUwx2c0DQcchwDTgCANHfBVJ/JrBzGl33h?=
 =?iso-8859-1?Q?ZGpt6cxc0ZDLRh1KLsKa8++KG5crBJu/kWz1VW1LCxDsG0fhRD/4suIhNE?=
 =?iso-8859-1?Q?xYV9wnRnfiC4dnpjAy1iGLjoNPFkog0XCAajFZymEBs8FQ+ghKpNyxRSJU?=
 =?iso-8859-1?Q?QjH6+yvWM52qAL1GYHBLaL/LSRV7Xg0N1+rXblekmzlR8IiVM65LlOIRhT?=
 =?iso-8859-1?Q?nClliAMbvYwLz466k85D2Y9lVJbKLZvYLieL04hS/oxonloPAlgco7xwRE?=
 =?iso-8859-1?Q?hG4PvavQhr+pOURHKMMMhhokaDAaDBKJZYyxniNq+o+EC8oySAip18/z2K?=
 =?iso-8859-1?Q?Yv6G79MnHUPAr7uAuX+9xWZJS0zwFbZnV2CAvOBSvpSNKNKCWzTgXnrKD2?=
 =?iso-8859-1?Q?UGLT7AnKzs3ueFNYLGg61waAy0qvwSUEM7GQuUGIw+AZIGJaruWKtZiMsW?=
 =?iso-8859-1?Q?l62uQZ8Q0NskcxTiqX4/5LeDER60D0GSuxYBn9JkhJsAUPFlJz0ipKzqrH?=
 =?iso-8859-1?Q?NrJ8JHLJ4HIQRApO9PO0GViZ6ouvIPFyDr6vyiCyVZ4gyarUXGdBTVMFR4?=
 =?iso-8859-1?Q?5ciJlFCszzJmOBWvCzvb2bZ7PtRu8uRS0GHAfApga4QqZr7m3+dU5PefDn?=
 =?iso-8859-1?Q?7UNfAODHItW5bYtWDnGTm6y6m65NT3cJ296Tas6TwGonsksZna0Zh8cVR1?=
 =?iso-8859-1?Q?h091seFCaXEDXkjsdasHLG63XYpFpYx5UVKU3la4YFx9YRriVDea+03FMX?=
 =?iso-8859-1?Q?OcnlLad1J1gtV9+/pvokmwgC1s43+JlH19ULFBi4Kc3/blQza6mrMIkGzA?=
 =?iso-8859-1?Q?PXULWP+NFixQ4rDjq/Iy7BXM1VMfRAQhsD?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR21MB4183.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58af94e8-2478-4557-242c-08dcd2640667
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 13:17:02.5716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3iMsBfR4n56BdtmGMZiSmZqsKKtamiHl2V/vPk7ZXZNpGvy/km1C86jZEL82v5bP6rk9UPh3xsgm8Ox1RbSfH8uw8I86lyIBa3wTsTFvxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB4434

Hello,=0A=
=0A=
**Environment:**=0A=
- Kernel v6.6.14=0A=
- x86=0A=
=0A=
I am currently refactoring an ACVP test harness kernel module for an upcomi=
ng FIPS certification. We are certifying the kernel SHA3 implementation, so=
 I have added test handling code for SHA3 to the module. While the Monte Ca=
rlo tests and functional tests are providing correct output for SHA3, the L=
arge Data Tests (LDT) are failing. Below is a snippet of the code I added f=
or LDT with error handling removed for clarity. The sdesc was created elsew=
here in the code.=0A=
=0A=
unsigned char *large_data =3D NULL;=0A=
unsigned long long int cp_size =3D tc->msg_len;=0A=
=0A=
large_data =3D (unsigned char *)vmalloc(tc->exp_len); /* 1, 2, 4 or 8 Gig *=
/=0A=
cp_size =3D tc->msg_len;=0A=
// Expand the test case message to the full size of the large_data object=
=0A=
memcpy(large_data, tc->msg, cp_size);=0A=
while (cp_size * 2 <=3D tc->exp_len) {=0A=
    memcpy(large_data + cp_size, large_data, cp_size);=0A=
    cp_size *=3D 2;=0A=
}=0A=
if (tc->exp_len - cp_size > 0) memcpy(large_data + cp_size, large_data, tc-=
>exp_len - cp_size);=0A=
err =3D crypto_shash_digest(sdesc, large_data, tc->exp_len, tc->md);=0A=
=0A=
if (large_data) vfree(large_data);=0A=
=0A=
I verified that large_data has the expected data with printk's.=0A=
=0A=
I also tried using update/final with smaller large_data sizes, but I get th=
e same incorrect SHA in _final as from _digest. When I run the equivalent t=
est with libkcapi, I get the correct md. It seems the kernel needs data thi=
s large to be sent by send/vmsplice in userspace for this to work. Is this =
correct?=0A=
=0A=
Any help would be appreciated.=0A=
=0A=
Best regards,=0A=
Jeff=0A=
