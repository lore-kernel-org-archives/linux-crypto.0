Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68302C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358C222447
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="H/v47GA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGNMYW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:24:22 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:24146
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgGNMYW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 08:24:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfs2FL70lzL1IeVRSLKd38mteWpKhu44VNPn0Haj4imzi/nkih1tUuypNsHTwG2v2q3lGoqURZbSNWAyfcAbb7NQT/tHf4vR7mtmSOSHihPmEds6X/SqvBJCznsN/sciSkY8zC9xd0RppOfNpL+Q8t1OPd4I9JX5WXSj+owHXILz449JEzIKCFJXYKmDNjDJwsuA8GGYxqYefNbJGknnJ5g/XJbZMEcu8J7W/LfxYQrqjmAnGdE9qqOwstTArxAgRXQszyqtBXzuaYVHm9ng/22MS7FeByfe3kebnu2R2hzWC5jKrkD2jFlei8iGmI1qbZA+KaNZzeMBlFuPeow+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0CxXV/ZMVR96KpUk9cKeQHeVVm7EorlMb7H7S6C/BM=;
 b=LGK0/TWPisBMnlgGLWqxk6ANGLVEuUgvaZTPioVMtudyhA8F430B95QGA5kvJbRySHG3GC8EqoiWINvvWzRyzKiKsjVIntNPpAjjbW03k8OFkhqCd19yYCeZwq6E0DhndVJf6OSx55MgSqx+IgryxLtD15Z4wC2guqhxa0+dwRJUY11fHZROq/CIGcdRfDQ6O7LpN8Mp2Bz95v3AIscwIsS2WLTSvSo11GaPlAWhGIxkQWY8LjJMe/0toz/qYqOyEkkW6MCLnWHXWoSg4gtwe6tUwVN477AReTElrlJDryncNmz7jrzKbPuntQhzNqcHRmUcckUYsHKFc7wSJG7cUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0CxXV/ZMVR96KpUk9cKeQHeVVm7EorlMb7H7S6C/BM=;
 b=H/v47GA1sr5wNTb8qCUxO/RxQn9hxkUyu8tTlNPwEQ2XTA2/mCA593DsU/QYkrDX6W4PGV/ylsTlo3jdYrK0SGr+TubuxclL3bOITrkLda5ogISL4a7LFvX1fcIqtSNJqFSXRWGLjK2/Ebq3pWZ1UmYjs5EF7PeNoh1+gQLOBQ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR0402MB3671.eurprd04.prod.outlook.com (2603:10a6:209:19::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Tue, 14 Jul
 2020 12:24:17 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2%7]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 12:24:17 +0000
Subject: Re: [PATCH v2 1/5] dt-bindings: rng: add RNGB compatibles for i.MX6
 SoCs
To:     Rob Herring <robh@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200621145658.12528-1-horia.geanta@nxp.com>
 <20200621145658.12528-2-horia.geanta@nxp.com> <20200714000352.GA966545@bogus>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <674d98b4-df00-a53f-e0a6-9aaef428ed0b@nxp.com>
