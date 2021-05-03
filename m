Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E306BC433ED
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 10:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AAA611C9
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 10:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhECKIn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 May 2021 06:08:43 -0400
Received: from mail-db8eur05on2132.outbound.protection.outlook.com ([40.107.20.132]:5354
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232960AbhECKIn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 May 2021 06:08:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeLRjNydO3VCRJOWPclfMXDbuqdGVFn4euSldHYxe8sPKzrMVIiC7egOVY2+HZvaubeGLOb/Z9/mM21ga2atohaOecT55AZUIwtaCN7D6QeJT3gAKckZO1DtBrThodgGMF600KC94Dwmv4V00j81lHK1XtqlrD4qDqyxecO1JKQO6NLEyYYOrOLxxhC6KxtVi4kJ0aS9Pyd5a/egaEx+2eW9fOYOyuPvKRsqb8TyShYBErZ2oAZDS/fT/gm6x81dpxfI41pW086PjPt3yocaDXsRrp3oUedsjgTSGn2BaJqT+nH5p03Q2t3xllV+p7+yLJpfESHKJKTZjZEjW4x10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm1LyTbxAuxbFm07PvThUAmbpNMt9Fhy0FTK/YbdCjs=;
 b=N7fRtsqDAbYBEBFPcCJLFbHk1EatqXOqxRp+SE0PjX43JQcxSJDyk1t/CqrcK2G8VD3n5Ebz5GLQx/OBW0bcb1YZHfB53Jze3KeVeFgW4jq/S6IOyYxkIHlWsBQ2WMnXQBDIc0rx/ArAovLH8ehCJql4qxh9U7JN2MLsZZ9gD5km54Hka4uSOJTkDxR+x4Zsy3xlXKAMVq0VUhjkpSV6EvCIiuBbd8YnS5wFxwiCMpPHmWg/VqcZR98E+TF/iHxP/PjFgQ2H/Slx4py72d9OKYHKo29gDisd0I7IpOlV1Ukam5jYh6NrOXPey2YmQXaSVhNLaI25A5s5sMunvc+UVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm1LyTbxAuxbFm07PvThUAmbpNMt9Fhy0FTK/YbdCjs=;
 b=NrKq7RbrBKxvJvPPb9GTB0unXGfjayWYp6aoP/NUJ/CBNTltY1xXuxigkb8W0xmEvExHLcU9BO04UyWqqieff0/Ro1629J3WHImib0ZxrphnPdjKRY4fRpyGty7zGTiZlpuosE3GuWOh4AeO88q8TwGqzDz+l0ZX/7uo42CakWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Mon, 3 May
 2021 10:07:47 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 10:07:47 +0000
Subject: Re: [PATCH v1 1/2] caam: imx8m: fix the built-in caam driver cannot
 match soc_id
To:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        dominique.martinet@atmark-techno.com
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20210429140250.2321-1-alice.guo@oss.nxp.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <8d73fd05-5fd9-c5e7-2f18-1263c87fbc8a@kontron.de>
Date:   Mon, 3 May 2021 12:07:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210429140250.2321-1-alice.guo@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.250.134.29]
X-ClientProxiedBy: FR0P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::23) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (109.250.134.29) by FR0P281CA0046.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.10 via Frontend Transport; Mon, 3 May 2021 10:07:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 725ccedd-68e7-4649-116e-08d90e1b4d57
X-MS-TrafficTypeDiagnostic: AM0PR10MB2674:
X-Microsoft-Antispam-PRVS: <AM0PR10MB26741C658F6456AFDC3625F1E95B9@AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRDVDVdiZ93vuywzn+3iIujns+BYuW8agrCUA3zFib4rv3XJ/r6XOQP3bivJp3WNARVriWlrRAIqfaZl7GeoLDBMiBlY39LUeXlo3WOh+ElLNi64CXpKM/NtxRE/p4BxmJkrJxLCub9em4pW/m+M/7NURl0rcAy/UC7V0FPCqaMY+jxe2HODpk3XWD6Nxly6O5SOAENdGeQHhKdH34oMxysc7XgRXo7Y+UneurMvzbUorwqmZvRx46AhNs+9FW5tAsFG5O3gxlDnUNogDAVQn20R1rSQiuGVURzFyykqfegXc1MvA9x0Y3GzV3RYusGseJvwLI9O931aSUwImaJIRvY1CjqqQ6aj7LGjr9sY990/B4sqFwh41uZSHyhB/kjhi3FFItKKVrRb2I1AhORqCC0WNB3greM8BO+sBVD7XM8vM/aRNzkDnx0UTSIhM6cMPMA5u1Pm7NxRHGyuAWwDQdSbm1K+XvbytZfihYgCwKb/X/jXmf4vuqoqeY/nUeK+crxsGT5y2w8hePDpEw2lOBEs6jqRnz0AftIzON+n3i1yqBG9Xco7nhkIZLzozuH6lPS5MJBWJSn1e3SSRHESypjD3YS0Z+0jUaNKQE7yvMRB2qmtap3e3K0ao/N7ex9bOy1Yp3lXjEg4r8MrsB6iOg9mHDN3RbCOCUbWrrRFFt5QKw7SG1Xm9bPSVwXqphUufQC64tSEu0iZltX5uJfrUizN2Bov+3GCSMUwYsIvmYMZvlzUGiwQlenoY+sY9+Jn/vp91aFKfT9goUcWCdFVEeYNgDKZ/RfmxIACh0JXC+656hSQM8XrkPRuBKPlY/PA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(16526019)(186003)(921005)(7416002)(966005)(26005)(38100700002)(2906002)(86362001)(44832011)(6486002)(31686004)(478600001)(956004)(2616005)(16576012)(36756003)(53546011)(31696002)(316002)(8936002)(66556008)(66476007)(45080400002)(66946007)(5660300002)(8676002)(4326008)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWtZK1BPd0VaY3UvQ0UwYVFtSmtpb0pSVUZUeGpySUdFVHZGc01SdlR6MDhi?=
 =?utf-8?B?M2N4U1hkMzNid3pzRCswYzY1V2dXOUpGVkd3V0xkbE1IQjg4aUUzYmVYa0R1?=
 =?utf-8?B?eVpHNUMrQ2FGeDVaSzlFWFBkWTIzOHRJSTIwZVoyTE1RdlptL0VZMjZTSkxX?=
 =?utf-8?B?elVDYU4xWXkybUhsRTh1bVcvUXRuMWRybWo5NkhOUEsyU3hhMUVFaFh4eFpk?=
 =?utf-8?B?VE4xalF5K2ZKcmRRTEJ2djlNcFIyTlYyc0I0VldiSWxmeExvbGk4YUZNYVZk?=
 =?utf-8?B?cU5BTUxoa3VNcFQ2T21JY2xoNkp2Rk1nU3NRVEhjalZNTk92MzlkWVdNaVd2?=
 =?utf-8?B?TUsrNDNHSTlBL2ZDWUNMK0taZFV1anArNk5mdDIvWmFKazZIZG9tOE5wUUl6?=
 =?utf-8?B?eWwrZDJhNDVVWFhmbGZFUGtyZjkxTDh1YTVmTTRHTVRRY0JmaS9DL3poWFFG?=
 =?utf-8?B?bXRXVFBnRzgvN0NzYmdldWFhYjduS2cyL29BWGRuR0o5VUhxblphZnl5OVUz?=
 =?utf-8?B?WFB1allhNE5lcHhROHQzNWMzS2tGWjY4V1ZrMW9OOTVyVFdxZzIrd0xQdkpj?=
 =?utf-8?B?S3V2ajl3MFgwT2FqSU9VYkQrQi9DdHhaeUVFTmgyWXVJVWt2K3M2T08reUxk?=
 =?utf-8?B?WEFhZnNtMUZtUmNtbmNSSDkwTnc5OXA3WGloTFFMcm5keFhLTVJjUXkzVFYx?=
 =?utf-8?B?RVlHbExhSnN1d1hRNFFadllwMnRRei9EWHNOV1FOMXhKY3ZCMG5KSjJsTzJt?=
 =?utf-8?B?d2VvU0lPcDQrNjlGbXZnVXBQNlVjaWRuK2txY1JZajN0N1IwQ0lEaWJOY1Qr?=
 =?utf-8?B?QmhrR0xLN21PTlFHQ0QzcDdYNTRtWmduaDZ1VWFMblNSY0pmdEUrTlBtV0x3?=
 =?utf-8?B?V05vdmF5M1ZXOWJqeXAyS3R2Y3NhQzFaUnB5aHRGVSsrOWxWeDNHQ2pwSEx5?=
 =?utf-8?B?ZlpOdlhEeTZDdEthcUJNLzU4cFF5V0wyRzJPLzdiTlV3VkJPV1UzVWxBa0Yv?=
 =?utf-8?B?aDBCeWwrRnhnbTNhbGp6OWJsaTdRVTUxbHI5U3NvTFU4VitObTJUZWpENDBX?=
 =?utf-8?B?bUsxK2xEMGhncDY5YmpsM3lwZGpRcDJKTnNLbmt5cWJEV1FHR2plMWhLaEI3?=
 =?utf-8?B?ajNoanQ4aDRlbnZ0OHdPOFlpTHlIOHZMdmhONDg0OVdVZzB5SkZiMEVWVDZy?=
 =?utf-8?B?RHNtWW84RHJhaFgrbEN2MnY5aEQ3d1FDOHNvempWT0RuRGVRUHp2WExvVUhR?=
 =?utf-8?B?V3FreXg5YXFVbUV3S1M5YjBMZUdkaUNzN1lvVXQ5VVYrekFZUUZVLzMzVjlO?=
 =?utf-8?B?Y0p3QXQwMGJ5TlV3WEpwazB6dndJaS9IZGg4R1lKOUNlK0JZc2hCV1VFUnpC?=
 =?utf-8?B?NkYzUHhmSGVWOWliRVBSampHWmhkVnZ4VzdXZEhIVURBSDNMQnpVei9YL3hE?=
 =?utf-8?B?QU9WUlhibTRFRnQwMUVkOGJkNTJBSmJuL29hNTdaQkM0V3YrVkJGSDE2Y2xB?=
 =?utf-8?B?UXB2aHRESHhtSFpXWkI0b1pUVFdCWGgvdHJqVU9odS9QS2FVRVVIa1RwbVpB?=
 =?utf-8?B?ZG5zZ0liWTJ4elNOK1NpbWZlY1ROUXRMb3VCejg2MGhsVHpPdjVERmpGLzJX?=
 =?utf-8?B?NmVZMHR5Ym1obThOMFBHSlc5V0ZKVFMrK0FrRDJLUkk4TXNrbFROUHl0WEda?=
 =?utf-8?B?UXNrYjgySUgrbUw4d0tDbllRMkdkOHVUZnJJalZZd1hQUEF1d2E5M0xGTG9O?=
 =?utf-8?Q?5G87jCc9Apc6DiM8xKQv173gPvY6sly8gvEavI+?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 725ccedd-68e7-4649-116e-08d90e1b4d57
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 10:07:47.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lJ/TwYst2pxARbPxGCNev+pIuZcg11q5EnfG9KE8haWF6Yxkm9CvcOTl/ugCSPeH2FVlrAcBuRNeC/uVqGxdYYYqa47QByeLvZnyIXd5jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2674
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 29.04.21 16:02, Alice Guo (OSS) wrote:
> From: Alice Guo <alice.guo@nxp.com>
> 
> drivers/soc/imx/soc-imx8m.c is probed later than the caam driver so that
> return -EPROBE_DEFER is needed after calling soc_device_match() in
> drivers/crypto/caam/ctrl.c. For i.MX8M, soc_device_match returning NULL
> can be considered that the SoC device has not been probed yet, so it
> returns -EPROBE_DEFER directly.
> 
> Fixes: 7d981405d0fd ("soc: imx8m: change to use platform driver")
> Signed-off-by: Alice Guo <alice.guo@nxp.com>

