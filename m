Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020116.outbound.protection.outlook.com [52.101.85.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8E1E498
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726069450; cv=fail; b=bQEh+6a2RTNNgmsd04AYkIa8/+sjQ4QxfvDy3/X4ia3iE5boat0xCA0bokAfG4iobQLA6qmBxN3ZRLBzIcbACGoJ9UpfeWLlIieiHZJ5dfk6nYupd9w+wstD7th2NgzcUK0M8Sk/l1hSYJvXEI6k9WQ4rpIxBRCJxvVExl3a944=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726069450; c=relaxed/simple;
	bh=dsdEGTl15aktpr2BgWnkG2oKUv3ferby2uRGxoNKcdM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MoiyHxs1vtrW1x863APDQMItodOvs+/utG4IXUJ7wbDfReuXwNaxitKbS/6qNykp2pi4QUel5bQ30WT4meH+5IvSRvsKCRvtWyqYlxYmaHEcml5RAMSab8CXWdPD9ViMRgZqdv3JwNNFnQNridAghK4dSU13JKwc0DfJS32jRic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=ag75HCrb; arc=fail smtp.client-ip=52.101.85.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="ag75HCrb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbN5gJBHjt2jCPlH8w9Fr0U3DlMgyG8POTL0/4soZ9OURJjZyyJtOeT1uPJaY3n4BD4xzEKGi8BV8eE2IQzTcZNvj+6PLDW3UpMIJSqWXTirebTcBURB5gAbpUNdbm9zWn0ycHXUDKyVQP7sbUD1C8iH72xkPfUrDCkoFtq30pJl9j2jhmzyN5I0NMityer3Wv0gc7A1nCvEZ9uAvYyVNAMev8t5QqGOWLqdM/83ikOLVdYeLFDDyvXfeWVyjB27WoJva6Kw4cTtR2+SJ/8kP4HaS1yat8mJQRy7t87FzJDIFYqhKcasxmQb7GBKZ5/Ewwfxita7QHVzGW9CYvJ/9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef6FANRSy3v1kc4ciHFZm3JCdOZ8JaS5fWNQaft3WNE=;
 b=y4uGjHPw9xDD6rqf5AmEYTegHj9Y+vNpj+pVONasQaVflTg9yBTZfK+xW0aj5P3ZG43mmQNxrqDXUdLLHeUNyYqo6ZL3dvDK4PX84wb1lqEgyU2Y8GX2LblrsVbnKAQ5Gf9mJqp+8VzKDEqemJnvmwJzA2GnWimiE7hwxZKIYsX1gvE0cX2X8kYBuvS1ek32yA2qUJ6gWI35bPIlAUxBv05qV7aCpOjkYCgfpZQgqbdH9Fq9Xe4C0e8WQ86k3wjRj0fnHKTVaVy9l2V0+3pJrYVMAbKm6fNd3tM6voaAY/hEU6AuvgpNu1mh7ldbDNioeNRb/JE04DJSZ0Wv/JFW3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef6FANRSy3v1kc4ciHFZm3JCdOZ8JaS5fWNQaft3WNE=;
 b=ag75HCrbIoww224t+4uqJcUyD5dDrquKWcgMgJanHghx1+sXud/mHEAjFjO/s2aZ/5kSrSiUMRXy3yFdLvacN+SnTiDNz8LAdgSyIoQjh79aNfbSaWoYSqbsdF/Drh9usblo4jOZpkkCZqYac6/8Ro89Yr9d4637J5HoJxwXOB8=
Received: from SA6PR21MB4183.namprd21.prod.outlook.com (2603:10b6:806:416::19)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Wed, 11 Sep
 2024 15:44:05 +0000
Received: from SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e]) by SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e%7]) with mapi id 15.20.7982.003; Wed, 11 Sep 2024
 15:44:05 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: Ard Biesheuvel <ardb@kernel.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest
Thread-Topic: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest
Thread-Index: AQHbBEwSCNhYTkgAFUirBdo85cqkSrJSmpWAgAAOgnGAABEBig==
Date: Wed, 11 Sep 2024 15:44:05 +0000
Message-ID:
 <SA6PR21MB41835440F537BB574ACF4255C79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
References:
 <SA6PR21MB418301113B9F45171814851DC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
 <CAMj1kXH7ubpkNQbSrvukvbJHnDDGSq+JWyMaPvPtUcYH=Mvsvw@mail.gmail.com>
 <SA6PR21MB4183FA8C1786EFF29BC7676EC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
