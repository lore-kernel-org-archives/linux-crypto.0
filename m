Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F6C143890;
	Fri,  5 Jul 2024 06:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161799; cv=none; b=P26a/cQQ7eVU3DliglXqoTIfc4BYmcVk4ogfdbWGuBucIJDZW2k0VZeB8QqZvoIIscEMRNqOMBg2c4snd5TOQ0/Vss4X1j7IMta8lGiqU0xRBAEMWguNSQJbwUfif5LS5+bBSh/mZJmYzMEuHHfha2mY2x6Wp5LH3nuexw9XHzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161799; c=relaxed/simple;
	bh=8qoHFSRKhHhJ8qBwr1oPNZA0QMdxUS4HBp4ofdLFHaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azK0Z8pXfexeepJzaoLYcxwPsDirdpoqWSjyLwsY3onYM3mCYKn/ar6SLO4GRiUuXTaF9SvpmKgSuvzGCFuiAsiwtgRjS4NTN/SKaya2Yy1XmWJ7KhH9Ly/X82UDYB9Dcfl8n2kmCPtvBauUI7fjkHIiBucv7AkvhAZaGPK9XEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b8QcIczu; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b8QcIczu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1720161793; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2LPcby+iS6BBEYNZnz/2U/NNFAHgLJPj1zgzlJlT1Js=;
	b=b8QcIczuEMZaUyOfj06MNPb/b0nU/xVUx/Zc/dSB17ShJMB5GrWLANXE65FmQE08Y5fHGRlwkgMkG/3KkiW2Xl/YTF4/auXRsEl7by12J/+Lgy253CSlnG2t3fvn/yR6AEJDFZNLos0Q3MvXe3ODi7w98aLE+OSYgXagE6imCEs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0W9txrXV_1720161791;
Received: from 30.246.181.6(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0W9txrXV_1720161791)
          by smtp.aliyun-inc.com;
          Fri, 05 Jul 2024 14:43:12 +0800
Message-ID: <e5e4db6f-079c-45e7-b079-ef2a6851dd29@linux.alibaba.com>
Date: Fri, 5 Jul 2024 14:43:11 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: lib/mpi: delete unnecessary condition
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Mimi Zohar
 <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <6686bed3.4a0a0220.6aa45.6c34@mx.google.com>
Content-Language: en-US
From: "tianjia.zhang" <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <6686bed3.4a0a0220.6aa45.6c34@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2024/7/4 23:25, Dan Carpenter wrote:
> We checked that "nlimbs" is non-zero in the outside if statement so delete
> the duplicate check here.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---


Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>


>   lib/crypto/mpi/mpi-bit.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/lib/crypto/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
> index 070ba784c9f1..e08fc202ea5c 100644
> --- a/lib/crypto/mpi/mpi-bit.c
> +++ b/lib/crypto/mpi/mpi-bit.c
> @@ -212,12 +212,10 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
>   			return;
>   		}
>   
> -		if (nlimbs) {
> -			for (i = 0; i < x->nlimbs - nlimbs; i++)
> -				x->d[i] = x->d[i+nlimbs];
> -			x->d[i] = 0;
> -			x->nlimbs -= nlimbs;
> -		}
> +		for (i = 0; i < x->nlimbs - nlimbs; i++)
> +			x->d[i] = x->d[i+nlimbs];
> +		x->d[i] = 0;
> +		x->nlimbs -= nlimbs;
>   
>   		if (x->nlimbs && nbits)
>   			mpihelp_rshift(x->d, x->d, x->nlimbs, nbits);


Cheers,

Tianjia

