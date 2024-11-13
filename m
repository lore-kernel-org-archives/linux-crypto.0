Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7A6088F
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2024 12:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731502580; cv=fail; b=bcc9y0pC+6VvJHOtYioGVwp3MbIjvb4fmDw45nMqELsf8mRfNP273Ka0nQivWxdSVleQzX6lFD09pHQjt1YJ/dwjplmoK62lu3j+KnVGXYQOLirqqa1A8zmVh+kzVY3N8E8cEjbLhpf0JHTtDJiEJJT8Vg/M5VUxswbBAPCIWao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731502580; c=relaxed/simple;
	bh=72Dvr9tPSRdL+xj0LUT5z3+2SPO9UCdcgnRNq2VSbWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P1p5ZtpS0+Kma3o4zuf8ePdw6qtbvg21RJAjnVjRsZWQPplRY2wYo2kRF5D4ahJxTsurf3EW6xSU8UNlQEGWKZbF8TRXPhjkwVQtjG5ALVGM0cliMZvwBmDAIrqafGAVgypNDzH7S9HKW+LjDEtcJOZLgnRDDb76kxCUmnRJuTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=TNj1Lwsz; arc=fail smtp.client-ip=40.107.105.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="TNj1Lwsz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qj+O0Aemq4VFSvutdx7mDSuo/Bn0C64915dLKRJ3XWV8prTCKF7/CV9C6JE7N1VtMOvGQAIRYvtyIl4xex5dkpwgkFA6O0wc/wCqgHV5jSqh5dBtUNDr3TzqqE+TMPeuGJCIRLDBoQfw2w/T+TvOOH1JiT/O/8wbhWcihjy6gZvxLrfZf/XlYfPx8cMf/bZ24/KzVYzXelES8er22IA830XrFnJtOrnET3u+fHxGCsDVhJTf+jpRAJ+zSuQFV6Jkiwcej2B7GqfBTSrWoQaPUdezSYjBDrDqyd9CLh6b1dnnM5LTHAc2F2Z2SGEg0FeG6bigNU5sIEk4oqHb6xD+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72Dvr9tPSRdL+xj0LUT5z3+2SPO9UCdcgnRNq2VSbWc=;
 b=IJ/dqKQajkcWCRInu6GLdD0LloPEFrD6Uqe89JJZFm93t9w7Fwm6vX43DnUL9L91Am7+DyCv+Lp7MD/CJCwfHajnAbvkgRH9Wo6hyUabwhVUn5rfndNFp0wm3AyNFyADQ6+FWwhZa/Lb0YueXW9Xpd2HsgonrE9yBI/Ye9BmQ4loVNrQiRFE450ipBDrxN58iXCPGjxUsAmTsRWsDFLyz9MiU6syLgaMfR7UjT4BlkXTsvPwGOmrNT2/MJER22i3nvANqSc1DNYGyB2uFHuwxmulw4duNap9fXdj26++jMIZN7Z6Z4s+Zjj4PwJ3UF/vVTAEFxYpgDgTcheau7bXlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72Dvr9tPSRdL+xj0LUT5z3+2SPO9UCdcgnRNq2VSbWc=;
 b=TNj1LwszIFJ7xS/OdT/lx3V2WKy+gYkEM6QoqUv3yYEyVd47MMK1Yb++YE3zj6+Hegg3de8b9Fkottop7EtyO9lmhzURyv28p1TTSt8UeKDJVI+YereJeLexGK4mTnrQTiihATmTZmXCgvWL37sWiyhST2BbuIzgod7hGwN6c+pbTrn4QQ+cDqXPRaPjP7CnWdDdMwiSWJ4GuRLC7IoCpfYzRzrR3Z1hQUoPbS2jM0zZTx81RkCpFY9lPHzgwDvkdqLK/Q8W12hYHVB7oR5i+dRrGjFfqYa7FCR6CvlYPHsZVwjiQZ4IzlzQNoiFhK+PPYv4E1qt8zaBvLNzKAJzFA==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by DU4PR04MB10936.eurprd04.prod.outlook.com (2603:10a6:10:588::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 12:56:14 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 12:56:13 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Chen Ridong <chenridong@huaweicloud.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "tudor-dan.ambarus@nxp.com"
	<tudor-dan.ambarus@nxp.com>, Radu Andrei Alexe <radu.alexe@nxp.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"chenridong@huawei.com" <chenridong@huawei.com>, "wangweiyang2@huawei.com"
	<wangweiyang2@huawei.com>
Subject: Re: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
Thread-Topic: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
Thread-Index: AQHbLrR4fJiGPOW05kWzoO76IsfgZrK1OWwA
Date: Wed, 13 Nov 2024 12:56:13 +0000
Message-ID: <4092b7f5-963e-49cd-acf8-8cd79069cc76@nxp.com>
References: <20241104121511.1634822-1-chenridong@huaweicloud.com>
In-Reply-To: <20241104121511.1634822-1-chenridong@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|DU4PR04MB10936:EE_
x-ms-office365-filtering-correlation-id: f79c5915-7679-4040-eca1-08dd03e28e1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aFc1Qi9LeVFDTUFZanZvUm5xNDhWZ2g4NHNPYzR4OEtiRFFwUUREU0dPUy9J?=
 =?utf-8?B?a0luRUZFS2JXME1LbGNVMnpNbWpTVEgvUnlFVlRGeitFVWN6Z1ZQY2ZGSkRU?=
 =?utf-8?B?NFRaWnVXR2cyWXZvZ1FwWGNFNy9wR3JPRFAwOUVlbkZNMWMycXVjaHpZbFMr?=
 =?utf-8?B?UEJkUlhab1laQzFiQ0ZMMFVqaWtHcU9QZGQ2SldXcXkwN3RaZWU5Si9yUUVN?=
 =?utf-8?B?WHlSM3luQzFFM2FLQ0k4NUd4NjEwL0U0anBHTzgwU0MyWmVxSS9JdDl1TmhI?=
 =?utf-8?B?MTVacFpYVG9TM3RNWUJpbXdYUWViTy9DQ3c1TDRuL091Z2tFNll3QThadVFQ?=
 =?utf-8?B?WG9tWnJ5QXZpQ29KdkFPMnIyZEVkMy9CYjc2bWZTTHdjYlpheWVpdHE5dGdF?=
 =?utf-8?B?WUZRWERBTlRsNVgwUSsrdmE1RFh3U1UyWmROWkN6STM1TXBFSEk0SDZNZkdL?=
 =?utf-8?B?UEFrdDNOZTN6QXBuRU42T2M5eUNRaXdjYjZ1MmtJOUF5ZXpFWTJSZWxaTlhX?=
 =?utf-8?B?ejBDaDRJZXdUeXZVeURHNlY3b0tsMWJNZkZlTmNmTzhlc2phTURFZHlvRVhH?=
 =?utf-8?B?L092UjZRemNEWU5MQitRdlphczRwZW9YQlhIdlFiVWV0SHF6dnFJZ1NVYmFk?=
 =?utf-8?B?b3oxUGl6bTZxVXYycWZIVlJjalBtMTExb2VLRDZOL3NpSUVTQXV6WDMyV0tJ?=
 =?utf-8?B?NjVJak85K2MxZ2dHWVhaM1VSVDJlTzZBQk4vQ0loNjhUODE5b2dkNWEvQ3ZB?=
 =?utf-8?B?MUVZOHFKU2dLdkxGT3hFQk13Z292R3RaR054alVueVFmQkVwU3VjdmZQbFN2?=
 =?utf-8?B?eTh1OUxxSG5xK0kzUkg4YzUvczhRd0pXSk9hZ3ExTDlQMzBmWVlpT1Q1WHRq?=
 =?utf-8?B?bGRyQnJKMC90by83WmJpQlB3dHRMN1pobXdaU0lMblZNTTV6cC83bU9JcnEz?=
 =?utf-8?B?ZWpUdGJzanFXK2ZnSEkzb2ZNaWR2MXZiTm4zeGltU3NCS05JQTNQeEpWVGY4?=
 =?utf-8?B?SnBZRXFHUTNEYXIwSFMwQkltU3IwSnBseUhiY3BDVUF0ODdtcTFURVlGRkUx?=
 =?utf-8?B?TWdxSldyMVh3Qk5tNFVCN0ttU2xHNHBjRTdGd0FQdDc2RjBTSG9jMUZwSUxL?=
 =?utf-8?B?azJYU2VxWklDNWtMSXJjc2sreTR2a3UwazhNL1hWSm84QUNUanc0QUNHZWt3?=
 =?utf-8?B?TW9OVC9xQ2tRdXRHanAxcjM1ZWllL2NmVnFRQlRvbWFlT0JDUnJGUFFaKysv?=
 =?utf-8?B?bWJSeGtBSlY1TUZsZTUzVVYxSmZ4cENXUEV2V1B1b2pXaERQeTJYb0MzMFdl?=
 =?utf-8?B?Z1krSDJkVlkwTWFTR3dmMTV0bFlPYWpLcXFwcWNxUDV3ditpTXcrTDhOYlFp?=
 =?utf-8?B?ZFdBUDJweVpWVnpiUHE5bUNzOHlJalJzZGF1S3FIa2ZLbUdWcUp4Wk9ENFJB?=
 =?utf-8?B?dXJHeG10OXF4d0pmaS9IUmJ2a1A3Ky8weVh0anVoNFNIeDViaGtaNWNsd2M0?=
 =?utf-8?B?SngyRlRkcU9HdjlWV0EvcDBuWWJuSlFDdzlpa1JhN0pVUnNLcXNTSHA4aElB?=
 =?utf-8?B?TkNzVHhCd1FHbnBUZlRuanpiOTU3NDZtektSc2NOSkJZbG1Rc3JqdEw1QjVG?=
 =?utf-8?B?SWxSSjZ4cDFjTUpBYTV5VVZwZDAvbXk2WUVGVDdNTlZtbUgwY2ZtSTdoaWF3?=
 =?utf-8?B?U080c0hNakVDN0RidDhoSVlqM0hVVUdyRWhUa2JON1NzU2JiZ0pzVkhFbXQ0?=
 =?utf-8?B?TkRoNjJWc0tDUnFtNzFjUjhSU2tXYXJ6Q2c0UXRCSE8zaVJrWTNScGt4SGQz?=
 =?utf-8?Q?ExPKT6GUDK7ByVTkfDUSY/fiTJuTsIDdPHJME=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WVk5ZU5nOW9UaGhxMGtLZW4waW1IVTRNT3pNYjFiN0laN3ppY1NhRTZiRkVD?=
 =?utf-8?B?MGJYTnFXQW8yOEh0U0E1UDArMTdaTEFOL1B2cG1UVHBuRWd0bGZBTGRlUm9I?=
 =?utf-8?B?RWhmeXRPcms1U3NwRndGVzlVeVVRWkYzd1Zid1ZYWkEwbmxQVDZ6cm9TU2hz?=
 =?utf-8?B?RnBFVkJVWlJ4TGR5U0phcElVL0pOUFlTbWpmbWpzdGtaejVsNVhoTVpjSnVa?=
 =?utf-8?B?V2l4RzdHRlpKY2tNem81MkJpeHZna3g1c3pvTlozY0tFVW0yKzBpYzBtY0d3?=
 =?utf-8?B?MTBaVnIrSERSUlpzUW9XdVJwM2h2MXh2Qmt3VGlvVEp6U1VTNFl2WkpDdzRw?=
 =?utf-8?B?L1FmTGt2ZXdsOEVtT2tmVGRjc2UwbmFrSTRwN2h5TWx4Z1lzZmdGUTdObWRj?=
 =?utf-8?B?aUtaaThLczlzZG9vMUd6Ymk1L2dSQll3aTExYmRQS3pZL1ZKeW1XR2ZTYW9m?=
 =?utf-8?B?Slc0ak5WNTdDM3E0aHVkaEpBZWszczVyS0FNUE84ZHFVeTZzZmtndFpYZWp4?=
 =?utf-8?B?cTQyZTgwT0xZN3NTcUh5M093cHVvcXBaZ0E5dHF0VHpJemlQdUQyTUI1cFdQ?=
 =?utf-8?B?QXBGOUo3eXhUVnRybTJ2U2kxcEVVS0l1RkZlNE1qVVNvTW5oUXZER0xvUEJy?=
 =?utf-8?B?ajByUVpkbzFoR2NZT3NWQVFVcEtmWSt4bmJ5MHlQdzBRdmxndnR3VmE0UVhO?=
 =?utf-8?B?WGlRRkw3QThYdFF1b3hZSlY0aGcxdUpDUGNkNjBMd0JSZW84N3FHeVJMVXJ0?=
 =?utf-8?B?ZU9HVHlNb3V5czNGS0FZbXlIZElOa1RCNFhqU2xTWlJmUXFSVnhQY3VuOGFi?=
 =?utf-8?B?TisrWmV3eWkzeXFkZUZpMWdCVXYyaVJPbVVrMlpDRXlPMVVBb2M4cmtxUHFZ?=
 =?utf-8?B?Z29LeUZhSUszMEFxeGRsMzgrLytHQ1VpNnh6aTBPaSt5ckpDUEV2eTQreWlC?=
 =?utf-8?B?THRDSmlsS0hBcDFUaG91YzRiYktaVTlodTNIQ2U3ei9wcnBtQjBBSnFIWjlY?=
 =?utf-8?B?d2wxaTEyNURDcjFIY00xUHg4Mkl3L0pkOVBLMWtraEZ5djU0b3Z3dUdHNnR3?=
 =?utf-8?B?bUNYeTFSS214WURxL0RXSUFXR2VIZ2tuWUpKUmJ4alV1ZjRLUTFySmNDYlRX?=
 =?utf-8?B?UTVHalo3c2gxajV2REpIUUU4R0RuYnhkZ0Z2aWp0dUhyREIrSDRad2VrVkV5?=
 =?utf-8?B?Y0FTcHE4a2Q0QXRKYnNLS1JSay9NQUJpT2kxVm5SNjNuLzlLQ2tXSmFrRWEx?=
 =?utf-8?B?akt5NVlFSWJybnFqRnJPa3g4WTZwS0FFSUk1bU8rZGVZUDNCbEw3R2ZxK0VV?=
 =?utf-8?B?NUw3cW1vcjNBdVJqN0plYko0c01TcGdYQVNiYjJDTUZ6eU5uY0h2c0VVbnZ3?=
 =?utf-8?B?ZjhsU09ZWEJOckVZNjVYaVJGYXR0eDVsb3NZdHRmeXdYbG0yVEhGbHZQdDNh?=
 =?utf-8?B?L2ViWS9MMmNCenJXcUlsTEdpYlpkR1NqdHR2RVh3bjJ1djFHL0U1YVl6TE1H?=
 =?utf-8?B?NDVCdjVDRzlQTzYvL2tlM1c3ekUyQkYwZGk0V0tSQXI4UWJKVkc3Ly9GcnVr?=
 =?utf-8?B?YkFvakJzdjRUMjhneUhqMzRqakc0VEpMQjVXNDY3MUtaQXU3SC9JQXVTeHli?=
 =?utf-8?B?OThVbnkxalMwMHVzUU5vS2sxWW1PV25GUm9JKzBjWmVkY1k5U2NpQVFtb1hx?=
 =?utf-8?B?SkIwYTNCaE9mZEtGd1lpY0RzdmdsMVh5NDdCcG5lNUg4Ty9nRFNzbGJ1ZXV0?=
 =?utf-8?B?YXcrbVNzdW4xWDdkYTk2T2VtTnBzSFBBRTBobDRWdVAxeXBLRzF5L1BmVklw?=
 =?utf-8?B?RGFvSGxXdHFndVlFVDVzVDdHM1ZlTTlPTVc5WE5EKzd5VnlDcE9tRW5oRWxD?=
 =?utf-8?B?ZEdJaE5VT01iU3BSYnJ4NjFPRlJ4Um1CVVgwTXpEdko2VmRaYUJvKzRUUWVs?=
 =?utf-8?B?VVViaFc3a0NzbjFnUDFweDJEdG0zSEpCNXFJaVlBc2FseEJDZk1pbmN0SmZa?=
 =?utf-8?B?ZElUYWJrK2w2NElQbytPRUUzMk9CSTJHRzBEbHo1RDhuSlFWcG5HNXhzZUo1?=
 =?utf-8?B?aCtFc1c1Nk54SGVudWFOWlRGYnc0QzdnbndJdElRSi9VSVhGa1RsemVYN1Zy?=
 =?utf-8?B?NkpmWW14SHVnZmZqaDBNTnpQVUhyeUlqMUFpbGhPc2hJd0sxaUpJb20rRWxI?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB1554F08C1D264BA817407195FD6680@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f79c5915-7679-4040-eca1-08dd03e28e1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 12:56:13.7929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sZGO1yl5eHNBZ6ARmqVfISyv0sEzWZ/aJLjILegHVySI9d6qtfUcOqxYQjsnKdc73QJDm+Yv0aUMM1H/QkUTSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10936

T24gMTEvNC8yMDI0IDI6MjQgUE0sIENoZW4gUmlkb25nIHdyb3RlOg0KPiBGcm9tOiBDaGVuIFJp
ZG9uZyA8Y2hlbnJpZG9uZ0BodWF3ZWkuY29tPg0KPiANCj4gVGhlIGNhYW1fcnNhX3NldF9wcml2
X2tleV9mb3JtIGRpZCBub3QgY2hlY2sgZm9yIG1lbW9yeSBhbGxvY2F0aW9uIGVycm9ycy4NCj4g
QWRkIHRoZSBjaGVja3MgdG8gdGhlIGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtIGZ1bmN0aW9u
cy4NCj4gDQo+IEZpeGVzOiA1MmUyNmQ3N2I4YjMgKCJjcnlwdG86IGNhYW0gLSBhZGQgc3VwcG9y
dCBmb3IgUlNBIGtleSBmb3JtIDIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaGVuIFJpZG9uZyA8Y2hl
bnJpZG9uZ0BodWF3ZWkuY29tPg0KUmV2aWV3ZWQtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdl
YW50YUBueHAuY29tPg0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
