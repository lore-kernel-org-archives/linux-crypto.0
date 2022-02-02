Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F848C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Feb 2022 08:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiBBISZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 03:18:25 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:58643 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231628AbiBBISY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 03:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643789904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VDy1sK3CxK4iZYpEherhsZT8ValE/X4rPsJAlP5c2Ww=;
        b=TugCTZvIGZqFiIXcvilA+lkE+9tnBFy+QvxWtgc5JXP5llix+ZgdILbmjjMiBuXEEOxyf+
        rGByYlRvK0WsCoKXmQFs2TUM35K4YVZ0l4mFBLV0w4lDQO3/xkW/cGBqVCcqoS4kGRF8Q/
        wsIWXM2gtU7F+Wq/sfBfqAk3GF6mprE=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-lIanT3X_Oq6OUqjNOg91FQ-1; Wed, 02 Feb 2022 09:18:22 +0100
X-MC-Unique: lIanT3X_Oq6OUqjNOg91FQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3DE4z4KGHPmrCBh5viY/7H6J4+iTE1f7M/IG2XZk6dnXJ3gx38evJv80JExkcLpEApCzBf2BU2G+rbuZcDpyJJLuNAUnGJ0Ya0S5YzlVx62KXCI4ALJaD7JBDvEfDKTGk0mZLbNSgV185q3ptXlXsRrCjtQZYv7Rxin1w1FmqkgSXVvzxtcyAznMUfCtMw/4yKy0Z5ePs1/TdZ1B3WAQpjaemqCynJ3bZb8L538ON0/CtnnBFGXjfe7JESpyIl57JukB4oymSRpaONVlCgpLMiJ5h/RCed8/TTrqnBqB4gc8SeOf2n4FVmSp6QAiSnglx0pqozDi5mxPYPmArcYyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDy1sK3CxK4iZYpEherhsZT8ValE/X4rPsJAlP5c2Ww=;
 b=e4rnEAs6OupH35yHKefZVC7PPv2vQBgNuZifpjUNBh2jzlvVlKj1wrqUbL6BfyRp514PBiWwL9WKISh2ZrQ/HASv0fYneUpX1rSkLG5LPWSEbbl7uybk/Et6LbQ5w79GwBvHNdaTtIUxgZFABn/HsouoWxvIlsPTAJdmNxmNsliGECY+VmfsP/UOcPWJNnjdw0A6DzP1o6FJDoaJULsgGeQvC1zmn0dtrHOZPo9kpZHreBN+NE72OxwiBvV6xxbLS5t4ODgdP+7QTPC2EqC1PmDv0qbpmQZlRMMLcTjAAOvApSCR/9+qopL+EbxtilQQCiikD2xqla9gNlQSyhzIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by DB3PR0402MB3675.eurprd04.prod.outlook.com (2603:10a6:8:b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 08:18:20 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::5160:9fd7:9627:cb11]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::5160:9fd7:9627:cb11%5]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 08:18:20 +0000
