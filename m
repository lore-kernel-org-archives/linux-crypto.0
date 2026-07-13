Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2AC1DFDA1;
	Mon, 13 Jul 2026 03:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783913487; cv=none; b=ks5LFlCbMBFpCmHy+DJIWIsgJHRpscMA69SE6ZuI7K91rnMYupj1+WqPA4IuhxDFV5aINRlDV4zuRGcAvkcvKe2iMKvnn8+CjeWBzjwN5F2jX9gdHmHmydf47S52Vdl+l1Uj06Q1BVMB2uyck58Q15J4K38lsI/1aGFsvx6lixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783913487; c=relaxed/simple;
	bh=yn6CSO24b0+nwTv1JL4Wh60XfPU/R6sqVcXQSImzD30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWtSXQ5JsS++qQOLwo3uFPxEyE90CLCwkYrxhaOKV5Bxh1zlfEFrDybZ7AWDlZgHf6aKBYzArwud64QawJSgu0Y3rWsQATmc4+80wWwFJFghyW1RgjxSi+sB085D/MSOgInqvsxqgwb8Ni1/6xLY5Gi4h60+gOsK5ZW+h9AlI9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1lOdL9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1lOdL9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5721F000E9;
	Mon, 13 Jul 2026 03:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783913486;
	bh=EWoh0L1t9pHsEoOde9LON+LMQGauZWMksz8lAEpdX3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c1lOdL9IXZei1QwCMdadD29SCABuIXIxxKc9OliXqMeDMsIbNkhL4c/rCTSdWIKOB
	 l+EIO5JnR8myyg5kLL0EpEZbFcFst5hhM2nZoISNtOfrTBHeD5BXa4LYvrKQsQDaJ4
	 /w1NgwcW8X+3WVy8Qkk/tlXzZMvxl7UiIrTYYs9WC1AJeWqAMS72+jRhcESDCUAzB0
	 AFx6ajYLfLC6U5Hu8dZEAUaRucTZVZlgBvHP/Ynr8FSKl/1SiRjY1ZtBLDTP1syeZR
	 IFBHNR4kzVRQNRhxiFuNRsk7qADssNFd4MD6NWNijLD4d4xedFHJnUMTztBBZQMDXH
	 sOUP22hqumXRg==
Date: Sun, 12 Jul 2026 23:31:24 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] crypto: pcrypt - Remove pcrypt
Message-ID: <20260713033124.GG4362@quark>
References: <20260713032600.44355-1-ebiggers@kernel.org>
 <alRbsLpptbdSsBlf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alRbsLpptbdSsBlf@gondor.apana.org.au>

On Mon, Jul 13, 2026 at 01:29:52PM +1000, Herbert Xu wrote:
> Looks good to me.
> 
> More than half of kernel/padata.c is only used by pcrypt and can
> also be removed if pcrypt is removed.
> 
> Thanks,

Yes, that would be a separate patch.

- Eric
