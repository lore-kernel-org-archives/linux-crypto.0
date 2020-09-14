Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E5EC433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 16:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9C021BE5
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 16:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OGF2Tszh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgINQYd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 12:24:33 -0400
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:9953
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbgINQYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 12:24:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR3C5PQhATCsmdONy+cC0XEaMZ26D8j+5n5gX4OJhqmCUnnBZbDWwXJCy+twKlEKRzAQyvrAZH1/pAXCIe9t2JImn2O4b1PpkupMPJoqPcBbweOyfrV/ShquJnVFtRoIFRX8AYMI268goq6NhiWLYRJEfrRlN52Ju76pKvVSqXkxdReOTcKpTqZxXvZoD/S7MNWn89U4hSdl1jgxkXwVznqDnygXH3CIaRu7WDzfRem9YjQHum3R59+eKApEd1wEoGSNshCROGuGP8TDDerBC7DB7ND3EmhzPqVZaqO5NccCW6eO1PTfvSHq117myu9r3sh+Z4+sHk4Qr+f+edEdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMrcNaoRj9zGHVJ/B3mAde/4Isqj0p+xMMBeDwv7iUI=;
 b=bDLPAm9UGGn/GpmC23SU/EQW/+CNX8GBKUSY2sdRdueN81X0Za2d55B4wSKxCGd8qQQK3oHtAxJW6mtkem44xMEBkEQlm3VYfofyHPa9B1Rd5CTkWvXwPVxyh6zTxyX0dtjjkzAsaXiPDRx+yNlnr22cNACYa69+hgU5WhQR+pvVnJ+3kZ/r7Rpc2eVNTS4l06+cK8c12lEmiGS1uTPOcFNKhhNOMBQX6flwtAG6CT/QtejJ9uSLD/B/365Gl1fuhXwbRZsFaUl2vKm6q46/tWTmU8twLBPlrjtmHS2epENwNC74NkcRZqf0a8NH1GM/QgyUMmbFvpYquUjt67VReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMrcNaoRj9zGHVJ/B3mAde/4Isqj0p+xMMBeDwv7iUI=;
 b=OGF2Tszh3cZiXEvfpKDI2eu9TtPmYDpCswM+qGiEEq0PnCDtE3wbO4GVCsFiRDhbeeXkEnl8XTt2KRjw4T8ih976aGH7tSXBFEi7u1QT2EVJ5fCSGhyC+HMPi2Ch2MjLF7NCMFbAXua8fKU/vAojTbCEIAO5E51zAABUYWhtq0U=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 16:24:01 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:24:01 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
 <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com>
 <20200908221019.GA23497@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <67159207-1082-48be-d085-971a84b525e0@nxp.com>
Date:   Mon, 14 Sep 2020 19:23:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200908221019.GA23497@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0055.eurprd05.prod.outlook.com
 (2603:10a6:200:68::23) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM4PR0501CA0055.eurprd05.prod.outlook.com (2603:10a6:200:68::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:24:00 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b550fd8-b8df-4179-f023-08d858ca96d5
X-MS-TrafficTypeDiagnostic: VI1PR04MB4046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB404673AA430DCBE7A38F141698230@VI1PR04MB4046.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWGC2ZbbUtskszYJANqw+rzghdDV5VsryAj2kwC4BnXaVBF8adEKs60lVQ8cwX0yLTaoMVwBN3+LqrrJqVW+luNDsWr+QdTZhLBP8UGt7MCDJntmqpZkAPAaM0EZD8vHN39OctAzXaQIW0sbVuUkzM6dlRvsSU39wrqZipdr3bX/gx0Tf9qYTi4+oVWWcZm79vgeRitDmJNdVG+lg1Gtr8mSvMkR2XWTYX5fSK4K6ZlaT8uX4KOruJMlBTsHI9U41cnX1h6VNsp5W9WhOYdvqJgFKyFJBKyTvAibXOSAbo/zBetSADldFHvZyDPej/SoF+We5ORTbJUuZKCxuSUcIL9Gwbl1hPhAG98ywEZFH9UaLq8Sp3UVtYV74XQkqKXb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(36756003)(83380400001)(4744005)(6486002)(16576012)(316002)(8936002)(6666004)(66946007)(66476007)(66556008)(54906003)(186003)(26005)(16526019)(52116002)(2906002)(31696002)(6916009)(8676002)(478600001)(956004)(53546011)(31686004)(5660300002)(2616005)(86362001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WZTZoyOJjF/kIg/SAGs+3xV6vdtaalxHzmSXOVYU9OAqwoe9vvvKx5uk2rg8OSPY9xRDg3S8NHTJUXee+PAL168XbfLrzfpn5OhBnhw9uAwL7LhDc1cuOZoN3wumbSS0h6NZ1UVYNbRlCv/bBRbWOum6Az8yRYobM2Z6FkVG1JtX6MszbmWlMSamo7WbbWG1isYMecvJrUmyGKApaNmGKpeUabYDJDXi8/twQi4mAWU2jnEjCtHWYiJ00X35oV8EdI9BDBUKBaS4LfV1ybmeoKmtniE5n5tT0tLs4ebtoU6kVwicPI36pbNXvo6HQMEtsIlr1q0IVBYQQrNW5v9WMc/y2mioTltCCFX8T6bWF9RpK6NxkKpAgF8/tvCtvA0giyXD2zT34xn+JRWYXm/WKRBO4Gasga6vy5CYD2TW6c7s3GN69r29DKwvJWlFHM/qLp8b3fVcsyxOcTMrQdLcvjHzPo8NHJV7yMvYMlaPY51Wr26oXSTLIkTnujSIA/AGAwORqvnj6/KXdPv/N+YBcyE9pd+7CiFXXyHIGkWAz2B9b6ABf/Qjm10PO8+vV0j0LJcndWE2/l/WRQT7iDQ0r3JSxoxECdOnqacYVzGH3u9a8xtTZdHfoHVNkS7YBoO0UmqvCds8A3IytKCXmClHsw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b550fd8-b8df-4179-f023-08d858ca96d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:24:01.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCLp2MyblmVteqrBIHWjS99pH+vWHz+IJUhMM1AhuLq4N09FmJdtI1PpJjuP5uYw1dZhv3kvMnLqtqt5S/E2nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4046
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/9/2020 1:10 AM, Herbert Xu wrote:
> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geantă wrote:
>>
>>> Just go with the get_unaligned unconditionally.
>>
>> Won't this lead to sub-optimal code for ARMv7
>> in case the IV is aligned?
> 
> If this should be optimised in ARMv7 then that should be done
> in get_unaligned itself and not open-coded.
> 
I am not sure what's wrong with avoiding using the unaligned accessors
in case data is aligned.

Documentation/core-api/unaligned-memory-access.rst clearly states:
These macros work for memory accesses of any length (not just 32 bits as
in the examples above). Be aware that when compared to standard access of
aligned memory, using these macros to access unaligned memory can be costly in
terms of performance.

So IMO it makes sense to use get_unaligned() only when needed.
There are several cases of users doing this, e.g. siphash.

Thanks,
Horia
