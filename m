Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB70BC4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 20:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9148260F38
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 20:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhHPUBz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:01:55 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:39009
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231259AbhHPUBz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 16:01:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ljsj++kOuIwJBjVIxsXFBwcmMpelfS8McTeQsv/WL52FCIr7inUGHLH+M+SjinUpCB/pBphmnMiifXg+pvOMllAkkLxOc45LDQdshqwWzpILd/xS6N8qobNqRn7W8BqoImjyD87LYm4R5KkwjReNYXbH2PHm8i8YI0crgFzByVM8bjlrz+2/cSVWlIVnyjd5xmRe9BzXjRj8fUNalomxTT8U5DZaHKM3939Zvz1HltGshq5970PxGqoo0eq3lVgO9OroVJ5+xDCA8Gg6mk2Mplf0+NB1L7cg6fOsHfzmX1kyfeAAi8TwM/UyPr06TdPW33vKR1MEHAKCO+rzcahyXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fjcd3Cn+MvdJEjSps5n1va3gL+v2UoCcqH9b/Kf5Yro=;
 b=gJg1Tb/JnwZIzKPLaUrZzBHfS8CC1Poul7JT5p8a7o6kHQZvVcP9i8KW3u44Skkw0ParhJdOFwQwXaPL9NqyZZeBdIMsWQHGrpRS5ox9ScHJGonYbl61p0+z/3NL8n6rHYUIXsLH01sHXuT5xUsN/OD2E7XqJI8gWKUJxeCZW1RfMu4aBpMq5mTFuC6fRM4F9UHSa2ek/Zqwub6ZuLCyOLe5Huh0eVoyp0pzY3U/pwxOItRXCZdJLYLpCpoYF+qVVrjJUyEv59YXXH4hfAojl6L14q0K4xN91oglSjkiMmH1MUrgv3XImtMvtwzoPLW4xb1kf/PFXFtwK6eZsDQK3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fjcd3Cn+MvdJEjSps5n1va3gL+v2UoCcqH9b/Kf5Yro=;
 b=FL/LXYArzMkvmr8M77cC6RE+MHeumqFS7KvVhP6tv8D8Uz8r4SD0AOyymV7j2rMEQ7rbXaqHv8346WkvVr4qAv91xnHaar3VBtp8FB9ZCC8C3uKGvuAyS8DyH/ZRN8IDFjSEjzdMUd4dce3d/UV1XXlRzKern2Lu9WyzMMklB0k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5149.namprd12.prod.outlook.com (2603:10b6:5:390::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 16 Aug
 2021 20:01:21 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 20:01:21 +0000
Subject: Re: [PATCH] crypto: initialize error variable
To:     trix@redhat.com, brijesh.singh@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        ashish.kalra@amd.com, rientjes@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210816192312.1291783-1-trix@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fee6dee8-7193-f88e-bad9-5f0985dc4c40@amd.com>
Date:   Mon, 16 Aug 2021 15:01:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210816192312.1291783-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.241] (165.204.77.1) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 20:01:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fd4bea7-6cca-4b3a-8a9c-08d960f09e6f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51495B9EC5C4251FC5E0D7D5ECFD9@DM4PR12MB5149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dCCAkKdb1IYsACqEpnZUwRg7qMPVJIGApzuugKGQ+CJ1GLqvbG2p6OH5KVJTWW58LKKrMlEhsrh5YmwpTOYlh5U/W/ZToI4P+g2+TJ4ZHCZTxFuZ9oKpVnKQo7d0DIDMYREHD+s0z3d6qRl6as0/QT7yqEOz2vmAHSpFedQmPH6OffcKsSCJq7j1kb28NAdsmh+R95RniMt2jGMFlGKZ848ttb+jX5D3Xk3U6F6mY//lQBDlkkiuG3OmWhTZ0dmQUKOYDYy5apxiOeMvuiHe+yYi8gHEOcZSNsp6TXZef1tMgy9nkReii6x025uWg1LMNn3ZOhkl4nUa3zbzWGm2lG4pDXxT/VQrhMIcDUFy8Z2LBcKGnMrQWs8X3DKR4Qh5sqwbRGocwRwKoTYjPHJL9vtaltmP3ZmimYyHf2FvRpblKc1sYuX0BKYvf+8jfSSNJl6nAHwB3tqTXmB0V0Wb7LEzupmb3CZkeH5pg5buPphcGGUdoFLNmCucIN8d1gGI/lfGB6XjC1OcsUgEBeUsNcDoDX75hQ5gQdUvsRmKvY9FPuLVDzC9w9Gr4a21J/KG3cNUDBI4kq2zN6YHg2AlFwVxOO1vbE6fLVWz1v5gLP3XxCSTEIqR1CuHl90n763HDMSiYuMkZP1pLKd96d4jby4Xw9cw8ouDBPxrwrHyl7zTXaCrfVaHF3AkyvczBZGMRptL4bl8Xjrjt9RRvhChJCiXZO72nxxU2zG8gvGha+GRNtGcssHJqUjqJ8hORD260GYr/+RVKDtbvmpmqcglPAidXS9YNwViANsct7KlmfZmooTBlHqhnXTsZKpt4Iv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(26005)(66946007)(8936002)(53546011)(16576012)(86362001)(31696002)(2906002)(4326008)(478600001)(5660300002)(186003)(316002)(66476007)(66556008)(8676002)(966005)(31686004)(83380400001)(38100700002)(956004)(2616005)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3NaZE1kTDdwWnpVMGZyc3luZWJlcEIvS05vL3QyWTNST3hkajZycEJ5WnRO?=
 =?utf-8?B?dENJbDRpblcwNzk0SU1vZ1pZeVRrdEMrUUZrVUI3Q3JieUhKeEE4WTZYUW5U?=
 =?utf-8?B?V2ltSnpVVEVhTUFjUVU1ZER1eHpBcERELzFkZlRHWTAvdlByZDZDN0FWczk0?=
 =?utf-8?B?UlYybWpDL2lXcjNNSE1VT29UUWxIQ3E0dFJZckpubFdUQW1vN0VsZ0NtU05Z?=
 =?utf-8?B?WngzWU43U1hVVXR3bGx6OURpRzNlVEQwQk5xb01jNlgzMzU3TUNRRTlLcGda?=
 =?utf-8?B?UUFHZUlrcXhmUThJUTMzN0V6SWZvT2hFeWhSRlk0U3l6RWxHY0dSSTlPZk5O?=
 =?utf-8?B?UFhGbUZtK1piMGoxSm0zMHR4ZmNOZmgvZGRBTEQ1OC9EUk9TQy9Gb0ZUV1V1?=
 =?utf-8?B?ZTFobG1HL09iS0taQkxmSDB6ZE56ajhzMTU2VlpSR2hpanhId0pxM1dpbVBn?=
 =?utf-8?B?WmRMbnpXN0FXelRLTC9KVytsOC9EdDQvazFHVTNjc080RFVQQ1l5VkRySUlV?=
 =?utf-8?B?K1B6ekNMSUNIKzFWeXFWSHFQK1VUTE9ESjFJUW1YOUN1VnJxVFNYdnRNQzBS?=
 =?utf-8?B?OHluUnovUWcvN1BVUVNNWnMwRTk1d0lYWlNVNXBiRHNrRnRxMTBBUGhNZ0lI?=
 =?utf-8?B?WXMvZmJNZGg5Y1FNTCt5NGdDTHVaZmZoL09uRFdPOU5weU0zUFQ4eVZaN0Ft?=
 =?utf-8?B?SWs2REljMi9hNUdvbXF0ZUJjY1lHM21pWVZPODE4WFpWbFlKMll0K1N4eGsv?=
 =?utf-8?B?WUtkcjRST01OZEtPd1NmNXNhMjFOSnNHNmlBNWNCdElibFlob25CT3VXbVNW?=
 =?utf-8?B?WVJjM3FCWlBPd2xGLy92TGVhOXg5UUxsVGQvMFh3QWtqbmNJeHlHUHBiMkIw?=
 =?utf-8?B?VGZBVWhLUS90WVhCUDdHTEx6SzdaU2RieE5kdlhYb0JLSi9iZ0VWaE1NVGhr?=
 =?utf-8?B?dkMwTlJ0M0ZQZUMwT2xjWXNSMUY5WlBEaEl3c1BVQnd4eHRDaFYvaEh2WExF?=
 =?utf-8?B?bVg3ZUV2ZzZIS2pEK1VEUWxZQXVSYnBYTUZza2xvVlBCRU1ZTStuL3FVdWtE?=
 =?utf-8?B?Sm1aQ2VhL0xSNnFidWNLdmwzdTY1TWovZk5Jd0l1eE1Gd2pRTFZ2aVpJRmVF?=
 =?utf-8?B?eHRrUGtOclIxUk9iVlI5RXRieWV4Y0xHNXZzUVIrb2JmaThQTkRRWkg1aE56?=
 =?utf-8?B?Y0dhdVZsWEFxR0VFSld4QThtM2VKU2t3VUcwT1RIWkFCa3haQkV5ejF0NkdB?=
 =?utf-8?B?bU55WjZIZkQ3VlBwUDcyS21aQU11NEowNEdWMWgwMVF4SG5YTzFQTTVBdG03?=
 =?utf-8?B?UXEwZmRCV2puZk1HNXdKRmIrS3BkaGMwejhDRUlibzNFZkZaczJZcWVKZkpJ?=
 =?utf-8?B?dkJQMUxwVFA5aDhGQ2J0M01QMnB3d2dMRGdyUFNiOENVRHF1Ry9vVkdob2g5?=
 =?utf-8?B?cEhjMFVmR052MjhuY015NDQ3RkNCNGVkSHRDNU1VQXhVdFd0R2J0MTlINm42?=
 =?utf-8?B?cGhOakJQSGJJWUFFSE5JbTdqOVVVQyttdC9hQ2c1NkJqci9Ja2c1ZDB3ajBl?=
 =?utf-8?B?YVRRaUZydkNJcnBNMThtNCthSWlaWFh4U1lnMnozMUpuc3AvYWs3VjFWNmdJ?=
 =?utf-8?B?aE1mN01MQVg0V2YvOEh0V21XVGNrSWhpeUtMWUZRVFA3V2xFUWp1djZlSi9v?=
 =?utf-8?B?bVZkRlhldnZqNjlnbS9ab2tWamRneTZSODhpZlF4dzlRdVhJN3RSM1ZBT1E5?=
 =?utf-8?Q?k696e2KqYauAC1gZjKYW0eZf5uUALLCl6ZeC8Px?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd4bea7-6cca-4b3a-8a9c-08d960f09e6f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 20:01:21.7627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IbPrkisDAIpP4og/Nn01rnc44aSz4uALqFHBPpa+TrD8FNNPmPDhJJLd6cxZtqWkl6W2KyRJxGd7R/6DT8+iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5149
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/16/21 2:23 PM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Static analysis reports this problem
> sev-dev.c:1094:19: warning: The left operand of '==' is a garbage value
>         if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
>                    ~~~~~ ^
> 
> The error variable may not be set by the call to
> sev_platform_init().  So initialize error to SEV_RET_SUCCESS.
> 
> Fixes: 1d55fdc85799 ("crypto: ccp - Retry SEV INIT command in case of integrity check failure.")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2ecb0e1f65d8d..b2b9f0f4daf2d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1065,7 +1065,7 @@ void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct page *tmr_page;
> -	int error, rc;
> +	int error = SEV_RET_SUCCESS, rc;

Looking ahead to recently submitted SEV-SNP patches that will also use the
error variable (and will also need to initialize it), lets move the
initialization of error to just before the call to sev_platform_init() so
it doesn't end up with a possible stale value in the future:

https://lore.kernel.org/lkml/20210707183616.5620-13-brijesh.singh@amd.com/

Thanks,
Tom

>  
>  	if (!sev)
>  		return;
> 
