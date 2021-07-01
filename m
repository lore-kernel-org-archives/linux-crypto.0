Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22616C11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 20:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB73561263
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 20:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhGAUcs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 16:32:48 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:53057
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235654AbhGAUco (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 16:32:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZH/muk0UwgOu6W/E94ewplCzDJ8T7QapsHn25kc8HAUn6QzS/sNlXQ7XjBoios+vlDRI+/7Q6ZTgNQl8vorxY4a33N7hCxY8eTWdu6+RC9qdhUx9+srGsC9XnFc09d2CyY/dbyHSlxJs+XDMwWo4NgRutDDbxvDihYtoU68bIixJ8jzcD6YNLCGNEpIPHtY55E6k8UDEnIAjIia03DEyGOYB3ZCadOtpO3ZHC2KPGApSO/7yZp76dzg8lgLtlKFSrYUSnVrHRURXiEU/xCxX08xq0qutSR3jUBL1j+QpaKdWl1+oCobO9ovxx+OatBL7oI2cVJvNiKkz/2xdVyS3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwuZZ8U9QKQFGno+3/oGY3FDAyDLWVsokdZLbFTo4rA=;
 b=Ck8msiDSv2Od3Y+mm3PT5LIBi87tQzR+7FzwSE75guUpBbAQdWfqdvFtA/QYw7FMSdt0pVAHSX1Bmqy1WDGysN7Bob+8ARphk2fh1WblMK6zECzXnlmj9LK8wraxNo2uDSwYY8c+gZDUY59/tpxNn7gUkBUxEAbqPp3kthKWYC3ioO7//XGlvjPAGk7xxJNh+RcY4eRupAoNjBwW2MJj4kq/WeUx3Y6c4EKMxTk+F2VRNYvpL0PCPZa4Q4LBqUktdwTtLrpLtYGjyPLGYaNcuFtl19MT4FFnkNjpWGg3WjVzTngsPWCqb0mPa++zS8t01v6k2UhEQ0m7OiQtNeIFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwuZZ8U9QKQFGno+3/oGY3FDAyDLWVsokdZLbFTo4rA=;
 b=ApMJUj4QInIBc35UayszBqAAJBD7KMYwVceEVlleczKdpgP4Lz53Lg9xJRXjwXT5o8nzF2OhloMIdgkVewj21QC9wo8vK1FJAbL39yu06zreA7Nij17Xjau2rOvnD7L++AyuxLHh+k6gA1FNa6ksFdCEYwV92aLWl4ucpWAmi1Q=
Authentication-Results: sigma-star.at; dkim=none (message not signed)
 header.d=none;sigma-star.at; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBAPR03MB6533.eurprd03.prod.outlook.com (2603:10a6:10:19d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 1 Jul
 2021 20:30:10 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 20:30:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
To:     Richard Weinberger <richard@nod.at>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
 <723802567.13207.1625167719840.JavaMail.zimbra@nod.at>
Message-ID: <dbeafb2a-e631-ad51-05b3-a775225140d6@seco.com>
Date:   Thu, 1 Jul 2021 16:30:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <723802567.13207.1625167719840.JavaMail.zimbra@nod.at>
Content-Type: multipart/mixed;
 boundary="------------5D7FA6597D9EC2BE52A4F491"
Content-Language: en-US
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: BLAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:208:32b::35) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by BLAPR03CA0030.namprd03.prod.outlook.com (2603:10b6:208:32b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Thu, 1 Jul 2021 20:30:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19612e8a-c859-4149-bdc0-08d93ccf05f9
X-MS-TrafficTypeDiagnostic: DBAPR03MB6533:
X-Microsoft-Antispam-PRVS: <DBAPR03MB6533F179BFF7B5DF87C8F72096009@DBAPR03MB6533.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHpbJE+1QI8OObsyksAt0blutEJpUeDBj8fbhJ2w9v9Y4pwAhr7VEzo5frcMTLVPxna+gURvPBMe48SxhE4xCETY1amK+KaGo519CiWQOs15QuoP3M9MUdj9gQtovKXvL3e0cmR3H/dcXcvgpek+es5mN/1a8Xz5B3DSicZZHIeYUPTAJVddMJU7VrJgQBoZbW4gFRNrnhS0rwGy+twtY2rW3s7rbavn1YAPAlHlQtQ1coGQZj38JQ6GX9a0LqLiWqzHEflHmI/2I/eauNVmt+nGINVTdhXFZewIdFhQ7DmaCrARSLAEKqrA4G/uXZiD6EQs4JlNH284gxtfkLt2cTFjI3qM7yuSfzzgSHkPxoQTEDUQbGiQ37nRB0oyPOr6nJp2OV9e6fNqIrTFU25CAJGAI9aviMF3+Q1Y+UW41lg1wwOA4pSimCHaOjjue/cm7k3u1vR9S5DNrUUYMVL8JCv69Q+6i+jmFGH337qv1qSRaHZaCxzresEzT2CiayoZ9agyQRmv8rlr7AwGLXDNKcdzH14TJyv9ZBei6xhAznReJD6E2W7iwdSLUw5p/RywH9kJUQH4uQqMArGCb4V2C3hXHnjT2joI3qzfmbU//V8D3HdQXSXo7OVT+jmrBWQP+iRWqfnrjBkSyysC+tfcRWpE641xhDkzoonHtT2Fjh3QUwUYNNVJqL6uIadYRec/YKXQZL3bcac1wWQk4Gl0ftdfU9br7aLIV1Q6Z9kVxTitqbLpj5FUn4LzpY8cZ5QoBoXx4545zyZTYnho9yP+a8FJeHiILNyO0AufrCeceS9vCD9BJtA7rLg68Y03FFkVHQW1om4amHQFj08CaYG3Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39840400004)(136003)(16526019)(4326008)(5660300002)(6666004)(6486002)(8936002)(235185007)(186003)(66946007)(26005)(956004)(66476007)(66616009)(53546011)(31686004)(45080400002)(478600001)(52116002)(38350700002)(2616005)(36756003)(33964004)(66556008)(38100700002)(966005)(66574015)(316002)(16576012)(54906003)(86362001)(44832011)(31696002)(6916009)(8676002)(2906002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2c5N3F6NkRpeEdQOXpNY0pCU3dKZnRTOXR4TTVVVjhUWDlhS2FXbnVLTlVz?=
 =?utf-8?B?SnNRT0RTclNTSDg3TFk2VHdhWmpBbDd2WUtTMW5mK3JMZmwyck9UazdZSTVa?=
 =?utf-8?B?NWErUHdsR1VwOVc2YkdoUzNpOEdHVC82c0pFSURUYUN3QkUxdUtBenIzMGZM?=
 =?utf-8?B?YkUyaGJjTDZsUlRwQlJ3Nmtvb0daclMvNy9XSWFOSjNhUUErTW5sYnl4UjM5?=
 =?utf-8?B?WUl0UHJyb1I5L1k5clUwZVdvR1RoODVla1VKY0NaaEs2eU9Na1FkdExWRWtY?=
 =?utf-8?B?MGY2ZUgyWXpIZVV4cXBKQklHMGRnbDgwMjJMK3I4ZnR5QXZGV3dvaXF5Q21V?=
 =?utf-8?B?VHVUOElLMjQya1BHYnlFZlllZUs2QTR4MmFYbFRkVXk2ZEdzRS92UVU5VTNS?=
 =?utf-8?B?SGF5UzdhM0FvTTlXUHloOVlOUS9QZE5NSUN3czRDdndDSVhpNDFBTE14R0ox?=
 =?utf-8?B?U3EwQVdwUDQ5ZzJvQU5hY0lQVGdpUGxESWI2bm1lTGxtV0JybTB1SEl4SGI4?=
 =?utf-8?B?cE9VNmxLdkJiY1M4Uk03cmRTS2NzSlNCcmhYaDBacWZ5WjVtWm5pWUJHTS9X?=
 =?utf-8?B?NDc5UHdqK3RWMnd0ZWJhaWZ3eHVqKzJqMHVBSDBVUkdCdytKVEVjZFR3aUho?=
 =?utf-8?B?dk1EUTd0WWI1REc3WVRDUUVnbXNCV0tFYkFUcm5yeHRRN0dZT0pVVzBOZzRJ?=
 =?utf-8?B?ckVLQk9wakdNbjk5S3k0TGdBN0VwS293TG9uNmZoaFJTRGJMUFJIdkZIN2NS?=
 =?utf-8?B?TEJWajFFZVptNWsvdUJ0T1BnbU1qWkUxVlNBZUlJVlBPSWNKdkY0M0J2M2oy?=
 =?utf-8?B?R2RweXRQaVlDQU9SKzU5Q3RPVWFGWVJKZEZBMnJRRmxSQldYdk1jb3R4UGlL?=
 =?utf-8?B?eXp5ek90STNkcUxuY1ZUY295c3RRdHRXMCtsaFd6QVlKR0xaRVhSK25OdENi?=
 =?utf-8?B?eitWeWVnRGZtbEFxOWcxK0Qwajk3RmdXb0VBWDRXNFJRWlpkYU9CY3JIZm0z?=
 =?utf-8?B?cE0wUTVqeVhkVjFFNnZNS0JXLzB2Rko5ZEgyUlJrTXYrVE5JNytORkcza1hz?=
 =?utf-8?B?UDlVaHJHYXZaU1JCdTAvUkNobmVxMitPS3pWdTlyeEEvWjJzZkM4eVdQT1VE?=
 =?utf-8?B?bkdVMTM0YjNCQlFPTXdqSFVGM2R0d1RBOENXNFlVTVdnR3dYVHdsUGlaQU0y?=
 =?utf-8?B?aG9LWklGSUE2OTdYSnlKd21sSWNEM2RzWFh5TkQzRlJjY2RoTWkvVElheFlX?=
 =?utf-8?B?ajlsUDVqVkJTRktRQWhSNEJKOFpHL1JYL2pSQzY3TVVGbm9VZ3VUZ2pIY1li?=
 =?utf-8?B?UDBoUHM3a3Z6TXJSVFBTdXNFNnR4TFJ0RE8yNm1lVG44VjlYNExjYi9tTGIy?=
 =?utf-8?B?bVJyb0pOZEhwT1JzTXU5YjVYUzF2b0dJYzliT2hHbzlCMmFBK0NycTloZ3NI?=
 =?utf-8?B?T2Z4VmR6YisyNkV6N29hUGxIZlhNaTVHR1JjWUFBa2lDSkFEQkJTSmJSemFs?=
 =?utf-8?B?Sit4ei9QY2lZRnh5YithRkxOMk42ZmxJZ0hlVXNqN1VzSFR0T0pEZ0ZaTnVz?=
 =?utf-8?B?YzA2bEo1WkRwd1BjMG1pRS9VUDg4NnEzUVNKNWNhMW1FTnNTUklQQVFmbkFh?=
 =?utf-8?B?SHRBbWxPYmE2b1ZDaVVNcW4xK2RPTkQ4Rko2NkFPV0Q3dTllb25xbEVlYm12?=
 =?utf-8?B?Y21oY29vSU5wMnFxT2VQeVl6RVVTOGVENThyU2krUWRWbnlZWVVLdG9rNEtI?=
 =?utf-8?Q?mRV+VvsHtuKHLSHjz1Lc0iyR48zkHcdmBDp1cKE?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19612e8a-c859-4149-bdc0-08d93ccf05f9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 20:30:10.7564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpjfuwiRGbsauWz1Kv+V6kKpOy4eiYng46Zw7L9uOeneUfBF2e/FzDqrJC1VojfenVaYTD2Zfvh/Gb8MRZxAXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6533
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--------------5D7FA6597D9EC2BE52A4F491
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Richard,

> On 7/1/21 3:28 PM, Richard Weinberger wrote:
>  Sean,
> 
>  [CC'ing David]
> 
>  ----- Ursprüngliche Mail -----
>> Von: "Sean Anderson" <sean.anderson@seco.com>
>> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
>> <davem@davemloft.net>
>> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
>> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
>> <sean.anderson@seco.com>
>> Gesendet: Donnerstag, 1. Juli 2021 20:56:36
>> Betreff: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
> 
>> This fixes at least one oops when using the DCP on ULL. However, I got
>> another Oops when running kcapi-dgst-test.sh from the libkcapi test
>> suite [1]:
>>
>> [ 6961.181777] Unable to handle kernel NULL pointer dereference at virtual
>> address 000008f8
>> [ 6961.190143] pgd = e59542a6
>> [ 6961.192917] [000008f8] *pgd=00000000
>> [ 6961.196586] Internal error: Oops: 5 [#1] ARM
>> [ 6961.200877] Modules linked in: crypto_user mxs_dcp cfg80211 rfkill
>> des_generic libdes arc4 libarc4 cbc ecb algif_skcipher sha256_generic libsha256
>> sha1_generic hmac aes_generic libaes cmac sha512_generic md5 md4 algif_hash
>> af_alg i2c_imx ci_hdrc_imx ci_hdrc i2c_core ulpi roles udc_core imx_sdma
>> usb_common firmware_class usbmisc_imx virt_dma phy_mxs_usb nf_tables nfnetlink
>> ip_tables x_tables ipv6 autofs4 [last unloaded: mxs_dcp]
>> [ 6961.239228] CPU: 0 PID: 469 Comm: mxs_dcp_chan/ae Not tainted
>> 5.10.46-315-tiago #315
>> [ 6961.246988] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
>> [ 6961.253201] PC is at memcpy+0xc0/0x330
>> [ 6961.256993] LR is at dcp_chan_thread_aes+0x220/0x94c [mxs_dcp]
>> [ 6961.262847] pc : [<c053f1e0>]    lr : [<bf13cda4>]    psr: 800e0013
>> [ 6961.269130] sp : cdc09ef4  ip : 00000010  fp : c36e5808
>> [ 6961.274370] r10: cdcc3150  r9 : 00000000  r8 : bff46000
>> [ 6961.279613] r7 : c36e59d0  r6 : c2e42840  r5 : cdcc3140  r4 : 00000001
>> [ 6961.286156] r3 : 000008f9  r2 : 80000000  r1 : 000008f8  r0 : cdc1004f
>> [ 6961.292704] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [ 6961.299860] Control: 10c53c7d  Table: 83358059  DAC: 00000051
>> [ 6961.305628] Process mxs_dcp_chan/ae (pid: 469, stack limit = 0xe1efdc80)
>> [ 6961.312346] Stack: (0xcdc09ef4 to 0xcdc0a000)
>> [ 6961.316726] 9ee0:                                              cdc1004f
>> 00000001 bf13cda4
>> [ 6961.324930] 9f00: 00000000 00000000 c23b41a0 00000000 c36e59d0 00000001
>> 00000010 00000000
>> [ 6961.333132] 9f20: 00000000 00000000 c13de2fc 000008f9 8dc13080 00000010
>> cdcc3150 c21e5010
>> [ 6961.341335] 9f40: cdc08000 cdc10040 00000001 bf13fa40 cdc11040 c2e42880
>> 00000002 cc861440
>> [ 6961.349535] 9f60: ffffe000 c33dbe00 c332cb40 cdc08000 00000000 bf13cb84
>> 00000000 c3353c54
>> [ 6961.357736] 9f80: c33dbe44 c0140d34 cdc08000 c332cb40 c0140c00 00000000
>> 00000000 00000000
>> [ 6961.365936] 9fa0: 00000000 00000000 00000000 c0100114 00000000 00000000
>> 00000000 00000000
>> [ 6961.374138] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [ 6961.382338] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> 00000000 00000000
>> [ 6961.390567] [<c053f1e0>] (memcpy) from [<bf13cda4>]
>> (dcp_chan_thread_aes+0x220/0x94c [mxs_dcp])
>> [ 6961.399312] [<bf13cda4>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d34>]
>> (kthread+0x134/0x160)
>> [ 6961.408137] [<c0140d34>] (kthread) from [<c0100114>]
>> (ret_from_fork+0x14/0x20)
>> [ 6961.415377] Exception stack(0xcdc09fb0 to 0xcdc09ff8)
>> [ 6961.420448] 9fa0:                                     00000000 00000000
>> 00000000 00000000
>> [ 6961.428647] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [ 6961.436845] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [ 6961.443488] Code: e4808004 e480e004 e8bd01e0 e1b02f82 (14d13001)
>>
>> where dcp_chan_thread_aes+0x220 is the line
>>
>>	memcpy(in_buf + actx->fill, src_buf, clen);
>>
>> in mxs_dcp_aes_block_crypt. I also tried with the following patch
>> instead of the one included in this series:
>>
>> ---
>> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
>> index f397cc5bf102..54fd24ba1261 100644
>> --- a/drivers/crypto/mxs-dcp.c
>> +++ b/drivers/crypto/mxs-dcp.c
>> @@ -367,6 +367,7 @@ static int mxs_dcp_aes_block_crypt(struct
>> crypto_async_request *arq)
>>                                last_out_len = actx->fill;
>>                                while (dst && actx->fill) {
>>                                        if (!split) {
>> +                                               kmap(sg_page(dst));
>>                                                dst_buf = sg_virt(dst);
>>                                                dst_off = 0;
>>                                        }
>> @@ -379,6 +380,7 @@ static int mxs_dcp_aes_block_crypt(struct
>> crypto_async_request *arq)
>>                                        actx->fill -= rem;
>>
>>                                        if (dst_off == sg_dma_len(dst)) {
>> +                                               kunmap(sg_page(dst));
>>                                                dst = sg_next(dst);
>>                                                split = 0;
>>                                        } else {
>> --
>>
>> but got the same oops. Unfortunately, I don't have the time to
>> investigate this oops as well. I'd appreciate if anyone else using this
>> device could look into this and see if they encounter the same errors.
>>
>> [1] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-dgst-test.sh
> 
>  Can you please share your kernel .config? David or I can test on our test bed.
>  But will take a few days.

Attached. This is for 5.10.46, so for all I know this has been fixed
already. But I looked at linux/master and didn't see any changes to
drivers/crypto/mxs-dcp.c (other than the sha1/2 split).

--Sean


--------------5D7FA6597D9EC2BE52A4F491
Content-Type: application/gzip;
 name=".config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename=".config.gz"

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

--------------5D7FA6597D9EC2BE52A4F491--