In-Reply-To:
 <SA6PR21MB4183FA8C1786EFF29BC7676EC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-09-11T15:44:04.727Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR21MB4183:EE_|BL0PR2101MB1316:EE_
x-ms-office365-filtering-correlation-id: cda37650-6bea-4f85-f30e-08dcd2789109
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?PTZxA5bl/WjqobI7cKN6PNUlT+Z/XK8h+b9NXDqEl45OUf1uAR5j0z2Ra40M?=
 =?us-ascii?Q?UbgCkRpIXFpzyYU5KZljd0mhGf1W3UM4UwC19xGFM+4mV0vOTASBuxOU5H9O?=
 =?us-ascii?Q?cG4dwVWyvR6kCtuYemV837qH7U8jM0sinNMaptAdARz4JSvQYJIC+aNirarP?=
 =?us-ascii?Q?dnN9NInn1ccVDRo7uNbML/QTESWs6korwCMTlaFYnYwXy5Tkws3IRaGESQDM?=
 =?us-ascii?Q?gHL2EWPrjJ+dzyR8sw0wD7iJRUnuW/eKxdlemRCvQ/7Q6041DRzuI5Ni9bwk?=
 =?us-ascii?Q?4WGMHF7eHPkI3OTTKgsFgEPNrn/OXFGMbqZeKnZCLE/0HmEr9R4PJHjZihgq?=
 =?us-ascii?Q?l7XhNBnzZ9Refa8+neG4p3YJ8QqOaT2CXzDTOUPToafcBC5Lb4rith/vyg6Z?=
 =?us-ascii?Q?Sh3sXoFPIOp/mLUB1Ok/4oqHdvtJp6jb1S2BcbagnwmFXoph+6rnpDbuMnXE?=
 =?us-ascii?Q?WeA1wpChjuR1dN0x2xwNaKfBpJYnqasuP7imeN62x+Xt0zvnTWGfj+fMSEHX?=
 =?us-ascii?Q?W8osla3fAKGUBvUGXacwCyEDkIwnG0JK/DRmRIQbhLHEUj2QErvbxyDR0hrP?=
 =?us-ascii?Q?YMpl6LwP+W2pIK2p0ZBi/TDY/zg9gstYfkGU0VcB6v817opYDlGEoeSmq2dP?=
 =?us-ascii?Q?rTT6zF07dLO9wEC92HWWtRntOxKcW5knhRrosHO8heWjiAIWN1PpttoiLeSI?=
 =?us-ascii?Q?FsRY+Vg1+5NYw9acqL8+ZLKRKG2IjUXDFSpZPsPMvYp2sHjAOa3e0O3h8pZ7?=
 =?us-ascii?Q?suxFcT9X9J5SFL7vIWTwsJMBSGWdNlm4mUi/OsoDNnc3eLqAvAVNI2xl9Zy/?=
 =?us-ascii?Q?UT9GE4aV+PafzHtx5DnqmziK6pl86mHO5/tgjMOGikPzAct+Eh9BRG5bFseM?=
 =?us-ascii?Q?x0bcrmucqGEIktJshJDQcrZ0200urxMJXC29MM8fe/brLaaItQkc7LGbUqlp?=
 =?us-ascii?Q?VJSVD1nMHBFmgG9zoLrzAK+nfWoDJtv0BqGmG6bfZSfOG/nQP87niEGiSOPv?=
 =?us-ascii?Q?O+ru6aNvUi4xbUd6HaLlvEsr6mwJbMI+8kZvRMvGKELWOnEjca2JFvoMVf9Q?=
 =?us-ascii?Q?wBG0dNil88TnYVy1w5YEzvN7G99hp7Fk85ynNhWiYrdGpxeDrKAl8R8tGELe?=
 =?us-ascii?Q?HeH4Wa3ASSfhDuBMzg3EjOD+AKaHki8OTjR6C9npCZPcFfR9KgoPizNkkFbm?=
 =?us-ascii?Q?zP/v45z5tkK+3lPBqnAc9qOOZ3o1mmYxk13bsF4asb5LJvi+uAeZT/P2hqVh?=
 =?us-ascii?Q?WzydoPrlIEb7URH5nfsQK704jgL7Hv2k4UINH5r+sRRAwgtfQrMaWYmYl0yD?=
 =?us-ascii?Q?vR3LTidtOJOBCZz9XuERNWYKPGDWOWACKK8JT1T+7jSV4dXftprMURaolbok?=
 =?us-ascii?Q?8odepopr5cZX8y9lt+4zMHJLflR//Ux/K54IlA0MGK5oiSJrmw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR21MB4183.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RIuDOcvERw/IXcJUcKHqJdSQMnxq8p2HQZtdgAXgSNh9Bco7b9L2NtpiYLZv?=
 =?us-ascii?Q?du97D5BVrL11iHSZp7HGzXytwpmANC5B1TBG9e0c6Gr4tSzGuGoBGSAnK4gJ?=
 =?us-ascii?Q?6O1aQlrSooyXLfNNz21LdoEbagoiNZSP9WbEKzw0aSP45DUNxxuji7iodeVe?=
 =?us-ascii?Q?itFaQaxn3hytXact7YZb2lOx/qWJoj2pgsY6CPdNeJZgF6sj5fJBESzy2PuK?=
 =?us-ascii?Q?3JJTAmUOGjNa5QTMN/VP7xsBTMen2RWKGdLiHXKjzwFyawdZq8BXtWEmPlSx?=
 =?us-ascii?Q?n0Osi37CUS7Xy4I7q3GRUUArawH/lNooDLZNnrlMK+NfoKmIXd2aKMSZSBnz?=
 =?us-ascii?Q?yMKwjDwFw0HmDRGVTKBIO+Lxf1JMrm6mYAsBVjYilmslwU6/IBjbTCUVo/o1?=
 =?us-ascii?Q?g4bbFHX9MrRxx0fdAn2usxiCTeVXmepFIn4FaAfrqJCSBg74Z6IgIaHhF617?=
 =?us-ascii?Q?t9xJ8kYPcGdLhfLc2YM9vO/0tOi/Ulkr9f6N9ogJN1V1LWX6VTyZTeqK1BIZ?=
 =?us-ascii?Q?fCPIZLIsHpf6b2WYJMvog7KvSpc8zJMANkbOdz57Y3BVoJKywP5XVOCn+QbF?=
 =?us-ascii?Q?+GSr4JKFrzxY7vZ1cGJYQ39q8zwVLLqtgbYAg4sLmTqDGRnyKZ8Sc3N81ha8?=
 =?us-ascii?Q?pH6OqySyB6dHJ/z/A6Yq1icNhr7E9wZ/rQ5dnvFu26ml/rPp4kURlyshTiJL?=
 =?us-ascii?Q?tARVQbbS9BwJqE949JgDWlROWvtN25bKTiQ+Va/MhwUYatvl9ZGQzXtSH4Ct?=
 =?us-ascii?Q?PAvKo9FSRPYzNTsYIFLbSCKSgUtQ56qc1m0PqIwY6vQWLJq0mM5DrzZEbfW5?=
 =?us-ascii?Q?MLXE1I1TrwTwVTM2eGVXcrGGBcAmDHEd1wzrH9U05JgduYQUSdu+NNr7be0Z?=
 =?us-ascii?Q?jeQat4TKBfxQ7XeJs2rHkWe/JoMgtsc5n8iy++hEN74BG2AUiONFDruJVpIX?=
 =?us-ascii?Q?Zy0Cj14LElVtEuIE3G8XNCaE1X1chO1B7ajvg+O8+jCUv6qIQMrQMEsTEmFV?=
 =?us-ascii?Q?6ZA9Jg/uzsEFxr5PcKDRaUNDaYoCudH9P12w2mNy6bWjefMIY6/Pk+e4EXaC?=
 =?us-ascii?Q?L1FyQb1sgEkKRLqkB4DCRG9LLZPzrtGQUvtwlqJIz71QWuTSFKwQhgEhrV/i?=
 =?us-ascii?Q?TQoFMuHxzckJcXOazLcPIWeLvaxQEFXkgZfgf2u4UQ+UXw7WYTOldyeriVhl?=
 =?us-ascii?Q?va0OZiTnXyqD9Thc/31Cg/gzA8Mzo0i9MQzr+AQvHx/H5HfQ1gs1x0zYZ4ky?=
 =?us-ascii?Q?xYmb03/R8ZBw6zQEQCGuWWpuNUwEAUF+EIRdH5idV/XPELhM3XIuA4m3TmF3?=
 =?us-ascii?Q?yTNM5FQBCoP1h65h8/6eElya0rpMgr/2SoaQBimG1bUz5ei4qKbFaJOT6Geq?=
 =?us-ascii?Q?erhneaaqryYCsr6vv7Je4cqK3tjyC8h666zL+jlvCXbKmOkJuDLC82a2Scxo?=
 =?us-ascii?Q?UWJGaRhslcz5DbbQ8ftThb2GrcrTnvuk2jYHKJof2/Q/+cwT3JUSFv2ddfO+?=
 =?us-ascii?Q?6QZjeIa7UrYEDl4joX1uh9od/D99DmdkcC950/9YDH9pYwP5MndSksAwyXOO?=
 =?us-ascii?Q?igZL0tAnt2X53wz6q36lyTxXWiNTmfc2//No47WI?=
