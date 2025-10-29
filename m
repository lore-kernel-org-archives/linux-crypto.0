Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899EE285C9D;
	Wed, 29 Oct 2025 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761757780; cv=fail; b=O1y5QDkD/JjvxJcdvjJ3075f3/9l5bgx7xZP41n6GVlOo7HydxQ3HnuG4XreaRKTHbHnVQpKKmiXK5c2ekrKBr2zdXRUTwGFQGXDuJzqLhZCZmoxW/aliMs43VlRQcUi8sjD4ThtXGWa1g+SS5UrEwtcwBsRMRD4dt9wku+EuC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761757780; c=relaxed/simple;
	bh=dQcodeo3Q5tfYTFKR6ip2aRTpaXFuZUs2SilLNdpZXA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AYl0zQKyAIERBpiT3qboXyTci06x28xd3IlFPaAcTLUb2Nxb4fV3lQu5pJ/sdg5QS2oftycDqBhSbl++P8OQrYbI4k+tQMChgU49JBU9TpHQaYJSn1jse4Px29VwvWhggcnJ42bVql4aqXQXxuilkvi7zms90XpINBzDAy/fr9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=IpIC+ygc; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="IpIC+ygc"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59TGHJWO106507;
	Wed, 29 Oct 2025 10:09:31 -0700
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020073.outbound.protection.outlook.com [52.101.46.73])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a3paj087k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:09:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvSYk5vvPwohdKQ9Wymx0KWhSIPfkvVr7fVUL3tuWT45P7oJh+O69Ju8gbcrh1bujA835ohVVZ0h1uC4xIMdo0yqvY+S13aPtwlUkAReHNvXdt+i4MXUKQOHTnhVM+FA6OzG36A0RaKYGNOX/vG1EOxIdpvbpyMf77rEk01qAk6UDSWYMy71G0bzqq5h26gihPUFv9g5dL0RDosffoV9ovn0D6D0DFCWYo92SV9ND/yGi2HMqUqqkHT+8y2doIecMbcRq0eRCaoZOB8t+LZhoYCqrCyHsNL/OQuzIDIkfebRs5QYrS/B1nBneXDoVFG2YpMdjmtbXTP4ltPPJTO5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tf3ZfWs5pTt8+0gdkRt7ucV0gMPm1aNDNxXYsBm3aKI=;
 b=qIIiFypruptiiAIk+CPLKJ765F+uEz+WYA3wrobIRnUqKo467FSnXpskoKz6ixwu1SJVkeKijNTLvlOkO0XEZ9PYZG2k7BIl4166Bz7X8yLuGP50MZ4zAC6IAJchSX7agOXed1MfWXlzyeEOFYAUTg29D9WlWUg61NQzUZIRHyrbJvPeV1RCoX3LqCwHlL65/9D/TUwUV12MCMHdWFOz9ZXrRBiI6iTza7q7VtalC2Nbb5rcoBOgwbf/JCxgGVdiF+GWF0NHomVTo+79V4uufj6HQqVwvheVkQZsKfQoeipc7EvT9zfvKOJcJDt0s5L3hP1nygLoeC1Thx8JbQzimQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tf3ZfWs5pTt8+0gdkRt7ucV0gMPm1aNDNxXYsBm3aKI=;
 b=IpIC+ygcFg2n4zPsdY5ctNbyA9f5YOTEPbN28p6qLXZdDxc+PYZ2YthmWYzm6TiKCWIsZ0TXAia3TR/9n4mE4MEWL8yzBrf8WobXkIvL2nmaqu5JJMH6CuNomlqVAhgQLN+CzIAZCBJG1jFHYV6DSa+fY8hO25GcT/esVneO5sw=
Received: from IA2PR18MB5885.namprd18.prod.outlook.com (2603:10b6:208:4af::11)
 by PH5PR18MB927675.namprd18.prod.outlook.com (2603:10b6:510:39c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 17:09:28 +0000
Received: from IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231]) by IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231%5]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 17:09:28 +0000
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
	<netdev@vger.kernel.org>,
        Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [PATCH net-next v5 05/15] octeontx2-af: Add support for CPT
 second pass
