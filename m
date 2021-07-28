Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8366DC4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jul 2021 20:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5496860F9B
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jul 2021 20:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhG1UlG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:41:06 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:63041
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231126AbhG1UlF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jul 2021 16:41:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGkjgkZI3bb6dcdsAsZ2322adqaSt7ySX/UuITdqBpjNC214VckuYQUQKvaOsqPWdvpzGkkdO93H3DR4o3B8tGhZ+9t2NjJOeceBiv4rptEHwItGefd+QUvqdbpUyPp6/oNQ5dzTemgmMIjVSmX80za25JjFClZu3LOnHj0F3wOQ1fMu27v2PvaTsPvH0WI+7T+VmHL3manqo7VUY2/f1bT1gYob46unfkX8Nmh5od6mhNnY7rzznxV07MrQV/Jf3/FAxanuM8uBQXlIZXmxWjeOH8p1ogYRhHwFPfiLWJVV9P1Ag4qy9teCbfxl1GsEE6jJWUqpxm9lsX/48REnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COIM1J0sibEdE7Yx3uTC3MBxlyjrQ1nm+A964HxlJK8=;
 b=Ik7X3PJZQqtBuElUBFy97wsX947MogzczTYa+G00hGB2WKp/JwwByHyVPLlWnV52oDXmLP907DMS4tedcHNW6A1Jaw3GXSccHAJl8GVBf9wm9pzU5oCxjusEKzQtYlr4ZCJQkVb8SgbJeTPIhNEbD0HBuzCNU82S+fbe3B3qXRcpuN3ipQRhmbajYsTmcyz85aFVQlNZCICxEnpORrVglTs4hcQdGaWxCjE8ZPqABBjTkBiu+0X/A4MXJnyzOcgjqD54uZw386HqOL9oibYul9W0tXILXcplvxIhuj4ESSCl0JGCNJXNX8BSkU0ay98bABatj8SF8PSdtmThINtpmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COIM1J0sibEdE7Yx3uTC3MBxlyjrQ1nm+A964HxlJK8=;
 b=ewicHirv0N7hPKQnA+mr3rhgqcZoPGSvojeSfP/Vwa8OZgQjdX3sFOP213VTv2pSv8n+VgQF2mC/N/Kijzo2cbwn6rTeLdmXnhpMekD25DNBYTRIGD93HGO2xlPilvtZT8o3YYgovV4C79rdxRWTus6MyDncHfr7HW43SBNy+8M=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.26; Wed, 28 Jul 2021 20:41:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208%3]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 20:41:02 +0000
Subject: Re: [PATCH] crypto: ccp: shutdown SEV firmware on kexec
To:     Brijesh Singh <brijesh.singh@amd.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, lucas.nussbaum@inria.fr,
        stable@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>
