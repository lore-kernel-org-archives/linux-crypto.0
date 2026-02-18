Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020076.outbound.protection.outlook.com [52.101.69.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572452367D9;
	Wed, 18 Feb 2026 09:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771407760; cv=fail; b=dyIbCLkFpvTmyRVX+VL4ZZgVcZbXMYccdKuoxkbq+n7DbQ4Lr0dXUncTmuyHx13SnN52qsGM7ruWEV5jdfZ+nuolYockDjjabhIvel+yJz5eClII0Gf0bgpD8+xVMRP0aJl8T7sA2FNyUVi8AEdIEQS+muAgFxmbqB3LJhkjOfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771407760; c=relaxed/simple;
	bh=FD7d+q97K1wr62DWl4St1r4T7ISMvfNIi106fRkmG+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E52olefyyrhRUUA7uLR8eZOi3Iap/oI9A2bZWzCB3SFKdSNzVDnnZVZkIhYFQKyPL/ibeoWzNRdrNgtzEKQhMyvR4BSUMsDunI1XE0lfjWtbHQEExnU7UPGQKn9APdJSoVAkluUhJ7LzW/wr+PMLj8pNXDPM7aQLxH3de5j8Qz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=N/zi1XGh; arc=fail smtp.client-ip=52.101.69.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="N/zi1XGh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j88SyngibM6oMLySfugjJahmDkZW/aXdrSI3dMFRAtc5gM83AA60ECVt+FnlQFLWkkvpBuZsemka6HqtHQ5HrN3G5Z/9R26fIsQHssbJJExl+T6PF7KZRnUl1a86Mzy9WiaXbfbenWoimiRGhRr7z6edQ17LKbcGHipai6jqj0ArE/q5l1R+S4osZdLsz3OlxrxcIAJR7oEMpxDHtPOvptFzwhX3xMQUFa9XgBXR4A2zSRZpvkVIaurJoBsmeSaEfD9kkCB6ttggTZjwO/h3DCToNyinvcyccb3OGXUfQWaiDZuZDvCj5fK3c8Q2nAScY7jL2uWmI9AbKWiImm+vNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FD7d+q97K1wr62DWl4St1r4T7ISMvfNIi106fRkmG+w=;
 b=hMFCJG+KKGH//rzHHKCMXNX8/0zv8n6KNxCAKsaTpcue1FEUYVthwg3FakEx1hFdSXy3/MntxxqBEQQM3RXAlYs1sbS/11M2UUcWnu7Aaf0DZovqjNmecPvoZVUeBz50F4xdkCP7o0WlIBqYbzH5IxGsORp93WefxxB9Es+lH8o5BqoEVrA+VTaOhVz2B8VwyEmddHvcBL3FMaiKi7WK45eJx3Hd9zfJkuVbg04QZL0+Zw5OfXbsalDhVA8jEyVbHAvE77rhGCV+9XqlFUBoVOWZsZyEQn+4jc1D8oJEW8rlOWDRjs5KkNLEOmrOgBtruaEmv+qQZc5FZ+NfsIQuFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=cloudflare.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD7d+q97K1wr62DWl4St1r4T7ISMvfNIi106fRkmG+w=;
 b=N/zi1XGhaKpcCje88fk9tdnqTCI4gm4/t6sNyYlbhoPmkGZNJ/2NBFT+eZmCyCrAQL07MBN5NeL25tNoPK/+2hnUDqo3vd0m4DKPpLnkaXNPAh4aqyA379kbMxRV3K1+OHp6/omH0OastBBrRa8S2xIGAMJDht9NkpWrKgYUmzEK83sgiFhJdTlSWbsP3xcmsPUvqmbCUYX/RujdqL/1ENBh9XdUx2jogroJnIwzTZw7l3HDTROXKkzVXaGh6kgQknIPmrQAgXFYxbznkDIWKyMPR0L0imCBe0F1NIOdHCZ9q/0T+iNfnRrh3fdHjaBhY69TuwjdPpPT6Q6c+OsQVw==
Received: from DBBPR09CA0042.eurprd09.prod.outlook.com (2603:10a6:10:d4::30)
 by PA2PR06MB9266.eurprd06.prod.outlook.com (2603:10a6:102:404::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 09:42:31 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:d4:cafe::9e) by DBBPR09CA0042.outlook.office365.com
 (2603:10a6:10:d4::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Wed,
 18 Feb 2026 09:42:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 09:42:31 +0000
Received: from GV1PR07CU001.outbound.protection.outlook.com (40.93.214.97) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 18 Feb 2026 09:42:30 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by GV1PR06MB8353.eurprd06.prod.outlook.com (2603:10a6:150:1c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 09:42:26 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 09:42:26 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Ignat Korchagin <ignat@cloudflare.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "lukas@wunner.de"
	<lukas@wunner.de>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rsa: add debug message if leading zero byte is
 missing
Thread-Index: AQHcnAvkIbtDqneDG0+UC7zie+MHU7V+6bUAgAlBhQCAAAhggIAABG+AgAAFpgA=
Date: Wed, 18 Feb 2026 09:42:26 +0000
Message-ID: <2545c85aa50e7aaac503ed076fdb47ee9c15791f.camel@ginzinger.com>
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
		 <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
		 <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
		 <CALrw=nFCizuZ3Cko3LnAGb8A=4KB+=HdgoZDjqPgU=ssAK0hJg@mail.gmail.com>
	 <957c4cebc0c479532c8ce793ad093235e30acc77.camel@ginzinger.com>
In-Reply-To: <957c4cebc0c479532c8ce793ad093235e30acc77.camel@ginzinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|GV1PR06MB8353:EE_|DB5PEPF00014B9B:EE_|PA2PR06MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e8d7230-f8d0-40f0-673c-08de6ed20980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|7142099003;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aGNLY0xhenl5ODMwVk54SUk0K2hjakFvZDQyN3ZaaUlER0E5K1FlVis4Z2hZ?=
 =?utf-8?B?QmJ2WGtvQ2g4TUkvLzBURU9DR1FSV1RnUEpSYUxrLzlMdzBDZmFZL21hWldG?=
 =?utf-8?B?akVSaUtLeUhEZWp1MitGcTJlNDVDSUpGTEtRa29HN2lNRW9jdVZXWlJ4Y1NT?=
 =?utf-8?B?UU9ON0pkTGJKOXU0Tk1reTZRT3JXVE1aOWUyQjl0elhRUjV1allXaWdseEdh?=
 =?utf-8?B?Z2MrZ2JSWGhVMVJNNXRoZGh1a2lSWUh0TWRXSEoxU0tQU1JtQjE4WmV3LzVx?=
 =?utf-8?B?SmNTRWlmcjkrRWViQ3BrQXRMak15NzRTcWdJVEpkTzlNcnJwVkVCWlhQZHZC?=
 =?utf-8?B?K2RBaVpucldpVm1lOXgwL1Nya0lTejVUSS81Zk5lQjltZzhPanBJRHNJZW1L?=
 =?utf-8?B?Uy9qWHd3SWJMZmFzVE0zcXJGbkUrK0FTbGI2ZDJoRVg2SGJwc0dsR3oyNWVW?=
 =?utf-8?B?RUhJc0czRmFFdUZyNld2eVk4aDFVKytzVGpXeW02MENONHcwTlVIbkhXYkQy?=
 =?utf-8?B?K3NPNTFYRDBqYWZFQ0VtUndoMmV6QkMwcWpjRW1qSmh5VTBFdDZVelNXbmUx?=
 =?utf-8?B?a0taS3RUR1dDdllGSW1icWJVLzhpeDZ5MjZ4M1ZzdEUvSTFaWTRMbXdGbFB0?=
 =?utf-8?B?ZFhuYm9rYTlZM0tkQ2dPUzFzTGNGdW5sMDlQVjMxVVoxMk0yR1NMK3lVM1hm?=
 =?utf-8?B?WldlKzE3OXRtZE5BWVBWWmVXTzl4bmNqTGg1UGRoZTVzQmNTaU1hUWJoT1Jz?=
 =?utf-8?B?KzBsYngyZjcrOXN2d1Bpc3BlMStvZVc5ZGVQdUtHN2xBZ1lLOU1sVUt6UXll?=
 =?utf-8?B?S09wUnlZN1hNTnpwNmRxZWtWMU93L242MGdmYkpmSGQyZkc1UGxzY2FHQi8z?=
 =?utf-8?B?MTZhc0RmczZFVmRyUk5MSEJ1am1ZSzZxS1pkWWtDa0p2Y0RVVmRmTld4WFJl?=
 =?utf-8?B?UDYraEZGUkhwdk1GdGQ5bWsyQVdhL0RIeVRwdWdLdmJSZFdHejFTOVRkOTB3?=
 =?utf-8?B?OE53OFdnc2xlc2dQMENjNGNYcTBjc2F5elFPSGltRklQeFJIMXR3TjFSMzNq?=
 =?utf-8?B?dnMwM0hRWm8weGhLQlp4WGJza0RzcEJkdlhCa3F5TnRwNUFoV1ZCcE9kOUFr?=
 =?utf-8?B?RmpHOGdCazUvdTEyUkN5R1ZYSENrUjE0ZDhkUjBlcC8wVVlGVGJNV3ZJYUZu?=
 =?utf-8?B?TXd2REQ2UUFYaEFkWTZYTHJzVHU0TzhOa3RnRk1MdjljVWVNb2Q3QkZESU9W?=
 =?utf-8?B?VTMydEFsMmFVYU1UY0J2cWZpY09USFRaOThHbUZyNDJGUGJwa1N2S05BY09L?=
 =?utf-8?B?ZjNGZ0JrdjFYK1BXbHdQZHJxaGk3dnc5TUJialBUUk9zYWFKNzJ0WXYrNGNx?=
 =?utf-8?B?Y3NDS1hqdWV1NTRuVURRd00zakpkZG5FVWUrVlBMcmNCY2k0NGdCamQ4aDRW?=
 =?utf-8?B?Rm5kN294ZjhhbEdjcDJoQTVEcVNPZXIxUXY3ajlOdWNCVHNVU2djS0RNVko2?=
 =?utf-8?B?c0VibVJTMWRoMVZuZEFnQ1RXclZwLzVqZ2g3eWdIMEJUZUNFODI4cm5MeWs5?=
 =?utf-8?B?cHVQUzZ3RHprYU5VU2ZyVEVOODJ2cjExbUZoZWg4ZUFiYUx0T1huWmsyOVhq?=
 =?utf-8?B?d0FTNUJ2MjVzWG90eXovZDlObzBBVDRrTDU1bVhiWG9SK3VvTXZzcmFoSzYz?=
 =?utf-8?B?WVJSTnFvenJXamNvclZaRmFzaGsvaEw1QU5pR29CMklLS0NrNjhvUjFCTVRk?=
 =?utf-8?B?M2p2ejNWUVFDdGYrSHdGWW0wbzhrQTBSczNHVUR2SW5lbkpRQ25ObGJUOWNP?=
 =?utf-8?B?dmRxZSsxT0tJb2FvY3EyZDRWVVZ5ZjBwTFdYSzVpdjB3OUxqZUVUdWhoRnJQ?=
 =?utf-8?B?bFlmMUFOWFc5V2lkK0ViK0N3bUlaWXJWSnlHaWx3TzN2MEZFSVVtYzJkL0Ev?=
 =?utf-8?B?d1JTaXhqeVZwT2ovS3lQWllrdXpibHdrS2tXWjk1MUIrTVZ1eW5pZ2JTeTk0?=
 =?utf-8?B?cEF5bUUybFB2Zzd3MEUrbExsRDJzRm1rdUNmUEtGb1R2THBNd1oyb3ZyM2VS?=
 =?utf-8?B?QjE4UTdJT1Y4T1p5eFFRaC9FQnhBbzZLZUx2eEMxeTRSdnFlQ3lMNHpuUXl3?=
 =?utf-8?B?WXloZDR3VTM2dFdnbWY5MEpmRldPbk8yQi9OK1J2eFJWU0JOeW1kUVNOZXBD?=
 =?utf-8?Q?HX+YcER7BumUGYkoPpVb5iM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(7142099003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <43B0418D9D35D143A7FAD7F78CEDB78F@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR06MB8353
X-CodeTwo-MessageID: 66aa63b2-601f-4294-be37-595dbeebefd3.20260218094230@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5be37868-11da-470e-4786-08de6ed2067f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|82310400026|36860700013|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHRRU3g0czhHK1NSRlBMK3JmWExlV1hOQWwrdUNaNGtlK1JrRHE5VU5JZk9o?=
 =?utf-8?B?dCtwU0wzdHd4RTFjYW9haW9pWUgvQkk3TW1xbVZiRXJhOUN0SzBsaVpIWjF0?=
 =?utf-8?B?N3F5NXd4QVN4cll4Qk5oaVZ3WTFjaldpWFFtT3VCMVFtckJ4VFJ2U0MvZjEy?=
 =?utf-8?B?REtHZk9mMGl6UDhGa0l0NnNpeGh3WHgvOXphY3AxL0RYY3JkaDE5WG5wMkdi?=
 =?utf-8?B?aG5rTG1SNkhFellEbzluaWtZdHJJbEdWc0d6dENTVG9HandrREtGZHdmWjdZ?=
 =?utf-8?B?aTNXNWlDbzNiYkdPc05oblh6djlzTHRLYjVPY2RZRkt5QzBrQ2hhWUROZ0tB?=
 =?utf-8?B?SmgxMjZITTlHdEwrNGtwTndSMXo2VkJMMFZWSVY5bUhRditXOTJITHBzUW5u?=
 =?utf-8?B?MFlMM2pTMjRLUnNERHRjY3JUS1BMb1lFUGUxa2xNREtCUzMzcUJhQnpqL1lE?=
 =?utf-8?B?bnM0SW9ZeVNTTXYyc1g5TUlDRThpL2xzdC8wTTBQZTE1NXhidzhOakluVjZx?=
 =?utf-8?B?MDY4TUdiWE9BckRWMDRzcXVwaW5FRndPbncwaGhlbUVmWUVmaU1WVmZVa1VI?=
 =?utf-8?B?YzFQYVBqOGdIOEYvUUFvVWwwcDBBZ2pLdTR1ai85M0tLUkVsNWdhSy9NZTNM?=
 =?utf-8?B?VUw1Qm5aQXVVV3ZIS05uVlBTZHE3cDVJMEFpMWsvUHpKVEgyeUJYVjRqU00r?=
 =?utf-8?B?Y0NxUjVMNGxvUVQ4MWF6ZXBUMUM5UGNNRFF1NXphTDJ6bTMzd2ZRSHdzRjJC?=
 =?utf-8?B?VDBDY2N4SzMrY2srU3JCODVkY09LRVVIbExpWlg5dm5obTJpZUFPb1RWUklE?=
 =?utf-8?B?ZEIwanUyOTJ2RDZXRDZaNWhKdTA1VWRrdE4vaXJDOG5Oc3NPb1djSnJpVXFp?=
 =?utf-8?B?S0g3TndxVURqQmtPeVo1ckNUWTlraW90eklBTnVYVzdaTlRRUk1wZzIvZFRL?=
 =?utf-8?B?b3FjV3dXSTNTQUFhZDdGS2wrOTM2NmdjUE0xZE1vR21zdHJTL3krY0dtdTRN?=
 =?utf-8?B?MWJiamFObWFxTWZGZDRGbENHdFdpbWplY0YyTGRJalhIWnVwWFZ1T1d0ank0?=
 =?utf-8?B?M1VOd3g0V3pmNHlXbnhxaW1iZG9SU0Q3RlBEeVJFdnlCMDFXZW5vZnlXMEVa?=
 =?utf-8?B?WFIycFJyRWJkVy9jcVFsSlNKbnRhME00MS9US1RLT2xTWXBINjhlb2hFT1Vx?=
 =?utf-8?B?MVIwM1BhRThrZ2tzczBhWTZPZTVHMGkxRFYvdkVqbk9wdDJZckFzTzE3aW1z?=
 =?utf-8?B?R2JRWDRocW1QSXUrbStCZTVVOXdmeWpJam9sWFhoOVhGKzFnTTMvSlZ3aS9P?=
 =?utf-8?B?SkhSd0NQRVpaTFAzZWlYWVlPeGpzRkI4Rm5vRWJSSSs4WENJNWlQc2RTUnYx?=
 =?utf-8?B?RTU0TmhIKzNkZXVtYzQ3Y2U1WmhGRjJHU2JrWWY3MkNIRTlld1I2RGdDRi9L?=
 =?utf-8?B?cXpUaFBRTzlmRXp2eVZRb3JXUG1NcCtpRWhOemJTUWdnWTF3MXJXZ3lBKzFT?=
 =?utf-8?B?a3pxa0NERHgxaVZiQk1kOC8vQktybFByQWJ1TkdMSzIwdEo0dVJpUk9MZ3Bw?=
 =?utf-8?B?NFFuNkhEL2MxTWlmQU9zb0Q4V1ZReThPdWRIeDl4LytmaEV4Y1Ftc1NlQ3Vw?=
 =?utf-8?B?RG50WkplK05FcU5CN1gvQ1YrdXJERUtJeUNkZk5YUW5oQXRzK3JsRng4eGk5?=
 =?utf-8?B?UkpDQVZRakJub0RjR1p6UGxZQlhmRlFKenVWQkZIekZPLytEdVBvcDU5U1o5?=
 =?utf-8?B?R0pQZW1HZXNOV1VwQklSVXJHRlkwNGVtQkxJNUpHa3RvamMxUzcxMXl0eU1Z?=
 =?utf-8?B?Q0JtanlUNDVoNXM1ZW1ibENlQ1hKQ2gwdkVIZFJZY3dCbWM5RmlZVDhhRkoz?=
 =?utf-8?B?dWdpY0lyUDU4aFdmMXBnYXZGaDlqMU1kVTVwSUhsdUJwSWEzT1NYODIxdWJn?=
 =?utf-8?B?cFErZmR4UGtFempreU9wV2NBcHBMemNyUDNIVXBubFRHQ0ZkOFIveTdzVGRK?=
 =?utf-8?B?WVNkUDlmckFRNTJERXphU3N2RUtPalgra3N1bXl5ekpVK3cxZldqMXlJZDFI?=
 =?utf-8?B?SzZKSXltUUNJYklob1I0akpGdVczU2xPS2toc2FUTDlhSTFKbStJZ0Q0THJD?=
 =?utf-8?B?RHloNWMzdUwvZjc5WVRlRit2RUQzY1BhNm5CaXpOYU1aTjMwVEM0MU1NQkNS?=
 =?utf-8?B?NnhDWGd2TTBlNUNKellmWkRpaUhhNXRTTFFZTEdzVGZvOGZ0TWI4NXJFQm5w?=
 =?utf-8?B?clNodWdpTEVzUkJXNWFaZ3ExNzdBPT0=?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(82310400026)(36860700013)(376014)(7142099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	F0oDhC01iWErnRWl9fMtioxBgKDj31QpQNqAADX02C2M/bwKRfXWy4Wchl2KG+BEjDCRU6TEUYcyM+fMrLn78hPqvgGpFXSGHIluZM/WpIMcarA0k2zva9pMIhoXuMloIkz3IhHtWT4COJ+8xc3WpEQTyX4qTcL+sgzLJFTAwuju7DSZDpdET89dJz8PZ86YqpCtIVxwzM+P98Pp2kDGE4CN30KWu10o/1ZgbCPY9dFRkALoIwmDdcnWC9TW2EqGtquw0HBA2iPzrzMAMMXbYYKuQEK/+7HkVN6s/8QXHeIHlytz0FerI+lDNSR9PD/rsm4DRyPNBPabTLpG7b9l23L7KktaFihxLrSfGCyWo4ROBqm6h3bvH30YqCf9Z6gJshU5rawFIcB+xIhhncI5BHeWTVn0CIWhJvVyzspthTb2bE1Ho89VWEYcuXeN+dNb
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 09:42:31.2768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8d7230-f8d0-40f0-673c-08de6ed20980
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA2PR06MB9266

QW0gTWl0dHdvY2gsIGRlbSAxOC4wMi4yMDI2IHVtIDA5OjIyICswMDAwIHNjaHJpZWIgS2VwcGxp
bmdlci1Ob3Zha292aWMKTWFydGluOgo+IEFtIE1pdHR3b2NoLCBkZW0gMTguMDIuMjAyNiB1bSAx
MDowNiArMDEwMCBzY2hyaWViIElnbmF0IEtvcmNoYWdpbjoKPiA+IE9uIFdlZCwgRmViIDE4LCAy
MDI2IGF0IDk6MzbigK9BTSBLZXBwbGluZ2VyLU5vdmFrb3ZpYyBNYXJ0aW4KPiA+IDxNYXJ0aW4u
S2VwcGxpbmdlci1Ob3Zha292aWNAZ2luemluZ2VyLmNvbT4gd3JvdGU6Cj4gPiA+IAo+ID4gPiBB
bSBEb25uZXJzdGFnLCBkZW0gMTIuMDIuMjAyNiB1bSAxMToxNSArMDAwMCBzY2hyaWViIElnbmF0
Cj4gPiA+IEtvcmNoYWdpbjoKPiA+ID4gPiBIaSwKPiA+ID4gPiAKPiA+ID4gPiBPbiBUaHUsIEZl
YiAxMiwgMjAyNiBhdCAxMDozOeKAr0FNIE1hcnRpbiBLZXBwbGluZ2VyLU5vdmFrb3ZpYwo+ID4g
PiA+IDxtYXJ0aW4ua2VwcGxpbmdlci1ub3Zha292aWNAZ2luemluZ2VyLmNvbT4gd3JvdGU6Cj4g
PiA+ID4gPiAKPiA+ID4gPiA+IFdoZW4gZGVidWdnaW5nIFJTQSBjZXJ0aWZpY2F0ZSB2YWxpZGF0
aW9uIGl0IGNhbiBiZSB2YWx1YWJsZQo+ID4gPiA+ID4gdG8KPiA+ID4gPiA+IHNlZQo+ID4gPiA+
ID4gd2h5IHRoZSBSU0EgdmVyaWZ5KCkgY2FsbGJhY2sgcmV0dXJucyAtRUlOVkFMLgo+ID4gPiA+
IAo+ID4gPiA+IE5vdCBzdXJlIGlmIHRoaXMgd291bGQgYmUgc29tZSBraW5kIG9mIGFuIGluZm9y
bWF0aW9uIGxlYWsKPiA+ID4gPiAoZGVwZW5kaW5nCj4gPiA+ID4gb24gYSBzdWJzeXN0ZW0gdXNp
bmcgUlNBKS4gQWxzbyB3aGF0IG1ha2VzIHRoaXMgY2FzZSBzbwo+ID4gPiA+IHNwZWNpYWw/Cj4g
PiA+ID4gU2hvdWxkIHdlIHRoZW4gYW5ub3RhdGUgZXZlcnkgb3RoZXIgdmFsaWRhdGlvbiBjaGVj
ayBpbiB0aGUKPiA+ID4gPiBjb2RlPwo+ID4gPiA+IAo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
TWFydGluIEtlcHBsaW5nZXItTm92YWtvdmljCj4gPiA+ID4gPiA8bWFydGluLmtlcHBsaW5nZXIt
bm92YWtvdmljQGdpbnppbmdlci5jb20+Cj4gPiA+ID4gPiAtLS0KPiA+ID4gPiA+IAo+ID4gPiA+
ID4gaGksCj4gPiA+ID4gPiAKPiA+ID4gPiA+IG15IHJlYWwgaXNzdWUgaXM6IFdoZW4gdXNpbmcg
YSBjZXJ0aWZpY2F0ZSBiYXNlZCBvbiBhbiBSU0EtCj4gPiA+ID4gPiBrZXksCj4gPiA+ID4gPiBJ
IHNvbWV0aW1lcyBzZWUgc2lnbmF0dXJlLXZlcmlmeSBlcnJvcnMgYW5kICh2aWEgZG0tdmVyaXR5
KQo+ID4gPiA+ID4gcm9vdGZzIHNpZ25hdHVyZS12ZXJpZnkgZXJyb3JzLCBhbGwgdHJpZ2dlcmVk
IGJ5ICJubyBsZWFkaW5nCj4gPiA+ID4gPiAwCj4gPiA+ID4gPiBieXRlIi4KPiA+ID4gPiA+IAo+
ID4gPiA+ID4ga2V5L2NlcnQgZ2VuZXJhdGlvbjoKPiA+ID4gPiA+IG9wZW5zc2wgcmVxIC14NTA5
IC1uZXdrZXkgcnNhOjQwOTYgLWtleW91dCBjYV9rZXkucGVtIC1vdXQKPiA+ID4gPiA+IGNhLnBl
bSAtCj4gPiA+ID4gPiBub2RlcyAtZGF5cyAzNjUgLXNldF9zZXJpYWwgMDEgLXN1YmogL0NOPWdp
bnppbmdlci5jb20KPiA+ID4gPiA+IGFuZCBzaW1wbHkgdXNlZCBhcyB0cnVzdGVkIGJ1aWx0LWlu
IGtleSBhbmQgcm9vdGZzIGhhc2ggc2lnbgo+ID4gPiA+ID4gYXBwZW5kZWQKPiA+ID4gPiA+IHRv
IHJvb3RmcyAoc3F1YXNoZnMpLgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBJJ20gb24gaW14NnVsLiBU
aGUgdGhpbmcgaXM6IFVzaW5nIHRoZSBzYW1lIGNlcnRpZmljYXRlL2tleSwKPiA+ID4gPiA+IHdv
cmtzCj4gPiA+ID4gPiBvbgo+ID4gPiA+ID4gb2xkIHY1LjQtYmFzZWQga2VybmVscywgdXAgdG8g
djYuNiEKPiA+ID4gPiA+IAo+ID4gPiA+ID4gU3RhcnRpbmcgd2l0aCBjb21taXQgMmYxZjM0YzFi
ZjdiMzA5ICgiY3J5cHRvOiBhaGFzaCAtCj4gPiA+ID4gPiBvcHRpbWl6ZQo+ID4gPiA+ID4gcGVy
Zm9ybWFuY2UKPiA+ID4gPiA+IHdoZW4gd3JhcHBpbmcgc2hhc2giKSBpdCBzdGFydHMgdG8gYnJl
YWsuIGl0IGlzIG5vdCBhIGNvbW1pdAo+ID4gPiA+ID4gb24KPiA+ID4gPiA+IGl0J3Mgb3duIEkK
PiA+ID4gPiA+IGNhbiByZXZlcnQgYW5kIG1vdmUgb24uCj4gPiA+ID4gPiAKPiA+ID4gPiA+IFdo
YXQgaGFwcGVuZGVkIHNpbmNlIHY2LjYgPyBPbiB2Ni43IEkgc2VlCj4gPiA+ID4gPiBbwqDCoMKg
IDIuOTc4NzIyXSBjYWFtX2pyIDIxNDIwMDAuanI6IDQwMDAwMDEzOiBERUNPOiBkZXNjIGlkeAo+
ID4gPiA+ID4gMDoKPiA+ID4gPiA+IEhlYWRlciBFcnJvci4gSW52YWxpZCBsZW5ndGggb3IgcGFy
aXR5LCBvciBjZXJ0YWluIG90aGVyCj4gPiA+ID4gPiBwcm9ibGVtcy4KPiA+ID4gPiA+IAo+ID4g
PiA+ID4gYW5kIGxhdGVyIHRoZSBhYm92ZSAtRUlOVkFMIGZyb20gdGhlIFJTQSB2ZXJpZnkgY2Fs
bGJhY2ssCj4gPiA+ID4gPiB3aGVyZQo+ID4gPiA+ID4gSQo+ID4gPiA+ID4gYWRkCj4gPiA+ID4g
PiB0aGUgZGVidWcgcHJpbnRpbmcgSSBzZWUuCj4gPiA+ID4gPiAKPiA+ID4gPiA+IFdoYXQncyB0
aGUgZGVhbCB3aXRoIHRoaXMgImxlYWRpbmcgMCBieXRlIj8KPiA+ID4gPiAKPiA+ID4gPiBTZWUg
UkZDIDIzMTMsIHAgOC4xCj4gPiA+IAo+ID4gPiBoaSBJZ25hdCwKPiA+ID4gCj4gPiA+IHRoYW5r
cyBmb3IgeW91ciB0aW1lLCB0aGUgcHJvYmxlbSBpcyAqc29tZXRpbWVzKiByc2EgdmVyaWZ5Cj4g
PiA+IGZhaWxzLgo+ID4gPiB0aGVyZSBzZWVtcyB0byBiZSBhIHJhY2UgY29uZGl0aW9uOgo+ID4g
Cj4gPiBDYW4geW91IGNsYXJpZnkgdGhlIGZhaWx1cmUgY2FzZSBhIGJpdD8gSXMgdGhpcyB0aGUg
c2FtZSBzaWduYXR1cmUKPiA+IHRoYXQgZmFpbHM/IChUaGF0IGlzLCB5b3UganVzdCB2ZXJpZnkg
YSBmaXhlZCBzaWduYXR1cmUgaW4gYSBsb29wKQo+ID4gT3IKPiA+IGFyZSB0aGVzZSBkaWZmZXJl
bnQgc2lnbmF0dXJlcz8gKHNvbWUgcmVsaWFibHkgdmVyaWZ5IGFuZCBzb21lCj4gPiByZWxpYWJs
eSBmYWlsKQo+ID4gCj4gCj4gZGlmZmVyZW50IHNpZ251YXR1cmVzIGJ1dCBub3RoaW5nIHNwZWNp
YWw6IEkgYWRkIGNhLnBlbSAob3V0cHV0IG9mCj4gIm9wZW5zc2wgcmVxIC14NTA5IC1uZXdrZXkg
cnNhOjQwOTYgLWtleW91dCBjYV9rZXkucGVtIC1vdXQgY2EucGVtIC0KPiBub2RlcyAtZGF5cyAz
NjUgLXNldF9zZXJpYWwgMDEgLXN1YmogL0NOPWdpbnppbmdlci5jb20iKSB0bwo+IENPTkZJR19T
WVNURU1fVFJVU1RFRF9LRVlTCj4gCj4gZHVyaW5nIGJvb3QsIGFzeW1tZXRyaWNfa2V5X3ByZXBh
cnNlKCkgaXMgY2FsbGVkLCBmaXJzdCBvbiB0aGlzLCBhbmQKPiBhZnRlciB0aGF0LCAiY2ZnODAy
MTE6IExvYWRpbmcgY29tcGlsZWQtaW4gWC41MDkgY2VydGlmaWNhdGVzIGZvcgo+IHJlZ3VsYXRv
cnkgZGF0YWJhc2UiIGRvZXMgdGhlIHNhbWUgdGhpbmcgZm9yIENoZW4tWXUsIFNldGgncyBrZXlz
IGluCj4gbWFpbmxpbmUgbmV0L3dpcmVsZXNzL2NlcnRzIHdoZXJlIEkgYWxzbyBhZGRlZCBCZW4n
cyBEZWJpYW4KPiBjZXJ0aWZpY2F0ZS4KPiAKPiBUaGUgYWJvdmUgdmVyaWZpY2F0aW9ucyBvZiA1
IGtleXMgZmFpbCByYW5kb21seS4KPiAKCnRvIGNsYXJpZnk6IG5vIHZlcmlmaWNhdGlvbiByZWxp
YWJseSBmYWlscyBvciBzdWNjZWVkcy4gdGhlIGZpcnN0IG9uZSwKbXkgb3duIGNlcnQsIG1vc3Rs
eSAoYWx3YXlzPykgc3VjY2VlZHMsIGZvciB0aGUgNCByZWdkYiBjZXJ0cyBJIHNlZSBubwpwYXR0
ZXJuIGF0IGFsbC4gQ2hlbi1ZdSdzICJ3ZW5zIiBjZXJ0IGtpbmQgb2YgZmFpbHMgbW9yZSBvZnRl
biB0aGF0CnRoYW4gdGhlIG90aGVycyBtYXliZS4KClRoZXJlIGlzIGFsbW9zdCBuZXZlciBhIGJv
b3Qgd2hlcmUgYWxsIGNlcnRzIHZlcmlmaWNhdGlvbnMgc3VjY2VlZCwKYWx0aG91Z2ggSSd2ZSBz
ZWVuIGF0IGxlYXN0IG9uZSBhbHJlYWR5LgoKCj4gSW4gdGhlIGVuZCBJICh3YW50IHRvKSB1c2Ug
bXkgb3duIGNlcnQgZm9yIGRtLXZlcml0eSByb290ZnMgbG9hZGluZwo+ICh3aGljaCBhbHNvIHJh
bmRvbWx5IGZhaWxzKS4KPiAKPiBvbiBvbGQga2VybmVscywgbW9zdCBsaWtlbHkgdXAgdG8gdjYu
NiwgdGhlcmUgd2FzIG5vIHByb2JsZW0uCj4gCj4gdGhhbmsgeW91IGZvciBhc2tpbmcsCj4gCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbWFydGluCj4gCj4gCj4gPiA+IGluIHRoZSBmYWlsdXJlLWNhc2UgYWZ0ZXIgY3J5cHRv
X2FrY2lwaGVyX2VuY3J5cHQoKSBhbmQKPiA+ID4gY3J5cHRvX3dhaXRfcmVxKCkgdGhlICpzYW1l
KiBkYXRhIGFzIGJlZm9yZSBpcyBzdGlsbCBhdCBvdXRfYnVmIQo+ID4gPiB0aGF0Cj4gPiA+IGhh
cyBub3QgeWV0IGJlZW4gd3JpdHRlbiB0by4KPiA+ID4gCj4gPiA+IEl0J3Mgbm90IHRoYXQgb2J2
aW91cyB0byBiZSB5ZXQgYmVjYXVzZSBtc2xlZXAoMTAwMCkgZG9lc24ndAo+ID4gPiBjaGFuZ2UK
PiA+ID4gbXVjaCBhbmQgMDAsIDAxLCBmZiwgZmYuLi4gaXMgKnN0aWxsKiBub3QgeWV0IHdyaXR0
ZW4gdG8gb3V0X2J1ZiEKPiA+ID4gCj4gPiA+IGlzIHRoZXJlIGEgcmVhc29uIHdoeSBjcnlwdG9f
YWtjaXBoZXJfc3luY197ZW4sZGV9Y3J5cHQoKSBpcyBub3QKPiA+ID4gdXNlZD8KPiA+ID4gQ2Fu
IHlvdSBpbWFnaW5lIHdoYXQgY291bGQgZ28gd3JvbmcgaGVyZT8KPiA+ID4gCj4gPiA+ICptYXli
ZSogY29tbWl0IDFlNTYyZGVhY2VjY2ExZjFiZWM3ZDIzZGE1MjY5MDRhMWU4NzUyNWUgdGhhdCBk
aWQKPiA+ID4gYQo+ID4gPiBsb3QKPiA+ID4gb2YgdGhpbmdzIGluIHBhcmFsbGVsIChpbiBvcmRl
ciB0byBrZWVwIGZ1bmN0aW9uYWxpdHkgc2ltaWxhcikKPiA+ID4gZ290Cj4gPiA+IHNvbWV0aGlu
ZyB3cm9uZz8KPiA+ID4gCj4gPiA+IHNpZGVub3RlOiB3aGVuIEkgdXNlIGFuIGVsbGlwdGljIGN1
cnZlIGtleSBpbnN0ZWFkIG9mIHJzYSwKPiA+ID4gZXZlcnl0aGluZwo+ID4gPiB3b3Jrcy4KPiA+
ID4gCj4gPiA+IGFsc28sIHRoZSBhdXRvLWZyZWUgZm9yIGNoaWxkX3JlcSBsb29rcyBhIGJpdCBk
YW5nZXJvdXMgd2hlbgo+ID4gPiB1c2luZwo+ID4gPiBvdXRfYnVmLCBidXQgb2sgOikKPiA+ID4g
Cj4gPiA+IG1heWJlIHRoaXMgcmluZ3MgYSBiZWxsLCBJJ2xsIGtlZXAgZGVidWdnaW5nLAo+ID4g
PiAKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG1hcnRpbgo+ID4gPiAKPiA+ID4gCj4gPiA+ID4gCj4gPiA+ID4gPiAKPiA+ID4gPiA+
IHRoYW5rIHlvdSEKPiA+ID4gPiA+IAo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtYXJ0aW4KPiA+
ID4gPiA+IAo+ID4gPiA+ID4gCj4gPiA+ID4gPiAKPiA+ID4gPiA+IMKgY3J5cHRvL3JzYS1wa2Nz
MXBhZC5jIHwgNSArKystLQo+ID4gPiA+ID4gwqBjcnlwdG8vcnNhc3NhLXBrY3MxLmMgfCA1ICsr
Ky0tCj4gPiA+ID4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0
aW9ucygtKQo+ID4gPiA+ID4gCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvY3J5cHRvL3JzYS1wa2Nz
MXBhZC5jIGIvY3J5cHRvL3JzYS1wa2NzMXBhZC5jCj4gPiA+ID4gPiBpbmRleCA1MGJkYjE4ZTdi
NDgzLi42NWE0ODIxZTk3NThiIDEwMDY0NAo+ID4gPiA+ID4gLS0tIGEvY3J5cHRvL3JzYS1wa2Nz
MXBhZC5jCj4gPiA+ID4gPiArKysgYi9jcnlwdG8vcnNhLXBrY3MxcGFkLmMKPiA+ID4gPiA+IEBA
IC0xOTEsOSArMTkxLDEwIEBAIHN0YXRpYyBpbnQKPiA+ID4gPiA+IHBrY3MxcGFkX2RlY3J5cHRf
Y29tcGxldGUoc3RydWN0Cj4gPiA+ID4gPiBha2NpcGhlcl9yZXF1ZXN0ICpyZXEsIGludCBlcnIp
Cj4gPiA+ID4gPiAKPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgIG91dF9idWYgPSByZXFfY3R4LT5v
dXRfYnVmOwo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqAgaWYgKGRzdF9sZW4gPT0gY3R4LT5rZXlf
c2l6ZSkgewo+ID4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG91dF9i
dWZbMF0gIT0gMHgwMCkKPiA+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAvKiBEZWNyeXB0ZWQgdmFsdWUgaGFkIG5vIGxlYWRpbmcgMAo+ID4gPiA+
ID4gYnl0ZSAqLwo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG91
dF9idWZbMF0gIT0gMHgwMCkgewo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHByX2RlYnVnKCJEZWNyeXB0ZWQgdmFsdWUgaGFkIG5vCj4gPiA+
ID4gPiBsZWFkaW5nIDAKPiA+ID4gPiA+IGJ5dGVcbiIpOwo+ID4gPiA+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGRvbmU7Cj4gPiA+ID4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPiA+ID4gPiAKPiA+ID4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkc3RfbGVuLS07Cj4gPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgb3V0X2J1ZisrOwo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2Ny
eXB0by9yc2Fzc2EtcGtjczEuYyBiL2NyeXB0by9yc2Fzc2EtcGtjczEuYwo+ID4gPiA+ID4gaW5k
ZXggOTRmYTVlOTYwMGU3OS4uMjI5MTk3MjhlYTFjOCAxMDA2NDQKPiA+ID4gPiA+IC0tLSBhL2Ny
eXB0by9yc2Fzc2EtcGtjczEuYwo+ID4gPiA+ID4gKysrIGIvY3J5cHRvL3JzYXNzYS1wa2NzMS5j
Cj4gPiA+ID4gPiBAQCAtMjYzLDkgKzI2MywxMCBAQCBzdGF0aWMgaW50IHJzYXNzYV9wa2NzMV92
ZXJpZnkoc3RydWN0Cj4gPiA+ID4gPiBjcnlwdG9fc2lnICp0Zm0sCj4gPiA+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gPiA+ID4gPiAKPiA+ID4g
PiA+IMKgwqDCoMKgwqDCoMKgIGlmIChkc3RfbGVuID09IGN0eC0+a2V5X3NpemUpIHsKPiA+ID4g
PiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChvdXRfYnVmWzBdICE9IDB4MDAp
Cj4gPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
LyogRW5jcnlwdGVkIHZhbHVlIGhhZCBubyBsZWFkaW5nIDAKPiA+ID4gPiA+IGJ5dGUgKi8KPiA+
ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChvdXRfYnVmWzBdICE9IDB4
MDApIHsKPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBwcl9kZWJ1ZygiRW5jcnlwdGVkIHZhbHVlIGhhZCBubwo+ID4gPiA+ID4gbGVhZGluZyAw
Cj4gPiA+ID4gPiBieXRlXG4iKTsKPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gPiA+ID4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPiA+ID4gPiAKPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBkc3RfbGVuLS07Cj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgb3V0X2J1ZisrOwo+ID4gPiA+ID4gLS0KPiA+ID4gPiA+IDIuNDcuMwo+ID4g
PiA+ID4gCj4gPiA+ID4gCj4gPiA+ID4gSWduYXQK
