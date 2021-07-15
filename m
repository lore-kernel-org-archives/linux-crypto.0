Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6E7C47E48
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 15:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EA661279
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 15:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhGOPOB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 11:14:01 -0400
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:37062
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234479AbhGOPOA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 11:14:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf1FZqSdWUkaf2a3hwmb0Aa1FhL+BEvhxktarX5iGrd478A+wh3cEyGkcf9PQs3yFWgO+OtSRMkY1a7Jwe80sMFDgq4/bHscxJj9d/cqvHIS2ATKdGok2uqu4azkKGHAAGNvsD17do9gsrsT/ZbO4wtkwLdj7ltCBjJCPgWh2DlyVLn0qSZvi4156oAjqFxZWOjbeOeXOE8SvSK4Ic1na0uUj2ZqVu4tSJVY8LE0s0WDQOn/MVc5iQ9Qip/OC8ygu2SlJb0IVQD6QRpLYh67s1SbLzZrKD55IjO1Af8O4/IeZxO+qf+BVnz+1yZN1/GMpqWtmXbkjnZ521LIK20+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pV1Kw5Qr4HmKUyXs/WRE7n6zUNnASaoYEzNfL3H9pZE=;
 b=JndCecUNctVVVEbvj/Ab2JzQx/Nx3wufb5LdFI1NVqBE4+ueH2nWi1SNkajbdaDAm0AMWhc8Od2Nv58/N4B8AkeCDs0gcbnrKa6/h42xIkiFUwSyn/GcFNx6eNM3cuUwbFL4qk5nNnk+VageH+97Ufn/8EjkB1rVjIuKOjk59IoVcwyDq6DdoScxHQ8KEgjhaeUVWCEts7JIDLaNNWtAbXejhmM724I4L9jyeL+PV87vc6Fiky3AFfVfvTQDb+jxn1wUYlaye+6wt6tWRvfxRTGRFDsQ9R12XdELV1X52B5AD7eH8W06S93MZul9DtPa4GAXCipM2h1XgUbymd7jbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pV1Kw5Qr4HmKUyXs/WRE7n6zUNnASaoYEzNfL3H9pZE=;
 b=glDtNcUz/7NF728LoReLQ/np6xWWgmQ9Pakcvxbkxalg8yMP8XyjGextCphtl6HS3Try3hUqzckET/Am+WiWlivUVNK5Sxmd2+ZuG1+pJN1eVpIA8nVlmX7FNDfoJPjxcFr7ZTqin4clpjXioqHa2K5pYYCLjODEBBMQFSPoHg8=
Authentication-Results: sigma-star.at; dkim=none (message not signed)
 header.d=none;sigma-star.at; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3964.eurprd03.prod.outlook.com (2603:10a6:5:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 15:11:04 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::dc6c:815b:2062:d1f1]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::dc6c:815b:2062:d1f1%7]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 15:11:04 +0000
Subject: Re: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
From:   Sean Anderson <sean.anderson@seco.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
 <723802567.13207.1625167719840.JavaMail.zimbra@nod.at>
 <dbeafb2a-e631-ad51-05b3-a775225140d6@seco.com>
