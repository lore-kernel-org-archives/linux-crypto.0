Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B747C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 17:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A2E221D1A
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 17:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="bNVDaxYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgINRMf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 13:12:35 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:39006
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbgINRMW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 13:12:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g79RKX/IGLkC3Ym/9GmhEx96UeZAZwA/kn4SuHHcowzXtyNBFIsWtAE2xhxY5hOR6xJE5WY2ohzIpQjGyhhUjhNnIMswm8fI0trKVlUTaj8j+oEUyz9DHnL3LuBqlu/xA8Ah5u73LFxH8cwR6a7/ZrfteaMm06vAiTStDY+JHFP0EFXik58mPLgPSC8gSV30kNtAuwyI0PA9OYxnuW1I1PBQUVOJhyUzg9qmG0jAggPQFM9OqJsoZfs4Be+ZGSSAcTUT6Z+G7cQG+B7r/LJhEw4KnvtdR1d1+HcvJDeFD168wV3OKbz6AWww5S18Vk3DLb5Aos5GCGf3u1JBHheWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lEMaqZPAGmfUmG53kQ2EAfcxgjdj7Bo38ItSZvEgZA=;
 b=RDezNg4WSzmJ+7SRQF8DIHFjx85ZIpJEzyRCoJBMzehUJOtBc8NDGbzuI9W3jEv8OB9U1VvDdTvo0kGie/Y9WKo9X6Jv+smR70jvFLcHGhJnOUi5Q/tHbfsCPhDSM2UIL2krVrSCf5U73PQBFqnfHN8rwiwGxTh4k1qof5Pa0pwfno845n2BN3hLE2TnNDxikEqmugewiRfzHh1XwHRFgsNuY4GGdszuKdsJFzfMTWqhGtJqwtE2UwOs4PiROYKP5XBzofj/LIOrr+wVGjWt9Y81K0q3tLXKCSDIyH6DPZExz/6QzZp6eNKjKEsx1KQ0ibsNBAQnoaQmKCqeFYGXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lEMaqZPAGmfUmG53kQ2EAfcxgjdj7Bo38ItSZvEgZA=;
 b=bNVDaxYOP3DSkLe6eHyQk7t3+IL/dRnGO+aYpeIyEiod3xvPBngVWYkTv17J/LND2rtHg/exWsfEwcMyVDjHzZS+AEKId9WR4uL2ycom2PzdiBiejFfSMvKxslfraDIpVn+9l03MpGLSJv6r+ALeTGvFpvvyaP7t/F+H+G9vaXo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4047.eurprd04.prod.outlook.com (2603:10a6:803:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 17:12:17 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 17:12:17 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
 <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com>
 <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com>
 <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com>
Date:   Mon, 14 Sep 2020 20:12:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 17:12:16 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9860642-231e-407d-99ae-08d858d1553a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB404759822DDA4197F0722C1E98230@VI1PR04MB4047.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CPxR1hqQFG5KPQZWLLjzheieMGgeIisxN4n/+wb5Cz6T/VFM9/w++KCef+OA95kpyzcxtMaUlLQ2dBAvJp4AJWiWV5fYU1YIVtLxgOFea2iQGoh3GUG4A5Sk0Mg1hyi/euy77jkZ+qJQJ/cOYk9iTfCZgGllSXhnyaj68lb3kmK5GOegLT9/f6HG7HKMMFj2RsOBzkivLs8xy/riYj4kwjlAz/B1cRnL0teE2Fk8p5ykej2mOym4kKSVL7sF1NPkJZQFqozeeQvOkRW6R1toj+ykUhSGXIixJVomw/Lx4+zy72smAmdEVCD6XDbnweDIk6XXTdrHau3xPz3avbedn++BxVkJ76um1ZrwJXqCYDKA6LKJTs7qGWrLlBtm40Zk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(31696002)(4326008)(16576012)(52116002)(26005)(66476007)(66556008)(86362001)(53546011)(66946007)(83380400001)(54906003)(956004)(5660300002)(2616005)(6486002)(478600001)(186003)(16526019)(8676002)(6916009)(8936002)(316002)(36756003)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cF7IHlGBwd/Yc2TeiHRHti3q85kp1oxGHTG+CesXv2dCTm2dgVZAtgorm1mrcOfoIoUKe629lTY47muUTNqPHfCf/fSb45RIxUpKOT0qutDoDUcYq6rEk1dMz39k8COWEbzD5KuC9wE/uqhnmo32egk0//ue2N83CUZaLrtIG3iFO2ZQvig9jQBTPlQ40qlL52KYqbAF1NBhGRZ/WCQbLCYwHPmvRbvmH+AZwOt5uN0GXWR+lrtgEAkl0HGWQz+qNroV2N9f3dwhBe2aHxOXGEWUr1krzcssRFbvq9VqRdbXTyKXS8APR9SUUosyvQ4Hwp20kPryNLTVeF68BGNfehXWOpm0x4YB507DMCDEnwN+Ofz+vC1oauWwcUQZ8Oq8gTHXCIhKpeR5R4pHGicD3hcKN1ztu6wdk2h7irGj79rkYCItjFtzDRffI2Jf2qwSFnhfKFkpVF9HnYmsxNsvitLaDdh3eti2vqAUsmvkkae9fqGK91xndDrkLnN+0wjtr5FoRaJjr2W3RlQtX19bOzRfzcX+mM2JKZYxGple1onJOIBkUWeRw3LYdt8PLZVsKy/rknWFPPOUvO5II3ER3L2jSauIP5I0+I0zu77EMQkFzE6fdd/p6dGvzsWzAzyDI00/ud/cKprFzGdXAtuJDw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9860642-231e-407d-99ae-08d858d1553a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 17:12:17.5877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAQ0T3thXMUC77FsVJdVhd4xCCGjh4xohxCRVqZ8asTk+Pf3KGdWoIyCnhDCSKL9kan8KsEPIqNCBOfz+09/6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4047
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
> On Mon, 14 Sep 2020 at 19:24, Horia Geantă <horia.geanta@nxp.com> wrote:
>>
>> On 9/9/2020 1:10 AM, Herbert Xu wrote:
>>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geantă wrote:
>>>>
>>>>> Just go with the get_unaligned unconditionally.
>>>>
>>>> Won't this lead to sub-optimal code for ARMv7
>>>> in case the IV is aligned?
>>>
>>> If this should be optimised in ARMv7 then that should be done
>>> in get_unaligned itself and not open-coded.
>>>
>> I am not sure what's wrong with avoiding using the unaligned accessors
>> in case data is aligned.
>>
>> Documentation/core-api/unaligned-memory-access.rst clearly states:
>> These macros work for memory accesses of any length (not just 32 bits as
>> in the examples above). Be aware that when compared to standard access of
>> aligned memory, using these macros to access unaligned memory can be costly in
>> terms of performance.
>>
>> So IMO it makes sense to use get_unaligned() only when needed.
>> There are several cases of users doing this, e.g. siphash.
>>
> 
> For ARMv7 code, using the unaligned accessors unconditionally is fine,
> and it will not affect performance.
> 
> In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
> you can use the unaligned accessors. If it is not, it helps to have
> different code paths.
> 
arch/arm/include/asm/unaligned.h doesn't make use of
linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
is set.

I understand the comment in the file, however using get_unaligned()
unconditionally takes away the opportunity to generate optimized code
(using ldrd/ldm) when data is aligned.

> This is a bit murky, and through the years, the interpretation of
> unaligned-memory-access.rst has shifted a bit, but in this case, it
> makes no sense to make the distinction.
> 

Thanks,
Horia