Thread-Topic: [PATCH net-next v5 05/15] octeontx2-af: Add support for CPT
 second pass
Thread-Index: AQHcSPbIlknt/avvzkWdocKYLpuU1w==
Date: Wed, 29 Oct 2025 17:09:28 +0000
Message-ID:
 <IA2PR18MB58852FD7DD14B7E7F4FA7035D6FAA@IA2PR18MB5885.namprd18.prod.outlook.com>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-6-tanmay@marvell.com>
 <aQCj2iRMRR8pFhhQ@horms.kernel.org>
In-Reply-To: <aQCj2iRMRR8pFhhQ@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA2PR18MB5885:EE_|PH5PR18MB927675:EE_
x-ms-office365-filtering-correlation-id: e8382524-5f24-41c9-dd42-08de170deb35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?RIM44fFTIrGz55G0VHHk7nS25uTD3+Ekch2ep01U4j6RmEc+j2GWJUAaWP?=
 =?iso-8859-1?Q?eGicAtZ/y9H4tqwoDKR2LXV8uXtAjy3Io5bXQ3f6IhjJIp6hvTCD84QWb7?=
 =?iso-8859-1?Q?ASF7kvBS7sOei5rhfC7z3+qZ5U1fRG/vEySu+9dr/gwx0vurgQGs1SPnnr?=
 =?iso-8859-1?Q?gRXpXXQQu45gpMTIJ2umOSOKHTfV9o3vX6UrNXKFdwftx6WEAD4JCIMyuY?=
 =?iso-8859-1?Q?tYw12hzeXxLF/eFBWfHxTirT1RfmaFKU4yQwLOs0RG8J/i/N2cJyLqRerP?=
 =?iso-8859-1?Q?zoHsADNF5YmudEFN01dGPxwZK+ZPupy0ZOVpWil845LvWCEVb6TLRaFXsK?=
 =?iso-8859-1?Q?Dyz+3fM0hlVhQiFbCsAPy6nopPKqPngOFA2PaM6FZ68JIUprL5lXm2r81v?=
 =?iso-8859-1?Q?PlGGKkK6Q/ZYs2BFOn7dvURX/C3Oo4MfybKf8Nu+0NB2K9Dd+yrs+L5V4t?=
 =?iso-8859-1?Q?3zSUwo35gYjKI4553oJrxyqwqVSSCwlm5/APAUpz2y4vTW4R3jdEbFUc0A?=
 =?iso-8859-1?Q?TJrv6+R2FzAJP0b3aiFgCIp8EfofjmY4c3u1dPQe3NDOodq1e85WIzCOim?=
 =?iso-8859-1?Q?rnWT0y6J967jAeWYlRjQmfCWf59VepaXQDIok69+zLjlzGX+ga79R8BRfl?=
 =?iso-8859-1?Q?R1cn16sGdhDVhkVHhVwNsqGgGgSxx0y8TxmRURWzcW4A82HEY5jJulSIM6?=
 =?iso-8859-1?Q?miJiKUXrVirtW+ibpITRmQygyvANrEMzEZhABeEg+x2HN9YagZoCCcmHh2?=
 =?iso-8859-1?Q?cuv4QFGppC5c294Wfe0J5FDkxsxxrSunTgj7oeEEAV6QVguCggDxMZPx+C?=
 =?iso-8859-1?Q?X2kZVHjydoi25nz/8kTAa0JUy27h+raZYukP5B+ww1m5i5jnNsTTbyAP5k?=
 =?iso-8859-1?Q?ya21alVDMfmzypISmJEJRDdDU65Iupf1bLFrs+LeOuUa0B++zElbDIkv/2?=
 =?iso-8859-1?Q?+DS8oGdCVofVMHxsCG/0eUHL0G9bGIvzSYqUzOtI4Sf94f6HkRqrJWZa5r?=
 =?iso-8859-1?Q?PHPtdXNH2nUSdGYSuSBwTsCP/SSgmneCLl+9AH0a+VAnLg1LUIbKe90xLG?=
 =?iso-8859-1?Q?ME1xe0+DQ+sb9KTc8eNjdq/iKIvPHnBW2+bzdJexZeDlOG3FmZs+tOYAkJ?=
 =?iso-8859-1?Q?R1dOJIG61md0vsewUmkCV+1V97Ughr8Og8p4WC0rro2+X18MhnhjSgT5Zi?=
 =?iso-8859-1?Q?rdG+WBOs/xHFsqUSalH5GOedGP+CMHum9StUYBYbd+lwspnUUoy0zHAzRM?=
 =?iso-8859-1?Q?IlP0M8Bz4nqKQWd5aheM6Emee9g8MD9sYRNNyJ96QaUOVRDqvQuWg+HUHe?=
 =?iso-8859-1?Q?y0YdEkOqgfgMiiwMl5fqq8ffJIQAuuUlatdnoL3M4Zov/VuKuOgyQ3Ondx?=
 =?iso-8859-1?Q?tgsNms3QSIXBqDVf/wcgpxSWYS0yjZVYvg0dMwztsMoYiYcQ8onj3sGz0j?=
 =?iso-8859-1?Q?j1R0fgBr/Ilbf4VaKunOFQqFdst0iI/RNj4ERFCL2lbp9JlX2JBiOk9Vvg?=
 =?iso-8859-1?Q?86lA8W2Xe69sDLVVNAyXoLjk5RKWQU4ty4TukTfjCcp05l0h94gpfwfK4g?=
 =?iso-8859-1?Q?EEUPNqINdP6Pq7CB7iJAPzIN7FDg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA2PR18MB5885.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?s6pukmLqfgoqtyh+rFMTBY8SQTfn/szSJUfRAwqTQ7X08ZOFrbrJb5ngBY?=
 =?iso-8859-1?Q?fF4n3in6Of3zN/6FeXB8MsxLzvqTanLVa9ZPDb+lG80md70kOQT1aR3fO8?=
 =?iso-8859-1?Q?3SuGDASNgzFklV2WUn/hReIQWvOYDL5o2vssqwQpTuPuHnZc4/JOBA0Ssa?=
 =?iso-8859-1?Q?StZwO9RJDCGoEWS/cbZ9ZfcpBuSIfhfro8WShPo5kR9i29Ea8KS0UhbMvV?=
 =?iso-8859-1?Q?ANXrldvfMMAFB/pQcWXSDkE8m0uzwn9drKEJOYtZYh2IeybaKRjtkdkOwz?=
 =?iso-8859-1?Q?fnik2UfIj68bRTEvJLuA9D+i+x00leAkILqkBAsz3wGbEWbwN89QCcfuwT?=
 =?iso-8859-1?Q?0wHplBQs3WwoLeJUNfQOLsD1dBjZ62gLHAEr7IsOTNjBQ1WhTSVhKhwcJY?=
 =?iso-8859-1?Q?7wdjv0LCFEit3HdkUQHq6fbuPhYCUgj6rMV44O+NoiC5UGK0uxvS4YsrM5?=
 =?iso-8859-1?Q?3YvZn8tNHbjDPqAXIamAxNMe8GNIiXgDxElv9tCSUcSBH5sAznwyX4uW6B?=
 =?iso-8859-1?Q?2LwZ07eGxf2hgwWi7X+GNtldxK6+Opiog59Gq1Q7jw9Zs/DIYE4Rd91eLK?=
 =?iso-8859-1?Q?U89ZNPWn9842phdUOb042nEt1t2CeGYSv+BdDy78JBLmaoRH+S4AgGQSKb?=
 =?iso-8859-1?Q?DPK0EEO7axDyM7sFhcV3FzNOjCMnQ58VbNp7a9R13zIJdPKb5SuM/G03XX?=
 =?iso-8859-1?Q?OfvqySTXCyOpwX6r8EaNTPIbv1GKEKYoGa7qXRp0nt1cI4UgIlXuFaNE1o?=
 =?iso-8859-1?Q?spirGuk45R0ZRqQXkC3GCXJt1lwbOmgJ/6xYhS9OAyUAAaxSQF2U4RLBIX?=
 =?iso-8859-1?Q?Iw8nBGcTYQVSuzOanKB1Qc/MjqpX0hq6z5fyNAy2A8ix4Da1vKU79w+8Q3?=
 =?iso-8859-1?Q?GMEHMeUtXw2033MwsAolUxoKFHS6BsIf+aimAKi+x8lYZ2ptX2j8qnaeMJ?=
 =?iso-8859-1?Q?j1MVGQH+v0Wb2yRNaJM/t+CuVJbMT3Uz+xyzrKwAawQy74FKIn3z6GhsIL?=
 =?iso-8859-1?Q?VA5LG9sRQje7NVLhY3vUFsLZq5qBoK10OTehTxgyTtyY8BgnFevM3X3L5M?=
 =?iso-8859-1?Q?644etk8idiGO/pih3SDIqTrJ3p6+G7rwK1G73j/BR4QVmE+4nirv41ycOq?=
 =?iso-8859-1?Q?9XXp1mW4EM/UUCqpkM8OmrHLZ8+Ng9/Jhz+Rhd5IW3keKxPsucX7cvBDnh?=
 =?iso-8859-1?Q?70ZVvrePWu+RBSAos22JZR8JLSowKGzKyE6wveOznAkJfRQRoDLeEWMPjg?=
 =?iso-8859-1?Q?lHn1l/KJ75F2nyqbdh54rcze2pqaikVUam86LzHWyT+8NYA4NDqTr0id0P?=
 =?iso-8859-1?Q?XzQGO7OOfx7vERsx08Su2aQrqpSuar0zoND+MQXrqnEgF32wQIGncpYhzY?=
 =?iso-8859-1?Q?+Ztj0RjhSdAN2GJFEqn/H1SonAIT3dkn6fdbYirZf4FUQLqCky9C/zNf0v?=
 =?iso-8859-1?Q?kZfp4rzIkvArIsoV0sGc6OmPo5SlEnyI1c+VCedzjoun3+vbL6pXbXlNDm?=
 =?iso-8859-1?Q?ldVGChLnc/s5+nf0Yuz8q111AZXPdTw7iF9TlnFH3VsRN7o5KUJwa7Prj/?=
 =?iso-8859-1?Q?sicJVs7nCtJU08ovntmN4soscSRhPHGS3zekKF6DTWUNmCtRtuMfJt2R+t?=
 =?iso-8859-1?Q?ZIf8jTG0Pt99k=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e8382524-5f24-41c9-dd42-08de170deb35
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 17:09:28.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Drr/2smIKHzX97fdZWfXK1N5nmpyv3ZGe2H1GxpDIG46iJCpRGd4Lspk3Jtyr1OzrDVPnhroT6H/Zfb+X1ujHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR18MB927675
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDEzNiBTYWx0ZWRfX3kNKuvJL7V95
 PuY+uye8EU/lsb4ssufPnucPiz+h9lawmZQKOhIhOVf0gZr5sooCoCcy1y0eCVeLAKcYj++d3gs
 58TqqpyLpxkAfIQ9iULpf060WqfBzNcReEoSjmcEsYb1pv5cP46OfcuihqfFUvSKXcZP3VFtDeW
 38V1503V670O9//9uMNkGVBJ5QdH+dhYXDwBRs8n6My7XIPFeZAYpfKYueRxRghPZqjDGNLrAPf
 14H+rHL4QIgxm92cjDVyQL17MJa9LswEkiRYLD/A26ZK+mz9WkCLlYu7K+oH0bNlykuKOcAmY+t
 oTPYemCuord/6+oeOGQnFzgNBHObENYhkHSnVdAxmbbCNaqiZ6oiBN/Na8bthCsG/4uVFMNRo8L
 uzLJfhGruRz8RwWA+nN3f1fEVThB5A==
