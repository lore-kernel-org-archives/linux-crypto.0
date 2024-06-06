Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECDFB19750B;
	Thu,  6 Jun 2024 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717698075; cv=none; b=P2UUGD0BapPVNE7pfo/lYSk9BG9e3yV/nur3JJKLcgaQBYrwfDPPwmg3WAgBxJJhkmbh8eQi797O4rzyb1ARXpfDEKrHxWM37/WJ8tzZE4PHmlx0zq74fCgx86evDmG4xXMVHKA/bNOpv+kbllV/v0xglYlGbCr4cK86xUopWyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717698075; c=relaxed/simple;
	bh=anY/d8A01PQ7OY+Z7i2qgvA8r2Z5cysTIgQdnQRQQn8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pskBOXXf29gGbSx5gKpkuvN4bHG/R7ARcaBUq8bHTfRoyrSBt7ZznwFtzogcLu9lKbyUu6Cy+wyb6Ayr43D8yC3ZYagcGOl0JMBzwV2uJbkD8WQgyoaAk18flgU9kObDGqPCTaTsA7/P0RWC5na1E4pljYVKqvdtfOgWqRa0zYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rW067lQc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rW067lQc"
Received: from [192.168.49.54] (c-73-118-245-227.hsd1.wa.comcast.net [73.118.245.227])
	by linux.microsoft.com (Postfix) with ESMTPSA id B279320B915A;
	Thu,  6 Jun 2024 11:21:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B279320B915A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1717698066;
	bh=hc7uke1nP9K6ZEiOlab0+7WnHfaWkClsnMNcflkN4jU=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=rW067lQc+jCvJbWL4V/gx0fjzaOI9VmYDgh34Vn4R/RlxAZUYvYF8R9dv28mxYPrQ
	 peHPLzSrKw0Yhb4WX94d0ehATIIimuY2yUEilS31GXxHAxqD51wlohfEXsqvdd0BnM
	 W0IQUuyLgQ8/nPdRDNo7xShM+ZPaUtSbmo5qxwcE=
Message-ID: <27a0ad29-a096-48fe-b9fc-e918464227da@linux.microsoft.com>
Date: Thu, 6 Jun 2024 11:21:06 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] crypto: algif_aead: After having been compared to a NULL
 value at algif_aead.c:191, pointer 'tsgl_src' is passed as 2nd parameter in
 call to function 'crypto_aead_copy_sgl' at algif_aead.c:244, where it is
 dereferenced at algif_aead.c:85.
To: Alexander Sapozhnikov <alsp705@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <20240606172023.23-1-alsp705@gmail.com>
Content-Language: en-US
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20240606172023.23-1-alsp705@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/2024 10:20 AM, Alexander Sapozhnikov wrote:
> From: Alexandr Sapozhnikov <alsp705@gmail.com>
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
> ---
>  crypto/algif_aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 42493b4..f757907 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -191,7 +191,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		if (tsgl_src)
>  			break;
>  	}
> -	if (processed && !tsgl_src) {
> +	if (processed || !tsgl_src) {
>  		err = -EFAULT;
>  		goto free;
>  	}


Please see
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format
and format your subject line accordingly.

Thanks,
Easwar
