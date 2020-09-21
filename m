Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C5CC43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3015C20EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CiTmlM1t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIULX7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:23:59 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:4449
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726367AbgIULX7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 07:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARWP+sxJSB/ed6wVBQ+El/Zu4m+uVuS9z5nHmFCJmt+Yo8NDUKRnkMMSxf6pCpDpnufDRjk5ifLzTsQb4sl9g13da/Tcy+HrB8HWMDkZWpQoByUkHBGnT9EoNfm5unf8rmN/oy31/Bj58CiutLRXtEqyJUoHWQanpKjQmdk1xXCzV+RMokW2SyCdeNHwoncuwEbqr6hc0bpBo/Dth9vG4LG7S7MFS55qj+VJs6ItobtBdA2kclFI3rIdIjyrpeqNs+RCuhT7p+ofPae+rrVj/tgOiFFoCZQg6A6wtGaWFEW8gycYtQwc5vnOFxwF1iDg9PWU1aIsLjpR5vdoXuwcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ea+8kfIUXYm2lXfTXVsPiuZNjSW8/2eBFaVMOgyZw38=;
 b=Nyt70g2BtYmmuwAPn8eXLLQMBfcmBY6dHta7Rr8Dt6hn7OCfRUI76yf7k8pz9qwcCb3VoL0Jgh35y8RPsXUjAe1T6icLzbAo16H5+kHWjLcZHK48ZvSux1R6ANei8ORzfFiR5eAjD5lq9cqnolKdD4tTeUoV8RGJcUrBmkZ6L/OfM844hSsUxzzG3/O22KhMNIRCce4fE+8trrK7fDaaTRhlzA2lDUGLelpM6qM5cY+V+cSxf+Tqar8GPyjzs8uGhx3f4fLs5Wv7R4izAdT/3HT1Zm2TeAOWfbR0q/pfu4wqFO9lFAJgcu52+q++yPxIvZpbzc7N+6jGdMMbt2+EpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ea+8kfIUXYm2lXfTXVsPiuZNjSW8/2eBFaVMOgyZw38=;
 b=CiTmlM1t+EUyZ5GugMjgiOp55SCt8Aq/tuBORuUBcxcJMfi9hfX9eT/1yS8Cah/YtedvsyI2aKpqiYBh2N1ImO99BKAKYWgaZvsv2YpBGyV3s1LlPUv7fpKH8/tPX97ffeEauuN+iYxpiFYLd0oVs4f5AjTd01sDX6i2vtoL3Xs=
