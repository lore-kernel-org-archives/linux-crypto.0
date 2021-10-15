Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567A7C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 07:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D065611C2
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 07:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhJOHmr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 03:42:47 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:10753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230471AbhJOHmq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 03:42:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dB8vCogJVOoeqOebcIOBeqLOZD8MYk7ZTMxsXGzsFkyT7GnSOVGBqU2mcO0v+ioIp6bn9KX2LN+8nDxITAU5nJC9XWX1/htkxUg3+GvGKi0NbXldUAnZk72cCGDsR5hbWqq7EGdt4C9k8S/M6MzwUybEISPXSAisWR1wQzZd8gYQOJpyXbmlg0yWzWoeleKeED2SEPUa1b7RhPwXj4CpJVfNDPzJ53S1b93r4rO5zobNr3UdEcixQfG0EFqPVjBiODUT+1P7kplK8Bf7+IodSNwN2h8DUq6FH/4/kov5JktUXFOytOYhg+PTJBcwm2TXySDVTrewNgg2vE46AbAzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrRG5OipF3yf4WWXD48GwYoYBmeguSfFjgwbNKp+o4Q=;
 b=ZBfY3DwZhD3rWRvNiSTbTUIpt5eGaK6Pm6CE42+5t4ICv9UyCE/lc1Bhuwi04lPJlI7+4v3skkHguh9jSJU6R441DnGWHMIgHKYgWuyW/SN6pW53IMWhzds39sIUurRAH/0Cn+wA/aQMrzAwbEs5BCIAxU5I+m/hpGpPmHJV2o3TbXfz595Jfs7eSvm1/myaeKtxRKjwW2Z/G28nmVrJnuqvvA67T401IcU6fVjMrx9o4YcH3XKrFJ5zjBZJmkH+SOl5Mq3a2RWsbwKRYu2RJZ4+3EEyeymUg8WO/qZg9C2TEuzgQNabuU4mVafDrQpIJwboH0dyvN0/LDVQoCZpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrRG5OipF3yf4WWXD48GwYoYBmeguSfFjgwbNKp+o4Q=;
 b=iYZjPV5YSpVFYI+46Jy1mXCSjCNANgo3rhDojLXLLKw5MSsJfkKBBrm6aKuYJVDgYg5GJmskMuN4cnDmC696HbEld87Dtg2VdoxhlTgXlf3wsCQASfRiISoJ0if1Wd1RKtXxnFXfTNma8g3FVXeZsNQc/wxd6jxkKN0YuSnKbiQ=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2878.eurprd04.prod.outlook.com (2603:10a6:800:b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 07:40:37 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f%2]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 07:40:37 +0000
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>, linux-crypto@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks
Date:   Fri, 15 Oct 2021 10:39:18 +0300
Message-Id: <20211015073918.4837-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR07CA0008.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::21) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
Received: from lsv15138.swis.ro-buh01.nxp.com (92.120.5.12) by AM0PR07CA0008.eurprd07.prod.outlook.com (2603:10a6:208:ac::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.9 via Frontend Transport; Fri, 15 Oct 2021 07:40:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc2f43b1-0cb9-4e51-64e9-08d98faf145f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2878943E93E5695A3B5DB52398B99@VI1PR0402MB2878.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iwvRMZV0evqzZ9p31DquhCMW7XoblNQG2wdVgnJe+ZIkuQ1ZxqSRiXC4be9joz+pF/yDG7lk5VI6LkyJR2Y2EmWsBSgKHIw6TyORK8Q7WYXKk7O89dZA7pFjrKu5xfmIeEyrd7tGg1/Bp5deYDuMzUjebJxFi3XkGosAZOP9X/5wx1YRYGH/BGlbPp+CqloE8R4d1EaIQykE925wsuvyw1vdVI6vARI8Buh8CvrfB656LXKgYjY1cx9nLybcW5fznd6l/+WXNEeekEGjE5JaB0GMljdjlH9XZy1TQQoOlw1VA7noibb5pi8B6k2IRYkWpFZ4qvgNvOVCMsLkuvn2E4rrCs4bn/WKZ5nLdY4xUWP820dzH/sYB92jnROscMCbR5S6RhZLf4WIJDMUDRxs+shRy+NOPMegVCYBcHg63HKbF3EuvyaszcTLM4+jiyNEpovwxuGV7SacLMYz5EgF+OGBTk+8ONTSaDcSfpt1pC1rCr3/NoDlABEzCugcioTzQ0ONB8F0ssNWi0+bzp0PUjDlyXViA6AAQnKzvEXebsLxR5bhx4PVyN+vaS3f3yZPf4jefwDiMoSwWNp/6Nb0m69Yym6USHIYyvokY0mztBUezNjZSGQ6m20FLPmw80pubZh6G2gSd9l6bjb5ZFtQVLXzCmh8YYVKST/yM/F001517EBkws6At9RnKptsvbAk4m4kA6mxhoD2FefEn5z1tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(316002)(1076003)(38100700002)(38350700002)(508600001)(86362001)(6486002)(66556008)(7696005)(52116002)(5660300002)(8676002)(4326008)(110136005)(66476007)(6666004)(54906003)(186003)(66946007)(36756003)(956004)(8936002)(2906002)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWJMNzM3UDAzMmRFeFI0UWw3ZGlVS0JSVktrZzFCbDNSajZLVzZPRlRkVXEx?=
 =?utf-8?B?RUhPbnAyUE9SYWJQNEZERW55N29lTDRFZ3hBelVudnFIcXFnR3VGYmxrZkI3?=
 =?utf-8?B?VE9MVnpxVUl1U0NCQjAzb1NmbTNRa2IwWFNua3VqOVdiTzF0Mk5mZ1U0Zzht?=
 =?utf-8?B?VUJkbVZ4Vk5jS1BuRkJ1V1BQWlgzMVNEUVNMWFRqYXByZ2UxZlpYMk5LUFRS?=
 =?utf-8?B?bjFncXk2ejNMdDUwVWxReWJvOFEzWkQ1VCtJNVF0Qk5TbjJoY2c2cGFFTTV6?=
 =?utf-8?B?cVcvUUdVWU1TT1pYZDVPN3V4ZnhwNDUvYURNMHdhNjh6S2pibDFITHF6dGl3?=
 =?utf-8?B?S1FheDhnYklSanY2NFp1UHZtMUR4bHd2dW54TlpDQTlDcHRtQmJJUDdoTDZj?=
 =?utf-8?B?dlhTMVJXN3h6dWZMMGRUdTBUMTFwWFlYNGtSQTZxKzJncVMrbjRXZzNsRUxo?=
 =?utf-8?B?QlhnUWEwcTRSdFBHMGlZVXRMbEhjQ0lJSHpjcW1mQnM0ZHhiR0xNS3dYS1pv?=
 =?utf-8?B?OThPMFQ1M09xQzJhc2hQdlJxQ0NRTkxrNEtaZWh1K1FWSnMxS3c3dlAxMlhM?=
 =?utf-8?B?Vnd1Zk0ySDlvbFAzaVgyUkhRSlBFWHZLRmxCY2xUOEZpY2hsWDFvMkRSR1pQ?=
 =?utf-8?B?MDQ1cFF4M3phR290QUU2cHFTRitGdnFTMGlkUk1JdW1tcUFBc1RLZmR0c0xh?=
 =?utf-8?B?N0V5Y3B4SXdhV0RBUFF2VW0wL0tleHE3L3VVSXVsbEoyM1UzREwyUktZSUUy?=
 =?utf-8?B?cEV0WlRNSit5UGpvMnd1cnloa3dDL09KT3NmWk53MXpvTjVLYkh2UlY3SEps?=
 =?utf-8?B?Z2hza3IySVRrcHJlYS9EUjdpOVg0RkwwUkhkYjdGeVlVY1BCUXBKQVZzK2NL?=
 =?utf-8?B?cTIwMUtXQ0EyMyt4OWJyKzZ4RXEva28yRE1uOVhIRjdZaEVBenE0Q0h5NjJm?=
 =?utf-8?B?VTJiYXZHMy9iUUo2OFFITnVJZXpkMFVTRFdhT0sxc0cyVHdueVFOdldubG9q?=
 =?utf-8?B?Wmd2ZWNIUVliRDVwN09DOWdIblNuVmI4alFoOXhRaXUzTGZWSFhkVGZpN0d1?=
 =?utf-8?B?NXVwb0hDbGtwQnJPejQ4bnllZ01mbzZhS0tFMFdrazIrRU9WZTU0L0w1WEQv?=
 =?utf-8?B?amtGdTdwRlZtWk9hYnV4cDhiRHIxMlFvVEF0cy9zZnFmUStzUThNZTE3L1B0?=
 =?utf-8?B?bFVQcmw2MDJFSFNKZEhrd09Zbk1vbkhUdG5lSVFJQklnUU1EWitTSEczOVdj?=
 =?utf-8?B?Wnd2TW5sVHZlR3JadW1YeGdldEZUMFFoNXlrTlg0QTM4SFlBSTE5MEM4NG9v?=
 =?utf-8?B?bWZMTUh6T1FuazRsVmw1RnRxc05rN281SU02OXlUZTY3aWVla1NkWmlQZ2J0?=
 =?utf-8?B?dVFVUStNVEFZc3Y4QWdua3YrWmp5L1Z3dUZNd3UxbllVRzNkYnJMT2xkYlgy?=
 =?utf-8?B?UWFjRTlpUWEzdmJWelNtWUkwMXBFS3ZXdWVsNmMrRCt2eWxqUkFCa1lIYVlE?=
 =?utf-8?B?eXFvOHpXN3BQRkxPSXk1THdXRDM2Qm5Bd21BZ1hvdCtlRHhuN1lrWmQwekNX?=
 =?utf-8?B?VHpPajZZWEJQWk16VWpuN3NvNGErZDlseks2OEJkQmZaUmNsTmF3NFVsUGxx?=
 =?utf-8?B?R0l5cjZld2dLMk1BNktSL2NaQS9CQkwreWlJVk0zcEpCUllManhPTmNLcWYv?=
 =?utf-8?B?UVg5V3lHOG9VWEQzQVV4b2pXaklGMnZabkgxcTZkcEtnMzhHcjhRSG5SRkZu?=
 =?utf-8?Q?/zuCEqxFa8ZPhR7bBvQsQeiRyt4WqSDBTRQD0DE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2f43b1-0cb9-4e51-64e9-08d98faf145f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 07:40:37.5659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQoshKrIyGiCyWAXMXzk4CbKobZBHFf44NwP4Ip9qy8DmnGh+BDAQDTJg2r4N1gJvOzt2Y8CgjTdhVmcPAUphA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2878
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
mentions:
> power-of-2 block size. So let's add 1420 bytes explicitly, and round
> it up to the next blocksize multiple of the algo in question if it
> does not support 1420 byte blocks.
but misses updating skcipher multi-buffer tests.

Fix this by using the proper (rounded) input size.

Fixes: ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/tcrypt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 82b0400985a5..00149657a4bc 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1333,7 +1333,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 			if (bs > XBUFSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for buffer (%lu)\n",
-				       *b_size, XBUFSIZE * PAGE_SIZE);
+				       bs, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
 
@@ -1386,8 +1386,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 				memset(cur->xbuf[p], 0xff, k);
 
 				skcipher_request_set_crypt(cur->req, cur->sg,
-							   cur->sg, *b_size,
-							   iv);
+							   cur->sg, bs, iv);
 			}
 
 			if (secs) {
-- 
2.17.1