Content-Type: text/plain; charset="us-ascii"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cda37650-6bea-4f85-f30e-08dcd2789109
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 15:44:05.0660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kO17WWW5vhk6LXQe4DgGJAiZlSCDHPEOGHfS6ytjHCRlEEkqrhoRaOO6K1Mde8DqYt+K/ZoaoQooAXdrAX7D0fp2CbzV6tDwrYSK70IVVv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316

It had to be the data.

Aaand it was.

Thanks everyone and especially Ard for responding.

Best regards,
Jeff

________________________________________
From: Jeff Barnes <jeffbarnes@microsoft.com>
Sent: Wednesday, September 11, 2024 10:42 AM
To: Ard Biesheuvel
Cc: linux-crypto@vger.kernel.org
Subject: Re: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest

Thanks Ard,

data size 1073741824 in range, less than 4294967295.

That was produced by this block.

        if (tc->exp_len > __UINT32_MAX__) {
           printk("data too large\n");
        }
        else {
           printk("data size %lld in range, less than %u.\n", tc->exp_len, =
__UINT32_MAX__);
        }


Looks like 1 and 2 gig messages should work.

________________________________________
From: Ard Biesheuvel <ardb@kernel.org>
Sent: Wednesday, September 11, 2024 9:50 AM
To: Jeff Barnes
Cc: linux-crypto@vger.kernel.org
Subject: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest

