Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E780C3E40EA;
	Tue,  6 Oct 2026 08:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276196; cv=fail; b=uQASL5uUv125xqetAhuwIeCZ7lNN/dRvTDb5G2CMCUHDsEV/8fxKD4CF14l45IHfDygzvEK/A2hysiB7WhJfO3mNiU+fVTP2UtNYSLNbe7IUA+miJgZrXpWFnX2Hqu5TBoYiIZYpfnZQ/L4+g+gszLhkmT4NzmUB57o6kltw6Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276196; c=relaxed/simple;
	bh=AbzzehUTX3ljvCzGyAiR5Auj46tSo7X+7sISp5mbUcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YjJQQK5ZCzhLEMjWX1qezVo30qVqr24tPLGg6xXzvmf4X9kljTmos7JqdSLJnbbmX0W2CIQFcSDACnnm6PEUwFJ/E2Fc58lDYl0B1YkoGqQtb2L2j6kfez17RnDXhxO3jFGBvreIZdmIEvaHoawH4JCfjh1LSSB1D/lmA0n0g2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=fed2IdZX; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="fed2IdZX"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6966dxjP2718149;
	Tue, 6 Oct 2026 01:42:46 -0700
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020088.outbound.protection.outlook.com [52.101.85.88])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4h4983xfca-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 01:42:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H46vtGJ7RQr2rUG4Jnd5q4RM5rZZfBki3+hPgJGxxyQuSnOuqDHsrf+MAP8do1gGRVQSGptwxdtDztnSVreonQsAjO5RnQWhi8ollFQVJuwgrDmsTMLmFK2F8YlmWNsac9TWwWXIsNB2T7nBKLRkXU+TJujrtphjnyVBEKIsrt8CUXGmhHqGpGJ2kbrY3gAcVibYGN+ROmd3rj9kJTEPZFCvU7K5xqDCFzLSkIcKXcaeoI9Kf2yq3kqXqSAqopo4hlsz2kGZzgHWWBUTt2XqkbQJZaHC1q5cJBxQiuAWxLExpdnPRS8be4w6rXFAzlXQJd4TosGa1XzHJVKwfX/ooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbzzehUTX3ljvCzGyAiR5Auj46tSo7X+7sISp5mbUcY=;
 b=OSlhzk29/IHQlDwl4n/0AeujJ6sQgMlS1uVsw72/TNazM3B20gTNzuRCPVdlbegpGR6GeiuuMFdcQVXPKykqVo5KpMRZqZ9y+2rWrfPvPIfpmRmQd+Gihx3mjpfAIc5NWZXFfOFRBMzGyWsjCMwKlswnGB2L7gWMwuu7+OSrRepLybKgA6QHKaiij2RJPF63DxAjmc0ZroCOwdB0VQLR9SSJsOauonWVp84AQG+ZALQRtq002r1mP9y6g98+xPPOzruZJzdkeFiiNEbWj63IAnWTaltwkLTf2bNx1o6KWuEmLb6Nd9qYxPsY1gfYBam+X5hx4VfqaqsN/5TZ9ycOwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbzzehUTX3ljvCzGyAiR5Auj46tSo7X+7sISp5mbUcY=;
 b=fed2IdZXX8NWH3+8BalZmcHkkX/vIzrKP767N5/EbqnxOvr40V23q+pW2o/lQQ7srtoiRuKw6otpiP78iUQt55CRTzJmmew907JLC/DYlbuU9zTzymCfohGIf4m8Q6Dh21ky9oqlsy4QNlrw/UUFc1XtJnNRzn6Zv65HvihjRyQ=
