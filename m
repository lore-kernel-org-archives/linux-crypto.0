Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023104.outbound.protection.outlook.com [40.93.201.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF61425C819
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 12:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745411474; cv=fail; b=JR3/ha/eMEf4DrF668858va90cfKD9JB1Z+4o1aHSHbdIxKkICoXDzaMusdArajw4LlDrgEqJ4804OXhkLKbBQCjl186cpvBE+3GXcgT+D2KPIPSqeQqgtyiHIG3OXV8l2gvzsUUxeTgfH0p1TVmfl73K245QVT4JCYa+r0vaEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745411474; c=relaxed/simple;
	bh=f0wuI84jxs4SjvICd0nX4P5sjPPjScOYw710FMysjjk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ixF59LAD1V3GhjNp+J7yvxhjOHgH11uYsGjKKUqxL0zq9q0sUYEvm7z1OoWev6Z4xOmYuJG8c65X9uYACg5Y18GcKBG0X6BImbSJOFqjiaWM8LQ8cvfnr3woyrW2xb2Xkr/y4bmANYFLj6VPXaAxddjhUMi6+XJ7zM5DCacJMm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=a9STToyX; arc=fail smtp.client-ip=40.93.201.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="a9STToyX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0UhgXhQ7epEy8dHdbWmmhTaTknPZxhMEEFkFn0QVZZz8oXCsttARgGhmpOleF1PAEpvM/LA9vmhRsonDgzYShE7p2O+l3jb5CYtow9GySZvH1gJv5CuAFXkpOzsfBMkByJ6Czwwn7FZ+cqSznazO5zneWg4UZCiYZj/exKiogtcl2l74+4st10eQamQi1yek1uvEbnbZhzE7h8X4WnElteB5LFObJhh4U7GDIpKh0aPZZkaRmmD41jn33Zomic+Hbg6jGdrAWlkeFZlEd3RxVSY7R1GATyphWbtY4F2gRY+LpnN1s65WPEseKRC3NF9eXCt80USkB1zNYRosT8dKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtQVlqB8gJXFKGeiTL2ttpAOioMk3t/v/m05JhnK4Xc=;
 b=y06UcQogUtGyFevi4qiyqGdpmphnYnOk1LUM0At0XR/dyWnczgYdfAhGQj8cF5FW8rQpSG3nvGs7gBUTsehAOG6+NWHMmNSUDwz0fyWdP0e/k8kaQWQNI0Gm/t0WBsrfXsIkVhL18JC4ALcvTfV2pcVrAoyIfARmys8nuT88nm24ZAWii4IXpK/ogvLNOLE109L5ela4NIzdXD0lY+8lJvXs++hZIhLabR9SPP+9iiC4sUpvo6RxYyBLUlLqlCliVgyfJtDwOqx3rU+PGR41Cga/s37ZQ5FT2TfIpfldToLWxX3SUa/eTczJSmZdrcZYou6LFcWbSaRDoaDhfdxRtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtQVlqB8gJXFKGeiTL2ttpAOioMk3t/v/m05JhnK4Xc=;
 b=a9STToyXnb6AT07yqIIGwLHjbxxgRB07l3fpNwqv4g40F68wvYEKR/nJ3Q2rICsBQb7e+4lDIfEixMEgSUQQHL3dcDM6zBCQyoOLQfSHJtnDte+H6yNlLGDS3tKpBZjfPnX399dz974Bzn4mkYdYJM0qLxDZrNMpfYZodKE3NVs=
Received: from BYAPR21MB1319.namprd21.prod.outlook.com (2603:10b6:a03:115::9)
 by BY1PR21MB3943.namprd21.prod.outlook.com (2603:10b6:a03:52c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.10; Wed, 23 Apr
 2025 12:31:10 +0000
Received: from BYAPR21MB1319.namprd21.prod.outlook.com
 ([fe80::1efe:1414:43ac:7820]) by BYAPR21MB1319.namprd21.prod.outlook.com
 ([fe80::1efe:1414:43ac:7820%3]) with mapi id 15.20.8699.005; Wed, 23 Apr 2025
 12:31:10 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: drbg_*pr_*_sha384 fips_allowed not set
Thread-Topic: drbg_*pr_*_sha384 fips_allowed not set
Thread-Index: AQHbtEpilu3oTds550Kn1Q+3tzijhw==
Date: Wed, 23 Apr 2025 12:31:10 +0000
Message-ID:
 <BYAPR21MB1319D9FA2CA2455E1E393940C7BA2@BYAPR21MB1319.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-04-23T12:31:10.239Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1319:EE_|BY1PR21MB3943:EE_
x-ms-office365-filtering-correlation-id: 67e57a06-5a7d-475e-158a-08dd8262ba8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tUKLdgjdDm+S4ci4SYtKu3M2tl8wAYgiwvaNLmc7uKIwqFoAtED3PwIiSd?=
 =?iso-8859-1?Q?G14srzUFx1BVHNiVu48jv4mOoW8iUkQfIWfcIkPS5ua5N2+nW0cPLPRL7M?=
 =?iso-8859-1?Q?JijQIrAjWIfM0OnWZBIf/c6wDDKvd0sv4v1uaOmiY+upSjfjEWqi8uNsym?=
 =?iso-8859-1?Q?FKlc5Y6Jt8ss6cQnZJD62TC85GrLuLffaUI1bMJil2era3Sukr6OWdd+kw?=
 =?iso-8859-1?Q?SN7JWdV4GtoTkBHLc8abAXFfUkyC/BJIZVaFoPvN+zqJAnxf+ViZ8E8/uS?=
 =?iso-8859-1?Q?4hr9LjZ6OSq4ZAI8Ir+sD6ukWg8LOzY41S7z7/fOZUC2738CRzX29FK4Et?=
 =?iso-8859-1?Q?O8ZJdga/oCeHBLHcfuSwwImMmYAb6ASxfMrjyH5TFYZLPCdT7oDpWTz1c5?=
 =?iso-8859-1?Q?JFSI+Gx5wvg1tLncfJn912SioYq/FPRI72nhYJTxR/JfnWAA7zm+i3MSU1?=
 =?iso-8859-1?Q?C8WY6aBQxtgNmpvhdproU5Z0tmTYuI1D3r+u8CBF2Ci4mhUXkElViXt4Pr?=
 =?iso-8859-1?Q?v6pa7hd/SHIUv5jbAMhNRBWYH8MUcvuxe1cOnX91wynXEcbgRr8oO/kfhD?=
 =?iso-8859-1?Q?ly52XWysbZrGe4TtoCKsNWY+eD42+HjhA+2VfVlpTA66bf8Uo0SfIcZGzx?=
 =?iso-8859-1?Q?sGObAakIVUIF43WOTZTD/GjhMcBYedDM8yZdgI6FYhtg/d4jljk1Xeuvty?=
 =?iso-8859-1?Q?kzwdxKsJLq7gWJ1YUomz9Ae9SAq1zUiN4og/AFx5njCsKFWVC6K9aHTpRp?=
 =?iso-8859-1?Q?H0BHe/QUWeuvJlZ9OKc3wMsgbhx+Oe+L2C573hp1BgsiaKRgq7FEwZepU/?=
 =?iso-8859-1?Q?VpfZTNG6GJqNvCF3N6qOWZXxzgaNHaB0I+zQAf7nvILIY5A7+ux6AnQaOh?=
 =?iso-8859-1?Q?tcnjXIfV9Jv/nPL/KHYfEPWfLDcMqrMHkx6Oe8LV72orwjkBQCU8NeXF3A?=
 =?iso-8859-1?Q?bo39QMixclz0jHqjAEJeV5mIUb4fh8r5S3LQ3IRj3YAquMODllhURLX9af?=
 =?iso-8859-1?Q?H+Qd0FObqRnkHPTQ7qf6ZwOO/43nS62uQPoznBCtp4rNzDSj2wjhnXgDwM?=
 =?iso-8859-1?Q?1zeDqevRn0DNe8JexhoThFDNQDuMvo9lIKYbcsuFkOw0n7R3XZLX4LxCNp?=
 =?iso-8859-1?Q?HFB0nMcHefVtpvKd61wCj4iH/0Y9xrXNx9mr7sji284FhXtAcVAHObY/nu?=
 =?iso-8859-1?Q?//Zig7JwUcEjfpeS4bAhkP/ujz3cfV/zT919yhwO2k1z4O5jhvRH3vgLrt?=
 =?iso-8859-1?Q?MXjcZGcXt0TDdK3iCQwn8wlX7Armb5QUrfg8cPPlQjFIHJaoEd/MQOETJo?=
 =?iso-8859-1?Q?MD+TZdImkaRndSNDkyOti9kRJMLfqe/njjDWRt2Y6rz0RYnqmKzQ57NPLj?=
 =?iso-8859-1?Q?kD2XyG0sg/C2/vkNAVk9AkGIg1NNX3uLZaelvq0L62iQkiTrS+4KJ2Y7aP?=
 =?iso-8859-1?Q?35p/COSwEA2GYvv6qB66zM/ip/fiVRSTK3qzOu0rbKqYR4EgHYqSjv7s+s?=
 =?iso-8859-1?Q?f1u8fiTx84305r1WPQ2lPxG+SLlV7QZ4ysvSTRqHOgtA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1319.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Mf0q7E47gtt3TehONUUJKaQY1NrIPXsgTnd+UH8IXVQcJHhIqC0uJ0nyug?=
 =?iso-8859-1?Q?pLPfHle9WTrJGjf+R13gNkAqFl6NMSgAwT6BG8dEDJKky92srLtDyRCqFg?=
 =?iso-8859-1?Q?XW5xitnW50lJLAIUAXKIUW2zD2/dkCv/8B6uhWta/scNRqu6fnsJoKLnO1?=
 =?iso-8859-1?Q?xyyWSahBWX2p7YegBeD5ExFLVKug4pwr+s+mbQRfTvc7Qn1L6IOswOcQsu?=
 =?iso-8859-1?Q?UV/Yx5sbaxAIOc3r4gDQMLS+T/QmCnISvM2wzc5/eOD1sfaNQuLK4jUreh?=
 =?iso-8859-1?Q?hwObBySpsoYGRE8Gd17KGUUPfQlX9dGM7c4OFrazWh5aSjOhFaL6EVQG8R?=
 =?iso-8859-1?Q?wJN2JXKtaHPlZugkz8oOshH9hC0MKY0NtiemswUoRX8jWqdkj1ZtFt8Igq?=
 =?iso-8859-1?Q?8pN8mv9SLVUM4xwWTyzg3Euw3KyoOzPiuCdfNjb60johaDFVotfKyetAqI?=
 =?iso-8859-1?Q?3KkpjmH8BQW38o03D2L60LREbRJ0FQIiiy/3d0+9NZm2TDRh8wJePSw4a7?=
 =?iso-8859-1?Q?BzaYPcRNgiSkCVC5ffZznn9BQWSJHJT/2u97AhobFZNcoh7+ar0OgjiidK?=
 =?iso-8859-1?Q?Z8v8f4VMR2T834Jzs+IRbn6rY7q0HvIwcZZVNngjFMH6SB2Aktsd+Z6pQj?=
 =?iso-8859-1?Q?qG0mgp+ULueyb1mTYUxRZne3rRB+8AQ7XXqD5pjwrLSjz6cKJ07qPpQUcy?=
 =?iso-8859-1?Q?a1cFznaBbya/FYKzseCXImFxPV9u5CSxSO5Jm5ETw9Q+79xwf78D5RnZtP?=
 =?iso-8859-1?Q?jhYc8ZImc6areLOQXvTKQoOPMEcu4GWQ1OE8801vcBl7GcP7u2hlu+B023?=
 =?iso-8859-1?Q?a/kmD2gRosYBMDtsBV3oIkai/kGPJGZLDyLYj34t4t2b7DbLkU3stQJewy?=
 =?iso-8859-1?Q?44WoPNMO+4kX85g7pk8Xy35+4ZJr3HfaoajcX0fi3CtkCDU11EAutYdfgd?=
 =?iso-8859-1?Q?0jE+lry4HN5kpfJ7ESs3SLJeU2k5xvz0F6xWKoc2UD/yeEqYYumDoSz21X?=
 =?iso-8859-1?Q?rpA4uGFq7F2fZFi5nGJVS2vvoKIiliQx1YgZNpBencECUBpJvFBh/bM0UP?=
 =?iso-8859-1?Q?14Xy5K5jxv0BYClo9csDzvoJEI//BdK1+gzJ41jOKfpnInk6xFBTj8wnY7?=
 =?iso-8859-1?Q?GAmpg8ddGhTE1arDyQeVxVqgyOwrI/cCgL5x6L3eMhBhExyc8yiR0rWREW?=
 =?iso-8859-1?Q?2m2shVGsTC62m0pq6APyoZ5i+fPkbZ7s8a/2VmyL2qYSVaLJC7nNH1duez?=
 =?iso-8859-1?Q?4ZHTm24Nlv9hxgoCKwzvZd7v/mGjFQOsKXLFaBICesHzBXSRgjCrEDTJeT?=
 =?iso-8859-1?Q?IpiBXeHOqABc8V92QsF0u/1efWOHJXLp3ot/R+9o0Q5+7gkShn71jvg1Gi?=
 =?iso-8859-1?Q?ahjEmIxgp+uYu1lQEFGZpnuvANHN3f1w9QTiHvUDnwL/uqzinFFLK8+4qk?=
 =?iso-8859-1?Q?MXMdh6NHl11MDIpNbsJLqZaxHcXWy0wVdCaKlxZ3ic7d867aIOn6CvAl/D?=
 =?iso-8859-1?Q?c9GaJyWsWlHYmppuxxoYBhJ9aczejcihUqR5Jcok3WHBsB0mFRhFeqKoS9?=
 =?iso-8859-1?Q?Xya/bPOwsn1i96717ONBaFwMyPKEI/YnfJUcKoDtXPun/0B95hjo0d776e?=
 =?iso-8859-1?Q?PUqukydTDC7FUQSf5S7jyTR9aAFQHE1xTs?=
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
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1319.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e57a06-5a7d-475e-158a-08dd8262ba8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 12:31:10.4356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hEYXUCobqFZouzKI/RUnePLQN6IAQrp7ramHEnZWGUgWdqOeQeJXZqDEswVv0V+is7j94vp/V3dndALMzI/B6MNb6P9kieMUMN+eUwKg3N8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR21MB3943

Hello,=0A=
=0A=
I noticed that the following algorithms don't have .fips_allowed enabled in=
 testmgr.c. All of the other drbg algorithms have it enabled. I didn't see =
a git log entry explaining why.=0A=
=0A=
By not enabling .fips_allowed, the algorithms won't load when fips=3D1. Wha=
t is the reason for this?=0A=
=0A=
Thanks=0A=
Jeff Barnes=0A=
=0A=
        }, {=0A=
                /* covered by drbg_nopr_hmac_sha256 test */=0A=
                .alg =3D "drbg_nopr_hmac_sha384",=0A=
                .test =3D alg_test_null,=0A=
        }, {=0A=
...=0A=
       {=0A=
                /* covered by drbg_pr_hmac_sha256 test */=0A=
                .alg =3D "drbg_pr_hmac_sha384",=0A=
                .test =3D alg_test_null,=0A=
        }, =0A=
...=0A=
        }, {=0A=
                /* covered by drbg_nopr_sha256 test */=0A=
                .alg =3D "drbg_nopr_sha384",=0A=
                .test =3D alg_test_null,=0A=
        }, {=0A=
...=0A=
        }, {=0A=
                /* covered by drbg_pr_sha256 test */=0A=
                .alg =3D "drbg_pr_sha384",=0A=
                .test =3D alg_test_null,=0A=
        }, {=0A=