Authentication-Results: sigma-star.at; dkim=none (message not signed)
 header.d=none;sigma-star.at; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB3583.eurprd04.prod.outlook.com (2603:10a6:803:e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 11:23:55 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3391.026; Mon, 21 Sep 2020
 11:23:55 +0000
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
To:     Richard Weinberger <richard@nod.at>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        davem <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, david <david@sigma-star.at>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
 <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com>
 <CAFLxGvw4zvL0N5+wChKq3=_xLuuCYLKDOyKKnKFy3UiWMUwf-g@mail.gmail.com>
 <ffc5254a-cecb-20b8-fca3-d2cd8486362d@nxp.com>
 <881550786.93213.1600206653402.JavaMail.zimbra@nod.at>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <5acc982d-77b0-3141-2689-d35cc24e36fd@nxp.com>
Date:   Mon, 21 Sep 2020 14:23:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <881550786.93213.1600206653402.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0139.eurprd04.prod.outlook.com
 (2603:10a6:208:55::44) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:208:55::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15 via Frontend Transport; Mon, 21 Sep 2020 11:23:53 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbc0e844-3caa-40ac-785f-08d85e20d337
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35832AF717F1DE7226B16710983A0@VI1PR0402MB3583.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ing/TPKMBLy0jNcs7HtqPyAG9ao9qnzLzHoUgvwTnwHnQu4TzGT7AE9fa+zHG8f0lQidMhWhOeGxsqf20G1MPulQ8j4t3E98lzscZBE6tK3u5TPHzfk5jTHkaIxdlSBjrA+DtF55PvpJXivuRMZ3uhijle5MA64UxdrYlRoejqb3BSE2ropKI/PiFCEgV6OXn77RklFykbRcqoHvzB+U7MBCaRnpA5KGpFwOBlldl4sslDYnqAMWMkc8nWC+KsHtmAdtIXZX7myznd6I1oyVSOCYti18Cad9yg4t6D+AQJaJKEVyN30HV6W+MgCZQ/TQBmlwgzRSaLWL1Kx1c9/E26EEVO96Szz2PPVG52Pa9FB9FUB+jZGgVtbjex9fFeJHrVuRLOznwmyXI1Dt38FEV/fEPT1tPv3Z5hcWIrCDtnPN1F7yvkEMWT67JfNBY4zU2xg1eujx64SbDob24yEBZEkmeKZou+KyuxL6t/weP47V7aKZm8Dxg8/Rubf2BfWG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(86362001)(966005)(8936002)(16576012)(316002)(36756003)(54906003)(6916009)(8676002)(31686004)(956004)(2616005)(66476007)(66556008)(6486002)(478600001)(31696002)(66946007)(2906002)(4326008)(83380400001)(16526019)(186003)(5660300002)(52116002)(53546011)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xW1TSYCOKqPCjyS2fgmtH2lIFcxt6ySf652NSSHdIoTqVD7RC0V0Uyvw3AqKORSdckbBcgVpJI37ylcPvTv+yQwM0xvveWa+R18JwR6spKgHACggJjC6w58oVe4k+YU04qPq61UEMRU5ZHgWC82oHq3eV0Ckl5LjWqyLsyoENK9Si9zf5PN1qn+Fbs0PMekwXzVtGg8XwCq1MD8vSJLN3UYZr9KYnCKVCr9w7M4vfbItEwZoEl0vEU0V2Mw15+nBq9k1tHxAWgzfSyT9EYG3pXtWYEUYsHAjK6p5E1J0k6+TTNHvQ0WrwU+CZjHbr+HL/eueW1HiwVIcE/S27sea1Dnxmf8nJQDK+DplWZez/NO8ASJnpoBFOpuggjaIQLmD3cEIpp/GwriBpXcU2edhB/AYAR7CYTqFk0arQfjNsOju6bXdzqW68vSh3HxWLBgOtdphQhZHphFb9HQfOY6hQUZxuUB6DYNb1L8QkwuCQkDbK6fdhW49u6Gj3nxerIdNs15yanRhiQlZFv/akMbEHldkasfwo2/Rp6/W5MYVq2ZK0QGl2k9SJ4ki+fmXdVB3aA4V2i7IzAHQVu+S0yDFK8zOYzrjosl77WCVmcokH58uCJ6qJnwCaF6HHo/UJdgaHTLXeKx5rn7NN5yQ0kVj+w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc0e844-3caa-40ac-785f-08d85e20d337
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 11:23:55.0306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMTofwAheBi19oj46ZzCqSbYiLxkXAfPLaC6Io2E9Fr6E8MoPHWvKwFoxcbMxa+E97/AMEI27ktrNe74YV8TsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/16/2020 12:50 AM, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "horia geanta" <horia.geanta@nxp.com>
>>>> How to use it with cryptsetup?
>>>> I'm asking because it is not clear to me why you are not implementing
>>>> a new kernel key type (KEYS subsystem)
>>>> to utilize tagged keys.
>>>> Many tools already support the keyctl userspace interface (cryptsetup,
>>>> fscrypt, ...).
>>>
>>> *friendly ping*
>>>
>> We didn't include the key management part in this series,
>> just the crypto API support for algorithms with protected keys,
>> to get early feedback.
>>
>> Wrt. key management:
>> The NXP vendor / downstream kernel (to be included in i.MX BSP Q3 release)
>> will have support for protected keys generation.
>> Besides this, a dedicated ioctl-based interface will allow userspace to
>> generate and export these keys. After this, user can use standard keyctl
>> to add a key (as user / logon type) in the keyring, such that it would be
>> available to dm-crypt.
>>
>> We know that adding new ioctls is frowned upon, so before trying to upstream
>> the ioctl-based solution the plan is checking the feasibility of
>> extending keyctl as David Howells suggested:
>> https://lore.kernel.org/lkml/8060.1533226481@warthog.procyon.org.uk
>> (Note the difference b/w adding new key type - which was rejected -
>> and a key "subtype extension".)
> 
> We have also a keyctl based patch series which should go upstream.
> Since we also added a new keytype, it got rejected so far.
> 
Could you please point me to the discussion?

> Do you have git repo with the WIP patches available?
> Not that we do the work twice. :-)
Unfortunately we haven't developed any code yet.

> Our patch series also supports DCP beside of CAAM.
> 
By looking at the DCP capabilities, I assume the OTP key that is copied
in the key RAM at boot time is used as KEK.

If you don't mind sharing, I could review the code.

Thanks,
Horia
