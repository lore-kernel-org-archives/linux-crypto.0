Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C42C433B4
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 06:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2216136A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 06:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhDEGk0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 02:40:26 -0400
Received: from mail-eopbgr760050.outbound.protection.outlook.com ([40.107.76.50]:58753
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhDEGk0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 02:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cP55PfK64pgecrQTtfyX1s2R9hJ5ky5RJXKbsTXNzhYZifp3e+ZZlJ4H+UItiphkT70enFftUiUVDy1xatWcli+Ko/iz1YPK//5T8ISScnK5+1PDcvHZH4npDQghL7UkjNpcR5Kund6xgnEVVve4SD9wJK+0YboP2otTgaDzvTo22PXAap2t/YCjo7yOg+WtDBgQfm9VbZsbq2qxeXKhowk1veeD3mKKiUnYr5U+KOH0I62dlF2TBHuInO1oc9YrFuEpWeGVZa+zoAX2wYZoEZ7d4QGFWC9rmanjkLJUSMa5xlCXh4sU5W0mhcA54DS6WKv4kNNvSY2HC2k0pxjyYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjwCd0ErUnV8HfaVb7drXt+RQpgg9GAWL/3yZf18sgE=;
 b=jbJ38+dU/hJfzGfb0X7oIbaCTQaqN/FQQp9xkJVWd4dl65J8KMAzYopLBNgQLIa7917dSSw9w8784KYVEIwUznanm3RksF9VwQnwsGUOCf+D9lB05pLpbPybrOOP+BXZ//i8LKa16gJqaSsPjGEi/ugFzqCk8GZRfPvcEPDp0mQ0diryHmkv4p2EXjdNr3uOyGIf36c+lh1pA6j5B0+NzCV4sOdgrW3I+ACgN4wd4mKFV9WkopJTUDSUtg7hcCojnuRNr8Aww8FsQSxwg6FK0KvnQFu9iqYE2Ez3PB8/CVVJlLHbe6KRAA+q8JObWfzwTQ5EcErGncSDQFKqDSBq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjwCd0ErUnV8HfaVb7drXt+RQpgg9GAWL/3yZf18sgE=;
 b=MaqqwwwncM07nKG5vkjsEE7zr6glxcqF3l3OvJuWd1ogKwJS8KB9pDT3816pVDgZ6FQxuN1MIyyxLbmuKXpfXdRdqGkzz3/9aYgMkn/n9m7is6f1/0VGUY0rpW1RAoSYkft+tMeOzfTYCeLtXytHkouPDl6GJ7Qd1RyetYqMr6Q=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN6PR12MB2815.namprd12.prod.outlook.com (2603:10b6:805:78::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 06:40:18 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::6999:4ad6:8648:9c8b]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::6999:4ad6:8648:9c8b%4]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 06:40:18 +0000
