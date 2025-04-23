Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011009.outbound.protection.outlook.com [40.107.130.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DA75BAF0;
	Wed, 23 Apr 2025 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400128; cv=fail; b=kKUkd0Y6ANDkUeLHGOM6nw3wvcBaJf6Ql5z4eeQDeGXTIsgYcVkKX86qrg/EJXcibAhzrSUNjD/R1qZsaud1qAdNJl3T7jkOmJuBm1WIscKUetX0l5Ftj9G6zJFs2L+WEXcUl6ab4FwjJlXheX+KSfgTVw6m8okockphJK/T5eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400128; c=relaxed/simple;
	bh=4gRy0p45qwiDtw1MBIRR1Azzml/kLsQUNGC+c1i20AU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sQFbuGIstdm/jeHRrtY/U3b7hDVThrfCY/CrwnAPp9ZPspY5rnIPHdCYWeT15hL12+FJtn8Kh0EbYEXD98fSHYXuZzN65NQx0kVusmoJ7sFNLhUEuKVlfNp9qcZKmdzUTgHwsItryquVPb+ZTpuglfvvaesaLLivB6Wz3jW7Ulc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=dL4tPncO; arc=fail smtp.client-ip=40.107.130.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="dL4tPncO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8Su7iUUKdL4FDIRaAxxnkLpH0PwkOYefJiwTBEuNPOFeYu9e1iJ3IkCa/zqfDXIfOUzM70aFiDWSRNnQb2+kntTv/Imx4yDzwPcEocqoxxJ8QhMVFKx5NRHcsjjFbUNRhJY2+N2NMzSrLFlo6+Ic92LCwg4BtPPB8UihX1oIprMt5DwwWu+AlZ8DzgpDhLNFdQFeuVsOpeJRLj9arX4s4ayagAzj32auEBMx5nhbOrSqmRlDAfxDaRgM/354hr/7YpplQTCUL0zcOY1M1FsuvDOw/SKcuCvPJW5Yt1RmjhFDuDCKFIqPUhoG6XAJ9T/Ae0IQ9qLaCFJHTEsvExepw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gRy0p45qwiDtw1MBIRR1Azzml/kLsQUNGC+c1i20AU=;
 b=IcseOS3zGAl/HfoUCplAMgfJ9uM3QoroFWXIs9/F6Bq00E9iiaNrZu9aRazbdxBIChFXA9FjqrfXAtCXKNsSNmRGDWR4yuu1AJZmee9BqG0xaPg8rQ5jA6kj1jzZcIzppeksP3xpGcW1pFUokbuMDznd5UukhVSjL5TKZuEwF3B2CrXbleLRVMtvuZlasN8VeVpl5KJxkC0VEeBL8y36h17ZSXgws7uEuHzi2vVnmC+UUJhZSyRU7AmndXwkobEXrEuumBF4D3lmKF+JmbPyY8L6vsK0Wg1Dq0M4ULxDscfXOvGCoXEJ2NxqmJKqKnNBjf73n0r01zwgaRltCMyzzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gRy0p45qwiDtw1MBIRR1Azzml/kLsQUNGC+c1i20AU=;
 b=dL4tPncOONMEcpyIh9MRt1yf3+3sBY15ybLvprzj56oP8rqGXtMfJH7JOHXcBy2Wu+3Ms966Pzqg55o0crNZgn0g1qZImx0QTiJ1n98+jz9jyBxpR+bpCwvvo20qhkVO+6BxrJDzOSbc28hS8Mz2ek2YvIb6H0zxV0ZrJDN4QUip89m2zyTtbqLK07GT56lYmmI4gcpz4gQzXoolJpO2XlEoZtr/dQ+nGqamBxK4x03jJr2L+s//uxQhikoOEabGmoL9FzyKzGKTjsElH+2QuMC8ThNNFM5EWBuFy1q7CksrU7I57IiIIfGzbzPYLDGRMpYO8xOhzp6ToNzVlRQKTg==
Received: from AS1PR04MB9697.eurprd04.prod.outlook.com (2603:10a6:20b:480::9)
 by AS8PR04MB8836.eurprd04.prod.outlook.com (2603:10a6:20b:42f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 09:22:03 +0000
Received: from AS1PR04MB9697.eurprd04.prod.outlook.com
 ([fe80::9ec2:ecb6:b719:fc03]) by AS1PR04MB9697.eurprd04.prod.outlook.com
 ([fe80::9ec2:ecb6:b719:fc03%5]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 09:22:03 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Pankaj
 Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] caamalg: Make use of dev_*() instead of pr_*()
Thread-Topic: [PATCH] caamalg: Make use of dev_*() instead of pr_*()
Thread-Index: AQHbtCGAk4k2ktiuFkGpyqjUY1W+37Ow+hQA
Date: Wed, 23 Apr 2025 09:22:02 +0000
Message-ID: <dbf1577c-220d-4eff-bc1d-649d0d70678c@nxp.com>
References: <2025042122-infrared-bumblebee-b2d3dc@boujee-and-buff>
In-Reply-To: <2025042122-infrared-bumblebee-b2d3dc@boujee-and-buff>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS1PR04MB9697:EE_|AS8PR04MB8836:EE_
x-ms-office365-filtering-correlation-id: b4d4a8a4-6c04-479c-36cb-08dd82484efc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?eGkrL3J2REhwOENXU1BlZU9BNVZ0T0Q0ZG5QYWZwckpvQzFhY3kwV0FRTU94?=
 =?utf-8?B?VHhJL2NZRmwyZzgyRW5ib2hWcmd6QmtRLzZVMSthaHNkQTlVREI0QW1MYlhI?=
 =?utf-8?B?YzlGaHZqcllOeTFVckM2aHdEV283SitCcktkRUtZZXBzVU9HR2o3MUh2ZXZh?=
 =?utf-8?B?bGtTMS9zVWJOL0phMXcya2Q5QjRLUy9KSktYSzd5ajB0ZVN0OFRpWHJ3Sm01?=
 =?utf-8?B?K2t6eGlNN1JweG1hMHkrRXV6b200bmlJY01LZkVvS3d4TVMvVDUyNnFpeldu?=
 =?utf-8?B?dFJlU0dLZUZUU0RLZGtPSjdpQUpNY3BRMVZQVlFNOXlJblNrQkJXN3AzRkhk?=
 =?utf-8?B?VXhJVzcrZWwwNEFyTmRsemNIQ1lZK25uQUFCK2x4WUJaajZDNFoyNjJXMjA3?=
 =?utf-8?B?QXlMeTFEYzJkeGdFNW96UU91Z0ZWVGNQbjdIRkJaUmV3UGFTd3VUaFpwYkww?=
 =?utf-8?B?dGpNK01qM3h0M24wNi9yT0xSUDRHOVhvUWNweUFWZElJOWJ4U3NvZHBOa2p2?=
 =?utf-8?B?eWtOdjVrNlk4cmRiT3NYVWVZQTR5U0dXY0dENk05RThsK3FqWmNPbnVtaDhC?=
 =?utf-8?B?bjhBRElscFhDRUZmQXFxV0tQM3FYNmo4cUJhb1V0OGU2N0tXUWFpN1ZiQmdu?=
 =?utf-8?B?YWNDemJrYldKTUdZUlBVbDZ2MFppb2hCNWZUMXVXckxVS1ZzNk1QVk9HUklv?=
 =?utf-8?B?YTFxK0NjRG9qTzdqbUd4MFphMVFQUGlSTVhlWGFtTTR3dFppNjRBMWNpejhK?=
 =?utf-8?B?UG5XMWc1ZzFzblJNV2lsMHhxOW00VTZ1WWVCQnUveWdPL3hBM3FoblpCd0t3?=
 =?utf-8?B?TkQ1emFmZGV2cnF6SllIMEN3QkljNmlGVzNTeWhGNWp1VTh1YkQvaURVWjJV?=
 =?utf-8?B?VzRYRHJuQ0hoRVBZNTRYL3ZhVEEzcklWMkM3d2VrU0tPT0MwV1lLSU5OZVJq?=
 =?utf-8?B?MnVUV2ZHT0hSd291U1hOYUxCc08zT2Vodnp6VkhHKzdJRDFzNkVMKzRWMlNs?=
 =?utf-8?B?RXM2VkNTb05SWlYzTVRvVWJhaWpCeEFjS1h4R3JoZWRJMEs1b1FzbmtvNnhr?=
 =?utf-8?B?MVFvZ2QyNFJmN0xvZ2xPc1FLS201aHBQNmIydGRYZTcrUVdteXIzWlRMSSto?=
 =?utf-8?B?bEhoQy82K3pVcnpiSGRrbGlyaWJuYnJQb0FZNkhCR01yQlA1aUZGZ1NuYTgy?=
 =?utf-8?B?UHlCdzg2bU5jVHdrSHdQSk05VS9zbmIwdlM1M1FsOUJDWlpVZitaN3Q2VzlJ?=
 =?utf-8?B?a0h0NkE5UWtwTU9aZ3ZZRm9DWUtVc0NtVCsxckoxOFRpWlNOVEJGRk1MTytE?=
 =?utf-8?B?OWFqTVVXWFR5TTh2ZUVNOGl1UDNDcnRNSmdMQ21yZDl3Tm9WNzJ6RnlsZW8w?=
 =?utf-8?B?RVpPK2xRbW92eDBCd203c0MxaXB3QkhNQVY5RHhVSmMrUnNMc290U0hSYVM2?=
 =?utf-8?B?QU55SDVnTzhWdEZsb1dsUUJkTCtBUEdHVGJ6ZmJRQkMrNDdydzNqVjdMdW1o?=
 =?utf-8?B?ZngzTElDOTdYbktYQmc5TWpWY1VvYXV6elJsZEFHOGdqYzdhVlI1dURGaGR5?=
 =?utf-8?B?RDJpTVNQVFZsSUZmRGk4V1dXd3Rvc0U1ZkUvejdRSERwbHBtMnkzZGM2ZzlN?=
 =?utf-8?B?L0ZRa2tDc1gwWndxanAydVkwQkZjU0NVTzVxV20rRFhhaDBDdEVacnpjM1JH?=
 =?utf-8?B?QURZWFNwODJ6YWlxYmVoVFpwLzVPRHN0c1JEMmtYREF3MWlDdDh5YmNrWDRq?=
 =?utf-8?B?S3NxWk5tc25lR2oyMkVtZGE3VWpWQmEvNzRHOENpNjRqOTVROGJxK3U2WEFT?=
 =?utf-8?B?NkxGclMycUFPaUlMVVUxcTNpc3duem4rdFp1TzNsVHlXUVVvRmJpb05EWEEy?=
 =?utf-8?B?SXRjNjN5Y0dNa2lqWG9QTThrWThkaUYvYnJ5ZXhjcFdDWGJyM1BZdzVmcG5O?=
 =?utf-8?B?TmlxbGhOWnIramlMTEo5Vk1iWkh4dlNOcFdaY3JaeXRpRHJWalZ5YjhaNjA1?=
 =?utf-8?Q?BmLLH5SKeH4iQZrPJlvLYMcfL/5iTk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9697.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eGFDZ2VveHZpZndFUy9HYWpURFk1MWRtakorNmxJZFhCaFFUUXlzb0RzWUlZ?=
 =?utf-8?B?VHg0R0N2YVJlckVTQnFRcFVKM2NmOXY5alZLSTJuUUU3aStOcUVydzdBR0h0?=
 =?utf-8?B?eStSTU00WUhDcEdUK0hsYzlkdy9qaitLbTRxVkZ5cXFudlIyb0Y4VndidGJw?=
 =?utf-8?B?UkpmQ0RhcVFZUnBzVGg2NjYwWlc0L0FqYXZKZ2s4NGFHNGRjaHVSWWpPKzdF?=
 =?utf-8?B?L0J6bnRhNHhTcXEvTk8zUmZOcm9SdkJST0JQcy8wTVhTc0xBTVBpQmF3NlFs?=
 =?utf-8?B?d2VGTnUxWmhNYjRXN3RGSzFQc0M4MVZQL1cxODlLUkdlVXJBSFh2TFJueVJU?=
 =?utf-8?B?ckZBNEtyTStMM2l2RUVMNERaQS9IdEdDd29nQm9xZWt1RjJBc2IrNTFhZEUz?=
 =?utf-8?B?eVorYnQ0ZWNYMC9yWEwxT1p6NEp0aXJTam9GTi9sUEVsYWNHMXcremp1SGFG?=
 =?utf-8?B?UWJGOTg1enBUa1pEYTNGY3RLM0o5SmsyTGNaVis3MGl3K3NZNlBZNTJzTmZC?=
 =?utf-8?B?TEZYS2NuVmZzeUVzQzE2ODZTMXdMdDJUTHJyOVVidCtETjdmMGtHR1daeVRh?=
 =?utf-8?B?QUhIOVRTQTR3VEg4RkNxUTNXSzhHWmZHLzRXNi9xb29Fc2pOSlF0RnlIMVNP?=
 =?utf-8?B?RDhNT3ZPL1RuekV6K1ZyWEVNSElWNFpILzN5RnQydW13VmkvWDdYeHp5ZXM0?=
 =?utf-8?B?NW1JL09PYldKNWt0QStmV3AyWkJTL3dCd2NqWTc3NEZMNmdLVkpwTlNNaEh5?=
 =?utf-8?B?cVdkM2JzaTUzYTFsd093dFMxWERwYTBkRHJBd1N4M0hlWlk1KzFOb1ViNWta?=
 =?utf-8?B?UEM4TG1uVjNtaDA1Q1lpS3MxcXFJcjJ2RzlrNjVib2J4ZUdBQnFTQ0tsUUhY?=
 =?utf-8?B?OUtOTDd4aVBtTTZIUi9kYjR6bTFPZjRzOFcybDZLcUo2ajdNVWNDWUZRcFUz?=
 =?utf-8?B?aTNNSDlXN3NqRy8rdEZEUDM0cmRubzEydTlRK2E2QlhBWElad1pvRUVDWkdV?=
 =?utf-8?B?TlhYelVvUU1RWUxWR3hvR1VoWm5DQnFydTZlcmJBMW9RMG14WjgvL3dKVWNX?=
 =?utf-8?B?TWd5NTh1WEloNTdWRDJ5eGxGdWU0aHdmZEdLK29XTUpXMjNVa0RDSUVrYmRS?=
 =?utf-8?B?T0p6c0JhcXhFaFdxKzZYV1ZzNVE2VXFqMEFEamNZMklDQWxIYXFnWXNrMjJT?=
 =?utf-8?B?WUJtWWdFcWszUk83dTIwWS80R3pGYWZLMm8rL2VrckNUSEZtVHcxWUIvc3NF?=
 =?utf-8?B?R0hjY0hmbDJ1ZmIzNmJFdzlBQkJvNlZmM2s3VUVUTGE4SFRVNUVBSzJ3RC9U?=
 =?utf-8?B?dndkZG02MllNUzVFWkZYNGhINzdKN3BXYWJwbHRZUjVFYW02Rkp6YlUvNmJa?=
 =?utf-8?B?RlRoY0pOSUZEaVRDTG9aMU1pVmdnbFJVdHJkSFk3YklKTFppc211ME9uMjdJ?=
 =?utf-8?B?VWZhU05rV1JqS1BOdmp4eFVLdXFEbmNKTU1aMndIbmRZRDQwMVMxYjdUUzNk?=
 =?utf-8?B?ZWJ1bmZObzhXWHozN3FhM2ZxeURxWmJxUWpLZlY0QVRjSy9GbXhKNkZ4L2N1?=
 =?utf-8?B?bzBEeUUvbGV6Tk8xT2hsWkg3U0FWSDBWMlRBTDByVjdjOUJkemVpNzFXSWho?=
 =?utf-8?B?c2dTZ3VmZ1FodXZPVW9UT0Mya3Z6RUJ1TCtZRFJBYXZYY3d6NUlGc3BsQkZS?=
 =?utf-8?B?YzE5cGtzcU9JK1Yva2l0MnFjL3hERVNzWmpuYnBVSG94R1RUMzVnbDVoTWUv?=
 =?utf-8?B?MUlWOGdNYjE3OWRqNWdxaXA0YzF0WjU5YmdJaVRVM1lJeno4eTIzUWtDVmNX?=
 =?utf-8?B?UGEzbjBtb0hDdWV4Rnp1UGR0RklzczFRVmxzTTc1SXk4T21DcTh0eGVlaDV2?=
 =?utf-8?B?QzhZdVZYYURIZFZFN1BZWkV3Sjk0eGtZSlBlYzdoUXUvMGs0Rlk4dWtVTWM1?=
 =?utf-8?B?NVFhNEhHUmU3bXdNWmFvMXRtSEwwWS9ZUW1EM3RXeEYrOTN2YitobXROdU9C?=
 =?utf-8?B?eGRHdForWURVeTlnSzhvOEMvWGxzSzhjOXVGbnAxQkFEdFlBZGk1RTNUcDI1?=
 =?utf-8?B?VG5kWjFqQTFKc25lUEg4TWdiNWFyZDRVbjIyM0Z1aTROZUxsZ2FQVTJHb3E0?=
 =?utf-8?B?eGpCcDhLcldZaExsaFZobE1ySFJzRFFENjlsNENLdCtPT1RGUWc5M0YwY1JD?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA309D565E18404B857100E04FD8FFAC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9697.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d4a8a4-6c04-479c-36cb-08dd82484efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 09:22:03.0249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wYwvYzvN7Br+g7IJ0SY8COiHi0fnFYYOAdaqLeOrS9FzqOhroKLRNDDrLdzQfBdb3ELIrWn6DbnqIYttPJ6m8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8836

T24gNC8yMy8yMDI1IDEwOjI5IEFNLCBCZW4gQ29sbGlucyB3cm90ZToNCj4gSXQncyBuaWNlIHdo
ZW4gbWVzc2FnZXMgbGluZSB1cCB3aXRoIHRoZSBkZXZpY2UsIGFuZCBlYXN5IHRvIGltcGxlbWVu
dA0KPiBzaW5jZSBpdCdzIGFscmVhZHkgYXZhaWxhYmxlIGluIHRoZSBmdW5jdGlvbnMuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBCZW4gQ29sbGlucyA8YmNvbGxpbnNAa2VybmVsLm9yZz4NCj4gQ2M6
ICJIb3JpYSBHZWFudMSDIiA8aG9yaWEuZ2VhbnRhQG54cC5jb20+DQo+IENjOiBQYW5rYWogR3Vw
dGEgPHBhbmthai5ndXB0YUBueHAuY29tPg0KPiBDYzogR2F1cmF2IEphaW4gPGdhdXJhdi5qYWlu
QG54cC5jb20+DQo+IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+
DQo+IENjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IGxp
bnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1hbGcuYyB8IDEyICsrKysr
Ky0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1hbGcuYyBiL2Ry
aXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZy5jDQo+IGluZGV4IDJjZmIxYjhkOGM3Y2YuLmQ5NjRh
NjJlZjk2NjggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZy5jDQo+
ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZy5jDQo+IEBAIC0zNjMzLDcgKzM2MzMs
NyBAQCBzdGF0aWMgaW50IGNhYW1fY3JhX2luaXQoc3RydWN0IGNyeXB0b19za2NpcGhlciAqdGZt
KQ0KPiAgCQlmYWxsYmFjayA9IGNyeXB0b19hbGxvY19za2NpcGhlcih0Zm1fbmFtZSwgMCwNCj4g
IAkJCQkJCSBDUllQVE9fQUxHX05FRURfRkFMTEJBQ0spOw0KPiAgCQlpZiAoSVNfRVJSKGZhbGxi
YWNrKSkgew0KPiAtCQkJcHJfZXJyKCJGYWlsZWQgdG8gYWxsb2NhdGUgJXMgZmFsbGJhY2s6ICVs
ZFxuIiwNCj4gKwkJCWRldl9lcnIoY3R4LT5qcmRldiwgIkZhaWxlZCB0byBhbGxvY2F0ZSAlcyBm
YWxsYmFjazogJWxkXG4iLA0KY3R4LT5qcmRldiBpcyBub3QgaW5pdGlhbGl6ZWQgYXQgdGhpcyBw
b2ludDsNCml0J3MgZG9uZSBsYXRlciBpbiBjYWFtX2luaXRfY29tbW9uKCkuDQoNCkFjdHVhbGx5
LCB3ZSd2ZSBmaXhlZCB0aGUgc2FtZSBpc3N1ZSBzb21lIHRpbWUgYWdvIGluIGNvbW1pdA0KYWI5
NWJkMmFhOTA0ICgiY3J5cHRvOiBjYWFtIC0gZml4IHByaW50aW5nIG9uIHh0cyBmYWxsYmFjayBh
bGxvY2F0aW9uIGVycm9yIHBhdGgiKQ0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
