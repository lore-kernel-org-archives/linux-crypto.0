Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7631AB8E5;
	Thu,  4 Jul 2024 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720089577; cv=fail; b=pJJzLUC2vAgixk1C59PBEijLffIXNRGJEJk+9iuEEhR3qjQGbyvik91FNpndkujdPyTmF7VJktb+vRjIxKaAj4zjv998oqtRV3Vb3CZL4Vj8pamxnKOJrP+FRiw7KhRT1AqMjEN7RK1omWC79SAAV0zSFbYbCRGd5G9idFvZqlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720089577; c=relaxed/simple;
	bh=3kqcqQqjTHnmD2HXk49j19twVn5wN3kr1SecvUhrtHU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T1OT4MJEDFG7cAuF862m3qAR78Hp1XMkGXy0fBhsLosdUA7DbnBu1YQbxWWcLwp6MbCXnjPnTQnM25Xotmc6jj3G1HD80IdV4TPcbK+g45oZRphZ+1wgX3Ly7hY7Wyri0QQCuVuhzTEauxSdcEi6wFDWP1AOn7b08Rth8Y8/KW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=GCbNH4On; arc=fail smtp.client-ip=40.107.22.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GCbNH4On"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaldoyyKo6xS1nZ0D36i6SBKQvgXYx+NQKnRHkrjynnPn9v7py77hHGpdBBFFt6M58yrB/tO5SkDTWxd8xx1aBGsNFEtSLWF3mBUHSRogtNclhK1zlbUR6eSFd/Jt2ark2eenmPw0vPqyYn3MY9M+uZMZiSPTKTki3hhZdod15wPxNQ/31QYZTv757j7Dz3jxk9dLZl9qDxKU9iOJmm0rDDspzOHJPs2SMtgxnNhyfNv2UxpmQDRYPzSD8ESd+jbhodzmanrnXEbCW1RRFREUieS0Yzdx/HG8qd3yGh0LbPnuT7ZD6LmgDb1Pl9aFb+0X3UjtQ/onZTYwVAPTYGzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3kqcqQqjTHnmD2HXk49j19twVn5wN3kr1SecvUhrtHU=;
 b=ApPk90dBJdwBay4vneUdy1sAt/rP/HL73powYQa2Uw6b9uUTbkIoZurKy8zm6K/VHMHLJcxVY1N5CsA/f9tYAR7mYnF7YCXIZSxVS0Ve7k8zc4XbnWYU9zBNIHJIr9kVh9SM/Jwnv1jgCulFqh7DV9x6j1bSBfRm4Cr0Zpp4nr8kc4EzM0S3eihRw1+JMe0A4lZv5PMMPjy9WqunktiuswF0CfXGiCFVh0EuSyUnS2XRJ76n3/mBayYsbkibmoV5/ToDbpXl0K3sNQUwuCu9cch7s/WI82rD3eQkq0CNj2OdWvLNQUZAcQNmzL27VzFQ/2BCcGBEWMZJ+/Xpyg27aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kqcqQqjTHnmD2HXk49j19twVn5wN3kr1SecvUhrtHU=;
 b=GCbNH4OneqazOYNRCQtvn55vZW9mN4n1JYfjr8+7oT3hzxqnRBOr8kJrMYpIV7z3TnYfxiBQ4UqDbsq9AeXuv5BEneMizgdfDGK4Se0v/oZKq7m61SbDj0Q9OOxW42ARBJaygHUCR2A58AROq5UvwbKZiU5Q91ku4kqfQgGQTmg=
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PA2PR04MB10278.eurprd04.prod.outlook.com (2603:10a6:102:408::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.37; Thu, 4 Jul
 2024 10:39:24 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%2]) with mapi id 15.20.7741.017; Thu, 4 Jul 2024
 10:39:24 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>
