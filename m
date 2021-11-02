Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA32C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 15:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89ED960F90
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 15:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhKBPkt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 11:40:49 -0400
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:18016
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230370AbhKBPko (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 11:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WI9VW4sUrd7yas70Er0XvP+eVf3reGjhmv+zd2cv0H9kn1jtSYQk59WbcagmCNQsK7WPDXjYEQy+bxBtALNKh20QFGJ9wUSfxDvfWvkubwvtNEI40hPpPyCYkRvscmWRpVtUEEIzAUTqC8Lx5XLRxDXbFvrBCVy5BTcqRCQ4Z4Bxm/ojWLd7uw7Ad1sm+doQ/b9jPO5UcZWIoSEoGmbHiqmP7zaXfcoYGY6uTPKFceBU6eJZlzV1NnNPalZBOWadizvj+H3U9VnwOczFxcEpWEoiYnG68zVrQqWCvDIAI48vVDqE4ovYzOz9memazNwetDmT8fI1qAYxVT2+DSTP9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JclaWLprKEtPGJiP9JWue5pTs8t+uNPpE1WD5wsb/XE=;
 b=Ihiq48dC99XKBQJxaGBV6fJJd+42NCYTBA9gSph/ybVhunaZNEATSVLQTEm2bG9c08J6KEeqU+yij/zBOtf836sxhXOX19ChIS4+Ew1wlfvHBC/eGxqdLJCr2Biy98qrELjo06DXpOKon2yEuuv0Ogd1rQGmW+HPseBUMGLSvy7loeflBFYr7uIP+uzgyOtqlIEB8Y+OcIQOxFRqe+dDLEc21rUr2sQi7rjLynj3UDM+LbeRFVAsV4U0TlP1w81stT6HHhsbeIdSslZt6dtkkCOGYfPREBoIqZJe5IvbU+VxIiyGlp7B7GWdCIaCR1ZbWPR8vX8L/KSf8hiKf0tt2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JclaWLprKEtPGJiP9JWue5pTs8t+uNPpE1WD5wsb/XE=;
 b=S8aNEUrehdmWviErbmHPnf7Y7B+NmYzUOJGu4Yf1mLVOQEXBGiaNDZbDGjHT67A78TtkLDuzSufaVYtb1NRow3/QaC4JeICQVxNCWP/VKb2E3NtITGUOj2snyN03KTLicbXsVOeLqIse37flDei87E4RCbbgGOwqzcYlOfiDryE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 15:38:06 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 15:38:06 +0000
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-5-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0701eb12-a60e-381f-ddd0-9ee9a0fa3edb@amd.com>
Date:   Tue, 2 Nov 2021 10:38:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211102142331.3753798-5-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:208:2d::44) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR03CA0031.namprd03.prod.outlook.com (2603:10b6:208:2d::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 2 Nov 2021 15:38:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9206e46a-9353-4786-d388-08d99e16c373
X-MS-TrafficTypeDiagnostic: DM4PR12MB5134:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5134AA622F0D8F9E88C9148CEC8B9@DM4PR12MB5134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0S5PM4oY60uRDbIhPlfBYTK2YXeXHeL2DpOfo8b72VWn/cf19aHH0+SHIbh7UFZCDOeySwrJ9+a3bkJX8FCT0P18gqw96AgQg0MCjbxp7VO3OAZ6SB6bD4Uzw0ba98ROd1fo+9+Yms/5gBObomQjCFQoXcyhXMdQ8/1jWJEbzr0eoC9jpyJXIMDh0ocm7hqXsZBGVBraMLJ0HaUmEhp5lU6X7roccsDz73HJ8y6WCELcbhaDE/1QVD+v1dNxPr8eCEK1kug1qeEx+brYL+1Ai+FXt4ZtmJmDjfdIJQtoN+WKW/cf9I/3WOf9ELU+sXSYjhlHWKj+UjMCVIrvx44Iu8k83fdn25sD6ICoebCw9UHmW7OzAbapnTDTLV05BqCvM5QgJLYJpsxZ4eY4piNheqhE/Yog181F+fQXrDZrfPvLVIZmebDHJll459JH9KYsqkyHItHhRjQpVKZ6+6hhPFFfjUzcN50DsrYuoGYcWkzXgelvZkOakyaxCXgARdumceV21qmpjmk3OBw1DhnmGbP6fyGaeVEdQgZVyWaX/47jWC6TgnrzrMhUUPeUYzfiUZH3R/Zmv14TXseUjs3eMs+VmeJv2F1eOpAQCepO9+3nkLPJKax0wHzB3LtBVCARIT4pgwxG7blWMEWroZTlcy/C8ooSZAPTPVpIp682UhqpbHAFSKvBfABQV5mTDbUunTWiCQox8J2SDSbW2WIFVolVoo5buegSbdxyUrnfu/IfsVM3hIL3JaoV3ASSynxR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(36756003)(38100700002)(8676002)(508600001)(66946007)(31686004)(53546011)(2906002)(4744005)(186003)(26005)(956004)(2616005)(6486002)(6916009)(83380400001)(54906003)(4326008)(86362001)(16576012)(5660300002)(8936002)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUxSZnh6c3lmWkc4bncyMWNBZ1ZEaW1OZnppNzhQVllhTERSVDJmV24yZExD?=
 =?utf-8?B?bUVFUmVBc25QdGxnVlZNTnM2c2RxcE00N3ZBTnh5SXNmWHBEYzdzZXZvVlA3?=
 =?utf-8?B?a0pVU0hFcnZ0ajI4dGlzbkF5Ykw2M1pqbS9iMThySnNVQ0Y4aUZyU1ZsQ1Ay?=
 =?utf-8?B?c3JKVDJEME04MGRWdFcyTWRmYXhvN25pbWRYWHN6NkpIRWVtZVBRSllWUVo1?=
 =?utf-8?B?cm9tcXlWVW9HQ1RkbUJmMTZDdmZkdGZ3RTBDeUNnMzdVYWhNcy9FSHFhOGVy?=
 =?utf-8?B?bkhCRnJZcDZBZW5QWXp2U3N0MFBtOFBmZWVvM3p0aFdGcXdKQ0RNT2t0RXFo?=
 =?utf-8?B?ODFDSHFQR3FFWEFSSTNmNUdheDRjcGNwZnY5ZXRyeHdvRjVsWWppQjF1a0JI?=
 =?utf-8?B?dGR5cXp4NHBkaDN6K3pnakxuczNlcW5pVUdiU0U2a0JQOTY3NjlPUnU2Rm1K?=
 =?utf-8?B?NDF4eVRQbHQrU1lnQmwwMDZzMzlNZzZlalBxaDFYNkpqOUhSdjc2ZGN0Y2FI?=
 =?utf-8?B?QVhJTnN0RDVzeUhHSklxZGVCNFRRa1k0TDNPU0dDQ0JqcDdmVDhEZVFJTGdN?=
 =?utf-8?B?QnIvOVdlcU1rS294NHNGU25pdjRvdWRDamtFQnJ2eWIzOUFjdzU4ZEZJV2s0?=
 =?utf-8?B?cW9zaW55Z3hla3VOYUk0RGp5S2RidGdUWFl3ODdmU1JwNDNDQ1VSM2Z4cVdK?=
 =?utf-8?B?emdVRTFXVEs5dGpMak4zMWRXNUh0VGZpRTNlYkpGT0RCVHZ5YkgxR2t2OVgz?=
 =?utf-8?B?QUVpYm5rb0RXc1QzUUFpK1BQNVhITE0zVEZJdjBLUjBBSmRhMXE2ZVRNK21S?=
 =?utf-8?B?RlAxRHNuRWxTNXE2OENLbW16MUlpaWFlaXdDeUdxY3ZZd0RZK3k2dHpvenhI?=
 =?utf-8?B?SndINnVCdVp3bW15V3pVM3YwdzZqZVZlV3Q3Vk0wRVMxVkREamswdTVTN2VZ?=
 =?utf-8?B?Y09xVUtQeHlhbU1OYzNrNUpaZUhUeHlJVVNDOVh0MjBSV3c1TmFQNlYwYkFr?=
 =?utf-8?B?ZTJ2Z0JSZHRUUWI3WGY4K0VGSllzOWJWM3p3TDVGSldrcGROTUcyR2xRVk9R?=
 =?utf-8?B?NUIyZWI0eHEweTlhSTVrSm1vOXVJRjM4OXl2dVloY2xDb2I1SHZNT0ZQNzBJ?=
 =?utf-8?B?ZEc1U0JVTWRzS2d3dnoydklSZnowcXVjeW9NcVV3L2x0OTU2WVY5WVRlVWdL?=
 =?utf-8?B?TG5LMTREWXRqWmJVdzVNQkRrcjdLNENRWE9iSk5FbElTd2ZLR05nTDIvcHR5?=
 =?utf-8?B?VDR1a2MrcGJXTTlKd3lNTjRmK2RuTDRtUE9jNVZkYUNFUEZLRldGSEllRzkz?=
 =?utf-8?B?dGk4YnVzRWRHVlgvSlIvdWJFK3Jlc2FYL0pWTmxmODl1N0R1RUpSZDI5aUZr?=
 =?utf-8?B?TFNwRUZVNXI1SXZXUEo5aTkzNnRvU0h0N0RFRU9TMVFoRG14UGJqYlQ3ejdI?=
 =?utf-8?B?cTZGQWRIcCtMWWNKcGROWjdMVDg2dXFQNFRwWTZSSjZzQ29URjVaRUprajMw?=
 =?utf-8?B?cEdSVzd6TnpLRGwyYmNWSzhRcXNmczJzNTRxOXZrWlJrakJXVGJpMVlTRVdh?=
 =?utf-8?B?OWU2UjA4cEVTcVhUR05xNGttR3p3R3VScGVRZTlXaVliMzBOV284aWNmNUJM?=
 =?utf-8?B?V000OHcwVUQ1Rm5zN0VhZ1pkamQ0cW4xU2FTSHBZdStESmRuWnB3bk5kZDhC?=
 =?utf-8?B?M0FncFdZTXRjKytDdjlURFdJQ1QwMy9CWFA4TnBWWTlvYWF0RDZJRDNaNkFl?=
 =?utf-8?B?enJ1QmlVUUd2NjBQckoybFVGZnF0ak1Ka0UrNEtGdjFYL0dnTkdTVnZPellZ?=
 =?utf-8?B?OFl5NG93T0M2VHgzc0I1WnVFWnpVVEpnZy9zd2EweVFSQm5xOWxicGZQcGxr?=
 =?utf-8?B?TEEvcTJEelVYOVJrcmdPRnpFUGRUOG5kOUcxalY0bHNqZjBTNTZzTWZHQ1dx?=
 =?utf-8?B?OEhkREJncEVQdDNJNlZSVjgzZXQ4VzJ0R05xYU9YRjI2VjROeVZHVzkxRHFx?=
 =?utf-8?B?WHp3dWFGZmhjOStXYStZaUd1eXZpVFV2bUlxbjlXNlhuckhyRkd5TE02ckhE?=
 =?utf-8?B?SEhNZk5ETW56TEN3UzFDNjlpVXBxWHJLZTkzK2wyb1EwRTRPd0M4dWVmV0NI?=
 =?utf-8?B?WTRjekxTRjNrM2hFMlVvWWtkUDRqT1ZTdkgyVGE3T2xFUGx5WmVoL1dSS1Iv?=
 =?utf-8?Q?F+UphjWPrrW0AYfWy4URJpU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9206e46a-9353-4786-d388-08d99e16c373
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 15:38:06.1176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1EET06hzbHI7RaNKXotEXOtEHMl1aIRwItS0P2NeuaK6P7zhlnlFiFDH4izu7/1kbq9XkZUInTq6SCgouLVCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/2/21 9:23 AM, Peter Gonda wrote:
> From: David Rientjes <rientjes@google.com>
> 
> +
> +	nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, NULL);

Not sure if you missed the previous comment, but kernel_read can return an 
error, shouldn't it be checked and fail on error?

Thanks,
Tom

> +	dev_dbg(psp_master->dev, "SEV: read %ld bytes from NV file\n", nread);
> +	filp_close(fp, NULL);
> +
> +	return 0;
> +}
> +
