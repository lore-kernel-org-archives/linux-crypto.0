Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162FCC4320E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 15:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F506108F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 15:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhHQPkK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 11:40:10 -0400
Received: from mail-eopbgr00113.outbound.protection.outlook.com ([40.107.0.113]:6208
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238264AbhHQPkJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 11:40:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YotuRDbVKYCECpB60o5XM+CN52V4KLIKeDGUUSqGUonDA6fD3RdwepPNZ3mW+gvjAt38cmXh+DEJz88i8LzvWKSxWv1JY9enR6eiGkZ4WmcZJtI4UIyIvVx9mjpLrDC/m8aJv+hxk7pcedB4DxRd3Iciwc6rEk+feR517AzM+jerhppI1CZm+8GRBN4RDuNcaIPC5a+AFON1eCHemrAHcDeTtrW69tOEkz2FUr1WjmL1f3UASvIOJfe27Wd+AhaEZeqhMQgo5tSDNrY6sSGlSCwqib5okvYODAtwY+yqlKDePLGECnYFkRl5RMcqJ/zskmxXMZZtvtUzGZ4mVg6Maw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOyyUygVnKDIRsZ5741B42nhYOaC95EwN0fXGj6iCws=;
 b=ZYVk/N62vsM4c49+eRHpjn7vOYMlmSBHTjpdE53P7K+ElDyNt1EWQg7P5w/y6e+DwzZEO0zS+aftjJ2n+hMEuhtVDKNgwvUEBeqjXCPZjxqo8EwDafNgW5vzuE5A4TR+dJZGaqz4Gew0EstjS43UkkNdWPDUcUdQQMuLLANE7QZ0GoBK5fD7B5zVQS5+D3SlRCAZyHORKXo0fNtVmhr4E4AM6SJgDRyhSi4VmJjzFf7lOn1Fs8DGQZ9mU/PHuxDXYB6ikTZGzQ+JAwwRcHLBJf5t9qlHYgEG3aHN3sZI9HeAZGVEbp6EwKrMmKc26A1ds2QjBvQuKUFKfp58nJtNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOyyUygVnKDIRsZ5741B42nhYOaC95EwN0fXGj6iCws=;
 b=hUhxcAYMZ/AaJ9dgoK5K5fD2L1KaLNyQHj2podMwfU9ha/UFJc3MpCssbPEUrYQMNOxoS9+5dbXn+oPuENJGf0f/OMuByQQG5biO+w4VPE7fkZpNOI1mDEUPDBmXNofvE8BgKG9cIv3JwUnhFGIKAM7ufb9tqFOgxqCMh3wiBF8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3730.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 15:39:33 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::30d6:1ff9:85e4:48d1]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::30d6:1ff9:85e4:48d1%5]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 15:39:33 +0000
Subject: Re: [PATCH v4 4/5] ARM: dts: imx6ull: add rng
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Franck Lenormand <franck.lenormand@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Martin Kaiser <martin@kaiser.cx>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20200715152604.10407-1-horia.geanta@nxp.com>
 <20200715152604.10407-5-horia.geanta@nxp.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <4f30d822-9db7-4a54-c082-fa9f54982b42@kontron.de>
