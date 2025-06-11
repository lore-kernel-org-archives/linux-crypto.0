Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915161779B8;
	Wed, 11 Jun 2025 04:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749615804; cv=fail; b=pfg7tYoWX3MJy6LBy3jlpxBHsyleTCEH4M9rXcpMska+iPzDBFPtG6ac68/A4O0ioKp5c0DCnvIcRQ6NeKjcvBaELGYMDSgKFH5p1wlXHinWd+YWm+3C2gwiTM/OwPDVHwJ7PrsLlsILWHC8JyMzrbbE8pAaAnOeToG775dIMtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749615804; c=relaxed/simple;
	bh=3k8fM/cgg69eF5MlfXAb2CzhG5iieFJjztiC28ETCr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iD8WWAgDSetQjOrph8nfAKs3NyXKn9ZEf0H8VNRjUNSynf4Zh/Hnkv3Jr3vtvDrJRYe3npYBqLVmVHFUhYCOpRlUGiqvzynoQjHw5VpNjQYt1lzabBqaqzMa8V/2INXWiLhcPNeVXsQcPLPVLVp5UWBjit2G/eZyzjFwn0WMMt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2UXI8dSF; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2UXI8dSF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVztH+Jy6n648yHc635QPgGCO8ytNxTBd4fFM4sV+1tiuW/MDQUfHWGsKJyZIDTEDnImCwabpupJ1c9KMIzqRL4/PEusrT8Cc2s2N7aFftkCOBERBlF8crtQ2PccANDvylt2RUXRC6++HaHRj0eAk6Z+n5vsigO4vE7/FmFt3k9jan/2UBro6OcWv9ayDksAf8OAsHYknYWA5kQMimEnQd7+vJ57XU6njA9al785KLbufKZ0W4WHqZc8J/PVPBISbwXXUc4YkTNGv65VJWeAa2hw4SvBqteQHWS6hvK3CAaZG41+ignNmoLn7H33ZSEqv2p4lapjrXKVd8QimUCdEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bg+lRmo4528TFQZYkLc2ANHwbT9qthHCOrQ2tXEygwg=;
 b=T8EZN8CkmyS6+eXnItJtLH4W6cFlpD+2CojYNt/HclI3GNVUXzGx7eUEuMnY0WUG2WqwPRwUB6piPEDIJjyJOCRGx+zBrFUAQRQQGsX2qf14i+tYRCvhWEzvD8tfFhiy/o0Bkqi7iM7zZP4zwKJWya+E9IMFwx3H5cRo+pngASn5qW9JvVPztvfU8+FPQ346lm7O41XJNEcPKJH99wcPUUE1bsYnwOIVppSZzyWI4brqGlkypYatxPHAWy6b04U/pvT9FXi1SUYGPaqNXFBrBZg+L7MqEHhZ/DxqdXDDq8/tXYmA8CExfKLjtYk7m1MuAlSoe2TNW1YLBiNF20QqEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg+lRmo4528TFQZYkLc2ANHwbT9qthHCOrQ2tXEygwg=;
 b=2UXI8dSFd5WYE5CVQdiYKcbPUtDJzQQEaCfQMTuWGf4XLhb9jWpKq8EbjXkdJM6Tk80bNCdYFHUvgR27NL5n6B8q/mRNYBBdRvcvn7Spv8+sS5vrl52QEJ1kd583m87uSaOgUC0XbDnvANhmMI/a7IMAhePpWrXGFTwGxRYOc5U=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by BL1PR12MB5801.namprd12.prod.outlook.com (2603:10b6:208:391::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 11 Jun
 2025 04:23:18 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%3]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 04:23:17 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Rob Herring <robh@kernel.org>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "Botcha, Mounika" <Mounika.Botcha@amd.com>,
	"Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>, "Dhanawade, Mohan"
	<mohan.dhanawade@amd.com>, "Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Topic: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Index: AQHb2Pos9qp4lX7G/0KL13KXwmK5H7P6zyaAgAKPyTA=
Date: Wed, 11 Jun 2025 04:23:17 +0000
Message-ID:
 <DS0PR12MB93451D18D77A48C713E6EE9F9775A@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
 <20250609045110.1786634-2-h.jain@amd.com>
 <20250609131521.GA1700932-robh@kernel.org>
