Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FE7C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A539B61056
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhJ2NoN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:44:13 -0400
Received: from mail-bn8nam08on2047.outbound.protection.outlook.com ([40.107.100.47]:46593
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229603AbhJ2NoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiD5bLhPKUD01JOQ8boSaDYWkRDWb+5RfX8sSBAqD8+sMZM0qL0COuxxZZjCRIbMrYj65jJBS/5c/8VMUe5sDN9nMEOMpcnxq6kVl8+AphsJy0cHxAXjnDAz5JkP7BJtIsa+75HcZrdynCBCO/v2mqX2DpJDNRBKwZLKtczKWPo+OqeSqb+tG70uDWbFylCOLXyhTFf5gZhWrpb4tu64p1sAKAC+i46v2UWVQvxfO7FrHHeubEyI/MWWGVTQkGwRPD/K/3RjM0vWqVCcUObx3dSjVp+KMQZsqh0iiIYE4ZDRZtOaaQRjNvGOTC8EUHYMJNRdl/wMR1aNDkN68J3Ixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OdQkHvns2u+nTdg3UY0LPEL1HQbiwDDVtOtoYvjWFYk=;
 b=U14qw3kkL3uqErNlJm70jNIR2QRyBNH7w5LeFysYyH2XnChsxMiGBFCDpeDzZUAoqX/RlI7+D8xKAMKw/FsOMatysYpr24SVvqPFbfOOr9cngA8GJN/pkj+/JH9FjePuTX/JkXq8bGNFdjfeq/zhqxKetwAxDhxlkrq5M+qKbfD+IS4JjjXhZ2q3K0cb2rrXV/20IzPpMDeN1YAKeABFwgM92nADQ1oRhSdULf6NBLXHAbA3g8A96pGk81JrwgG+/ZC2YJcs4OeDBYY15VpyCsMFqO46/o7ITDK+6epsiPMvhOGiMYJR7mNq2ppkosNTICHGtct8i6/ndy102sye8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdQkHvns2u+nTdg3UY0LPEL1HQbiwDDVtOtoYvjWFYk=;
 b=BMO4zXVKYFq04elqqrjlarjTk9qHjcQeSrE9H+yg5iQoZmZ9PpCqp0p+b7PPETKaxWJmN/+6oHaJEs0uhb5NVqpN4uROWvttJzTtInskLAVYi01xgmDvjUcv3226i2Lwq9Z85A7iOTnnqOGGn0SK/kcUkroFR+oTrYhYD4ax3Ps=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 13:41:42 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 13:41:42 +0000
Subject: Re: [PATCH 1/4] crypto: ccp - Fix SEV_INIT error logging on init
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
 <20211028175749.1219188-2-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0202da2c-a1ea-df2a-6544-f2f8a93865fc@amd.com>
Date:   Fri, 29 Oct 2021 08:41:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211028175749.1219188-2-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0033.namprd04.prod.outlook.com
 (2603:10b6:803:2a::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0401CA0033.namprd04.prod.outlook.com (2603:10b6:803:2a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 13:41:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a397b078-5568-42e5-42c2-08d99ae1d6f7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5072350F1D72E94DE60D7128EC879@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2HrkOdaPJ6GktmvpEPpOQWaJlJpLl1fgfvFVkDz08+R0Mx1WMcg124/BJJkcKILmnglqlrDhKtGnt2BQxkc+sFP7x0oK/fWOJFf/YLksKYfFmixBREm1d0A3IaE/IGw2FWg+bPMQH9mAV5dG7uo8lI4orTIT1GSrlRvUwzmgDun1JXBES2C2EAgUMsGGLHQoLnPFmaYDfbaAX05+H2moZpNwIql5253JweiPrlB92XTduzKR6mB0U/opocMtyjjiPwMhJTDXdIyxO805GJOc3kbUa9YiBd3bFwhw62AZ4jz2MfUCWBbCJddDyuap0QoJX6QWrTCuMzL1+rGqLdGq81C32eF88AOl+G9aEiH/GLbuZ4f7qpBlQh2qoADOu2Ufiqm5BYdfk7EsdHWg5K/aITNtk4sHo6BYhaasVHQRlPgZeH40PE6N3DeMuZDi95ii1wfIw/X+CjEkh+rIhdv7gyyS/9Hzz1JU8NBdlf5hxrq0nE5Qr++x4JUZSzyCRgFZxYCQ10INKvbkoKyH3F2f7ADwL+sH4MOxqaEsgiAkL28SjJ+G4T7wi9/FiG+8VDmnTcDXGrW8A47Eho8VP3ZQgtUx++8tOdHLn7pqKroO+FlJoywPpYAN53hih3Uy52/F638QSt7uWThZFZMDWMjRgx4LLcR5eo6hj0WBImXa2SG053Gw5QXn4zXqkgkggyRJTaSfAcO36i3Sc84L7oAqcFNjrjjp//pekg2dDYesgqYIkGzv5Uqh1IFjmHRyxd8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(4326008)(53546011)(5660300002)(83380400001)(6506007)(54906003)(86362001)(2616005)(6916009)(8936002)(956004)(38100700002)(66946007)(66556008)(31686004)(316002)(66476007)(6512007)(31696002)(26005)(8676002)(36756003)(2906002)(186003)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkdSa0pXdVUxdWNmeERkaTNnN1l3UC9WRWxKMGJZK0Zha3pOcHE4NUdNUGl2?=
 =?utf-8?B?R0crWjYwMkhGS3FmamZET2NZV0lmdjk0QW81Q1pjbU9RTFRaRUN6WG4rZkJz?=
 =?utf-8?B?dHdLSmZTNlNQQ2xJazRGVjRtWkhnbVNpL0tPZGxWQmN4YXl6WStkcUlOVDNC?=
 =?utf-8?B?OHA4TmFYaFQvRHE1aTY0ODZ3ejcvWi9vbWNZc3NJRFkxV2RvMEJ4NGhnZ2Qr?=
 =?utf-8?B?QndtbEE4OGpHNUVmTFRaZk5IbXMrYWpvSVVsUWZlU0psdDdTNGZ4MFNmeWVi?=
 =?utf-8?B?RjR1OG40N0VPNTY1OWhCd0Y4bkJxY2Zyd0daRzBwTHNKSFF0SHRVT1NjQ0U1?=
 =?utf-8?B?ckI2TzI4cndnSkYzTDA2SzIwd2lFMDhKNVFGY0lyYnBna29QTnp4SUtJNzRY?=
 =?utf-8?B?VWwrWFl2UUlhZ3VtcGFBMWd2alZjK3hCa254aE5oZDJkVDV2NVVCVkZrdTYx?=
 =?utf-8?B?OXU4ZFRwTUg1UTVaTWwxelR5SHcvV2ZiblRFL2I3cXZDUEk0aGZkZFYvWnNi?=
 =?utf-8?B?WUpwME9ETTBUUUdSZnFpbFdkQXJtdDBVNGt2Tk1FdEpqNTNRRVdaSHRoUEs2?=
 =?utf-8?B?MTBEY1IyYms2NC9zUHFEOERQb0hxbXJRYjczSUxhVWpHb1BCWTlxL3ZBVFp0?=
 =?utf-8?B?N3A2QTFyMFFlQ2s2WWxBSXdkQ2tDaVVsWFJGQVFoeTV4NXB4N2dzS0J6d3BU?=
 =?utf-8?B?Y0VUZ2xEZThHbE9VTHNVUHVBcnM0Z0ZleFZsWnNGYXI5ZzJSRE9USUdnUkI0?=
 =?utf-8?B?Nk16U2JjU2dFazg0Q0VuWUlMNG15Q1VsTVpIWGJBNlMxN2c0MUIvOTJ6QWc0?=
 =?utf-8?B?d3hGaUQ2cU00b2xVbVJWU1NDWExTTHNtNnhQL2pjK3NHOTliYnJFdmluczlN?=
 =?utf-8?B?S2VISFFmODQzNjUvNlBRS0VpSkQ3MzZHMFdhTnNiOEFGeXJ5YWVrQ3R0WGNu?=
 =?utf-8?B?Skd3ekJJdUJ4aU4wdGY3am9OenExUkpvL2lpbnlSTFBzYW9UMG9lanhPMmFv?=
 =?utf-8?B?cm91VUV1L21NSExEV0U4bWRaNW9RRkRLdzJIR3NiWXpoNDdvYXYwcW1XeCtM?=
 =?utf-8?B?Z04zY1FBM1BaZVBueFZnOXpmaDFVTHBaeGp4SHZZS0xJLzJvdEd3MFl0U1do?=
 =?utf-8?B?UlNHeklGYkFSemV2dlcwRXZzWEdVS1JxTXNIbUdzcFdYTVZPL2wzOXp1cGZw?=
 =?utf-8?B?WGE1Yklhek91V0VoRk9EemFaeWZ1ZUJMTXg4bWJ0VVpuOFArN2puMWhTb1FS?=
 =?utf-8?B?TE9veXU1ZVdQS2w3cGlpMGxJWERrRzJzcytpYzV1K1h4RUxhcWk0WDN1Vmtl?=
 =?utf-8?B?b1J2ZDNhSGNVdWFQeUh2aUtzaHZ5QWV3VVRkVi9scWE3VVB1OGFNTkhQS1dG?=
 =?utf-8?B?OHRrQjlDV1ZIRzJITW5kVjlyS3JUUHVwV29hcFA4RXpvRE5jT1BPT0xOZlQ4?=
 =?utf-8?B?dzZGVktNaXZYMGFDdmpJSFd2RVRyQkcxM20zR0dobm44WXdwRXRDNlhteUZ3?=
 =?utf-8?B?Y2pSTVlrNnp0d3JwdkVESnRTSnpaQkVONEJxcDN2OFpmUGVpamhjTytJOEVE?=
 =?utf-8?B?SDRKV2Y5TFliNmhvVStxK0Z5V0U4SWtZcEJyeXp0VFBqd25vWlJUTU5rRk1O?=
 =?utf-8?B?cENuc2tnSDBib2o0bzExY0lzMnM5SE9ISXRNNzZoRGpsVzgyM0F2NGZOZE5k?=
 =?utf-8?B?V0RpakdWZ0VBd1pZcXlzYjM1ck1Ca3I4RUppMHRuSGZzTnEycmpPTlZ0elhv?=
 =?utf-8?B?eVA0bk5Pd05MdUFDdDkwMkp6NEFxTi81MmZvaXZSbkNyalZwcW5qQytBQlg5?=
 =?utf-8?B?ZHMwakIwTTcwZ3ZFUDJEMmpkYmN3YnA0VDV3Uy9GQW5yS3U4ZGp2clNFLzFo?=
 =?utf-8?B?eVUycFdHbmdLSi8xTTBhdVRTNE1IRGprUWJ1czg5WDFuaFVpVVlvaE14YklB?=
 =?utf-8?B?V0s5WWpCYVQ3cXBNNlJhRWJzNFVVRUUyL2ozdXlvbjVDbU9DWDZ5VmFNRGY5?=
 =?utf-8?B?eDJvUW5FSjN5STNoNHdITXp0Y3NRRzZ2YkJwQVM2d1hhRFU3YnBTaXhkUVh3?=
 =?utf-8?B?VUZOL3dJeW9aR3BvME15MVZPVjBISkcvdWRnbmlKejJ4QlhoY2pCMkNPaDdI?=
 =?utf-8?B?WFFodktYR09xQ2cxdUpZSGdWVFhaSkFKQXU4ZjFCa3dpbnRhRnpyN0ZKTFhQ?=
 =?utf-8?Q?GQRnFY+nweThuhyMjOCpRVw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a397b078-5568-42e5-42c2-08d99ae1d6f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 13:41:41.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ExHoaoFc8QncfBctBzesIWPMFNtbA4GmSDWpIAHfzbtobHIZH6Xs2jY8IsT5BE0zYOHUhglVSP4GC6W5UoR7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/28/21 12:57 PM, Peter Gonda wrote:
> Currently only the firmware error code is printed. This is incomplete
> and also incorrect as error cases exists where the firmware is never
> called and therefore does not set an error code. This change zeros the
> firmware error code in case the call does not get that far and prints
> the return code for non firmware errors.
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
>   drivers/crypto/ccp/sev-dev.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2ecb0e1f65d8..ec89a82ba267 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1065,7 +1065,7 @@ void sev_pci_init(void)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct page *tmr_page;
> -	int error, rc;
> +	int error = 0, rc;
>   
>   	if (!sev)
>   		return;
> @@ -1104,7 +1104,8 @@ void sev_pci_init(void)
>   	}
>   
>   	if (rc) {
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
> +		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> +			error, rc);
>   		return;
>   	}
>   
> 