I didn't look at the details of this at all, but I can report that this 
series fixes the bug below for me when booting v5.12.1 with built-in caam.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>

[    1.425534] caam 30900000.crypto: Entropy delay = 3200
[    1.430781] caam 30900000.crypto: Entropy delay = 3600
[    1.503610] caam 30900000.crypto: Instantiated RNG4 SH0
[    1.571266] caam 30900000.crypto: Instantiated RNG4 SH1
[    1.576511] caam 30900000.crypto: device ID = 0x0a16040100000000 (Era 9)
[    1.583229] caam 30900000.crypto: job rings = 3, qi = 0
[    1.594172] caam algorithms registered in /proc/crypto
[    1.600308] caam 30900000.crypto: caam pkc algorithms registered in 
/proc/crypto
[    1.607777] caam 30900000.crypto: registering rng-caam
[    1.612966] caam_jr 30901000.jr: job ring error: irqstate: 00000103
[    1.619316] ------------[ cut here ]------------
[    1.623936] kernel BUG at drivers/crypto/caam/jr.c:187!
[    1.629171] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    1.634665] Modules linked in:
[    1.637730] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 
5.12.1-ktn+g807a88195d76 #1
[    1.645223] Hardware name: Kontron i.MX8MM N801X S LVDS (DT)
[    1.650888] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
[    1.656904] pc : caam_jr_interrupt+0x180/0x188
[    1.661363] lr : caam_jr_interrupt+0x180/0x188
[    1.665815] sp : ffff800010003e90
[    1.669134] x29: ffff800010003e90 x28: ffff800011362f40
[    1.674459] x27: ffff800011362f40 x26: ffff800010faf3b0
[    1.679783] x25: ffff800011460f42 x24: ffff0000023be600
[    1.685107] x23: 000000000000003e x22: ffff800010003f24
[    1.690431] x21: 0000000000000000 x20: ffff0000023be600
[    1.695754] x19: ffff000002397a80 x18: 0000000000000010
[    1.701077] x17: 0000000000000000 x16: 000000005e86dba6
[    1.706400] x15: ffff800011363390 x14: 00000000000000e2
[    1.711727] x13: ffff800011363390 x12: 00000000ffffffea
[    1.717051] x11: ffff8000113e2048 x10: ffff8000113ca008
[    1.722376] x9 : ffff8000113ca060 x8 : 0000000000017fe8
[    1.727701] x7 : c0000000ffffefff x6 : 0000000000000001
[    1.733023] x5 : 0000000000000000 x4 : 0000000000000000
[    1.738345] x3 : 00000000ffffffff x2 : f0868b59cca25e00
[    1.743667] x1 : f0868b59cca25e00 x0 : 0000000000000000
[    1.748991] Call trace:
[    1.751443]  caam_jr_interrupt+0x180/0x188
[    1.755547]  __handle_irq_event_percpu+0x54/0x170
[    1.760262]  handle_irq_event_percpu+0x34/0x90
[    1.764712]  handle_irq_event+0x48/0xe0
[    1.768555]  handle_fasteoi_irq+0xb8/0x170
[    1.772661]  generic_handle_irq+0x30/0x48
[    1.776680]  __handle_domain_irq+0x64/0xc0
[    1.780786]  gic_handle_irq+0x58/0x128
[    1.784545]  el1_irq+0xb4/0x180
[    1.787693]  arch_cpu_idle+0x18/0x28
[    1.791276]  default_idle_call+0x20/0x68
[    1.795209]  do_idle+0x218/0x268
[    1.798444]  cpu_startup_entry+0x28/0x68
[    1.802373]  rest_init+0xd8/0xe8
[    1.805606]  arch_call_rest_init+0x10/0x1c
[    1.809716]  start_kernel+0x500/0x538
[    1.813388]  0x0
[    1.815239] Code: aa0103e0 90002ec1 91388021 94077cf5 (d4210000)
[    1.821353] ---[ end trace c369bd5cc770522f ]---
[    1.825979] Kernel panic - not syncing: Oops - BUG: Fatal exception 
in interrupt

