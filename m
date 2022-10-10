Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1544FC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Oct 2022 07:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiJJHeu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Oct 2022 03:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiJJHeW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2022 03:34:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E931F186F0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 00:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQCELTQVjL0pyUYXe0z7x2a14N+hQ34zaaNZdjLqfvVD3D2iqhkPuareYqUUpkfGUdJ54dW7U/HRM9GC3uhSDPxPNatVSxShOqWWXTxFGKf/m2y+cTA/8YB6uYEmzPAR2H/SBEoszbS/xzqh1Si6pubhwEQFtD4q2Nje5DBvnrJeF9S9VXl3G0mwSuQ/lfyAqRvjDF4ndgmAuWHSp9ymtKd1iiEG54dHVIbrHgCXiyAyE+oWKNaM54Vnr8wHyDX24Rh9mRyr/k9qZPfQD6eK8SmXmXoGFmMXYp0AYowCVEX60mfmvrUZeiJ9jThrlVMPls79wLQsd9f5SgbfToO1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5heZyat7sYzL/nyAwmXReyaByDyeMaFj5TWbRYr8w0=;
 b=HEoM66DCHhVAZ0JpTuvUArq2h6mIO2QtJt+LMXc2qXmJpQtZqQzNNUpkgR3pTR96SdpIK6A1nfxU0I1Uc2KypBg14ETm3pZ5Izvzyb1W0tHRfDySaCz22MTRPSlo/kP1uiApAN3JWPfQeDuXGOF6XJLrnli1As8cstBxSRsOsL7sA25VGiBKyMUhetwaek23yyBaqtyQTvycRYNk2N7Z09mGBgr+IqLjv3xsqm/f/KHXY39bYK/bfMqQe5UKUaQ3No4DFdNpYlK1HEF8oIaXdzOiaZjfmZl+3fodD49nzDomdBzc3m+pyCxIWWYxwVvvga/UhSYSJl3BAWGJIqBGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5heZyat7sYzL/nyAwmXReyaByDyeMaFj5TWbRYr8w0=;
 b=fN0TYkECX67roG6YWUskp92Sr3zoRJVJZa5rXr40qLJ8qtBKAGCpc+yqMvV/43yVkVtS6zPcIIzmQDDrBFxxBcKU/VahOLlmnT7w31z7IrjVn9OSjO9KJKip01BcJcbCP9GVi3FbUZPZxl0MoCBikmR41DTT9t16X5MlGh7FAuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM6PR12MB5008.namprd12.prod.outlook.com (2603:10b6:5:1b7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 10 Oct 2022 07:27:49 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002%3]) with mapi id 15.20.5676.028; Mon, 10 Oct 2022
 07:27:48 +0000
