Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED28180BF8
	for <linux-crypto@vger.kernel.org>; Thu,  9 May 2024 20:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715285771; cv=fail; b=hlMFZHn47TN1l5QsbTYZVmzVbe0C2V4V8toUumM2PDN5dZmExjqOo/4qybpGVP/n6h74KSVgNCqJIlgDy8jHfUN85TsIkGsTzvIv14K+INRAIRpCNL95f8/28v7smvIH9xBFe1KLsQjJd3zR9ycBp2Yh+fr7D0Z2jIUGbTpqBnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715285771; c=relaxed/simple;
	bh=CwTrVQVCkB4fN8htMTG1klhohUQjRJGYZicvKu26Wgc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cNd3vgC3zFSCOoFUSiafQIcpSjLzr8jEt0vTaklgdw98tw0v1LW5KRSclSpc9AuI/8XbNzs2niojt3EiOEKOqcy0+woK8WUe2N/zOQQMkiYQR2YCrh4mKJEV37BggWxSclK1LPRUnRFiiHnX2PJIwZpmbO25BsfD0d2CHgwubxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=PeHdOZtF; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="PeHdOZtF"
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 449DX4Hn001578;
	Thu, 9 May 2024 19:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=YRof74Ckgnj25gZ39Ldtr8Kw1FH8d+3EHxWrAWA8yjk=;
 b=PeHdOZtFzla5O0CLmqFT5w+JektbLZ71JqU/LLtuzgt3Ku+qXNd82H5LKLpLr+LNISK8
 EmLfzqtXhrO0WPlMUG6bL91pqPGHQhs8LEdkRoDadVJDjvRWY02H+sdcCyamS9C0Ebdm
 J28TRIpV17szMkim7S6wL/XOXFPBlBbCYffFWpgtpp9baPolGY+xm2gk7c6r22IwkjJ5
 NOTYq14Yrm2sTvxMz237bs0RUEeLHnwo7V/gCt7H4jrUq/MOqk/JRAFwwZDbhpzV8UWn
 +wsj2+txFXekNeDXCDz7d1rprd6GNgYXwYvP+hhW6C5WoyZTzw5T3WF4p8bIHh+3lrRY Bg== 
