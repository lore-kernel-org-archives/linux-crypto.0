Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A06AC2BBCF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCF423A9A
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389078AbgLRKxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 05:53:23 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:59077 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389113AbgLRKxS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 05:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608288729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dYUjn04ev/0h5j5SvHPrqsPxrHdN2rdocG8LM1nnKN8=;
        b=HTKWRxloq3xgxHZsTz6iWcm6b2nAIfKRmK7rWfQEqikeZJ3u9u/Ad25qjwFrVGouRx83sY
        RNmvsFL7oKKGUPr7eQf+5UDhekuOFjQZ8x7FKYFfewttfBkqhJ1BRVQhAWIrKfYX2xVezd
        OR1RH0CfpfEfYpBQhfEGuEYmWPhLuY0=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-QoMgbnJdPVSEE8xi7SAztA-1;
 Fri, 18 Dec 2020 11:49:59 +0100
X-MC-Unique: QoMgbnJdPVSEE8xi7SAztA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFmfNyq4Z3rqhZwizvTyHZtG5a9cvZJ2u1nuupC8FF58c+3mQT8kO6JDoPFx2TASmRpf0c3gZmgj63InsUEzxv2HyHTnre/9F2DHOMLdjYoiB6qMeArpdrVdsD4ly5Mhb/j8zmbTNvtfS4/8eYnkd7gYxDYi/jOndQ6tGG1sJVKl44WFeNyRcuM5bWReYX/1bwoFZ/G6mVQNgoTPypcGyOmLqpNz7Ayk0sPDxw+C2kp2FGLCLvimb7fYNnVBQJN0Angwe7BEYkRtS+acXxlCFBscutwVY/WyXjssvDvM6gtThoql40MMXXSbrWA2rl5LXRvEiwnoEnhtggFMvq5n4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PBRUP8/x7G/Dw9riQ3ex7/iaqHYO7jgV8ld7H6bvMY=;
 b=CHssSneXiYZf5vE3kbtRP6CFAwDukA1YYxUpPvoFsvcxT3u/9iKwW2k+DPUegvpl7uzvzeIWTU4k8id3jPGESxnaVGoGqopg9likf8GzbrGSD/eNx9KD+SGhtDDZv36gj9IrBItlVLUWP6zk8Zq+S0KXiVDL5ZokISQA/NcEinFfflAtMVsljci3NiN7QaR5lK8RYf7BawPazDmpM70em3JuLwQpZK2SbORHNCCa43KnvCyYAmBgl+fgyAZEsnvoxrbeog94JcH/XlH8S1YIQAzXLgylBmuHM6VN0ZXIcRWlho9X3DeJ/sqDreGBf1D1+E0PWp1Ewr9LoZMzaWeVBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM6PR04MB5366.eurprd04.prod.outlook.com (2603:10a6:20b:9d::19)
 by AM6PR0402MB3317.eurprd04.prod.outlook.com (2603:10a6:209:a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 10:49:58 +0000
Received: from AM6PR04MB5366.eurprd04.prod.outlook.com
 ([fe80::b58b:42d9:4e85:ddd1]) by AM6PR04MB5366.eurprd04.prod.outlook.com
 ([fe80::b58b:42d9:4e85:ddd1%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 10:49:58 +0000
Subject: Re: [PATCH 1/2] hwrng: iproc-rng200: Fix disable of the block.
To:     Scott Branden <scott.branden@broadcom.com>,
        matthias.bgg@kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
CC:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org
References: <20201214160454.22769-1-matthias.bgg@kernel.org>
 <24e22e5a-7371-02b4-1636-2e03def420e3@broadcom.com>
From:   Matthias Brugger <mbrugger@suse.com>
Message-ID: <ab41dfe2-e244-f920-5d1f-bb34ac16fe8f@suse.com>
Date:   Fri, 18 Dec 2020 11:49:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
In-Reply-To: <24e22e5a-7371-02b4-1636-2e03def420e3@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [213.195.126.134]
X-ClientProxiedBy: AM9P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::32) To AM6PR04MB5366.eurprd04.prod.outlook.com
 (2603:10a6:20b:9d::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ziggy.stardust (213.195.126.134) by AM9P191CA0027.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 10:49:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44c9bf06-6e1e-4763-ea16-08d8a342a98c
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3317:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB33179106C85719D2946FD594BAC30@AM6PR0402MB3317.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92Oht/FqSva5H0lhbYP3mLnSM+3GDW1a4Wvgmt9BcLhXk3Pr9RboYN7moJ+xRgCx5Q8vlkXwetM/2UV6BHya0DqDKlxL3imOkeI7EDmZU58hEZM6Wg46IuPyPsmGI19qiBtupt2bX3eOT5SszqaOgP5kZA5SvBBwY159JXLorg9lG7xN2jUXrFCOnnb/rAkduF0CBN4ZuIyVjpb95a+Lf3oW0uJ4nzn3WhY15XBmQEWbAams6xN7PQk3mmP/5TTu3letVcb3A43EVi93agM9KaMqn4SkIj39OOoqg6aB8XTj9n/BQSDuLS6AQfg9d043+7hVJvDIHX0Yv339r1bjUt4vCh8pVMrphNHY1eef82REPgKGrlcIYhDUw+bEpyhH8BXW6S4AkC0uZLQdtu/oqBX8Gc6JMYYgN2ZLH7JAi6wJTlqI9O1QacrF7GXcuZM2aXOY+0z3QGACgIetIxlWs/hyhZ9hYa+4F3xL+zJwv8c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5366.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(16526019)(7416002)(2906002)(6506007)(186003)(36756003)(5660300002)(26005)(4326008)(53546011)(4001150100001)(31686004)(8676002)(66556008)(6486002)(52116002)(86362001)(2616005)(83380400001)(66476007)(956004)(316002)(31696002)(478600001)(8936002)(66946007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QzKTtl6nH+3djOlBG9A4mnMfeXvEGX+pUWKkZcUSiR/69JzEVoD0lhMldO09?=
 =?us-ascii?Q?u4T6NYiYZTHwRV+iS0rmGCtmd9mh14ytg9Zy/WzdYm7squNZ6STCa9v3yAoS?=
 =?us-ascii?Q?g9ZWEYDyXzguIveqXdHDseAw2aCDtzj7HzdVLm+JtRYVnf/iYU7bXffj4Isq?=
 =?us-ascii?Q?KwjWZ3j66HuT6+QC6ncLySym/FEfnsDjVSzf74P8pfzap9OMWYOj41UGHFyM?=
 =?us-ascii?Q?/kOwhcah5n2pouZUtVI5hRSghPg+l6MNJeWPxHTDYzcLTgsaw5aUfyqO20kD?=
 =?us-ascii?Q?TD5sWKMfkcjxOHwMgIwsskW/X0aD3VoEeN/P3JgZCwcGIJyxItwEu/r3szQL?=
 =?us-ascii?Q?qRQ0IrkpkPz9Cxr/JIh+yj2T6QGMKPxkip5UBeL6Nd3ugwrYjF2dUbj6TOnC?=
 =?us-ascii?Q?Wd12XUk4MEXtEc9RXzaVx/MpP1uLF+jPcoTTe4gS/9ImshPZgNhDZ+jcpeXT?=
 =?us-ascii?Q?AEkyA6c1nn/fKZReINR5N0bU1yuPTkUAGXVsLRPsJxt9h6CB1v1O/J88sXhh?=
 =?us-ascii?Q?2PeEuRqG4yHqeIIL3EIopVaDNWxNtVBSnQ8qBFZwtzGV5aEkptlsX9gXeTWE?=
 =?us-ascii?Q?GQ74rH6Wz8g/a2gDFV4CgQhunfhje81ZVRmwqRI/wX9f375wVgbz06BXM0hZ?=
 =?us-ascii?Q?hteCY4darQYwAlWeNjm7TPiIxswOIaLoDqYel3fCwe44Js266oVUfSzLWVgr?=
 =?us-ascii?Q?IUp7Wu2tDJbGaHlbg368wMHLivDkHhLBfWmweDDbCZQATIsW6Fx2blhL6vuf?=
 =?us-ascii?Q?HqR3VMVW53JLYH46CIgJpOm7xTMPM6vuamDovR4e1vIPikpvKLkyYbKNlsMN?=
 =?us-ascii?Q?INKFQUDA2j7GBHUHuVz0xbUbY0kt0ChbVEFiegdnSVtMXAPJIHB2snwdmM0u?=
 =?us-ascii?Q?2sxSOiLd+eRtzCkVEd3Ajj5OUYJLUwg4D+2iwXFna1vx6nVsMutaU5mALmDM?=
 =?us-ascii?Q?fvhLzestduwGgdReLNGnKpejj6f2312mHA5fLcax+hklEIYSB0VX3M/WoJYZ?=
 =?us-ascii?Q?Gtec?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5366.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 10:49:57.9179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c9bf06-6e1e-4763-ea16-08d8a342a98c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8aUwnk50lRr1bC62YIiQlp2Y1Aj/msG+zseU++Wv74IFjhua38bhiWAOXjmegYWs8yzFo9TCFMNctvX5OLKbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3317
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 14/12/2020 18:45, Scott Branden wrote:
>=20
>=20
> On 2020-12-14 8:04 a.m., matthias.bgg@kernel.org wrote:
>> From: Matthias Brugger <mbrugger@suse.com>
>>
>> When trying to disable the block we bitwise or the control
>> register with value zero. This will leave the block always turned on.
>> Fix this by setting the corresponding bit to zero.
>>
>> Fixes: c83d45d5685f ("hwrng: iproc-rng200 - Add Broadcom IPROC RNG drive=
r")
> Commit message needs to be re-written.
> I don't think this is an actual fix as the ~RNG_CTL_RNG_RBGEN_MASK alread=
y zeros the bit.=C2=A0 This is just a code change, which is fine because it=
 makes things clearer

Right, I'll reword it.

>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>> ---
>>
>>  drivers/char/hw_random/iproc-rng200.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_ran=
dom/iproc-rng200.c
>> index 01583faf9893..e106ce3c0146 100644
>> --- a/drivers/char/hw_random/iproc-rng200.c
>> +++ b/drivers/char/hw_random/iproc-rng200.c
>> @@ -28,7 +28,6 @@
>>  #define RNG_CTRL_OFFSET					0x00
>>  #define RNG_CTRL_RNG_RBGEN_MASK				0x00001FFF
>>  #define RNG_CTRL_RNG_RBGEN_ENABLE			0x00000001
>> -#define RNG_CTRL_RNG_RBGEN_DISABLE			0x00000000
>> =20
>>  #define RNG_SOFT_RESET_OFFSET				0x04
>>  #define RNG_SOFT_RESET					0x00000001
>> @@ -61,7 +60,7 @@ static void iproc_rng200_restart(void __iomem *rng_bas=
e)
>>  	/* Disable RBG */
>>  	val =3D ioread32(rng_base + RNG_CTRL_OFFSET);
>>  	val &=3D ~RNG_CTRL_RNG_RBGEN_MASK;
> This mask will already zero the enable bit.
>> -	val |=3D RNG_CTRL_RNG_RBGEN_DISABLE;
>> +	val &=3D ~RNG_CTRL_RNG_RBGEN_ENABLE;

Correct, so no need for this extra line. I'll delete it.

>>  	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
>> =20
>>  	/* Clear all interrupt status */
>> @@ -174,7 +173,7 @@ static void iproc_rng200_cleanup(struct hwrng *rng)
>>  	/* Disable RNG hardware */
>>  	val =3D ioread32(priv->base + RNG_CTRL_OFFSET);
>>  	val &=3D ~RNG_CTRL_RNG_RBGEN_MASK;
>> -	val |=3D RNG_CTRL_RNG_RBGEN_DISABLE;
>> +	val &=3D ~RNG_CTRL_RNG_RBGEN_ENABLE;
>>  	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
>>  }
>> =20
>=20