In-Reply-To: <20250609131521.GA1700932-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=60a5d33c-2bdb-45f1-ace1-b0ebfce08cee;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-06-11T04:22:29Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|BL1PR12MB5801:EE_
x-ms-office365-filtering-correlation-id: 9346b58e-f133-49d0-0f96-08dda89fb0cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0YOHsNCN1RAVerCe0uvDhyzaD6x0HwG94+nRrNHwlkseU1464keNb748ZTDm?=
 =?us-ascii?Q?i6szk0l0C3Myz1n2u1w7fY5PHTQMuLmAalz+7t1LbOkx99uzYJ3o5xNkLVJk?=
 =?us-ascii?Q?qZaf0781Cp/X5eESSiZU3yT+mIhGZlBU5T2vx1TSrPC3xHI8a6UUa4XU3n15?=
 =?us-ascii?Q?fBbVfXSepmH26S69e4HuEeJmzHA1wZhw1Hl+L0RcUm9oAEMqXzDS0gC0K6kw?=
 =?us-ascii?Q?AjjQknPETpsbnwOyRp73O2+/hnu4g6T7yE1QGzA/xxYqE1t2cB6EIM7XXeJo?=
 =?us-ascii?Q?iSECMCDiG65PhvehS2pqRpZfJYUP6MnQq9/Qo1uPYqoDLfj5QobRiJftPXb9?=
 =?us-ascii?Q?DjREpcRJ3hQrj5FKUa8vwpAF0NeS8vmosewjaY4ldgSS5FcBbUoaM0o29vhp?=
 =?us-ascii?Q?6Q03YVXMFmY/CpT7HD0BZHoIE2fR2CqlpRfFfqEfYssgTEnncM9zIqOJ1ZfZ?=
 =?us-ascii?Q?0YqmDKGzndROH7La25pD4PrzYdTaif03HNB3WR7OawWpaV6LxlB1wLCdzpwl?=
 =?us-ascii?Q?eK7TcbMy+BzTluJREd6c8vAGasCYoUprvY3vDL74pRTlq1zgrgSOKbsx5Rln?=
 =?us-ascii?Q?MmTdGJcuppK9+6sZDEcCCiGr9osDQycPtDhTa7qL9sQqyEJT8vTvsR8b3y4M?=
 =?us-ascii?Q?pZ4kYTlAgU8MdL5yqEWsXufQY8hkb7joAuaR/qaMsUGfxrge95KvZIneMMMa?=
 =?us-ascii?Q?D3IB6XWr625M0wre988rUgCHiiRy9qPEiGCTlkRYl53ESFApxNTwnKb0YJLT?=
 =?us-ascii?Q?FAa4YunjUIwxIjfjt0OfFY51Orv9l/VrmD35s8JtJX8cbGosiC8Bn7xCJjtH?=
 =?us-ascii?Q?UaEDxOCUDUKOL9b316QnJqQ5Pq5svsi5pdySYm8bv4IB2zsnHjH2xLWQZ+Z3?=
 =?us-ascii?Q?BYzFYOexM5tng1w8AIjPp9d9H6ayUqaxPvSzuATuQ6cwZbw/OMah1OgUgAHX?=
 =?us-ascii?Q?1hBOFem+8Rn8QEuUivjMfGsMPE67eFUu1U0Er+tWzFt2EpUacI/htRGF4BW1?=
 =?us-ascii?Q?weZMQyT3k7X7eA46Eaxv+GCtg2c6bvtEfrfocCkYuwGedu+zoYtdt1SOmFsq?=
 =?us-ascii?Q?OgXw9ph5jxq2RBpg0dHjwgWtmN1WrODa9zINESkGBNIN7O4lOhrjDKWp/U4S?=
 =?us-ascii?Q?X74g9bM7JYia8qetvpofIEqVzj2MXnz/7H+dMP4SHYWoNbCczKGtBI9rHSL2?=
 =?us-ascii?Q?2ZfxZjhtZRmUJMGqBj7F3lI1pJXtd0RbfMWrNuaPE9Lk5EifeUoBISOSi27S?=
 =?us-ascii?Q?wk1HQqV0/FSsqg5AHlkzM7gOOujJ8S1qgizOcW2exwvz5YnZ2kgH5B7Ji021?=
 =?us-ascii?Q?g9tHIkvo/xul0UpJHvJDYPh42kbUa6u3Cwnlow/YpgfZKkGvgWhIWlJ7urKC?=
 =?us-ascii?Q?IwkZeOz/obHH9JNEW2qQ1bqSVITQbuXcgSLvyLmvWBsn/zYeeC7BV5MrhqGa?=
 =?us-ascii?Q?GMF+/xLgwqU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nrxfviNzFuvqUJz4VPoqviW4tjFJH5e57sFrayTk7gTyeIFvSQ5iY1N1ckhX?=
 =?us-ascii?Q?JtapZSDzACaFNr0U0OKQexKzno2Cxis0s8WxFF1kyVbvjxFByerkyddy1bhn?=
 =?us-ascii?Q?q7gBwM5dwnxleYMy7phb6bRvCzCfkBzDzhH5uoJZ+9rZh6t+88DJ+vBmp9GI?=
 =?us-ascii?Q?s/jA+QnOY13NVC78xvuKTFN/kbRiknxdlZGjUVgaBY8tkFZgTwRfTM3xYTFN?=
 =?us-ascii?Q?HajZ3kuKBQgz2ZfvnfbW9U3eoowrousFIUlRrfg5FTjB7yVCmuvStVU4JitQ?=
 =?us-ascii?Q?6slrOwJRN1Uuvot3q3csoXdFguaLuKpf5y7BPf1EO9beEHxOVbhoajGnMZLg?=
 =?us-ascii?Q?tH14vuIujj3w8W1bZDcdYspFu1F2tdu+Ud02UupDj1BXvEtWC00SV3Psw0V8?=
 =?us-ascii?Q?jsXHnqCZRKLVNnJiaQGF1JZXld6hN0fbYg6VaH1hStuBKeSe0/8oBxQ5V01f?=
 =?us-ascii?Q?6c0a744yTTGMHu90pHFzlOuvViVjze+Jf/Avmliu0gXIg/Ewbok2ke1lFuej?=
 =?us-ascii?Q?moX9DIIcRf+bPZKcj8gZU2C0/BUauFjbHHB7YR+l3ok9u1IXMA24c+yAsHK/?=
 =?us-ascii?Q?zQzI+jRdhmueE4Sje2YGs9lGlRGmS0QjuWiUxh16yrMbRFEtQVeJfY0wiqrM?=
 =?us-ascii?Q?lvHpAspBmFTcVjCdKqDpg4wYTvOBWoNJOj5TOCt1553XBVjJQRXjJPLtPwNt?=
 =?us-ascii?Q?fU+2l6fWTkRuXDNcNbowUFlx8jUPcJE0Y0jB2/Vq0vV2HlhYca/9QNpJU4j1?=
 =?us-ascii?Q?SK48gvm/nlyl11nqnXXkvpx76lkcBCSSI6mevrSkCsOB4qwv1Yl1sqX0P/pY?=
 =?us-ascii?Q?v2WCAGMtMiSAbelhjUL5ejXHzhBUFg/U536ZkdY2KUVuNm+y6uefQ9BUFw1d?=
 =?us-ascii?Q?Wk/leTfLOkwLAuy/CRYWO4ebkwXKeNqIPBD/pgW+Z2lkk/zvsjt5gfCVMpte?=
 =?us-ascii?Q?koQrv6F37Mh+NUSsU1NjZYvRQOpirdJ3Ni9l5118LLGY6XbYz2evTj0+Sf+C?=
 =?us-ascii?Q?WsCdymiDh6OPzfWCcacN28ftoDL1kJCgfDM6RrrvRyEjGwQ/eeEvGKKPUT32?=
 =?us-ascii?Q?85oTjd9Sd0MtWynvIAKLnIriUdbM4LhtxKHKlOXCY9Z7GCK721merWeN2lj9?=
 =?us-ascii?Q?HgsYE47tWvp+ReLqucvzaquGp3kt+dm+C8ycdI2Af7yWGhA8XB1P+11blDk5?=
 =?us-ascii?Q?JjqVhzKhOlL5kEGClwHxOKVMr6pr2hSXFrgsdY35a90CFSUfCneEMWWIerbw?=
 =?us-ascii?Q?w+OrBk7Qz/OcswN0cn0XD7yxJC4UjOmD2GfFzqFcotBPdCJsJ4DSROaSwwUV?=
 =?us-ascii?Q?Ec3v9NK0MTClnfEdSZgZ1npa0qDcfeMvM0zao4LG4QS1gVnR1yyyUFPv879B?=
 =?us-ascii?Q?o/qaH9vxVDx7oycskto0bZav4u//BnuijUxAWQCRDpnwegS9Hg1p1sjGnN3z?=
 =?us-ascii?Q?jUNVQDDXHfG1+NDqJM1zy/J178vqPTLna1CRjvj/fFuA7lcsDgMNnJ3EYKl3?=
 =?us-ascii?Q?IgYFyyddJOZLXl1fgU8YsygfK+mgK+Mg45nbq9YXMft4yasHgVn6b04MwfzC?=
 =?us-ascii?Q?OynTxRvSq6iRUSzOF8A=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9346b58e-f133-49d0-0f96-08dda89fb0cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 04:23:17.5369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ME6kxTvRO6hG0aiEWN4/km61xWK+TkWn9l/q17cs9Q9pxsVhunP6nOD7veu8yWmo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5801

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Monday, June 9, 2025 6:45 PM
> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; devicetree@vger.kernel.org; Botcha, Mounika
> <Mounika.Botcha@amd.com>; Savitala, Sarat Chand
> <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
> <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>
> Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random
> Number Generator
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> On Mon, Jun 09, 2025 at 10:21:05AM +0530, Harsh Jain wrote:
> > From: Mounika Botcha <mounika.botcha@amd.com>
> >
> > Add TRNG node compatible string and reg properities.
> >
> > Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
> > Signed-off-by: Harsh Jain <h.jain@amd.com>
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
> > index 000000000000..b6424eeb5966
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> > @@ -0,0 +1,36 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/xlnx,versal-rng.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Xilinx Versal True Random Number Generator Hardware Accelerator
> > +
> > +maintainers:
> > +  - Harsh Jain <h.jain@amd.com>
> > +  - Mounika Botcha <mounika.botcha@amd.com>
> > +
> > +description:
> > +  The Versal True Random Number Generator consists of Ring Oscillators=
 as
> > +  entropy source and a deterministic CTR_DRBG random bit generator (DR=
BG).
> > +
> > +properties:
> > +  compatible:
> > +    const: xlnx,versal-rng
>
> I believe the prior comment was only about the node name. If the block
> is called 'trng' then you should call it that.
>
> And please test your bindings before sending.


Thanks Rob, Will fix and test.

>
> Rob
