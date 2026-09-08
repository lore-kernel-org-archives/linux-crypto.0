Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C96519913;
	Tue,  8 Sep 2026 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860254; cv=none; b=ky9RaRddmxRik2fB+MNmC9A2sjQz45zj2FLxfnll1A5lUSlnllYsb3lQmhf+6lAYNPEZU7BkWitmdKRAvzdNGHHuQ48MnIaCFcHk8wZky/+qGerTOwJmMS1RpLAF/pt2bff/0/AsOWPOVdNSmMutT0QYe2a5p/VNaRf3vRH09+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860254; c=relaxed/simple;
	bh=Uzro9sQyNbEXpshQpInNR8RyMssihPgj7sRtvoTsTRQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=rn00IGjsoYq1rKnShMsaXDyCiTnMqod06r+HY6G/8Ns6rqZPL9nLh8s0wuEEpTZ3MO36Ia+7Y9MUsjXezNgbwLIaWPfxSplFilMKz9dSZY4RB2t6AjVZ6JsX5rXGu2BlNX+bPM6toVX/sfDx4jNj/ZBaDPxn/heowBPrXpfuUVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=o2sFK7r+; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="o2sFK7r+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yCthNr5mJM9tAeqQeJQ8svvk+g0Q+GqxOFfeKxDoCjk=; b=o2sFK7r+mVqe1wEsO8jOZ4Zzi6
	amtR+kji1nwyTlsmWpU3Mbgkz+z5kzixEgJjF7A7doqBj3VswbhSs3vmiae0dS5Z5aWfdmYQeGX/i
	LznBj2F1AM1zJVfAtmF9b7cI56C9FN041WxfOgJTEuCPaZawtRTGzMMhPDz4CEEuOouTjTQutZODt
	zrN4OJ+fTo6/EKYaTZOCZyno0Jyi1gZeCeIaL3vHYATK5DrXCyoLI6A7sMExZf59fe55XJF8ji2Fa
	QfgmLo7rW21LC6hsigjmTxM7jFgjVMRdGXIUkaFDd1g2uKnbi+hQJdgrAvEyvsm3nOBRI8sc3Q9ZC
	nDAwSJ0w==;
Received: from [::1] (port=34328 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1x3sGi-0000000ABeP-3g1Q;
	Tue, 08 Sep 2026 11:37:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 08 Sep 2026 11:37:30 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: arei.gonglei@huawei.com, mst@redhat.com, davem@davemloft.net,
 jasowangio@gmail.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, Bryam Vargas <hexlabsecurity@proton.me>
Subject: Re: [PATCH] crypto: virtio: validate akcipher completion length
In-Reply-To: <ap_TatiabFuXiiad@gondor.apana.org.au>
References: <20260821095511.3600564-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <ap_TatiabFuXiiad@gondor.apana.org.au>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <7fc9c66a8d89113854ecf8cc54ecb0c5@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-09-08 11:20, Herbert Xu wrote:
> On Fri, Aug 21, 2026 at 09:55:12AM +0000, Jérémy Jean wrote:
>> The device controls the used length returned for an akcipher request.
>> Subtracting the status byte without validating that length can 
>> underflow
>> dst_len, while accepting a payload larger than the submitted 
>> destination
>> can make sg_copy_from_buffer() read past the response buffer.
>> 
>> Reject malformed completion lengths before updating dst_len or copying 
>> the
>> response.
>> 
>> Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> ---
>>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 13 
>> ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c 
>> b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
>> index d8d452cac391..886032abae80 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
>> @@ -69,6 +69,7 @@ static void 
>> virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>>  	struct akcipher_request *akcipher_req =
>>  		container_of((void *)vc_akcipher_req, struct akcipher_request,
>>  			     __ctx);
>> +	unsigned int dst_len;
>>  	int error;
>> 
>>  	switch (vc_req->status) {
>> @@ -88,9 +89,19 @@ static void 
>> virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>>  	}
>> 
>>  	/* actual length may be less than dst buffer */
>> -	akcipher_req->dst_len = len - sizeof(vc_req->status);
> 
> This appears to have already been fixed by
> 
> commit f77a956f6a19f9463ef1527c9d0cda50dded6b92
> Author: Bryam Vargas <hexlabsecurity@proton.me>
> Date:   Mon Jun 22 01:52:15 2026 -0500
> 
>     crypto: virtio - bound the akcipher result length
> 
> Please check that commit and see if it's sufficient or not.
> 
> Thanks,

Hello,

Indeed, this fixes the bug.
Thanks for the pointer, I missed that patch.

Regards,
Jérémy