Date:   Tue, 17 Aug 2021 17:39:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20200715152604.10407-5-horia.geanta@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P193CA0019.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::24) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.36] (89.244.183.210) by AM9P193CA0019.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Tue, 17 Aug 2021 15:39:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f0ed755-1f82-466f-3379-08d9619535e8
X-MS-TrafficTypeDiagnostic: AM0PR10MB3730:
X-Microsoft-Antispam-PRVS: <AM0PR10MB37304B64799DC9FF17F12AAAE9FE9@AM0PR10MB3730.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCZsyhZCFnjNmwnvG88qFtv0p48/zqDIymvwaY0sHGKwQK8AC37h/bKLjZourxIq9F+TKWmJ13VFJF0rGLY50OfFkq0O1G3QyQaQrmsZcRi530GLRk0REX5fMU2HnW4MoYXQcciSSB57mL2TLoZ9MHprwsHDjsHLJpiXzw12sfUWUAF3LdejQRd73az7CctMHhSsU87d6n8uI0q9bBoUShpSG2OePODxQv/vqMQVGvYKzSq15Zq1PrvRDZ9PNslflBJwpxRLdZj6eZCjKvEaOgpwd9AZcnPK7HIO4TXaMsrjknEILltus8vizJkDMqscD5NQiysoSRQQWzRHNYc/yh8G8KMWnLpKbYO+FzHOV1nP/LSWD/sJuSfkS1jT9HeL31tK7xfZppxGP2++zTBo17jRZpSP8tRaBWU1WEek313uK1Se8KxacNhZ5WTYm8+ej6aLX+yen4QnZs5ywKtHOVg6sfmQW7jM0TzDuaan0yu+Blk7HiqE0I+cna8ErSxtiBI1cx5+/Ynzj6LxsBKpu5+gMRgeIhmTV3fhw/61lz824mJjnrtkgBQoL7jp3XuPf8oeMGkX+YJZivA9Nbk5+2X1+P6FswHpy9HO3WvHsly+05L+5ppxY/7cSL8vHjE5jOEQPMgxYo8Wt5zpREnS59bDw4ec9ZPkIsx3n4I8ZTlJ4Ke3PgWsS8aJrgp0fqXSgYa7Tt7otigQnpSfXZf7iMzDV0A6hsCHFeHk4R+Gkjve0bBJBUWnbEiA+qinCDIG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(38100700002)(4326008)(8936002)(8676002)(2906002)(36756003)(6486002)(31686004)(2616005)(956004)(44832011)(7416002)(478600001)(45080400002)(5660300002)(86362001)(26005)(54906003)(110136005)(16576012)(316002)(66556008)(53546011)(31696002)(66946007)(66476007)(186003)(83380400001)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1cvcFZCNGJDNUFiZGs1WEVzUEJGcDhsMUNqY3JQWnc1Tnh4L3FEZkJPWjJN?=
 =?utf-8?B?OURaMmpVSFVJQUxjcmNVbi9GdjcvR2JjbE1iSDErMUJ6VFA0U1daSTFZYUwv?=
 =?utf-8?B?R2QyL0J3cVBLN0ExbWZJNjk1R3BIUlN0aFRObFhoRVlpaWxiK0MreXNGYTh5?=
 =?utf-8?B?blBwaCtRVm43T1pqZGJpd040aFRuODJTYVRTOGhUeHFCK3A1emUrUHpRZ25C?=
 =?utf-8?B?R254R05vYnIrZjRiY1J3b0drNXRCVWdPSjVCcHFYNHFYZDBIZENia0F2RWFS?=
 =?utf-8?B?UTJQNDhiSlJEWkRDeThwM1JMVkdmY3hxd2w1dXF1MWIyN1hzc3I3M0VPdFl0?=
 =?utf-8?B?dkxodkYvVHcyUmdJeWRDSTBDOUxCZXIrS3EzTElab0pGWDNNOXlDU2VqU2pQ?=
 =?utf-8?B?T2R6RmpSNnhUWEFyeFhaeHlsWkFzQkQ0ejc2WkI3SGY2MlhaS2p1Y1JlSENs?=
 =?utf-8?B?cmo1UnZnSytMTkR4K1JMY0dnOW5IUnU1a240ZHJSUTNpelpRQ1FOdllyL0ZM?=
 =?utf-8?B?NCtqRGgvY0tBVE5KbkhGWm9EMkJ2Z1U0Wk9acmFKZTBzb2dPR1FOZDJMUjI1?=
 =?utf-8?B?ZWpFK3phY2FHc256UEpqUmJIQmJGNTRIT2EwOW1kWGVqM1RWRGR4UGFydy95?=
 =?utf-8?B?NXBzdXI3WUFxbDFvbDFGVEtoZUYwM3JrWWRSRnhUeUR3UHBIK2k3YjArRUpN?=
 =?utf-8?B?cnRHOENGTUo5Uk9qYmg2VnNwbVRDU1pTWHZ4WHkrek5FN0ZsUFgveGJtN3Vj?=
 =?utf-8?B?ZTdSY1E2QnFsTFVrSjRjdUdURHAvMVp6YmNEQmlmZjdwZWFDU1dPWGNTQys0?=
 =?utf-8?B?c21CRWNXRURtRDlvOERsK0ZiOGVDdXMycmMzckVVOGpWT0ZtbkhvRElBbmlO?=
 =?utf-8?B?RHBQY01kajUrVW52SldPWjRSS2ZYMzdXMmpwUnExS0V6TGJnTWFmN2dGYmho?=
 =?utf-8?B?Qlp2MlorTnlOMVF1UnM5M3h1c2pxS2xLamxSY0xmd244V3IyaW5VVFdjRzBT?=
 =?utf-8?B?R3dKOHh2cytVQnRMaXlxUis0Q1RXWmJBK2tsSzlFalh5Y2l4SG9nSG1mUWty?=
 =?utf-8?B?WkpvSWhrazNmdUdkWHI2eURVamxPbndWZFU2RHpJdjN4QUdhWUZESVdRS2Fa?=
 =?utf-8?B?dzlEVm1yejh5T3FvazEwSEV0SUJCOEtZZnFnbDRyS3FETTVoYmdTR2V4bVhN?=
 =?utf-8?B?N0NZaXhyRnNjME84Um93R2ZPdzdiQ0dWVm9zNzhQY3lDZDRnSVM3eDY3M2hX?=
 =?utf-8?B?eTlFYmdtbHhIeWZVbW1PRVgwSFFMQkZGaFZDQlpoZXpkZVkxNzBzTE54YUdV?=
 =?utf-8?B?L3hVVWJOdFdDdElVUVRPL3FZOFdVMTRnS0M2cFF0VG80MDVkZTQ3WUNZRTZR?=
 =?utf-8?B?ZURJS2p5MlFDNGVXZDRtSVNDSlExdW9sQWVuTmJFcU8rd3dLT1RNOXZ5dXdk?=
 =?utf-8?B?WU1Cbzl6dzNVOEErcFJGNmd6N0hUN1NzMjVVT2xMeFgySnZNUFFaSkxRNHN2?=
 =?utf-8?B?ZDFUZHVDUGZUWnlJNHFpdVM4ZWZtQnRWa05RTjVMWTJuWkVsRTNndDhaSG5y?=
 =?utf-8?B?eWVNRmVGLzZpZlN5NTFMZzJvZW9mN0draGdoelpjdklFM2pQbWRQeXEzN0pq?=
 =?utf-8?B?UmdRR3czd0o4R1pBQWIrT0ZxM0tSM3JmRzJ5V1BVNGZpZmhwNnlweG5RaEQ5?=
 =?utf-8?B?KzZqWjE5eWtqaXB3c1lWT0JyRnEwano2MGpKT3lGYkJlWTRBS2d6T21qNncv?=
 =?utf-8?Q?bTjXRM9iAAGXMg06TNLOy9ExocH28cDdcjO6UJn?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0ed755-1f82-466f-3379-08d9619535e8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 15:39:33.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eliwm22MUSKb7vIu7Za7LkA3NFABl8f82ffZbjlILql8r4wN5CKGyoDcdRQEk9JjmdipnLzvCBuM7/2HjASiLn5yFYknEA0RKU6sbwwI1K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3730
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 15.07.20 17:26, Horia Geantă wrote:
> Add node for the RNGB block.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  arch/arm/boot/dts/imx6ull.dtsi | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
> index fcde7f77ae42..9bf67490ac49 100644
> --- a/arch/arm/boot/dts/imx6ull.dtsi
> +++ b/arch/arm/boot/dts/imx6ull.dtsi
> @@ -68,6 +68,13 @@
>  				clock-names = "dcp";
>  			};
>  
> +			rngb: rng@2284000 {
> +				compatible = "fsl,imx6ull-rngb", "fsl,imx25-rngb";
> +				reg = <0x02284000 0x4000>;
> +				interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks IMX6UL_CLK_DUMMY>;
> +			};
> +