References: <20210728151521.5319-1-brijesh.singh@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1feda157-49a5-ed19-44ea-d3f2936cc07e@amd.com>
Date:   Wed, 28 Jul 2021 15:41:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210728151521.5319-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0204.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.241] (165.204.77.1) by SA0PR11CA0204.namprd11.prod.outlook.com (2603:10b6:806:1bc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 20:41:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f906779f-edea-436a-c0b4-08d952080362
X-MS-TrafficTypeDiagnostic: DM8PR12MB5397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5397639A06AAAE9F78E13377ECEA9@DM8PR12MB5397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8J9jE202ulMnwh96CTcBxZhxdqUbnoNuMY11xabD8DOGAxVaWmCiqmBvOGTqVIbzOcID8PzG/pkMHGf7F+DT3KP6n9uwt+adkqIjAJ7VKT++HYteA/xUPMVc9xCfkZol3g1OciZ6euIrN17epwW+2rJtd/viZlf1aiNXFnJJbYQN/hLhoMeFMgePdOsmIAwGjesWAmKHkSrZ3pvZk0xxPONQh+cpqUhufgmM5VTlKSwpr1xP4A2AzywL3Yz/zbv5NTTpp2xhhzrbveo1E003/PqzRkc0d3KG9sknnS7xAsTXVvj3ryGEcLs+H8DgIyAuUBefmWUQxZpDzczji7gjZyUCk1KdVkwttfE1J1msv9zGykn6OVOP/HgJF8eL3j3tYP5nt2HLLI9IIXcoLFHYqsrcvcFxD+WbjdAyUGxrrwgnoypWgCb0niwMs0Ydtsy4AaoWLuyEO0N3bT8296Yb/bs8nJd9TrTClhnyFGlujKFNM+ImZ05Q9QBZf+JO4uPNFuQivHZjMwASNbdEcU5lA1uVfUxV14PMcBuEK5x1S0awiKjFaoETjBN1jSgz4dXeLJtkcjn3XY3eifZnELihvuCTNhkCreD0tRG5mN/K2rCP2VjR4OuyCJtXjtt/QKk5dX+ejJlQ6gKFDZJ8i5oNu3QD+jgvfGs8zv45602atHtcCftbG7hgATQ6GWI+p1S2TzU8ypTQy8Ohh4QYtUi+EpfOuAQvQTqHqTqHZHlSIsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(186003)(66946007)(54906003)(316002)(86362001)(956004)(5660300002)(83380400001)(31696002)(26005)(2906002)(2616005)(66556008)(66476007)(4326008)(31686004)(38100700002)(53546011)(508600001)(8936002)(36756003)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVJMVUwyOVNPQnBwMzZ2clM0RG91WTQ0dWpVZkUweVdMUWRlbmsrUGRnWmEz?=
 =?utf-8?B?SGlFQ3k1VVhKOGlVRUdpODcxUm1QL0tpdHF3bkh1UUFjMEJ4MlJFUTBSY0tC?=
 =?utf-8?B?Sno2ckdKMy9ZV0VxazllVzcvbHJhUHNRN0drQ1Q0Z290VGg1N2Y3T09PZFZt?=
 =?utf-8?B?YWFtZDFFZ2VUZWE0Y1B2eFVURmZWcjVOcTI1ZC9sQnpVQ1FIazV5K3J2UitZ?=
 =?utf-8?B?OXlQMmpVbUdIRmlSRlV0S3hneXZBYk9RaW1BdjVFUlVrNHptYi9FVTRRZXhw?=
 =?utf-8?B?Ukg0UXRVWExRL1g4Zlh6bkFIcklOMUJub2MyVnRXdWtwclNWYjFkNkVKcUpS?=
 =?utf-8?B?eTZwZ0pHMVJoMjJMMkkyaEx1ZjJTVjgvcUFsQnhrWXhxYm81K1dESkY2K1Bj?=
 =?utf-8?B?S0tGc1Y2S0lrV3FqWWM5OVZ2ZmsvLzNrOER3dWNiM2JQQzZhYi9hejhTSUsw?=
 =?utf-8?B?OURRVFl5c2FMWVc0dUNJL1pXUVBpT0w4eUpBKzdLTVRCaEFOUysydDRCa3hW?=
 =?utf-8?B?d1lyUFJkTUNRUmhRN1lHSXVZTDdOR3NtRWNyQjVNVnZTcVEwM1lqY09YdmhO?=
 =?utf-8?B?aE1wZTBTYnV6NHIvN0RCUVU5Z0VvV09uOE1RWnlsTXNDMUl2YlUrTDZWWHhB?=
 =?utf-8?B?UDdTQzQybGcyUndHcjB0Tld3VzA5RDViMmRYTkU3cUZ4QTNhWFdvanVvUGhw?=
 =?utf-8?B?WW5jQ3V0ckkyckVzc1A4UFQ5T0ZiVExmSG9mUFZGS0hjWFpRZzlPQllwS0dK?=
 =?utf-8?B?aXgwNzZuWTdDNnphZTJRNC93elorMG1rTElYY3A0K0lOYlZpd1VkQXRDRFd4?=
 =?utf-8?B?Z080ZWRtK0RyYzZ1TTJsdTlobCtDZEs0UjF6azdpNVhwUGlmc1JMN3BIaS90?=
 =?utf-8?B?Q2hDZW8yamZPRjFremRGUmdjZUxQK2ZhRDNvQ3NRVzJpVFpneXNXRFZhbmRS?=
 =?utf-8?B?a3NHZlRkOC9Cc0dFemhHTHB3SU9uZFlFWTZHU2tpeEpUS2RCRmpMZFhRVVAr?=
 =?utf-8?B?TGNBS3ZvT2R3a2QrUGlKWC84SFYrTFphcHZjVlFrMGFpNzhKdUYzcGZ4VWh3?=
 =?utf-8?B?aSt4SVBYdWdRYktrSTF4SmdJSC9QbzRBbGQzelloU1AxSjVMcTF3RS9zR2RN?=
 =?utf-8?B?bC9GeDZhNHhkRGNrS0VWb1lvN0J4RmJYYWJZeGczNXJwdE9aNVlOMFlST1pw?=
 =?utf-8?B?ZVhvZE03aUR4ay9EOEhTbjkzMHgwYUpGNW42UXVTcXJpT2R2T3FOMi9nbEl0?=
 =?utf-8?B?b1ZZZHhlZDFUbmxERWl4UnJCVzRDMHFyRkpMWGRIVUxheUdGRnBFSjlpb1or?=
 =?utf-8?B?THRXWXRQcnRmUGhVaHl6YVU3djU2ZWdJSlIwWDRicko5NUhGSUdPb3Rjcms3?=
 =?utf-8?B?eXVKMkFaTForaXh0NUVZTGpvWS84dmJCVTV4SVd1enB4M0J3bnFUYzVSZmM1?=
 =?utf-8?B?VHRYY0xvWDR2QUpvSlhpNWROYmZOR3p6NGc4Yy9ScW11WDVVdVJRRmI1aUFG?=
 =?utf-8?B?cVgxTlh6aDhrRWJxNzNVR2M3ZlByYWhUdlFLNXBtZTlRczJQdXptb1dCZTgx?=
 =?utf-8?B?MlhSZ1hQRjM0VmtYR0VsU1EyZE8waWhpRGRlbWhHZWtsQjFXeU1WSlR6NFRu?=
 =?utf-8?B?NmFDSEYvSWxnK1VpRGt5UDM3YTJlMmNZbTI2Z2wzcTJtK0lIcHBUWE1aR0tz?=
 =?utf-8?B?cHgyNitISmNSdEtkNm5COUZ0SXJ5MTBzeHA0TC83azJQa2JEOXQzRnA4Z0pQ?=
 =?utf-8?Q?LpN/5gveUXxWUWxTVp1juaY+7XiJZMJ5SlauPao?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f906779f-edea-436a-c0b4-08d952080362
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 20:41:02.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcDj1ySQCiGN8SAzbHlLGyubGA3fFzt5kp0pv6TkkLGBlZjxU+81axIuczRM5/GUtII71mQHBlLEadDJm4PpJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/21 10:15 AM, Brijesh Singh wrote:
> The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
> PSP driver") added support to allocate Trusted Memory Region (TMR)
> used during the SEV-ES firmware initialization. The TMR gets locked
> during the firmware initialization and unlocked during the shutdown.
> While the TMR is locked, access to it is disallowed.
> 
> Currently, the CCP driver does not shutdown the firmware during the
> kexec reboot, leaving the TMR memory locked.
> 
> Register a callback to shutdown the SEV firmware on the kexec boot.
> 
> Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
> Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> Cc: <stable@kernel.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@gmail.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
>  drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
>  2 files changed, 35 insertions(+), 26 deletions(-)
> 
