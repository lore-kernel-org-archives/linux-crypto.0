Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F304F36D;
	Fri,  6 Jun 2025 06:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749190423; cv=fail; b=rz1T1cJpfoqHscBOQs+nvi/cRTwHSfYI5WE+c6JiBIOduUmmGlTvtg481RE55JC93mKTFFQxVY4cqwYi0h1Ng1u+Ee45v8LBxiet4PIadstuknOSAZ5YpBWaTtTrfgFmMI7ciElyZU2gTamyGh+ITGMtWxXDzDGZpsLt4MVoTzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749190423; c=relaxed/simple;
	bh=OivBTTg9+7FEb4909RJd9avSkXY07u2zpj6oQ8jW9ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rEfiD4kEoBjoUgEe77QNf48xMiPIp76Jzl7ZYdGRLip74r1+GYt96S58EzDjnX4e+NWu+kTuZULUSLza6wARktQ/sPp0f1V8iadTooltJ2dPtXi9eTEfmn9bW5Hkk0S1XoOrnoVSvRvFdcL0B9ioDM2n/wZlNPmVFNqM86Otzq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BLn1ublB; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BLn1ublB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPsrVLv/jDn8PRMij67nzASL1uXp99Wwf6NgzokBp80tPyMsSZ1m1NRSAKsC9UAVZIRsNCO96M7plyW7R2pqH/exuhCu7zUDrrKpYD4GldiGbasUwm4J25Li8iT2VMhsM48EAhyDzEEmfZXQpDd0Erh5LUJvC6d8WgGjdmW/uaZ90wa3NkXXIF0OtFjiAnl0oCCbugFoD2ZlMhLY9PNy6MHeq4MteQOf96YPhhgr07wNPQe/XcVvdJzOoD9/w/R31dUcvpbrZv6Y2us3OyARMVIlSzd8OA8+CNRYtrc2gypy6NpnUzKSaIDIl1F6i9aH7//rQD2MvpfbNzo+49EIsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73rJTSj5A+NleqSHeoCTbb8uujln46EPncHTF4ME8tg=;
 b=KnqIkm0JKbHm9cBofEa+PrwVlVLxD9kDYO8T5+2Q0FM/bffkA9bAjgdFhjRZCNuHED6Fm85Xh8oR17UJlfWLL7lt39M/h4g3vVSe0YS+ovmN07NVWjUqSrDXlLuvQReItJNBcX67vnvoELxjhcfI0KCTjDZFGqUGDXZD2rrwGUo1n7FhS3agaBz1HhbrDYLmvLW7m4Nmn+WSrJcrxFTOw7VMnsZIc06x6olAb859F2+nk0+WTsC7w5ej7PCTAS727CQjJO263DEhVNpvIg6Sn+qIyMX64sfy2YqWYdRLN5U3Wr3nBx1CGxujmtzK7JIQMQ33vSmtP6T1Q2hoMu96SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73rJTSj5A+NleqSHeoCTbb8uujln46EPncHTF4ME8tg=;
 b=BLn1ublBf56DiK3nWEm+MdY+f5QzyfDahZeNsUWowfWMAy5V1a02yRIBhlaH6rnb4ggZafsgnZqOZ9Ey5GTvujmK22z7Gc7HXr4+xfNuA4NFyrMf6qdxAabZGswYzXXxspoO/g10s/mHzLp+39NoWaFM8dZH/dLpfIkpe9ruaag=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by CH3PR12MB9281.namprd12.prod.outlook.com (2603:10b6:610:1c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Fri, 6 Jun
 2025 06:13:39 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%3]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 06:13:39 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Conor Dooley <conor@kernel.org>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "Botcha, Mounika" <Mounika.Botcha@amd.com>,
	"Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>, "Dhanawade, Mohan"
	<mohan.dhanawade@amd.com>, "Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH 1/3] dt-bindings: crypto: Add node for True Random Number
 Generator
Thread-Topic: [PATCH 1/3] dt-bindings: crypto: Add node for True Random Number
 Generator
