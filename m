Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794065217;
	b=RziyXSBfnUghDufPe0cc+HBKiA5eUp1PQ3/HM9vExHEVUXnAyAaJgfCzRn038SDlQRFY
	 ZzTqhmbpKzCiKZCluXCviCnqb9iJAQRVEodq/swmWKf3s6wnCpbytVGmVYC4I4jobqJ5r
	 7L7T60AAkAr7D8OwDPR3Ipx/UXWyhYK4ZrPTFtAcybGQ3tPWV91ClIp6Jkxhy2fdPF5jB
	 RoBKDy3Yv83CeJUAwBP3GGp3Elk8cRs4KC2llmG6/0BinTMNYE/aRHG47FkcP3k53Batv
	 s9yE7HfRQ70vux7f0YR+6P4O/aD91zAWvTkmOJYjosx6mpJfLhc/GRlTjgazlsCn6CQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065217;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ld-processed:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=2deUNfJerIJNqJ8zrVPeeVWuZNCxRJZp7zIF6j2Dxzo=;
	b=oLFGOQyybZKZNcO2Qf+l04e5bJuHUVkVaXg0lZp5mFNaNT/BrLGVacOPt04DGL6HTQNd
	 Vp21hJkZqnUQhsfFqQfpdHAb40VRSIhcJdDDHvTDY/5nVywMmmKchY6kcu8v/oy/F90xc
	 BKijz3xxW6l+jAY8DwvMpQz4qHaC8D67kmMUmyH8XK8oZCyKHD+KfnLg06RMKfpbvBPev
	 Cb+DhUsOZYdrgv3mm5/qNC+LmNVAgSosbyANuyEwlVr9fBFmwaZn1FnXU+IpM8oG8f6VS
	 MMfLmzhTLw5CNjG4XFYkg7QW0qryFBWVPEPL9gklMeBN12cjmvJ5Erw1bkl4GndJFsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=PJSh5YZO;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Li1A6kH4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE19A606A339;
	Sat,  7 Nov 2026 15:26:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE19A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=PJSh5YZO;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Li1A6kH4
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Extml2334848;
	Sat, 7 Nov 2026 09:26:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=2deUNfJerIJNqJ8zrVPeeVWuZNCxRJZp7zIF6j2Dx
	zo=; b=PJSh5YZOY1RAKivSv6QsQGTfHTkh7uB0kItoi+Myx+Wo0KYK9MhvXk5Cl
	NPlAJM87MA5F1kuqjWs9PbR1RA23Ew94ThGKt5MPJo7aFWEsi75IbZKDd5q63dRD
	cQPEEyGufw0z637U3o0avIbNe4kPifl2mjc923Xy2eKBz9xXL5v8D71lmhkM6myA
	XF3QHPfG9rGJZQOguOlFrxJ3qBkuvnn2E3viy6M5ckt4VAwXiNiMoiGWOR9nyfUQ
	KnmC62aaqolXNKGuVv/7hOO74taaJj7r4mZYmZm1BlZPvU6P7Dn1cxxl0Du8tzbG
	GGWhoo/hITImLzFZBIoNLl5l5ehvg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy894-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 09:26:53 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vM8qayT5ip6qklOA6O7pw+ATGSUroNbRRtwBK1UC7ZN5iAA+cvgTu+ynFMqVMgYMkU5c764KawYlsLoBwNUGxl0Cr8ZJoHcT5m3kAQhe4S9R7DH9ehfkK8n79y9L1Rm6nKVQZgn5iMFx6kPPulo+WXX3JwMGziNnJslDXgjvBI0UlTlz18sDHhuL1YSxkqdjRWseOiOUm95iwSNAMzFve0Z7H71k+2TwLK3GWvkMGdTuIsl/vl456SiE9K7vvFHD0QqIWq5CtOisobVYEgPcgVEO5EQyZ8thDKsy779Z/oqneMAApvsIis3tNPkldU2/uASazRpccxWrembtRAJSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2deUNfJerIJNqJ8zrVPeeVWuZNCxRJZp7zIF6j2Dxzo=;
 b=S1jtutulRkufNmBJgAVvk/ZrxYkyZUbC2fowlAxxJLV0riTV6pFu7dF6ty/bhrzzgasTIsfHcYuRm+lbd8R4r8ryzGFypLdKWzXVvfUvV9mK1tbRqX48hIKLonFgGiUHDbmn+VozbSVXUoI8i2JEa38BN/OoJavZy6BNOuBHCQi/TPh7O34ZCTwo0PFYTFYgpTfkT6yCBSgXqG6kTDlJ3QxLGsKt/XMbO1EPAYD826168YvfSeWB4Wcw/iRHOvqOpeaS8WMJjUP9+zo7EM+1cx+RJaHqMGjATULR4jSBayaO2U9dGl+GY4s5xvIiu5QWACSCAdJc0rX+SWWF1Pcvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ti.com; dmarc=pass action=none header.from=ti.com; dkim=pass
 header.d=ti.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2deUNfJerIJNqJ8zrVPeeVWuZNCxRJZp7zIF6j2Dxzo=;
 b=Li1A6kH4Ho4griJk9HqXmv1bZZZclHyLaTvxe3jRcCtxVeNQVGa3tFb6i2kXfE7c7pdfaOse6P6xskOsLoY9ZZ3zaHJpmGEieChDc9HwHjXMGPSzLV/m9RXJteCTiCI859fdtoWAHxC1oZJldP3hEMUWFZ5izUdXqJ3H0rkwOac=