My board (imx6ull-kontron-n6411-s.dts) fails to boot since this was added in v5.10-rc1. There is a crash in the RNG probe. Can anyone help?
Below is the interesting part of the boot log from v5.14-rc6.

Thanks
Frieder


[...]
Asymmetric key parser 'x509' registered
io scheduler mq-deadline registered
io scheduler kyber registered
imx_soc_device_init: failed to find fsl,imx6ul-ocotp regmap!
2020000.serial: ttymxc0 at MMIO 0x2020000 (irq = 30, base_baud = 5000000) is a IMX
21e8000.serial: ttymxc1 at MMIO 0x21e8000 (irq = 69, base_baud = 5000000) is a IMX
21ec000.serial: ttymxc2 at MMIO 0x21ec000 (irq = 70, base_baud = 5000000) is a IMX
21f0000.serial: ttymxc3 at MMIO 0x21f0000 (irq = 71, base_baud = 5000000) is a IMX
imx-uart 21f0000.serial: Console IMX rounded baud rate from 114943 to 114900
printk: console [ttymxc3] enabled
8<--- cut here ---
Unhandled fault: external abort on non-linefetch (0x008) at 0xe08d8000
pgd = (ptrval)
[e08d8000] *pgd=81c89811, *pte=02284653, *ppte=02284453
Internal error: : 8 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc6-ktn+g807a88195d76 #1
Hardware name: Freescale i.MX6 Ultralite (Device Tree)
PC is at imx_rngc_probe+0xa4/0x30c
LR is at _raw_spin_unlock_irqrestore+0x4c/0x50
pc : [<c06922b4>]    lr : [<c0c7ccd4>]    psr: 60000053
sp : c1ccfe00  ip : 00000001  fp : 00000000
r10: c1cb6240  r9 : c1fdeb40  r8 : 00000000
r7 : c1d98410  r6 : c1d98400  r5 : c1e07b40  r4 : 0000004c
r3 : e08d8000  r2 : 00000000  r1 : e591bac3  r0 : 00000000
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 8000406a  DAC: 00000051
Register r0 information: NULL pointer
Register r1 information: non-paged memory
Register r2 information: NULL pointer
Register r3 information: 0-page vmalloc region starting at 0xe08d8000 allocated at __devm_ioremap+0xa4/0xbc
Register r4 information: non-paged memory
Register r5 information: slab kmalloc-256 start c1e07b00 pointer offset 64 size 256
Register r6 information: slab kmalloc-1k start c1d98400 pointer offset 0 size 1024
Register r7 information: slab kmalloc-1k start c1d98400 pointer offset 16 size 1024
Register r8 information: NULL pointer
Register r9 information: slab kmalloc-64 start c1fdeb40 pointer offset 0 size 64
Register r10 information: slab kmalloc-192 start c1cb6240 pointer offset 0 size 192
Register r11 information: NULL pointer
Register r12 information: non-paged memory
Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
Stack: (0xc1ccfe00 to 0xc1cd0000)
fe00: 00000000 00000000 00000000 9cd54eeb 00000000 c1d98410 c145a4d4 00000000
fe20: c1d98410 c1244854 c1cb6240 c0710fb4 c1d98410 00000000 c145a4d4 00000000
fe40: c1d98410 c070e86c c1d98410 c145a4d4 c145a4d4 c070eadc c1b3b0fc c1b3b100
fe60: c145a4d4 c070eb70 00000000 c1d98410 c145a4d4 c1cce000 00000000 c070ef24
fe80: 00000000 c145a4d4 c070eeb4 c070cb9c c1fdd900 c1cb32b0 c1de0a14 9cd54eeb
fea0: c1cb32e4 c145a4d4 c1fdd900 00000000 c145cdf0 c070db70 c1024488 c122e530
fec0: c145a4d4 c145a4d4 c122e530 c145a4d4 c1308fcc c070fc7c c145a4c0 c122e530
fee0: c145a4d4 c0711470 c1cce000 c122e530 c14c6b80 c0102220 00000000 00000000
ff00: c1cb62e1 c1106d00 000000fc c014cd08 000000a2 c11059b8 c1051d10 c12003e8
ff20: c1cce000 c14c6b80 c1308fcc c11059b8 c14d1000 c1244854 000000fc c01aa110
ff40: 00000000 9cd54eeb c1254540 00000007 c1244874 c11059b8 c14d1000 c1244854
ff60: c1cb6240 c1201200 00000006 00000006 00000000 c12003e8 00000000 000000fc
ff80: 00000000 00000000 c0c71b20 00000000 00000000 00000000 00000000 00000000
ffa0: 00000000 c0c71b30 00000000 c010013c 00000000 00000000 00000000 00000000
ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c06922b4>] (imx_rngc_probe) from [<c0710fb4>] (platform_probe+0x58/0xb8)
[<c0710fb4>] (platform_probe) from [<c070e86c>] (really_probe+0x14c/0x33c)
[<c070e86c>] (really_probe) from [<c070eadc>] (__driver_probe_device+0x80/0xe4)
[<c070eadc>] (__driver_probe_device) from [<c070eb70>] (driver_probe_device+0x30/0xd4)
[<c070eb70>] (driver_probe_device) from [<c070ef24>] (__driver_attach+0x70/0xf4)
[<c070ef24>] (__driver_attach) from [<c070cb9c>] (bus_for_each_dev+0x78/0xb8)
[<c070cb9c>] (bus_for_each_dev) from [<c070db70>] (bus_add_driver+0x150/0x1dc)
[<c070db70>] (bus_add_driver) from [<c070fc7c>] (driver_register+0x74/0x108)
[<c070fc7c>] (driver_register) from [<c0711470>] (__platform_driver_probe+0x44/0xdc)
[<c0711470>] (__platform_driver_probe) from [<c0102220>] (do_one_initcall+0x80/0x3a8)
[<c0102220>] (do_one_initcall) from [<c1201200>] (kernel_init_freeable+0x1a0/0x234)
[<c1201200>] (kernel_init_freeable) from [<c0c71b30>] (kernel_init+0x10/0x124)
[<c0c71b30>] (kernel_init) from [<c010013c>] (ret_from_fork+0x14/0x38)
Exception stack(0xc1ccffb0 to 0xc1ccfff8)
ffa0:                                     00000000 00000000 00000000 00000000
ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: ebfe93da e2508000 1a00000f e5953008 (e5939000)
---[ end trace 27e536094eba35b6 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---




