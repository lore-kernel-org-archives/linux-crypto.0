Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F342CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87962067D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aZkIh2j+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgGHQYP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:24:15 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:59457
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730116AbgGHQYO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 12:24:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFB7R0UTy4Y/iN5wbhvOxoEDwlgWcieEWaLA0KUFUF98/jeNc6rqGhioWZ7/l7VkIEVLkXxSTvMJ9BoJJKugK2PkLJLcwmDbL+Bfk8DskNwhfSVc6mIBoflnITIkkXM32NPqudaWT08IIf0GBnbWOE6sQd+gvD3pAtO14lsoH/UlIeTv/VfGnmixI5aw3FKgO25BvN8az3Pfs/qaUvq/gPVptPsWYF2wCfsMUGgRsEvJm50RW6YJHzStxjOttwvC9th7+OrskUgI9GJdTXkbinzFKjmQpjw1o4TJPNzWjhIWCzOYrdJEHACHbUbgna38q8DMc70go8fFXUktmbCcPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvH5WI5tgEFiW4JZGQUNFd0+UTDnZkfX+/Y5Q+D8nT4=;
 b=BRRK9MOdd4HkdmI5Dgp3oNhUW0AlamYgqLbeHagjSTkPje+OhbAd6IUc0JQWHQaDoI5zM8leXDVp8Y59Gsi+UeO47eaXMKot7WEyT4R/FbQ5a7kyn8LbICjpdRpJiyPDSkeD1cqdt2b0cFlXRn/PPR4+TkxCJOS9usk7Oy5UZ3yAH4IMGFBMBROrUcxnKiJiRVYs1yNssgfZDIuqlQ41j2TkWQkbvqzUzdLkKF0TwO7hAUrk4kjp/0IAOMP6Kr4W+fKQWTwbSeNnRJO4schwhjfWZVrJTM+8I8gmaB+dv/tkT1Xofd3m2BjtRubcEF6t03ts3LZOFMvhnWVFrbcdhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvH5WI5tgEFiW4JZGQUNFd0+UTDnZkfX+/Y5Q+D8nT4=;
 b=aZkIh2j+jMf2bKK31ArJNtGYWIgiL3DxsBtnT+FL1fbe+5y7w8VyET2NCGL4c2F2n1ZDoDZLCLKqy80UNKEpuKiMCMcMpWeZ6Rl0NvD6eiygPwk9IvTdAPFVfOq16DAth5Naq28wMnGGavCtbJn8DuHlTH4QfEV57K8sTpOO+Uw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7181.eurprd04.prod.outlook.com (2603:10a6:800:12a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 8 Jul
 2020 16:24:11 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 16:24:11 +0000
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20200702043648.GA21823@gondor.apana.org.au>
 <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
 <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <8e974767-7aa6-c644-8562-445a90206f47@nxp.com>
Date:   Wed, 8 Jul 2020 19:24:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0088.eurprd03.prod.outlook.com (2603:10a6:208:69::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Wed, 8 Jul 2020 16:24:09 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e73bc66-e423-4c86-496a-08d8235b5874
X-MS-TrafficTypeDiagnostic: VI1PR04MB7181:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7181E7D1E550181101A4024198670@VI1PR04MB7181.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DH+31wIWXx/XyAua4P10UH2xu/Xb6E9YLPLZQEFUPnBeophQsberbX1YaunwKGYzwTfYDcB0Q9QP20moDPqsir3nP1/cWupeeh4WMdNBMDyvqg4/sJLi3d8VuuC6BD3ebSzOngF4qko7Qjl/TXSpYC/ThKSabMAtEnqqsiQScaeaizGNP3vL/Q9VusTg1ivjnV0MKEx0o+XkHG6MIxP//7/5ijb5ALY94VGcP+1F35BEOhcCRr9SMrrDKu195/BH/K+gcSzqL9Av2LPD9Ltcfkd0GWyL9TyEvfzZ5ptN5nxqUmmwVCjkhQ0DDEeZziontLF2qTlZNHZ8rJRvL4N7wuJcmKh9WUQZ7+jy+r1pkLZca0IJLja6HsJy/f2FI2XAU+sT7paWCwyoG1fbC/C2o1TEy2Pb/7U1MxHWr+npqQqyNhlO8cmAHm8BO5mEDk7TjFEc+qQeoPbLzPBseq0Ofw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(54906003)(8936002)(186003)(16526019)(26005)(4326008)(53546011)(2616005)(956004)(8676002)(5660300002)(52116002)(66946007)(2906002)(83380400001)(966005)(31686004)(66556008)(66476007)(6916009)(316002)(16576012)(478600001)(6486002)(31696002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N/4/AhJzyt4EiX97hO0+sIQQ6ToA+3Ss4bC0mfTuaYcDn9ciZvOnzWVND+1HTXHUkNljsyKbfgkGIyx1VcAHicynE7+Qw+u4IEFjJK4qzh0SDVhgniBnEaCF7kYCQCI0a0aL0+WYRfcDoJZ7Im9ZZSwlXviRJr2l0ltZ4ozextPDhOSS6bnQuAuI+pJ0h3Xbpk0r9+f5ZGgcH2XY1qasYBNsvT95jOATHOlEpPTtybxjF0MRA18zmpQN8rM9PH8acOFnrRkZHCFRFq7xiCn6r2tTR58XzW1v3kw+FCQg5GMIESjNjF+CQzGItKgDfwm8+TDfoCvtNCA2uStlUKCGuxa9L17hl0xAqKCKLMqUkpi0nFSS3MzSf9QwiIJBvfxB1qxvbP+wl707UEZseHtCzyq7HfV51I6p4+/whEkBrgY7flLc4FgQEsS9dXVFX2/fToISGFVnlzcSspDrOVlXHBUn9VVYe4x88kKBNLtZu2GuyTtdZJjnoJztUtGVujuU
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e73bc66-e423-4c86-496a-08d8235b5874
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 16:24:11.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WH61skp0t/6S5XCiyRXiqg3p72ol3vD+1ZCbuYvKrjOI1AND3iKuN7WjTmqr3dk/3zIUMn9d+9q9egi8QoGupg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7181
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/6/2020 4:43 PM, Ard Biesheuvel wrote:
> On Sun, 5 Jul 2020 at 22:11, Horia Geantă <horia.geanta@nxp.com> wrote:
>>
>> On 7/2/2020 7:36 AM, Herbert Xu wrote:
>>> The arc4 algorithm requires storing state in the request context
>>> in order to allow more than one encrypt/decrypt operation.  As this
>>> driver does not seem to do that, it means that using it for more
>>> than one operation is broken.
>>>
>> The fact that smth. is broken doesn't necessarily means it has to be removed.
>>
>> Looking at the HW capabilities, I am sure the implementation could be
>> modified to save/restore the internal state to/from the request context.
>>
>> Anyhow I would like to know if only the correctness is being debated,
>> or this patch should be dealt with in the larger context of
>> removing crypto API based ecb(arc4) altogether:
>> [RFC PATCH 0/7] crypto: get rid of ecb(arc4)
>> https://lore.kernel.org/linux-crypto/20200702101947.682-1-ardb@kernel.org/
>>
> 
> The problem with 'fixing' ecb(arc4) is that it will make it less
> secure than it already is. For instance, imagine two peers using the
> generic ecb(arc4) implementation, and using a pair of skcipher TFMs to
> en/decrypt the communication between them, similar to how the WEP code
> works today. if we 'fix' the implementation, every request will be
> served from the same initial state (including the key), and therefore
> reuse the same keystream, resulting in catastrophic failure. (Of
> course, the code should set a different key for each request anyway,
> but failure to do so does not result in the same security fail with
> the current implementation)
> 
> So the problem is really that the lack of a key vs IV distinction in
> ARC4 means that it does not fit the skcipher model cleanly, and
> issuing more than a single request without an intermediate setkey()
> operation should be forbidden in any case.
> 
> The reason I suggested removing it is that we really have no use for
> it in the kernel, and the only known af_alg users are dubious as well,
> and so we'd be much better off simply getting rid of ecb(arc4)
> entirely, not because any of the implementations are flawed, but
> simply because I don't think we should waste more time on it in
> general.
> 
Thanks Ard.
My understanding was along these lines, just wanted to make sure.

I think the commit message should be updated to reflect this logic:
indeed, caam's implementation of ecb(arc4) is broken,
but instead of fixing it, crypto API-based ecb(arc4)
is removed completely from the kernel (hence from caam driver)
due to skcipher limitations in terms of handling the keystream.

Horia