[You don't often get email from ardb@kernel.org. Learn why this is importan=
t at https://aka.ms/LearnAboutSenderIdentification ]

On Wed, 11 Sept 2024 at 15:17, Jeff Barnes <jeffbarnes@microsoft.com> wrote=
:
>
> Hello,
>
> **Environment:**
> - Kernel v6.6.14
> - x86
>
> I am currently refactoring an ACVP test harness kernel module for an upco=
ming FIPS certification. We are certifying the kernel SHA3 implementation, =
so I have added test handling code for SHA3 to the module. While the Monte =
Carlo tests and functional tests are providing correct output for SHA3, the=
 Large Data Tests (LDT) are failing. Below is a snippet of the code I added=
 for LDT with error handling removed for clarity. The sdesc was created els=
ewhere in the code.
>
> unsigned char *large_data =3D NULL;
> unsigned long long int cp_size =3D tc->msg_len;
>
> large_data =3D (unsigned char *)vmalloc(tc->exp_len); /* 1, 2, 4 or 8 Gig=
 */
> cp_size =3D tc->msg_len;
> // Expand the test case message to the full size of the large_data object
> memcpy(large_data, tc->msg, cp_size);
> while (cp_size * 2 <=3D tc->exp_len) {
>     memcpy(large_data + cp_size, large_data, cp_size);
>     cp_size *=3D 2;
> }
> if (tc->exp_len - cp_size > 0) memcpy(large_data + cp_size, large_data, t=
c->exp_len - cp_size);
> err =3D crypto_shash_digest(sdesc, large_data, tc->exp_len, tc->md);
>
> if (large_data) vfree(large_data);
>
> I verified that large_data has the expected data with printk's.
>
> I also tried using update/final with smaller large_data sizes, but I get =
the same incorrect SHA in _final as from _digest. When I run the equivalent=
 test with libkcapi, I get the correct md. It seems the kernel needs data t=
his large to be sent by send/vmsplice in userspace for this to work. Is thi=
s correct?
>
> Any help would be appreciated.
>

Hi Jeff,

AFAIK the crypto APIs generally don't support inputs larger than U32_MAX.
