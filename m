Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BB0C2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 14:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B79561969
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 14:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhFYOvg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:51:36 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:3040
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231668AbhFYOvf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 10:51:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPHA5fe01n2yISx8fzYJZV32TuAvxyw7amFS2dkAI1W1BWMy4jkbOp/acI4QWFeg1bHgImX4u6/aQKCw8OFubu2vzvDjDcDe4K0Qnnglxu4BwC1PIfbMZAGHB4hQD0Q+ofC3lkp5cIaHXNelz10b3KxblGI+kPJCKO6tLxexeFgV7WfuFkwauOPbN1Sx71POt8hA3tWEwBgP6pGhgxVDTSGN2pX9PCfIulxw/Klmo2JBm/T3clxoClFB2U0L41yryKq6Au0BhZi7C/NzVNCqGsBdndxsc32DEba5Si86rloFnPyPX71TKeuY9uPUf7/bCvyJdRMVz4jqDSOsZzNmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmQ4LkOdnp9GGZwEhYIhqTbUWQj3ogCUGR16Lp4ozwM=;
 b=fQnhR10nDVvLBUMJS2ci1IwSwknkrzUs8FlCadrPp3ERP7Xl+CTFnWZRo9ZLBcYnwHIx0mz3BSK6r8zzKJEd4hS2m9EBo44JXCOeQWwlic++QiokVmU9G7Bve2YbXlHKzjXsFolMVeRS4kFSMWO1QGkRT78cLg6Rp99AD1CB4j1bTCqFK5/oh49lAAt790tap+RIW2ffhylVn/7ofKX1eWcC/Y3agleG9AmcmMMV+oyQ4MXafNlcc5mTQlPkOX6PgCfgvHN1ZwALxPdN+phtP2cdvYa5c9P3jVHHtKM/p0wsEYQ99ixp129JzmBzzJB15KpLJrvNjhnZqe9z4vfjeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmQ4LkOdnp9GGZwEhYIhqTbUWQj3ogCUGR16Lp4ozwM=;
 b=yd1DxA9L5wHdZgL0ueA4MbtYwgLiAle47qhUB6nXEoFh8sPLjeVoG59lFaCqfhs2c5k/oO8+hqXb0NxZA2x4J0ZI8Ol/PonBJwyum0yOuZvAy6c1u/KPYXxRPMlgLyPUvGF9MWK/Dt3LYM4O6Eo49MdaRv0SgcaRI2Ul7+Il/n4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3513.eurprd03.prod.outlook.com (2603:10a6:5:6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.19; Fri, 25 Jun 2021 14:49:13 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.020; Fri, 25 Jun 2021
 14:49:13 +0000
Subject: Re: [PATCH 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
References: <20210618211411.1167726-1-sean.anderson@seco.com>
 <20210618211411.1167726-2-sean.anderson@seco.com>
 <20210624065644.GA7826@gondor.apana.org.au>
 <dfe6dc8d-8e26-643e-1e29-6bf05611e9db@seco.com>
 <20210625001640.GA23887@gondor.apana.org.au>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f3117c42-7918-3d32-059e-4e6c338a781a@seco.com>
Date:   Fri, 25 Jun 2021 10:49:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210625001640.GA23887@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: BL0PR0102CA0034.prod.exchangelabs.com
 (2603:10b6:207:18::47) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by BL0PR0102CA0034.prod.exchangelabs.com (2603:10b6:207:18::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Fri, 25 Jun 2021 14:49:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33cb81a8-6615-4da3-cff4-08d937e865d5
X-MS-TrafficTypeDiagnostic: DB7PR03MB3513:
X-Microsoft-Antispam-PRVS: <DB7PR03MB3513A4508C384822E8180FEA96069@DB7PR03MB3513.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:181;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKJA2t8x3hGMg1EfZOEhkdBp1eqCvOddYkeOUJX/MEHxqwOdQ6EtjR8gHxkAskBvh1rjDyqj4oe/YuhCyebdXABqVyNtuN2MTJxrmFeQDCshMc6LcqPBjrEdKDQJX8iMzKDNCS6J/qMwcxpzev3tYGeYeNorsf8iqFgcOOPoBBlIsFCymuR4yJKWrfclZFdKJxYQhJq1HaBu6XraAvwrqQ2qakerMybJL+BmSiQg+tP6ZP9zWJeY4JUKg1X+0hrLK++RTbXzpS81H6LEtFrTiPou/ith69uDR87FuFYQP24DTku4i4YtIDrhm5ExYtIFR2VoYKQ5+3gyUir5MnjSfGGvpZ/n9haFKizJByDdSwY0st6eMNuLRp2o7DYl0O0fr9qERPG/0oaawzSyLVovp6tkIngnTYCwka3rxsn7hSb8QUyD1pzQq9DdpJfdZ+eIix3WPadRx5VoH4SQm6oikgfK44stXnOjFCwmTz5UMygJE7/05XM6qyxCahVFNjUvAFWtu/X9Ms7V8jK1OKFhqHjxaGAwClFkicAr1lwBDDsUTqhjBTMgn2VS2Yb6VkLW+2nnurnOIApYsjZsGQEdSQ+Bj+PjH1HAxjBiwwWyjo2UE+ZONtT6w+3W8uTwFb6qFP1gNguNiR9OUNA5MZimCOtjZzSM3yJ5xc86A8m9YapIlJBW/fNHEQUnhUdPd9qL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39840400004)(366004)(346002)(376002)(316002)(4326008)(8936002)(8676002)(54906003)(66556008)(6916009)(5660300002)(66946007)(16576012)(53546011)(66476007)(52116002)(2616005)(36756003)(956004)(2906002)(86362001)(38100700002)(38350700002)(186003)(44832011)(31696002)(26005)(6666004)(6486002)(31686004)(478600001)(16526019)(4744005)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVJVdEtpMmNuNWMvZWptUHlDMnhaaTU1dGVsSU12bnRDMGtmUDYza2gvZ2VY?=
 =?utf-8?B?MjhSdE1HcWUxbWdoOWtWaDFKNXJBZklNT1QwdkwyTWthdUpZdnRKQjNMci80?=
 =?utf-8?B?aVBQNHdIQkV2aFQwOGVkVXZ1L1JtRE5uQnhhWUNUL1VjaWNwUVZRcmpSRmtH?=
 =?utf-8?B?V2pXUU4yUVhtVWI0dnMxMWFxMEVWa3c0R1czcHZHekQya0ZXeWkyUjBheG5R?=
 =?utf-8?B?czhxclc3WVR2MHBkNWtxR2FkdGhCRndSMXppMldKR1ZtQjdQYTJJWW9OZ0Nr?=
 =?utf-8?B?OU5DL0Y2ek5EalFta3JHdFM5bEg0N0JESDdEeDhJQndxL1lwajBQdHR5QXk3?=
 =?utf-8?B?KzJJOWVsNkRqR0wyaVRIeSt0dVlOSlFwb0Z3Z0JKRFlkWFFoNmxteWVpalRr?=
 =?utf-8?B?TVRJZDRHU0hOSjRxeVh1WEtxektyY0p1SFRON2xFNzlqcjBzZi9DRElhc2po?=
 =?utf-8?B?ejNWWnMvS05FcUJQbVNZcUI3c2N6d3RteWJuVk1FTExmSDM0djJEem0zUnRQ?=
 =?utf-8?B?ZnBsN2t3UUMzeFB1NUUvU28rYis0V255bTdhYmloNzdyQ3pMbHpXakI4K2gx?=
 =?utf-8?B?cmEvbDJIWmV3Wk1vSjNBcFEyb0ZlVzZMd1Nia1hudWs1aXIrQmlXY2YzUXFs?=
 =?utf-8?B?RUorMlQ5dEdjWmM4em5IWXorTmJ6QllVVVUzWlZnZFMwbFV1WEhrTWI5OXA4?=
 =?utf-8?B?WHp2UmJUdTBrbE1rc0dLdFRubzJ2cVZaQmpMOW15ai9wZm5PbXVOV2Y5TDNh?=
 =?utf-8?B?Z1pKUzdFRUtnMWNadEZxNXNLajR4UGQ3WjZkMFM3VzdYN3pCUEx2MExRWHZs?=
 =?utf-8?B?bHNOcnVnRk40R0d0ejRzWThNcXE2eEM4Z1V2K0l6bEhSMmtRS01ISDNZMDlX?=
 =?utf-8?B?THBxNWhVQ09xZ0pZa1Avdy9aUGJZTEdidTVrbDMyamNlL0JpRTVvS3ppWTdL?=
 =?utf-8?B?VlA3UC9iNXJLbVBMMWRCcW8ra1JtSVltSHhDZjdSc2hMc2o2b2JpUWFqQ3dh?=
 =?utf-8?B?bnV5SnZIWmRLZktWZzIrSWdmczd3NHlsaDJyUy9kbFN5bXB6ZVRnamlWYWpx?=
 =?utf-8?B?cC81RWZwckhxWGdGMXoydFI1Q09UZ2o3NkVjQk44anQrRmRXdmNmSEVpdGNV?=
 =?utf-8?B?UHVwcEpBOVdlK1lPWTRjVEZLd1VUcmphbXdqMTIvVHJxVC85RVQyc3pvcXJi?=
 =?utf-8?B?MHEvRi9mczFJQ0pvRVBtRnh6RnNxbHdITjUreW55WXJtMmRpa2x0ZmZHY2VP?=
 =?utf-8?B?U093cGY0bkROMldNaTJ4dUwzWU53SHUwQ29wQ2NwbjkvbkhFTmsvVXZKTHpo?=
 =?utf-8?B?eHRFRmFEVEdwLzJKamY1TlZId3g5c1BEWUYybmxTeGU3Tm10bnlHRVFXWEVG?=
 =?utf-8?B?V3dTcC84anpmNUpSWUZreWJHa09mTWN1ZDE0UU45U2VVMk1uaDBpcmlpNnBS?=
 =?utf-8?B?emRHZjFVVWF5c2ZXbXRiYlRxbVVOdnBmdDYzSVUrVUhTVHFjOEllUktKdlQx?=
 =?utf-8?B?ZUZ0R0hxRW1TUXJyZzNoVUdWbzRGVE5XUFFuck5veFRkeFU0VmJjQzJJWnBX?=
 =?utf-8?B?MlNwaGxyaXJEWGxMdkhkY0RySTVwM0wvcVFxdTY1QisvRVVzcDZ3S082RWpz?=
 =?utf-8?B?TTAybU9jU0dFTjhWVENDT3NBTUZNRk96VXpCRmhDL0VDOGkxcFY1OUZLNm9K?=
 =?utf-8?B?VVpVSzVreTJPYUdYSTZFdGk5ZHV1M3h2YkZ3Mlp4T3ZrQ0V0aklvRWRZQ2pu?=
 =?utf-8?Q?UHcXbKCs+P8BdNADdePCgBo6myO4/TOZesJVPxa?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cb81a8-6615-4da3-cff4-08d937e865d5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 14:49:13.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toVCo3dMrdi7LNBdWHxlhYDuZa9WXr37KPX+96S2UaynKCnPDXlXrWMYmePvYL4pC1ewje1STG7ObGSKVJqA4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3513
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 6/24/21 8:16 PM, Herbert Xu wrote:
> On Thu, Jun 24, 2021 at 10:58:48AM -0400, Sean Anderson wrote:
>>
>> What exactly is the warning here? dst_iter.length is a size_t, and
>> actx->fill is a u32. So fill will be converted to a size_t before the
>> comparison, which is lossless.
> 
> It's just the way min works.  If you want to shut it up, you can
> either use a cast or min_t.

What version of sparse are you using? With sparse 0.6.2, gcc 9.3.0, and
with C=1 and W=2 I don't see this warning.

--Sean
