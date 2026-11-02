Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.152.168
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793629661;
	b=hJCEvEGLAnMyZSTX30xetdFY5R2l7uomQn1/QfssVgGAaFeB/TpwI+W0G4n7RbSxnMrn
	 MalJkYAceZSrZJKOM7UDJhF6MzJo0kPPZt9D7+CL/0CJK4gjgxw+4pV9KMygShmrqWyr7
	 beZrvWCF/CIBaCyF1BUWWk4FLuh7mUx0SeDUucc6HESG5wxlm8ZwyfKZVYpr4NGYfYLhc
	 7RA1eoy6PbOkBYeuPN1YYwFajCmk1sHs36OgQO/WJNQmc8pe2XCLPazdEvSzph3nxc3y+
	 cpD3P4lTPIiASdfpVGmacQhPo0yakugLbWoAaQorU/VbXqvQZKh77j8F4+6sfBaNp3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629661;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Reason;
	bh=kPguCP5zChuD8MpIJBrCb8YHHBSSdTekx/kYz+Uzu3c=;
	b=Ey7SUuzdtzyikNDVeR9jtIKxh5qngGTKB9jk+vg1Cd3r3Hu7FqFw5oYIKCiHDyQoy5wY
	 N5xZqva8VIgr22WMbSuUdy/lCxTZ/sgTo+7l1uf6H0Wl3olDHY/KpeHbVtniESqZVtt4v
	 53YhK2solU2R7ioGdaJKuxZuG1jihuZME6EQPXf5UM2d+c24HJjWvwE9DG7UjyFUIaE9U
	 +FpVID5lazRzWvLF+pTYa/D7JIP0EXhELZnO49GP6KniX/8DSdLa51zN0vPygIAa88ePt
	 HDxmV75ffTL0tfdvA4wUJzixS3wjTPhw89HwLkFaL5B+XOspopPBb+IC/6Y9G5O/mHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=opensource.cirrus.com;
	spf=pass smtp.mailfrom=opensource.cirrus.com;
	dkim=pass header.d=cirrus.com header.i=@cirrus.com header.a=rsa-sha256 header.s=PODMain02222019 header.b=US32CT+3;
	dkim=pass header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-cirrus4-onmicrosoft-com header.b=cSBdALto;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.152.168
Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8996606EEA7;
	Mon,  2 Nov 2026 14:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8996606EEA7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cirrus.com header.i=@cirrus.com header.a=rsa-sha256 header.s=PODMain02222019 header.b=US32CT+3;
	dkim=pass (1024-bit key, unprotected) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-cirrus4-onmicrosoft-com header.b=cSBdALto
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2DPBYm2776587;
	Mon, 2 Nov 2026 08:27:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=PODMain02222019; bh=kPguCP5zChuD8MpIJB
	rCb8YHHBSSdTekx/kYz+Uzu3c=; b=US32CT+3V6o2Q4fR+lxUQ84bmjZgDGvTUQ
	Bh5IQOiyYSKaB3VqHPqqbw1CNLHtYrbyQFDNg9/DirSmngUDvKRQxhFN1Uha+wjh
	wE2+iKrPEe7kzV0tyEqyAJsBgYjXtYUX282Gx3qRU30T+zz5/iQGhctjGMAgplz/
	MyOIzAX0NpfEdoyJfm+a9qNbUa2GoOXKZ4NR1WiYQ+zFcLge9sae30VpV1yBzZGV
	qJ0aW2h0Hn+pbV2AllkdOWT7YVZe3PRKWVgJtonVf8Vm10LTaIQJUv55t0/Lk/uV
	qnjTKwQlT8wIwXBrRTA0XYAp/OaQB0dI7iKAyZ8SSKMlRuJxH2AQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022122.outbound.protection.outlook.com [40.93.195.122])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4hncrft03k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 08:27:05 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V53Fcu/g0dK6D7w5kOrmX7KZ+XoN8+6UWS/VrgMp26/nPR2VS2g7hIQ2ewic5OJw7niKXex7p1ghA9pk+Z1qLoQ8OEdlxfhTcaNCgkaY3GJqRfcBVUlz1cWYv2XjynpvBYsWSvQ7KAURANWfkIc3Zj/BK/D4m88aawf5MkBOlmPHLXRiIaHfMqT4H/oXjNH5BcCyEZlGYR16mJZ390Eov156WSUSX/HPu24iaJmsvw3KDBLZQBrs0iZxxyvSMkAND8jZb4ZBvDpKfv2MKuuSVU5QZrQwFIa+P+DtYFyLLTqFs1pODE6+h/wn7kiW6upVsQrIUb8/BanxR2d6wHtw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPguCP5zChuD8MpIJBrCb8YHHBSSdTekx/kYz+Uzu3c=;
 b=ID80aX7/Pefpfpnk+qR0gWGj2QUiiPGNUw/ZmU4Z1VpS+ASdO4X0cjGk3R1hGEFJcSJyTNGdgleGpSFaXnqMqRu5o6J1h2oWG16zJkNvIQLEDXoPyoAzXiNniXYWwcTOSpjOn0BISVQzu422dWAQTe6QL24elqa2uqLqk4u1rl4UYALWc3h7uXJ8OtU5RJ89gYHZY1kNtZyDtCe9Ge6HSyN457WXDOLkNtXTu5v5PnBLPcJ/pi/9MZkMxJOC/Ze4XU48IBncmtocLd2D+pnIGTIc6n4V3H7wlSPQd29eTGkbitZfMwtW+QE+Sbd0eudY17cDQGW4xe1cCtP1JLZt0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=bootlin.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPguCP5zChuD8MpIJBrCb8YHHBSSdTekx/kYz+Uzu3c=;
 b=cSBdALtoOqy4kK2tvRr9eZsKMmc6dpMZhPVDNf6/MAdKwI3Jp1c5c8nw8R7LCmTS9RPlV/xM1CsnKcP6rzrhuzLpkOqje83Kw61IlzFdeY/Qgv1fjRWaytH+FKE0TQQkfkcUy0Zdf3JwvH1IhSMZ/Ymyemw81G7R+Pm6yftcDIk=