CC: Eric Biggers <ebiggers@kernel.org>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qat-linux@intel.com" <qat-linux@intel.com>, "heinzm@redhat.com"
	<heinzm@redhat.com>, Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Varun
 Sethi <V.Sethi@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain
	<gaurav.jain@nxp.com>, "davem@davemloft.net" <davem@davemloft.net>, Iuliana
 Prodan <iuliana.prodan@nxp.com>, Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Thread-Topic: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Thread-Index: AQHZr19tOtB5iqIpoUCbK9tS8Cwo96+rmzCAgAAMzQCAABCvgII85XIA
Date: Thu, 4 Jul 2024 10:39:24 +0000
Message-ID: <b20dd7d0-2f36-4208-8dc5-f304a7bd1a1c@nxp.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
 <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
 <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
In-Reply-To: <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PA2PR04MB10278:EE_
x-ms-office365-filtering-correlation-id: 7a453295-404f-4647-c20d-08dc9c159261
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aTQwSmRldU1EM2pOWTA2Q2l4VFc5UzNzY0dsOWIwVDI4UU8rRDJjQ2JKNm9x?=
 =?utf-8?B?SzdjU2RiUFU3WDRpa3pxdllMVFhxL1FoaUVqcXdJUUtBdkhwUENhUEFjMjZC?=
 =?utf-8?B?aGJPWGU4a1dPRFdNbEJjdlllbXhlZXk3V2FYYWUyUTY3bldRTmZFTnVJN1Fy?=
 =?utf-8?B?NllTZzhKZ1VEaFhyWXowRjBqSzBjRHpRV1NxZnJrODdnTlBMcTJvU1dyQU1M?=
 =?utf-8?B?cVRFUVRySkVjU29NVW9URys5bkhydkpHUWZjR1owbm5VNVQ4cGo2WCsyVWg4?=
 =?utf-8?B?VEdzeUREc2dvMGdPc1NCWHZmRWV1WVkwTGZZNmpqdXN5bFJpMG12OFZ3ampI?=
 =?utf-8?B?bGZ3K0VqRE1WRXpQZVQxZ2pCUWtzWmpYbEZOYmZ4SERaLzRvRi85aEdUOFZt?=
 =?utf-8?B?UlpJcUxEUW5sUzl6dGE2Mk9iZjRVRmRLUGcrS201cVhmUm5nbXNUTFoyeGtD?=
 =?utf-8?B?Tm5HZ3dHb2VaTEg0QXdUSGcyZDJGTFpIeTJsOCtMT1NjbXN1OURzbFJSdzRt?=
 =?utf-8?B?SmhCS2lYc0ttdzFscTEvS0FUK0RNZ3A2S2lkZkpQVFlKM256RG5pOXE3a1R5?=
 =?utf-8?B?c0JzMjd4THdVYm1vRm5tOVpYdHpCQVpGSmtSeFVrcmRsRWRhekZMZTFVbHZh?=
 =?utf-8?B?eXdkSlZWMUtHNWVJKzAveWpPc21NY0FLUUNpcXg5L3Fjd2pjV0ExcVByTnBW?=
 =?utf-8?B?UXB3NFQvTk9FSzVjNTJMUWZhcktXelIyY25FOEo2d2RhQTJkNlRPRTZKaVhF?=
 =?utf-8?B?THhkZktCWFdmOUkzWTU1Ny8xVnlLV3NVMU9vazZSVVRFZE9XdTVmVmR4b0VR?=
 =?utf-8?B?NFlVRHJDdHdtMzhYNjcrODg3RGY5bWNLeUczMzgwZlBiKzNqL1A2b25qWURy?=
 =?utf-8?B?OSt1M2I1TFNNWWFMS1Q4dVRlVWZYeXFxUzJVclo5akdxSkcxNEU4TlVqRVhI?=
 =?utf-8?B?Y1dTZEE1VlJxUDNIWWg4MkJjYjBwNVJ3UFVncEVMV0hrNE5nRnJtcG1kS2p2?=
 =?utf-8?B?VFAweVoyVzYzMzVnVS9kNDIzK0c1cGNLUEdnQzRVWXJoRzhGY3pIcnVHUHJB?=
 =?utf-8?B?NG9NVGpSRWVlMFROOWJPZ1NHb3pjZkFXTEppWC9YZWk1ZDkrT1hXckN5bkZt?=
 =?utf-8?B?MExjUjJreEhmN2p5VHUwL0tXYjZSQk1NbWo4alA2QSt5WWtzUVphb1A4cHFr?=
 =?utf-8?B?QUdvS25vZU4yZzl3ei9BWjFWcUpmTkpQQlF3RFU2K1NPWFFsRHlOYmM2Wmhq?=
 =?utf-8?B?dnBXM2lyYkFNY08wUjhvV3lmQm9LZkxEUTd4WEJBRW1TMXdBdFBYT29SVGhj?=
 =?utf-8?B?MkgybXE2Lzc4R0p3VmdLMFpGVy90VFNxRDF1WlNTWDhMTzVnTkRiK2F2TFdt?=
 =?utf-8?B?U3lveHVvU3hnQ0tNN0t3K0R0Ry9iLzRQb2UvNlNWcXFOaW1vNzRJU29OOWRj?=
 =?utf-8?B?UkJhTS9lbEp0aW8zNjlWUFFaVWpTa1J5MG5xdnV4bW80aWl4V3dXbGxudmd6?=
 =?utf-8?B?Kzd3b1c3UHJhOHdDenozZXdBdnRZdTVNTGtjcElnSUJjMDh3NUVnKzBBOGVW?=
 =?utf-8?B?ci9OblFYWEtoczVjUWVlWkFWbmEra1J6Umh4b3ROZWl5YjlkZmg3UHlMelg2?=
 =?utf-8?B?Wm5sZUhVeEQwdmxaSGdsSmdXZ05GM3pwWWg5c1JyemI5amNwZXk3MGI0OWFr?=
 =?utf-8?B?V1FDeEJDVXIwdCtJZm1SK1YwYldHdFZnT2ZqVzQzN0ozV00wdm9PTTczMENp?=
 =?utf-8?B?di8va0JQL1hzOEd1a0FoQjZ2UTN0Wlp6K1RaaC8xeXpiOTh2bDBUY3hDT2NS?=
 =?utf-8?B?N2FaT0hFYjFvUG1FN1lTUjF0SzlDY2UrZDNmZUM3M29Td0RMbGs2bitvUGFj?=
 =?utf-8?B?V2YyTmFweGQ5dk84OFE5R0lOYm1meVFwcjljeDZTTVVsMXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VTNvZVdabnNGcTQwZ3AxanltcmVaRmVaQU1PbWkzSnlBeStqMlUvb2dlTGRB?=
 =?utf-8?B?ejRKYTJaNk1Na0M3YnZhbjBlWnUwVEpvUWh0ZW15aVVjNjlUUmwxWjh1V2gy?=
 =?utf-8?B?bUpNVFRiVm5ZSytYWVlRNjQ4YUJ4cU81YlVuQkFGYldmdTRlY0UzRFpsWFV1?=
 =?utf-8?B?NVpISXhDTjVFVW5kSnNJQ3NiaDRLTjlQbStwdXhxOFBkWkxrR1ZDdFFTTUdh?=
 =?utf-8?B?ZUlHaDFyWnhhSmMvczZJQXpWenhLdERSdldiUDFZSTU2MmpCZEdWalY4RWFM?=
 =?utf-8?B?N0pTczE3UWxQL201U1ZIc01lamo4ck9wdThhTmRYZ0g4cXBPaytHdHV3OEhB?=
 =?utf-8?B?a0gvRHA4Q2c1S2l2WndoQm1PTjRndVpjMHJKUEtGV1AwdUI2Q2VTOWYyYjUv?=
 =?utf-8?B?Rjc5cW9HR2g4NCszVG1wTkpaMC91NmN5eGo2eWw0MmtaSWZNZWZsaWpwVHRs?=
 =?utf-8?B?bkdBRzNFcmJLdUp1c0t6SjVuMHBWbWx2LzRwbW9ZdEt2REVZTncyNGhEcDh1?=
 =?utf-8?B?OVNMZkQ1YXRHc29ldFE4QjNJNkd5dE1ycW4relcyNWxxVjhLSmxLb1lDNU14?=
 =?utf-8?B?bGtaZDUwbURuZHlzOW1WYmoxODZSUFY0dTVZZW8rMXM3QjROV3hZcWo5Nmll?=
 =?utf-8?B?ZzBac1NzeXRmaHU3R3YvellCYVljYXg3UkxLbUN2VjlTSWNWS3h0ZXh2bjNL?=
 =?utf-8?B?YjV6M3N1NVFtMDl4M1gxUVNRNWZ2SHhCK3M2akFmTWxOVTNxaWF1UWdqZVps?=
 =?utf-8?B?TjlEMjlmdGFYRWxXRE9HcWNhUWZtckgxSHdTU3gwZXo0OUhuUWZKTDlrWXdU?=
 =?utf-8?B?SjkzcDd0bUd4Y3h5Y3VLdUpIWVV1M1l5UXczUXhwWEIzS1g3dXhDY1R6R0k2?=
 =?utf-8?B?cnhuQ3pTVFpVT3JrTk9aMjlYWWJmYndQZW9TNkdHYTZkNjJCUVBGbnFlVVhm?=
 =?utf-8?B?N1d3SHdicnRsUkVaa3BFc291aFhnYWJTNi9yV1JOZURsMXhHbFlxSm1sNVNx?=
 =?utf-8?B?dHhQT0tic1pUelowaTN2V3dnTVZoelBDUXJUVGlLUkw1VmdxdEhDOVNJb2M4?=
 =?utf-8?B?WTdBeDdRckpFMTlQNXV2VGZrbzIxOVVDY0NUT1QvQTV6cmZXbklFWStlZmpM?=
 =?utf-8?B?NjhUdFRKSFFEazNUNjdNK1lZRy9TRURGbUw0YzdlaUpWYmpkTDN6VkNnN0NG?=
 =?utf-8?B?ZlhaR2ZiUy94aitrQzJnVStsQWhkVks2LzJoRHpWblBSaHhEWTlYbnYyN004?=
 =?utf-8?B?WS9GVk51SnBEbDlpN0oza1AwYXNvRjVxb0htWllHdHpGU3VJSGFhYWFXWE9i?=
 =?utf-8?B?NnhrNnBTejJWUlpNRmJ6VENNdlJUQ0hhZVB3KytNZ3R4TktlbTF3cWlaNjZQ?=
 =?utf-8?B?TUk3US9lVjd2Y1J5a21GYlJhSkJOdG5TZHM3YXhKMEFPS2ZjVHQ3eXZ0OGVG?=
 =?utf-8?B?bXgzZHR3K1lvNytOeDlGNmRsNUZLMTRkT0lqNFBFUFVnYnJLb0xtVG9paEtJ?=
 =?utf-8?B?QktEdXZuSVg3MHJjNG81Vzhlalo2L0x1Yy9Zcm1ZbUlJYVJvbXIzaHh1VnEz?=
 =?utf-8?B?cERneFZvOXZRbitXTGJmeC9talBmaGFUL3MyQjJxWGdCTE5sN1lReFdUSGFT?=
 =?utf-8?B?U3hZcHh2YmFaekZmcXNlbG5MUUJPZmpLajFKNjYrRmUzQldDbSt3bVJ4Ly9V?=
 =?utf-8?B?dWJoMHAvZmZYQlk5Uy9GTjNLYzc5VU5BS1kyeXRER1Y1bHFadUhKcnlseFow?=
 =?utf-8?B?bU14Qk51L01pRUw4N1NOa2hyaEVvNVhEQVVFY2kyVXo3V2kyVHhLbFdzaHlI?=
 =?utf-8?B?ZDhUc2FKdE5SS3ZRUGJGdVlWbnZWbExZU3BjdEtyRlJocHZDc0U1Z3kyaFV4?=
 =?utf-8?B?UWIvMk5lRFV5bFR0OWNjcDZMUGtqVk5BbTZNT0w2VUVibFVkOW9CSEtwY2xz?=
 =?utf-8?B?dmozZ085NnJWVi9Dbk44S1FFYzNGVXcwUU9DNTI5R3c2R3NLU3JndTc0dFRu?=
 =?utf-8?B?M1l6MDdkTGcvVjBDTXJ1VnBMVW9DbHRvQUl4MVhMbXJ0WVJDTm5TUkVUYlRI?=
 =?utf-8?B?UVRnM3JMdDI3b1QzMVAwQVd1NHFHM1ZWS2FXRDVUMFZhdEZEUm0vNVVybnRN?=
 =?utf-8?B?eHk2KzZFY1N0ZnRaR0t5c0RneEtBa2prLzg0aEk5YzBFSXNONEdqaEtjeGJD?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A41CEA1F1855E4DAF011FAB407721A2@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a453295-404f-4647-c20d-08dc9c159261
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2024 10:39:24.3335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uBt7xzSvnk29pjjFADZv7LyqFqY9T0UHH1p62r5ScMGco3xnF5d4OfbTbcJmh4xYQ8gSSXuEacOhrfurlVt3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA2PR04MB10278

