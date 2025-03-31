Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578C31E3DEB
	for <linux-crypto@vger.kernel.org>; Mon, 31 Mar 2025 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743435957; cv=fail; b=TRL8Kh55BxxRRmhv+aP2DAp9MYLBUjK/P8EWNk0E8D2mojtIdpqNU+VU0EQOEycISNGNHVHdI+JuHmpVfjbYfY0Lp7eym7cLu/Li2eqNKEQzotWo+kqjWfAw+woj7XWb5cLcvYjip57jKb+CbCxEtgt1tHoq8FGWUqjxTfsfB4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743435957; c=relaxed/simple;
	bh=P+ze6REYcwy9E6mbjsYzFe+rnGy0xiSiDKB6QWvaPUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VooXdjGNhaDLG7av4YfF31h/WeTUI2taEbncJGLQPnE29CoRcsShMNtMqSv2q/ku3ZGFznIs3lEatHZVfsVNn4JOm+F5jWfyZ7qcb7UvKuh7VRq/9pi+7MGHxwxm3Ozrjpq6T4DMImxK7FZ/Xm1CF7cXZsrbmGrIoyJo3bLTleQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=X3PN3GBy; arc=fail smtp.client-ip=40.107.22.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="X3PN3GBy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+tWQGuVP+2/QRXjmnO9cmIRs8ecUBlZ8U2duvSTZyEEswfYm0E478fVrDGvc1eUkYpBqa2bxoTCtgC4exUoYJq8e/UfS/WCxapsQFM1PW82AXAWNIOl7Kuf+x32Kfx2Xj9qLwqZpIhwAQVnJ9E490kAgD4nzHIh3yQa/hJUe6noMM6y41AuzLJ9L3Ayx4KfEM5n2lTKVrPW0Z5oEYolP4K+iyvKvGc4Lzyy0b6m0troGalYvLbOuHKdpGYRGQMOdxkALcZ5RoJbOK3KkMRrPeliRn/jdYo3ESNDAKkA01oJfknZR+u5rJMQfA5N0U9q3iIQdhZqiYulKnAIazp5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+ze6REYcwy9E6mbjsYzFe+rnGy0xiSiDKB6QWvaPUQ=;
 b=YlR/LcOL28St4PhNd5WcmmEdvz60xX2mQ/qiVxslH5T54rJNN0hhA3ohhvSpldod2pjbTu+Mu8yGDES1mjh+FhwGMfEzkgR6vvUmglmWtcfiZSeDZm2beBARpDiSM82KbW6XiZCK3M+1VWI+XgbJnnCBF70gfdQ3gzZZkcuT3otglWCuQql38/Uc0mW9s2K0LViZF+91rppJXA9G+5C/FTrXN3pJc8xkSya2cKGnEIxhWAf5AHCsRPwsb8Ga4LwmwAOgseXC9ZH6ZyZew3NuJNx20JzEPkwAgTrVWJV4eH7jR/a7THZCxqAAQ84OGMV2ZOtdpnpC6KQEs+SBgFjvMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+ze6REYcwy9E6mbjsYzFe+rnGy0xiSiDKB6QWvaPUQ=;
 b=X3PN3GByrlYSr4vJUI0OgZGdKrHwyDrw6IYWvIRb+lVyrAE+1BvGtQVKmnwSZyssWGwx4HloxsT+aIFl7wGIR3JKmO9yTp9ikm9j4LurwmH0PpPcIMrf86QEv+wRm1llY2ae3riP7ErX+Sk7UQJq7+0dZYmMc4H9LQC2kQVoVmAZ5QRZXDvk5myI+8VzRzRlLovWZ+TrrmU9+UroyVds0M9H9XSYkMrDr78yeqzmMuujEa1oHyXyVlbU1B0keAxH4fqYiQg/dJi4M/Fqw+wXoBkl7Q0TabVW4t3p2C+O9wIxocP8MG6UsALDXCpP0l5jl5p4S3DME+3pDEUIrHfFaQ==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by GV1PR04MB10896.eurprd04.prod.outlook.com (2603:10a6:150:204::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Mon, 31 Mar
 2025 15:45:52 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%7]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 15:45:52 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Gaurav Jain
	<gaurav.jain@nxp.com>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Pankaj Gupta
	<pankaj.gupta@nxp.com>
