Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023089.outbound.protection.outlook.com [40.107.162.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1372D4CA784;
	Wed, 30 Sep 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.89
ARC-Seal:i=4; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787320; cv=fail; b=LZgMlbhWVxwj6wkhKkVDpMxQq5f7S3CmNfyzC2y51l2naP/nGlFDYPfvVWzcwbHiHQT+/vNKWiVU+1NKcJp5c+ZdeAkvCdA6dU+x2XNHUA0yVR+fXeUnFdQ7jUcuwLYD/CZY31Kwtu4fL+XCox+aaVKiItdlCVHX/RMPueegaVg=
ARC-Message-Signature:i=4; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787320; c=relaxed/simple;
	bh=pjHgPm0svVOjkpyuIDklYewJ2k+Foa1jlIJ5R6O2kHs=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=FTW5IC2HhTePkkb2DsZMqJQ2Wc4HEvmc9n153LMTUJg6SAP+EF0aE2hEPHE5JKc6uOH6f6xQ35/04fTl+ScYsLvSGTCJT5jwqKIEbdGAPq+BuBHhw4AyIDaQXcGxmt5iz/kpWcePLPhvbyn0oHzuNOlPueLrRtn3lgfoNpkmoJc=
ARC-Authentication-Results:i=4; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=lttcV72T; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=lttcV72T; arc=fail smtp.client-ip=40.107.162.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="lttcV72T";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="lttcV72T"
ARC-Seal: i=3; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=n+lrUIuR58FzIe+XoIhkTOjTKItFxplKlMjvDYiUpnEW056K11Fz1b5YfMzHpIWwb4ereaBuNxDUUgLDoYbS2wEIk3WAM99sSo/IGFD6hdfcCb+d1deYWcrjocv9onwrigdZ0o8BTjf1CEpQ50WdSxSQGCNPHJjPpOV/EIUlDsd4LtqZfjYwmz6f0hBPZHSmoAAfZSYj2kZ5cD/o+BOCunINrcr7+VAR3Fb9HHJfucC879ruiurPAqK5lo92gb7aB7vI/XJVi+NYx0UqQLnYfXmIw02DBKXbICyCpot5q5EMiYlz04xQikjoDtAMpnx1C3TqjUgOHUDhZ1SPaiZb5w==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dloxuTDLJqdnj+JbQ3wteTr2VciS6EA6P7oYSHkW88=;
 b=pfIiBa68AX8gIroMec+7lY4M+WTrnzus5Q/E7nKxYSxVqC48xqqM+5+IJQ3Z+1mcCXr9z5WWkUF9W9xlwL8Wj3HHCI7VN5gsE20A1xWA1y5SwCbbBIWX3jESrOIxcFTpdIHzQXYQBIF2WJFp+ZlZvCEjMlGxMtQip14SmSfq3dcxo/vsD4TrSALuycYuShy/rt+DLRYj6b1b3YbRhM27fjKOoa4KQrLfbcLraR4GmPtBdsLOOlEwNxaYA1xF9MK3dT52rtVSbyljJxE1R2JZjlZvrDxDNIyX5kBkohiKzEvhl2qDnTWAkZDGCAORmw8gH3PyKylCGj5NwqALT+yyuw==
ARC-Authentication-Results: i=3; mx.microsoft.com 1; spf=fail (sender ip is
 52.17.62.50) smtp.rcpttodomain=davemloft.net smtp.mailfrom=solid-run.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=solid-run.com] dkim=[1,2,header.d=solid-run.com]
 dmarc=[1,1,header.from=solid-run.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dloxuTDLJqdnj+JbQ3wteTr2VciS6EA6P7oYSHkW88=;
 b=lttcV72Ti3nLiRx1KLFyNxJ9y2kMZrRqXwZwrRSzfDz2IqKHyT/nT/oVN2ZEFr+FKa3pdYndRUc5lls7+wZ33FwezZadNTH6HCTZnYBv3TToDK/+qoC+wH3l55bKWdXy9Ie+qeaZe7t7m9lTh//G5q19Q+hhCdzbwucR7mKYpFq/M2UKmeNOlGP+i3VRn1S6IQxxBk9ZB52jvbQrXEeoZK/xv2QmXSpF9705ufi4GSMg8pLEAjyzPjBSzO0mIofknQh+lO+pOmjzLGJWNbFDTcNQ3ZfmlixMsRbGjERpUREZ8Yyu1oM18DZVht22AlWeP+l1kWX3vJFdLNPRGZJUjg==
Received: from DUZPR01CA0221.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::28) by VI2PR04MB10785.eurprd04.prod.outlook.com
 (2603:10a6:800:26e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 16:55:13 +0000
Received: from DB1PEPF000509EC.eurprd03.prod.outlook.com
 (2603:10a6:10:4b4:cafe::a0) by DUZPR01CA0221.outlook.office365.com
 (2603:10a6:10:4b4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 16:55:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 52.17.62.50) smtp.mailfrom=solid-run.com; dkim=pass (signature was
 verified) header.d=solid-run.com;dmarc=pass action=none
 header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 DB1PEPF000509EC.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Wed, 30 Sep 2026 16:55:12 +0000
Received: from emails-91475-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-6-124.eu-west-1.compute.internal [10.20.6.124])
	by mta-outgoing-dlp-942-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id AF1647EE67;
	Wed, 30 Sep 2026 16:55:12 +0000 (UTC)