Subject: Re: [PATCH v3 0/2] PSP TEE driver update and bug fixes
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
 <20210326092919.GB12658@gondor.apana.org.au>
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
Message-ID: <8361ffb7-d4ad-1663-8b08-b0becf1835c1@amd.com>
Date:   Mon, 5 Apr 2021 12:10:00 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210326092919.GB12658@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.138.129.146] (165.204.156.251) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 06:40:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2a80013-0696-45c4-e692-08d8f7fdadaf
X-MS-TrafficTypeDiagnostic: SN6PR12MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB281542B9F81B463303DBD11CCF779@SN6PR12MB2815.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MQz+PoR7KJca6qX9zggsN4c0fXaf91gVvCFEwntQwFXl4ZLbAi0kUmSwmsuB1aWXvdR8ZTNRzviwryGW+/YleaSlD314WrN1AiRX6haaXcmmhUcE5RJSzYly/06sWSWcivbWmw5CamyPh7PwJzfvnzFY5DYZY98zbLibUf8wU0DR/vFWg701Z1Uvj2Cm5IT9FVestC3blNbnFDf/Up7RpzQIQg60K5/WSKePjzv1VP6GtX0ubU+yWKDTauxFV2pO9OgABb/HqVf82mEpmTIbyi0XZSQp563aMSD9sr2pTHJuhWqUO1u9DzZ8W1/6xBy/u7ssDp5Jxknb2H4DiRc0STf+G3Wikp8vlHlgSJnSKRwlxVKepdNo1FkQoUk6aJmtgOoDVkgDFPqVB8NXzg3lKXV+Ee4XQiqPIHIzT0OJjFE0UHFs+RST8QdPKJP9zQb32dVdyi25rQ2h5ynThIcvB9unjegnK/QPHQG+WN1J4J8QRJSvnwPwLfRz44VsGRCGuOL+pTILhjouquZEVHT6gWxlM1P1j6cHhmQjnnl3ZdswVcFe0GZW+1e5ADhjap4PKaDPbtMtcwCQLt5e+9ibJO/sFB/aDzrl6ZiODndnZLUfs+VtyD9KS+iL54q26yCMnUiMJGDu81EXivwWfEl+LD666Eozg7osU5btQiXvER3ab35oKDJGCRwZ80WSTji3p06yTcOVW2LTakh1zmf2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(8676002)(8936002)(66556008)(66476007)(2616005)(66946007)(16526019)(86362001)(26005)(5660300002)(186003)(15650500001)(31686004)(54906003)(31696002)(38100700001)(6666004)(53546011)(83380400001)(52116002)(36756003)(6486002)(478600001)(4744005)(956004)(4326008)(6916009)(2906002)(16576012)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NWU0aEZnaEJrMEFiMGttYVBpS0VJWTFtTmMrYWpndjI4L0V2NWhnb0daSWlX?=
 =?utf-8?B?WEhVeDNiUHNNenJkSHR1Z1cyU1BVZzR6b05oN3ZSK2xmUUp6c3VzSmxlRFpo?=
 =?utf-8?B?NzJ0aDRDekpxZ3RrU3dQMCt0YTRYS0Rlcy9yYUJvYlk2TjFyVEp3RXNWaEp3?=
 =?utf-8?B?dmNrY2VWZnIzRlVxbTlLVlhxaVQrSlZwaUtYZXorUEhQL0NpNXZxeWlYMG1x?=
 =?utf-8?B?VkN3WDY2QTRVY2xYSU51b3M1aWRYd1IwOXhtZThIV201eS9pL3NUQVRWdHNS?=
 =?utf-8?B?Q1VBVjNHcnhnZHpqUG1YMGVxV09Ic1VKd3dQVlpPWE9YSVdtbHk4VE9IdzJL?=
 =?utf-8?B?VktZYmVuUFQ1SXpIMXRjMG0yYWdqcWJUNHl6RDJJdk1vMDhaeFNrTlZ0eitL?=
 =?utf-8?B?R3QvZGFCUHFPajdaVXdUREFhc21TMTNOYWhWYTRSS2puajVkei85S1g3RUlQ?=
 =?utf-8?B?dm4xNmRFSy8rRkZpdnpETXMxN21vWi85MzFsQmlDR2JNbVNiUTVSRjJINVJt?=
 =?utf-8?B?RzdyV1JMaysrSXlCbXhQdlN2L09nSCtJOExTaitBWDBkQm1MSXB2WldZTEI2?=
 =?utf-8?B?Rjhpa1FMZTY2L3dmT0hMekFFTHJwNUZBQ1paczlDQndweXVsa2JGSnEvZkt0?=
 =?utf-8?B?dUtDeWNDZERkMFE1LytBUXRCc3ZxT2l2anlPV3htTiszQWVocmNBdTV2WGJ2?=
 =?utf-8?B?MFB4SFFRY1l6YzdLQ2FBVDlTMUFSbGEvZW9LK1lZcG02RlhxeFJVRmtCdzFn?=
 =?utf-8?B?b3liRU5Cdi9wbE1oY1BlSllwTmhkVGlkbWdPSnRuTGdEUHlSdVlSUXAzblVo?=
 =?utf-8?B?d3F6N1FseU4vc1JYYUhFVHRaTTZzU2pPby9wd2syTXJmQUhnZ2gydUEwN0hs?=
 =?utf-8?B?MHp3bmpNbC9wNmQyeUpYVnJjNUhYZjc3MDhrSnYrVmcrUXoyS2QyK0FDUUow?=
 =?utf-8?B?VWhMRFJONHg1U0xGZFZZUmY5NUJFa2xITXhrTGw5SHRqVTMyYVFMUE1RRHhG?=
 =?utf-8?B?VmdxTnkxQmJGTC84VTN1Wm5scC9qU3VMb2ttdk5aNEpDNzVRNGtQc1AyQmVB?=
 =?utf-8?B?bWl0d3lmN1MxS1JML0lyTlc5bjduem9Bb0cxNjdadm55c3VGZWkweG1aMU1j?=
 =?utf-8?B?WS9FdWlRQkZySWRGekJYMHRqcEVuNkJUMndRY05TTG10NkRjMEkrenhhYVhK?=
 =?utf-8?B?SnplZkJISS8zek1oeFErM2NDU00vMmZObzFFa1JSUzFLTGs0Rm1VaU1CS2VR?=
 =?utf-8?B?TC80TFJUMFNiaTZMdnQ0K2tnem9HbVF4N01ieTh3T0lCY2tHUWxVNms0ME1z?=
 =?utf-8?B?YUMra2JmZXBCQk9oRThmQjZSL3dsTU03bytPc2xpN01saDJ2VW9DTVR0TU5S?=
 =?utf-8?B?RUpxZ1pIaGNVNmlqVDE0QUJPdmVMQ1JKYUVUc3k2RHBrK0NLZEptd2FnZDZQ?=
 =?utf-8?B?akpWYmhDRnFyN0psc2xWMndKTS9Bd2dRSE9FcnlubmFSQ1BpSmVvOEtjVW9h?=
 =?utf-8?B?SVkyaktHTEJnYlFSZXBHMWVkazNjQjdvUE43L3duSDlSRm9tMU1uQmVDSk0x?=
 =?utf-8?B?T1luc0pWMDZXZnRZd0dUSTRiWjBPbHhKd20rbHZqcStLcUxPbkxOazVoNlBL?=
 =?utf-8?B?TmJyVndRNUxPQlBkQk9oRmJqTUh3Z0F2akdvYjJYV3RUZU1mc1dWd0J6a0Uw?=
 =?utf-8?B?MWRoRXgxQ1ZOZU42OTBZNTdNZHRoNm5yU1VvVUg3a3NQdlBjOGU4eGFVclRn?=
 =?utf-8?Q?B1Iw0zHBOPm/uW7pwkHS2aAjSsbN5LajQiuR6yM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a80013-0696-45c4-e692-08d8f7fdadaf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 06:40:18.7926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wq7sW5mCUZm0ek8b94y+amrbbfEDWOSLgc8WJstITAO5HKGu0058ILu0nRh4992F+HGhg11yfBorDTe3WAcSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2815
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/03/21 2:59 pm, Herbert Xu wrote:
> On Mon, Mar 15, 2021 at 01:55:27PM +0530, Rijo Thomas wrote:
>> The first patch helps to improve the response time by reducing the
>> polling time of the tee command status variable.
>>
>> Second patch is a bug fix to handle multi-threaded use-case.
>> During testing, race condition was seen due to missing synchronisation
>> in writes to the TEE ring buffer. This patch helps to resolve that.
>>
>> v3:
>>  * Fixed checkpatch.pl warning
>>
>> v2:
>>  * Updated copyright year as a part of code change
>>
>> Rijo Thomas (2):
>>   crypto: ccp - reduce tee command status polling interval from 5ms to
>>     1ms
>>   crypto: ccp - fix command queuing to TEE ring buffer
>>
>>  drivers/crypto/ccp/tee-dev.c | 57 ++++++++++++++++++++++++------------
>>  drivers/crypto/ccp/tee-dev.h | 20 +++++++++++--
>>  2 files changed, 57 insertions(+), 20 deletions(-)
> 
> All applied.  Thanks.
> 

Thanks for pulling in the changes.

Cheers,
Rijo
