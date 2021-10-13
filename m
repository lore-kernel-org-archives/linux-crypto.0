Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B70C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 12:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF5860EE9
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 12:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhJMM65 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:58:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5392 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234300AbhJMM65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 08:58:57 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DCKvPR028299;
        Wed, 13 Oct 2021 12:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HTuwds795mY8svuvtTnRLxPcf0TWDMwnemYCJdEu9Ps=;
 b=MLyD8Bp314wFjTo9XNFmaZSlvNCOXho46LnjCijgrTVRR+bcZJWZg6zkcfJccUON9pxg
 3nX4SqOIZbrW5usRksl9g5b3ZGeqapuwgx+2Xsuy2r1TbC+TlnDQX1r2BZNhAqm2HVS2
 TmtMtlzA/oZ4nKBICY/7Fqw48nd5rgeRCFrXZbyh+lCEN1WaOSDaxmE7NeWACFDBAuEf
 ZX+bdaYFZ2+yHSZWsPZiz/bQSEL4pLF5A4SMrpgyHoUIRWzpkxz4Fdv286j7AP02oJVK
 QZALnNi+pXqMdB95FPIDFuFUWerqv1I+YWNJM/Ik+S11baSc7RC20ho/bwhRMaTaLs5v dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbjbvbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 12:52:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DCp905113913;
        Wed, 13 Oct 2021 12:52:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 3bkyvaq93x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 12:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EikYpX94lCVzBYArADHsxfyAAjlhIgz7TuJm5HqDjcqIAatgehEDv7CeRzXMxwfwXMZyPek/tKsJynBkhvqw30JUNWs+qQvpdJERPRoKhtFFIL3rptt6pPWBQ4B5vJje5v74exlnFcWkp9Ekv1rW6mljLr68yfBoRCL68sPlIGpyiIS+CJC3A8bW7yhIiCumnfvFF0EDPGkzv5XwOxAUzi8aPGQcl93Iej4IU7P6X2npdB8Oige6U77dm+h6eB0qJ/xsXWwp1us6lmLI9RHcKUY+WaAIpPfzWVSyVwBIa2ampIuhF9JCoHs/EuU0oCgllNh88CurAInBcc4ELp6dVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTuwds795mY8svuvtTnRLxPcf0TWDMwnemYCJdEu9Ps=;
 b=Q+3/u+Fz07Z/2giRmVFCd6F+oiXK2NUnJQHFjfWVZ2BfI6HQYzbwlon1L8kMiSkleTTS5ne3j5ZqZ4quK7iZ5N1cMYurL/lau9y3Fcy+Nq8GIkrXEYX8Kh35SL5NXisR1YYR58CN0Xug0iylSsAPG7rwIntwtmy6KOS5wYHweph94f1GOipew6CPkmJ8aQaoHXRrtNXZlRmOaWr8mHKQ8P1vgWIYfZ4lM+pLpLe5VwwvqaMq8cJM16+XL6GZgzRVQl0xwUxDOHCZ6du87n1tEct2DZui34u8i6fy5jVymHrpznagSqMR3nNAAdqhsCnWpNdWG/38f/dc6Ag7Ml0vTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTuwds795mY8svuvtTnRLxPcf0TWDMwnemYCJdEu9Ps=;
 b=REGUG/vv82WjfUgpGImXQnIP6+ZMbSlwAhmY8BBGk6a9Z795UPQnXCC3L8iEJYSCzJyQ38haCxnuzu+YaENJ7+HepHjZgzn2UheB3XVJQSc/0oOiRZ4A4ycE/yo7puNoAI8sLWbRZ6K9obPetxG4RdPRCH6M07lkQ9kfed11CMY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 12:52:05 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::958c:1aaa:ad5:40c6]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::958c:1aaa:ad5:40c6%8]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 12:52:05 +0000
Subject: Re: [PATCH] staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211011152941.12847-1-vegard.nossum@oracle.com>
 <YWbQd51r8R3BprMi@kroah.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <1bfd3945-3487-31ab-5489-9c12c759276b@oracle.com>
Date:   Wed, 13 Oct 2021 14:51:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YWbQd51r8R3BprMi@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR2P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::23)
 To PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