Subject: Re: [EXT] caam hashing
Thread-Topic: [EXT] caam hashing
Thread-Index: AQHbm/XepWTAbidRBk2Lp+KQulcy5LOB0qaAgAAc3gCAABYqAIAAAQ+AgAtpTIA=
Date: Mon, 31 Mar 2025 15:45:51 +0000
Message-ID: <e3dc3351-c819-4d65-b5ea-0e90916ea7c8@nxp.com>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
 <DB9PR04MB8409D73449B57FABE1B3031CE7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-EmH9n5u05iJ47p@gondor.apana.org.au>
In-Reply-To: <Z-EmH9n5u05iJ47p@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|GV1PR04MB10896:EE_
x-ms-office365-filtering-correlation-id: 164e3b96-497e-4880-0524-08dd706b1dc0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YTVlRnhRWWRVMmo4dmdWNFdlcGZaR1ZNOFBuRlhHUEozQU42YnRqL2hoQ2ha?=
 =?utf-8?B?R3VMZDBjbWt6WTIrdlFQRmg3UHdvY0ZNUkJsZGxTNEp1ak0xWEZnYU5Xemdl?=
 =?utf-8?B?c25pSzcyVGo2eXlsVVE0UVd5SmR6RmJoSW5mYUp5VEIvdXlUSXZGTVpQb3kz?=
 =?utf-8?B?cGk1aW81TXBraHE3SC9TVjVPcUkyMjBtVG1uL05yK0hldFpXbnZVM2IzSlEw?=
 =?utf-8?B?YXZteGhIWXM3cEgwNDNXNENLaklYaHd6YWp6S1l2aHhtVU4yNFhZMDFFL3VW?=
 =?utf-8?B?TDlyaWpJdit1UVhNbXYyZEtRWDQvN3AzNDZzR3JodW03QlM0eTc5Rnh0SVRL?=
 =?utf-8?B?cldVeG11OTk5Y0JLS3VjdGhXMzROb1psTGRRMVRMREkwc1dBc2lyT0lxbTFu?=
 =?utf-8?B?Z1EyUS9LRS9xaDFRdmtKTkZBNnVsOE1CZXV2dG9qd1UzTDZIeFJNS09BSzV3?=
 =?utf-8?B?eGM4NENJM1RnTjhPMmM3aDdsckxOeWNMTjJIc0kvYk90YktrMVNOalJlOTNV?=
 =?utf-8?B?dzFMR0h4c2FPcEdXZlVISlErRE40ZTE2RXBpQzJuT01mNC92VnBPRWNXSjNR?=
 =?utf-8?B?d3ptOVJYVUE3ek1PT2FMNm9LNlZLb3lHekpaSXFTUUE1WlY5UENvSXRtQUpD?=
 =?utf-8?B?ZmE4SlZFcXZIN1F4R1BjWTlnY0ptZjd5WktkVGIxdjltTkMvaE5JaDdnTlNV?=
 =?utf-8?B?elBFbktZaHNwb1BBNGZuSG4zVmtmaEUzMmtJVnF1VDZiUXNhM2NuQ1F2dGJi?=
 =?utf-8?B?Zjd3bEdtREo5eUFtTjJMSk13WTN5aFZWQVRwa2tGcVdObS9YS2VNNnB5ZUJV?=
 =?utf-8?B?SWxNMEFvR1V2bGJXWFVVMzdTSE9Jek5VYVV0U1R1aERaWGVXVW5YNHFJQ2ND?=
 =?utf-8?B?RDZPVEo0cWFNOHMzODJYQVJjVUVPaUJkamp1Y1pxY2pNUUk3VENQNWljaHBZ?=
 =?utf-8?B?Z3pUZVBuamxseXNZMkMwbGFJMDd5MWJVV1UxalBBUUEwN1dMNW1laVhyWFh2?=
 =?utf-8?B?YUwyaXQ3WjZuWGhKdnBrcFlKMWVYU0ZkQnBOVUMwSTAyZUNSaVV0MHVYRTVk?=
 =?utf-8?B?RnE2R1pUY3JtK1FVMk92U2V0Sm8vazVMbVlYd3c3YzlNMzAvcURiNU53NW9H?=
 =?utf-8?B?ZzRMRXNWR2QzazVDVjN1UHMvSmxNZ085K3p0NFoyc253M1VJdWtPYUlvRGZR?=
 =?utf-8?B?VlgwUUJ6R3JnWWs0dVZDd0dSMi8rTVVDQUtqQmlRb1hOQlFtWThhU0RQWkEw?=
 =?utf-8?B?QTdTUXlxOHZjL2dJV2lkaGkrMHB0ckZsdUpFWi83NUJ4NUoxNjhjbmhYcVBx?=
 =?utf-8?B?VVBKdVp4Q0FrRU5zclE3S21CUDNzeHJCUTVtYVNJblBEQlJEd2tmbGpXMGYw?=
 =?utf-8?B?MTd0UTE4ak9PN3o0d3N3UC9vYStlL3ZPdS95Z0c1c0M1djZpS2tyV0UvazJv?=
 =?utf-8?B?ZTlQMUxTeldRSDZ3bllhRlNYdHBTQUhvaWlvdUZkY1M4NG82bGxxRElqU2F0?=
 =?utf-8?B?enJOUXhRMGs3RkN4WEdReWVNSG9QUU41M0JyRHZMNGFNcHFnano5MVh2NFRX?=
 =?utf-8?B?MmZCa2NGem9KSlU1ODQ0NXpqRzRPQm5vUXB4VmlJQXF6WDJoTTZyZW9md3hJ?=
 =?utf-8?B?Y2NpY09LNFFuaU51dlcwNSthaVZKblRXU3IvZ1ZONFJ4Skpkd1VVTHFSUU53?=
 =?utf-8?B?RFNsd2JHNFVpQjRENURaL3ZPaWVUZXI1U2w4N2Y0R29KK1RUL2NTN2VNWVFM?=
 =?utf-8?B?amxLNHgva052UnN4MDFSeFlRSkRrOTluZVRPbGlHMDV4UURJa3FOeW1IQTFy?=
 =?utf-8?B?MlV4NVhZK0MvNUIyc3M4dXl5RGp4OHNvaGV4clExR3QyOHdaamtZVUxaZHN1?=
 =?utf-8?B?eFJUSnlFSTA3WkFZRVVtRUh4OHM2UzRDa05ZOU14OWxBZUpGWTkvaUQrbnp4?=
 =?utf-8?Q?vw6fSuG7xYTIriauoAeOz+ZmI6tsVCQ6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aGFwYVdlV1UvL3ZEd3pUQ1QrMCsxRlhqY3h3WnlERXRndmh6NzlneHUvTkpr?=
 =?utf-8?B?aCtoUDUvUUhKaGdTOUZBMmN6anFnWk8xNldZenFTQy85K3J3M201U082OVQ1?=
 =?utf-8?B?azlRcGQ3UlhiSzQ1WUIyZW9ZaDNkRGM1S0t6bXhBeTdUV1l5UWQ2eGxWT0JH?=
 =?utf-8?B?WDVoRWVsVGRoVXduWVBDaGZqZ0lMT3VHOUE3VmNXUDN3RzBNUVRxZk96QUlG?=
 =?utf-8?B?WmdsaENReHlRV2NINnIwTnU3clN3aW1uS21FWnd5SmxJNG9Qd1NIVHpEU1pF?=
 =?utf-8?B?N1lGUkdsYms0dmdjeGl0MHZoUGtYcisxZklndXRuZXJtNkM2cnZSQUlCVEZ4?=
 =?utf-8?B?c2tRUGJXZ1R3K0J5RjlLTHBrMHQzMFJuYVNsVXAyaGtHRFFnZXJmdXhHb3da?=
 =?utf-8?B?dUdXRjZTVHhJNEExeUZ2ZXdKZmJieGNGWTdMUDZTc3p4VUoyazQ0MEwvcURn?=
 =?utf-8?B?VVpGVFhpbXlrQWpSTXZqK0tZOVlGbE5NY3dXZ1ZpUWp3aWRkeHRPc3FFKzA1?=
 =?utf-8?B?OFNmZG9RVytSckwyeFd5UG5uQWNmMEVXeE4zcVZ4UnJjL0kwRWpDSnhRRWlr?=
 =?utf-8?B?WlRHZytCaEFMUmN1QVhZK2tyYkxBdWRBc1BDZHc0UFJnSWZoaGdrVVVjRXNx?=
 =?utf-8?B?V245ZUh6R01FY2VCdzJmVE9TRS9Jdm9GM0xWTStsR1VWbFVGa2p0UEdrT1Q1?=
 =?utf-8?B?SU9WSm44Tm02SFBpcnBUcXkyV1VLWGl6cjVRUHN4dTdHcW4veXl0VmRUZm9p?=
 =?utf-8?B?N2Q3bUdxZG9RWk1NaDkxNXV4N3JXUmgzNHM4UFJhZlZWOTE3M0JZZndxZzM5?=
 =?utf-8?B?bEQ1T3V6SVJvTU1xZ2dBSU43cktLMTdQS3lSRXFnR0RXSUpBenhUOXRtcUhr?=
 =?utf-8?B?SDM0bnlXYXB3M3JPOXRmaUMvRnhkVjdHVDNkMDNRN00vazk1eUhwTmtKbVIx?=
 =?utf-8?B?anJWckZQek5Zd1h3TEJ3WkE5Vi8xUFRMMk12Q1JpSC9EcURuQldMUWNEKzlX?=
 =?utf-8?B?OVZRSTBtdEp0M1cvaXp5aUpQTHpTdU9VNEVabjNQdDgzUnJ2UWFuMUFJd0M0?=
 =?utf-8?B?eXVwcXpCbXkrRVJ3ZUlxV2hKczFZWWlhejhRb2t4U003ZklXT3RFMndTczdm?=
 =?utf-8?B?UzNkNEVuUGUyRm5kTmczK0RDaFE5YjlucU9wMjlFZ0MwbEJ2aGMraEVJWVVF?=
 =?utf-8?B?MWZPV21JaVJabVFKc0VRVUVaS0ZYeEhGUlFIUGdyVElWZGdKTE1FU3hHS3d6?=
 =?utf-8?B?dENqWFZrTk5WRGFRSk1rVVN5RG1IS3RPWmhRWkkvL1N5QXZUalQrL0gvRmxy?=
 =?utf-8?B?UkNPUFdWalNkK2t2QzJzT0gxeThzZDI1SjNwL1R1b3V5WDd6bmp3NGFJYmtB?=
 =?utf-8?B?c3ppM2hhVERXeWhuWUFpeml2QlJXOXZJOTJxVnpJV2x1dEtGRmVWMStPV2NT?=
 =?utf-8?B?bTRuMXdXYkk3TDVMR0JzRFUrdmlhQ21sWUN6M01oQ2lXdmYxZGw3ZksrVkg3?=
 =?utf-8?B?T2RqZ05NNDlsTUJkZmxuRTB0cXJTL1BnRGRxalZ2L0ROczl5S3FFRXhldzZq?=
 =?utf-8?B?WmlTdEpnZFhCUzRtN1d1K2E5K0lSRnJkR2pTbDg5NzQrZFR6S082T1NGS0FF?=
 =?utf-8?B?czRNU0ZxVVJyaDFZbStzVFZOQU1lVzBBVFd3UlBXaXZhOU5RdGNjNlJkdUxj?=
 =?utf-8?B?N2F4ZmU5Tjd2WTJIU2pNSmZ5WWt6dlJlY2F2MGU1RjZvSUtiTmlpRWdzRTFs?=
 =?utf-8?B?RDZQek9zaGwwamhTM0VONG1ha3NrTGlkNEM4cVVTM3NIc2NXalczM3FzcVJW?=
 =?utf-8?B?WVFxYzZaU1djVnNHM0l2NHlEeFU3eUdERGFrejdaOXNURVNjNmVtaHc2QmpW?=
 =?utf-8?B?OFNNaEtVY01udlBLYTNVdWlaZ3BkUG1IOHZTNGxweG1sVDdYOUZVcjVhcXZN?=
 =?utf-8?B?SG9vZk9oZ2JIMHJDYWtpa3NtY1Z5ZlJBaHVST1p6d0JkNE1MdzNDTmNUWU8y?=
 =?utf-8?B?TkZoazJJYUFQdzhINS9qU1hQTGFyZHBkcnpNK1hrSWNmRUpqY3UyaStkK21L?=
 =?utf-8?B?c2ZXQWhYdW9rVEVJS0JCbGdXNVhtbFAzSUVuMFo5K3FacllWL3lVcnU5RDRa?=
 =?utf-8?B?bEFZeHNORjdTN2ZXR3dLcW8yQzhNVnZlc0FSTVlySEREaUs0UFJyY1FJbUVD?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19204DC995B2FA49B723248B8CE04FE3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9709.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164e3b96-497e-4880-0524-08dd706b1dc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2025 15:45:51.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ezo380GxI+oGD/i8u+U2n83g/l6UPJMII2RITF12q+Pqfq3KbuOzZU2aseMsGEqsF8M3gEbubow+iWQBiZGNLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10896