T24gNy82LzIwMjMgMTI6NTggQU0sIEhlcmJlcnQgWHUgd3JvdGU6DQo+IE9uIFdlZCwgSnVsIDA1
LCAyMDIzIGF0IDA5OjU3OjU0UE0gKzAxMDAsIEdpb3Zhbm5pIENhYmlkZHUgd3JvdGU6DQo+Pg0K
Pj4gVGhlbiB3ZSBhcmUgdGhlbiBiYWNrIHRvIHNxdWFyZSBvbmUuIFdlIG5lZWQgdG8gY2hlY2sg
aG93IG1hbnkgZW50cmllcw0KPj4gYXJlIHByZXNlbnQgaW4gdGhlIHNjYXR0ZXJsaXN0cyBlbmNy
eXB0ZWQgYnkgY3J5cHRfam91cm5hbCgpIGJlZm9yZQ0KPj4gYWRqdXN0aW5nIHRoZSBtZWFuaW5n
IG9mICFDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkuDQo+IA0KPiBJbmRlZWQuICBJIG1pc3Nl
ZCB0aGUgZmFjdCB0aGF0IGl0IHdhcyBwcmVhbGxvY2F0aW5nIG1lbW9yeSB3aXRoDQo+IEdGUF9L
RVJORUwuDQo+IA0KPiBTbyBwZXJoYXBzIHRoZSBhbnN3ZXIgaXMgdG8gYWRqdXN0IG91ciBBUEkg
dG8gYWxsb3cgdGhlIGRyaXZlcnMgdG8NCj4gcHJlLWFsbG9jYXRlIG1lbW9yeS4gIEknbGwgbG9v
ayBpbnRvIHRoaXMuDQo+IA0KUmV2aXZpbmcgdGhpcyB0aHJlYWQsIHRyeWluZyB0byByZWFjaCBh
IGNvbmNsdXNpb24uDQoNCkhlcmJlcnQsIGRvIHlvdSBoYXZlIGFueSBzdWdnZXN0aW9uIG9uIGhv
dyB0byBtb3ZlIGZvcndhcmQ/DQoNCklzIHByZWFsbG9jYXRpbmcgbWVtb3J5IGF0IGNyeXB0byBy
ZXF1ZXN0IGFsbG9jYXRpb24gdGltZSB3b3J0aCBwdXJzdWluZz8NClRoaXMgd291bGQgaW5kZWVk
IHJlcXVpcmUgdXBkYXRpbmcgdGhlIGNyeXB0byBBUEksIHRvIGFsbG93IHVzZXJzIHRvIHByb3Zp
ZGUsDQpvcHRpb25hbGx5LCBoaW50cyB0byB0aGUgZHJpdmVycyAvIGNyeXB0byBmcmFtZXdvcmsg
d3J0LiBtZW1vcnkgbmVlZGVkDQooZS5nLiBTL0cgc2l6ZXMpOg0KCSpfcmVxdWVzdF9hbGxvYyh0
Zm0sIGdmcCwgcHJlYWxsb2NfaGludCk7DQoNClRha2luZyBkbS1pbnRlZ3JpdHkgYXMgYW4gZXhh
bXBsZSwgcXVvdGluZyBNaWt1bGFzDQoiZG0taW50ZWdyaXR5IGFsbG9jYXRlcyBhcmJpdHJhcmls
eSBsYXJnZSBzZy1saXN0cyB3aGVuIGVuY3J5cHRpbmcgdGhlIGpvdXJuYWwiDQpzbyBpdCdzIHVu
cHJhY3RpY2FsIGZvciBkcml2ZXJzIHRvIHVzZSB0Zm0tPnJlcXNpemUgZm9yIG1lbW9yeSBwcmVh
bGxvY2F0aW9uLg0KT1RPSCwgdGhlIHNpemVzIG9mIFMvR3MgYXJlIGtub3duIGF0IGNyeXB0byBy
ZXF1ZXN0IGFsbG9jYXRpb24gdGltZToNCmNyZWF0ZV9qb3VybmFsDQoJLT4gZG1faW50ZWdyaXR5
X2FsbG9jX2pvdXJuYWxfc2NhdHRlcmxpc3QNCgktPiBza2NpcGhlcl9yZXF1ZXN0X2FsbG9jDQoN
CkZvciBkbS1jcnlwdCwgd2UgY2FuJ3QgdXNlIHRoZSBzYW1lIGxvZ2ljLCBzaW5jZSBjcnlwdG8g
cmVxdWVzdHMgYXJlIGFsbG9jYXRlZA0KZnJvbSBhIG1lbXBvb2wgYW5kICpfcmVxdWVzdF9hbGxv
YyBBUEkgaXMgbm90IHVzZWQuDQpGb3J0dW5hdGVseSwgdGhlIFMvRyBzaXplcyBhcmUgYm91bmRl
ZCBhbmQgZmFpcmx5IHNtYWxsLCB0aHVzIGRyaXZlcnMNCmNvdWxkIHVzZSB0Zm0tPnJlcXNpemUg
dG8gY292ZXIgdGhpcyBjYXNlLg0KDQpJZiB0aGUgdXNlciAvIGFwcGxpY2F0aW9uIGxvZ2ljIGV4
cGVjdHMgbm8gbWVtb3J5IGFsbG9jYXRpb24gYXQgInJ1bnRpbWUiLA0KdGhlbiBpdCBmb2xsb3dz
IGl0IGhhcyBzb21lIGluZm9ybWF0aW9uIHdydC4gcmVzb3VyY2VzIHRvIGJlIHVzZWQgYW5kDQpl
aXRoZXIgYWxsb2NhdGVzIGNyeXB0byByZXF1ZXN0cyBlYXJseSBvbiAoZG0taW50ZWdyaXR5KSBv
ciBwcmVwYXJlcw0KYSBtZW1wb29sIChkbS1jcnlwdCkuDQpUaGlzIGluZm9ybWF0aW9uIHNob3Vs
ZCBiZSBwcm9wYWdhdGVkIHRvIHRoZSBkcml2ZXJzIC8gY3J5cHRvIGZyYW1ld29yay4NCkl0J3Mg
dW5yZWFzb25hYmxlIHRvIGV4cGVjdCBIVy1iYWNrZWQgaW1wbGVtZW50YXRpb25zIHRvIGF2b2lk
IG1lbW9yeQ0KYWxsb2NhdGlvbnMgd2l0aG91dCBiZWluZyBpbmZvcm1lZCBhYm91dCB0aGUgd29y
a2xvYWQgdG8gYmUgcGVyZm9ybWVkLg0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
