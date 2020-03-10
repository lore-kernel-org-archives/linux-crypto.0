Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22152C10F27
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 12:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFBE124686
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 12:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="dAjegQPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJMAj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 08:00:39 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbgCJMAj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 08:00:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiGTv0S9GSE+GDnonuMUoqHP/bnnVTK83erg0AXW0l4kOM/zCAbaaZk+bY5i+pwv2gJOa+PJCKX6X+9tPooj6nXd3wtUz1wlLDBiXdaYAChwcqTC/S3IptGqvRH+UI+3OKv+Dbmq6fxUMQ3Y+AkEOVEMplPSgQVPnDvX/nMmhA9ATWS37IC0YczS/RQao2pBLTlLX9HVSAPTZsPoMXol5yk0Sx6zHuHmS/Y9Roc1d0LSUV9mwOzKkhaWRF5Y1w7pkMgL2EC2IQLRLEdWEm66KjwooZMigdkhZxbXllJek3byXYe00s4egiBZ1gJ93/mbSsw8GUTgBBV8MQ962yC6hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F9ZszTpaLI7LPCpVex2EXqRuc39RGdFCMe+2LzY1+w=;
 b=Od6itFBw0lYDlSS+coKXbHx90/+cST9lKpINAiufpG2SqDcJtt0s6Z0YqlgMwASVDNkGd7kauuhb6W1rHQGtc2yiNuoOb57wNbUoHN1QUPnin2Wk+mnsH7l+lM6nTE3sRXl09SWp/czAY8J31UOejfu9qP2AYAeZE+j20ZSMCHlrJR7DLi9fuJlFyVRuwfjEPVPuLeltXJDxU3/ajYhOnK/HCjK4u0TdALpy+6ZCQuE6j8COfTHcbhDQsOhVpObJ2pLs/j7L4C2GGrdHZxrwwTBj37E2LF8JkOx8FSxAzTMgTz1dDSo4cmBmrG2/7/mynGT6tFl7/YyeDPDu3Iz4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F9ZszTpaLI7LPCpVex2EXqRuc39RGdFCMe+2LzY1+w=;
 b=dAjegQPahbqWzDyXQzt2c85WpaR5je+TGEV7G+GeAfiJ7On3SzSOgu8PZANIdIOlsqWiI2eaSCwLGJIol+NDyYT8Re21iTBU7rWt37lG98nA0HId2veflEykdJJOcy0Pd24SxnJSKrxnl5thM/7Xu/5nJpYFlctMtssHlLi/pxw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Tue, 10 Mar 2020 12:00:35 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 12:00:35 +0000