ARC-Seal: i=2; cv=pass; a=rsa-sha256; d=checkpointcloudsec.com;
 s=arcselector01; t=1790787312;
 b=Uxwl0/aw2lwWLpelRbqlOoXviBKQ/yY/3dtqMn/5qVV4JgcuMFSt3lOlKi1rAZOmU9rNu
 tQwsazRrgTL7Hf6x2n18lGeJNJBGw/7x3yqvLXaUbP+jPgaDKVWiI/5Y7szuwhT0i+XXeF+
 PuZGrYEBGavTEq5NtUrj7wqg7XMu3gU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
 d=checkpointcloudsec.com; s=arcselector01; t=1790787312; h=from : to :
 subject : date : message-id : content-type : mime-version;
 bh=+dloxuTDLJqdnj+JbQ3wteTr2VciS6EA6P7oYSHkW88=;
 b=aOOEzho4Wn7rJOeLG0HgnIZSq3ZUOoUxkmuTgNgaowHy3vzc2Ft4AmFrCKz9LrHtd9oZF
 bayLjDxo4+pHmVOerccI+CtbMsL+9v5JlBwWUGPPbKdTXlPMkjlnQqJ+nzzOldu4ZA5BB3c
 qCNa9Lys5I9+NBzySoA9aBFp7pSn6Xk=
ARC-Authentication-Results: i=2; mx.checkpointcloudsec.com;
 arc=pass;
 dkim=pass header.d=solid-run.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dloxuTDLJqdnj+JbQ3wteTr2VciS6EA6P7oYSHkW88=;
 b=lttcV72Ti3nLiRx1KLFyNxJ9y2kMZrRqXwZwrRSzfDz2IqKHyT/nT/oVN2ZEFr+FKa3pdYndRUc5lls7+wZ33FwezZadNTH6HCTZnYBv3TToDK/+qoC+wH3l55bKWdXy9Ie+qeaZe7t7m9lTh//G5q19Q+hhCdzbwucR7mKYpFq/M2UKmeNOlGP+i3VRn1S6IQxxBk9ZB52jvbQrXEeoZK/xv2QmXSpF9705ufi4GSMg8pLEAjyzPjBSzO0mIofknQh+lO+pOmjzLGJWNbFDTcNQ3ZfmlixMsRbGjERpUREZ8Yyu1oM18DZVht22AlWeP+l1kWX3vJFdLNPRGZJUjg==