MIME-Version: 1.0
Received: from [192.168.1.13] (86.217.161.200) by PR2P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 12:52:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba94633-d4d0-4f84-e01a-08d98e484286
X-MS-TrafficTypeDiagnostic: PH0PR10MB4567:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4567D6911B9F5B669161F8AE97B79@PH0PR10MB4567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zABE2gAtk9oXCls1MIkf4M0jAhVviX76jVEN48ovjKlUbNyu+NwEbkSeD4Y+PDBJbyRjbwUtlu1Kp/5JTQmQtRPvmLcsVnP+TrpugqDvQlhv8ioRScRCF/kzX8JCJNdT6Yco5UXsAERWcuhYTunHG1VZXdnAnUjk9E8tPGYiNx3zBHZ3FY0gC0dnITkZLS8ob98XxeSX5TI/ezpFUBA4R6+4dNNgGLW5by4wh5Am8S5i1FSNV3EPwWIUTy2QOETHcz822sz807dN+IIuK1MkY8b/Urx2L/nMuCdgvCe8BX/ZggvvgEYRSDwCkvl81eyaIBIZAODNz94I56kvIw6/lCPZS5w4PGip/pxv9IhEYqi0eDFKAOmzwHbf7efY3Qp9iJgn2nBZCXrmZZj/UT4HC+qbtHe2C2m1M0zqWHAeDPdZHkbqYhmE/An+6mHoMfSW4d/o7rUdUzIFit9CWDZBJAl66JI3c+kBFHOdEhhdFnkXptUq7bsZavZV4n3X/nR4sYi/gRHwR0xTk+ab2+N21brLzF/fOQtNgKEkRnHWce3NHGAfyUe6G9U/ZKAVzeDGaEDWVgmWd/1F3BNrnceZ0S6m/fxGxyGLLsxEJdfDphjL/gVV7REMvLftU+xjyO03gZ2hZoeHUiMbMlgtuMUN/Jme++4TpiEA5WLMamWtVfJFQgIFXKvfuKm0laal6pAX8QMIIhVFnvXXB6MMoK5BTNK0dMqfR+UwAruvI68ZVvFXCqO+mmfnS44kB7VyChsKco1Tw7EIVD4Pu7PfY8QFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(83380400001)(16576012)(6916009)(26005)(8676002)(4326008)(31696002)(316002)(86362001)(53546011)(508600001)(186003)(5660300002)(52116002)(36756003)(6486002)(31686004)(38100700002)(44832011)(6666004)(66556008)(38350700002)(956004)(66946007)(66476007)(2906002)(8936002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S05FOEdJY2pNQkpOM1dLUVlzSFhqYlJXVXJlL1dKK0hYOUpGeEVnbTR5ZUIx?=
 =?utf-8?B?NG5RMWtuVGxQdC81UXlBYWdWNUhlNFN2ZjhKRWk3TWt4L3JCS3J1Z2RrZ0hh?=
 =?utf-8?B?QWxlR09VdWNacGxQTzUwZG1saVpxK3RSYmRWc0IvZXJFcmpmVXdUbWRPYVBu?=
 =?utf-8?B?UGwxcU44aGJqS2o0VytCa0t6NUZQbDBlY045TXZsTUxhOVdISnpVWEo1aDJF?=
 =?utf-8?B?aUE0bDkrTmtEL1V3OWJJaDRRN3RyeVd3TDZGYTltRFBrcHRlaUE2QmZPcDEz?=
 =?utf-8?B?dkxsQ3NHZ0k5dUNtSmg3KzNTRFlnNkloN0dHak0yakhLQlZSNjJ6a0FxLzh5?=
 =?utf-8?B?QzRla2lZUEttM3JSc3UrV2hlbXR0QTdsbFpuSFFLblZNZXlDUVZ2VitISXg2?=
 =?utf-8?B?NXpQMXRabjJheG82SkVFMDV4eEFUa0hYY0k0S1RuVVM3L2J3NUlVTHA0bFV4?=
 =?utf-8?B?RWMvZ0RwR3ZvTTlib0RyMlN2d2lSeHljRFdMZWpGeEhZakJ2WUN6TXAxY3Uy?=
 =?utf-8?B?ZysrdXRDaER4RkplMlNaUk9hTmp3VXVmWVFnQkRrUGlPZkhhNnJhVEZnSDVp?=
 =?utf-8?B?QzZMeDlGVkx6YlVrSTA1UHBJVFFsd0FvSUg5czcrSnZVSnFCaUZqSGc5NVdo?=
 =?utf-8?B?bzY4WXVSYUNjcEFvc3diZERsWktwdFZXWWF5djNTVzhvNlZFbE04VUx2dGti?=
 =?utf-8?B?TFdJdTByaVNrbnNJaEdOdVhqVXFRbjZxdVpERnh0Um44VEZNd0EwR1FkTnhw?=
 =?utf-8?B?cGpldU9xUkhpREo2L3hxNlhKejdqZ1RvVDV6V0o4eEJqN1dLMG9GNzc4MUtX?=
 =?utf-8?B?c0M0SVl5ajF5N3lQc0ZVNjIxRkdPblp5ZWVHdXlKblh5Y0JmN2JhdjVRcU1V?=
 =?utf-8?B?SUdFRFNVWXVBYjBoNHR4b055K3k3WXFVQkdDMHpRZTlkVFl6RVZJbzJ0c0tq?=
 =?utf-8?B?ZU1sOFBsYVc1V3kwMkNqY1pZYnBBdm1IQ1lBdXJ1TkUya0tzcThiN0x5eEVY?=
 =?utf-8?B?UzYzeWhrdkFhK1hiRnVWTzZpODIrUk1wQkRHeWFQSzhQQXY3Rno3VVJOZi9l?=
 =?utf-8?B?OXN4bHJ3ZG9maFNWYTJEbFQ0U096WW5odERib3dGMHdxSk9BNERNdzhaUzFX?=
 =?utf-8?B?SG5MaGN4aGp3QTVuZXV5ZWd5aHlqMXBGSWhObjlYaHN6UHl1QVdDdVlsRGoy?=
 =?utf-8?B?azJrby9SNjhKckpTZnhuenczS3lDTmZmbHZRUEFjaVdRSUJ2RGZIYm1JdytX?=
 =?utf-8?B?b0Z1RE5BQnFTRXVNVUloejQ0cU1ZQVBYVG9uUENhWWZ6N2Rwaml0RnB5VUFM?=
 =?utf-8?B?d2JROUpQVnh0N0Q0V0VkSXc2SkZleXczVklNZldkcG5ZOEtGcityZjJoMXBG?=
 =?utf-8?B?aVZEc0M4cldZWlhRZE5jZTJCcFpEdENtWXFoK2VOY3BRc3ZZdkx6R0lnNU1L?=
 =?utf-8?B?TlZLWDgveXZmaDdUMXZlMEhDeThLMlFWbXp0U0h0WlBDcmdmTTJwZ2VBRVVG?=
 =?utf-8?B?MDRaSThZVWxOQjRXV2t4U3B1cmRvL1VaUjFjbkFlNXVZNk5PNERCZU5xd1NT?=
 =?utf-8?B?NGNlaXd1Zk9OY2JpUk1jWEpxQTRDVXEwdXJySTN0UVJSUDNneDBibjlMOFRz?=
 =?utf-8?B?MGVJYWx5bFRDeW1pS1VoaE1zTVN3ZFFvSFN3bldNcEZUWkM0NThCQ2U1QU1l?=
 =?utf-8?B?Z2JjVUlDUVVyRU9SQ2Q5azAyc01VVDZERWVNRDh6S0RYN3U1dWdpSmpFdTBp?=
 =?utf-8?Q?8lEfK5FPjVKvfBTOOs48GbhtxLFyslPUJ/Om/tN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba94633-d4d0-4f84-e01a-08d98e484286
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 12:52:05.6402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIAB485OELIULiDr48TJAILI2rNNCdb35BYZa/XRmOOS6/kJvZ6ce+SBqeK/NkTj6r8VFiP8d1evg0fnPG1IKOmS1lPK310gmvoW1ezThBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130086
X-Proofpoint-GUID: kP6L6sOwViXMB-6Om0hNxpIFQ_cKth4N
X-Proofpoint-ORIG-GUID: kP6L6sOwViXMB-6Om0hNxpIFQ_cKth4N
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 10/13/21 2:26 PM, Greg Kroah-Hartman wrote:
> On Mon, Oct 11, 2021 at 05:29:41PM +0200, Vegard Nossum wrote:
>> Fix the following build/link errors:
>>
>>   ld: drivers/staging/ks7010/ks_hostif.o: in function `michael_mic.constprop.0':
>>   ks_hostif.c:(.text+0x95b): undefined reference to `crypto_alloc_shash'
>>   ld: ks_hostif.c:(.text+0x97a): undefined reference to `crypto_shash_setkey'
>>   ld: ks_hostif.c:(.text+0xa13): undefined reference to `crypto_shash_update'
>>   ld: ks_hostif.c:(.text+0xa28): undefined reference to `crypto_shash_update'
>>   ld: ks_hostif.c:(.text+0xa48): undefined reference to `crypto_shash_finup'
>>   ld: ks_hostif.c:(.text+0xa6d): undefined reference to `crypto_destroy_tfm'
>>
>> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
>> ---
>>  drivers/staging/ks7010/Kconfig | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
>> index 0987fdc2f70db..8ea6c09286798 100644
>> --- a/drivers/staging/ks7010/Kconfig
>> +++ b/drivers/staging/ks7010/Kconfig
>> @@ -5,6 +5,9 @@ config KS7010
>>  	select WIRELESS_EXT
>>  	select WEXT_PRIV
>>  	select FW_LOADER
>> +	select CRYPTO
>> +	select CRYPTO_HASH
>> +	select CRYPTO_MICHAEL_MIC
> 
> Let's try to rely on 'depend' and not 'select' please.

I used 'select' because it seemed to be the established pattern for
these options. Compare:

$ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO$' | wc --lines
1

$ find -name '*Kconfig*' | xargs git grep 'select CRYPTO$' | wc --lines
66

$ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO' | wc --lines
87

$ find -name '*Kconfig*' | xargs git grep 'select CRYPTO' | wc --lines
1005

That said, I have found several other cases where CRYPTO_* algorithms
are getting 'select'-ed without also selecting CRYPTO/CRYPTO_HASH, so I
definitely see the problem you're trying to address.

I've added some more people on Cc to see if there is a consensus on the
best way to do this for the CRYPTO* options going forwards. Thoughts,
anybody?


Vegard