T24gMy8yNC8yMDI1IDExOjMwIEFNLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBPbiBNb24sIE1hciAy
NCwgMjAyNSBhdCAwOToyNjoyMEFNICswMDAwLCBHYXVyYXYgSmFpbiB3cm90ZToNCj4+DQo+PiBJ
IGRpc2N1c3NlZCB0aGUgc2FtZSB3aXRoIEhvcmlhLiBkYXRhIGxvYWRlZCBpbnRvIG9yIHN0b3Jl
ZCBmcm9tIGNhYW1fY3R4IGlzIG1lc3NhZ2UgZGF0YSB3aGljaCBpcyByZWdhcmRlZCBhcyBieXRl
IHN0cmluZ3MuDQo+IA0KPiBTbyBpcyBpdCBiaWcgZW5kaWFuPw0KPiANClllcywgcnVubmluZyBt
ZXNzYWdlIGxlbmd0aCBpcyBiaWcgZW5kaWFuLCBwb3NzaWJseSB1bmFsaWduZWQuDQoNCj4+IEFs
c28sIHdlIHdhbnQgdG8gdW5kZXJzdGFuZCB3aHkgaXQgaXMgbmVlZGVkPyBhcyB0aGlzIGRhdGEg
aXMgaW50ZXJwcmV0ZWQgYnkgY2FhbSBpbnRlcm5hbGx5Lg0KPiANCj4gSSdtIHRyeWluZyB0byBt
YWtlIGFsbCBkcml2ZXJzIGV4cG9ydCB0aGVpciBoYXNoIHN0YXRlIGluIGEgZm9ybWF0DQo+IHRo
YXQgaXMgY29tcGF0aWJsZSB3aXRoIHRoZSBnZW5lcmljIGltcGxlbWVudGF0aW9uLiAgVGhhdCB3
YXkgaWYNCj4gdGhlcmUgaXMgYSBtZW1vcnkgYWxsb2NhdGlvbiBlcnJvciwgd2UgY291bGQganVz
dCBmYWxsIGJhY2sgdG8gdGhlDQo+IGdlbmVyaWMgYWxnb3JpdGhtIGV2ZW4gaWYgd2UgYXJlIGlu
IHRoZSBtaWRkbGUgb2YgYSBoYXNoLg0KPiANCj4gT2J2aW91c2x5IGlmIHlvdSBleHBvcnQgdGhl
biB5b3UnZCBuZWVkIHRvIGltcG9ydCBhcyB3ZWxsLiAgU28gSQ0KPiBuZWVkIHRvIGJlIGFibGUg
dG8gaW1wb3J0IGEgZ2VuZXJpYyBoYXNoIHN0YXRlIGludG8gY2FhbSBhbmQgY29udGludWUNCj4g
ZnJvbSB0aGVyZS4NCj4gDQoNClRoYW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uLg0KDQpMZXQgdXMg
a25vdyBpZiBoZWxwIGlzIG5lZWRlZCB3cnQuIGNvbnZlcnRpbmcgdG8gLyBmcm9tIGNhYW1fZXhw
b3J0X3N0YXRlDQooY2FhbS1zcGVjaWZpYyBoYXNoIHN0YXRlKS4NCg0KSG9yaWENCg0K
