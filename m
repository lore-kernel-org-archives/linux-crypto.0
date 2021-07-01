Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD30C11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 20:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D320E6138C
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 20:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhGAUGr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 16:06:47 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:22084
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230139AbhGAUGr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 16:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=al7HlbOX3AJcnwz1J2WpsyTeJxE0KMMPZXz+KqOJrG2YzB9a1u1ONiMrigUacadYAttxZYqJCSQlh4Ie/KC6s9f5RVyPWOUhphZVLx+b1Fvr926pGZP8YeZqgwmIcI6JTEtl4tt/wJm+B9nTe0Xtkati8AMWV2GqKKzvPqeBbmFZSy0iuO6NfeTnPbiZj5LT9mTj/IHdsDRCXTX4cOZQ5bOuVAi/ZTD8To6VpH0lU79bB8nEZlHRku8H7YynyUeS6Ll5gz+w12E3wq5SW+cgZ0hwS02vDI1qsHVvcIAcxA5K31MTt58kjE1r14aD692FgKU/I3S8GO8Un9i1IcA25A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e44hTI3q2ey5lrWHjCubsDn/FLZALMr6rvnhBOuW2go=;
 b=F+Jk+qf1ifn9bZGxyjMP26e2V3TN6p0JOxCEf7KPxIV2lVp88+fKkBCaQReX9LH0RzwR42qhLn5jqdg5oRX1qer/MVPBa/f/n3GNaYwQgweWAl/chJMhdLEU0qOefGI7lc36dgISk+3kh08auX6QgloQvgHYHG4TCEgjIC2CbMgA2bzFUdqtg2Ga37sMLrmXO875G7nLw27plKgS8dsgCerCTfxsDfjbBCAPI/Ju8tJgCtki/zT358iDtxGeuL4yDSN2FQITn1dxgJj//s1jZqT3zRcKr9H2PoNN6yyQD5Fygt4krJPRHBN0vWbOX/e7iQjoqjrJH8cYUVUvjA1MaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e44hTI3q2ey5lrWHjCubsDn/FLZALMr6rvnhBOuW2go=;
 b=QLPx8U6f28/w6pbhVkGXiaVWFoEOqmljTjuiASFKiqzwLEdz7Yfs+cJRpQltdtdfeqw4XA/KE9S3mzPczKZrfA/s5usanEzVX0NYK+epQefjfpqmmfwvYmNag7LGPzhkyd+kvL5T19hLeRD27yJswswGj6hSRbNdE6FRbVoOPyg=
