Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD22C54FC9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CE32075E
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="SVdRKmSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgDUNPW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:15:22 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:63585
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728864AbgDUNPW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 09:15:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3yenT52Zp9soF035NXfsVtw9WJz1hUCDn9xdApBOIEF8S1tJ1JltXrtZI0i71s6HhQO2em3WmEv2enQPNdF3wsYvOwEOrjDPCNIUS3AtHjnOkbuq7tlr+lWFAttx/kVVk7w3BbdTG9/Cu+PdfIZK5pWAaJDGf1AoS4XCJ3G1VjMSdLw9Entx6NzhovDWKjPPQ6iF4B44RXMy0Sf3tEBgJgPN4f/YwUQK/Egz+li91Y6RJXMs2PH0l2LljYXJsfPoC5YzVbbmV/NIVwUpaPO37P7CZ7E1wZt8l7anARboL++9wweD9c/cG0RriKmal2ifLQSmSh/m6IerKD4qFFVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a8iec2p6hvtnn4WIpgz98E8hxI4ZRKagsE23dA11ro=;
 b=fYAeiI6umzZYBPQqjEmH32Ck/rTST0+L0ksb554Awh/44q3VeXAU4E+pEbnWKC688tDidL1h2CP3H+1lu6MTjO8+tIsbJhW3Pdw+omMf2hHoOL6vGb0vf35wnfHa0Pj6/cSypDlmx+PjlYHz/sG/FfCPwRspFHYif2xmVZ39Sxa9fPoFcB9aKFwWgtzdSuKZWBp1sHrzNyghdu+YzRg7ADjH9P7NqD0OZAMqUxL3LRYi9yJnIumBWBDMXXoZclOy48Jgj6ZzseejaLpEss0tiRe6TzrYXBdBqIGc+Q+5fw7px8nom5erViaJe3IT1R9kXcWT37bmVCdlHdM3AWbvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a8iec2p6hvtnn4WIpgz98E8hxI4ZRKagsE23dA11ro=;
 b=SVdRKmSXTmniFqve0iA5QBoA0ync926oLyuevmeQk4akD5GdkT9dnlxfgeALDE35E/hZ/r7e67gVyvAnr9C2lrIVJaeKOork7RpSvxQ2hc4IxN9NEMaDQVnrb8MVQCR9y1+sY8pVwX/bdN1w+oYIIpciv2P2Y05Ixsxp1oyqeyU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3482.namprd12.prod.outlook.com (2603:10b6:5:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 13:15:19 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf%4]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 13:15:19 +0000
Subject: Re: [PATCH] crypto: ccp: Add support for SEV-ES to the PSP driver
To:     Joerg Roedel <joro@8bytes.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <134926f3bcd38e51d5d0b0919afc7a16311d9c0f.1587412498.git.thomas.lendacky@amd.com>
 <20200421123311.GJ21900@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c609bc22-735a-0db9-3367-0713898707ab@amd.com>
Date:   Tue, 21 Apr 2020 08:15:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200421123311.GJ21900@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0015.prod.exchangelabs.com (2603:10b6:804:2::25)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0015.prod.exchangelabs.com (2603:10b6:804:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29 via Frontend Transport; Tue, 21 Apr 2020 13:15:18 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf6959c8-2d5e-4c25-b37f-08d7e5f60a04
X-MS-TrafficTypeDiagnostic: DM6PR12MB3482:|DM6PR12MB3482:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB34826EE296627C183AC0A8B5ECD50@DM6PR12MB3482.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(316002)(6506007)(53546011)(81156014)(6512007)(8936002)(36756003)(6486002)(8676002)(5660300002)(956004)(2616005)(6916009)(31686004)(26005)(4326008)(478600001)(186003)(16526019)(54906003)(66556008)(31696002)(52116002)(2906002)(86362001)(66946007)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yg1EQ0YwV2hsDYbN6UQLcnqlAGrlNjqszscXONbl2JrIb3cbz+a4CJQz7usC7UfOmH1MbeWHKSFZQOhcJu51iycEW2gZ1nYvBC//i5k6+UOJNanhhn0tSuEoBWKYWAuoUXwyjAKCcvB16TWpohno1zMpeaAId3UQ/hoBaLiItYqgMwde9tRd7r6GZPvysfLz8nKE2/e3pM5z33Izkv657bTyY12cxx4r//1YyzK4M/Aeo/X43G8HU+oZUXqZOBEQo5MZexHtDGpjWFGU3MyiZ7dwS86Cye8RZzWDtny0igntwqL/glIkW/MuvZqbICFogQvvsAeGhwi5yoSijq2aIGQB/fKrN/ShXp7/7ABFFIhmLvMUDDAvkAT1NqOhhdFy6PoaE0WEH4OjxlWxTk4zVhj4vOwHqhwSJ/9yCTD9iRJt99pojINUG3hSAlzhNhuX
X-MS-Exchange-AntiSpam-MessageData: VvEyRc7cidEo3tnuet+DKyxXtsRqdatmBDxVIxdf5hNAaiXd4lasPW12AInEVth+0SZGp+5mHMB+MEzJIfmXDx1jsWeTVGI4oETQNcXsQQcC6kRnL3d5FwlJQ2slS/mtbJ7WqV5f+rG8uo/r4v6K2A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6959c8-2d5e-4c25-b37f-08d7e5f60a04
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 13:15:19.2028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ualcNeEBUrbPrv0ldIys0VRBHQN6GvWfD2BeYqxrPVf0RP7MVQt5AAr4OZEKJEirvf+Nc4Cr6mPesCrwort9aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3482
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/21/20 7:33 AM, Joerg Roedel wrote:
> Hi Tom,
> 
> On Mon, Apr 20, 2020 at 02:54:58PM -0500, Tom Lendacky wrote:
>>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>>   {
>>   	struct sev_device *sev = psp_master->sev_data;
>> @@ -214,6 +226,21 @@ static int __sev_platform_init_locked(int *error)
>>   	if (sev->state == SEV_STATE_INIT)
>>   		return 0;
>>   
>> +	if (sev_es_tmr) {
>> +		u64 tmr_pa;
>> +
>> +		/*
>> +		 * Do not include the encryption mask on the physical
>> +		 * address of the TMR (firmware should clear it anyway).
>> +		 */
>> +		tmr_pa = __pa(sev_es_tmr);
>> +		tmr_pa = ALIGN(tmr_pa, SEV_ES_TMR_ALIGN);
> 
> No need to manually align the region, see below.
> 
>> +	/* Obtain the TMR memory area for SEV-ES use */
>> +	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_LEN));
>> +	if (tmr_page) {
>> +		sev_es_tmr = page_address(tmr_page);
>> +	} else {
>> +		sev_es_tmr = NULL;
>> +		dev_warn(sev->dev,
>> +			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
>> +	}
> 
> This allocates a 2M region where 1M is needed. The page allocator gives
> you naturally aligned region for any allocation order, so when you
> allocate 1M, it will automatically be 1M aligned.

Ah, I did not realize that. I'll update the patch to allocate just 1M then.

Thanks,
Tom

> 
> Other than that this patch looks good to me.
> 
> Regards,
> 
> 	Joerg
> 