Received: from IA1PR10MB6122.namprd10.prod.outlook.com (2603:10b6:208:3aa::16)
 by SJ2PR10MB7655.namprd10.prod.outlook.com (2603:10b6:a03:547::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 15:26:50 +0000
Received: from IA1PR10MB6122.namprd10.prod.outlook.com
 ([fe80::adbc:118f:b10d:46fb]) by IA1PR10MB6122.namprd10.prod.outlook.com
 ([fe80::adbc:118f:b10d:46fb%6]) with mapi id 15.21.0592.009; Sat, 7 Nov 2026
 15:26:50 +0000
From: "T, Pratham" <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Francis,
 Sebin" <sebin.francis@ti.com>,
        "Chawdhry, Manorit" <m-chawdhry@ti.com>,
        "Bajjuri, Praneeth" <praneeth@ti.com>,
        "Mahaveer, Vishal" <vishalm@ti.com>
Subject: Re: [PATCH v11 00/15] Fix several issues in DTHEv2 driver
Thread-Topic: [PATCH v11 00/15] Fix several issues in DTHEv2 driver
Thread-Index: AQHdbsg4rHuEHMWzYEGer4k/1huF6rciuzwA
Date: Sat, 7 Nov 2026 15:26:50 +0000
Message-ID: <0fe68821-c8e2-4418-8820-f3340bb8a0dc@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ti.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB6122:EE_|SJ2PR10MB7655:EE_
x-ms-office365-filtering-correlation-id: dd0196bf-2d27-4ba6-b6c0-08df3ce38b6c
x-ld-processed: e5b49634-450b-4709-8abb-1e2b19b982b7,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|38070700021|261026140227099003|56012099006|261026121527099003|261028144727099003|261022105027099003|10067099003;
x-microsoft-antispam-message-info:
 JAS4VLJaZm8hfzcPwSFYR7DWYTSwmTUI5KzjpVIMVwj82pGokr3y+QKutImNt6LOAnZiRdfP7JvigBDAkhJpr3/zYTn/TXjBncHHwBNNctK5JfeUxnOYXQ518lYTaylAbj6gg1td+XHMSKJmCVgqtIFNWgffPYvIu1g+O4DmtIxrCnIEThc0aIQpiISouQK6gXciX5Brn7u/eGPeJkV9V6yPxcVatzw1LiC55/HToypuAEXhGEBCPdx3Cvc+Jn4Qan5DMT4pn0gdn3gmhZNVK/orK8pT/urZf8ybLGECrZn7G3WrYFbv2Gt9f0Gvssnj6/28/8TWB5ySPK70n+HSSCvyfQ5mvuBwj3rrr1z9iRBE7UIDkCmgXS0RcSTTS3rxJpVJBp+fEVtkJupsg0wjCRkQ5RJHyS8KMVbg/6wQv64NioymKgt0osjfwbp+0sb6dX3kD3oxoUE5R1c/GLIfXAr12oxragIfLxBwbW/TIA7wCAguBrTo1A4eNUmaj4IOLZDwI3E1rGlcJzYV0Ky110k2QCjo5ZMgIklL2oek6Tl4dZyjaLS4llGHdTrKoSUJw46xgY2YcteXyPsXgJe5sNjBLpvBdN2Wu6y9Kgy+R2nul77wrV/toI2kYflxtCT3MsBZC4QKuODZjX17WjVG5BYlVp/BHjbvGmK20X9rC/lW6BC05ZNe7uJb8nj5tYDWgXP3UtK1yTTR9fBf5FXvt4DrvkJzyNaw6iFsKJSc43Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6122.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(38070700021)(261026140227099003)(56012099006)(261026121527099003)(261028144727099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RmwwWE8rRHVhOUszbG9xR0FTYUJ1THJnRTFWdWRINUtMbXhkcXlQTGp5czhP?=
 =?utf-8?B?eDFHa2xCSUZiWVR6alhUcXI0MkVTcEEvTU4zeFJPc0NJVzhpV2ZBU3QxWCtO?=
 =?utf-8?B?SHVLc2w3UkF4YXlmQlI3NEpPaDhDeUJWQmhjL21uaDVpS2V1dmlwYy84L0R4?=
 =?utf-8?B?NzFTMTcyOERYaTFpWlhzaWZSMDNxMGdFcEZ0ZkM3Zmo1WTNwMjA2MHl6cG1U?=
 =?utf-8?B?L3J3NEtlRFJoekZyTEhVS3pNSVFqb1h4eHpPYW1OeVE4a25rdlh6Wi9DU0Fj?=
 =?utf-8?B?YTAxd05OMjVkTHEvM09FNkt5MWU2YUtvb1FxNkYveVVqdm9HNEFobDJ1eFBF?=
 =?utf-8?B?WFhxdTcwdnJIa1ZSVURhekxlWFVCR01VYmx4TGNURGx4YzVQaDF5cm1XRndL?=
 =?utf-8?B?bTBZakZFZFlSM1BnMC8wc3V1OGVFUlhHZUFId3lhVC90aEtMbXlaK2wxdFZl?=
 =?utf-8?B?Y09idm9xUW1qYTFWVXNBOFBwMmdJb0x3bitoK09GbWlySDRTdHk5SzVtZmIv?=
 =?utf-8?B?VHBlMFB6QUdpK2FESXN3TnpFdWFRcGpPU01wakJFYW1wck01VmVZaHZPU1Vl?=
 =?utf-8?B?VWZaSVBKeXJ1TzRmWW42WkZzV2MweFJ6TkpIWnNUTUlZcDIva0JkQ0ZtT3pV?=
 =?utf-8?B?eGIxMUh2WFl1NDZUR2JpWVZxeVVldGwzdzRkMXVsQUE1WG04VEFlVmUzV1dN?=
 =?utf-8?B?dHBQVFk1SDFLYnFTVWI3aVhkcWdIamIyV3RQREg1YVRZeE16Wk9iZ3lna1BU?=
 =?utf-8?B?ek1pd1ZVWTJFUjZSSm5KSXJvMEpIZ3hUaGxpeEYzSEtxRVB0WW5IbEQ2MENY?=
 =?utf-8?B?UEF2ZDU0Y01KakppNGkvLzdJOExpTE4zclpzdmpleW80K0ZVVnZQaWkxY2JN?=
 =?utf-8?B?R1hGdDBvUTIxWndLMnNiRDBaMXFOdVNWNUQxNlhOc29HeVZtTm5vM2I5VjRs?=
 =?utf-8?B?T2dJbkVVMWxWSUtrOCtZaUhPSGY3enlYQXFOVTVUZTlpV01PWlp2c3hlNDhQ?=
 =?utf-8?B?Z1pIYzhjaUY3cko5WUt5cWNwanVJdlpSMjVzcGVjMHVTcDY4Ykg1RVhSWUQv?=
 =?utf-8?B?MVhjaWVMVWpMYlpzV3JqeDZpUVNJSnAwRUxqL2JmdjhvdTZQQ1FSM081bWo4?=
 =?utf-8?B?b2JqN1lTcXpUdVZ4ekp3c3huUExCTHZOZVB6SDczcXhnTUdyemsrTENhbE1n?=
 =?utf-8?B?azBGbm1WNWRJWHZpcnpiY25VNVZHY2FNbDlBZldrSlN0SE9lMWhoY2x6K3RD?=
 =?utf-8?B?bm13ZmRrVkM0Sk9SOCtxRExSSjV3SWJFOWw2VVlOc2d4NkhYRTBQY1dxNS9B?=
 =?utf-8?B?aUJNN21yZkkyRFJ3Y2FvWUxnSnMwY3dhMW8xL0dkMkF4ZWxReUJIckNzSDkx?=
 =?utf-8?B?TnBPR2wxMlJmRGNxeEJmcytPVlFoN1FQUTNtdmJraWZ0K0tpSytlSHhSNDRM?=
 =?utf-8?B?dmYvbGkrT1BDSmFObGt5L2NmTHRJaUl5a3VTV2tndFI5c2loWGJxVURuVldD?=
 =?utf-8?B?L1NSR2NQVGE0U0p3cSt3c0RjcVhPb2JCMXpIZjlJcjNMS0tOSjRPWGdKRWpE?=
 =?utf-8?B?aUtGaE1rQisyS2cxVFBibXk2M0hoRnBCa2hxbC9kRElHNmZna0txRi9UQVFH?=
 =?utf-8?B?RXowV2xsV1A1dndyUlBrV2FtbkdoWHN6ejZzVUw1Vkg0OVA1bld0THB4TDNv?=
 =?utf-8?B?RXljRVlPYUtyTnhlV2pXVE9la3RTWmdwK2tNcmhOMGVCNWF0Ri9VdG8yc1lP?=
 =?utf-8?B?cmd3MnhBMXkxSlJka1FDUkNrZ1VHeCtpeHprUUh3ZUhITVJ2cHd6dHhhL09q?=
 =?utf-8?B?M3l2TTA4d3Qrc3BYbGdNLzZSNys1cnpDQW5OOStXNVZVeUNYWVFXK3FQTHBo?=
 =?utf-8?B?a0p5RFVyZnV2WTdTcnFEdTZROXdkN1pjd1RmKzg3VlJXVGZsN3NWenBDbUd2?=
 =?utf-8?B?aHdEUGpTZ2R5WllxVGNRTEdEQ210ZXJYamNuQkdIVEhKVjhTVFZ3UDg0bVZY?=
 =?utf-8?B?L0RUdXFheXJDV2RHYVRBbWd2WlVKbVk5V2ZzemREV0ptOGpOZTRjSC9OdGQ5?=
 =?utf-8?B?cDQxS05CTE8zaU81SW5YRnlGNTRhcXlxWS9mZWRGSnJ0dkt4WGFwZ0Qrdm1o?=
 =?utf-8?B?RnNOWFJZSUZxOTIwKytoSU80U29scWN2anF1MmoxY2JldnlWMTF2aWo3ZWxk?=
 =?utf-8?B?K21leEJkdmJrNnhNamFpYmtOTkVGaFdzY2F0RlFlRTlsMmtabVN2OXdBREY4?=
 =?utf-8?B?VzcyTFBvVU1zbkt0VERyTEt2OE41RFo2RHJtZnBmTGpFL0dXdWtVeHdiLzVY?=
 =?utf-8?Q?6TzVvNojAd0J+kztFo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE0DDF64775D524184AC1C24755AA002@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	iw6Ug/5DaZy88+nsiZUz0Fvc2qA+OAEB3DI1ZN/Ni6l4lHlU0R8jA6fEBih5iVU3a5oCNr04+szD5anLkpLotpwOvs2iTRKFTfcCQu9m3NQfS85ZvDQV2li/p9hAmPmZbsVH4t2mnnXMPmaaJ5Yyio5zzlhoTYxg9gjS4gQd2dDX/+W6OXF1jNTXO/+wUq8Jw4OlIr6Iz6Y/u5vw6RGPxaqXQcl0uKt0tqZDbdVpoNIHeqIjyrqdhv6CC1LA53YZCAzcwRuXG7/2OmboFHArUwPEyDQJ20+OW/cjlz2MSg7j2RBRqtOiJLSmuh6c3q02P52ImJvvOAX+romkm30Bqw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6122.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0196bf-2d27-4ba6-b6c0-08df3ce38b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 15:26:50.3766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cfhms0zT1coIwcv0wsyfygHaI1yTpoDrHHXEKUwBcUURhuYZpld+QFGn61kWwH4woSKGWg9OoGVoHr+GtoZX5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7655
X-Proofpoint-GUID: AP-9FHtopnKhJbLTJL3c6aXwQLeyKGMx
X-Proofpoint-ORIG-GUID: AP-9FHtopnKhJbLTJL3c6aXwQLeyKGMx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MSBTYWx0ZWRfX/4rMHum3xAlt
 NEzPm8Qt0CXrZH7Um2ecFQ/fEpjew6CALggFnmfmJeKEIs9SRmOIC5c36c6ESYMTqs2j1W67MA+
 jnKAztJRiReGHQRam+f83w+7RWCKiw8=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef433d cx=c_pps
 a=RIETLMKpmuDvoeNDRfR8HA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=_bFmQ1G5zGV2eOCLhAAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MSBTYWx0ZWRfX70X3h2MPPhXZ
 ur/ZY8uSl8IULFvOBiDkJ7shNR5QQHUhtXI9++9ZyqgKNKMJrj8PsbMjhbj9PFt/7f5e0xgL94c
 81Jf4nzJltEGy00q4VbNq+2R9oPEb/y3HQZ0NL8st40Wa2JL1i5M6Z6Nv0TxqJGRAVfX6hi5Lse
 TTDiLc/sKWDIN1uhwewmLIWxk15p9Cag4bAOwiKIxwKvz1s12448LG40SKql8n4doAeYvjRJnZk
 E/E/L7Rvxr3FHVB37ntY/Jii5ZSoInk+aHkdE+nzJZpi7W4S5XTkDo8bnlS0As234KS2U1VLGA8
 you543LeqjKWyc3Z02zzvekhPk8mw/2Ls2ThTMewQX2GJfSxMbIBptP4Sfqog2WeQroV7s/wUJ0
 jXCiAjFjV4OO40fbfN9f+AQTRUMyQIfnSXqSJTv0BdGMM/YF/iR86XStXAw+4yPj7u03HhT5SZT
 Kq4nZDusjerXyXp0pKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070061

T24gMDctMTEtMjAyNiAyMDoyNiwgVCwgUHJhdGhhbSB3cm90ZToNCj4gVGhpcyBzZXJpZXMgZml4
ZXMgYSBoYW5kZnVsIG9mIGluZGVwZW5kZW50IGFuZCBtb3N0bHkgYmVuaWduIHRpbGwgbm93DQo+
IGlzc3VlcyBpbiB0aGUgRFRIRXYyIGRyaXZlciB3aGljaCB3ZXJlIGZsYWdnZWQgYnkgYm90cyBh
bmQgQUkgYWdlbnRzLg0KPiBFeGNlcHQgZm9yIHRoZSBmaWZ0aCBwYXRjaCBpbiB0aGlzIHNlcmll
cyB3aGljaCB3YXMgZm91bmQgaW4gYW4NCj4gaW50ZXJuYWwgdGVzdGluZy4NCj4gDQo+IFRoZSBT
YXNoaWtvIHJldmlldyBvbiBEVEhFdjIgaGFzaGluZyBkcml2ZXIgcGF0Y2ggc2VyaWVzIHY1IHBv
aW50ZWQgb3V0DQo+IHNvbWUgcHJlLWV4aXN0aW5nIGlzc3VlcyB3aGljaCBuZWVkZWQgdG8gYmUg
Zml4ZWQgWzFdLg0KPiANCj4gT25lIG9mIHRoZSBpc3N1ZXMgaGFkIGFscmVhZHkgYmVlbiBmbGFn
Z2VkIGJ5IGtlcm5lbCB0ZXN0IGJvdCBhbmQgYSBmaXgNCj4gc2VudCBvbiB0aGUgbGlzdCBieSBN
ZXJ0IFsyXS4NCj4gDQo+IEkgaW5jbHVkZWQgdGhpcyBwYXRjaCBpbiB0aGlzIHNlcmllcyB3aXRo
IG1pbm9yIGVkaXRzLiBUaGVuIHRoZSBTYXNoaWtvDQo+IHJldmlldyBwYWdlIGZvciBbMl0gaGFk
IG1vcmUgY29tbWVudHMgWzNdDQo+IA0KPiBPdmVyYWxsIHRoaXMgcmVzdWx0ZWQgaW4gYSBidW5j
aCBvZiBmaXhlcyBwYXRjaGVzIHdoaWNoIHdvdWxkIGhhdmUNCj4gZGV2aWF0ZWQgdGhlIERUSEV2
MiBoYXNoaW5nIGRyaXZlciBzZXJpZXMgaGFkIHRoZXkgYmVlbiBpbmNsdWRlZCB3aXRoDQo+IGl0
LiBTbyBJIGNsdWJiZWQgdGhlbSB0b2dldGhlciBpbiBhIG5ldyBwYXRjaCBzZXJpZXMgd2hpY2gg
aXMgdGhpcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFQgUHJhdGhhbSA8dC1wcmF0aGFtQHRpLmNv
bT4NCj4gLS0tDQpJIHNlZSB0aGF0IHRoZSBwYXRjaGVzIGRvIG5vdCBhcHBseSBjbGVhbmx5LiBU
aGlzIGlzIG15IGZhdWx0IGZvciBzdGlsbA0KYmVpbmcgb24gNy4zIHdoZW4gNy40LXJjMSBpcyB0
YWdnZWQgOi8NCg0KV2lsbCByZWJhc2UsIHJlc29sdmUgY29uZmxpY3RzIGFuZCByZXNlbmQuDQoN
Ci0tIA0KUmVnYXJkcw0KVCBQcmF0aGFtIDx0LXByYXRoYW1AdGkuY29tPg0K