Subject: Re: [PATCH] crypto: caam - select DMA address size at runtime
To:     Greg Ungerer <gerg@kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <e19cec7b-0721-391f-f43e-437062a7eab3@kernel.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <fafc165f-2bc7-73d6-b8e0-d40ed5786af3@nxp.com>
Date:   Tue, 10 Mar 2020 14:00:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <e19cec7b-0721-391f-f43e-437062a7eab3@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::16) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.171.74.188] (212.146.100.6) by AM0P190CA0006.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 12:00:34 +0000
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 90324d9d-282e-4ac7-88ac-08d7c4eaa3df
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB29250C447C2BB3C9710337E998FF0@VI1PR0402MB2925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:308;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(189003)(199004)(4326008)(66556008)(66476007)(66946007)(36756003)(31696002)(53546011)(478600001)(26005)(45080400002)(2906002)(16526019)(186003)(956004)(6486002)(2616005)(31686004)(5660300002)(52116002)(54906003)(8676002)(110136005)(16576012)(316002)(81156014)(81166006)(8936002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjTw4w1ITexzRfIBXxg1svTxvN1JflYL+fM8c6websxnFbL6QkZf0t5bg6fJCsQy+33ZsYhUyOHj/Gdo5PLAgp2v6MzPCm+jcAoaBc8hCt4oew8o1ETL26XdrJDeRFU+KsDxaDlz9dw+0cQoHKW1ycgjhqAT1cJjSXTDd3WnN3QGqN54/GXbm6epZ9PCN9fbVF+mZtNsOeCvDlD2NgXGf0J66DeG6oFKJAIjgTVkliRdQlVm8ptTazotTN2QZEINmIoFTMnG1MIZYjsXZ5f4HvYL1qPVWtUVi2uHpRVf8nLWs26wPINGIFStMycz1ElVa4nL4eHA2HBC8V5mLkEIDNKKHmJZ0QkvBq/4f/ZMwJQf3y0DwdHU/Ldd6oGT5WNF7a3YpqnfxzdajwDnbT9Hwx4l/7v9kp7DlRFamM7PlL788O+G8G9aRXUiaHRYPEy7
X-MS-Exchange-AntiSpam-MessageData: kMQQ/nnF5guJcI5JAQD65kMyTuLo4ZdonM1CkrctvTSVzNaGCvCvGrqGJkpJq6NfhBfQsYLKgyeKesmFpkOtn6FnA18+KlFYNkk6hSuP93eOx0Bq1+JbLwjOy3qYLT0IKLgnG48X2UBP48YhJIn6UQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90324d9d-282e-4ac7-88ac-08d7c4eaa3df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 12:00:34.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55WKHCoI3WcBce5a+xWQbNL1LsXNklhZi0uTMN69teClSHsMhwVF5l8AZwwmo3wMoZhfd879InVTyZGY9HWixQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/10/2020 8:43 AM, Greg Ungerer wrote:
> Hi Andrey,
> 
> I am tracking down a caam driver problem, where it is dumping on startup
> on a Layerscape 1046 based hardware platform. The dump typically looks
> something like this:
> 
> ------------[ cut here ]------------
> kernel BUG at drivers/crypto/caam/jr.c:218!
> Internal error: Oops - BUG: 0 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-ac0 #1
> Hardware name: Digi AnywhereUSB-8 (DT)
> pstate: 40000005 (nZcv daif -PAN -UAO)
> pc : caam_jr_dequeue+0x3f8/0x420
> lr : tasklet_action_common.isra.17+0x144/0x180
> sp : ffffffc010003df0
> x29: ffffffc010003df0 x28: 0000000000000001
> x27: 0000000000000000 x26: 0000000000000000
> x25: ffffff8020aeba80 x24: 0000000000000000
> x23: 0000000000000000 x22: ffffffc010ab4e51
> x21: 0000000000000001 x20: ffffffc010ab4000
> x19: ffffff8020a2ec10 x18: 0000000000000004
> x17: 0000000000000001 x16: 6800f1f100000000
> x15: ffffffc010de5000 x14: 0000000000000000
> x13: ffffffc010de5000 x12: ffffffc010de5000
> x11: 0000000000000000 x10: ffffff8073018080
> x9 : 0000000000000028 x8 : 0000000000000000
> x7 : 0000000000000000 x6 : ffffffc010a11140
> x5 : ffffffc06b070000 x4 : 0000000000000008
> x3 : ffffff8073018080 x2 : 0000000000000000
> x1 : 0000000000000001 x0 : 0000000000000000
> 
> Call trace:
>   caam_jr_dequeue+0x3f8/0x420
>   tasklet_action_common.isra.17+0x144/0x180
>   tasklet_action+0x24/0x30
>   _stext+0x114/0x228
>   irq_exit+0x64/0x70
>   __handle_domain_irq+0x64/0xb8
>   gic_handle_irq+0x50/0xa0
>   el1_irq+0xb8/0x140
>   arch_cpu_idle+0x10/0x18
>   do_idle+0xf0/0x118
>   cpu_startup_entry+0x24/0x60
>   rest_init+0xb0/0xbc
>   arch_call_rest_init+0xc/0x14
>   start_kernel+0x3d0/0x3fc
> Code: d3607c21 2a020002 aa010041 17ffff4d (d4210000)
> ---[ end trace ce2c4c37d2c89a99 ]---
> 
> 
> Git bisecting this lead me to commit a1cf573ee95d ("crypto: caam -
> select DMA address size at runtime") as the culprit.
> 
> I came across commit by Iuliana, 7278fa25aa0e ("crypto: caam -
> do not reset pointer size from MCFGR register"). However that
> doesn't fix this dumping problem for me (it does seem to occur
> less often though). [NOTE: dump above generated with this
> change applied].
> 
> I initially hit this dump on a linux-5.4, and it also occurs on
> linux-5.5 for me.
> 
> Any thoughts?
> 
Could you try the following patch?
It worked on my side.

Unfortunately I don't think it fixes the root cause,
the device should work fine (though slower) without the property.
DMA API violations (e.g. cacheline sharing) are a good candidate.

--- >8 ---

Subject: [PATCH] arm64: dts: ls1046a: mark crypto engine dma coherent

Crypto engine (CAAM) on LS1046A platform has support for HW coherency,
mark accordingly the DT node.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index d4c1da3d4bde..9e8147ef1748 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -244,6 +244,7 @@
                        ranges = <0x0 0x00 0x1700000 0x100000>;
                        reg = <0x00 0x1700000 0x0 0x100000>;
                        interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+                       dma-coherent;

                        sec_jr0: jr@10000 {
                                compatible = "fsl,sec-v5.4-job-ring",
--
2.17.1
