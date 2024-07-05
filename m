Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B4913CFA8;
	Fri,  5 Jul 2024 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720174306; cv=fail; b=cimqbzKCVlAmjr6W6n4cJhRr+vycDegqk7106DcmfcCz1g0rd3bNh9ZLqPsA9e+QyPvVGMPAByP8F5vMcd9ZcpV9WDz2lHkw8MbDM4wxT/Mr+w3WrBsLhoxBd23+xKXA/rc3d0+3FPTBe2DLXgeNJL6wF6WQEZklPCNuWoGxQ1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720174306; c=relaxed/simple;
	bh=DUivASvDhfLqn8ngo2kcd+xOJ6jXkJzSN0fAXNJdx2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yc/h/sQbDxcJs2TTDJVqrAwPLHh7CAeAX+RKXuzGeLGzlJ6QJH7VK1D33t8vLtcJkNtsI4rxujjcWyLH7kdy6Ii6+1jj3fvW/MLbBdTwFI63Q+QbqxWbYuIsVOMwalcHpkTjBuyVh4KmtsPXtVnttpu2baPM8YSrCZ9VqxW5Ad4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=aFLPWOd7; arc=fail smtp.client-ip=40.107.21.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aFLPWOd7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AikNLMAdDowXc7MsSKMSu6/O0bH+xlM+4Ynzue8AsbgWccxzo+qqZi/HX34mR5Q8eLEaAkX39DUGZFXlvSDH7q2BLzah57g3kVjDXW0CeskmUfr2yUnrToZpiKl1F7uUh/2dxcse+7i7jBlovRdsE3oV2phG9y1LjykTmJpiKUv2HrUb7yYiWIidm6vYnChdpLq0jF4Zt+9nVFM/1AblkuSsyzWrGxItPAvQ0HfEoMdyYaYh1/td0YDc+Wh4Ut34w7O560T4QmjX4Naf4bT1atlyzFXzT8H69XWohq4sS85eMK7d3EgyNucmA3cdFYQu7Oi8uaCYBRNOX//OkCRfBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUivASvDhfLqn8ngo2kcd+xOJ6jXkJzSN0fAXNJdx2U=;
 b=FnA1bq15aYFZDCPCwdIF6mtLWR19AZ5eq63GPe58iBBV1ZTJmzZmctDwPZv8iJDeaFHqbJtgrZIB1b7Tqp0BS+moBN/ZOtDknXvo/kcjb+Hx75Ql9LldBBnkdrG5G5e5RMh8um+tMZX/12XUnWtTf9MXTqha1vijoh0BjL44CWsQwpczFFQALw+sA8DNBigKtLt3hy8H37i0ka06jKbZJma3qjO/HRpycSOWyEertuODgo3IrEMe2mb94yBaP8Cema7DLc8Yhu/TPvzL5lLrWUjr5Vw+3AXE37lJQgDNUqC6GRHD1MkEOKl7w4EEC/Ly6LVd4OS/zqcHlamfA47ppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUivASvDhfLqn8ngo2kcd+xOJ6jXkJzSN0fAXNJdx2U=;
 b=aFLPWOd7ZvbPN0W512xqGWBb2EjLPiSX/AgPByKpuBRy0JoRRB2a+onEHQQeSwicd+6R/MwWpO7aOl4Tfc2Dj9G1/MLFphP9xvrF/YC+A1XdPBZCeLhayGWVInJzjtDE4Qp7mAJswn028/BwlhMD0vwziGeSh88AXjr3LtkbeN0=
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by DB9PR04MB8377.eurprd04.prod.outlook.com (2603:10a6:10:25c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Fri, 5 Jul
 2024 10:11:40 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%2]) with mapi id 15.20.7741.017; Fri, 5 Jul 2024
 10:11:40 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Breno Leitao <leitao@debian.org>, "kuba@kernel.org" <kuba@kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
CC: "horms@kernel.org" <horms@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3 1/4] crypto: caam: Avoid unused
 imx8m_machine_match variable
Thread-Topic: [PATCH net-next v3 1/4] crypto: caam: Avoid unused
 imx8m_machine_match variable