Received: from p1lg14878.it.hpe.com ([16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3y0ucad38p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 May 2024 19:58:41 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id F10DA130DC;
	Thu,  9 May 2024 19:58:39 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 9 May 2024 07:58:28 -1200
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 9 May 2024 07:58:28 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Thu, 9 May 2024 07:58:28 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 9 May 2024 07:58:27 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLflHlmTJy9qpFwyw8t5AUcEo5vQJD0mNVl+TDqKt4+cu+xewnFySDj4ldYMAwhiI2ImmkXmlMMRlrMXChvuPSgT8MNjovqwedgSsYiNiJOmz2YS2F6jg1Ry1RRg7YXPCJZ1pF7JC2EL881rjh/zB+rRguoO0wlXQgkqslVBEz/Fml7fLUkm7z7pCQ0LvDv5bn3yOcO+AXTMtH9akqHTwZbYD+Z/VTUDU2HFdf6rAfLs4TMni4o32bnOOqUmpMJEcPY9AJJDj8iVc6dDlp9/fvrQWPkJ9FtB35hEdaBXKIm6TxvTPDe8sG6u0ZGnv6VGBDuu9iJtBGLXZ8Df2MxejQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRof74Ckgnj25gZ39Ldtr8Kw1FH8d+3EHxWrAWA8yjk=;
 b=ITRiewjeIHORlTAskjHaAc977NFLBKMtVfmlwBU7FC95pP0AWujuXWE9tNuFzUzeIh1iIGoR+8yvEy4HakMuQVbjAKnsqQg1BLwbDV+TEKgYidMOrZkUFJRBNZeQ244189QmR7Qi6/18Oz967T/guUAlUgnbLh0Fz0gLAI8GR58ORhf5kO95QBt23sbdTckR+jEjJjTWTZMtj44babWn9O7N2Qs7NjlT12A3ToodM6sDM4mNzwio4vr9Cv9c0JUXTYtUSexpliUvyQqvMCO+bWneUJNMdue5TIvr5jS+MQ93Tqjc9N4KBaevMaKG7F7m6GkMSrGurwwWoDPG2XciSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by BY1PR84MB3953.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:4b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Thu, 9 May
 2024 19:58:23 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::4da6:9972:feeb:2ad7]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::4da6:9972:feeb:2ad7%6]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 19:58:23 +0000
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
To: Sergey Portnoy <sergey.portnoy@intel.com>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "qat-linux@intel.com" <qat-linux@intel.com>
Subject: RE: [PATCH] crypto: tcrypt - add skcipher speed for given alg
Thread-Topic: [PATCH] crypto: tcrypt - add skcipher speed for given alg
Thread-Index: AQHaof0Xe/RFI8D1nUuFu7qbncfH47GPTHNw
Date: Thu, 9 May 2024 19:58:23 +0000
Message-ID: <MW5PR84MB1842E5564DD90B9599AFD5E2ABE62@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20240509113703.578583-1-sergey.portnoy@intel.com>
In-Reply-To: <20240509113703.578583-1-sergey.portnoy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|BY1PR84MB3953:EE_
x-ms-office365-filtering-correlation-id: e003afa4-1843-47ba-92a7-08dc7062622a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?3AFAjx9FP7q738lAmsl/DFDUKLXlEBxfTYv7ugAvMVCVn6k3dY7KmmNLV5Qk?=
 =?us-ascii?Q?SvTagvX/88SLFZzmA0BI00rl8pjm9Tr6x5GZdBYV5NYU3IqoeCqkDX3vto/e?=
 =?us-ascii?Q?QoDL0J6JwtEj+QAdK1Q0vLvcor3jCvkIUMXgaeF8QkURp6C9DFWHfnGI4le7?=
 =?us-ascii?Q?WlflRXzBLADZm21DtiZmdgxlOtzR/HPE16pR4zxZmSRsF00Dbn4WL6WssiHn?=
 =?us-ascii?Q?9ySRab7lKHki1CqFQVyDwt1jNBMH+Y/2fmU/3zZwMqoTs1JO85lbDI4tWcvB?=
 =?us-ascii?Q?3R1Q72Lay/O6LEX6p9cH4QVv7v/+f4qQQlb8yxH9UmIATMLiYFmANnJG31Ss?=
 =?us-ascii?Q?flK2KqGqJscxKhru5rNiS7+6JrSiSbwl/iZ9Z1x7NP0XvJl1M3abq0NwsUfD?=
 =?us-ascii?Q?ROcyFlwlcRiUC/LTolPZTzPfEcWerLrZex4ZHGf0Je92qhyvxjaT94II6w23?=
 =?us-ascii?Q?5o7z6eSGm4GjhvhLUarj4R0NTu1b8mhnwSRBpru92GYaBEeZc1Qa2zMfuJ/M?=
 =?us-ascii?Q?DNLSkcG61/cZHJ1HPuiBxvt1ShxvhM8LT6h7mxu9f8/Q/5+gmm3sT1PjT7T9?=
 =?us-ascii?Q?drZMoEXg71yRjW5rX64P+uAXb2MjFUFFTPpp4EHY29IqGgKndqlIEwuLuRBr?=
 =?us-ascii?Q?+QTYWGbWVhGcwwCq+TBMKM4CoL0JqLTG/5e9NoMVOHWi6zdk88T7HO1cBu6J?=
 =?us-ascii?Q?KLs+Ddn+qjK4Ls+2zqP72JsvPx64SHd5SRm60QCrqpAku1ITnQiepU/2k8XB?=
 =?us-ascii?Q?N5eA7T2x/ST26djRhCiZVVpEZBhTRnOO3LpdtnsCdGzp4TDLYP86qSd1f+rG?=
 =?us-ascii?Q?hc3x8yNfrOBihnVyM/5vCXONRTXGHmvS926cQ+bW8Jj7LHrYKuucMOv00Mqx?=
 =?us-ascii?Q?cWtwbtKK8pDp9Lu/vK5TuAIP3sN18SfqdTZFZLD/toFM1tazAii+eSOBEYQJ?=
 =?us-ascii?Q?U2TIJ1kF1PEOQd+aTfD5CMEMxVX1QNiL0Of/qFR64GF733WZ7wnSjUDKEMyv?=
 =?us-ascii?Q?zkKc1bO4gT0TJP4Emq6CJC9v5Urn/t3+3FlcL5VwLMTF8aVlqCG1Zws+/BH/?=
 =?us-ascii?Q?fQ+R0diI/BV2JpRVBsXeI3FKtRWZB8e81pQI9NMCo7tF2s7Qa3PJhup9zl1v?=
 =?us-ascii?Q?nVDdrDFyjKJw6kjh39NA29mYNq7m5gSX7RCDOSePSlKkXQ8XFEqAI3mqPhjD?=
 =?us-ascii?Q?RbIf6I8DtdC8T9ywi0leGhTU9yYkMUNvUiaR5d8YaGcyXO8KjBpnSaltTOF9?=
 =?us-ascii?Q?2RMV1EehAkxdsXG49vlwHGOgaYW6Vih3TlBFA7T7zYwgJy8CjZbJaKK8ez8/?=
 =?us-ascii?Q?XZPvL5oiIIBVvzwCnTKRtkkSm90AGNzT3tEwzinrHupO6Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vMrzpGUfCfrH85fFFpRGCIUgR3wu7H48vOqFFuWvs72b2KA6yyVAz8M4JC2U?=
 =?us-ascii?Q?vHvS/6g7mTKsXMS022i8YsrGXpK9D101Dnb2By4iWoqzeqdRB/YI4QsSB2ct?=
 =?us-ascii?Q?8XKCHIaVztLsxJWZY2XrWhxOnKBwwgygLmALs2UMsqEMUzb0SEd9n6JzGL1m?=
 =?us-ascii?Q?xVWYaHxfPd0F76o9YmgOzEYB0S6KiHJSMBQhroXxtDIqumoAhOiJTaxnmMLz?=
 =?us-ascii?Q?5xQ/d7E1YGmZQfVs5ayCOgZGjnfSpCp6VnJ9qn+pCPklIXF+LXHFdHtLfcoA?=
 =?us-ascii?Q?+I0PR/s+jDdO3gIV/AFcC9EeMOhtru0CFNc4YnKzz+55qC3///HrUCAzeqD6?=
 =?us-ascii?Q?eF95tL9CuVmuuOoWc3IC7UODaK4GTFsJVnle9abnsIxBF53XA0r6ow7zj3tB?=
 =?us-ascii?Q?Fj0UFWIRfSQL8mlXm/8RxWU1rS0JZPpcaoxfME4M8tavuLDZUDUbYpqArfg1?=
 =?us-ascii?Q?uaWlC/BSs9NtDNdJWN9kJkrA243OWaD19Vdcyp7WJatiKKwBcWIPBEnp8C+t?=
 =?us-ascii?Q?AlJDsv3u/e2YP6PQx1BpgoXsEpreCBmBd6Z5AEZWKRO/Lck+Tyxl1HBCaADs?=
 =?us-ascii?Q?tViSQPGgzM+tQRU/5+LE4AOGstnBOmtSA3WaKBMi1BCUpneP0zd3n70H2zdo?=
 =?us-ascii?Q?OLx/QkbX9ZvDVHPEdZSn3Ohwfqw+BSzER7loRTVHc6iBWILDVMP6jEoLALKO?=
 =?us-ascii?Q?dHoOkeok/rFQEauc7yGKPpS8KesxE4cTO+t4Ry7Gs1UVps6OCB5D7TrCme6b?=
 =?us-ascii?Q?Ima04n4WPtk0fz8NUI0POwbH9+F/KtCu466YYWhbCqBhoFDqdFMVQrfFMf4z?=
 =?us-ascii?Q?PBxW082fWnHWoezL4cxb5qKCnv6xQHdJqZZagzMFMSyvBSnFfskVaUsTPJPV?=
 =?us-ascii?Q?nzueL2bxioirMA0QLngsmauooPv5UYbaJhRInCrcMzyDVwSXo3GNuF70z3t2?=
 =?us-ascii?Q?yLFu2Y35SIGSrWXTee/C8d+ZF7TJ8KdFZxwIH9DfmMakc8+HPDX469DC1N+c?=
 =?us-ascii?Q?ALMN8Vy9EpfRXEAUQnHPzybsaNXulEQAHJ7fCcMDnOBueXmKfcpAUEKh2Djo?=
 =?us-ascii?Q?Xd40DepLaAWIik2AXPizTlSwukfiniXsnS5hzlZBzoyNZkYhHuHt+M0gDBus?=
 =?us-ascii?Q?D0vbXH/oTFlSLoc0bHgilTvWbNuPCOTEDpXvwLat+89rYV5rP3vqYiCzCASz?=
 =?us-ascii?Q?QGseQGQSJaep4x7/RML99kIvb2VoVKegNeKNJFSs7J54huZQHDVt0Ai5MZfO?=
 =?us-ascii?Q?j8rRuSfw536IHN9C59kicirSUSWOKCn8sGfKvtuE72LDT856aaV/P8b/RLcV?=
 =?us-ascii?Q?Z4Hi+/4ETGk/WkbrslV4q3YF1xrSA1+VUGmI9sz/HiRdrcVC5aNWmN/mbcwC?=
 =?us-ascii?Q?QKTyshkzFjL9xMSgCREhzPh9YF6wb5ws6B4g4FatWBILAA7x3DrRQz3mvY3z?=
 =?us-ascii?Q?d1LavHXZbj13nMTDj52OAG+FH27m/YJTCiHLUZly0J/GAQAAEZ3vwaNn4iXh?=
 =?us-ascii?Q?huCnguaryvvK30JeND0hq/Z1o0PRirWS2PB3RpV1A00FcN9XTnMGnVtshzX/?=
 =?us-ascii?Q?egbu/O3gtGKLgPaiUAg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e003afa4-1843-47ba-92a7-08dc7062622a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2024 19:58:23.5549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9kKooe0NYIvR11opiVVWrBviKoCnSk8rEpd6YflkoJ1gj4kU8jyHL2A1rReDWtOO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR84MB3953
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: vYbLnB7HWL0B0yEdBiO63YO_z82gzC4q
X-Proofpoint-ORIG-GUID: vYbLnB7HWL0B0yEdBiO63YO_z82gzC4q
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-09_11,2024-05-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405090140



