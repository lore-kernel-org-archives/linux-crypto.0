Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276F5C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E4B361056
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJ2Non (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:44:43 -0400
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:65405
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231418AbhJ2Noj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:44:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZRbeBhK/eyReQKXOmYgdF97cAgKYtYKZKaeriWHYRcu6AuWeuU0vzePPnGC9oLcdZygBCoaWOCpEuLyaaVcG7bRY5tuCh3OSZfMBW+zp/U1kfAP3jdWr/yi26ViH42tSXygRkKCKwphFeG2wdnmFPkWfP50CCHM/Zr1bG+mWHm7XzKLwawVMEj+jlLv0zlX4EWE9zS1vRhnUZqzGwk2dqI5eReAdkoq5kc/nE0rkWK6FDZ6qkHARx+y8wTp8Td5z2tVOJADZ4wW42j39kkCNQJIxwd9nfMkDoezNM7n/LbJCwZ7xwVZ6LZAD84VgY9aDxGI5e7O+BAU7897wCUFlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4z6pEKh6yoEOBq42O/n9W4K2fP+ac+FKSJT3OfX2nBM=;
 b=AA/116987PvrLOOZi9AUs2wjk60nJazRC4Q2gs5IeDSROjQboYmRTkCFNHXkOViaZMxecz8UOrOxuM4hHyKUeYu4ZUxY0a70b0TGyuTZ6lS9dlhTri42EYY42THJMz1OG+zX6x3D5jD7KMuQjid62vqF6rii8ZEP09GlnwHkuQOCQGaJ7gSHIO39mQ07BAVH7B8//gCJkOrJpR5jg+MHRsSQklghTiLVco7ck49K3bZ5551ntyWYqq5tOyPNXeh6pzvqJxk1T1mMRL1dbJ4VPJ3t5WdfoJhhROszaa+hmN/YYuCvBHuSOV8Hn6ywL0MqavFYYK5k7gRh//QupHSJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4z6pEKh6yoEOBq42O/n9W4K2fP+ac+FKSJT3OfX2nBM=;
 b=zyjFEvxz/XuJVVcjn8RdyidVOMiRI3xvroYSqLOuKVFSL2s6YstOkfWtzxdrcRU43OyAUBxa/pNGRhTWbNHGWL0mpR482KBaduJjDivjLqQMqpYE/WbqcEC9UqKbh/vfYMuncHLXAB99tWn6dYTjyiewV4W77S2BHH76h0i3odo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5232.namprd12.prod.outlook.com (2603:10b6:5:39c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 13:42:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 13:42:09 +0000
Subject: Re: [PATCH 2/4] crypto: ccp - Move SEV_INIT retry for corrupted data
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211028175749.1219188-1-pgonda@google.com>
 <20211028175749.1219188-3-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cbab86b6-4ddb-e33e-1605-9c9e20bb3488@amd.com>
Date:   Fri, 29 Oct 2021 08:42:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211028175749.1219188-3-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0046.namprd04.prod.outlook.com
 (2603:10b6:803:2a::32) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0401CA0046.namprd04.prod.outlook.com (2603:10b6:803:2a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 13:42:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 180ce80d-9ea6-48c3-ea98-08d99ae1e78d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5232:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5232A2B00A02ED62EC77FE32EC879@DM4PR12MB5232.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zX4LHfkFspo/RVoQGLh2xozRTknmA4eokdSIyUsgVfgjca+6DK/UW48h1uT45Iy35QLkiA9ESCg7lLaAc/pg72UQAbnpFhJf0coNqVXB+D607C/fKcfdZbwrgHpMrlKLpOQoEOxXY0ns5ADCzXGtpdruHW//7MUo25U6aCWjS0XuHSATMTGEb+JW9kwRrh+pzT1FxhYg1XVDktlLQRQwd+Wmce1LiZCDKIDEGOFuzDa7jDqHqppXTDyQjDEUrNaqrgwjRQwl5Y7kQEBXYZ4SKbjp4snHX/WQYIEGRXjw/3AcZYCNOOUWCusJrFr1jS/Cg5WCJt5cUkbQL5oz3IcgWxXAmkpzh0QCK1yjNnnZ7frXd0zKWZUdXIFBbns77zeIj2w3BIr8L3WJ5CNOIC+sTgUX7z93Y9BqzR2Sw0/+oRWUzdg1JUff7Hz8Esy+dJKv8B7RMzq+demlpH3txhJGQNhwNSwOk2OnFVfoGg2+xsI916c08IeAyOw0wZ8wl7GrvyBkHxs1DCH418VkJAcBlm2T8KC04vq9A5G69X+OQ8k+Oo2FE007n8gau6FnJLAvmXYd7kX8FqDZYBgka1nJHYF0NqJvnLocHyoRWGJVDlsc+O++LvDuJPtTLTsFKdw6eumES52sx6TsQ5B75JwtAtaNf/Dm5uemd2T1tr5NHBSg9mC3wd5V7zAmCeUeQZ1j/zE9Jl/SRJa8FsCjBrCtpzwh8vDi7AS4dj2ezzgoYK3Z0Dcl6bSakP1Qy1KWF7NN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(8676002)(53546011)(186003)(38100700002)(6506007)(508600001)(31696002)(6916009)(86362001)(956004)(2616005)(36756003)(316002)(31686004)(66556008)(54906003)(6486002)(66476007)(2906002)(66946007)(8936002)(4326008)(6512007)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFVBTVBhenF1Qm9RRnIyc25VWVQ1SklBM25Fa1lNcDA1TEJFRnB1RlJtbk03?=
 =?utf-8?B?SkJwM0l1bGM1VzQrSFQ4UDRIczVLREJQU1pEME4wRHFaNkx6d2dwNk82eFZi?=
 =?utf-8?B?YUxobFh4VmxoTkxMZTdVRVNuTnZDcjgxdERhNjdyblFac0JZMlhGUnFlSTdp?=
 =?utf-8?B?TnozUWtsdjlHa1BoL2JqRnUwcnBNeGRIbEhpZUNnY0VVd2k3cWNUWFQybTRN?=
 =?utf-8?B?V054dUVrQ20vUlJ4YWZUT2VwL3YzazRUSXlkclZjYmVFNjREa1NsRGN1TG5M?=
 =?utf-8?B?Wjc0d0NMMmpZTEw4YVBKblFILzFvRmVjb2E2VWx0cHphYVZaR29NZXdNeWRi?=
 =?utf-8?B?bUZVQVRCRG43aGk3djBFMGxScFJnMktZVHRocyszYTFGZGNHZ29ic0p5cWI1?=
 =?utf-8?B?UHE5dmxUZGxlNFZ0V0tBT3UxS29QVC9ZQWp4RWhNZVJyc1pCbEZZUWcyNnhI?=
 =?utf-8?B?MVRGQXV5SVZLVXJZNTJRZDhWblphdkpRNTBvV2U2ZTVvMmxLVC9JM1AvUytC?=
 =?utf-8?B?ZUpmVFFjdkVySDN1ZW5qVHNhSFRSRXRDRjJaeEkrcFhnSGNDbXQyVUh6dEUv?=
 =?utf-8?B?MXZOWlJEM29BeVZVMHd2aWJsN3F2c3l6OE5Fb0Z5endzTVBMeEY1U0NTZWZo?=
 =?utf-8?B?aWJyME45blp4eTVJWG03Umg0eGxtY0ZkNUZ6OGNjMnc2VGVZV1podjJPeVZ1?=
 =?utf-8?B?aHEvWkRSNUJhbGRUNXFZMWJkVEVCNWlVNTFGRFRTS0dQV3NTbVdPdC9tWDVm?=
 =?utf-8?B?cFRQcDl3MkR3Z3BtaFhpK1VJRUZtQ05zODdacEYrSWFGQnBCR0k2ajVmaGk0?=
 =?utf-8?B?WERUWk9lS3FoSUJNR3FMK1BtcDJFc3RJeng1Rk1wcDZwWlZGVTZxR3g0SlZp?=
 =?utf-8?B?U25zdjBGVVY5TGk1bE1EWjNwdXR3VDJEZU9CYnBndTdSbjN5RGNZeFF3bjhH?=
 =?utf-8?B?WUwveHhzbVIySXNOa0RaUUhweVExMzcyNVl5d1l2NjZRS0xTRms2OTJhSkZU?=
 =?utf-8?B?NHNTWkkxa0JPT0c5aGZJYTNta254UzFucHFuWkFkSFFOY2x6c1gzNGlTM1RK?=
 =?utf-8?B?SDNFNEdiVExKaDVnT3ZrTFdiUWFjN1pMSmNqd2JWY0lXemRDbkppeGxDdnU1?=
 =?utf-8?B?UFhNbnhsVW5CVWxPYTFqeGpNODF1OFF4ZmZnNDZRMlRGdGdaQjZoRHcyU3Vs?=
 =?utf-8?B?RWk0cWtPa1lsdlprUk5acy9CRnYyYWNZWHU2SVROWXc2QUZBV3V5RlI3dVhF?=
 =?utf-8?B?b0tEK1lIWVFJRnF3dVE0aTVOaGNrZWsvZmcvOHVlUDU2dExiUitzNm1yR2VE?=
 =?utf-8?B?aVZweXNmeU8yajVNYWVyMUFkS2Nnc21LUHFOSHUyQjZxYVI0VEZDZjBheE44?=
 =?utf-8?B?OXcwU3B5NkN0ZTZQeHQ2TCszWDRnREtzeUpUOEcreVFITkNRSTFZajcyelpu?=
 =?utf-8?B?VDRpSWFrVUF3eHdGTXZmeGd5M0RGaEh1NHIxQ2ZuLythVGhqbkF3Z2UvcXhh?=
 =?utf-8?B?b2RjWnpJZXJRUVdNbzRjOGQvNmIyYlRnaUJ2NUZDUE5sRWlkZDlGTkZKMHBz?=
 =?utf-8?B?b2k2a0trVE5sQ2pzNkFGWW9iVWNWTEVTMUxGTndNZzB1L0VlRnd4TURqL3N0?=
 =?utf-8?B?M0x4MlkzMkIyVW0zQXA0d29vaUY5eWZOOWt5ZFpzdjNBcEl0c0RDZ3g0M2JR?=
 =?utf-8?B?Qzl5bThNR1k1ajBVY0xycC92SitnUlZId0I2dzNvZkZBMVR5UTZ1N05jOTM1?=
 =?utf-8?B?Vi9CWjR4cmFtbkdOT0hvOVoxNzlwaE9iQ2ZuazdzZ3Z0Skc2Y052LzYrYTFM?=
 =?utf-8?B?UTB4ZkZ3SlQ5T3cvU01YNjVhdHFpOGFBaVpRemxKVTZQTi9BU3UrMHJmWjkz?=
 =?utf-8?B?eW42Uk1GRzI1aUZ2ZGJsQ3c1M0tMeERCMzhLMVVRTVh4TW02a1h6anlzSER4?=
 =?utf-8?B?a3kyaEJ4NmJrSUNnT2JxdUltd3FyM01GdGpRQ1FzdDdjTzJTWDJ5a1FsVGtq?=
 =?utf-8?B?TEZudFNieVlPR05sMTBRRGZlNVNJQjFtaG5LU256QzJKWkgvbWhVcCt0eDhz?=
 =?utf-8?B?UkFycWZjMnRab3RvZWFITHozRW9HUGtmZ1hzazZ3a1YvclFkdGZJR2tqNHN1?=
 =?utf-8?B?SWlpSXcwZGVNM3NuYVZVWU9BUTdYeUZITE02cUtFNEl5b3E1bVRUcldLcXhu?=
 =?utf-8?Q?8aiiFh7T+iepgeXcZ9zeS10=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180ce80d-9ea6-48c3-ea98-08d99ae1e78d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 13:42:09.5142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvIdIe4F3BonXDtYSZ4YyiXYzTJQLveKcuTYK4a3d7FfI7DY2ch7yiE/dWx/OgvgUQ0RINN0606cN/Wnt4btcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5232
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/28/21 12:57 PM, Peter Gonda wrote:
> This change moves the data corrupted retry of SEV_INIT into the
> __sev_platform_init_locked() function. This is for upcoming INIT_EX
> support as well as helping direct callers of
> __sev_platform_init_locked() which currently do not support the
> retry.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ec89a82ba267..e4bc833949a0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -267,6 +267,18 @@ static int __sev_platform_init_locked(int *error)
>   	}
>   
>   	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
> +		/*
> +		 * INIT command returned an integrity check failure
> +		 * status code, meaning that firmware load and
> +		 * validation of SEV related persistent data has
> +		 * failed and persistent state has been erased.
> +		 * Retrying INIT command here should succeed.
> +		 */
> +		dev_dbg(sev->dev, "SEV: retrying INIT command");
> +		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +	}
> +
>   	if (rc)
>   		return rc;
>   
> @@ -1091,18 +1103,6 @@ void sev_pci_init(void)
>   
>   	/* Initialize the platform */
>   	rc = sev_platform_init(&error);
> -	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> -		/*
> -		 * INIT command returned an integrity check failure
> -		 * status code, meaning that firmware load and
> -		 * validation of SEV related persistent data has
> -		 * failed and persistent state has been erased.
> -		 * Retrying INIT command here should succeed.
> -		 */
> -		dev_dbg(sev->dev, "SEV: retrying INIT command");
> -		rc = sev_platform_init(&error);
> -	}
> -
>   	if (rc) {
>   		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>   			error, rc);
> 
