Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6026FC63777
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 07:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E674722228
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 07:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="Y8KP4XBE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388823AbgK0H6j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 02:58:39 -0500
Received: from mail-eopbgr70113.outbound.protection.outlook.com ([40.107.7.113]:39926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729055AbgK0H6f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 02:58:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKU3CKUCUnNC996y2IbUdB5W1UyZVOCVDyisQ1JWNe6WIqWxl2PUXNpK8fxSL9McQzq1FrCdaYosKhtfD3swRoUwFrJ5zmt1tH2usoIwzxBqZx1uREGMynUHaYzh8CBGixxuKxbBZwbH7kEoYludC+0sDcw5GbzCbhzMSOp8Ax0411pacNmpxQTrNHzkqBdPLfdoPQ72f3UF4uo7PFLGCegcqOPDPJJxXeTKyHjSa0HkfGW69bMecr3Cs3S/dtlercbByletbKM/5ZFD+A4wr2vcCKHeH69+7KQvoO967RBaz9X1/NgEouKGx/ytydIEvltJLh8Q7QUaGd8pdoNgZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+04C944rPcBN+tJIr4271G3CMB90A9iHoDKuEi0vjv0=;
 b=dj8zN3LOTIxBxDMEgXIDMPc8lCW7vNUn8hRXbcECkkMPwgPZJ4waVEaxeyOtiJDCoMbwGnmNF/qSJE4vQaefzeL9fXhIzJ11SRIlEy3Y+7y9bqhFQ12p79GtyfMoELwLFad8zOn2VC7VMLyEqmARupfVpb/cg+gxeiJQ53efsrjJFucrrVcvUpybjO4Uix/47RZSJeyDpxds3EJPjvYBU6ik+1q4oIF9rwrYd9gExMhCR3/eWIvJIASt9+7KPoEdLcKkCmGrcN9GE8YFP3uVr2IEkN8Uh3BNnyLoxGfwWV834J5cgx4BgA5ZUMjAmLFTfzL952DfKKJZcoN0Nd0zbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+04C944rPcBN+tJIr4271G3CMB90A9iHoDKuEi0vjv0=;
 b=Y8KP4XBEWXErqvCbzzczXhTM9BF+q9hucElJfcsF9LirEfut1s6yEx6z9KNJuRDwT7HSk/HNh40gK8fqq7Ifk2NtMjQwdRnpNeVjHJGmh5FYZ6B/LPxCJVfHgbbzxSJE5CvYjJ7cwwkLyE8eopvdXSOctPwZtJ+cjF3yi1CO/rU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB6434.eurprd07.prod.outlook.com (2603:10a6:20b:15e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6; Fri, 27 Nov
 2020 07:58:31 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.039; Fri, 27 Nov 2020
 07:58:31 +0000
Subject: Re: ks-sa-rng.c:undefined reference to
 `devm_platform_ioremap_resource'
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <202011132311.XmkAgWg0-lkp@intel.com>
 <20201127054844.GB23521@gondor.apana.org.au>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <c34d556c-bb44-1d7d-5207-ddd5ed81f18a@nokia.com>
Date:   Fri, 27 Nov 2020 08:58:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201127054844.GB23521@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.166]
X-ClientProxiedBy: AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19)
 To AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 07:58:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d50434f-dc6b-4941-31cf-08d892aa3b17
X-MS-TrafficTypeDiagnostic: AM0PR07MB6434:
X-Microsoft-Antispam-PRVS: <AM0PR07MB64348FF5AB3C1C583F5E2A8688F80@AM0PR07MB6434.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dczfoz37+ZozImTpCrt0wHAarL1LNrqXqI4mSpQF4SeNlZ9XffcW+K6JCgKTv6VVh+JSlM2uf5vArj7iVrBVJAtgENTq6uwE2akZ6Zwa2O6Xrc82w+P35E5OA5gMClHhz/4uPOCPJwBRMFuHHFlpUf9/DbB0/O9W54coBftSm8QENHqwJ6UvPnt9IU+saTQooeKgeI0/yyT8G726lhbPlmwaQ0zxxXXq4lMZJpmQ6KO97WEncAi3Y9P+7aCGDd0K5G0ubBUuajjT+S5Sc4CAkgo7xb/5OrYxs2ZcxKaxXAElVif+2QmkyAM+vACStK11Hw9mg7tF66UZ+1GeY6ahKTW60WuTtIWPRDQuB+EJhQkyEx+lbdv+igOCPaZRzmC7oQJGkLB9W6lOsakRzf9OwGhkAni/bRjBnc63oBAv7wSmwcHAW89VBej7bgholwd1VEbl/LGiVnJETlHUkEoo+m9v9oCz08w1ph0emJq85pY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(16526019)(83380400001)(956004)(66476007)(66556008)(6506007)(31686004)(66946007)(8936002)(6486002)(316002)(53546011)(186003)(6512007)(44832011)(36756003)(86362001)(110136005)(966005)(478600001)(2906002)(26005)(52116002)(8676002)(5660300002)(4326008)(2616005)(31696002)(81973001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cUQ3RWp6MU51UDkwbzNVYlNCUG54NFBWdnlCL2RmaHJESk12L2JWZ1NFa2VP?=
 =?utf-8?B?K0VYb3JEcE9MdnFSVVo3bm1qRGxEZUtUMzMwL1dxeGJNcHVDYVQ1MGdOdHU5?=
 =?utf-8?B?eXZGQ05lUk9Rd3BuU1FueTV0Y2Y4OWtIYmxXSlAwckUrMTZlcFZSOFR3SDdl?=
 =?utf-8?B?RDhVZ2hlSEZxMjlkSkNnZkRLcGVkL1N5czdWZmVaYmk3ZEdWQmkreGpsMytO?=
 =?utf-8?B?aEpiVm9JanZvNHJyS3Y2K3lwY1ZaSURkOGd4c1NlK3p2cE9FaHU1cU90MFR3?=
 =?utf-8?B?RDhMMkE3WFRVRHp2K1lyenNUc2xOWVpKcHhZYnVWMEZuZ01PQVh5YUtmS1lK?=
 =?utf-8?B?R2ZUN0Q1aitMVVBsWWNONWJxUklGM1IvUytIVysrS2JJVnBPdkRnOVRxV2Zm?=
 =?utf-8?B?R244QWVzbDM2MGVxQkY5ZGNmQ09rdk9yQjZyb1BYelgxNm5FY3FOZUxqWlUw?=
 =?utf-8?B?V29GUVJVQ3VCUjVIQitlYkFpSzhRWE5panNGMGhqZHRGUVlwYjdMZTZMbUNQ?=
 =?utf-8?B?ZDc5Ym5BZ2F4dmg0RUlnNnVRRHRQTmlBV2ovM3ZlMmRuVEZDVEVPbG9EM1pG?=
 =?utf-8?B?VkdZclhGTlJiSkdxTGZKTWFOQ3BCMXZwellLZlBiN3RwWG5ZUkdLUURxVzdk?=
 =?utf-8?B?UjZUWTViaXpUVEhwRFBnUWxtZjc1Z3BXSndNSnNSd3RLOUdSVkFtcXgzNTV6?=
 =?utf-8?B?UGttVjZkZWlRU3BTZFUyeENaMmI3YUhlbTl0WHlPT29RcTBEMGV1U0lCU2th?=
 =?utf-8?B?S3gxZTVsTVpJVG9SdXUydCtzclpmbjFOanlncXdmSThHRVR3S1d1WUZZZDds?=
 =?utf-8?B?bkxPZUt6dnE4NmYrMkFGZXVxZnBhU3M2cVFlM1pDUGZYYXhCUnM1a2FwUlFR?=
 =?utf-8?B?ekFtQlNVR0dRUGkvWSt5K3NMaXJjUSs0QUkwdVVqelhRcGhMbVkyRVJXcHZK?=
 =?utf-8?B?Y2F2Tm44MDFFQzBaQ0MxaHJDRWNzTzJnWVhSTHZMNG8zSDFSU29LVzdpNDdL?=
 =?utf-8?B?YUFyeXVhcTgzQWtJY0Q5bXRNT3lnb3RYRTF4eFIrUnVVcGRsa0VOUWNkYXBl?=
 =?utf-8?B?WkQxRWhPVWxpeFhKYzkyaU10VmpoTUxIcktrMVAzdkNmZEF3RFJCWG1Uc1VI?=
 =?utf-8?B?M3grWi9uZHdJR2V5NXFBNlppcU5RaEVVZFlhd0lCN1NpaCtUMCtONUxFZm0w?=
 =?utf-8?B?RlBxL2JXWVRvNWhwOXRJSExBRnZHWnhXNzhneUQyRGdSTS9PbFZmZDk5Y3hq?=
 =?utf-8?B?cnhXeHAyWUhVRGdwcXl3YTl6UUIxU2kwVWhUQUYxTDVDejdUWFE2QTJqSlVQ?=
 =?utf-8?Q?ejB0bEdLpgFCj4KKzFTWfOSHAvy4j36fum?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d50434f-dc6b-4941-31cf-08d892aa3b17
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 07:58:30.9684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Dj8cQ6axe7JDZSXtce403Tr/hzD9FwYfBcwJwsBMxnNrEFDVmrIH5Q9382OQGlsCXKFwpWx1zq1vfw3f0jucuUDStxEYGMB5/WCnIaRwh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6434
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!

On 27/11/2020 06:48, Herbert Xu wrote:
> On Fri, Nov 13, 2020 at 11:02:13PM +0800, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
>> commit: 90c4b29eb1e555fee66f8329a18cb8a070090ad6 hwrng: ks-sa - Enable COMPILE_TEST
>> date:   12 months ago
>> config: s390-randconfig-r022-20201113 (attached as .config)
>> compiler: s390-linux-gcc (GCC) 9.3.0
>> reproduce (this is a W=1 build):
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90c4b29eb1e555fee66f8329a18cb8a070090ad6
>>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>         git fetch --no-tags linus master
>>         git checkout 90c4b29eb1e555fee66f8329a18cb8a070090ad6
>>         # save the attached .config to linux build tree
>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390 
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
> 
>>    s390-linux-ld: drivers/char/hw_random/ks-sa-rng.o: in function `ks_sa_rng_probe':
>>>> ks-sa-rng.c:(.text+0x2fa): undefined reference to `devm_platform_ioremap_resource'
> 
> ---8<---
> This patch adds a dependency for KEYSTONE on HAS_IOMEM and OF to
> prevent COMPILE_TEST build failures.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>

> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index ab33a2e17cdf..9ff4fb3236f7 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -508,6 +508,7 @@ config HW_RANDOM_NPCM
>  
>  config HW_RANDOM_KEYSTONE
>  	depends on ARCH_KEYSTONE || COMPILE_TEST
> +	depends on HAS_IOMEM && OF
>  	default HW_RANDOM
>  	tristate "TI Keystone NETCP SA Hardware random number generator"
>  	help
> 

-- 
Best regards,
Alexander Sverdlin.