Thread-Index: AQHazsO65NR3H4r1AU+O2bj4SR9fDQ==
Date: Fri, 5 Jul 2024 10:11:40 +0000
Message-ID: <ffcb4e2a-22f2-4ce2-a2cd-ad05763c91f4@nxp.com>
References: <20240702185557.3699991-1-leitao@debian.org>
 <20240702185557.3699991-2-leitao@debian.org>
In-Reply-To: <20240702185557.3699991-2-leitao@debian.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|DB9PR04MB8377:EE_
x-ms-office365-filtering-correlation-id: 2ff1cb8f-dfc0-4196-909e-08dc9cdadcf4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dlQ2V21KbFI5WS9sd2xyMnZVajUvMjdsbUd5WldzOXhadHZaZGZTSHJTK0RL?=
 =?utf-8?B?d1YxWjdKVW5ibEZ6MXYzMVZGUVpnRjl4RE1UNkE2QmZEWkNsY1NIQmp5WU9Q?=
 =?utf-8?B?VGJOTkdwbTNSWjhmeVdoVXRxOHV3VlVWTnBWRFZvV05iZ1lKa21ERkp6RGN6?=
 =?utf-8?B?NTlFU1pJQkZSVzVzTnUwMkdDYTY5bU9uWnBhdGFRdFBZUjNpYTAzZHQyb0ox?=
 =?utf-8?B?YXozcXFWckxyQjJQZTYxdE4zZ1NESlNndDB3MGE5VFcxU2ZHSjMyaVNhYlVk?=
 =?utf-8?B?VGFBSHduSlBWaUZjZEU3TDFleDlGRE0vVlU5YVFvYlNTRzFFeDNqbGhiS3Rs?=
 =?utf-8?B?aXFNRjZnRzk3MHMyc3l1azFPaE1rYWdpcEhBUGRZNDRtOUpsK3kveldCTEMr?=
 =?utf-8?B?TTU2R05kNEpuTllwVmdUU016MVBTdnYvNjF1THphSmx2dUdsSVZtb3I0YlhY?=
 =?utf-8?B?ZWNaL0xzcmRMR0hPWVFCQTNQalZwZGJndERXaVJDSERlUmhmTDF0WU1Dd204?=
 =?utf-8?B?U21PTk5va1NPeWJ1TWd5NVZVQU9nbjdFcEIwVWJxampFN052K3lQWDNOSGJs?=
 =?utf-8?B?YVVOYlk1eEx5UTNNRGtGdEZFNkNGRUxBVjdIdGhuK2VuYkdSdWF4UlZjb1dK?=
 =?utf-8?B?bFhJdDlKV20vTUM4allia3NRNnR1aWxpWWhZTXp6cHNnQjNhalNBRDh0NXI0?=
 =?utf-8?B?bG9jRGVXS0Vvc3BWQ3pCVWVhL3dvcUw3WDRZTGw4bjlGdnRIcEdlcTJ4Zmdl?=
 =?utf-8?B?VFc0QzZzZUZLYTlDYzVUaE5rdkhjTm0vSkJLWXZjbmx5aFBBczYrZkJHUXJx?=
 =?utf-8?B?eVZOZHR3M3FYOXdSV3NXYW5Ib1FvYTJTZ2l0bWJjM1oweU5qdEo0UVkvSnRz?=
 =?utf-8?B?VjJhRzV3VGg1RmNzbkh1TktFMkFTR05JWTVQZVRwTzV1WXJ5NGxMSTdNTFhS?=
 =?utf-8?B?Y01oR2lrVmJaQ3U5SUNtdng4aDJVb3hYRUEydnVxMVB2RUFYOFlacmozQnF6?=
 =?utf-8?B?WkJWK2ZTUnJtWmJFd3A1aXNGL0h5Z3JSZGRDc1c5a01yK1lzcVp1QXNyemk3?=
 =?utf-8?B?ZnM5b1RRYjdmYkZrSlRtQSs1WE1OMTg1Z0Y3UzhBakJQTDhCeENNQmxNaDRy?=
 =?utf-8?B?NkJuUzhWeVdxQlptdGg0Y1FhN2doc2R2ajFIRHVCaUo1Vm55b2JZUllBdGVt?=
 =?utf-8?B?bkdLcG9nWVJXTVlGYlVFaDFnS01nVFdxUVhYdWhNYlRBUE1makltVERvb2hl?=
 =?utf-8?B?Nmo5S1d3SnNHWFJuald0eHI4UXdRYTdqWHR1OE5TNTMrVmtmSVVUV3hoTEpa?=
 =?utf-8?B?NHdjWWpkVVdXOHROalRUcURtOFFCbG1FQjVRUWJGaU9ITHplRWdCbXVKSERy?=
 =?utf-8?B?TFRleUxTZEhpb2F5S2t3VmhDRzZuT1hLWGJIRlBINXNGd0MzUExqWFl5MlhJ?=
 =?utf-8?B?R1pIZFNDQUF6bG5KaVJ4M1AvZVBQanVENjFiazFMMjFhMEtxT3IrbEkwQlgz?=
 =?utf-8?B?VytPeFd6TVhMdHljS05NVWJDbzBhbnYyMWhNVVJTZW52Nkg5SU1ud29OMnhk?=
 =?utf-8?B?MFEwSGFwa1hNVGpheSs1U3ozM00rRVZFaTFXbmRXUVNpcWt4SmhEWFNraHdw?=
 =?utf-8?B?NU9mNGpBMHRueU1HRk05RzFxcEd4aXB6QWt4bDUyQzB2U0JOVzZZdGFSMDk0?=
 =?utf-8?B?UDVYNGhOYU1LZkFQNXZodUlFbDRKa3piM09DZDBhbmliRXh2bXFhNjBhaGt1?=
 =?utf-8?B?QkU1YnlCMFJPRTZXVHhJc1hCRGFCSk42VFBnaFNpamQrVFJDaTRCbjk4d0NH?=
 =?utf-8?Q?RuACDTCMnMPOvXad1eQ3RZ9iy0qVxa2HsJp2I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NDV3K0s5U3JOQ1FIalFRKzFMYm8xK0greCtPdjd3TjhJRno1ZVc2ZzRxbWR0?=
 =?utf-8?B?SFFkT2c1am9KVzMyMTluOGp0QkFRM25BS0pBS3BlaUJuRDJTWEhaRnJmYlRh?=
 =?utf-8?B?Sys2U2VKQlhmYWpzWGE5ZG1CcHROL1ZRcjdlRWYwcVIyTjAzRk92TGIxR1E5?=
 =?utf-8?B?UWNnZ2JjTTNEaFhjSmpoZGRiR1AxaXJRVk1iVDVQNVkzdnAwV1JIQW9GRy9u?=
 =?utf-8?B?anhaZm5HNzg2UTZaYlk0b0o0bngrYmJXc1dCRE9jQmpvZzljd1lIOXJQdXZV?=
 =?utf-8?B?YjN5dFA0UzFCTUdQTnB3QjAzemRIb0NTSTVTL2UwSmd5WHlBY0NHMncybjFx?=
 =?utf-8?B?bFV3MnMzSmdhQ2o2UXhhTW1RaEVsckxoSmVqb0RsSmlvSkVGaUNMajMwQTZR?=
 =?utf-8?B?aXZRTGQ0QS8ydXMzZitRVXZBRW5POVU0dmZmS25WcmY0SEdOZW9HYWE0bElT?=
 =?utf-8?B?UkNnYzRYVEMrZHBLdWVLTDZ3cVA5UkhLVHR4K1l2ZXVyNGJPM1B3NXN5UWxZ?=
 =?utf-8?B?TWlObVpvbjBEeUthYkNVZ3V6TGNFeEVIeE1vZWF4S3NZTlFleDhCMUJ3Rldh?=
 =?utf-8?B?amdvSGZ0endCMStlVElJSE0wZ1dCT0x2bzFRS1lSQkFsaGIxQUlROGFJbU9q?=
 =?utf-8?B?VmxLNXhyelZ5cm16VTE3bkxCaTdnd1RNQlVYQnFsL1FVcFcvcVdqSXVhV1k4?=
 =?utf-8?B?Z2wwcit4c0dRQXlRaXZ6R1BwRU5PbmdWRDFUNTlBRHZCVE80RncvUWlMeXNC?=
 =?utf-8?B?VlhpRG1KMUViYkNZWmY5MFlBSFgyVEpPSVNWVTk2UnU3aC8zTG51cWRKWExs?=
 =?utf-8?B?WDVmdWlHMXhDYnFNbWduUnVlUUV6YU1BMUVCeVRxelNKd2w4MkFVNUhBNEJH?=
 =?utf-8?B?VlVEUVkyWVF5NytETnozd1JtYWNqc2QxTTFjZ1hzSE41S05RUVNQNHo0Q2Zq?=
 =?utf-8?B?Z2JJMVNEazhwQVkxbmJ1UjZPRWxCZFdpQ0JudWprTlBSSlh0b1NnWERaVEJQ?=
 =?utf-8?B?S1YxNUJYRkJZZXg0NStiOUpkcmxWekJZS2dyOFhhNTVuZHBOM0V3aTFrd3Bi?=
 =?utf-8?B?U2RmcnBCd1U3TTgxZ0JGNmlkUTQ1NXNwdVhEMjdlcmdXV3VseDRwZmRpaEZ3?=
 =?utf-8?B?TU03MkJVMlY3amdxT3pwellzVTUvNVR3eFZIK3VqUTZYVjZtdUtkYlVIL3Yx?=
 =?utf-8?B?ajhadmV6VFEyeE9ETjc2VWoxKzR2ajhhNDBXSiswRG1hSzhLcDVBVUdhRy92?=
 =?utf-8?B?ZHFQQjBnd3J6NE81VmRMWHBoQjhuZDJQVExDVEcwY3F3M2JFVFB3YmRibE01?=
 =?utf-8?B?S2JCSi9DejkvRGV1TnlVY0xjNThXUkFzUVBxK3gyaUx6ZVNnTFhCM3d3Unh2?=
 =?utf-8?B?VXhxd25CeXFRMFR5Z2JyZ3JHTm15Znd1a3R1cHQ5STFZVmVNbUtLNHl6TzFl?=
 =?utf-8?B?OFErRVdKRUt6dGVmTXVOcWdNdFZYWmlXUWE3RmdVMVhudjl4NXV5YzQ0VU9m?=
 =?utf-8?B?V2pwNHdOSGQ1K0J5VUlmcEoveEhwQWZtaWF6SkJKLzNIdHI1djl3bU0vdk04?=
 =?utf-8?B?NWY3U0twSW1xQXo4NHQ2bjdwcGhqODJUcjhSK1l1dVFDblIzbUQ4RUZLUjEz?=
 =?utf-8?B?NmF4MTM5SmxONHIwSndGdnh5aUU4ZXZhUkxjazJVbXZPczBITjk0OUd3QTQ2?=
 =?utf-8?B?ZGRwMldLUnlGT1NTZW9VaUFkdFVOM0tZMFdEZlFuRm41YlZxSmwxN2pSaG9G?=
 =?utf-8?B?TVZoczRXR0NJdnRaMjVyTWxMTFFrZVNnUW9YbFpIMTF1d0lLY1hrTE9VSDJG?=
 =?utf-8?B?UlVVK2pqN3o4V3U2aU1xM2hmZUJYUzFqZEFMbURKQVI0enYzMlluTWpzOXdT?=
 =?utf-8?B?OXBjN2t6MTZOTGJCWjg5QUNkMDVMQXV6TkNPalFrdnVRQ2J6d0pnQ05sdXhx?=
 =?utf-8?B?TnhLM3p4ME9obGtKUUNwU0ZKTGtxbzcxSURoOWtzSldxNFRrOVhJVGR2UTlk?=
 =?utf-8?B?TDROZjE4aGZXQk15RU02dDQ2TWJVSW1JSzk1MUwxeThtNXhJZURFeUdGYjh3?=
 =?utf-8?B?REozMWU0aGZWaTgrdldDc2twSVBuR0MrbysrL2FZK2ZIYTBoNVhtUmVIbGpN?=
 =?utf-8?B?WDJxMDJ6UVkvT3ZIeDRTNVVSeVZjYlI5citJUU1uTlNWTHVmVDl3RlNQQURT?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4E7B8E8D860874996D0BAEA841E0EB1@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff1cb8f-dfc0-4196-909e-08dc9cdadcf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 10:11:40.2937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ldLxuL+18k0MZb/6L9Kf8ViyoMWbjDccANbJglQC10LBbIbs1sznUGejPfrkma8YBjySt5mW/FMb5U3q4oiVAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8377