Message-ID: <0b2b18b4-0605-a02b-8576-fd76c3d1afe9@suse.com>
Date:   Wed, 2 Feb 2022 09:18:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] crypto: api - Move cryptomgr soft dependency into algapi
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
References: <83208d0b-cbe0-8ca9-195c-ee1673f08573@suse.com>
 <Yfoo2L0vUibufXiL@gondor.apana.org.au>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <Yfoo2L0vUibufXiL@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR04CA0013.eurprd04.prod.outlook.com
 (2603:10a6:206:1::26) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff302a40-9531-48b5-2319-08d9e62492c0
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3675:EE_
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3675972F86AEDBAC0AA39AEDB3279@DB3PR0402MB3675.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiXrL3zUe7KxfVKWQX9yNTPei8lJ724VJBZ8Gj6e6m/5P8IjHV4LwZzcs8++Os1aim3j9qGPBqr3KbAhyXssDko9XNRYSnHXrv6qqRVq5v+dIJDQRsJr/JHf1ipPjiftUAEUYq1XpStdmCz7E0MDfk8TWz2Wm5zrADWv1rN8zoLzXzwR6Nsz6iF0OCuh3PnWFK7Pel+1Ubl0NN/k6iUrcIOGnwKmcgR0mzUN5nknGa+RVSvDSiPJuV9ow4AZvXLH2mnHwsIhHCmu7Jw46bOWUtwfhHRlaGiuTkxnTdsVF3k4SMdUuJN4JQp7rZcQY+JsTPmBQExNB2BDTHZmT10Knh8ojkmyV0GQB6+BkqyPTfMDvNJF3M1U6wn3TzMT/29Jw+ld7Nw9Gp3g7LzgdruHrH1pPi2Rhe+rXIGwhoxxR6uasLXRHFUdn9CFMjP293H85GQWvNqmPrfTk9zWS2Xr77BtrHvL8FVaX8ZcDMFS0MrtzYR13cFLmRhY9gOKurXBwf2LY3ILQQnO7XNMpFNqoew2Fcg3zGkEyq7UaTSlrWwrmDwjg6xZV5V8x8c/97pohPmaNmi480Mp5LzYbwZv3MCqv3UFOKJT3seZUsVMuVUA6lNlffqA+Ypx7ZNnqE3sKyg6KJRiurvzdd5inCvbMe+XF+XNbTrEVtEhbEOCGmCHYvmGX586TqZVJnzv9zHERyvLyOmwAEgoVoCZ0ByBjzOjOtnBHKS6xkHwoz9qVTQCX4B3EjUPXuYd+tk3FyzM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(66556008)(66476007)(38100700002)(508600001)(8936002)(6486002)(86362001)(31696002)(4326008)(83380400001)(2616005)(186003)(26005)(6512007)(53546011)(31686004)(2906002)(5660300002)(36756003)(6916009)(316002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTB3Tis4KzhkQm9sV3MvMmdWbWd5bFZaanhCVUNpSXowOStKVTJVZVQvb3ZK?=
 =?utf-8?B?ZFgwekp3V3p2L3BneDNMaWpXTW5PNUpXMU9zaXFLa3RORkE1QmRVSlVuaUVy?=
 =?utf-8?B?TFpwTzQ3YjhndTltZUpHUE1VN2lHYkJLWEVkQTRUVEpGSEpJTzUvMDczY3c4?=
 =?utf-8?B?MklwUkVkeUYyT2RtK0FrWWlXczJBRmlLWjlDcis4dzhuYmRUZWtOUmxqVFMz?=
 =?utf-8?B?SzhHZlIwTmx2WkxLREg1Sm0zQndEbFZUK04yMUg4WkNGdHpRa2xZbFJtL3Iw?=
 =?utf-8?B?ZVhzVS92alVqelhMZjEwUU8zMjFxWXIyYVZnTVlrRzBjblB5Q2VkSUF6bncw?=
 =?utf-8?B?OU9sUUxOY1lvMHI2cU5XRllML3dZck5HUmZzL3lWWkp6WmNJTVo0aXV5RFVs?=
 =?utf-8?B?Z09BYTdsV010M01yQ3ZaYmlNQzhxR2ZhalEra2ZVMkZFWXR1OGUrTVpHUmp0?=
 =?utf-8?B?d3FDTkhvR3NMaTRLNysvMnNyNk9nY3dkSmErdU9SS3RZZkVaZDRKdi9XT2pY?=
 =?utf-8?B?OEROc3hYbGY3R3dkMjVkYlhoNDdab2FCS0hpYWN5dDJOZ3l6VUZYYmhPOFMz?=
 =?utf-8?B?a2JXaDJ1QmhKMndXNHlWWGNKWDJISjRRb3NmUnhGSUxyNncrZFBZWFdIbVE0?=
 =?utf-8?B?OU5XYVh4WW8yZWM3T0d4U3VsYjVvVnE3UjhrUjBJSWhVSEJiVkg3bks4akRP?=
 =?utf-8?B?Y20yMUxzNm1FWENNT1hxUFBpOEYxWCs5R0dYdzg5Z0hPcCtwRGl6MjFkNndZ?=
 =?utf-8?B?TEdEUXRucC9wZjhmZ0c3eFVIcVE2K25oVjB0cmdEWjQzaXlhY2pEMnNvdFBK?=
 =?utf-8?B?Rys0RU1XVEh0Y01Mek1WbFUrN24vQ0ovN2Z4dnJiangzUmdJUnpDdEkwclJz?=
 =?utf-8?B?cm5ERnF3QWgxVDlGemZFVGNrbkxWVkdMTDBjZ1JSeFgwZG1Wc1h3SUlZS041?=
 =?utf-8?B?MDJVKzRJSEppMTh6T3d4aXUrQ1VRd0prMVJ3dEtabTZ4bHU3KzBGejFzdStw?=
 =?utf-8?B?dVZCaFpGTXlrc1ZZM0s5ZXE3Z0ZzSzBRVS83YUMzY3dGNzhqSXpHRVJoNGU0?=
 =?utf-8?B?WS9IdWJWMmVyM25KOHMvdFRkYko5cjUrSytrdEhrdC9jdmZOenk1b3cveUcz?=
 =?utf-8?B?d3pVTTVzWG9yYjY1SWZBWFdTYUNvVlNoOEpoOURBWHpLcU5LZ0lnbzFqK05V?=
 =?utf-8?B?NFJwcklZdkdyYTduTFJSOG42UXRkNGIzTEtzVVFsS3FEd09Da0gwYXNWTXJi?=
 =?utf-8?B?WXhCMHJORDg4Z3ZvcmtUZTBzenB1ckxDbnR0dWd0eFVBa2hIL2hxalNCQTBt?=
 =?utf-8?B?RHRWdUtXN2xCTEZkWjVwa0ZBYWFlTDBFTHdSTU9ObDA1SFU1NGNHSzd4RXpX?=
 =?utf-8?B?eXl3WitUVWFTNGE1YksxUmdQWWZvNHNtOCtPTmROSm1wZHZ3L054YVpRMVZi?=
 =?utf-8?B?bklWM2MrVThsVUp4NGI2Q1pZM1FrS005K2JyRmlGakNFbVBEZ3RlYTBHS0hH?=
 =?utf-8?B?SUpqenhCdGY4WXdWWG9ZTUhGbzQrSnl4ODhHTTlZREJpN0ErR1R5R1o0TWpJ?=
 =?utf-8?B?ZFIzb1hTRmFKRzJNd0NLcWx2REI3LytCSEdodnNoQUtKSjFPcXg0SmFuNVpO?=
 =?utf-8?B?WmtNdnJkSmhjMEpvRHJBZUdiUDAyNjRYS09GeTB6Zi9OWlBiUEc5UjlENVZm?=
 =?utf-8?B?VXhtMEFjWFljcGgzT0t1c3Q1dnI2aHdSY0p4QzJIUnllN3VuR3cycWZndndv?=
 =?utf-8?B?aGNuMG9HcEJYVm5Ec1BoeFFZSGhZMUNhUHF2SXcrQ0FkM25MalZueEx2bWpq?=
 =?utf-8?B?YXBlWG5UMU5PbE1LcS9LWEVkTUFESDhNOU4vMEoxZkpmSUNhekFkWllGa201?=
 =?utf-8?B?dkE5VWg5MWdGU1gxbWVwd0RHTnZyQ082bzErTWVKZi9Ed3FJL2g2Kzd4dHFt?=
 =?utf-8?B?VlUzL0FLeno0N3EyWnZBeStBZVJvUFZuVW1HU0J0WUZSMG5QcVMreEhXdjVV?=
 =?utf-8?B?WU9wRnozYUN2a1pjb0hGaVlzbnZQcjQ1Ymh6UVE5Wk1rQng0bVhHWERGaW1Q?=
 =?utf-8?B?NGFzbWJ2Z2FzZzVmVm9Vbm96WXl6RDFpRUpwdUNFVnhtYVhtVE5PT1dzRXMv?=
 =?utf-8?B?d2s2aERSQUEzNUY4R3d4aUdrdFZubmppL2txanduSEsvTERnYU05UEp4Rk55?=
 =?utf-8?Q?Sh4QQfgb01dAlPNoo2NzHME=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff302a40-9531-48b5-2319-08d9e62492c0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 08:18:20.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylesNQmb+f3jyHBfuNcA2hhoUo4hzY05auiWB0wbZbxa4c2sYptId6MmX5FVPfm5/4lb+sf8pwpT39JKs98W0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3675
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02.02.2022 07:46, Herbert Xu wrote:
> On Mon, Jan 31, 2022 at 04:30:06PM +0100, Jan Beulich wrote:
>> Herbert,
>>
>> unexpectedly after updating to 5.16 on one of my systems (the 1st one
>> I tried) btrfs.ko would not load anymore. Since this did happen before,
>> I inspected module dependencies, but they were all fine. Nevertheless
>> it was libcrc32c.ko which actually failed to load, but the error
>> ("Accessing a corrupted shared library") wasn't very helpful. Until I
>> spotted crypto_alg_lookup(), and "only" a few steps I found this commit
>> of yours. The problem, ultimately, is that all of the sudden
>> cryptomgr.ko needs to be available in initrd. Without any module having
>> a dependency on it, it wouldn't get pulled in automatically. And there
>> was no need for it before (until later in the boot process, when / was
>> already mounted).
>>
>> Can this be addressed in some way, i.e. is there a way to re-work your
>> change to remove the dependency again?
> 
> Does this patch help?
> 
> ---8<---
> The soft dependency on cryptomgr is only needed in algapi because
> if algapi isn't present then no algorithms can be loaded.  This
> also fixes the case where api is built-in but algapi is built as
> a module as the soft dependency would otherwise get lost.
> 
> Fixes: 8ab23d547f65 ("crypto: api - Add softdep on cryptomgr")
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks like it does (unless I've screwed up with removing the workaround
I had to put in place):
Tested-by: Jan Beulich <jbeulich@suse.com>

To answer your other reply, I guess the crucial settings you were after
are

CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m

Thanks for the quick fixing of the issue,
Jan

