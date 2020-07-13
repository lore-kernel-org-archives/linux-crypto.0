Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B223DC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 15:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887DA20771
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 15:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BPCdQZe5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgGMPtH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 11:49:07 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:8356
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729782AbgGMPtG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 11:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3CNlD8xnofy+ibtp4rhJKHU5EESooREUK1A63+OmDJZrldBAPT/qZp7jrYN6MVrWBR2s8LSgfcZVEEYMNZG/ClDaDr3KtPLaVOKfaXg6n+rHJJ3T4GI5/svffEHeoUXqxoMBbiozt7NZm/hojn8dXG1V7ONnMrNwSqHP0ywWmOzb86i4/qZiHmcrxRyoBD1GbhhGJVebGIyQek+X6rgLkx9ElXOsx31CztiYGPlD0Lsoy9NnHPQpLERXZA51U65C/SHpNxsAbu4KoaMPgzduG+KYaZ3G9qnWJ5P6AdM6MIWsqs5h/BjLygRUlxq7vF3ULNUxnaLkwVGCQCE+MjTuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gfx4GQsTlVDC8voxgChvmmt5a3J9fZAcYHF1DSBrWw4=;
 b=SDmjIxe9xeObWgzLOxTvN6T4pQfCzjdD7/DHmOaMg49YfwSqU2SYFrAp4i7AxeBDw5dNRnAx225crwSOkSxAfqMVoHWcpi8a1YqwdPeo0saPMmb7PgJXQbs0iH0UW1Tu75Z1XvOjClNIPHKw7ZmEwmw4FMgIRYryo4E69pO4JrYdRBtZ8Sj1AA+tMyR0tOI3E3MkHDqP0QfCmwbOzeIlwvMyFjCD5D7rbmn6hYF8hYaHVQaubWmkkvVN66zDWbZYzpNHkufzc3pWikDG7aNI/le2K1ROhZGwD71mP1rAWaRXKFhK1kokIkGNI0+K/RnAOw11wAnZThSK9vOxc9145w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gfx4GQsTlVDC8voxgChvmmt5a3J9fZAcYHF1DSBrWw4=;
 b=BPCdQZe54NW2FAx1yyBjVaUtH2PDDo2uUVZx+ULCUXGKGr3K4poWYTtnaAsfvgJa/ILmGgWTnxV0cGP5jy9EWliOoPvQ47xG//Zf+/mYEhEpMcI8avISA/JcypELRG19vjtgyizg9B1MWaCKt61fdIYZrXnyCC1xH8PuMPn8sxU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Mon, 13 Jul
 2020 15:49:03 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 15:49:03 +0000
Subject: Re: [PATCH 5/6] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
To:     Eric Biggers <ebiggers@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org>
 <20200701045217.121126-6-ebiggers@kernel.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <3f2d3409-2739-b121-0469-b14c86110b2d@nxp.com>
