Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6700C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 00:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B1261549
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 00:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhKRAuy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 19:50:54 -0500
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:18948
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhKRAux (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 19:50:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ms0pqGEE/Uk80cIOna2GejRyBEzXT5i2yeS9APZZjbZTV49lz+wZAvyjSKM/1vshRxQracJ+3DSOITRib6wn0ZcRLeecNSZo1mj6z5D1a/lzMMKZFaxsJFLO1vIf7XERfkv3qYQhPC9yeeqmjqW5kQtrQw4LGy5TUfe6rJHM5NJOUWv2bNYo5y3S0jcLvmeOtDMMLIEJCpw9dG9WF8sfLvM/EpGxRd4ueS55ukqZFVVXOWooMhH8JLiM2m0nHvPum9li9ioxQD9ZqnuqAu0CY7L2XzsQhT/mojMDskq6MFF2LjV/PsMaweZ6SnEjZRAbt1h/I1awHzRheCM0qqb/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEYuJEqktNGrHj/Hot5eZceKfM7zWtvDfSMLjYrfrDg=;
 b=DhzePaP3eJE5r1cFZ+vRZkN9vJFp4sEW8Gbq+Mhf55YSYPhTt3dUxllB9dKpK3+XO8W8iT/ZpjvAyK+7BpnXcHewq0yUoS5ObXGEwPQ+BENAyLuBfhB5FxRh008EGlNQEUMCAjDyOULqKmBav9Zm/hk4yid1mr80cGbbD7MvrrzrNRXl1Vk3PWMDWqSCQLHUmPdv45E6dAYPrdZPHwIEHls8HPz8Cqb0FdT33DYVtDBc1oaTosyp7eKTsonoYKJZtUPMvEhzqLFx+Hyh4F4lzSJQVyA6H8O2GEinzmNW5U3aK2jAuUu3XI7TmNqpES8zkeNvegSRhX7DO29psHFCuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEYuJEqktNGrHj/Hot5eZceKfM7zWtvDfSMLjYrfrDg=;
 b=jocJHgurVdtDc6lYTsCeIJ3G7tv2u4knAvW6bCplOXUMCWdm2MvRLSc1L6InwjWx8m02clnVdbevRT70j2eNOP1W20TkC0PLezv+c04EUeVX+JRRXNsbH+E1SxJs2nWMJeMyWtEChbI5ECPyRXIKhNEZPJqh4XTzJ4fZQ/SAxp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2814.eurprd04.prod.outlook.com (2603:10a6:800:ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 00:47:51 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 00:47:50 +0000
Message-ID: <59c04d9d-7acf-5468-1382-ce22bff8292d@nxp.com>
Date:   Thu, 18 Nov 2021 02:47:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
Content-Language: en-US
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>,
        Michael Walle <michael@walle.cc>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
 <e8456cc0bb9e4fc306e8188c5bd666d0@walle.cc>
 <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::33) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
Received: from [192.168.0.213] (89.136.162.44) by AM9P195CA0028.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 00:47:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cbdcf54-741e-45b3-9c59-08d9aa2d0c2d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2814:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2814AC9D5E84647DE194836F989B9@VI1PR0402MB2814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VpfswzErJIQrkDm67PlFEPsD9Nn9NPF2H3qA/CGibYWW40vCoYQYAHbgVg6QL0SldGaxyOI2IsFLp1+/UZlXhw8YHYrUyDApRxJdjoXIDIsOVhy9hlmEtUt3+xFwQ1UNq8sjptCehxSHFkM8AwXqORstT6Mu4MsL58HWXatQOn1gAi14QGIhTYJD/wLXcu0FcxF7IQz+R8zJ3BIt2mfFxtLEbHDh8Ti0aqq0H7gaVksN7YnDm9SMnnaGaVAS+Q3laZrZepQlJjX/piGfUfEQ7zw1rXMjaTw21q/fDo76lakd5+nhJcKfKjDTP0dD5TMIaIIL39ztzZsxWGonHLhFASHTtQ24ojhZp0NiOMI0JVGHTI9VtOxyZwvcPvgxq+dXz2KvzRdzMytYFulhapvqBn7qDesmkEmK7sASSZFpsF1tOZOq560j19yL46GAxoPQmhfEy/HzSGM2q+2N1Ou4bNEyP39FNKiATTO/tOLXSyuvf2GJ9WY22Tx/N+c1xSYIeg8EIJnP79QaSfKg7vSMVyBBA13/Cmgw8lFragPjSfr1mc0rVx3ohHwecoLZxyLJtykV684b2Kp8uGzJbLcsj1cEseU2GU+MAkv3PUk6zv19Y/PYJ4jvmHnZTrsvu6uSpaOXZXM+K0XQnUWIFuWsZIBWl0N0l+cyoqbJ81ZE1gBvJcSA00FJSnYcNSly0pEImTr+GE4Sbb1AZ0wi3i/BPFn/wDqXBND69sGw4UdoJ3G9EdzRpspXq+DgztH1QpOJs6gVNiVZ3Yx5MDh3DI4hVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(52116002)(110136005)(31686004)(186003)(4326008)(956004)(36756003)(5660300002)(2906002)(2616005)(8676002)(16576012)(38350700002)(26005)(4001150100001)(316002)(38100700002)(54906003)(8936002)(66556008)(66946007)(66476007)(6486002)(31696002)(83380400001)(508600001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmhqZ281OEhBYTA1T2tIVlBTVjVyRzJlY1owbFRzYisya1padWlaSk1xeGtm?=
 =?utf-8?B?RS9WaVFyL01lTVl6K1MwVDR0SWlRR3R6Zjk3L0ZleDJJWUE2NFlzU0FjcmtO?=
 =?utf-8?B?Q1ZTdmhRcm8zNlVYTXMyUGNhV0NDVXc2NVIzWVRvWG9KSXBUSTdPQ2t3WGxK?=
 =?utf-8?B?SzZjWUtXK2grN0lIbThEb29iWlhKREN4QXJWZExPeWsveDh4ekRnWVlPRFRn?=
 =?utf-8?B?aTZjR0FGaGRHbStiSFEzbmd2OUVPWjA0aWVVNmlGWThaUENBZGFiamVMUGVq?=
 =?utf-8?B?R3pBN3JKQmpFemlQeFAxZjR0eXFMVExwczFIdEEvNnpKN3dpV25hY201Wkox?=
 =?utf-8?B?YWpjWTFtcWR2dS9sOXgvaUdQWjJJb3IwRi8rRjRPYTlJeDlNTDlLeDRsaFBI?=
 =?utf-8?B?dUplWDZJUUtPVEc0Nm5JTWN0MVFNNEZsb2kwcVZ1STZXNmxRTFEzaUp4ME1N?=
 =?utf-8?B?SENUaVN0c0ZETGRaeVJaaVRZQ1QwZ0c0RXlLeWdZUUtLSjVld0lpY3RtTUNF?=
 =?utf-8?B?RSsweU9PK0tPSHpYZGl5TUlmcXBlTEFMa1RQQStqS1diSk9wTzNVVXBkM0RX?=
 =?utf-8?B?eUpjZGFyVWp1MFpkVlFWQlkvcEY2RTdETGhwOWE3NVNlS2pQbm1ycUxtUmE2?=
 =?utf-8?B?QkFZVVZoQlFZTlN6eHZZV2FQRDljdGh1RUNjZHAwVklLVzJ4MCsvV08zOURZ?=
 =?utf-8?B?RGIvNjNYYWdQZFVMQmR5cktGTHFoMUg5RStJeHkveCtHczZZa0NSOHNnVzlT?=
 =?utf-8?B?YXlPczFzbHFwVC9HWkFlcTBYSXorUU1oMU9KdjNLVUpPUDZqdThnU2J2UHJp?=
 =?utf-8?B?bVUzZ05DNENLVXN6WEFFaERKNk4wWlk0QStUdVY4TE9Ianp1SnZiUDRxUEcr?=
 =?utf-8?B?V3pubUpWREx0dTdJczFaWTdmN1FOei9wQzZKZ0tzdFRtcGtpYW5tVkV4RmNO?=
 =?utf-8?B?N2Q2T01VSldMSVFSZVpUMlBjY2NNTi9oYlp5S3BQMWhiSXhneGlzV2JCd2dT?=
 =?utf-8?B?VklaU2tnVk1vRXY4ZlhVd0RoM21hakh6eFJKNGZSKzJpcHR5UTV6cnp4SDFl?=
 =?utf-8?B?NzdLWG0wTllTMVd0dHlDazNJZndwQWV6N1ZuLzZEM0tWbU9YMzNtL09Nc1JH?=
 =?utf-8?B?dTkzQjdwNTVVTWJ6Vkdoajg5VmVwRWozUzJYcHVrUVpxTXBEakF2dzFjVW1z?=
 =?utf-8?B?eWZvOWZ6ZG1QejE4VVVUNDJFajNuSU5xR1krWFlaOURoUUZpRitmWk1iaERo?=
 =?utf-8?B?bTRlMkpqcXM2dlVHalpqNmtERUdHaGMyaEdGNjVOeU9TQkZuZ2ErWWNvdng1?=
 =?utf-8?B?MVo0YWRjd24reFhCSFhFbWpYS1FOT085MjczZmlFRGdDeWUzUUw0eXJsWGsw?=
 =?utf-8?B?V2h4WnJPSGROQWpyejJ3ZVJrSDhQeWpSZm91cmhySHpyYUdoVzNaZWY0Y2Zx?=
 =?utf-8?B?L2Nua1NOUUNOcGt4ZlFyRTVjcnovT01UMzFxSlg0SldlbDQzUlZRRzZUcXhV?=
 =?utf-8?B?SHRRZXNCSm01YUFkYnYrZVQ5QURIUzZueGgrc2E4bjdQQWNSQVVBanlxT05n?=
 =?utf-8?B?UGovR1VhaHY0R3YxZEljcmRRKzFkRVNlYU1USEZ4VGNCZ1g3ZkN0NjlnTkc0?=
 =?utf-8?B?NUhGYkROdU9odWR1N1NRZmVxd1hlSEpZbC82aVBnb3JrdjRSaCtYRU5RaWNV?=
 =?utf-8?B?WVAyZ3JxT0NmRVJWQlJLRUZOQnlsc1c1aVJVUTg3WHIrN1hoRExER0FIQW85?=
 =?utf-8?B?TExNS3UwUnNiUGsvSXJzRUdXMFN3ckRlNGVqK0hvL2dxVWtNZmdKTmo2WmFH?=
 =?utf-8?B?RWM4WWNyTmlzZDBDUFpVWkxGYnhqNldHdzNoakYvUjlCeGJQUHVOQy93QUc2?=
 =?utf-8?B?WXpFaTJLRlFvU29Ebm5iSGN3cnB1Yyszc2w3cjJSTzNKUmhNaitrYWdUem9l?=
 =?utf-8?B?aitxVnZzWndrM2c0TFExWkJKdHBZTVNsR1hKaHgvQTZIMWR4YmptM2hHWjBN?=
 =?utf-8?B?d3hsYWRPejJHcUtaZUVBM0c4YUwyc3BETFhORGRvMWFuYmIzZWRIdGZjd29a?=
 =?utf-8?B?T3E4TXFHTXR5emNIZzdVcHYzejhFMmdhclRtY29EL29wd3VJaDI0VERkcTkv?=
 =?utf-8?B?T0svT3NQYWx4VlZKb0dleTVSeisvQUZSRG95a1VjM3JsOHdKTWhrTEtZMEd4?=
 =?utf-8?Q?r6sZQeTYwt4UeaGGCfAEbAc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbdcf54-741e-45b3-9c59-08d9aa2d0c2d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 00:47:50.7280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lCdtmmhH9eZ9F+QmAHtUu8M8XvvXT/nt2lTLGl+N8t/2524KBNA7sfJrz1F6xMMjTBmI+AKVuuT6OHvrGtYAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/15/2021 12:07 PM, ZHIZHIKIN Andrey wrote:
> Hello Michael,
> 
>> -----Original Message-----
>> From: Michael Walle <michael@walle.cc>
>> Sent: Friday, November 12, 2021 10:18 PM
>> To: ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
>> Cc: horia.geanta@nxp.com; pankaj.gupta@nxp.com;
>> herbert@gondor.apana.org.au; davem@davemloft.net;
>> iuliana.prodan@nxp.com; linux-crypto@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
>>
>>
>> Am 2021-11-11 17:46, schrieb Andrey Zhizhikin:
>>> Job Rings can be set to be exclusively used by TrustZone which makes
>>> the access to those rings only possible from Secure World. This access
>>> separation is defined by setting bits in CAAM JRxDID_MS register. Once
>>> reserved to be owned by TrustZone, this Job Ring becomes unavailable
>>> for the Kernel. This reservation is performed early in the boot
>>> process, even before the Kernel starts, which leads to unavailability
>>> of the HW at the probing stage. Moreover, the reservation can be done
>>> for any Job Ring and is not under control of the Kernel.
>>>
>>> Current implementation lists Job Rings as child nodes of CAAM driver,
>>> and tries to perform probing on those regardless of whether JR HW is
>>> accessible or not.
>>>
>>> This leads to the following error while probing:
>>> [    1.509894] caam 30900000.crypto: job rings = 3, qi = 0
>>> [    1.525201] caam_jr 30901000.jr: failed to flush job ring 0
>>> [    1.525214] caam_jr: probe of 30901000.jr failed with error -5
>>>
>>> Implement a dynamic mechanism to identify which Job Ring is actually
>>> marked as owned by TrustZone, and fail the probing of those child
>>> nodes with -ENODEV.
>>
>> For other reviewers/maintainers: I'm still not sure this is the way to go. Instead
>> one can let u-boot fix up the device tree and remove or disable the JR node if its
>> not available.
> 
> Just as further clarification: this patch is intended to accommodate for cases where
> JR is claimed in S world at the boot and not available for Kernel. It does not account
> for fully dynamic cases, where JRs can be reclaimed between S <-> NS Worlds
> during runtime. It rather accounts for situation when any arbitrary JR can be reserved
> by any software entity before Kernel starts without a need to disable nodes at
> compile time.
> 
I prefer f/w to fix the DT before passing it to the kernel,
either by adding the "secure-status" property (set explicitly to "disabled")
or by removing the job ring node(s) that are reserved.
OP-TEE already uses the first option. We should probably pick this up.

The reason I am supporting relying on DT and consequently avoiding registers
is that accessing page 0 in the caam register space from Non-secure world
should be avoided when caam is managed by Secure world (e.g. OP-TEE)
or a Secure Enclave (e.g. SECO).

Unfortunately support for HW-enforced access control for caam register space
is not that great / fine-grained, with the exception of more recent parts
like i.MX8MP and i.MX8ULP.

Horia
