Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECC12FE071;
	Wed,  3 Sep 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756911254; cv=none; b=WHOY5mtYoM0w1YhpdCfhsY2Cwb8+xa+4BACYCpDwSnZDD76HqCplru9XExHKSLjX/0lnoJnoUeg9a460ZBACP2Rt04rI48HlUYeqz96ANkWC4VTvtjryi/Y0GEFUJkM1LvLwuPFBgVD3OeKeIw5mo9OkN8ubRd2c4gLocDnsLwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756911254; c=relaxed/simple;
	bh=OooI5PPhh/VV5eZk6iwMam+IPZzO03EriXPFhdCwyCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDr6TW2ROadXzjSdHcxrvkoSqjATb3vyCjjRqYdr39mLUiRV2w08nUt/PbVGzbDvs3vd/k3piI2vEDR8iAEHV7E++0R/AG4ph17nxcbqq18/wJdTGfwJysEUH59nyGN7MszcRFqV4XYIp16Gh5b0rOGEPJLY9/gOU7mOdzNMFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biYt5MLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biYt5MLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B62CC4CEE7;
	Wed,  3 Sep 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756911254;
	bh=OooI5PPhh/VV5eZk6iwMam+IPZzO03EriXPFhdCwyCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=biYt5MLI5sC128nBMVkzp3UB26qgVO3laVRRqBnhmujpVi1JqZ33uwVUpm+yNp5RC
	 QAvz1yvEs7BVbGW+vhhe4kKFoZsTPNld+Oe1qMWMe68RY5wE2VRc35SyhVLVdDJ8Nd
	 zQggYS/eFDjXwrUjYwTdjT+vQgDP3r5m4fxOej+TSVGmuB8whAhjYRiTwVyy382kh+
	 KO/5p32ZYkyxDew9+E5/qfQcpphZw6/ok/dcqPRVG7y7fhyN+EzB6WG1/1yYE7HFWM
	 nJ0m0tBNlMegliAE3hN4diImzZ1PLIi7DLYtXbZdN9YeVBYfjjy/pQcxP2AXS3Xyps
	 hucSRIx+95ueg==
Message-ID: <3603d3a2-4527-4ac4-82aa-7533f33e92db@kernel.org>
Date: Wed, 3 Sep 2025 09:54:13 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Fix incorrect payload size calculation in
 psp_poulate_hsti()
To: Yunseong Kim <ysk@kzalloc.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250903131642.16798-2-ysk@kzalloc.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250903131642.16798-2-ysk@kzalloc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/25 8:16 AM, Yunseong Kim wrote:
> payload_size field of the request header is incorrectly calculated using
> sizeof(req). Since 'req' is a pointer (struct hsti_request *), sizeof(req)
> returns the size of the pointer itself (e.g., 8 bytes on a 64-bit system),
> rather than the size of the structure it points to. This leads to an
> incorrect payload size being sent to the Platform Security Processor (PSP),
> potentially causing the HSTI query command to fail.
> 
> Fix this by using sizeof(*req) to correctly calculate the size of the
> struct hsti_request.
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
>   drivers/crypto/ccp/hsti.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
> index 1b39a4fb55c0..0e6b73b55dbf 100644
> --- a/drivers/crypto/ccp/hsti.c
> +++ b/drivers/crypto/ccp/hsti.c
> @@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
>   	if (!req)
>   		return -ENOMEM;
>   
> -	req->header.payload_size = sizeof(req);
> +	req->header.payload_size = sizeof(*req);
>   
>   	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
>   	if (ret)

