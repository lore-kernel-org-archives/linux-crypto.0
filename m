Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D983C47094
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 14:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D341610E6
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 14:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFJOyJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:54:09 -0400
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:33957
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231337AbhFJOyI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 10:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKVA7SY7UFH+W1Z5F+bNWw5CBNEXt5mTrO4S6QN+xS4+wPMJ6Pl2WGUthlJ678MrDZ7GAyHwb1v/eR26tPfME0xq4s83LkFCKmz3+hsMy3SKDhdvXVWPGzFz7Qjl5kBmIekyMhcjMsgHigS8DX3pWrEN+idRie8K9H6krD3PEstdGFtMNn0/m9gy1bDOfN/5s0iqVdCtqYuHU15z2hlWjexVh3r4XHiFvq3GC4tdJLIPGE0afmsQtnteLk6jEmj8Lsw1O5J9ULI4IsOPJtUB2m8NAq5C0SkeOJaTejYeoS5+VLb+zcPhsXVCtnusJBH35EZE2p8d3FpMad016uI6pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+putAtfRiM2iBKqceOyA10Rf3OE07Fy+GsVAKbVMFzI=;
 b=b2fcmiKgjr1kIHNO5QtLkvmmu2TkNowxX7agOjlBvkNh195Bqel56ABaKG6jS6byMAkSovTEresPA/IfnfpP7JKND6VPpS/gzUIA8jR6KK8Pk+X5a7yqRaCWEMVUDoQijkYCGl0BtcA8ImXu5XFHwATDrZtaOJYksGOlbIzYOpiqWhYzxYSeJ3ibBNDnkTYjYv0H+Q3k56svJP8OJOorT3+DYbHJb2pofexpCYU/Lcfeic2iIdmD9IAuqd+zyn0TKuWPvyePkxtcWO8Zj4eGj2Oi35FntBaM6wetL8cjjwKBEfPQzpjMkL22UV/CAvSwEY/ChNKD/CjiCM97DfuxRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+putAtfRiM2iBKqceOyA10Rf3OE07Fy+GsVAKbVMFzI=;
 b=k/v/aCrJmcYiY+o2yYu5/Pt2qYZwPgjfy9pykOCWs5OAGqGp7/DooazFTaMgGYUwGmG4JQaPYyNm0gnG7trWxyIld0iayQWpfaeCV6HrnZvgYCOTSuszWlyGlUl80Yo2NTquLrXOS7WXYb2oQmOCfwW5On/tjtfDDDBONCew+aM=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4048.eurprd04.prod.outlook.com (2603:10a6:803:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 14:52:10 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 14:52:10 +0000
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
Date:   Thu, 10 Jun 2021 17:52:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YL7XXNOnbaDgmTB9@atmark-techno.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR04CA0131.eurprd04.prod.outlook.com
 (2603:10a6:208:55::36) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM0PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:208:55::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 14:52:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a1fd4c5-35aa-41ba-b4e9-08d92c1f531b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4048:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB404803EE388E9643F578659898359@VI1PR04MB4048.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xh5AAVHc/0r+Q/6paQlib+U4Wq5v41XOQbxdzL9cVfnn3PYWghw/8GpQgpn602X1SrtspvWXF1C492V4jW9vPohGQQMsPMdHvDRBqAJ4HakaCLMaN0iyjxYU09bRKVJTtAuD32slCUVZTmNwlCmE3QjIvnH4TrwUs8mIImQD7ENwtpHbonNJFDByP/jvOdvqXs6vFqI2bj8ZcXYSjFg3gBVoxUOY1XRMLplljgMqs3LWoRWrRyCBh2gK9KLC+CcTNKIzBpzDZ5wdUQ+pKe+Km8vAU2Z4CpkilVIsgv1ctrT7ImTHinGgEE4WsfeMInVZHhHsgPWDi5n/7J1st/7vLtrtOckky5RhVTC0dKechu/fQm8jYbHQiRe0s/qi5WPQiRR72dwsQOaGUaP4t03Jv5+bMfp4WOzR8kSZyv3VuwZL/D6XTSbF4q5YlQIStYWhyoAs+MinU1TfppxAmf9pNRcWMd6lRV3JoCkrCMCuD546TzY7EJ4I+zsr4Pai3LSrq9rmDTQkf64MSoG3JO+eP7L+ajepnDsrAY/MvTBpqGDjyYv9+ojNeZR8CNzgKL8IJpYvEsRyOyg/ms8Pi909BlsQd9MfCZYbHpyvUZp2GvqkXBTsEfO6QMn6HjU0HZSm1uTaCX6LABvD/UwDxwzFXBoNQmZuHcDh1Yf8zAo7cMaMZdbdBopkOLhgWu6ETzhDyVzzMXyD+iSggNs8BpSEcbC2xdA3kb5vw6MS/f4yTky3wFsFXY97OmOnx66EWisXYJFGiOdQN6CU20pn7UYW0W97oA8sMMQPcWeYM+GQ8xevF3xB8Wx6FeMgGKuwUZABrHuwH2lQ4kaD02ecI3sBkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(38350700002)(16576012)(38100700002)(45080400002)(478600001)(8936002)(110136005)(54906003)(2616005)(966005)(83380400001)(5660300002)(31686004)(36756003)(26005)(4326008)(53546011)(66556008)(316002)(66476007)(31696002)(52116002)(86362001)(2906002)(66946007)(956004)(6486002)(186003)(7416002)(16526019)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UTVQaXN1bWpjUmJkUFdheXhxd1lkZHdNdlFBOG9PZTl6TGVtbVMxQ2hpY25n?=
 =?utf-8?B?dXdCRjNnekhRUjR4ZUViMGRsYit1UGM4MFdMSzN5cFNIWmRHUTJWaXV2ckda?=
 =?utf-8?B?djVTUFNHQmM1cXN6SlBTSEo5N2JjYXVoMWNNR2VCcEltcFhPcVJkOU5sVk5J?=
 =?utf-8?B?TTZoa1hoeEw1c2hNK0pNb3FZamxlV1JUWTUzQU1xUnRYZEpicE84Nld5WnUv?=
 =?utf-8?B?Mi9uNUcyUDNaM3cyL0RvaEtIS2JsK2dwSjZqZFZ0M1gvV050Z1p2R0VjZk44?=
 =?utf-8?B?bmlRYmhvME9tQzlkTFM2SlIyeW92RnFkU1BaZEZGYzVzZWpQNlJhK3Zzcndo?=
 =?utf-8?B?Rk84YSt5ZFF1Snl5ZlV4U1lTVjJBV0pkS2paSDB2d0IwSWxsRUxXQ0hCSGxv?=
 =?utf-8?B?U0VQUDVjWUFoKzJLdm9Jc3BWK01QSGwwMGZIaW5YK2thUXhmME5idTh4S09J?=
 =?utf-8?B?aFd6cHhtSnFETDc2ZHRjeFFRZk5mLzNVTkZvTzVSN3JZQ2RRVVJqOGY2SlY3?=
 =?utf-8?B?eVVFQ2JmVC9wQzdoWVAwTEk2MStTMjl1dTJteTJYRHpTYis5L0ZsbFYwTytX?=
 =?utf-8?B?UlFIdHRVbW1uaUNQTGVQK0Z5VCtHNHdVK0JWR0dWRUJ4b1R6RVM5b2h3eklE?=
 =?utf-8?B?SWx4MnJ2NjZ4a1VRZWEvOUI3aEc0ZnlRa0UxOHpTS09ZR3Zlb21HV0JiNEdn?=
 =?utf-8?B?bHFZaS9OQmMzQnp2R0trMm9CazJQZm0xOFRyRHRKSDNtK0NNekZBMWdhSlll?=
 =?utf-8?B?ZFc2OXZ6bkpmRFZWL3pIRTc0cWhlZWRZazF6U1Rnd21paGFKbVlxemh6SnhR?=
 =?utf-8?B?MGRmZnM5QzIvSmtwY3lzR1hMRnhNOStiWjhacC8wN005UTRsOWVpcW9RRmVy?=
 =?utf-8?B?OGc1VE92aXpNaE8rMlRYYktHS3pnUjI2UTk4Z3lZVlArRUZsaEpQOXllN091?=
 =?utf-8?B?M1l3Q1lNSFZZWFFzR2I0cmgwbGlNbDZ4eE1UT2NtMmVzZjZxajVobUc3K3Yx?=
 =?utf-8?B?eGI3Nk9VYlNGbE5ma09IajRhd2NwQnp1NDZnd2luYzFaT0VGZjB2SWNwN1ox?=
 =?utf-8?B?M3paTitBS1JnL2Z1U21ydDZNNkx1M0hVTy95dGp4S0ZpZDhIcGJ3emdPYzNo?=
 =?utf-8?B?VEFtc09RdEdiOCtGVldxdlZpUXVZZ2R6eS8xdk1pVU1RaWt1M1dGOEFsY2U5?=
 =?utf-8?B?VmNFdk8xRTFqMmRGTXVyb1dRaDBTTlYySjZpZzFyZG50Q0pSczloMjVuY0px?=
 =?utf-8?B?aUN1czUvVVJicjRzelArbVhIa0pHRURQRjBYbzNLWEIvMjlXQ0Z5OVhBK0or?=
 =?utf-8?B?aWdzN3ZUM3c4L0p6Y3RJMm9hcnhZS3Y3VzM5Z0ZNUkpmTDVpL3JXZG9wZ2lw?=
 =?utf-8?B?NUkzaHhFNkhQdFZWUjQxWFVQalRCQTFDQ2JONGRrWG96bjBTanQ5NUlqWkFH?=
 =?utf-8?B?aXB2NTNqVGIrQ0ljUm4xZXpud2diWk0vdXNCNkgxZ3EvQ0pVaGkwVkRUUmhD?=
 =?utf-8?B?bDA0TGdYeVdmT0VoTFhPK1BrTElFTHFtV3Z2L0VRWXIvRGdpZTlDaGdPUlhT?=
 =?utf-8?B?eTJlV1lvMFhwYmZCeEdtdG5LTExLYTFVMXYyaWZpOG00R29kcEtUMkxFL2FC?=
 =?utf-8?B?MG12RHJrNjFHZElLY3NGQmgyVVFoTjNzUFRGN21CZ2N3YnhEKzYxVExDMzRk?=
 =?utf-8?B?UXNtTTd2NDYwVW1KRHNSeXdDalJJaGhZa2JXT2g0MW91SUU5YnljbVhLcExt?=
 =?utf-8?Q?TvPFlu98O3oRyZkbwywfyYoiyfn//xBYkyGlQwt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1fd4c5-35aa-41ba-b4e9-08d92c1f531b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 14:52:10.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxiJUdWkNjXNfAahzWa6om8Rg1S9NANYUtAumj/+/ktAQAZF2DTTil/hp2jEIL7Qtu6qTjyrqMJXSUwpH53H3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4048
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/8/2021 5:35 AM, Dominique MARTINET wrote:
> I'm not able to find any individual mails for Christoph's patches so
> replying to the PR.
> 
The patch set is here:
https://lore.kernel.org/linux-iommu/20210207160327.2955490-1-hch@lst.de

> In particular, this commit:
> Konrad Rzeszutek Wilk wrote on Fri, Feb 26, 2021 at 11:00:08AM -0500:
>> Christoph Hellwig (8):
>>       swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
> 
> merged as 16fc3cef33a0, breaks caam as used today (thanks Lukas for
> bisecting it!)
> 
Thanks.

I've noticed the failure also in v5.10 and v5.11 stable kernels,
since the patch set has been backported.

> 
> More precisely, drivers/crypto/caam/caamalg.c does a lot of mappings
> that aren't aligned:
> 
> dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
>                            desc_bytes(desc), ctx->dir);
> dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
>                            desc_bytes(desc), ctx->dir);
> 
Right. These dma sync ops are in caaamalg.c and should be fixed.