T24gNy8yLzIwMjQgOTo1NiBQTSwgQnJlbm8gTGVpdGFvIHdyb3RlOg0KPiBJZiBjYWFtIG1vZHVs
ZSBpcyBidWlsdCB3aXRob3V0IE9GIHN1cHBvcnQsIHRoZSBjb21waWxlciByZXR1cm5zIHRoZQ0K
PiBmb2xsb3dpbmcgd2FybmluZzoNCj4gDQo+IAlkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYzo4
MzozNDogd2FybmluZzogJ2lteDhtX21hY2hpbmVfbWF0Y2gnIGRlZmluZWQgYnV0IG5vdCB1c2Vk
IFstV3VudXNlZC1jb25zdC12YXJpYWJsZT1dDQo+IA0KPiBpbXg4bV9tYWNoaW5lX21hdGNoIGlz
IG9ubHkgcmVmZXJlbmNlZCBieSBvZl9tYXRjaF9ub2RlKCksIHdoaWNoIGlzIHNldA0KPiB0byBO
VUxMIGlmIENPTkZJR19PRiBpcyBub3Qgc2V0LCBhcyBvZiBjb21taXQgNTc2MmMyMDU5M2I2YiAo
ImR0OiBBZGQNCj4gZW1wdHkgb2ZfbWF0Y2hfbm9kZSgpIG1hY3JvIik6DQo+IA0KPiAJI2RlZmlu
ZSBvZl9tYXRjaF9ub2RlKF9tYXRjaGVzLCBfbm9kZSkgIE5VTEwNCj4gDQo+IERvIG5vdCBjcmVh
dGUgaW14OG1fbWFjaGluZV9tYXRjaCBpZiBDT05GSUdfT0YgaXMgbm90IHNldC4NCj4gDQo+IFJl
cG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gQ2xvc2VzOiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjQwNzAxMTMwOS5jcFR1T0dk
Zy1sa3BAaW50ZWwuY29tLw0KPiBTdWdnZXN0ZWQtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEJyZW5vIExlaXRhbyA8bGVpdGFvQGRlYmlhbi5v
cmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMgfCAyICsrDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9j
cnlwdG8vY2FhbS9jdHJsLmMgYi9kcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYw0KPiBpbmRleCBi
ZDQxOGRlYTU4NmQuLmQ0YjM5MTg0ZGJkYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8v
Y2FhbS9jdHJsLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4gQEAgLTgw
LDYgKzgwLDcgQEAgc3RhdGljIHZvaWQgYnVpbGRfZGVpbnN0YW50aWF0aW9uX2Rlc2ModTMyICpk
ZXNjLCBpbnQgaGFuZGxlKQ0KPiAgCWFwcGVuZF9qdW1wKGRlc2MsIEpVTVBfQ0xBU1NfQ0xBU1Mx
IHwgSlVNUF9UWVBFX0hBTFQpOw0KPiAgfQ0KPiAgDQo+ICsjaWZkZWYgQ09ORklHX09GDQo+ICBz
dGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBpbXg4bV9tYWNoaW5lX21hdGNoW10gPSB7
DQo+ICAJeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14OG1tIiwgfSwNCj4gIAl7IC5jb21wYXRpYmxl
ID0gImZzbCxpbXg4bW4iLCB9LA0KPiBAQCAtODgsNiArODksNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IG9mX2RldmljZV9pZCBpbXg4bV9tYWNoaW5lX21hdGNoW10gPSB7DQo+ICAJeyAuY29tcGF0
aWJsZSA9ICJmc2wsaW14OHVscCIsIH0sDQo+ICAJeyB9DQo+ICB9Ow0KPiArI2VuZGlmDQo+ICAN
ClNob3VsZG4ndCB1c2luZyBfX21heWJlX3VudXNlZCBpbnN0ZWFkIG9mIHRoZSBpZmRlZmZlcnkg
YmUgcHJlZmVycmVkDQppbiB0aGlzIGNhc2U/DQoNCkkga25vdyBteSBjb21tZW50IGNvbWVzIGxh
dGUgKHBhdGNoIGhhcyBiZWVuIG1lcmdlZCB0byBuZXQtbmV4dCksIHNvcnJ5IGZvciB0aGlzLg0K
U3RpbGwgSSdkIGxpa2UgdG8gY2xhcmlmeSB0aGlzIGZvciBmdXR1cmUuDQoNClRoYW5rcywNCkhv
cmlhDQoNCg==
