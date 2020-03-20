Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405B1C4332D
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 15:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40582070A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 15:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="SC8WgbLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCTPrP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 11:47:15 -0400
Received: from mail-eopbgr40058.outbound.protection.outlook.com ([40.107.4.58]:63458
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgCTPrP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 11:47:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StixpbTvvghFQpPvzeVrhTr3mbCU1t+tJvwSfQMR2mmYxOXMUC+epW/0KvifPNbzQnGn3HdWK40CvvxJtaZkSWaZc0BUbJ6xSkS0yKAM/D01lM5RjKP9ojZiibL3oFhDAuYYlOeT3M9NDvHspmiRCXnP13WlTAeNgfvIRGBAnKArTz5ZRCIQCfN3hiHIVmLHyJmrh91p/iDGODWxUMcNtRX6HYRDhLDg94i+SsIzYreQUXsIxoVSxDxgBg+6paDn/YF7mV1/21rlQEOOVxWDGrUvc5xhXnyUlWdmXiIspHc9C3a4iJz7tlrQZMuICQW2Nbl+7vvOXPdalqzO1+Ixeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNb05hX3tBOltDMogW3TZSrHwp0jrI/v3P12zWSSpto=;
 b=fsGzlUSexKN1Hlm2nNEzRCcCN3IC9plU9xqy5RrF+/uUYTu+PiJPPIFwjeppMSJuLzceVXTIVtRlItRSvODF0R6DUB2tVCft9YW6Wk4LUTsgoFnrPw4jiqaxQ14DeRBAjdbOGtIdLdhDKJ5//s1j/98ZjvKGrjAlCnFFTXuIlKiV8+1DtXveLERiSN16QnU3i3GWzs349fLNt1xu5UnPaNkPSWTlcqhjDSKxZmEAsmbKPUNa3sEci36hhj8gs0QaGSbHjb4oPk1av7/cmyVPBLqtLVDven0wfMWiDK/wg9hkfxueaV5fWCVAgMju+wya3M9s51Aa/wigQQ5c6guiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNb05hX3tBOltDMogW3TZSrHwp0jrI/v3P12zWSSpto=;
 b=SC8WgbLHVfQpUiU7S5NhRDLhR3O1BrInaqnNhy0vU8ErASwJuW4vPnJQi24TWFxbrUrpr9ANtSoqRBTxe6zobELLnqaFO+SBO6RXkEwdR8fubNQkitanfvHAOeObyifW5PjyoKaKqD+agzeIYphYdRHysTVbiNoMQ2OKuVJK/bI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3470.eurprd04.prod.outlook.com (52.134.8.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Fri, 20 Mar 2020 15:47:11 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Fri, 20 Mar 2020
 15:47:11 +0000
Subject: Re: [PATCH v9 3/9] crypto: caam - drop global context pointer and
 init_done
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
 <20200319161233.8134-4-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <09e82dba-2130-b1d7-73af-d03927be5d56@nxp.com>
Date:   Fri, 20 Mar 2020 17:47:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200319161233.8134-4-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0134.eurprd05.prod.outlook.com
 (2603:10a6:207:3::12) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR05CA0134.eurprd05.prod.outlook.com (2603:10a6:207:3::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 15:47:09 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 818ce772-69a3-42eb-b4a8-08d7cce5f3cb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3470:|VI1PR0402MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34701D8BB657A6BF3594DBED98F50@VI1PR0402MB3470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(53546011)(6666004)(2906002)(54906003)(8936002)(86362001)(16576012)(52116002)(81166006)(31696002)(26005)(2616005)(16526019)(4326008)(186003)(956004)(36756003)(66556008)(66946007)(8676002)(316002)(6486002)(66476007)(5660300002)(31686004)(4744005)(81156014)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3470;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUY/uiF1kiEOomMmjWsyXdsRo3+kKcFUqTIA42x2OIM6Lp5bowt+EPBX/jhp6ZFYId+wPIOJYdjWM5EVkhDwBPKw5K6zt4qwpofKIlf5HPGPmPzIR1cqADbz5KplDzY27hGtbsNxHHkh+gumhNdsat7+tHg5HBMI7cwLPnHF5Qo8Rkhju+k13gnolg0kj7Qlj6IqMTF0iOjPYNq5JHHZy0QiaQ0mGM6gNRA72GdGTtA1ehIienlxevPMPh+hKdrOsbphwu2TwUINIEF4q7RvahdB+sY9h+n3oSjdYS2E/zdYB09lRPK6XTlZwBz7l/OZfNj/Q6tdsJsbaeDdROWTLV8vqzaoni93/a567GZM+t8noEztNrSvO3La3JB8TJWpYqStpz2TPsl1QiyD5+maL07MvJfROSMOwpu5HzZgKyQZR3lq6tfF8FcSyi+gI5fW
X-MS-Exchange-AntiSpam-MessageData: 6ECTwcNmEOLzoRmJ4vIVqlnVEEptHmCF3CB59TmH/PcGvLPnc6Uf9IZla+C7ZLDPb9b7hGj3TYVMjZ4B4v9wefeu7/SpEUteKI3c9Srvw7OQe76KQ9L+OTESVZZ5RRiZVGLfvRtMqzfBLY5lMXxQLg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818ce772-69a3-42eb-b4a8-08d7cce5f3cb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 15:47:10.9813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7eL2Q1TpkJdK44Ybm4aQRNikILOPCXTVUqM4MDwFrldAem4eKYwha8Q65N+ef90nTgTXXvsgCudyMOlG+Zvjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/19/2020 6:13 PM, Andrey Smirnov wrote:
> Leverage devres to get rid of code storing global context as well as
> init_done flag.
> 
> Original code also has a circular deallocation dependency where
> unregister_algs() -> caam_rng_exit() -> caam_jr_free() chain would
> only happen if all of JRs were freed. Fix this by moving
> caam_rng_exit() outside of unregister_algs() and doing it specifically
> for JR that instantiated HWRNG.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
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