OTOH there are other dma sync ops in caam driver - e.g. caamhash.c:
	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
				   desc_bytes(desc), ctx->dir);
where the mappings are aligned (see struct caam_hash_ctx),
but even in this case the crypto algorithms are failing.

> 
> which can be caught by crypto tests with this caam enabled, for example
> adding a warning when an unaligned mapping happens I get this trace:
> --------
> [ 1628.670226]  swiotlb_tbl_sync_single+0x74/0xa0
> [ 1628.674677]  dma_sync_single_for_device+0xe4/0x110
> [ 1628.679472]  skcipher_setkey+0xd0/0xf0
> [ 1628.683224]  des3_skcipher_setkey+0x74/0xac
> [ 1628.687416]  crypto_skcipher_setkey+0x54/0x110
> [ 1628.691866]  crypto_authenc_setkey+0x94/0xd0
> [ 1628.696138]  crypto_aead_setkey+0x34/0x10c
> [ 1628.700236]  test_aead_vec_cfg+0x3a0/0x770
> [ 1628.704338]  test_aead+0xac/0x130
> [ 1628.707656]  alg_test_aead+0xa8/0x190
> [ 1628.711324]  alg_test.part.0+0xf4/0x41c
> [ 1628.715161]  alg_test+0x1c/0x60
> [ 1628.718307]  do_test+0x37ec/0x4c50
> [ 1628.721709]  do_test+0x4bec/0x4c50
> [ 1628.725114]  tcrypt_mod_init+0x54/0xac
> [ 1628.728864]  do_one_initcall+0x4c/0x1b0
> [ 1628.732701]  kernel_init_freeable+0x1d0/0x234
> [ 1628.737060]  kernel_init+0x10/0x114
> [ 1628.740550]  ret_from_fork+0x10/0x24
> -----
> 
> and the tests themselves also fail (all or at least most of them) with
> e.g.
> ------
> [    8.454233] caam_jr 30901000.jr: 40001713: DECO: desc idx 23: Header Error. Invalid length or parity, or certain other problems.
> [    8.465820] alg: ahash: hmac-sha256-caam final() failed with err -22 on test vector 0, cfg="init+update+final aligned buffer"
> [    8.477149] ------------[ cut here ]------------
> [    8.481781] alg: self-tests for hmac-sha256-caam (hmac(sha256)) failed (rc=-22)
> [    8.481818] WARNING: CPU: 2 PID: 295 at crypto/testmgr.c:5645 alg_test.part.0+0x128/0x41c
> [    8.497307] Modules linked in:
> [    8.500365] CPU: 2 PID: 295 Comm: cryptomgr_test Tainted: G        W         5.13.0-rc5-00002-gc98cdee6172e #23
> [    8.510455] Hardware name: NXP i.MX8MPlus EVK board (DT)
> [    8.515767] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> [    8.521778] pc : alg_test.part.0+0x128/0x41c
> [    8.526050] lr : alg_test.part.0+0x128/0x41c
> [    8.530324] sp : ffff80001371bd10
> [    8.533637] x29: ffff80001371bd10 x28: 000000000000008f x27: 000000000000008f
> [    8.540785] x26: 000000000000008f x25: 0000000000000400 x24: ffff8000111658c8
> [    8.547930] x23: ffff0000c02aaa80 x22: 000000000001008f x21: ffff0000c02aaa00
> [    8.555075] x20: 0000000000000085 x19: 00000000ffffffea x18: 00000000fffffffc
> [    8.562221] x17: 0000000000000001 x16: 0000000000000003 x15: 0000000000000020
> [    8.569365] x14: ffffffffffffffff x13: 00000000000003e7 x12: ffff80001371b9e0
> [    8.576511] x11: ffff80001188c940 x10: ffff800011844300 x9 : ffff800011886b98
> [    8.583658] x8 : ffff80001182eb98 x7 : ffff800011886b98 x6 : ffffffffffff0888
> [    8.590801] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
> [    8.597945] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c1684e00
> [    8.605093] Call trace:
> [    8.607540]  alg_test.part.0+0x128/0x41c
> [    8.611467]  alg_test+0x1c/0x60
> [    8.614608]  cryptomgr_test+0x28/0x50
> [    8.618275]  kthread+0x154/0x160
> [    8.621511]  ret_from_fork+0x10/0x24
> [    8.625088] ---[ end trace 2d195377ee3c219e ]---
> ------
> 
> 
> 
> Looking at it a bit further it seems to me that swiotlb_bounce() should
> either keep the offset (re-adding the line that was removed except it
> would go back in swiotlb_bounce, diff at end of mail), or the size
> should be adjusted to cover from the start of the page up until the
> original offset + size which would also probably work (not tested)
> 
> That, or make unaligned mappings forbidden and warn when we see one, but
> I have no idea what other component could be doing some -- I'm not sure
> if what the caam code does it legitimate (e.g. would it be possible to
> do the mappings once at init and use them?), but the swiotlb code
> doesn't look quite right.
> 
Well, it's not only about unaligned accesses.

It's also about partial syncs, e.g.
	dma_handle = dma_map_single(dev, cpu_addr, size, DMA_BIDIRECTIONAL);
	[...]
	dma_sync_single_for_device(dev, dma_handle + offset, size - offset,
				   DMA_BIDIRECTIONAL);
(where dma_handle + offset should be cacheline-aligned).

Documentation/core-api/dma-api.rst explicitly allows for partial syncs:
Synchronise a single contiguous or scatter/gather mapping for the CPU
and device. With the sync_sg API, all the parameters must be the same
as those passed into the single mapping API. With the sync_single API,
you can use dma_handle and size parameters that aren't identical to
those passed into the single mapping API to do a partial sync.

AFAICS commit 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")
is breaking this functionality.

Thanks,
Horia