> ---
>   drivers/crypto/caam/ctrl.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index ca0361b2dbb0..9bba3b93cf35 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -79,6 +79,14 @@ static void build_deinstantiation_desc(u32 *desc, int handle)
>   	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
>   }
> 
> +static const struct of_device_id imx8m_machine_match[] = {
> +	{ .compatible = "fsl,imx8mm", },
> +	{ .compatible = "fsl,imx8mn", },
> +	{ .compatible = "fsl,imx8mp", },
> +	{ .compatible = "fsl,imx8mq", },
> +	{ }
> +};
> +
>   /*
>    * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
>    *			  the software (no JR/QI used).
> @@ -635,6 +643,8 @@ static int caam_probe(struct platform_device *pdev)
>   	nprop = pdev->dev.of_node;
> 
>   	imx_soc_match = soc_device_match(caam_imx_soc_table);
> +	if (!imx_soc_match && of_match_node(imx8m_machine_match, of_root))
> +		return -EPROBE_DEFER;
>   	caam_imx = (bool)imx_soc_match;
> 
>   	if (imx_soc_match) {
> --
> 2.17.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> https://eur04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flists.infradead.org%2Fmailman%2Flistinfo%2Flinux-arm-kernel&amp;data=04%7C01%7Cfrieder.schrempf%40kontron.de%7Ceab62a59cfaf45dd5acd08d90b17ad0c%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637553018576335889%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=kHLtIGIsyueosiAj0h9EurdZYzR3rk3fIuY74IhXySw%3D&amp;reserved=0
> 