> -----Original Message-----
> From: Sergey Portnoy <sergey.portnoy@intel.com>
> Sent: Thursday, May 9, 2024 6:36 AM
> To: herbert@gondor.apana.org.au
> Cc: linux-crypto@vger.kernel.org; qat-linux@intel.com
> Subject: [PATCH] crypto: tcrypt - add skcipher speed for given alg
>=20
> Allow to run skcipher speed for given algorithm.
> Two separate cases are added to cover ENCRYPT and DECRYPT
> directions.
>=20
> Example:
>    modprobe tcrypt mode=3D611 alg=3D"qat_aes_xts" klen=3D32
>=20
> If succeed, the performance numbers will be printed in dmesg:
>    testing speed of multibuffer qat_aes_xts (qat_aes_xts) encryption
>    test 0 (256 bit key, 16 byte blocks): 1 operation in 14596 cycles (16
> bytes)
>    ...
>    test 6 (256 bit key, 4096 byte blocks): 1 operation in 8053 cycles
> (4096 bytes)
>=20
> Signed-off-by: Sergey Portnoy <sergey.portnoy@intel.com>
> ---
>  crypto/tcrypt.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 8aea416f6480..73bea38c8112 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -68,6 +68,7 @@ static int mode;
>  static u32 num_mb =3D 8;
>  static unsigned int klen;
>  static char *tvmem[TVMEMSIZE];
> +static char speed_template[2];

u8 would better match the source:
    static unsigned int klen;
    module_param(klen, uint, 0);
    MODULE_PARM_DESC(klen, "Key length (defaults to 0)");

and use as the keysize argument in:
    static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
                                   struct cipher_speed_template *template,
                                   unsigned int tcount, u8 *keysize, u32 nu=
m_mb)

and the other constant speed test arrays like:
    static u8 speed_template_8[] =3D {8, 0};
    static u8 speed_template_16[] =3D {16, 0};
    static u8 speed_template_24[] =3D {24, 0};

...
> +	case 611:
> +		speed_template[0] =3D klen;
> +		if (alg)
> +			test_mb_skcipher_speed(alg, ENCRYPT, sec, NULL, 0,
> +					       speed_template, num_mb);
> +		break;
> +	case 612:
> +		speed_template[0] =3D klen;
> +		if (alg)
> +			test_mb_skcipher_speed(alg, DECRYPT, sec, NULL, 0,
> +					       speed_template, num_mb);
> +		break;

Since it's only two bytes, perhaps it should just be an on-stack variable
inside each of those if blocks, not a file-scope variable.