Date:   Tue, 14 Jul 2020 15:24:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200714000352.GA966545@bogus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0131.eurprd04.prod.outlook.com
 (2603:10a6:208:55::36) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:208:55::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 12:24:15 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b45bfda3-2671-4334-7c1d-08d827f0d3d4
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB36714FCFED3450AFCCDEDF7D98610@AM6PR0402MB3671.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OIrIDrTplowQFYkvKm7IxErWq51fETDZv4GqS3mZvSyDQNJY7FP/6q1MbRB3dfiJ5cKo3Zccw4V7nMsB9p0ozMBB/Br2VXhXN3dB6/dYfw01JCOeAI0CuY65lMW+sWu4M3QMYN/6UXL8Pkj8BkbzAI4vmf520vZQPs8LULvoGntlmRn8NHDHw5Q29fayJDFinTnqAxONb7sRW0cAFr5RAO91dKm7pZPWm6/WZE0AoMVWRF9FTZuVwXdbVKJXa0nxR99SNRs8dDw+NNeLQDbb1ncfVRwWdYOHWsM3FF1zgFYUSvubGKb2+Wp8JqJTCHeuMDXu2MbgtWno3Ds82lhOAi8/1XRO9wP9MNvjYHL+jlIWawAXilyllwULPE2p0KRf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(366004)(31686004)(86362001)(66476007)(66556008)(66946007)(2616005)(36756003)(956004)(31696002)(8936002)(16526019)(52116002)(53546011)(186003)(2906002)(6916009)(7416002)(8676002)(498600001)(26005)(4326008)(6486002)(16576012)(5660300002)(54906003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tWiTf/FRgXGM2pq/VJmoNCFX1Y7UNiJq4zRRJetsg3PQXRH/HWq4HNFWkVcAECISMeCFpmrSOQc7a6KWBgUP6s4vhStKn74nfqMLPDWWH3BIXrZdxV6RAldrNTAaIehvKVwW9iaD3PmsuMqyLlw08RuyT4qhN7BAu0Q44eqCM6IRpBVMXVf1SUdW6CgPFKSnX0eACs8xZk9T+7fMYXC2QAJ8jydzIfr9feTjB4U81/Lc2x7ifUcbEIjHysyiVwcUXbmzPaqNXKGgtQTe3/WSIG13lbN4RoKRO8PCbUUFwoGrdplAEXaftK0gx3MzLj1b2jtvLLWlKP5GiO0hhdlH8RWK4gd9Tb/Zhjp04lLqEh+Rd91VyLHYAabjcmwZZzGTEeyWP1EtbQJVn0jnLlOVZwlX5RAHB7LzyaMm+savFvoJrza9zLTZnvRjBy/kG4X5LDGpONVaZBvQznppwSVUYoYyvjyszkWwajp1JV8wougv9u+QXG1Y69g4ocpQmrbD
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45bfda3-2671-4334-7c1d-08d827f0d3d4
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4038.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 12:24:17.6115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tts4oB5toP15GXsJArHKJVpeE91WhTNQFUvLqMO/oWxkgPYXQmgfDULInw3LWAz9lXeVrBJtDp8lJdURKHJJZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3671
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/14/2020 3:03 AM, Rob Herring wrote:
> On Sun, Jun 21, 2020 at 05:56:54PM +0300, Horia Geantă wrote:
>> RNGB block is found in some i.MX6 SoCs - 6SL, 6SLL, 6ULL, 6ULZ.
>> Add corresponding compatible strings.
>>
>> Note:
>>
>> Several NXP SoC from QorIQ family (P1010, P1023, P4080, P3041, P5020)
>> also have a RNGB, however it's part of the CAAM
>> (Cryptograhic Accelerator and Assurance Module) crypto accelerator.
>> In this case, RNGB is managed in the caam driver
>> (drivers/crypto/caam/), since it's tightly related to
>> the caam "job ring" interface, not to mention CAAM internally relying on
>> RNGB as source of randomness.
>>
>> On the other hand, the i.MX6 SoCs with RNGB have a DCP
>> (Data Co-Processor) crypto accelerator and this block and RNGB
>> are independent.
>>
>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
>> ---
>>  Documentation/devicetree/bindings/rng/imx-rng.txt | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/rng/imx-rng.txt b/Documentation/devicetree/bindings/rng/imx-rng.txt
>> index 405c2b00ccb0..eb227db9e684 100644
>> --- a/Documentation/devicetree/bindings/rng/imx-rng.txt
>> +++ b/Documentation/devicetree/bindings/rng/imx-rng.txt
>> @@ -5,6 +5,9 @@ Required properties:
>>                 "fsl,imx21-rnga"
>>                 "fsl,imx31-rnga" (backward compatible with "fsl,imx21-rnga")
>>                 "fsl,imx25-rngb"
>> +               "fsl,imx6sl-rngb"
>> +               "fsl,imx6sll-rngb"
>> +               "fsl,imx6ull-rngb"
> 
> These are all different? IOW, no fallback compatible?
> 
They are compatible with "fsl,imx25-rngb".
I will clarify this in the binding in v3.

Thanks,
Horia