Received: from CH0PR18MB4339.namprd18.prod.outlook.com (2603:10b6:610:d2::17)
 by LV3PR18MB6176.namprd18.prod.outlook.com (2603:10b6:408:27a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 08:42:40 +0000
Received: from CH0PR18MB4339.namprd18.prod.outlook.com
 ([fe80::210a:9dad:297f:3540]) by CH0PR18MB4339.namprd18.prod.outlook.com
 ([fe80::210a:9dad:297f:3540%5]) with mapi id 15.21.0472.015; Tue, 6 Oct 2026
 08:42:40 +0000
From: Geethasowjanya Akula <gakula@marvell.com>
To: Emanuele Rocca <emanuele.rocca@arm.com>,
        Sunil Kovvuri Goutham
	<sgoutham@marvell.com>
CC: Ratheesh Kannoth <rkannoth@marvell.com>,
        Subbaraya Sundeep Bhatta
	<sbhatta@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Srujana Challa <schalla@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Tamar Christina
	<Tamar.Christina@arm.com>,
        Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [EXTERNAL] [PATCH net] octeontx2: use arch_extension to enable
 LSE
Thread-Topic: [EXTERNAL] [PATCH net] octeontx2: use arch_extension to enable
 LSE
Thread-Index: AQHdVOXYzAVs2Ij4PEKxkOeB3PGserbwMyZg
Date: Tue, 6 Oct 2026 08:42:40 +0000
Message-ID:
 <CH0PR18MB4339334C066191D935ABD90DCD952@CH0PR18MB4339.namprd18.prod.outlook.com>
References: <20261005162137.71397-1-emanuele.rocca@arm.com>
In-Reply-To: <20261005162137.71397-1-emanuele.rocca@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR18MB4339:EE_|LV3PR18MB6176:EE_
x-ms-office365-filtering-correlation-id: 5df73b84-c944-4f60-94ea-08df2385c843
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|38070700021|11063799006|56012099006|10067099003|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 ooDP/SyKr4zn4T6y5VljyAPDPGXRB5IUwlRYWIcX4ZgT4Dqbuk2GygNENJozAdsercRffaN364DAOx5HQH5uAjBru8bHWJ1uyzpT+GjZW5WsnacayLy+Hjz11zPeAKvD8iyt+rzdB1UtAG2ZJaNKTfzYFX6KAvb09peDg7xTV9oM87IrdrRfPnpwL9K3cWVsWHkyF2jNretaPzeJvv0LAmGli9TFbN1b8ny2DcMMgi3bfr/UZ5ao5eKa8eVwYypfrlbQALfH8e1yLMYLKZQ2pM819nIvk8qjJ1JIh5od52lC+aQSGwcIjbLBuIi66ZLOAeZ9vA6n10isFduR1lJN/n/nchHf0z6GRXGeGf5DK/fSpEaUh5NNcpDB9PsXpj4z5mAzTW9G3vR7zBnkaYRMKUMx3HpWHkr9a4GJLoCyNxHPXAET67g6vBt0Vz9QP+blQ/AAU6tTdmqqNlsOHmZrdkijYpVpQiC8t2nFS4ehmauC4CKWzSdEAZqWb8yxMCjv6BOD4DR8iG8Xd43yogRqeRicFS5b9cd2AoCNr2e96mkg+E5f92W+GKvahjpfM3Qywr+blldERfm5vS2hW+J5DpBrcFixwNk7zzBRGnckr0x7eA+YQuBdNt4exvPhEEY/tFVgoFdoory349vPV6MGyB+VPWCg7bwrqOnF/8jDwiEVzQdsgGRfQCcNVMMkUzIBJC02hmYhyxcs9fJU9svfRQ8UacIbEJm+UYrgcvv2k64=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR18MB4339.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(38070700021)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bXArRGZmWm4zQ1ZRKzNtU00vemp6N2xDVnJIR0NZdHh5dW5wVmJLSktKdnZI?=
 =?utf-8?B?REhmdU05NUlnTmo0SDlKRjhlOVRmV213UWwzMlJuUDBxaXp4a2VTcUt6aTlK?=
 =?utf-8?B?MG1CYlhxTWptbXpUNWFMVktpUDVGd3V1TmFuM1VZUnowK2Rrd2tSR0srYytt?=
 =?utf-8?B?dWh0U0tML1VFQURicUxsMTJKQ01URUlHQS8rT2ZadHhVZ3hoZVdXb3F6cXVn?=
 =?utf-8?B?TkQ4SUhZTFM2bVNDeEdUVldORnpBajV6RDVOQkNVVjdjdGg4L2xnZ2dNcWxo?=
 =?utf-8?B?WVdTYVV3MXBia29la3dCRmVQcUdQWjlXZjNhcWl6ZiszRzI2NEpUQnZNcFV4?=
 =?utf-8?B?NVlMeHB1SUFDekxtUEdDdU1pZWVxeVBCRXVZS3dlSUhoaXh4NXBkekJoRStv?=
 =?utf-8?B?MGhya2dOV0ZJR08rQlk4NHJicngycDZHbHQzQjlORGpKS3pFc0pSUHB0Sk0z?=
 =?utf-8?B?YUNONVpFeitVbENLUzdyenpmaTlOWGhMaFl5MDBIZDd3QWtraEE4VWJya1BM?=
 =?utf-8?B?bjZSZ1Y5dk0yU011MmYwc1hRSnd5dTNqSHJTcG01RlFCeWdxZkRLZXlWN3B0?=
 =?utf-8?B?N2RUTVdYdlBYVFdCLzIzc3NYcVhtNWszTS90YlNJT0tTa2RUcTBWRjRtQ25i?=
 =?utf-8?B?d1duUkxUalF4VnAwZ2p1clhFd2NNMVJxZXBIc0dNYzN1MFpJaUZ3M0g2Vkow?=
 =?utf-8?B?TTJTOStWUUV3dDdsdFZUcE53UkxtL2tiaDhTUy8zQldCRzJrYkdTaFJadTha?=
 =?utf-8?B?aVZqSUZOVktVaFJNQURHL0h6TUVqUXJ0OXNmZk9MTmIxMjlpQjVBM2JLTytq?=
 =?utf-8?B?VkRGRm1vNEEwMFB5UlpsTHhKc2FENC95UjBCcXdQaGtTdXJmOGlrR1N0WVpJ?=
 =?utf-8?B?cG9jZTBTZ29ZeTN3SjIxNjgxeUtBdlR2WkVoaFQ5M0ZTRVRwKzlSdllORitx?=
 =?utf-8?B?R1d2UmFPM09OaHJHbnc4eDZXY1d2Y1UxNkdDRFVKQ2hrSzZYcThEcGtWb2po?=
 =?utf-8?B?c0doZjJBTVVXSnQwZXMxRzJuZkNHVGswQ0ppVmhKZlFNRU1xbWF3R3YxZzN4?=
 =?utf-8?B?Z2dhQjhjcEcvWmlkK0pGVzlLd0p6cjFsZWhyUnFkeW10NlpNQTk4VytYZndT?=
 =?utf-8?B?R2ZqcGpTUmh1a09Td3BiYUM0UE5scmNlL3d0L3htMkNtNFFNTDFmRTZFdFFq?=
 =?utf-8?B?ekgzRG1VVGVoR2h6aXFsNTI4R3BrVUhmcGhqZXNiRG1WRTN0alZrdlduZGs5?=
 =?utf-8?B?SFJweEdZSXJ3Y1BRQUdDbEk1STZNMjk2blNpNUxPU3dZRDhQMGNxWGNWRzd6?=
 =?utf-8?B?dDBLbzNMMlRTTjVFOFgrRVk0K0g3N1QzZ3RmckdiVzdQMEQyRitERUpVWjkw?=
 =?utf-8?B?cEZzU2VycnJnbEtWMjRBZEhRQ2REdkhoWDZqd0hhU3ZHNXZpWk9jZk4ybVdH?=
 =?utf-8?B?QW5oZWZJSGdPa3d0a1VKc1F6NHRKZWZSK1VvdUtrRDBpZVFnZDVrR0RaNzlx?=
 =?utf-8?B?WS9SZHR1Zldkd1d0V3JoYTU1bVpmVVd4SG5aTm93TnVaY2lZSWM3V0QyRW5l?=
 =?utf-8?B?Y04rMVpnQWhnYXIzdEtObG0wSi9iRzV6eW91cFRoRkRydlZiYUhZVkpZM01O?=
 =?utf-8?B?MjdieWZqcnpzWW9Wei9hR1d5aXQ0RW1xaDFNWVFuRHQwMVpqWktOVU1xdHRE?=
 =?utf-8?B?U1hQekNnbUw2UHcyMFlvTlN2di9jYlIydVZRVEpldTJUYVNyOGFvelpZSDBS?=
 =?utf-8?B?WHlGTU1LZVBlcFNFZ1hSY2VpaEo3MXI1ekVWR2FWRnY5eERLZmY3RElqNDBS?=
 =?utf-8?B?ZmFEOVNyUE5LbTFORG5kMkNzUzFJeGJwQTFpY2xlTGZJUU13Q0lUQmsxRWRx?=
 =?utf-8?B?SWs0ZTZsQnNrSWkydEkwZ003T3FobVl3OWFwTEh6NlkvRjNleCtUeG1sZ2Vh?=
 =?utf-8?B?dXJSYVlZZEtiUldrN0lyM2N2bFNnWkVnU0c2dkpaME50TXl6RWJuazVoNkJY?=
 =?utf-8?B?S3RyNzhDSkZwTlNWSmNBK0NZYk03a3dUYWdramlrT2JKTzRwSmdkcTdFWkVz?=
 =?utf-8?B?eEFzeUtDd2VDVWRuMVJHWjJZUFJnSXFrUWovaUVWU3pQcldrWDQ4Uklla1BD?=
 =?utf-8?B?ejB6dzdBcEZaT1VaQk9NeFBhOG9YeHlKQ0MrNUZ4RUNPMk1MNmxPUGk1bmV3?=
 =?utf-8?B?VHlYQ0RnaFVuc2poS0pKTGk1eDh5Yi9QOXJTenFCWGhzS0FXOGxPdXg2SlJO?=
 =?utf-8?B?SEVOd1d5WUQzNVcvU0k0N01jOVRtcDlmUzVaL3R0cE1HdUFERXQ4WU0xejdX?=
 =?utf-8?Q?+ZRgFREi3Aoi+pPbKT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Ytp9BXPQRsMckCYG1QAd/Uqt/LzuZ/E8OkLC5EiYf4RLW7EcZ2eSgb9SQnln25RETye0/Y5RIevsBIxgS82JG9+cR/mDHK1q1gF6tSevX387hRfINz0jpEI5bXLIO2t5+8Av+gyts4xl6hsmueEDCqcIuqOMdnlSwkguKsLPmlk5OzoSCeUcji5fYLfo3K35CvcGxGfjWcCXOc4n8yV7Joso7V1tYycRZ7ygR/LRiRZlJSeAAtcNI53pOdJNhNIvWa6aipp1IhQ/kK9SJ4UN5px6eGajJ/Bkkmx7IkuPZDn/VxHbqJPncJ/Jr2wN35tILzmJBTPNdRUSvD40IUa+kg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR18MB4339.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df73b84-c944-4f60-94ea-08df2385c843
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2026 08:42:40.7007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7e7QeGkRTygh2aPP84MnJgjM4szETuxo9bVnjdtZ2VoYm557HjUJfGbjnELYpjcbSsVL2e2Li90yf/ZHjIV5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR18MB6176
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAzNCBTYWx0ZWRfX3oz+V34Alg9a
 oCn2X/2b0kiUSjJbIJ9jucCldpc2TgUsi7MlqOTNk6aHBMyvgc7Qs/ayWB28bu6ZSDiYCS8r7Jd
 IsxRNbn7AXUuOhOwXB5TdQb0JirGGX50ZjVHl9w6ovUdi4mi4zWihi1iyJCBZ7OtGWt/14ki96s
 8EM6msHxfJTMDHwFUXfbuhlFH4IllXBdgqUp+WLckgZvYfU1CtnPn+2foTV6rKBYSwxxmAajYx9
 +eU9mjLBidsVdOEAXevydv8se/aOxgHna8plbWhpYl3BWCfESEY8ABe6iObOOwnFuUmzhJnFNFW
 JReEsdQe9SKn+WHzjrevVHeFZp51NoauTlCX2HxpKzy8PtSE0AE+KxJZ+uHxaAg63rbBKg17Acw
 4SlK8s2lAv9wf4OyC0Yi5aPpojZ57zCcs8OiGPtdDEzyh6EUpUyGLbz7qFURnhngQGr0MeO3A6e
 Pg3UZifayzKnlYi6txg==
X-Proofpoint-GUID: CTK-fheunMl8Fcl790PdCvG-4uVs0TK9
X-Proofpoint-ORIG-GUID: CTK-fheunMl8Fcl790PdCvG-4uVs0TK9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAzNCBTYWx0ZWRfX00y2z7ZK6IvT
 tL2VLbMWAJ3m8F9erXp2Acuda9i0a4HLXK8OhIWalIP5neG483gpJZ7noQv8gUO12hSsBSHDRT1
 3kqlMOVYHWKwpGm31S1AVQ6F70s0LvA=
X-Authority-Analysis: v=2.4 cv=X+nHu2Te c=1 sm=1 tr=0 ts=6ac4b485 cx=c_pps
 a=RH0axx9bUT6qb0hBLGrbHA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=7CQSdrXTAAAA:8
 a=M5GUcnROAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=JfrnYn6hAAAA:8 a=L3Ky75s1M_vEGjJmoJ4A:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=OBjm3rFKGHvpk9ecZwUJ:22 a=y1Q9-5lHfBjTkpIzbSAN:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_02,2026-10-05_01,2025-10-01_01

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEVtYW51ZWxlIFJvY2NhIDxl
bWFudWVsZS5yb2NjYUBhcm0uY29tPg0KPlNlbnQ6IE1vbmRheSwgT2N0b2JlciA1LCAyMDI2IDk6
NTIgUE0NCj5UbzogU3VuaWwgS292dnVyaSBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4N
Cj5DYzogR2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IFJhdGhlZXNo
IEthbm5vdGgNCj48cmthbm5vdGhAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0
dGENCj48c2JoYXR0YUBtYXJ2ZWxsLmNvbT47IEJoYXJhdCBCaHVzaGFuIDxiYmh1c2hhbjJAbWFy
dmVsbC5jb20+Ow0KPkFuZHJldyBMdW5uIDxhbmRyZXcrbmV0ZGV2QGx1bm4uY2g+OyBEYXZpZCBT
LiBNaWxsZXINCj48ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRA
a2VybmVsLm9yZz47IEpha3ViDQo+S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFi
ZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IFNydWphbmENCj5DaGFsbGEgPHNjaGFsbGFAbWFydmVs
bC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj5rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0tDQo+a2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmc7IFRhbWFyIENocmlzdGluYSA8VGFtYXIuQ2hyaXN0aW5hQGFy
bS5jb20+Ow0KPkplcmVteSBMaW50b24gPEplcmVteS5MaW50b25AYXJtLmNvbT47IEVtYW51ZWxl
IFJvY2NhDQo+PGVtYW51ZWxlLnJvY2NhQGFybS5jb20+DQo+U3ViamVjdDogW0VYVEVSTkFMXSBb
UEFUQ0ggbmV0XSBvY3Rlb250eDI6IHVzZSBhcmNoX2V4dGVuc2lvbiB0byBlbmFibGUgTFNFDQo+
DQo+SW5zdGVhZCBvZiB1c2luZyAiLmNwdSBnZW5lcmljK2xzZSIsIHVzZSAiLmFyY2hfZXh0ZW5z
aW9uIGxzZSIgdG8gZW5hYmxlIExTRS4NCj4NCj5UaGUgIi5jcHUgZ2VuZXJpYytsc2UiIGRpcmVj
dGl2ZSByZXBsYWNlcyB0aGUgYXNzZW1ibGVyJ3MgY3VycmVudCBmZWF0dXJlIHNldA0KPndpdGgg
Z2VuZXJpYytsc2UsIGRyb3BwaW5nIG90aGVyIHByZXZpb3VzbHkgZW5hYmxlZCBmZWF0dXJlcy4g
SW4gY29udHJhc3QsDQo+Ii5hcmNoX2V4dGVuc2lvbiBsc2UiIGVuYWJsZXMgTFNFIHdoaWxlIHBy
ZXNlcnZpbmcgdGhlIGN1cnJlbnQgZmVhdHVyZSBzZXQuDQo+DQo+Rm9yIGV4YW1wbGUsIHRoZSBm
b2xsb3dpbmcgY29kZSBpcyByZWplY3RlZCB3aXRoICJzZWxlY3RlZCBwcm9jZXNzb3IgZG9lcyBu
b3QNCj5zdXBwb3J0IHJldGFhIiwgYmVjYXVzZSAiLmNwdSBnZW5lcmljK2xzZSIgZHJvcHMgUEF1
dGggZXZlbiB0aG91Z2ggaXQgd2FzDQo+ZW5hYmxlZCBieSBhcm12OS1hOg0KPg0KPiAuYXJjaCBh
cm12OS1hDQo+IC50ZXh0DQo+IC5jcHUgZ2VuZXJpYytsc2UNCj4gcmV0YWENCj4NCj5XZSBlbmNv
dW50ZXJlZCB0aGlzIGlzc3VlIHdoaWxlIGJ1aWxkaW5nIHRoZSBrZXJuZWwgd2l0aCBHQ0MgY29u
ZmlndXJlZCB1c2luZw0KPi0td2l0aC1hcmNoPWFybXY5LWEuIFNpbmNlIEFybXY5LUEgaW5jbHVk
ZXMgcG9pbnRlciBhdXRoZW50aWNhdGlvbiwgR0NDIGNhbg0KPmFzc3VtZSB0aGF0IFBBdXRoIGlu
c3RydWN0aW9ucyBhcmUgYXZhaWxhYmxlIGFuZCBtYXkgdXNlIHJldGFhIHdoZW4NCj5nZW5lcmF0
aW5nIFBBdXRoLXByb3RlY3RlZCByZXR1cm5zLg0KPg0KPkZpeGVzOiBjYWEyZGEzNGZkMjVhICgi
b2N0ZW9udHgyLXBmOiBJbml0aWFsaXplIGFuZCBjb25maWcgcXVldWVzIikNCj5TaWduZWQtb2Zm
LWJ5OiBFbWFudWVsZSBSb2NjYSA8ZW1hbnVlbGUucm9jY2FAYXJtLmNvbT4NCj4tLS0NCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfY29tbW9uLmggfCAy
ICstDQo+IGluY2x1ZGUvbGludXgvc29jL21hcnZlbGwvb2N0ZW9udHgyL2FzbS5oICAgICAgICAg
ICAgICAgIHwgNiArKystLS0NCj4gMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvb2N0ZW9udHgyL25pYy9vdHgyX2NvbW1vbi5oDQo+Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9jb21tb24uaA0KPmluZGV4IGVlY2VlNjEyYjdiMi4u
YzUyNWM1NTdiMzhlIDEwMDY0NA0KPi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
b2N0ZW9udHgyL25pYy9vdHgyX2NvbW1vbi5oDQo+KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfY29tbW9uLmgNCj5AQCAtNzg2LDcgKzc4Niw3IEBA
IHN0YXRpYyBpbmxpbmUgdTY0IG90eDJfYXRvbWljNjRfYWRkKHU2NCBpbmNyLCB2b2lkDQo+X19p
b21lbSAqYWRkcikNCj4gCXU2NCBfX2lvbWVtICpwdHIgPSBhZGRyOw0KPiAJdTY0IHJlc3VsdDsN
Cj4NCj4tCV9fYXNtX18gdm9sYXRpbGUoIi5jcHUgICBnZW5lcmljK2xzZVxuIg0KPisJX19hc21f
XyB2b2xhdGlsZSgiLmFyY2hfZXh0ZW5zaW9uIGxzZVxuIg0KPiAJCQkgImxkYWRkICV4W2ldLCAl
eFtyXSwgWyVbYl1dIg0KPiAJCQkgOiBbcl0iPXIiKHJlc3VsdCksICIrbSIoKnB0cikNCj4gCQkJ
IDogW2ldInIiKGluY3IpLCBbYl0iciIocHRyKQ0KPmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3NvYy9tYXJ2ZWxsL29jdGVvbnR4Mi9hc20uaA0KPmIvaW5jbHVkZS9saW51eC9zb2MvbWFydmVs
bC9vY3Rlb250eDIvYXNtLmgNCj5pbmRleCBkNjgzMjUxYTBiNDAuLmE5ZDI5ZjVkNmVlYiAxMDA2
NDQNCj4tLS0gYS9pbmNsdWRlL2xpbnV4L3NvYy9tYXJ2ZWxsL29jdGVvbnR4Mi9hc20uaA0KPisr
KyBiL2luY2x1ZGUvbGludXgvc29jL21hcnZlbGwvb2N0ZW9udHgyL2FzbS5oDQo+QEAgLTE3LDcg
KzE3LDcgQEANCj4gI2RlZmluZSBvdHgyX2xtdF9mbHVzaChpb2FkZHIpICAgICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+ICh7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXA0KPiAJdTY0IHJlc3VsdCA9IDA7ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPi0JX19hc21fXyB2b2xhdGlsZSgiLmNwdSAgZ2VuZXJpYytsc2VcbiIg
ICAgICAgICAgXA0KPisJX19hc21fXyB2b2xhdGlsZSgiLmFyY2hfZXh0ZW5zaW9uIGxzZVxuIglc
DQo+IAkJCSAibGRlb3IgeHpyLCAleFtyZl0sIFslW3JzXV0iICAgXA0KPiAJCQkgOiBbcmZdIj1y
IiAocmVzdWx0KSAgICAgICAgICAgIFwNCj4gCQkJIDogW3JzXSJyIiAoaW9hZGRyKSk7ICAgICAg
ICAgICBcDQo+QEAgLTMwLDcgKzMwLDcgQEANCj4gICovDQo+ICNkZWZpbmUgY24xMGtfbG10X2Zs
dXNoKHZhbCwgYWRkcikJCQlcDQo+ICh7CQkJCQkJCVwNCj4tCV9fYXNtX18gdm9sYXRpbGUoIi5j
cHUgIGdlbmVyaWMrbHNlXG4iCQlcDQo+KwlfX2FzbV9fIHZvbGF0aWxlKCIuYXJjaF9leHRlbnNp
b24gbHNlXG4iCVwNCj4gCQkJICJzdGVvcmwgJXhbcmZdLFslW3JzXV0iCQlcDQo+IAkJCSA6IFty
Zl0gIityIih2YWwpCQlcDQo+IAkJCSA6IFtyc10gInIiKGFkZHIpKTsJCVwNCj5AQCAtNDAsNyAr
NDAsNyBAQCBzdGF0aWMgaW5saW5lIHU2NCBvdHgyX2F0b21pYzY0X2ZldGNoX2FkZCh1NjQgaW5j
ciwgdTY0DQo+KnB0cikgIHsNCj4gCXU2NCByZXN1bHQ7DQo+DQo+LQlhc20gdm9sYXRpbGUgKCIu
Y3B1ICBnZW5lcmljK2xzZVxuIg0KPisJYXNtIHZvbGF0aWxlICgiLmFyY2hfZXh0ZW5zaW9uIGxz
ZVxuIg0KPiAJCSAgICAgICJsZGFkZGEgJXhbaV0sICV4W3JdLCBbJVtiXV0iDQo+IAkJICAgICAg
OiBbcl0gIj1yIiAocmVzdWx0KSwgIittIiAoKnB0cikNCj4gCQkgICAgICA6IFtpXSAiciIgKGlu
Y3IpLCBbYl0gInIiIChwdHIpDQo+LS0NCj4yLjQ3LjMNCg0KVGVzdGVkLWJ5OiBHZWV0aGEgc293
amFueWEgPGdha3VsYUBtYXJ2ZWxsLmNvbT4NCg==