X-Proofpoint-GUID: 5sXXqkQmJXl1FlwzqewI2xVTzhn7-uEy
X-Proofpoint-ORIG-GUID: 5sXXqkQmJXl1FlwzqewI2xVTzhn7-uEy
X-Authority-Analysis: v=2.4 cv=CcEFJbrl c=1 sm=1 tr=0 ts=69024a4b cx=c_pps
 a=NUMs+PEU/Pz2DPnLQvFO8g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=TvGtCUiG8l8sLAelDMYA:9 a=wPNLvfGTeEIA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01

Hi Simon,=0A=
=0A=
>> From: Rakesh Kudurumalla <rkudurumalla@marvell.com>=0A=
>> =0A=
>> Implemented mailbox to add mechanism to allocate a=0A=
>> rq_mask and apply to nixlf to toggle RQ context fields=0A=
>> for CPT second pass packets.=0A=
>> =0A=
>> Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>=0A=
>> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>=0A=
>=0A=
> ...=0A=
>=0A=
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drive=
rs/net/ethernet/marvell/octeontx2/af/rvu_nix.c=0A=
>> index c3d6f363bf61..95f93a29a00e 100644=0A=
>> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c=0A=
>> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c=0A=
>> @@ -6632,3 +6632,128 @@ void rvu_block_bcast_xon(struct rvu *rvu, int bl=
kaddr)=0A=
>> =A0	cfg =3D rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0));=0A=
>> =A0	rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0), cfg);=0A=
>> =A0}=0A=
>> +=0A=
>> +static inline void=0A=
>> +configure_rq_mask(struct rvu *rvu, int blkaddr, int nixlf,=0A=
>> +		 =A0u8 rq_mask, bool enable)=0A=
>=0A=
> Hi Rakesh and Tanmay,=0A=
>=0A=
> Please don't use inline in C files unless there is a demonstrable - usual=
ly=0A=
> performance - reason to do so. =A0Rather, please let the compiler inline =
code=0A=
> as it sees fit.=0A=
ACK. Will drop the inline in the next version.=0A=
=0A=
>> +{=0A=
>> +	u64 cfg, reg;=0A=
>> +=0A=
>> +	cfg =3D rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));=0A=
>> +	reg =3D rvu_read64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf));=0A=
>> +	if (enable) {=0A=
>> +		cfg |=3D NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;=0A=
>> +		reg &=3D ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;=0A=
>> +		reg |=3D FIELD_PREP(NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL, rq_mask);=0A=
>> +	} else {=0A=
>> +		cfg &=3D ~NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;=0A=
>> +		reg &=3D ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;=0A=
>> +	}=0A=
>> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);=0A=
>> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf), reg);=0A=
>> +}=0A=
>> +=0A=
>> +static inline void=0A=
>> +configure_spb_cpt(struct rvu *rvu, int blkaddr, int nixlf,=0A=
>> +		 =A0struct nix_rq_cpt_field_mask_cfg_req *req, bool enable)=0A=
>=0A=
> Here too.=0A=
ACK.=0A=
=0A=
=0A=
>> +{=0A=
>> +	u64 cfg;=0A=
>> +=0A=
>> +	cfg =3D rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));=0A=
>> +=0A=
>> +	/* Clear the SPB bit fields */=0A=
>> +	cfg &=3D ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;=0A=
>> +	cfg &=3D ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1;=0A=
>> +	cfg &=3D ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA;=0A=
>> +=0A=
>> +	if (enable) {=0A=
>> +		cfg |=3D NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;=0A=
>> +		cfg |=3D FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1,=0A=
>> +				 =A0req->ipsec_cfg1.spb_cpt_sizem1);=0A=
>> +		cfg |=3D FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA,=0A=
>> +				 =A0req->ipsec_cfg1.spb_cpt_aura);=0A=
>> +	}=0A=
>> +=0A=
>> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);=0A=
>> +}=0A=
=0A=
Thanks,=0A=
Tanmay=0A=
...=0A=
