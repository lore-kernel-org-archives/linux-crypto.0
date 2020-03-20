Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5525BC4332B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 15:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAC720658
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 15:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CziGsZ/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCTPtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 11:49:15 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:8928
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727092AbgCTPtP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 11:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REOsMDC8xWT5SgxjkyiBqD0PINiy/ruoM0RMYYcFelvDVRojiG+FxXgFXRBMrf5JLz0x0T9iXiEvf+XKqhvV/vX7FBKHkJjQvb/Q07XaZpbTfgmD+OtO9U6ZX74YAPdfBDIEVqSW3gnUzGncCcxl9nyWyspHyIE2e+mUVMH7/PnPgCpAfkFKhZcPjo6Mg2+vbMaa/X6iz+o3hrz5XiqIloFOkEGM3A61Po7Gji/0znAubzJ7XZNOTuyLNj+YeRDlUQo3138GtvAtBQW/H8+9w4upCh0Aa9Foj1iSb2vIqp8j9ARbf+Oss+PnLE4qQzrm297M3tzdVDodEllgPmQ7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7KS2GBP2w0N6N/VKWsgXZ0nqQ7UtNomvIqh0tNu8Zs=;
 b=Md7MRCltMPJciQ6tzhd8Z/nsPgH8sG3dssccdCRpH5bIh/ppdwA28fHXWTxaSbRnJ7e+D9hiU2/jrQypnOyMiU9+LbHHAoZueVhw7QtrFBxOL36qY+b4qsKlDyHTeSrr5d3xs6ErNLM4HEGEGQRQI/8gB4y65jV6+Z4Xv52ydsczfNHUUucDDtq5pvsIfl7umjfFmGJeytKpFs1JkqUCMe0idVd3AGnC3IrKOrLssbXMbDEbuGIKB1IUREjVuHoyNsuH3SVBwYz0kCX10EMgqjm8ZYQwDPY1s6tiEqexbckfEM6h4nZNSjkqlINZIVDnOOPPv5dEOcaYNh48XZ3Xag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7KS2GBP2w0N6N/VKWsgXZ0nqQ7UtNomvIqh0tNu8Zs=;
 b=CziGsZ/DQGwN02st8isN2ODPlSXEN8aMRnUB/CDQ39tEvLTgkjMQg1iarkSkTL07VBmCOzQ4ZGPm3bSBqcfvdQjObm4enN6r7frP+pcSLzC09YLWlSGJzqXGj6onw6ZLFeB/IOn2cwlIdOncJoJwy9OXqz6+clixt3EhZ2zaGkg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3470.eurprd04.prod.outlook.com (52.134.8.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Fri, 20 Mar 2020 15:49:10 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Fri, 20 Mar 2020
 15:49:10 +0000
Subject: Re: [PATCH v9 8/9] crypto: caam - enable prediction resistance in
 HRWNG
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
 <20200319161233.8134-9-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <723de89a-4d5c-467a-4008-fd5e575bb43d@nxp.com>
Date:   Fri, 20 Mar 2020 17:49:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200319161233.8134-9-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR05CA0039.eurprd05.prod.outlook.com
 (2603:10a6:208:be::16) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR05CA0039.eurprd05.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 15:49:09 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c08997f2-7683-4d43-251b-08d7cce63b50
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3470:|VI1PR0402MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3470EA1FE36EF459BE1816CF98F50@VI1PR0402MB3470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(8676002)(316002)(66556008)(66946007)(66476007)(6486002)(36756003)(81156014)(478600001)(5660300002)(4744005)(31686004)(16576012)(86362001)(26005)(31696002)(52116002)(81166006)(53546011)(8936002)(2906002)(54906003)(2616005)(186003)(956004)(16526019)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3470;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFU7TrO9/kPi5esXjVGkTheYN+9v9dmhZL6YG202ntUl1F7MZfGIOEHuhPh3ebRD9SInzYm6juBHQr862qHYzVWuRTM98IZiHqnMkysElQvtZML3j9QHqgxmDQ12ge7Z0cZ6mZFuk7xieHMNpYYlrtjrCP4c/tZm4NTZymK3WXYiiN62jg7WfHm+76FAlURzxuolJSTbdvBAcZBex8MW/2xnNeGDz8zuOz406+XcTth2WCPt+U2nqFl0WZvhvOq3xmsVcSESDVWRcZz1pX1WJud8Iuy1PWOU/piEqYWCEvwU+1fmPGH+omvhC5m1QkNfXx5tZruIWqAQuuwSkf34HZQnuaJR3F48OosiHHE5aUSytARBa9ktVvI3U8ZdRBE6V0pHDALudn3aoVeh+s0+UtMPHoF1dOpsLdIYFXXmCNCLF70igODN/Nx5nmrcoBOq
X-MS-Exchange-AntiSpam-MessageData: /0fary+HsLVM4wG73HTILHNKkpVLvE1HgtQA/0as1jG+d76+Y+FFFNpmRgRWe/NADE8iEFQO0gUUMLcdqhHPehetL7zzYAtb8jMQhidW6dfObmQOKe/uKxsJanIcTiKuaT5YraIkFlqnlvRxA68dtA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08997f2-7683-4d43-251b-08d7cce63b50
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 15:49:10.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIGpOkfr21VMrlPVvf11LL/SV5rfIKh9eiM5Ww9G6ZSCmIIhVTde16+xkDLfpa2KdSkzrcXCtnKCHsFUQNeKSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/19/2020 6:13 PM, Andrey Smirnov wrote:
> Instantiate CAAM RNG with prediction resistance enabled to improve its
> quality (with PR on DRNG is forced to reseed from TRNG every time
> random data is generated).
> 
> Management Complex firmware with version lower than 10.20.0
> doesn't provide prediction resistance support. Consider this
> and only instantiate rng when mc f/w version is lower.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-imx@nxp.com
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