Date:   Mon, 13 Jul 2020 18:49:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200701045217.121126-6-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0145.eurprd07.prod.outlook.com
 (2603:10a6:207:8::31) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR07CA0145.eurprd07.prod.outlook.com (2603:10a6:207:8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.16 via Frontend Transport; Mon, 13 Jul 2020 15:49:02 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1060a725-c530-44b1-d17c-08d82744445e
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815779B0E4B14847BCAB99298600@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /bX4p1FrlB0O/Qc+9QRFIwmIHHrutAA6azjO1o81WmvZtaCUnSkTZSB98w/hRe0n9qgWJCSq5ChYtpeK4B5yV/7/PoYsvhGpYQw5615mdMLveyf86a3t3kiwZHag1mJ+5zPBl94oz4kBq7smuOQkaoHwbJGzTchl4462182qXCA+yvabIG84y3IX/jZSY6fbOSPE0128E4bIPoyGuLp4TXegjBlBlgpH+fjnkNu/Au0r2QQXP/q1fc+PlBWCWxHwFUVXsUGtgY7og0sMQL57m9lDoBcPbaKcoM+qPWP4F8clyAhMtANzN+886dlgZZUw7iKciR2qFK9pukP8EuJFu42cfqa9VCxA/nQVESZSyW5SloqEbL/isFnTQ8FgGtcQHSBTKYDtEFjuKWOfEtuDEIBFWz+qqMhypSoFpkQ5QVfBXVR19fMW8y1HEffqDnKPvZ/oLkm7C8cGlEPNLJgN6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(5660300002)(66476007)(66946007)(66556008)(52116002)(53546011)(2906002)(31686004)(36756003)(31696002)(8676002)(86362001)(16526019)(4326008)(966005)(956004)(83380400001)(110136005)(478600001)(26005)(2616005)(16576012)(6486002)(186003)(8936002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sAglqdfsWhn+2W4QOzcYYJigwd9bWnW8FQhgH6RABmWwgMMoeNpZMhurrelUNH6+jqwDJR5FuyCcrMmkb+z8zeK6OevdjDrsbOba4+MmwQC1ag8PCbrewOGp5551PPECTo+oSwizq7rhK8FIQJ/NU4C8qH4pnVa2xXUh8NACQltCi+COH7/wtnDQ973duIutMJGCIwBAm92k8gG6gNvelWClEEAukdlX9ZxH1ZHUjn4s+vAtW7Hg/Oa0f7OkrZqneXqfEa1BWXyz88INKBvdi+sg9XMBisI7REGBXHiQEUmp7dXY0GtttTjWU3g5ofRKoSIn2VTHYcrM4p9ceYm4ooXztXSZFFCDv8DEI9wzXKzTPCbie2C6Xi9CaXBWqP+QXKqFweQwGY2M5hnZADHY4wfMSvKD3cHi6tifikFleyhGL1v0o02lRZUgrN4ZzdmXu8+8PIo2/G36uhaf9xnPY+wAcXxUXU0CYbO8NqB4zhwCRfsaHYkje5w8JaLLVtF7
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1060a725-c530-44b1-d17c-08d82744445e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 15:49:03.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /K9fl8CNNVGVU2+JhfpS/Yuop/gxJ6DuzbZuiRtz4oot/v814x7L+9Cz2EAsiC5cEoblW1ctS3caoZDkRXD/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/1/2020 7:52 AM, Eric Biggers wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
> allocate memory.
> 
Quite a few drivers are impacted.

I wonder what's the proper way to address the memory allocation.

Herbert mentioned setting up reqsize:
https://lore.kernel.org/linux-crypto/20200610010450.GA6449@gondor.apana.org.au/

I see at least two hurdles in converting the drivers to using reqsize:

1. Some drivers allocate the memory using GFP_DMA

reqsize does not allow drivers to control gfp allocation flags.

I've tried converting talitos driver (to use reqsize) at some point,
and in the process adding a generic CRYPTO_TFM_REQ_DMA flag:
https://lore.kernel.org/linux-crypto/54FD8D3B.5040409@freescale.com
https://lore.kernel.org/linux-crypto/1426266882-31626-1-git-send-email-horia.geanta@freescale.com

The flag was supposed to be transparent for the user,
however there were users that open-coded the request allocation,
for example esp_alloc_tmp() in net/ipv4/esp4.c.
At that time, Dave NACK-ed the change:
https://lore.kernel.org/linux-crypto/1426266922-31679-1-git-send-email-horia.geanta@freescale.com


2. Memory requirements cannot be determined / are not known
at request allocation time

An analysis for talitos driver is here:
https://lore.kernel.org/linux-crypto/54F8235B.5080301@freescale.com

In general, drivers would be forced to ask more memory than needed,
to handle the "worst-case".
Logic will be needed to fail in case the "worst-case" isn't correctly estimated.

However, this is still problematic.

For example, a driver could set up reqsize to accommodate for 32 S/G entries
(in the HW S/G table). In case a dm-crypt encryption request would require more,
then driver's .encrypt callback would fail, possibly with -ENOMEM,
since there's not enough pre-allocated memory.
This brings us back to the same problem we're trying to solve,
since in this case the driver would be forced to either fail immediately or
to allocate memory at .encrypt/.decrypt time.

Thanks,
Horia