Received: from CH2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:610:53::32)
 by PH7PR19MB7754.namprd19.prod.outlook.com (2603:10b6:510:241::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 14:27:00 +0000
Received: from CH3PEPF0002457D.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::44) by CH2PR17CA0022.outlook.office365.com
 (2603:10b6:610:53::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 14:26:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 CH3PEPF0002457D.mail.protection.outlook.com (10.167.252.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.5
 via Frontend Transport; Mon, 2 Nov 2026 14:26:56 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 68A79406544;
	Mon,  2 Nov 2026 14:26:55 +0000 (UTC)
Received: from opensource.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 4D0F182026C;
	Mon,  2 Nov 2026 14:26:55 +0000 (UTC)
Date: Mon, 2 Nov 2026 14:26:54 +0000
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Cc: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>,
        David Rhodes <david.rhodes@cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Qunqin Zhao <zhaoqunqin@loongson.cn>,
        Thomas Richard <thomas.richard@bootlin.com>, mfd@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        patches@opensource.cirrus.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] mfd: Use named initializers for acpi_device_id
Message-ID: <auidrr2KFuj9RSph@opensource.cirrus.com>
References: <20261102-acpi-mfd-v1-1-d61029971be8@thegoodpenguin.co.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-acpi-mfd-v1-1-d61029971be8@thegoodpenguin.co.uk>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457D:EE_|PH7PR19MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b97c424-24bc-46f0-3b0b-08df38ed596d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|23010399003|61400799027|10067099003|22082099003|16102099003|18002099003|56012099006|11063799006|261022105027099003|261022075727099003|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	tfB8WPzswcsAfDRPjZutZLWXrNvro5Dnt57/abi+CNA4rfGa1z6K9R12sqyJ24UjkScFssKSYRGDhB39QMhUkCgf+gJC/j86B3Vx6vR3I78fVqqqB72H4CFRM/l7htEQBLNOlG56Fi8lya0u6y0fWS6byFS+A5lzdJYYJT8bhjyG3P/s35WsdjPbOuhCsC/xFqGaUuFViIhlhY+5iiPEX3FqQIk/W4pX1+bIO9pE69NobsE1SK33+9Jds3VABPNCz1zjDKYy5iu5UyKa34FzCVBH/eFDrxUggVqR3UMSEjcF0eF6aG4SpqqkGaXy8Q0U6tBjwsC1aruvsWYha6BbHGWoeOjcSQRYoOjOgISMluENckZqMrqBsjLJ3zmKH8jFXb+CpD8jpdgQM6QrF3c1uH4tY5tBJwJKSyPxuJRRxcSGl+fSGnXhLNVgA7VNwzbDHCfOKdEtkGKFsRON6h9ajRWw2W79r5nAe1BS1if2C0zSRBcfRwnwF0XsrvxTOYsJdQsvkEFmOh+TUjrOBeFtppZK+S7KWvIEXU8KY3Z3B2MTpIdImz0uiSAgsPmpvzYPlbsC2trqg4j5G9HfNKMWPtzWZIXaSfWPjU8/wdSp+iei22VLykIGM3kT4g41b/EEGTqQN8LP/IRNxXSzotMGKXoTCrU8dOSql9B6oIILvMna9p4E/KH1tPgsQdgNqnlToz71J7rBg6gt7adpxrQMhw==
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(23010399003)(61400799027)(10067099003)(22082099003)(16102099003)(18002099003)(56012099006)(11063799006)(261022105027099003)(261022075727099003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1QY5X6JWHATa6jajNIUDjLqMasuOIY3L2mjZXQXy27abVEbSTd/lKn/IDSWZaoymxnMepxT8r99f0xuqT56YmfCiZ3FZ3phfAI3Je31Q8ygmIUwC+JnqnzLl78flGIfR7b0FTGFSQIounTWVMNpbHTfnUE0Xho5ARD5pMgFD7rbckknXNLW2M+XvYb+mRygL6XnQ7nxP2g6LGj5PRkoLFi96t43Yvk7C+gNVLN06zUXHJgN1U/SAeQZlhZgdq1X2J6G0HoP8+oSBKiCPb5lrwmcgMNivY/7yyNB29pSl0OQoPa5JRJ7KM346DPK/zZSje2hbbaJL6xsZP+KAV+tydcqi7WjoMCmPLlaN3UoKMUj2HgPxLpZrtnMQ39+l06GQcQmFIR6XZVU0Ae8+B8mz75h+bG1EUhM0OpGzVyfxgEfukg+nI1HlbUk9WVpE/szh
X-Exchange-RoutingPolicyChecked:
	wSh3z4SkvFSxDg//FOOt83uXIzOcvQh/yhnCzzjOdTxVOr7Vjj12aDMnLdS5NENFYeupaQ45dSSW8WG0jR6k8IYQrcbBOWvclHy9AHCd+bZmbeXzU/ArKSCNV08Gsv7aHeAm+26Wus/hmB/VxIW4fKkyHEHUCyaQ4+IJqEdmSyYoUL5W0Fxub01QnwZXJqnBWNTHKTM9W99sDxAfhEuEdhr7zfdlTIkN2CDzCtTiPXIhged4fXQdhe8f875bp46zsZuoQWikFRTLEmOmjvXIJ8DlRbHr6kvdRsdFLKUwFE3viwA69J8083rZGXZJ63gs2tRP9lOhGYQh14EcEG4S/w==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:26:56.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b97c424-24bc-46f0-3b0b-08df38ed596d
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-CH3PEPF0002457D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7754
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA1NyBTYWx0ZWRfX3EUbhG+fQNBh
 /8Fyjylt9hhkouZoBXlsovETUU9vusqIjZfoSjs+jQicOnrS9RTZm9ToNte8FPmD9+C55JTCKfN
 GjcWtvzJ3mIYcGgtm1vfVJT7Pme/hehabHJMnD1MNWUNQgujkkVtaSWqMzZcKPSX0uK7u6afl03
 fC0us8Ro4/lht2pZWQjRRAOtC3pDHHhLg+pGv7liBnJfct9q60H3Xch1vsVi2KxtprKID5u9pT2
 2tE2hQil2yW8SScx+nF3ueawx+FaF6JZH/dnrbU5r0Gg6ILl6o8ttFRP35LOdHPvhb4Mubtx6F6
 tSgHhAH0kxdBv2uQ/ieojqyZXZBCJ4iY6adYXek/Ugi3Y/tG+YX0gbjGU9i6gRd6q6HuWBhQwEU
 nkaKh/u5Aoj1rCFCSEtww7RUPYOAUGVwc2BU65F8H3c5WGmjXubNETXxsceL16E+/sXdrSJE0oV
 TdlwqOhfLp8vmzYsSCQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA1NyBTYWx0ZWRfX8kOhyHO+ssGy
 y5J9XU3n4RN6k2SMa5eNZEt9imh5DTeJSG8FzzVPyGq2YTn0hVpfblWxR09z4/W/Dj98vT6sXkv
 sfflcGTsIxofTvUF+J4xMKwDpFxS+UQ=
X-Authority-Analysis: v=2.4 cv=LtgHWXdc c=1 sm=1 tr=0 ts=6ae89db9 cx=c_pps
 a=Gvitfrn81X/13pqoc+dbVQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=uMr1uQFKAAAA:8 a=w1d2syhTAAAA:8 a=_2HNRW33gJ9vRV-SH_sA:9 a=CjuIK1q_8ugA:10
 a=mA13xv-6rAYGTomVCS-P:22
X-Proofpoint-GUID: FMpucnuGJu-duAcTeOlrJWvWTH3Ts03x
X-Proofpoint-ORIG-GUID: FMpucnuGJu-duAcTeOlrJWvWTH3Ts03x
X-Proofpoint-Spam-Reason: safe

On Mon, Nov 02, 2026 at 12:25:14PM +0000, Pawel Zalewski wrote:
> Use a designated initializer for the acpi_device_id fields which makes the
> code more readable and consistent with how lists are initialized in the
> rest of the kernel code base. Also drop explicitly setting fields to 0
> where it is redundant.
> 
> Unify the list terminator to have a single space between the brackets and
> no trailing comma.
> 
> Signed-off-by: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
> ---
>  drivers/mfd/cs42l43-i2c.c             |  8 ++---

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
