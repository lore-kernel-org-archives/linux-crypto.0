Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2093.outbound.protection.partner.outlook.cn [139.219.17.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5DAC2E9;
	Wed, 26 Jun 2024 01:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719366063; cv=fail; b=KOobspISrVGmaj7agiLysE3nt5YfR3UxqVbVGKKvskWCCtofPlQIcPWXTSZRzmrhkdn5b476MMYlZbzRVOq+FCGVjA46twNX5/brTHbmGIlU4vRmR8RQAHXdxRKaECYNCQyiSgZHaH+FWmEqH078tal4rfQIbiqZvF6DlqtCUDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719366063; c=relaxed/simple;
	bh=tO1ahIUlBJsR+RyHOFqJdtd926KMn5G+ECpUsP8HWdg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gP0qVWLv0uo3GxqFigL2r01fI+t7w1ZQAE4uK4OZq0gRmJPsjrOFtYGNS4wjaXfE391QKIp9JLrCZOubgyvnZ+s2ZCAvLlEmhoXs9Of7Olv+Afu6Y7AOdoOivXAF3EBSDc3rY5rlfutOaUHLNnFFyPHPL7jBjFY59CbRQtnAf7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmO4A6Zh7SFiVp3waqi7QMwyliUwa7In5QIkCMYENnL42PVcMwTre7Hcx+m33l4nj3uqqvW2iov4RibQlXgEgW65lb5Z47Ox+7trQ/ls8ysTRlH9FEJrPUTGXAo4sH3794tIgSQwCdV5Xg2FaevU+dUUHElGxiQ/vBCR0NWi4bxl3n1EnaX91xEXTuBErjVkj/IqFqmgFOo4cjcgsJGoAa2BjjTGq7v6LGlcD0mMTgqE7pWR/kCn3Gg69pxIWqDEgXz0z4QlI2DpiI+loHHu6WsuRrTDvK6clWhqSuolDMhpMK8o5wDpRMc5OmAxzL/BquBe6afYUPuzXwZraSJLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ANfapXW21pc378B88Csy3bAufeKev6/mvSTmr/EGEA=;
 b=WFB+YIoguoU193H/JsRfTRy/0lvpHZaheyYRst0PbkMI9WmoocuJbmagA+5GKwFpq/XCHSObk0HKcKC1GU23PFKMjpNG4y+7SCaH1IL4htLH0sfXpqhkpTDsu1cyNugnPtdyIgkC0galkjuVbZeoH6vICrzLR8EPc2v/I9qF4Lr6XsnyCtJ7h3JoAOVQbQmDyq0VcIXVl2ZsIqWQtvO4714DY5+hYFq4tyEETP33yb8RHWJqGYC1tfvsZ9758XS06i9wbpwO5gU43g3BfuFttRd9953wd8BZiP2Gbq2S1aEqbBn4kQzJJUjAiISuppjlFDxbPUrEvU2BCZnKzidFMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1150.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 01:40:51 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 01:40:51 +0000
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] crypto: starfive: Fixes for RSA
Date: Wed, 26 Jun 2024 09:40:41 +0800
Message-ID: <20240626014043.1194521-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0022.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::31) To NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: NT0PR01MB1182:EE_|NT0PR01MB1150:EE_
X-MS-Office365-Filtering-Correlation-Id: 606090a1-35e4-408a-6048-08dc95810320
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|41320700011|52116012|366014|38350700012;
X-Microsoft-Antispam-Message-Info:
	EWOUJdXQaYUax0V76Q7nFIKOVLLVTItARyrVQMGK8QVL7/PaKfUUNRjDUKhQvPb+KJUzkiqb68jmCfnXaPZLI0jaQg19A/nM89XQUiDP6BuyDYu4535qypgeTUxal4E0IZhg4kEA3gI8SJpT2xWd2mNSUyuVN2EQXudC9NrnZ/OPivIaEexhfL8NwNNg4cfF15OBzmp4iAKJ96SQQtw/xxbOBfaydIuqwezeXf0D6DvryBUq1+ST3xvh93uv5sOUn0BWV9j8M7S4SevcKV2gZxFEkFSJ4YdrTSCIkeTLkP2sb5RuK3jaYb5TFHhdplOpEaio2JBJp4pwChXySrw4oci7darCTz8hAgIpHaXZi9USZHTh8KauahG30wNsxWWZjT3fji9YOVo5B4wjvp1tGngX+MkAd1OXUqEK/R8SjuDlsYdmKrhEZ/mKRFq0gHsnBmedfG2APHbIAzVGiajHBINrsK587ZEYafBa8sed1dyYFHBuR8sk/tdlNVnD++InCWYakyvgmsvBCCk50Gp4djiYPiwcGakVqYt3iDzHtiLl25sNSY80MgqT9e1gbTF24KM6iUrvWPfGvluuHroHmuKFIFi2ZLQFHRgmb2YIG5vfiFKuVgRJbmojVrsLMiUM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(41320700011)(52116012)(366014)(38350700012);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HXsIraR5XNYqj1pGdxMk5v4hiiO7A11+7Bur6iuHxCYT+Rvd7AhrIiVB61iY?=
 =?us-ascii?Q?0ZzLlrF+3wfPBNwTlHaVG22USO0GcsuQN0fK2ISh4rIv2qmKoQjywMo1ao37?=
 =?us-ascii?Q?Ui1jgohmo+dh0y/h7ahTbjB6CtMwGr/Oy0YY4IBw4atBPRfGIcj88Ey+ljK+?=
 =?us-ascii?Q?UAl0UlD6VFKHaNVZyN5EAIwhy43zRHfJeF/bbY/gf3r4cgDSKx2TlyaOGOM3?=
 =?us-ascii?Q?xlqS1MRYktsOz8aYTt/cLLOMWGzd0JGD+uIJulUDMlQdDCWwQB9UjJG4osx4?=
 =?us-ascii?Q?nkisTsBXaUdMyxybKJgMgTqNXCUGJdzCxHKbf3TLryf66fKRWEbPhLKJ4DYJ?=
 =?us-ascii?Q?3OPTaZ3gs8CQ8c7FASqLVdNKcfGZBQvJWrnRES4hanlnVVw7zwI/3PIdiPKp?=
 =?us-ascii?Q?CiRknkyL4N8EPpo0dzQi8lbRVQ+AgxJdn2RDjS00O/p+2tY+xmjptppadRiB?=
 =?us-ascii?Q?502gS+EvximE56B2vtM2FykW9LUJmue9f1sHTKbd6llyNi/VUycofm3l1AYY?=
 =?us-ascii?Q?/WXTcQUKNJqoDrGol0VctOv2NEBnWy/LTz7vfvVVnBnyAfFpaPtujIVwqj34?=
 =?us-ascii?Q?wQmOIrjN7EkjqzP8K1FZZ9oOarDbLP8V+Rhfoa8fCDw08ep5mg3NaILqojbQ?=
 =?us-ascii?Q?slIEiT8/eF7d1FP5zcwAmffsgC8k9Cm0m+lhOOqG+5TmEekgLONP5qIzCEu6?=
 =?us-ascii?Q?TNsKOdhqa7CXCieSd0MbApieiBeYrw2sC0u9L5gQofXlPJgtEYjf7prLd4zV?=
 =?us-ascii?Q?mPKucYuBjAheJKO89ckuAYtgwgKT2Z26dL3gXhcpLDUWCWkVP4/WYAy0/26E?=
 =?us-ascii?Q?tqIt/8LC/83OeLZgBemcDxYNcE5pjDinSsWc3vKZFlnJ31c15T/6g1X4fG0x?=
 =?us-ascii?Q?o8BC6zJIDvEUfzhx4E13mCQ3adONL2SK1nLpzbAvhXmFXD3MUftLxLUpzhsG?=
 =?us-ascii?Q?uC87JFku6F/1jTXPSblREYChHJ+u31ribQncEHZILiEbHgvuV1Hi7dTeOlFF?=
 =?us-ascii?Q?O4KOMZqL0qxoimllQofNwAoOvJSKcnhG4Avpc5Oh8y5Kq+attFJvddxOW4hj?=
 =?us-ascii?Q?1WM3YVJUZf0nz/VLVc//Zn3oIF9HB1J5KlWOFaUJFossJWCnyn63YJED5paW?=
 =?us-ascii?Q?yHxhzalpqXhLMDCy91sHA3Lje8q+fEVUCP8/KKEgZWEX4EGdUA1c19y6dqjR?=
 =?us-ascii?Q?z/Aa0F6CaCbHkVD0kx1AIsEuB2Phx+K+ycmOT1M1Jl/J2I0oTZn7rcfA4jA4?=
 =?us-ascii?Q?XMVkHYmwwYwaKjNhn+xxf4dj2xv1Y/2e/HvAXG/3VY6D7mZMp58jL3jBm5SV?=
 =?us-ascii?Q?13i/Y7aG1tQX15m1LJkhulf1V46UVcKXzWfrKSGgAgb1xSyIgeOcq/oPurBW?=
 =?us-ascii?Q?pV8rUymNA+tC5qmco1b1souLoLzh4XbBD37ptu7lr2mB8co+klZRbVAO23xN?=
 =?us-ascii?Q?rM+QwfwnMijFuyJnOzTNyvOobE9YQyE6HpXnUbTJmvMxvVMW5oWWTGZ3ClR5?=
 =?us-ascii?Q?8BdXDvRGDUmww9O6SQz2wuCoqoECRxkuWLSV9zKOC3/zfwKcbbm+NKHI2/bj?=
 =?us-ascii?Q?ynq1J6e+54UNuI1i5b2MvrnXw+8SqBPN3K6csbhJXb8MpzahKO6YDM8Vn9eG?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606090a1-35e4-408a-6048-08dc95810320
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 01:40:51.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FssF0c8HQ67QtVcqua6gjBzo6jFmv90zPfWkIswKI3DkzdgLrKebuAvgIW7A9jKxjjXTXCI79HtZsEOAqCnpedwUbow8RkBaoGA15CburYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1150

This series adds handling for 32-bit unaligned input text and a fix
for a missing pointer assignment in the driver.

v2->v3:
- Retain u32 aligned attribute for preallocated buffer.
- Replace sizeof(u32) with 4 to simplify calculation.
- Removed unrelated changes from patch 1.
- Move nent changes into patch 2.

v1->v2:
- Build the extra space required for shifting into reqsize.

Jia Jie Ho (2):
  crypto: starfive - Align rsa input data to 32-bit
  crypto: starfive - Fix nent assignment in rsa dec

 drivers/crypto/starfive/jh7110-cryp.h |  4 ++--
 drivers/crypto/starfive/jh7110-rsa.c  | 15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.43.0