Thread-Index: AQHb0I0+SNgKjRpq7kSnxlwWslfjOLPrWfuAgApYHZA=
Date: Fri, 6 Jun 2025 06:13:38 +0000
Message-ID:
 <DS0PR12MB93455B069928EF2DB772D970976EA@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250529113116.669667-1-h.jain@amd.com>
 <20250529113116.669667-2-h.jain@amd.com>
 <20250530-gab-vocally-110247b8f60c@spud>
In-Reply-To: <20250530-gab-vocally-110247b8f60c@spud>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=eaf15017-b7cb-4ab5-8aea-5685e59b95f5;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-06-06T06:09:45Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|CH3PR12MB9281:EE_
x-ms-office365-filtering-correlation-id: 47aab24e-51f6-4dcd-478c-08dda4c14775
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0FSiY4aepbweo3FIUkOZJ7md5b99GGUwUMsAeUVdWXfK+r8YAq7VlM30KOhr?=
 =?us-ascii?Q?/KQzPIp5ZQgUCJxTYRLMLXtKhRg50QeXR1Phe004t+nkVS5ayDB37rqm3Nt/?=
 =?us-ascii?Q?sonGiLqh2Umvy30/O3spI+3Myngy3TDj6FCu+cBfNxPhiaC7BD5fI91OI94n?=
 =?us-ascii?Q?WFMURwlv2KBm/iKOXYc3d78086Lu9h2E4ANx0zrGaAoZOBGLjcvWjmlq95Hy?=
 =?us-ascii?Q?tYihfOVm1Eowt21KFq0I2ag7KbgcU4Mz47wgi759p6XHr9fIAjdMVPRs1LFS?=
 =?us-ascii?Q?bq5nJeeZSY/sZ0FZwe02+qzv1n4bRiOxV4X1Tg6/9Z7SFuoqaERwu+9h4Lj7?=
 =?us-ascii?Q?LX2HyFgZ63u+SGXOFBcEnm85LKZ9ZXN44OMxKyofvE+9FqMNkuyLpeYXrCB9?=
 =?us-ascii?Q?uHp6XDEDGBm4SDaGd99h/I7pg948l9xzGAfDs6GGGXb2jLDarQmQ5etsmajy?=
 =?us-ascii?Q?1jxQnqTkCGlUWCrJk7mKTZG11lBanUyFdKMMhjW0GLgIrYx4ykPb2p3XAX+E?=
 =?us-ascii?Q?ZJ885ScfO8ja4bxMN7dRkqQmqokGMVD80ZPlwY4qQ/3W7h28PwlFEWyyKTKF?=
 =?us-ascii?Q?bZ9viE/lBaEKGkn2nWSwPnq1fDNR0J3ECaXLW/+bUuG/s8KZ5LavodOmvedT?=
 =?us-ascii?Q?zf2p0Qo0vvHuMscB4jXlrCTokGHeo8i2wIWUemegXAjGx5fJIwOxV3VJtW8p?=
 =?us-ascii?Q?B6uZVNWxvNIO1Q3bvLgQxcDwkW1Hc2STyhkhWcD8WOiQ8E9t9d7+NiOcpz4u?=
 =?us-ascii?Q?QPE+dlUT5DPzBlvJpFqv+bOwNtA+j0TY9BdlsygiBWPtwh2Mt5vD/r1icNLx?=
 =?us-ascii?Q?Ql5tjeKOn8TCl8WagzUYyeUEeFPiVX4lR4YgDm410q1c0uAdJO1uIUnQHsJY?=
 =?us-ascii?Q?kS0I2aZTwQW9MWcQ1wSOUpdMegrTqKSK3UKhHuq3Oqd16FjdEIG4Uilu/vya?=
 =?us-ascii?Q?i/NUiBkGwTS5kLJojFIRAjJjLS8VLpFCBBwYpbgCAgSFYj1FUz3v1n1EFq97?=
 =?us-ascii?Q?j9nyEM4h0WU7nnOi+WKzQOzVUj56rDnIRmQiehgsLLkPhQAQrAfyNwnl2TQ9?=
 =?us-ascii?Q?T62ZaFv+6paMiYCCWC1VWF5O6FUb1qhIDGjjGizTAZ+pS6HVG/0vE2P6vQcM?=
 =?us-ascii?Q?ijuHGXFSfEIE4Ky8zJCEzYqK/4Mm3itKyj7STtC4OvgHP8Hvqt4W70XCmkGa?=
 =?us-ascii?Q?wlwuoxD28i6AaczFvAFpxL6GQo4JM0KgEtOS3w7Y6nLNLdLrZnzpzV1LaHcq?=
 =?us-ascii?Q?8xvamHDCEiz/5qD72n4+RrOm6Y7Tud1lU7HDE837X2jDnernbh6zJ3VOFkbi?=
 =?us-ascii?Q?6CmH2XqfE2VMKviILEUA7zCK8S/J6/RbRVanDJAKYnfA6DR46QqLpydPXwS9?=
 =?us-ascii?Q?EsPBW/SgKVWzeoRw8VFOqRvK5P99pENZJq7beLBT+g+INQiOH5mKNF9HpUeB?=
 =?us-ascii?Q?aQ3mdhSzfGney058UTbn3c6iEC9Z69tN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mCPASIlHCk089+4E0GUWkXDpu0c0pj4h2sOk+haXQNZ3w+XKCcKF5QAS+pUs?=
 =?us-ascii?Q?u4dX3hxoQn8KnszSn+xokzsO0Wtp9TmSIOxzLh+ginhUhr3KnZQyNt0pnFKz?=
 =?us-ascii?Q?u1wGjw2VoKKLeNT/EyQo4och2GwTT45CkSjFSsGbZYlZJjC7DvbBctKnJ+84?=
 =?us-ascii?Q?X9CmWjFeL/yTLPJVXA/tpicQrFemF0RSpAH1TJvKg/0ut75vwamf5Wv4q6C7?=
 =?us-ascii?Q?6Opl3CoZXuSkCHIUZQvonRKgaE1+sDexpOL1a75BOOW6VBrDf7FbenUbr+BX?=
 =?us-ascii?Q?wSe4FpPcRl52xooWnvQLydkmws3qJT1UznqTsmSqXKSvOzrkGdfLZ+Wq2uoz?=
 =?us-ascii?Q?IlQKCR7hZdVaXuwivhUET5lzSfqhVA454k8uBx5T98TxP7DynRtIaqEQ5OEu?=
 =?us-ascii?Q?xwbc2o3eb88xCSLbX8L9G4rbY67oGY3NN/a6ybo3WPE4wKZxYVEYtUO6b9+U?=
 =?us-ascii?Q?HvuAmLN/eneWGgdMAgIeXlr3dFiO70E0/O12tMfyZzZFd2Ui5LkC2SuIbu9V?=
 =?us-ascii?Q?of2mEFHWLRu+KRzzCo8oCIgemFjnB9MqlLpNkATpTOLwsnmuR4SIkQaECzWV?=
 =?us-ascii?Q?ry4MyLOK89toPvP3QAF3UD/keUMvU/Tu36YwBczHcDJmX5ryF2eFkLqpmnqK?=
 =?us-ascii?Q?1SZnYotcWBkBYgXYdodjdVWfQdtzpSRUEJyGeqRP7KOTS3qCWWr1bBTTzvnd?=
 =?us-ascii?Q?5xh3PQVTT6S8m9tLp+xk0t7DwkhCdwAIUhWwaiZRzGK51WeQ7pO2a3CGYpJ2?=
 =?us-ascii?Q?aoSetEUmJksJI/d2JlIKS9MrFNSBSKyt/DsNAdodWAGoCLpn90j+5NSM5j7L?=
 =?us-ascii?Q?aULJo/HgQg6EbxQ/VDGmzhjXRTwCLYAEeeci8pshAl+MVSrYbprBo88UXoJB?=
 =?us-ascii?Q?wZZ5qcKpCUC+wDx4LT0RFweJmTmf49WkAv6rnFhACYSRaHc/vvI7y7v0tHPS?=
 =?us-ascii?Q?qZ6YrjP4zZ5hcrcI0VP2klIfoBX/RH3DfjgrUvCRLOQ8PMMcDwQL0thbB3/f?=
 =?us-ascii?Q?xzPG5T6h9NpoFBYNzM/3E8bJajzYF8zaE8jDaeGIoNPa9y5dDMozfJLdbC7d?=
 =?us-ascii?Q?u60H7XULHQIoHtWz6Sh2RxxrehAOjWn2LDf1c8lGzwYGMlTyWrbrZS243BU+?=
 =?us-ascii?Q?WYc6mW53StlkpGzPKNYyzs4xnj+fpPAod6Miphiryh5c8ueJPFifsYfBaF80?=
 =?us-ascii?Q?9ty5kqktY0D62dwVa3p6jBeEN+Zddn7wW7yeCxUTs6DyRYUDoUphDE5xTrL4?=
 =?us-ascii?Q?XpqX1aE5fTDWDbtkzSqdruqh2giQbRQ1UXxIVl1Nkw8efqoT11dJgFnlZ6VL?=
 =?us-ascii?Q?sv91sUhqaumRXaoz6sDB5oFTdto4azpagCOLqsI9E0UpkWTqfbr6FYh8Cw5O?=
 =?us-ascii?Q?Tjv49V4FuWL7Dlq0+Ml4PpWfVdF/EiVvR51tUBuBcd8YJwq7g8aRQ8FUMflN?=
 =?us-ascii?Q?CjrZNf9wOKI+zKK+RP0KdTSJM4Z5T4ObX1dMrXwXqBCQBlE0fneCMeamdvxx?=
 =?us-ascii?Q?AyHOjv7UkiWbnZNPIArJjuYswW5RtmT9l8cnIXr64ikPWH+fJKKojDf7jTTl?=
 =?us-ascii?Q?s7pwrZc7OjFCQqb498s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47aab24e-51f6-4dcd-478c-08dda4c14775
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2025 06:13:39.0889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CcyaQUCEkTMQ7Oh4A4hvnzJAx/twT/Quip7srCH0myrhAnaqmYPlgLButWMjC/ye
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9281

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Conor Dooley <conor@kernel.org>
> Sent: Friday, May 30, 2025 9:42 PM
> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; devicetree@vger.kernel.org; Botcha, Mounika
> <Mounika.Botcha@amd.com>; Savitala, Sarat Chand
> <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
> <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>
> Subject: Re: [PATCH 1/3] dt-bindings: crypto: Add node for True Random Nu=
mber
> Generator
>
> On Thu, May 29, 2025 at 05:01:14PM +0530, Harsh Jain wrote:
> > Add TRNG node compatible string and reg properities.
> >
> > Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
> > Signed-off-by: Harsh Jain <h.jain@amd.com>
>
> The signoff chain here looks wrong, since there's no From: field in the
> patch, meaning that you are the author and submitter, but the order of
> signoffs suggests that Mounika is the author. If you are in fact the
> author and submitter, what was their role?

Author should be Mounika. I will add From: Mounika Botcha <mounika.botcha@a=
md.com> in next version.

Thanks

>
> > ---
> >  .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versa=
l-
> trng.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.=
yaml
> b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> > new file mode 100644
> > index 000000000000..547ed91aa873
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> > @@ -0,0 +1,36 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/xlnx,versal-trng.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Xilinx Versal True Random Number Generator Hardware Accelerator
> > +
> > +maintainers:
> > +  - Harsh Jain <h.jain@amd.com>
> > +  - Mounika Botcha <mounika.botcha@amd.com>
> > +
> > +description:
> > +  The Versal True Random Number Generator cryptographic accelerator
> > +  is used to generate the random number.
>
> I would be surprised if the random number generator did not generate
> random numbers. I think you can probably just drop the description
> entirely in the future

I will update the description

>
> > +
> > +properties:
> > +  compatible:
> > +    const: xlnx,versal-trng
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +required:
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    trng@f1230000 {
>
> "rng" I think is the standard node name here, since you need to respin
> to fix the signoff chain.


Sure

>
> > +        compatible =3D "xlnx,versal-trng";
> > +        reg =3D <0xf1230000 0x1000>;
> > +    };
> > +...
> > +
> > --
> > 2.34.1
> >
> >