Message-ID: <2628c3a9-a337-ccee-b996-803fdfe9e1fd@seco.com>
Date:   Thu, 15 Jul 2021 11:10:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <dbeafb2a-e631-ad51-05b3-a775225140d6@seco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0063.namprd16.prod.outlook.com
 (2603:10b6:208:234::32) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by MN2PR16CA0063.namprd16.prod.outlook.com (2603:10b6:208:234::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:11:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81eb9ef0-09c1-4039-074a-08d947a2c372
X-MS-TrafficTypeDiagnostic: DB7PR03MB3964:
X-Microsoft-Antispam-PRVS: <DB7PR03MB3964BF4B4BC0D6B74FD8E8AD96129@DB7PR03MB3964.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BDXBTFwX4dCQLOf0ftu7F2kDuv8neSR+PzW/hIDITHUEh0iA+AW6tsXyJ8Rc4Qi9TpELy1YhTH1aJSl54qwm4uVmcDY+yT68x56mq7brN1bHn51PX2AeKBUHV+ZKC2KbBOsBJIVK9dN68733eVJ2QuAwWhSWuLwQpt+9sKRl5avLXt3iziqNPxYgHh5b2QtzZ7AmTU3u2jCEFMRb9DZlqq4cdeVHHLPA8kXqKippRWV1wmDFEkXtR20qfk7Ol7hYw1sC+pSAenLXN43E7q9Q5qLQAXHvahIAvVS7IeA5vtseXtuCoboiBdDh6Je99JEqJPoARQyGjJjNIuROb9swQMJYCBC9wA7sZ0Ys4m4dZkNtXkQ02fDdJbkqYNsCpWyGhonBJ+YSoiwtka+y9OFf2AxSd+Si5SSOoGByd9jXIk5q7EqJtGr42V6QccRHnM9EaStB3ugm6TvFBAs/WVXI/FTCU08VgngEUq/P5wmwSbPMXPu9BRDH8wEA5zADnE6nZED/b8qS8TaAvgwk/xp0QvafLJrb0k4wyS7EODBIe1hl23JeYcPIgz641QKfvZyfxP8yGjjKumRJiTAsN9c/5ak9J5QLAyIdBbGz20Bo39ENBx+3Xn4emiNehlOuJ0MQR3ezIheb2uDAJL0mdVvfopmA3XQgx2lGPoP5fzYFc3iTYmOlpeugbM+ByPVYqg2SlPS23FuzGBcQEKhrvpiO72GM+/ZffxnVKbC8NgsJvh5tKKQqNM8WczHAeZLJLP5Up/9Gpl864NXCmA+upMWYKP1Tgurwv0RuoYKKoKR61T/03fs3p4kzq1K8e3GkFuN8QKv7jNgSVp02xPqW/3+MERRL6C2McpEyKewA4aoYWvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39840400004)(376002)(136003)(346002)(53546011)(6486002)(966005)(8936002)(26005)(54906003)(6916009)(52116002)(86362001)(36756003)(4326008)(66574015)(16576012)(31696002)(83380400001)(44832011)(316002)(5660300002)(478600001)(8676002)(66556008)(31686004)(38350700002)(6666004)(956004)(66946007)(2616005)(45080400002)(186003)(38100700002)(66476007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0ViM1FZeWNaSzU4Uk9LTjFoWjR6a280dndOb1VxMEZpRmZ6SlMveG5seXhy?=
 =?utf-8?B?OTZocy9VeGgwd0g4Tmh5c2RKOVpNWEM3UkpTbDN1NElMVHBiT0E1MEFJc3JY?=
 =?utf-8?B?ZzA3SzFRTWZDcDV2TGswdjhhZzRpSDYvZUlyaWZFanFGRHdIbHlObjVRanpi?=
 =?utf-8?B?S1NLcVpVMTNXOThKRTBIUXVrUzM1dDV0TFBLTW0xMDRiRWM2d3dmdEQ2MThy?=
 =?utf-8?B?RFE0U0xDMnovakMwdEhiR0l1MGpDcmdXTUplRmFUREQwLzdaSnQvQlh6c0N3?=
 =?utf-8?B?a0hNRTVvM3EvdFFrZFE5bkpYWTJNYWUvS0hvYm5aZVp4YWs3Vmg0Vlk2eFVF?=
 =?utf-8?B?NEU0VlRPKzFXTWwrMGppWU1aaWhYL0lyRHlVa1pQWEg5Yjc3UjJEb0F2OWdP?=
 =?utf-8?B?QjQzRmZhcnF5bENvc2JSZWZvRmZFbXI2d2lwSVhmYThqd08wQzJrc0kveGFp?=
 =?utf-8?B?Z2FqVk1COEhaS2ZjdjIwZTJYSyt2eVYwc1J5NWpwcE9MZ2t3ZFc2S0JZSnVP?=
 =?utf-8?B?bnhVR25BdmR6Q3l1MWR4OGlwSlRCcmcySmd4Z0l5TkhSS2M3SGhXSnFMb2Vs?=
 =?utf-8?B?RGFLaEg2RFBNM243SEZlYjNtSGl0NTRCU1ZLNWRTTlFDME13dGdIZm5UUzZo?=
 =?utf-8?B?OThiaHN6T2pXcS9vbzBnRzJxMFVnYTRLR0YySlh0YllIeGgyQUxCeXQ1eHRl?=
 =?utf-8?B?ZWRsdnI2UksxUmIrSERaVmpuSEFOTjQyMTVZVkhCL0xBRlJ4U3p1VkMvc1hU?=
 =?utf-8?B?KzhWUysvejlLeThpYkRVZ2pJWUlMVmgwd2taSE4yUmt2cS9JMit6T0ZyM1p5?=
 =?utf-8?B?WTZzdHEvazR3cTRoUXZwdm52WTBQNWYyd3pQeUhEUHBYWjdpWGlKUHZlbnZm?=
 =?utf-8?B?bXNhMHViV1JkS2FEbXJhbnpQU2hIRmFiRWwwd0ROYlo0czZmTk9PNEJEUHA0?=
 =?utf-8?B?QSttRDFXOENHOGNPYlBxaWU2OXRjN2kvL0NiU3IybkdFRzhSOEdyMzN2NExl?=
 =?utf-8?B?Z2IybjBGaXEwZndUUU51VVFtOGZtaWlEaXl1ZFh6R1FhL3llWnNvbndvUW0x?=
 =?utf-8?B?SEhyT2VKMFF1bnFndWFoUnVNMUhaYk53QitSRDdWYzVyZ1VLTFdOb0JDVGRn?=
 =?utf-8?B?TlNFTkVMV0xuWk9kbEd0RnNxQ0t3RWZJT0htVGhDT2ZWbUpvZ1FKMFNTUWFM?=
 =?utf-8?B?Nkk5OXBtK2Z3S3RRR2xIWUZ3MUIzSVF0anJ4SENnTlJoeFVYamRyY1dXZFRN?=
 =?utf-8?B?NUY4bG5Zd045TVM0L1RLU2hEQzcyVDBuUUJXWDJQUTdPNC8rRWpYczdCeW9y?=
 =?utf-8?B?dTg5UE9jK2l5dHVuNnZocElpSWtiY0xBL1lCTTR4SVkvb3o2K3pzUTQzWFF3?=
 =?utf-8?B?blFBS2lRc095ZEFDUVBKOUhUSkcrWGdrN0JPaVIxUWFFNmplWnUvSmNhN3RM?=
 =?utf-8?B?cnFGcW5nV2VNUlYydUZqcTl5Zm5PSk81WHRhbUZLdlpaQXRWUmFXRkNCN01B?=
 =?utf-8?B?ZDA1TTYvSFhlQlV0Q09hWjIwTzRLSElxODc5VldRdE1jVE82TXdtTHZ3Q3FX?=
 =?utf-8?B?WG9CSzRUNFk5TThzeDdUc0JKUjhXVkpZV3VzaCtSUUtZYUZFNDJhc1owM1Fl?=
 =?utf-8?B?Z1BBdDRKTGdoamwyWmgvWjEwajg4R0FpQUpRR3JjRER2TXpvWG1aYzRIbGNj?=
 =?utf-8?B?emQzak5RZzFjb3ExU21oRlI1OVF3U3RtTFFlM2U2aUszSWI2cmJtMlBTNzJ6?=
 =?utf-8?Q?6o5+0QSp2eUI9WnZdVgxgcCzRYEO/rkSuKhniFD?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81eb9ef0-09c1-4039-074a-08d947a2c372
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:11:04.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qQGppCx+XDP1JmPlCAwBk71Cls965j/uxrNyjUDe5P+ENaNt/0xMyKHmqCuArqZrDuABTyjapILMKSoQMQr4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3964
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/1/21 4:30 PM, Sean Anderson wrote:
> Hi Richard,
> 
>> On 7/1/21 3:28 PM, Richard Weinberger wrote:
>>  Sean,
>>
>>  [CC'ing David]
>>
>>  ----- Ursprüngliche Mail -----
>>> Von: "Sean Anderson" <sean.anderson@seco.com>
>>> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
>>> <davem@davemloft.net>
>>> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
>>> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
>>> <sean.anderson@seco.com>
>>> Gesendet: Donnerstag, 1. Juli 2021 20:56:36
>>> Betreff: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
>>
>>> This fixes at least one oops when using the DCP on ULL. However, I got
>>> another Oops when running kcapi-dgst-test.sh from the libkcapi test
>>> suite [1]:
>>>
>>> [ 6961.181777] Unable to handle kernel NULL pointer dereference at virtual
>>> address 000008f8
>>> [ 6961.190143] pgd = e59542a6
>>> [ 6961.192917] [000008f8] *pgd=00000000
>>> [ 6961.196586] Internal error: Oops: 5 [#1] ARM
>>> [ 6961.200877] Modules linked in: crypto_user mxs_dcp cfg80211 rfkill
>>> des_generic libdes arc4 libarc4 cbc ecb algif_skcipher sha256_generic libsha256
>>> sha1_generic hmac aes_generic libaes cmac sha512_generic md5 md4 algif_hash
>>> af_alg i2c_imx ci_hdrc_imx ci_hdrc i2c_core ulpi roles udc_core imx_sdma
>>> usb_common firmware_class usbmisc_imx virt_dma phy_mxs_usb nf_tables nfnetlink
>>> ip_tables x_tables ipv6 autofs4 [last unloaded: mxs_dcp]
>>> [ 6961.239228] CPU: 0 PID: 469 Comm: mxs_dcp_chan/ae Not tainted
>>> 5.10.46-315-tiago #315
>>> [ 6961.246988] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
>>> [ 6961.253201] PC is at memcpy+0xc0/0x330
>>> [ 6961.256993] LR is at dcp_chan_thread_aes+0x220/0x94c [mxs_dcp]
>>> [ 6961.262847] pc : [<c053f1e0>]    lr : [<bf13cda4>]    psr: 800e0013
>>> [ 6961.269130] sp : cdc09ef4  ip : 00000010  fp : c36e5808
>>> [ 6961.274370] r10: cdcc3150  r9 : 00000000  r8 : bff46000
>>> [ 6961.279613] r7 : c36e59d0  r6 : c2e42840  r5 : cdcc3140  r4 : 00000001
>>> [ 6961.286156] r3 : 000008f9  r2 : 80000000  r1 : 000008f8  r0 : cdc1004f
>>> [ 6961.292704] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>>> [ 6961.299860] Control: 10c53c7d  Table: 83358059  DAC: 00000051
>>> [ 6961.305628] Process mxs_dcp_chan/ae (pid: 469, stack limit = 0xe1efdc80)
>>> [ 6961.312346] Stack: (0xcdc09ef4 to 0xcdc0a000)
>>> [ 6961.316726] 9ee0:                                              cdc1004f
>>> 00000001 bf13cda4
>>> [ 6961.324930] 9f00: 00000000 00000000 c23b41a0 00000000 c36e59d0 00000001
>>> 00000010 00000000
>>> [ 6961.333132] 9f20: 00000000 00000000 c13de2fc 000008f9 8dc13080 00000010
>>> cdcc3150 c21e5010
>>> [ 6961.341335] 9f40: cdc08000 cdc10040 00000001 bf13fa40 cdc11040 c2e42880
>>> 00000002 cc861440
>>> [ 6961.349535] 9f60: ffffe000 c33dbe00 c332cb40 cdc08000 00000000 bf13cb84
>>> 00000000 c3353c54
>>> [ 6961.357736] 9f80: c33dbe44 c0140d34 cdc08000 c332cb40 c0140c00 00000000
>>> 00000000 00000000
>>> [ 6961.365936] 9fa0: 00000000 00000000 00000000 c0100114 00000000 00000000
>>> 00000000 00000000
>>> [ 6961.374138] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>>> 00000000 00000000
>>> [ 6961.382338] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>> 00000000 00000000
>>> [ 6961.390567] [<c053f1e0>] (memcpy) from [<bf13cda4>]
>>> (dcp_chan_thread_aes+0x220/0x94c [mxs_dcp])
>>> [ 6961.399312] [<bf13cda4>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d34>]
>>> (kthread+0x134/0x160)
>>> [ 6961.408137] [<c0140d34>] (kthread) from [<c0100114>]
>>> (ret_from_fork+0x14/0x20)
>>> [ 6961.415377] Exception stack(0xcdc09fb0 to 0xcdc09ff8)
>>> [ 6961.420448] 9fa0:                                     00000000 00000000
>>> 00000000 00000000
>>> [ 6961.428647] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>>> 00000000 00000000
>>> [ 6961.436845] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>> [ 6961.443488] Code: e4808004 e480e004 e8bd01e0 e1b02f82 (14d13001)
>>>
>>> where dcp_chan_thread_aes+0x220 is the line
>>>
>>>     memcpy(in_buf + actx->fill, src_buf, clen);
>>>
>>> in mxs_dcp_aes_block_crypt. I also tried with the following patch
>>> instead of the one included in this series:
>>>
>>> ---
>>> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
>>> index f397cc5bf102..54fd24ba1261 100644
>>> --- a/drivers/crypto/mxs-dcp.c
>>> +++ b/drivers/crypto/mxs-dcp.c
>>> @@ -367,6 +367,7 @@ static int mxs_dcp_aes_block_crypt(struct
>>> crypto_async_request *arq)
>>>                                last_out_len = actx->fill;
>>>                                while (dst && actx->fill) {
>>>                                        if (!split) {
>>> +                                               kmap(sg_page(dst));
>>>                                                dst_buf = sg_virt(dst);
>>>                                                dst_off = 0;
>>>                                        }
>>> @@ -379,6 +380,7 @@ static int mxs_dcp_aes_block_crypt(struct
>>> crypto_async_request *arq)
>>>                                        actx->fill -= rem;
>>>
>>>                                        if (dst_off == sg_dma_len(dst)) {
>>> +                                               kunmap(sg_page(dst));
>>>                                                dst = sg_next(dst);
>>>                                                split = 0;
>>>                                        } else {
>>> -- 
>>>
>>> but got the same oops. Unfortunately, I don't have the time to
>>> investigate this oops as well. I'd appreciate if anyone else using this
>>> device could look into this and see if they encounter the same errors.
>>>
>>> [1] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-dgst-test.sh
>>
>>  Can you please share your kernel .config? David or I can test on our test bed.
>>  But will take a few days.

Were you able to reproduce these oopses?

--Sean

> 
> Attached. This is for 5.10.46, so for all I know this has been fixed
> already. But I looked at linux/master and didn't see any changes to
> drivers/crypto/mxs-dcp.c (other than the sha1/2 split).
