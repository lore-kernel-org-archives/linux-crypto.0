Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C27C38A2A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 21:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5EFC20731
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 21:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="TiJ2Dop/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgEGVXo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 17:23:44 -0400
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:41028
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbgEGVXn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 17:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WArxMQHtrgfXQ575bq3Dv+x4vkYwafuvrulUQ8N8evx7A6ipQMcOlWNQuAOLCYGYJINy4oDA4rOiPfY+h6yONE0Mcm/Nxu32E2sy7iIIGJtrK2Z4x9iOo9UwokM10ybj4pVWasl8CDFiHuT89I5Ly8XtzXtSSUFsE357BG4WqZWWBjHrXDi4gIfwloxn9KYVcBYRRQxDpWdmbN2ZQ1K7BVNAM22eAfGMZB6sfYGyt8SQUxlVTv5phCQeWshy9MrDdhvqA492KRNeQcsRpjw7juTD7h6zkbgWUTz+h1XMw+uVZ60Yu3cvuvZwb2dSqmKOIhIuclzwAjF8HW/DcF71Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfqOd1K1bbFy4Pa12Qi+50lepj7drpO6osIcJGt2TWs=;
 b=OtoKCbSnktSSBQZLcycE/H6od1IQRhDmfkjt1/DpHpAo8oIi/wIhUeveMmi8Osa84ZWm1rndf0gRiCUitkKfoOGTIn4nm8H95j40dqbjsYsRhrTm91VRsatSwuNROZifXzrmWm9GWg2pOOCT9FEotowrIEfrVYLSdCOprhtC1qTMNfjgahKXa5FOsQykS6fpyo9V9DF9zuCBEdIMLB0Hrrq9tR4LaJPXuNfym+w9+KYlQYYOcHIMP0SImW00QBuf1rFRueTb3DZWJMScL8oGT5ETTqjQ2nBWiBGAs/rqqLXa8XwK7DUOXxObc+IQGD7bZ3IlnIDU1O8nnpK+iaWXpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfqOd1K1bbFy4Pa12Qi+50lepj7drpO6osIcJGt2TWs=;
 b=TiJ2Dop/BJ49quodrSTkuR7kLA2j0f/NdC8w668qG7K6/YPVx8lOkaGr4Pk1fKCjiWFxhu89LkbItcr2qO03xU+o/I+F/twjCDFb+e4yDYWzhFWGVr0yvwBFcJAxWmJWHq6sQ/4odwn4mO7MsBob1rJM7slzHcBNrEy62tYWmqk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1177.namprd12.prod.outlook.com (2603:10b6:3:6d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.27; Thu, 7 May 2020 21:23:41 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.2958.034; Thu, 7 May 2020
 21:23:41 +0000
Subject: Re: [PATCH 05/20] crypto: ccp - use crypto_shash_tfm_digest()
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20200502053122.995648-1-ebiggers@kernel.org>
 <20200502053122.995648-6-ebiggers@kernel.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2306b736-91df-3f76-0eb2-fe0308d144f2@amd.com>
Date:   Thu, 7 May 2020 16:23:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200502053122.995648-6-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0098.namprd12.prod.outlook.com
 (2603:10b6:802:21::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0098.namprd12.prod.outlook.com (2603:10b6:802:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Thu, 7 May 2020 21:23:41 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64cde6eb-43b9-4bad-0ba5-08d7f2ccea3a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1177:
X-Microsoft-Antispam-PRVS: <DM5PR12MB117741DFF15FEA8A881DC902ECA50@DM5PR12MB1177.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zX5Pr5gwIO2086dG3CiZsImC05V4ppOHdLeEILn0mcSx82xBQm4Y33axaFZI3HCAdCjXjumShkzMdNJAPVCmyaIHMIoRHZObe6T02xEi8xmeUIMOKfBVfxQOWAK1wQX5gfdPmrGxEJsPnyT3zsIOXGXBPz2XOkj1fhnsFH33Fo0tLtNne+fC4XJnMHhyZLMTZuxfPSh6CoVG+dMAPs4YV6hKl/oIDg9NXC1MTzlpuvAJMV5s7L5WTemsDvFJ2DiBjuUbOWCLUjl9nVOSvfAx9P4v36uTRZxvjcvT5FgJWY1H3rru/6JGFp9obTCtbpJourtpAcWU/PaOQl23ttSqLaOAaSN4Ks+cDkdAr4Elms/ZumVq6vZzgFUG1qH5ZWr8wZxfdUtRY4mzqyt6XcYDZ4cLEkPX5coATZdBXhMLiuIJHEHMxtJlxpx7yQ+MjFcrFoD4GKy6o6akXas5OUwAHjHMyoR1+OxlKs3wEEkqGVKZCnTtRoQf3vhw2h8zGByUQZxjgblh0fMACUW4W5OMEbldRo82YKvD7nQ/gb4QeTOSEuUiVOdX4HHqJ2Ru7Ad
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(33430700001)(478600001)(31686004)(31696002)(956004)(6512007)(53546011)(8676002)(6486002)(5660300002)(66946007)(33440700001)(66556008)(6506007)(66476007)(316002)(16526019)(2906002)(52116002)(6666004)(186003)(2616005)(86362001)(36756003)(8936002)(83280400001)(83320400001)(26005)(83290400001)(83310400001)(83300400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sfRZmgHh+yBoJRHSVlP19DI4YPkNRC8mnw9UpfuQMZUTqmFAUcRUytql9NBx7zTgnqubWn6YQRlhGbyL2MYbdWBI6wBamiIAF0feQX6+viN4lL8KU1bkHOOUdG0+GVAMVKUpclagK9a+V4iwnrnDxgNO/P7trhiTYogbHhky4rURSxUcH5k3lvQJWxUxMQYEyYp2c9tETJNE9mLhu3bAL99t+yEVMUnC83h+TdUkrbdO0aoUvCnG7LRbVTFqWv7UdNoPbzMYelPnWdYYQR8VCsYqQTsXX8SQtqWKm6VZbWuTEHW0vh7kASv2ppkQ3dHSGNOfOT3ZiVecdsSb3zuY7SMF2cQ+NakHkS/Yfyx6wSi5FE0sRFC9FsBJJWgJi4SCBraitRwi2salh0BrykOTxzHaVkC3PlRTgHq01HhNX+Ry+g3OkxTnuc1n3GS89vf2XGKIyKG/MxpVF7RZlRAgLDfC1T8Nu8TbZAdkfmA27PYumKBSPzLEIGktCzkwc1yyVBfLUl22WLc4m0nxy7XNVIRJN5kIuQh6V17pFr3paQwbszU+yaTbJ+kcjr+vkbkU8CKBNcTEYJVSSvEu7b/C+ekPkacKDj+krJ97FvTvuYe9KfBfCp/BxB79NY2oXrtliLiTh0W3hvNpcMjNBvdtljWJZirXVO9sD0ydxK1ybna9j2ZBBy4aYXyZM8REaJV3O3V/nsiOWBPq6xuCV3StxacU1dop/ONvfqSN8yKH2mkZ8TYwgTHiTkJ0eAoQ37tvVRy7ZkUliZ03HaiaEHv864lkeJl5v89mFQVJgiQnLf8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64cde6eb-43b9-4bad-0ba5-08d7f2ccea3a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 21:23:41.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcpx77pEe4rGsIc7zDYXs6yI3ezkSrCdppJlNKsfyS+H20KOQqwwa7nOrsGwjX6LTfSV7f+QHQTd5JceEb9yrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1177
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/2/20 12:31 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of manually allocating a 'struct shash_desc' on the stack and
> calling crypto_shash_digest(), switch to using the new helper function
> crypto_shash_tfm_digest() which does this for us.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/ccp-crypto-sha.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
> index 474e6f1a6a84ec..b0cc2bd73af804 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -272,9 +272,6 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
>   {
>   	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
>   	struct crypto_shash *shash = ctx->u.sha.hmac_tfm;
> -
> -	SHASH_DESC_ON_STACK(sdesc, shash);
> -
>   	unsigned int block_size = crypto_shash_blocksize(shash);
>   	unsigned int digest_size = crypto_shash_digestsize(shash);
>   	int i, ret;
> @@ -289,10 +286,8 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
>   
>   	if (key_len > block_size) {
>   		/* Must hash the input key */
> -		sdesc->tfm = shash;
> -
> -		ret = crypto_shash_digest(sdesc, key, key_len,
> -					  ctx->u.sha.key);
> +		ret = crypto_shash_tfm_digest(shash, key, key_len,
> +					      ctx->u.sha.key);
>   		if (ret)
>   			return -EINVAL;
>   
> 
