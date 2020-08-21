Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB838C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 12:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77175207BB
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 12:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kT1kvRRA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgHUMC6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:02:58 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:1090
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbgHUMC4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 08:02:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyd8bbkkOWHMUnqM8r4cdNbqfzQkX6FSbudoyIGa9fu/SvGJEy9nz7EFo0Qj72eIjxpHGPq0LqdidfXGe6l7ZFxyTetF5twyF7U4w7w5c/Bgqqeh+PRxD86l6WfVhjonSYOxBYNc/YoYDAS9rhAnZqt+B35THp0HbZI4SwphBdnTUgiE/J33U4lawjTE+OL4VtDOgMldQ/p/QUvcuYdYSFXPMEcrzLs4viWldgE6V/0HYBXHo/fcpsjILdpahoU1HHmPy9tVH54yoYL4E6KtdZ7hxK2oIgpQkaPDhP+GjRwLx30IJA3ETIxc9MnsRQzqEFUGTkTQwshyFtPG1R9lEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC0vpuNd86RqIQfZ8Hi2VgwtKfzIqsAgIqlD0d8l0X0=;
 b=biL8aSvX/llXoomj4D7sQ2W1p5uPbHNmnTH331dTDMPZp/ACBcUP5hrPb/dtROxtRKjQ5KP6OMXTv5NsuaWbI6dQ4f9mEnAL2CH2lNvVjSErGa9q5KXNYYtbkhVzTFLB2x1oAQvIVNbIXpNRgoKre05uFT40k8TvywYJG99UeymRe17RkzGG7Gu0U75t5LiiI+ohYghuLjuywOyRZ98TQin6kGABw0DP9q3putKNlFo1UtG/hvEM9PcOm+xTHJl539vAshRkSo45UIz3n+Z1emz4f1ZEbzXzzXzYLAqF3xo0e/o9O+vLB1/omevCtpVFQTGbJznevajfNSRunDM3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC0vpuNd86RqIQfZ8Hi2VgwtKfzIqsAgIqlD0d8l0X0=;
 b=kT1kvRRAiSBzGfuUZprO1GXzuO4MyeeeSS8qUbvlOPT9Mu3d003+x19Lsdo9wNGeGUiPXG9/7GDMsHg+WeSQ6G1h5tg4BI5l3pbgLUnVTGdzcWU2+1I3RbPoZ8mMzVhy8LGzkIK72rmdzrkXJDJkAwRZv8MWmi4olohsz90m7bw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5582.eurprd04.prod.outlook.com (2603:10a6:803:ca::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Fri, 21 Aug
 2020 12:02:51 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 12:02:51 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
 <fe251307-ba89-a4bc-23f5-205a1e1343ea@nxp.com>
 <20200821034741.GB25442@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <7fcc8361-7928-3e56-686b-9382bef9107e@nxp.com>
Date:   Fri, 21 Aug 2020 15:02:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200821034741.GB25442@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0082.eurprd03.prod.outlook.com
 (2603:10a6:208:69::23) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0082.eurprd03.prod.outlook.com (2603:10a6:208:69::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 12:02:50 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64f85e25-9f8d-400b-f0f1-08d845ca2128
X-MS-TrafficTypeDiagnostic: VI1PR04MB5582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5582428BF8F422272F501C88985B0@VI1PR04MB5582.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEcMcJ5TNHiRt8kAy+MLJqmcApFs3yWtVagkJyVGsfDr1w1YO5ShMD0BIzSSAqGsltZvV/c8xPznOSX8dQn/fvF0ca4xv1ucxW2d4wC5TlSyUxR8rnTyaUA9kIPGuDkQy2CU+88bJlpMK6TPDlEJZ7cOiNknp2ZQsgQ02pG2JlmdEnmHevLDv3qc57oFVZbcX3JCNeVrzyl3cQ/2EF0mRsZslmVNXKr2xl1HrayGAb23e+Bex7uuG9/zKkn4cRtNbEED6qM4eaSojZSFXPx2UP4jtFqvRtRp7uHg1aYay6D+rCdCKxJkAHieQJ4Ih3hq8G3Su/fVfX6OxcFl8As/m/6/2+1rGyeo9EUC43hbl3CpJ7jq2dEplmKdCeGRVyMs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(4744005)(66476007)(66556008)(36756003)(2616005)(8936002)(6916009)(16526019)(52116002)(186003)(8676002)(956004)(2906002)(53546011)(6486002)(26005)(5660300002)(83380400001)(316002)(31686004)(31696002)(66946007)(86362001)(16576012)(478600001)(54906003)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dSyDSshUV1sGs0ppzPfouKLadGm5Da221v/JMlkm5nCuLHJcyDV55qoIIRfVqrlbuYewNbZTyaHYkg64i7D7zSldQdubNksjBM/hzqCt+cxDv+vM8Rvbvxds6iux7e1lWCeFwH+w6LmKZxluma4rYzH2cBxWfVNcQ7XbqXsGmvjvrLN9VL4STmPLApXr3xUkcy+Xp87dcnFKzCidgVNxCRFxMQr5OKUB4Em8RXVy9KyFK0lW3K0HPFap4c08G9RQ4shy1tKWYWpTx6g4KjtBXif3E47d4BfuN3wl2ncuqB/WupqgqWHKLqopryN6oco/MyNkmUTF+LDwXUHful4wMUPrpujkf/sEOUo+UQyygms7KZZLuFT1y0Vmww3Ui+fwQA0iHYZkh0XZgbsGmq50bcMWth2VcomDQYyu0AadBOeTuSngVtvj/BQJl9XWX1XK4ySoQCGiPbWnjGVKvFnWLQsjgkMgC94Fb60hxbMjhMudLi99gAfwlENRhHDnPyqB5lpvOPFEWALzzqXCFyu9Plm9k+LK8pRBEjIA4tChBl9W1uNbA1LCF5fU8xZCWDjpRP8Q9cXBRY09RUhH6T674CNtyeGuBCymMbkE0DqBidiK3sSsVmh9cwBqbdAUu57DvOmWLBYX6Q9iOjJSuoKVcw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f85e25-9f8d-400b-f0f1-08d845ca2128
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 12:02:51.7575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mj+N+xiQIQLEQK7FOjSEoeH0Gy7jJ8sBtWYBNdQhywYsr7ynY0OvMii6lemBnMciPD3vc1Vu4xpNSXFMTHIjLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/21/2020 6:47 AM, Herbert Xu wrote:
> On Tue, Aug 11, 2020 at 05:30:41PM +0300, Horia Geantă wrote:
>>
>>> +		if (IS_ERR(fallback)) {
>>> +			pr_err("Failed to allocate %s fallback: %ld\n",
>>> +			       tfm_name, PTR_ERR(fallback));
>>> +			return PTR_ERR(fallback);
>> Shouldn't error out so early. It might be that the fallback won't be needed.
>> Let's postpone this until we're sure fallback is required.
> 
> Why? The generic should always be there as otherwise you won't
> even pass the self-test.  If we're OOM then we should error out
> ASAP.
> 
self-tests don't check the cases where a fallback is needed,
so in theory things could go well for a misconfigured kernel
(where a fallback is not available).

But I agree, if driver is updated to select CRYPTO_XTS
then it's probably better to return an error here.

Thanks,
Horia