Authentication-Results: sigma-star.at; dkim=none (message not signed)
 header.d=none;sigma-star.at; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB5131.eurprd03.prod.outlook.com (2603:10a6:10:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 20:04:12 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 20:04:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
To:     Richard Weinberger <richard@nod.at>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
 <20210701185638.3437487-3-sean.anderson@seco.com>
 <1382866497.13280.1625169542979.JavaMail.zimbra@nod.at>
Message-ID: <fbc5fdbb-5e5b-31d6-d0a2-64332a7747ac@seco.com>
Date:   Thu, 1 Jul 2021 16:04:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1382866497.13280.1625169542979.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:208:160::34) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by MN2PR13CA0021.namprd13.prod.outlook.com (2603:10b6:208:160::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Thu, 1 Jul 2021 20:04:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ca8f38-8afa-4713-f654-08d93ccb651e
X-MS-TrafficTypeDiagnostic: DB7PR03MB5131:
X-Microsoft-Antispam-PRVS: <DB7PR03MB5131E64B080CC7AF4A104D7C96009@DB7PR03MB5131.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cPTIXeElMayiCafO0GQvkkSfFGfceHPSxG5AzAh3IM7sw3QQzU1hM9hxxCA2K69/z71HLFMY9+2yCTRCrxeBItcUUt6XeXsl8E6mGHqKQrmffS9Nk1ZWqWtXG6yQnx41aGU0XdQ+wXlYlTH+3aFMRX/nqj8RrGyW9ajPuF9uYI79QG2D4bydwVuR9w2SeW5lyxhqvrRgw+8K1b3QXc6y8i5df2NGC+7hXuBLNOapsC4p4J6+sg8xsIKU7S2Avl36J16/jrAAOlPQ17JwXhUy0GvYT0oAdOn2SH8juflBBTqFd/4o3xlgihEBZqISN7sANYGxM4icaGnQquNjlYS13mqvxmtfiD2/kU6siPtOC0l8+b15L+QZmCCgKsKOIndzirGTdza5P2MCXYf/u6FpCNYX+g6xs6UYqreL7QFOqG2NInnHiDejKVTTFxOQIk/3SBLrM+ioC4ASjpEP8hkUNHel1nJgpwnPcrKg4C1i5ebJJX2hN4Zxm6DiWHSAVkYLeOQCoIItSkj/5FYHAZRFbjpYhgNp2L2uuQIS4+S7QFmDhGpHUsBgrAuMEPXSSfMprL6hDOl/PvihqtwmIdr/aI+venLTuIBsJXqotWuMPkOONsohHo70Otaz/ll9x5Dwa2tGcLNuGCM+RaN4F4VWSxYLNr/Z+KZ44um+JeF4I7F0Q5QiQwTNXKakfyluoQAnCPoEhuVNKJ8rRi6y7f+G3pbvozt4SiwRUFHKGahC7yfzWurJgiILknREdwNfZDEnPxTNiR7zStHQybHEEIEPQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(376002)(366004)(136003)(346002)(396003)(6916009)(478600001)(53546011)(66946007)(66476007)(66556008)(52116002)(45080400002)(4326008)(186003)(26005)(66574015)(16526019)(6666004)(5660300002)(83380400001)(54906003)(36756003)(316002)(8676002)(31696002)(44832011)(8936002)(2616005)(956004)(31686004)(86362001)(6486002)(16576012)(38350700002)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlRLeFpFMDVKY1pCcmd2NHR4VDEyRVJubWkrYmJ4c1JkRDZPbzBFcjVqaWxs?=
 =?utf-8?B?dml6ZjhDUGpucE1pR3lPUDhLUW45WnErSWxlakNyU1JTOUZ0N1NJekVWdjR5?=
 =?utf-8?B?NWVxL2lzTnQ4aUJEYVY1QXcxQkhXOEROY05jQnB6NlNHWGJaUzR1VFowSDJs?=
 =?utf-8?B?V3B5VFJqSHNlOGNmdGJ2WUc4dzFVZG41ZlVvQmxuNEFkY2N6enZweVNsdUJ0?=
 =?utf-8?B?aTFiWjJiSHYzazgybGhrNlpuTk8xNGJtYk5WTmw1K3ZYTVh2eGtNYk5EQUEx?=
 =?utf-8?B?L0VFS0JOVzcvdTZMa3hnMVoyS0pCZjJObUh2ajVHVzRiWk5Ud0xZUVp1NFR6?=
 =?utf-8?B?K0NxYWQ5b1MvUjNzd01aQkJidE5yamIvR0E1V0NkYVZVbWkxMW1RdVpjUkVU?=
 =?utf-8?B?L0pKa1g3eS9QNUd4dloyK3RqQWU4bXFPdGs1UDFQNUtyUE5HRnFpR2ZzbkdD?=
 =?utf-8?B?ekN3TGtkWnhKcWFGQjAybnRwQjY3bDlRZi9GTWFLYWx2Yy9vYmlGR2t6TUNO?=
 =?utf-8?B?b210b0hsdWp5VCtQY2xLOUt5bXB3TlhwU0Vtem4wWEFuM0pvTHhFdXpoOFFr?=
 =?utf-8?B?ZVFTUVFjbGFHZmZxclJTMmh0M25EMGRWQnJHRUVDUFd3UVZHVWlMVFlIZnI0?=
 =?utf-8?B?ZVhocE9pSmVIeVFtNDRlWG5xNTVzVVBhdmZDdmxKMW9VTXNWeFhTYXRHZUp0?=
 =?utf-8?B?SFo3bFZwejNkaWo5ZHY1ZWFIbEtHNXVyZVVqcGVMQW1GaEd6Z28yN242RS92?=
 =?utf-8?B?d2Y0L0Z1NnNjeFFOcnZzb1RGb1dpdEptclJyOVRXa250R1gwQzhwWXBjS3FL?=
 =?utf-8?B?dUM0Nk5iSVBQd1Rqd2pGU3paZ0hKaTZsSmF1bXJGZlVlUitURUdGd1E5S0l0?=
 =?utf-8?B?VG1kYUJBcmx1RmtOOERFTG1aMjJvZDFHU3NhbWdveHY2VjhOWDhuNUNVNHpq?=
 =?utf-8?B?cWM3ZXNsRkZUQkRaemNrTXZDeGk5VGRhb3YrdzRSWnMzQW5zelZBVHF2MWw3?=
 =?utf-8?B?czdDMENINThkSGxFamkxVGo2bVY0dEIwQWxJNlJDNUxsUHhuUkp0bi91blp4?=
 =?utf-8?B?YXJLODJ3bWhHNldTa0NHekEvaE1TaVpCZHZXOVJlNlF3eWtiMnZIWTBjTEQ4?=
 =?utf-8?B?SDBTWi9TS2c2TVkxUWNsZ0lia2NZa0pGT3lpc3ovWFRsVjQ3MGw0eUpka1FS?=
 =?utf-8?B?ZDNpckVOeWdlUUVGbHRnSFY3aFFwNjdtWEUzZkNLNU9tWHhKK0E2d01jdThI?=
 =?utf-8?B?SHpRRXdEWmVxbU1Ja0E0VHJiRG0wUFZGWGd3bDBFV09ZOGU2cW5jRzlMVjF6?=
 =?utf-8?B?ZjF5cTdLaDFNSWQ2dnJ6SFh0eExFWmtQU2F6RngwbkRGY3lrd0NFa1k2SVpI?=
 =?utf-8?B?RERzSlFKdUhZTWhuSHRzd1d3YmphWm1pc2RwdTlZbDBQWTJQSWhrZzM0d2dn?=
 =?utf-8?B?S2ZVaUFoRUROb0dtM04yb1pzWUtJODBydlMzbGUrbXBmdkJYYnNOaHFCZzBP?=
 =?utf-8?B?VE0yc2VUbGFONVBVVmcrQmJkOHQ2c3F3NFdOd3pwRjlSQU9wNjNFKzN2aTdx?=
 =?utf-8?B?N01SaXBWcEp0cXFWejNkUnBLQnp5NGJSSnBjbUdNaThVYTRhbjIvSU1kMjBn?=
 =?utf-8?B?bk55b2RmQm9FL1N1Nmw4aC9IWEdLcEtyTllqSVVyTFlYTDJSTWRQdzd6dmt2?=
 =?utf-8?B?TVlXMEMyOUlEV21hZE9kQUgvVTYxTkhjKy9OSllxdUZGOUsyNXhEZWJqM20w?=
 =?utf-8?Q?T3fbxcleZ+FJdjpB3oPte9PEEdxkB68voevCk03?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ca8f38-8afa-4713-f654-08d93ccb651e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 20:04:12.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /n2f2VThf6H8dbY1Wi/LmVhjUVg8Wos5yW2WgSuHHGw2xxd+o4izCMG9rgfnQOun8vn0rkPfGCGHlgYfcr35+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5131
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/1/21 3:59 PM, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "Sean Anderson" <sean.anderson@seco.com>
>> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
>> <davem@davemloft.net>
>> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
>> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
>> <sean.anderson@seco.com>
>> Gesendet: Donnerstag, 1. Juli 2021 20:56:38
>> Betreff: [PATCH v2 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
>
>> This uses the sg_miter_*() functions to copy data, instead of doing it
>> ourselves. Using sg_copy_buffer() would be better, but this way we don't
>> have to keep traversing the beginning of the scatterlist every time we
>> do another copy.
>
> Huh? This does not match the code.
> You use sg_pcopy_from_buffer() which is just a wrapper around sg_copy_buffer().
>
> Did you forget to update the commit message? :-)

Yes I did. I ran into trouble with sg_miter_* since there is no way to
consume only part of a page (without touching the "internal" members of
the iter).

--Sean

>
>> In addition to reducing code size, this fixes the following oops
>> resulting from failing to kmap the page:
>>
>> [   68.896381] Unable to handle kernel NULL pointer dereference at virtual
>> address 00000ab8
>> [   68.904539] pgd = 3561adb3
>> [   68.907475] [00000ab8] *pgd=00000000
>> [   68.911153] Internal error: Oops: 805 [#1] ARM
>> [   68.915618] Modules linked in: cfg80211 rfkill des_generic libdes arc4
>> libarc4 cbc ecb algif_skcipher sha256_generic libsha256 sha1_generic hmac
>> aes_generic libaes cmac sha512_generic md5 md4 algif_hash af_alg i2c_imx
>> i2c_core ci_hdrc_imx ci_hdrc mxs_dcp ulpi roles udc_core imx_sdma usbmisc_imx
>> usb_common firmware_class virt_dma phy_mxs_usb nf_tables nfnetlink ip_tables
>> x_tables ipv6 autofs4
>> [   68.950741] CPU: 0 PID: 139 Comm: mxs_dcp_chan/ae Not tainted 5.10.34 #296
>> [   68.958501] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
>> [   68.964710] PC is at memcpy+0xa8/0x330
>> [   68.968479] LR is at 0xd7b2bc9d
>> [   68.971638] pc : [<c053e7c8>]    lr : [<d7b2bc9d>]    psr: 000f0013
>> [   68.977920] sp : c2cbbee4  ip : 00000010  fp : 00000010
>> [   68.983159] r10: 00000000  r9 : c3283a40  r8 : 1a5a6f08
>> [   68.988402] r7 : 4bfe0ecc  r6 : 76d8a220  r5 : c32f9050  r4 : 00000001
>> [   68.994945] r3 : 00000ab8  r2 : fffffff0  r1 : c32f9050  r0 : 00000ab8
>> [   69.001492] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [   69.008646] Control: 10c53c7d  Table: 83664059  DAC: 00000051
>> [   69.014414] Process mxs_dcp_chan/ae (pid: 139, stack limit = 0x667b57ab)
>> [   69.021133] Stack: (0xc2cbbee4 to 0xc2cbc000)
>> [   69.025519] bee0:          c32f9050 c3235408 00000010 00000010 00000ab8
>> 00000001 bf10406c
>> [   69.033720] bf00: 00000000 00000000 00000010 00000000 c32355d0 832fb080
>> 00000000 c13de2fc
>> [   69.041921] bf20: c3628010 00000010 c33d5780 00000ab8 bf1067e8 00000002
>> c21e5010 c2cba000
>> [   69.050125] bf40: c32f8040 00000000 bf106a40 c32f9040 c3283a80 00000001
>> bf105240 c3234040
>> [   69.058327] bf60: ffffe000 c3204100 c2c69800 c2cba000 00000000 bf103b84
>> 00000000 c2eddc54
>> [   69.066530] bf80: c3204144 c0140d1c c2cba000 c2c69800 c0140be8 00000000
>> 00000000 00000000
>> [   69.074730] bfa0: 00000000 00000000 00000000 c0100114 00000000 00000000
>> 00000000 00000000
>> [   69.082932] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [   69.091131] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> 00000000 00000000
>> [   69.099364] [<c053e7c8>] (memcpy) from [<bf10406c>]
>> (dcp_chan_thread_aes+0x4e8/0x840 [mxs_dcp])
>> [   69.108117] [<bf10406c>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d1c>]
>> (kthread+0x134/0x160)
>> [   69.116941] [<c0140d1c>] (kthread) from [<c0100114>]
>> (ret_from_fork+0x14/0x20)
>> [   69.124178] Exception stack(0xc2cbbfb0 to 0xc2cbbff8)
>> [   69.129250] bfa0:                                     00000000 00000000
>> 00000000 00000000
>> [   69.137450] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [   69.145648] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [   69.152289] Code: e320f000 e4803004 e4804004 e4805004 (e4806004)
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>> Changes in v2:
>> - Fix warning when taking the minimum of a u32 and a size_t
>> - Use sg_pcopy_from_buffer to properly deal with partial reads.
>>
>> drivers/crypto/mxs-dcp.c | 36 +++++++++---------------------------
>> 1 file changed, 9 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
>> index f397cc5bf102..d19e5ffb5104 100644
>> --- a/drivers/crypto/mxs-dcp.c
>> +++ b/drivers/crypto/mxs-dcp.c
>> @@ -300,21 +300,20 @@ static int mxs_dcp_aes_block_crypt(struct
>> crypto_async_request *arq)
>>
>> 	struct scatterlist *dst = req->dst;
>> 	struct scatterlist *src = req->src;
>> -	const int nents = sg_nents(req->src);
>> +	int dst_nents = sg_nents(dst);
>>
>> 	const int out_off = DCP_BUF_SZ;
>> 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
>> 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
>>
>> -	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
>> 	uint32_t dst_off = 0;
>> +	uint8_t *src_buf = NULL;
>> 	uint32_t last_out_len = 0;
>>
>> 	uint8_t *key = sdcp->coh->aes_key;
>>
>> 	int ret = 0;
>> -	int split = 0;
>> -	unsigned int i, len, clen, rem = 0, tlen = 0;
>> +	unsigned int i, len, clen, tlen = 0;
>> 	int init = 0;
>> 	bool limit_hit = false;
>>
>> @@ -332,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct
>> crypto_async_request *arq)
>> 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
>> 	}
>>
>> -	for_each_sg(req->src, src, nents, i) {
>> +	for_each_sg(req->src, src, sg_nents(src), i) {
>> 		src_buf = sg_virt(src);
>> 		len = sg_dma_len(src);
>> 		tlen += len;
>> @@ -357,34 +356,17 @@ static int mxs_dcp_aes_block_crypt(struct
>> crypto_async_request *arq)
>> 			 * submit the buffer.
>> 			 */
>> 			if (actx->fill == out_off || sg_is_last(src) ||
>> -				limit_hit) {
>> +			    limit_hit) {
>> 				ret = mxs_dcp_run_aes(actx, req, init);
>> 				if (ret)
>> 					return ret;
>> 				init = 0;
>>
>> -				out_tmp = out_buf;
>> +				sg_pcopy_from_buffer(dst, dst_nents, out_buf,
>> +						     actx->fill, dst_off);
>> +				dst_off += actx->fill;
>> 				last_out_len = actx->fill;
>> -				while (dst && actx->fill) {
>> -					if (!split) {
>> -						dst_buf = sg_virt(dst);
>> -						dst_off = 0;
>> -					}
>> -					rem = min(sg_dma_len(dst) - dst_off,
>> -						  actx->fill);
>> -
>> -					memcpy(dst_buf + dst_off, out_tmp, rem);
>> -					out_tmp += rem;
>> -					dst_off += rem;
>> -					actx->fill -= rem;
>> -
>> -					if (dst_off == sg_dma_len(dst)) {
>> -						dst = sg_next(dst);
>> -						split = 0;
>> -					} else {
>> -						split = 1;
>> -					}
>> -				}
>> +				actx->fill = 0;
>> 			}
>> 		} while (len);
>>
>> --
>> 2.25.1
>
