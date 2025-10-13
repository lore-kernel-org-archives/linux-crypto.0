Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8412EB5C9;
	Mon, 13 Oct 2025 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343793; cv=none; b=cZucVFEGKVFM7pOl25amp6ziWEle+rSnIlrsyfSqMFU8Pqy8v1gd8YshaQOP6Rl10l6/pX54DLbhufOWY0vIeynATbPFytghJo2AjvXosWShuzGpqpj898dvNYfuN4ahaXnPJrsYLP+L51XMRWbKTKnVT+zfawWA05NZNDc64V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343793; c=relaxed/simple;
	bh=1kR31gbBKnUscwS6ZTjsnygKJs8ivj+9YtUWNXRZP3Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZbFFeE+sldQUBKqyAXmWv7iXh8btwxFtf3SS556QYE9/u4F5uDilfERc4pe86ImffFiTNbGCD+DJ8OKFrXyIiGSIgZCsQPjkZQlvBKbDhRvj2G2m1queIuaV5wmPk3W6GjaHIp1neVeT8gzJzTAdfjAQmZtqPzYxvVC0Ux4K1qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2nd+b5Z; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2nd+b5Z"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760343786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvAwE+mYlFFTAsj2rEKkqTesljDavewgCpk7RarO+os=;
	b=O2nd+b5ZQqqRTbpp7mYz1uktv8h7XNclbxxqpyGymBYBngnMHmyYjuFOAgkEMdPm8i0pzh
	P+JyicDM6y7IsHrVTw1R7I7HNePuy38/7pTu2zdYsYE3XVc5zlyKySaLNJ/bZIVwE2lNnc
	qtcTON8QsOaizF3zblxb4jSQlMXxQAE=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v2 1/2] crypto: asymmetric_keys - prevent overflow in
 asymmetric_key_generate_id
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aOybIZ2iqXExpTUw@wunner.de>
Date: Mon, 13 Oct 2025 10:23:01 +0200
Cc: David Howells <dhowells@redhat.com>,
 Ignat Korchagin <ignat@cloudflare.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Vivek Goyal <vgoyal@redhat.com>,
 stable@vger.kernel.org,
 keyrings@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4AF8BE0F-D400-4020-A8F6-EF61A797A24E@linux.dev>
References: <20251012203841.60230-1-thorsten.blum@linux.dev>
 <aOybIZ2iqXExpTUw@wunner.de>
To: Lukas Wunner <lukas@wunner.de>
X-Migadu-Flow: FLOW_OUT

On 13. Oct 2025, at 08:24, Lukas Wunner wrote:
> On Sun, Oct 12, 2025 at 10:38:40PM +0200, Thorsten Blum wrote:
>> +++ b/crypto/asymmetric_keys/asymmetric_type.c
>> @@ -141,12 +142,14 @@ struct asymmetric_key_id =
*asymmetric_key_generate_id(const void *val_1,
>> 						     size_t len_2)
>> {
>> 	struct asymmetric_key_id *kid;
>> +	size_t len;
>>=20
>> -	kid =3D kmalloc(sizeof(struct asymmetric_key_id) + len_1 + =
len_2,
>> -		      GFP_KERNEL);
>> +	if (check_add_overflow(len_1, len_2, &len))
>> +		return ERR_PTR(-EOVERFLOW);
>> +	kid =3D kmalloc(struct_size(kid, data, len), GFP_KERNEL);
>=20
> This will add (at least) 2 bytes to len (namely the size of struct
> asymmetric_key_id)) and may cause an overflow (even if len_1 + len_2
> did not overflow).

Could you explain which part adds "(at least) 2 bytes to len"?

Thanks,
Thorsten

