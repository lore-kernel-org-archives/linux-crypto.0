Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73216C49EA5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 14:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B1B613C0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 14:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFXPBP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jun 2021 11:01:15 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:18017
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231250AbhFXPBO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jun 2021 11:01:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihq7yIQapUBkJnjtakb4/7gg+9vvpRQC+12WPXm8YH9P3nAeBjBj4jwVY18OTg0Dd43ireWvHrfgiLCa6j9Z+/+rK2jyyXLyaNEdU/pJJynX0unQGqU0A/axxeIDTiqmaTlxnuRSFsHkNJxT9gAZd775yeM6C3qBzjhCljy8v6UTa1CQiddBbd2lI5xcxNQRqYAc4nhnFlMkupc/fJBqSPw2ZMoDW2R+XqNgPt2jXxqnWAA7PIdFsrRDMDj8fHwX0qj8kTm5wfRVTgIaMBJl2NAphnv4hFEY9s7kwZq1L+FT9qwkS5M2BbOI1EsW3BItz+u/mVQJV0ZP0kOwZypuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXvfbNtrGvf7rTjCcikPWZ4eJ9raYfTZtg3EFiDlhk0=;
 b=fg+pLmVJuoV862dd0k3J8+nRksBBdN7nhdHXJnKFmcEEwEqRernTsXsHlsFKEqdtNqiRarPHRkdR0VWgpcH61HeY+E+hR/OZu3imS7fnaZ2l2YtvM4upWc7WooMi/EyJweBApeV5TCMDF5oXbbQyqC0DeHQryfB+yHbSt1PmhYIymflsh3hRIZUl066nOOcxBBKdOzic2/VrEiksxHa0SOYCmYOFUN+K8yKt7kz6vkLMj9RyYoHRC94tMz+bk6ffk+oalkDuqCBhndNEXOoaAfiRZTXS5ikwmECMmBm+17wVVW4eoZc+8qd04DoZIUg00wYFLDYRH8vDL3s3bTkzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXvfbNtrGvf7rTjCcikPWZ4eJ9raYfTZtg3EFiDlhk0=;
 b=0lUIlRBi6YSLhfFGgO9RrdT0iBO4QlHJHY4OyG9NgMUUDp8R9eSyxwxVUxzZGwVgpILUM2BrvLo3EzaU3UgG6thDorgWq7F1P1s3tgentFwbYtvULfo9wE+NbW58xN/Z4d7qPf/g0iHc1CMFgS9XTqgu61fJljFEAxCIY8eokC0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5577.eurprd03.prod.outlook.com (2603:10a6:10:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Thu, 24 Jun
 2021 14:58:51 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 14:58:51 +0000
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
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <dfe6dc8d-8e26-643e-1e29-6bf05611e9db@seco.com>
Date:   Thu, 24 Jun 2021 10:58:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210624065644.GA7826@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR01CA0054.prod.exchangelabs.com (2603:10b6:208:23f::23)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by MN2PR01CA0054.prod.exchangelabs.com (2603:10b6:208:23f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 14:58:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 543497b6-3ed6-43f6-c753-08d93720944c
X-MS-TrafficTypeDiagnostic: DB8PR03MB5577:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5577B7D625837D52A3BE540C96079@DB8PR03MB5577.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJN1B25BA4yACXlZMOkrKfJWxjOMXpwG1plBtsAp43oyHp1ggRyhPMnMsgcyEgJKRd5dcgXs1byt8aL7UHLRQmN9M4IV2hN3MxWypX9gYfwC1MfFVCb4NckhQqtRQWf4vp16RYfTgX6uKNEix2zTD7XSLBF2Eahzq01yz718zP+hFje1h0ZTpCl1seoOt9LzyJ19gyzKOAK4vhk9IKeqxaepxhuihFbls7QjOrbWkU6qML7aCNtlNacyjoNUr+Aibha5vIZvgmX1VKl+81dh9Eau6o9pyg85cciCWpiHRq5aPampdEKT1H3wx9okEclnvRk3aeYk36fWOalEmOMVXdPml64CJckDDITvPgVxxOz9hH05tkEqupkPFmXc8ohK3RyyHLfWE71s4FRd3j+T3KvlukSKPei9VCYsem2DWzEnZaKEHuwP1unOCFeBFkg20yjSHvhsyTDNsibxhSBDBETSxWKK1BkqFvGDufBWnE9B5jRy3Gm5H6v1BejNO1np3lxblNQ+66ehfrdMv55LqxYkKd0KWsHdgcPO8nx+s9Hf1+7glBPooT4hf2aulXrz4Yz2gsLFn1laZgJmI9PZzK/RzSHs+1ENs85OjCx0qWH2XhJ48nGR4qFYVtm3gokOQzww2hTuRshF8tL/NFa1+mXdqbjtn8xF4TIDCvorbjGYXE38/TCMnG52srJDrR5aEVonnSir5+kCc3adGduMwWzS78nfgkDMI0/IQCGOD8w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(136003)(376002)(396003)(346002)(53546011)(38100700002)(6486002)(86362001)(38350700002)(36756003)(2906002)(16576012)(478600001)(2616005)(31686004)(44832011)(8676002)(956004)(8936002)(66946007)(66476007)(26005)(66556008)(5660300002)(16526019)(186003)(31696002)(83380400001)(6916009)(316002)(52116002)(4326008)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW9PdnIxR0pTMlNWZGk5TE1oZlBoU2NxSG5PMlUwdWFpakx0UVZXR3pVT2R6?=
 =?utf-8?B?R0IxbmlZZ05tVmRRRThYMmliWUlBN1N3aXlFUkQ2WXl2NDdyWjl0a1gyVmhK?=
 =?utf-8?B?UlRxclBMRCtubEdYbnBjVXozbUZLWGlHU3c1Kzk0N2x3ejVyYWdmMDB4UFdH?=
 =?utf-8?B?M0I0RllFYzkxTUtLWjJNWUpvcXNRRlhweHgwUWFjYVl5VEJCeDBqdm9VMVFu?=
 =?utf-8?B?TU5hajdhR0x1aENYdkN5cVFBSFp0TE5Ic2NQdTZBYzNGaTFBQ2UvTmFKNXcv?=
 =?utf-8?B?bDIvb0l6RVlJUUFXSkFHS0lKaUF3UkZhSEcyRjBOd21Fa2RSTk95eHJmLzNU?=
 =?utf-8?B?c3R0Zk90UUlRYlhvZ1oyM1ZXYVhITnpNOUo2Y1VNL0NLRlBGYWg4Y1E0TlRx?=
 =?utf-8?B?RFNtL3pYWXNtYW1vUTZPdzc1VzFqazRqOFBlRXJETzdSWTREUmR3eEsrUHN1?=
 =?utf-8?B?TlVwVzJKaUdRSEgwNzRNSlZNREdydXA4N2dHMFFTa2RtbG15YmNMaDc5ZFRo?=
 =?utf-8?B?VWsyQ2ZPeXUxTE0vdFE2NTF0WkhveU01OWV2K2VHZnNCOGRuZzNHQjlqR1F6?=
 =?utf-8?B?ZXVPckpRK3FRVnR4VUVzUklBbzE1S2dheWVqM1p3Umhaalh4UjZHazczc3po?=
 =?utf-8?B?empOZFhheG5pYUZWbHZ2YW1ESThLYmxUaHdLa28yZEsreUhYSnRYd1ZUV3lj?=
 =?utf-8?B?YjlybktJZkIvRXNrY1dLNUF3bzBaNVdOZHA0WkQ0cVlrUkNaQmFqenpuczJw?=
 =?utf-8?B?VzZvYWhiZStsZUVGd1pCMG41cVlINjVYVGUwWm1yT1JqRGtOeWZOVDYvOXJQ?=
 =?utf-8?B?a3NNdjhjQUhEbVc3ZlNZelh1UHdZUCtoSzRZSUZjWjhPRzZoN0xoQ25ZVDlW?=
 =?utf-8?B?MUd3RXJMajJpWFE5YUJyZnVUdm10TVZ5R0V0OUcxWVBYL1Exb1dZNTZ0bEhF?=
 =?utf-8?B?OWVETGRoZkR3akJqb3hFWEJNT0lpNnY4SUpuTEpIZkUxN0tvU05IcS9xWTU1?=
 =?utf-8?B?ODdEV0NvenVVT21mbFlKU3hWN0tIRExETlE4TVZ1ODhyQ1pBRUYxVUdiZ21C?=
 =?utf-8?B?RVlDVnI1QXVaTTRrNGRod25TZTU1V3lTNTUyY0FFRlhZeko0RnA1UnRySjJZ?=
 =?utf-8?B?cXRQOXcwcXdqbkg0WnZmZXNhQ201cTMxUmRiVjMrZkpoWGlIUStNaFBQY25s?=
 =?utf-8?B?WWR0MGE3VnZQT1JpT24zN1hYeHRrWGJ1L1hKQ1M2bTRKU04ySWY2c0krZW9y?=
 =?utf-8?B?ZlE3ajhjbU5zZElaOVU1QlpJc3pZVmt5c1hYL1Vob0VKTGdaekliTHZvNTBp?=
 =?utf-8?B?M0xWVEZNaG5vTHhwOU5FNEp5eVkwMTRkc1V1YmY4cXJjazdKaWdnVWM4UDl3?=
 =?utf-8?B?YmxKVGErZDdNbWgzK2tjYzVpRG9GOVNDSi92c1dyRTRJU0tPVkpUQ1V1QThj?=
 =?utf-8?B?b2RDZExUenJtbUpJckxqaG5FRVRYanUvU01qK2VnU24rUmJmM3o5SjdjSmRa?=
 =?utf-8?B?MGpxN2c0ZnNuUHkyN1JVd1JMZ1pXMUxObGVzRUpBSVl4cGxlWXBJYlFvWWVk?=
 =?utf-8?B?Y0pob29VMTZwaUhKd3hvdTRmcWlWa3Z5YUZzUzZOUkhYb1RKQXljYXVDUWxK?=
 =?utf-8?B?QlljeEczMUtScHJXNld4cUlFTzFFb25KZ2NBSW5pK1pKbDZLb0M3K29GWi90?=
 =?utf-8?B?M0Jrci9tRk5reFNBVy95NHVNTHNvRG1NTjNKRjE0cVhKTHkyWHpTWGhtbmRT?=
 =?utf-8?Q?3HZaOcgjuLiA2WtODQygFM9p2vZLF+6tYB4vzJE?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 543497b6-3ed6-43f6-c753-08d93720944c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 14:58:51.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgOmK7LZNf2NkELwE8g7I/y8CuxWeyB6tYEJSnvmV3jBZb5Te00+3gzqZkQDhkNrOuQbAXcuMfikWTtA6ymCQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5577
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 6/24/21 2:56 AM, Herbert Xu wrote:
 > On Fri, Jun 18, 2021 at 05:14:11PM -0400, Sean Anderson wrote:
 >> This uses the sg_miter_*() functions to copy data, instead of doing it
 >> ourselves. Using sg_copy_buffer() would be better, but this way we don't
 >> have to keep traversing the beginning of the scatterlist every time we
 >> do another copy.
 >>
 >> In addition to reducing code size, this fixes the following oops
 >> resulting from failing to kmap the page:
 >
 > Thanks for the patch.  Just a minor nit:
 >
 >> @@ -365,25 +364,13 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 >>
 >>  				out_tmp = out_buf;
 >>  				last_out_len = actx->fill;
 >> -				while (dst && actx->fill) {
 >> -					if (!split) {
 >> -						dst_buf = sg_virt(dst);
 >> -						dst_off = 0;
 >> -					}
 >> -					rem = min(sg_dma_len(dst) - dst_off,
 >> -						  actx->fill);
 >> -
 >> -					memcpy(dst_buf + dst_off, out_tmp, rem);
 >> +
 >> +				while (sg_miter_next(&dst_iter) && actx->fill) {
 >> +					rem = min(dst_iter.length, actx->fill);
 >
 > This comparison generates a sparse warning due to conflicting types,
 > please fix this and resubmit.

What exactly is the warning here? dst_iter.length is a size_t, and
actx->fill is a u32. So fill will be converted to a size_t before the
comparison, which is lossless.

--Sean