Message-ID: <3e395ad2-48f6-87f6-9042-a3ca21c0baba@amd.com>
Date:   Mon, 10 Oct 2022 12:57:30 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] crypto: gcm - Provide minimal library implementation
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        keescook@chromium.org, jason@zx2c4.com
References: <20221007152105.3057788-1-ardb@kernel.org>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20221007152105.3057788-1-ardb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0019.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::28) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM6PR12MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: a18372dd-2a12-4c36-5e51-08daaa90eeff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlHfLUnjKfwpq/SZ8BjneWi1U2vh5M3qBRm1ZDYU7evTYEtbpGBzJXgYSzhFWkacCpKmFsnpLyXcKJ6HYM5QrDuN66bU3UQeaWO1M9VxaNd4owwT0R72mY6/n2ql+BUiPyuNK4R2mJDHjnurdrpDqVJGhwbccy065ic3A/CgMp9XryKSG6AUDzWH9znJflKDAjUs6OQQ49M8ZMhgv+s9lPMPoI1+pybCTAz0XwCVVtcL4pv+5wIVLedWNQ7R5+484WbSxW6ybVOMKsD5g2LBpc5w0q9fJYdAZ6CevLNpKb+ghzaVCmZvXCi1FT7w0gBYu2MdtlwZ5U4jBakJyYSHl1LodHhfRmWY90meLHjH9hAxJQxE1fKSiBanMzJMNN7hQtOFROBVYS61eLYpBGCl/TWHt3I/niIh5fUUAw6qPDv3/b7SFTnvwOXT/NmcwGmhg/7GABiRtU405m2HeBVjzATv5BLvMnbVd5LHquR1IpsS3T9bAYmQvis570CeyXHUw889ZjKQDZebzx9RwOzBvnvocqBI2X1IGsUt2yFYHhTCFKsbYxIScBZ59nBsrtsWuKw1GS2gsC1VliSelNiORHYXQVsMcopIc9ysXnnZZEMDCcrxzcLsnMTkY/pkN5e1pcP9dwQo/R9Bwnzh7LjBKkaT+J747ToUOOegJfbNQTRKjPFDO/zJW40kXDN3EfHVHrMjjMnVj3xjFjcf9837JeWzaKGvrvFjrK1pQzwlW6vhd66fFEtX4r4Q/9PKZb19i8j0T14sTtyu7ukDq9765OOM20tUUWQXFhFMDsohSsrrfiuEv8HH47ioYwVYMKHKrrneVd+WM+KFPujvrCwkIyuOUIbKETc3KRwpfR15c20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(36756003)(31696002)(31686004)(2616005)(38100700002)(4326008)(83380400001)(186003)(6512007)(966005)(53546011)(6486002)(316002)(66946007)(6666004)(66476007)(8676002)(6506007)(66556008)(478600001)(2906002)(5660300002)(8936002)(26005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnRENnppeGhFb0NaY3gyanVaU3dDa09oYmV4OEFJdzVBK1IxMTc2OTkzUHRY?=
 =?utf-8?B?cS9RTjJ1R2IwbjJndW1iMkRhd1ZLSGJmNmM5VlMzTU84bFJrYU9qc09lNzAy?=
 =?utf-8?B?V21Kb093K01tR2JDUmVvWUpJUm9VZmlqS1k2QkhWOUtPRi96NEJEaVN0aU94?=
 =?utf-8?B?NjBzaW1IR0drUUk2dzZPLzRkK2laMEZwOW9wTHVFbkt4RVJ2WUdTQzk4R3Ja?=
 =?utf-8?B?S2lqb3llWk9nZlBiQzFndDVscnBsM3FXYUEzRFAwS0tKa3BzOUVJMHZ1QjRt?=
 =?utf-8?B?YWpDYVNBYnRkK2xGekdSL0FpeFVwTS9nNWluMnlMbDBMMlNETnJxSkZxZzE3?=
 =?utf-8?B?TUs5cmJ6TklWVEkvRnZ5ZDN6bUtXZVhiak9VbEFEcGZ2STc3SnJpcWVzVkhG?=
 =?utf-8?B?ZmFtRVJQeHFodno5WjkrZkZpdjFhaFptSjVrR0t0dEdSWCtkMlRZZnhWdXNy?=
 =?utf-8?B?SUZ3SGtNN3dLVHZ2czhPekN3bXJtaSt4RlJkaUpocWxkcjVCUDRWTFlHWWkv?=
 =?utf-8?B?eFBmcHF5dnlpeTRFU2hnclgxYkl0ajJSU0wvUlNZQ29vNFRucmJIN05jbk1n?=
 =?utf-8?B?WnBrdGt1VFJ2WU51Z0xIREhMdzZSNVJwSVFhbHFnSndGNFI0V3gzSkEzUVpC?=
 =?utf-8?B?UFNOSzc5RWdDdHFheFNqRVdqVll4YzRvSjNVb3dmSmJETE5VWStmZ3E4T1Iz?=
 =?utf-8?B?N1dKNGJITkVaM1NVSVlDai94QitaU1Nndy96TTdmc1RmeTFKY1lwU001WlJl?=
 =?utf-8?B?V1Y3aHptTTc4cXAwNTlzQWs3all0aGZHN0xYcnRmbUo1dXZrRVAwcmdnaEhX?=
 =?utf-8?B?YkJHQUF2QWRTejF6aWwyWWFUQmVMbFNUMW8zbVFMamorajF3Z0JISE80dTRP?=
 =?utf-8?B?QWJsQTBieC91S3JCQXZRbjVJdStOUCt5T21ieWJaeXE2enMwVmlWaldrM0oz?=
 =?utf-8?B?eFM1NGptb0lIOTBlaFdPbm45WTA0TGw4T0c2NTdpRUJNWDM3YmxDZWg4Rk9j?=
 =?utf-8?B?c08wUjlIZE5JeXJ0czBpRWRmQUJZRjlQckdNNTQ2YWNEWTJUQXJWZXczOXVR?=
 =?utf-8?B?VnUxeXVGQlBOUW1UaGlNVndyUHdYZi81THlweG1OblZxKzY2bzRsTXVDTHhp?=
 =?utf-8?B?b3FJOXdiSlpzNXdhalVDSUxjRnFDVVUvUFZ3RjRvTjRaUktEZ01FM3FKTUFM?=
 =?utf-8?B?cVpzZk1jdnZqN1JTVU1iOHROdDhOVVlTRmpkTVhtZm5xTlloS2tsYStqSjdj?=
 =?utf-8?B?ak9JcnRYOUErei9TeXY1d0NEM0R3bzBRR1lGaVhGcjdIMWxPY05LTG8rRVRB?=
 =?utf-8?B?QVkvT1JXeklxZjJjRmpEKzJWUi9CQ0FuUm5hUVNCNVlOUEhhandYT1IwbDZz?=
 =?utf-8?B?NmhSZVp0VGEza1BoVStpajFSVytTUnlneWw2Mkh1akZEUmxkQVdpUVFFK09w?=
 =?utf-8?B?MEE2N0txeEtnekw4ZG90b1RXVy9FMmFLSE12OThSWVlhVHFNL2ttMGJ5Ujh4?=
 =?utf-8?B?VzA2UE5vcFRVMXdjelErblRQbjFneTdKOE5HdEdFM2NlT0NNWDA2SWRpMkhU?=
 =?utf-8?B?YWdEaUdoVTZMcW1RYzhFb2NtR3A4TXZJZXNGcVJpTVdGZGg3NmZ3K1c0RjAy?=
 =?utf-8?B?UmVqNWtGWDBDVU8zVVF0bUZiOHpVZ1BIWkt1YTlXTTZOU3Z1YWFhK2ZaNW1Z?=
 =?utf-8?B?MDBQOTNPc2xDK3JFSkduZFZXMnhYOEZIQVA5bGYwWXQ3YTR5a2xHT2hBQkxJ?=
 =?utf-8?B?NVM4cUNtMzZVUGpxYlZDdWZGd2FNeWlmRzA1WlVNSm1BTmpkMURIL1ZwaHBa?=
 =?utf-8?B?V21RVkRCYWNxSC9ZWERET2hmMy9mZkpscjF0NDFSVGdiTXMwMGFaK2I1SDJ5?=
 =?utf-8?B?azI4c2NDMS9kRnVMaDVkRE1sOWxqc3JqRVAxOGhyalhzMGJSWGdSOEttTFd3?=
 =?utf-8?B?SyszMkhpdXpIaElUWHROUXUxdEhjU2t3ZzQzdkpaUG92OTZ1ZGNFQTd1R2RN?=
 =?utf-8?B?V20zRGJnLzhsZmlxMkVnaDhkTGdKaE15eTdpWjFOZ2ZxOG5pYXNxWDZVQzFV?=
 =?utf-8?B?dDVmTmh3aXZhc0NyT3JuZXVKaXdwRGtwaWhVaEo3VDM5QkF1OGNJNnUxZTZI?=
 =?utf-8?Q?uSNk9VcMquT7dyOUA3OrVVCU6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18372dd-2a12-4c36-5e51-08daaa90eeff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 07:27:48.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OAI+TD9s56aIKRMFr8LqPzL+t1+PPeeZg3kVmQrqJS4OxRTHyKtXv9KSnNxhy0ihOPIR0klfFaajAc2P3KN/BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5008
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 07/10/22 20:51, Ard Biesheuvel wrote:
> Implement a minimal library version of GCM based on the existing library
> implementations of AES and multiplication in GF(2^128). Using these
> primitives, GCM can be implemented in a straight-forward manner.
> 
> GCM has a couple of sharp edges, i.e., the amount of input data
> processed with the same initialization vector (IV) should be capped to
> protect the counter from 32-bit rollover (or carry), and the size of the
> authentication tag should be fixed for a given key. [0]
> 
> The former concern is addressed trivially, given that the function call
> API uses 32-bit signed types for the input lengths. It is still up to
> the caller to avoid IV reuse in general, but this is not something we
> can police at the implementation level.
> 
> As for the latter concern, let's make the authentication tag size part
> of the key schedule, and only permit it to be configured as part of the
> key expansion routine.
> 
> Note that table based AES implementations are susceptible to known
> plaintext timing attacks on the encryption key. The AES library already
> attempts to mitigate this to some extent, but given that the counter
> mode encryption used by GCM operates exclusively on known plaintext by
> construction (the IV and therefore the initial counter value are known
> to an attacker), let's take some extra care to mitigate this, by calling
> the AES library with interrupts disabled.
> 
> [0] https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-38d.pdf
> 
> Cc: "Nikunj A. Dadhania" <nikunj@amd.com>
> Link: https://lore.kernel.org/all/c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> +/**
> + * gcm_decrypt - Perform GCM decryption on a block of data
> + * @ctx:	The GCM key schedule
> + * @dst:	Pointer to the plaintext output buffer
> + * @src:	Pointer the ciphertext (may equal @dst for decryption in place)
> + * @crypt_len:	The size in bytes of the plaintext and ciphertext.
> + * @assoc:	Pointer to the associated data,
> + * @assoc_len:	The size in bytes of the associated data
> + * @iv:		The initialization vector (IV) to use for this block of data
> + *		(must be 12 bytes in size as per the GCM spec recommendation)
> + * @authtag:	The address of the buffer in memory where the authentication
> + *		tag is stored.
> + *
> + * Returns 0 on success, or -EBADMSG if the ciphertext failed authentication.
> + * On failure, no plaintext will be returned.
> + */
> +int __must_check gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
> +			     int crypt_len, const u8 *assoc, int assoc_len,
> +			     const u8 iv[GCM_AES_IV_SIZE], const u8 *authtag)
> +{
> +	u8 tagbuf[AES_BLOCK_SIZE];
> +	__be32 ctr[4];
> +
> +	memcpy(ctr, iv, GCM_AES_IV_SIZE);
> +
> +	gcm_mac(ctx, src, crypt_len, assoc, assoc_len, ctr, tagbuf);
> +	if (crypto_memneq(authtag, tagbuf, ctx->authsize)) {
> +		memzero_explicit(tagbuf, sizeof(tagbuf));
> +		return -EBADMSG;
> +	}

The gcm_mac computation seems to be broken in this version. When I receive the encrypted 
packet back from the security processor the authtag does not match. Will debug further 
and report back.

> +	gcm_crypt(ctx, dst, src, crypt_len, ctr);
> +	return 0;
> +}
> +EXPORT_SYMBOL(gcm_decrypt);
> +
> +MODULE_DESCRIPTION("Generic GCM library");
> +MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
> +MODULE_LICENSE("GPL");

Regards
Nikunj
