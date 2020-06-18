Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B04AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 13:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B4992073E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 13:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rchpbBYb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgFRNQo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:16:44 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:6083
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728632AbgFRNQh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 09:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/1+f1MMQtUbdhw2g7J/Ba/QGpgleer0e/7x7ElX1xljT1brC+6pzbHqKyRB7/jacNOjOAitXYvN8vMnChYT6FtiYdW5KjWDpem6EI+SzLoPHjQZETdwVEjFF+pVRaJJnZGw9vesCbU/KqvDdJZ5dzh3mZAi+x9aqPZF8yVOd0Uesgq4btCeGKAOc1MDnUf2lhWU7x/7vMyxHRpn+Wx2GkUsKNpdVXxkt7zd29xAIVGX8zvSy0aFZZipuRukNe3wICX45mEgatLOdmnPnejvWtN4B1E+w2OUPSUWMGd/wsJHWKsqaTdu9E49LmcEkydrCuKNRB7Dg3plObBHkWqxhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLIVCobv+W2l/D5MH6wzp50yQZ2+ZqMd6zZCmLl5Jlo=;
 b=bqRxfyTSiEnZQDhP9WbXoXIQAw8cHLZmezOxQO4deJ1pyeKoCEKdyKop/t/CI4cp4cIf3CDWj87kjP8v4r1n7LFUQu7YjWTpo+icydBtG3wU76qqkQvxUVBkACBhAFrx58ghBZxpnFKGYTIgiq/xUheWqD7Vuu7VumQURkkXygNWUolJuceKADKXGAkxa6XD+CN9dJgi48X2570kVfC1LfeXK6v1x/HOXLxrP2X2sgDIXirYMbWiFH3TauC9GveENUgqMhuhs1wMBe35cWc6iT+6kVm/PlDOhuwvwDPemTmr0SQwQcM8k0fmx8v4g18psr+Bt2gsDnU9Nk/QfgGjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLIVCobv+W2l/D5MH6wzp50yQZ2+ZqMd6zZCmLl5Jlo=;
 b=rchpbBYbYkcHz8j1rtcmPVssA00tr6moAJ5leFF6I2Ot5zpGIS65WAhaDzwPFVDNQ2iWohZZPsKqNBsXqgkoeyU7p1d/t75/foOKeuJ5Q2UzKejLc5xAIgrFY5PesYr+nMAqa5Jl5CtaCvutxvsG4ut7IvhByOUq5h3QLdOmRPI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7040.eurprd04.prod.outlook.com (2603:10a6:800:121::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 13:16:33 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 13:16:33 +0000
Subject: Re: [PATCH] crypto: caam/qi2: remove redundant assignment to ret
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Colin King <colin.king@canonical.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200611153934.928021-1-colin.king@canonical.com>
 <8e08adcb-ef91-124d-d093-921fc97da3af@nxp.com>
 <20200618110050.GA10995@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <b351f9b5-940c-61d3-38f2-3654c6da55b0@nxp.com>
Date:   Thu, 18 Jun 2020 16:16:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200618110050.GA10995@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::19) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Thu, 18 Jun 2020 13:16:31 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22df849f-a429-4a54-75fc-08d81389d206
X-MS-TrafficTypeDiagnostic: VI1PR04MB7040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7040263ED365BF74AB21979A989B0@VI1PR04MB7040.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/jwljeUU5gpiI4hgSV0ERaw3ACayJvfYFl21jfl+ncxqu0yZ2fY2WwTb71hBfF7LXhRU5xdC9Oh0Z9bAK3+Yn6TtdUZeOz52jkp6YhFLjotVeI+mxAM5jjGyEBG3LhIIa8fKwWOY7n2Pr2/xZnEYg6ZIzxvVjT1lf6E6JjHUreK7JbJTTU6SMAGKW1+on4aM8iy6gIuOtGCdxOkTQpZdscgdjT+ndWTCRmvuw/O0uQYb1qPUvvH9DbRnfUjBLn7yZEoCXR5X0WzZJy7l6B12X0EIyu5K5XXRVqphTrcAkQBz71KAswWtqmbc8kcxsFRdv9T7+IqW3F/00DGpbnDMPJdhrpSAmMv2M0lJ9yNxahCC2RxVdOSSjFBeod/dV+V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(66946007)(66476007)(66556008)(52116002)(26005)(186003)(16526019)(54906003)(316002)(16576012)(956004)(2616005)(86362001)(31686004)(53546011)(31696002)(8936002)(36756003)(4744005)(6486002)(8676002)(5660300002)(2906002)(4326008)(6916009)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VafZBJHnCWXzvotJaKGxdRQilRTRVUdBpwYhkwr4QLnKDHbtAPvkgTYCPiqdZ4rVSTDLhi6Z8cpdHmfnu7iXQSp5EzbiVubgCmD/b9+gh+9KUYYO3ITWLwkxIimY7hctQYSuCB5o+q8SCMMszxO+jMr2OcpHT645+ThgqB5NVemQpKaUVHPKJVl2G6qqlVLjsoqoKDBOk2S7lTXa1bZhxcKBccq6kcX7Wkqq0NiL8kfxfIHnCBIuYU4YEtwvPNlCmicZSdNmeT48fpi2adHVKeGHtQC1UIEit02SenVlxaIJZvM3n1wCls0J1LcR5MuVM4Qa63qfPX3Ah1mPU7nAMTB/A18ZyxY0pvoqQWY99FU2HQSKx+cYP+s+t0o5A70wrpIPELfMEomwsghie9bhF5hQoq2tAKpP9uMdM1+MHojHLv9gc6d67vtKuwnnVIuI11SYFxWr+XYrb+vcdGOyU6MGTOCHYSrEMiZOxCBFZJub8FvA67CU+6zQAw2Y6cHB
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22df849f-a429-4a54-75fc-08d81389d206
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 13:16:33.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KA34An8/6vT1n/5ZJ7/Sg/PLXc8ve7sVqJVUri+XCpvYWSt4yDav5f7f8KhmCwll7UzZjWeUskv6OFRwScd8ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7040
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/18/2020 2:00 PM, Herbert Xu wrote:
> On Thu, Jun 18, 2020 at 01:54:55PM +0300, Horia Geantă wrote:
>>
>> The proper fix would be updating the ahash_finup_no_ctx() function
>> to return the specific error code:
>> 	return ret;
>> instead of returning -ENOMEM for all error cases.
>>
>> For example error code returned by dpaa2_caam_enqueue()
>> should be returned instead of -ENOMEM.
> 
> You can do that as a follow-up.  The patch is correct as is.
> 
Just that the follow-up implies adding all the code back.

Anyway, not a big deal...

Thanks,
Horia
