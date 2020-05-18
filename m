Return-Path: <SRS0=Edis=7A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D765C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 May 2020 19:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEBC207F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 May 2020 19:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PFwKy8Nf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgERS7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 May 2020 14:59:49 -0400
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:37377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728436AbgERS7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 May 2020 14:59:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C64yOT3JWkxKpxgQ8GDcmReEDBlNEfLP1vo7iby32iLqfPBpsh7sJgv+YqQ53FfLAdtQt5+eKVzbdjxoGdmS2I20qiZkqIEJTpSNiYW6Re/YseSk9snkNMFmHZKABlDv+4RSuKTiMZN2zoOT3w09BnBmfwN0t+1on16kd6AGkaWt5yVvK7vE5OdDCDXEtbtKsT6uUi9QSANnE3Tm0af7d5GWywVMdYFzXZJ8mZxiGoVMpl+1SWnKbwlnQi1Hu9xEQ/50rlvjriHxHXI6FEirmj88SGZYc1LvbNF/kIDp4nZxaVdC04hQkdbOvbt2zP6XrXxLIEQzL7GXVcQjeTWtHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0vLKOvf7n9zSXNZqc9CjLV8tzmGoLjxZu6uGCO+L4M=;
 b=gMD+fGo79BUZfRIreHEQTnNrqp41nGWLJvIjXxku8jC9EDf99XbZRUW3KSmh+j/JCXZhwHf8mXhs5acLeyOFZOomrQKA4S8Xa0FtFOe1oDJgj118Z84qyXzuo/gsgC5Ygkxo34gwzeSVJd/BxOtYl9VR5SH5QoKR3Q9XzEV66cquimg3eml8W6c1F/f+Aip3D+qzmRcBZJwSbR5SpnD1VNoCTfUEKKeU4KE5fn13RMf8FATgt+yDykwDkbaoU0VQwaj2qMF4sJoH/wLrRpO+rmY5w2aV/D5B9AoT7I3EH1w2Em1YfEdx/L/wRhaaM7GRkVfspO5zVdMHC5yps0bW8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0vLKOvf7n9zSXNZqc9CjLV8tzmGoLjxZu6uGCO+L4M=;
 b=PFwKy8Nfbncc6O3exNkguL2qcx32qxNooObG2H1BFfS9NGxaeop0UU+d9/K8CRx4t/fMoMYSaCSmyC7zPpv4fb/AK9uvwJ5eqnnunxISbQecboi9fi49SDowqsQ160yn1OyLKc2hwNoKxu1lsOdrnyI/bSZff89M6NTdhmekKYU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1SPR01MB0363.eurprd04.prod.outlook.com (2603:10a6:803:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 18:59:35 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 18:59:35 +0000
Subject: Re: [PATCH] crypto: caam - make soc match data optional
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200516042303.6070-1-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <befcc520-6556-b09b-0464-fe0b5f28cf1e@nxp.com>
Date:   Mon, 18 May 2020 21:59:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200516042303.6070-1-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::19) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Mon, 18 May 2020 18:59:34 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45c46176-eced-4046-ccb1-08d7fb5d9b2f
X-MS-TrafficTypeDiagnostic: VI1SPR01MB0363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1SPR01MB03635821E0D5458F8361CC3A98B80@VI1SPR01MB0363.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+nlIMLjL3LHI4530krvPJlgmoDJbM/X1iYfFRFCchV3QRPT7UDOXOv998VwyKBk6Wyg1BC1YDdIAgnGr7DvEduGIfEpO+QG3aMc74QsxdjoPfR+7xL9rin3ZOafhGQ4lNOv+kDTI1rs8Hn67HP44IRj7zdZtp4MxDNAKlCaPLUmDRLT8df+BExglgP3IMXVawb5emQ3Z4MCCEUNh6UtBXgf1lOl3QFVZ2swqYyW6IjYwPNE+gt3GgFLBV0RTLClX4hlOq79XnWStHVO6rXTYRpPcbxv2PzyE0FH2yAmD8+zd/1FsMHcK988CB8i+Z+mLiitZ0y4/dcWiIP2NDwm3T09qjKbJXD88UnCeCTVvp78TaYPoZEVuFy5xIpctqbbf/BR/3aBLyCiMgZFOW2MQZa38IyxSTYXKNan3AtsGmIM2oUeiUIbmRe0mfM8egYmvhOFMdN/4Yn0UBqCHXB5s9+oWlYYVv07RxLMvPdkM5cWUG6cRE4EJ6s3T4ACyLAF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(66946007)(66556008)(478600001)(110136005)(5660300002)(2616005)(86362001)(26005)(6486002)(8676002)(54906003)(31696002)(6666004)(66476007)(31686004)(53546011)(8936002)(16526019)(4326008)(2906002)(36756003)(16576012)(186003)(52116002)(316002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SrJa9gmPzBV9ZmEWkhkFuMu1ZmYNH3uEQRfb4fFBL1qXHmEHsWAgkWg3F/J9jvF8usX1ZeYXCYvWrdUwbI+qZHszz9QL6DTQl8FDj66g8HjQtWZ8vEa2ncf21nxH8ZEkoXoH+9TcAfbwXyjBV1JPoHfJZ6VHKEfX9t8LlY5rR6trHMO6+XYUUIh8U5CD6uKDOA01urQLDQZG1nUqZ9Y+Vp5ZpkcwQmZVPEICOhvwd9RcpGthVl3n+0ydziicxYQ45R9VoTblxTn3SUVYt2eR9GpWES0mydmniQ/MtHbZ34nJ32yvtoBQbL48mSXF6qo4TJCU2UtlB2/snC9sXXv5Nm9neAtqvE7ht4DKzgGTHFdlFll+W9vDoSc7RQPoedXBqx+lcPMfyPgx5zvTinWXmNQK6+1LXk/JSjPRiYWpPv8PUBCH7Xmw/Ky+BYcA7JSrh3HcjyfmoHH3Xrc1e6OoXluejxug7Bw6r+wRUd/EjDx1wOhBQrBT+oLkfjNljt/j
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c46176-eced-4046-ccb1-08d7fb5d9b2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 18:59:35.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik3HFR14vs9BGONf7FCqJq73q2KAwcva5cApnWefafEHoEn0aVM4RyE5ueMBpmdxsOcIcfPPVD8rOR+qOvA/ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0363
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/16/2020 7:23 AM, Andrey Smirnov wrote:
> Vyrbrid devices don't have any clock that need to be taken care of, so
> make clock data optional on i.MX.
> 
Vybrid Security RM states that IPG clock used by CAAM
can be gated by CCM_CCGR11[CG176].

Clock driver needs to be updated accordingly,
and so will CAAM driver and DT node.

I don't have a board at hand, so patch below is not tested.

Horia

------ >8 ------

Subject: [PATCH] clk: imx: vf610: add CAAM clock

According to Vybrid Security RM, CCM_CCGR11[CG176] can be used to
gate CAAM ipg clock.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/clk/imx/clk-vf610.c             | 2 ++
 include/dt-bindings/clock/vf610-clock.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-vf610.c b/drivers/clk/imx/clk-vf610.c
index cd04e7dc1878..4f3066cf1b89 100644
--- a/drivers/clk/imx/clk-vf610.c
+++ b/drivers/clk/imx/clk-vf610.c
@@ -439,6 +439,8 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
        clk[VF610_CLK_DAP] = imx_clk_gate("dap", "platform_bus", CCM_CCSR, 24);
        clk[VF610_CLK_OCOTP] = imx_clk_gate("ocotp", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(5));

+       clk[VF610_CLK_CAAM] = imx_clk_gate2("caam", "ipg_bus", CCM_CCGR11, CCM_CCGRx_CGn(0));
+
        imx_check_clocks(clk, ARRAY_SIZE(clk));

        clk_set_parent(clk[VF610_CLK_QSPI0_SEL], clk[VF610_CLK_PLL1_PFD4]);
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index 95394f35a74a..0f2d60e884dc 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -195,6 +195,7 @@
 #define VF610_CLK_WKPU                 186
 #define VF610_CLK_TCON0                        187
 #define VF610_CLK_TCON1                        188
-#define VF610_CLK_END                  189
+#define VF610_CLK_CAAM                 189
+#define VF610_CLK_END                  190

 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
--
2.17.1