Authentication-Results-Original: mx.checkpointcloudsec.com; arc=pass;
 dkim=pass header.d=solid-run.com
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com (2603:10a6:190:28::8)
 by DBBPR04MB7499.eurprd04.prod.outlook.com (2603:10a6:10:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 16:55:04 +0000
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292]) by MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292%5]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 16:55:04 +0000
From: Josua Mayer <josua@solid-run.com>
Date: Wed, 30 Sep 2026 18:54:58 +0200
Subject: [PATCH RFC net-next 1/3] dpaa2-eth: skip isolated CPUs when
 allocating channels
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-dpaa2-isolcpus-v1-1-66c13f4fd75b@solid-run.com>
References: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
In-Reply-To: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
To: Ioana Ciornei <ioana.ciornei@nxp.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yazan Shhady <yazan.shhady@solid-run.com>, 
 Jon Nettleton <jon@solid-run.com>, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org, 
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Josua Mayer <josua@solid-run.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: FR4P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::20) To MMZPR04MB400504.eurprd04.prod.outlook.com
 (2603:10a6:190:28::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	MMZPR04MB400504:EE_|DBBPR04MB7499:EE_|DB1PEPF000509EC:EE_|VI2PR04MB10785:EE_
X-MS-Office365-Filtering-Correlation-Id: 844b1b50-bb90-4a4a-49f6-08df1f139839
X-CLOUD-SEC-AV-Info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|10070799003|1800799024|376014|7416014|52116014|22082099003|18002099003|921020|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 x0xq99jd3CdGj/fwcIEJR2w8Id0uTevCzl98KjL2VnIo7sVOrQXEJNSsMZxChysqdBoEbcA3lRkmuufLSNpa6F389K4ImUG+gNjul0E6U7t4MVbhDMUuxtW9vtx5JEgbUVfmII5ZLDFxqTn/u9JiPToV68dSMLipX+YD1nQHVBmiGoyd5CGuTdkOp4L+iiYAlumQYCATBA5zcX6/ZWzwyqvCXS3OcJUKZVHNQSH+W9WwYbLUzsxX/GruFv0rmjUUFUR5F/z6DmFT6j5zgJSSzQ3SZMMMkCw6SR48QMgRxxXNFT+mEF4GPcBvAuz6jmNsZj8OUjuff1O4HSCrRyB24Qo3PYqhvwZ7SDMc7Re46yTrdVHyXzdNn2BFLyyXo9VHIY/LH6ZD9FuZ84XdMcgvsPTAS8xzSVQjDFHWAqDemqDz7Ic+s1zafyBCd7RCaZPfxngL6hn8x/kIbkEyMOX9KPq6S9HammqFkBBI7BDUX3TAF1WmlMi6TCpE0S8zo7bCgYn+hRmWXzx2b8MXufpnz0Bbo4Q/aFIwQ4iZ4h49YMsG5PhSEHk2yACc1kYq3qBCKezSZ+teRyr8n8NSUGGSPqUawK6sbVzZ1VC4z548G9QZrB0JNVeg88XwKuDkF+qsFePyytibL+DVqpXryoDcyqOPuFowGCzK4nZo8SGO/pTxUyUjLxudzzjfpY+xVNj1HH/MH1WMZspP50n3e60ycw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MMZPR04MB400504.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(10070799003)(1800799024)(376014)(7416014)(52116014)(22082099003)(18002099003)(921020)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-Exchange-RoutingPolicyChecked:
 MkE9RWboo+w031aXX4ZtgIHR02PNP/gprlb9inOGFKrCiebM0F2VRNk8A0IMz24jYc8JzuaDpB50Pc7G2r41GqMiMFOHbcAkwmlf6eaJK1o6rGIS77LvOfvefManrNuvTbe3UusYpO1iyqw0Fc+EDWUQv+f5fYC1PXYEKAAKK8LMoszS3CSPrg5wzvTwhXf6EV0D/d6NBNHaqDmR4RqTLd7wdAbqcpS/3/l7JhyZWH7AR+aM/8dV4I9SkPfLfDt2b7Jl/i+5NxY4fhcisssHVnsbXjK9D17DlDkeBSKifgQ1xquI0lQYdApYzbiTvahG7d6KzjfEKMEg0vu4diqp2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7499
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: a7f110e0d0994bedae12d910dd091f26:solidrun,office365_emails,sent,inline:776544cf20a4f6cb347dc8a29c053d94
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4IBhgqeQ4zWR7uvKXRVv5XUdoV70pZ2Dm/IB2KqR+GGPFI2ZPfWeextPwejr6gPs9ySMgSJt4odEZtvREXGxKpy7InVsPVzdQ7D0P5TUBI+9rhL2kbvPBhNLdNGM7qTWLFrelVcz1QTuLgZ70tyfRvNMfXj3fejPHPmQzu9GDxd+eXPCQWrcta3nLYE/MPiLfQHvisHcyWXHdOiDXo6RUPFjPELrIOfMvVMDNoe+Z7vsNzWLK1jKxrU0MS4qmwAZ8TBh78bMOb5zVyTVkkAIphwCMf8E7Lrmyi5n9g3KPmYyRcILs2mbL+pJbAFHZq7L3a0C799NhnNpcKzrHow0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dloxuTDLJqdnj+JbQ3wteTr2VciS6EA6P7oYSHkW88=;
 b=ioUEsABOizBBoPRSXgbMBrf9OhziUzSxopf+oZtRmplf6qFZOGfjxd0kiS2RgagxFNkY0EbAu8ssfY2wvTYieRDtiNsB7OT2vEaN63QcvS7pY79cxPR9hj9aVWy8DHCeVlw4q4V3L+0MfjE/GSGGTZsldTzVXiDpn2Bbfmgh2mcYlv0N67msXB2GOP+XV5sIGDQCDIU/hKbyPHsW11mmWYugBlbz1AMD1J8GvmbL8KRSfluJVNb5uvQaEAbsUgmcxZGH6iUVnvzcZJ+jEQ4x+Wo+OkkxZAQikrASymg7+WruDjRHbqunV1FIn/bqWIUKTdIFBXhqG2ohhTMpFOjBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2215630e-ba62-4ddf-1b32-08df1f139309
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|14060799003|82310400026|35042699022|22082099003|18002099003|921020|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8tWo461aq4nYfTPoy9iq3W+56yEa2uMLNNu3jCnhtWi7El+lni42j0kE0rXVet1oqqmczdFz/sM3/nFNmZkB2laoWR37DiKqqKlbS4NWUOVM28wfwq8JzSttKd5e3XxFjuWT5c2UZniBaHRmV9VI4cMGPBSf8lonceLfXpGYMo7Gpp7OTvtx/KrUSSHX4xdmmxsoL6WLOKBNY6mhs2AzjzGEoQnVX4cMG7p1De0Us+HlZYU+dOqZqJarvbVUrVm7bhuEl1hsRdiyMziVD7/ro3j5SRnLuxP5Cf8SKXCMSk/2bgqsHIzsk2rzJ53uxidZn5ksPClBxfWH/Y9e7wXMmBgrnyI8EX7WoCpysIRr1oLZrJVAScW5I/pNEPs++ruq66QNsXKKAk2vF1KFesWXK0wocOyGEaVRPGokWlnZuIQmd+ewHTB6bgcx75nCHr+LFH6Le6e+kJVJhKOcPY5RBpwdHBgb1fkf76HsmeD4iHBAAX1lC0BC2bykJUNkttpnKUpgoQldM3xbM2bXbD8KEApvihVWlB/819o+3C1p3cB1x56Tw/CZ4G4gCUyWIttTyUH0/sFhzdAJshrAqIJ6957IJahE+TotrlF2G6qb6927Fgb9vT9TcllkA+6pa0bQVTjmZb+m6driQ/6h7utEG6tNHOPN05Mp3e6Rl04VbpID78LY0P4hPB3eHbH/VZldMq8teYhkkwJY24tJMn/Fog8fHEQZ2/yICWSIdz2vhhcKlurvS5OqTdA22/68G2+x
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(14060799003)(82310400026)(35042699022)(22082099003)(18002099003)(921020)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RGRPDA4PuCAVMF/WQmbtktpcG7wjt/wRg7t34ynTIw8/zs0jsLciomERYM/9Br0ZacUv6xX3uLtYVqCOr7HyTA/r27XZT4EucdAntX+t6OZcP7O7+zR6UKX5/rgNQ5KZ1Ojnt4vd3/VHsVw6QhdVIl2RBFo4y/ucTY5r93ItDMXUvtrz6yZNOzpCiFRGrTytWN0DW4j8k3x1YDc+1N4SveKO3K5wBcZCgYJiW0Qmwwo9ZyuQXt8p1gtDGV57n8nTRcDAjJTPwTVMY1O3YpWTBsTMCelpRcwhoOKO1SzIl53RiidLy/xXgNVhjrjbupxZVzUcozEcrV2xTwq5INsIImcgUqcUL7/9zGlr0Iu+BO5HpVEumvbMlrfLPG07IHQYJa2G8aRlYlxsSVcaNWXOnXGMGfhaIFxpeLdjfK4wFYsqROl6AkCfm7yRXcrMF+sc
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 16:55:12.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844b1b50-bb90-4a4a-49f6-08df1f139839
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10785

The driver allocates one channel per online CPU and registers it with
that CPU's affine DPIO.

When isolcpus=managed_irq is used to reserve CPUs for latency-sensitive
applications, those CPUs are expected to be free of routine device
interrupts.

The DPIO driver assigns affine CPUs only from the HK_TYPE_MANAGED_IRQ
housekeeping mask, leaving isolated CPUs without an affine DPIO. This
defers dpaa2-eth probe indefinitely once channel setup reaches an
isolated CPU.

Restrict channel setup to the online CPUs in the HK_TYPE_MANAGED_IRQ
housekeeping mask, so that isolated CPUs are skipped and don't defer
probe.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6f1046c9cc515..850834388790a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -15,6 +15,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/fsl/ptp_qoriq.h>
 #include <linux/ptp_classify.h>
+#include <linux/sched/isolation.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 #include <net/tso.h>
@@ -3173,6 +3174,7 @@ static int dpaa2_eth_setup_dpio(struct dpaa2_eth_priv *priv)
 	struct dpaa2_eth_channel *channel;
 	struct dpcon_notification_cfg dpcon_notif_cfg;
 	struct device *dev = priv->net_dev->dev.parent;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	int i, err;
 
 	/* We want the ability to spread ingress traffic (RX, TX conf) to as
@@ -3182,10 +3184,11 @@ static int dpaa2_eth_setup_dpio(struct dpaa2_eth_priv *priv)
 	 * Allocate one channel per core and register it to the core's
 	 * affine DPIO. If not enough channels are available for all cores
 	 * or if some cores don't have an affine DPIO, there will be no
-	 * ingress frame processing on those cores.
+	 * ingress frame processing on those cores. Isolated cores
+	 * (isolcpus=managed_irq) have no affine DPIO.
 	 */
 	cpumask_clear(&priv->dpio_cpumask);
-	for_each_online_cpu(i) {
+	for_each_cpu_and(i, cpu_online_mask, hk_mask) {
 		/* Try to allocate a channel */
 		channel = dpaa2_eth_alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
@@ -3245,6 +3248,9 @@ static int dpaa2_eth_setup_dpio(struct dpaa2_eth_priv *priv)
 			break;
 	}
 
+	if (cpumask_empty(&priv->dpio_cpumask))
+		goto err_alloc_ch;
+
 	return 0;
 
 err_set_cdan:

-- 
2.51.0

