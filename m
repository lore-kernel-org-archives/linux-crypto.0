Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE7D477E35
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 13:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780578341; cv=none; b=W+v7nkblwg8XyD0y+PrOmAC34sLd4o/VmO6VQ7G1q6J5zllfkcx0cFToyspXfUNO04S0+ZeM7nvF+vW1EWoHJ68bZRckhPT+zTYt1xw/5bsPSkIYHfL6+2ITdiQFj7l3gRXalbTefrYKWb0R7Uv5m15uo0TtK2505fJQ6Z07VZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780578341; c=relaxed/simple;
	bh=wPPPGZJFC6k6RLj8gm5YHC+9mDVIbxLsSHFwHYbrcog=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=r8lc7JYvTL7WA9c2JK5gLQ2nWsDZSnj2VjnuHkCclVK2yUWd3MY1VyHMI3HIadOFOogzzCm0VKLcspWBS7ZOfWcTl3FTrfr3mViNZgXWQq8S2OPFY8I84eN1Cr3U6pnXGSSHaoUFygngSAmKhIha2UEJtZSpDFVDlt7j2JBBsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=uZoNUnJ2; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="uZoNUnJ2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 2DCE4C63453
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 13:05:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E7A385FEF7;
	Thu,  4 Jun 2026 13:05:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 239B5106A1ACE;
	Thu,  4 Jun 2026 15:05:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780578338; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=exQ0rXlGrGyVPsfxJbZH7pj2sHfgCT/ex68u93y5sBE=;
	b=uZoNUnJ202lsmnIVApLw+6ySm8Nxk3SUuzBEjP1ksN4Pzqq4jEqRn1cMh0NsjJqzl7xFon
	TVLt1sj2a+GKqYeWYv1M2WtwIsIdh+DuwJrJjdjkVlPuIpSk3S/xLCSKCdNhIPaKC/RvJL
	skZ8OwM0ekxcBR+YVW94GZrqn1IR+ydzqlFNCfd4uZSeZZXofipqW2FfQ/jplUyMUc6KhO
	/e/g10BztY2ITmbxDtxoVMCwTdu5uSzqw2u/idffcEmgr2/FMQGdhVgVExsQnrFhcYFnKH
	ngG9LYqHv3dboIGgzTiLc1fSUgedxeG4CXxFipXC6lZHDSIUS6kPQjrIFwo+hg==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jun 2026 15:05:36 +0200
Message-Id: <DJ0ACBGP13QP.3UJ74J9XFHOBX@bootlin.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/29] crypto: talitos - Replace SEC1/SEC2 conditionals
 with ops dispatch
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-20-cb1ad6cdea49@bootlin.com>
 <5dce751a-0d48-467e-b8c9-6702366cfd06@kernel.org>
In-Reply-To: <5dce751a-0d48-467e-b8c9-6702366cfd06@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

On Thu Jun 4, 2026 at 11:37 AM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Replace the if/else is_sec1 dispatches in callers with indirect calls
>> through priv->ops. Add static const sec1_ops and sec2_ops structs
>> populated with the SEC1 and SEC2 function variants, and set priv->ops
>> at probe time based on the detected hardware.
>
> Why is that needed ?
>
> I understand your objective at the end is to get rid of that is_sec1=20
> boolean that is carried over the entire call chain but using ops for=20
> that seems overkill.
>
> What about changing it to a helper using static branches, something like=
=20
> (untested) :
>
> #if defined(CONFIG_CRYPTO_DEV_TALITOS1) &&=20
> defined(CONFIG_CRYPTO_DEV_TALITOS2)
> DECLARE_STATIC_KEY_FALSE(talitos_is_sec1);
> static __always_inline bool is_sec1(void)
> {
> 	return static_branch_unlikely(&talitos_is_sec1);
> }
>
> static inline void talitos_init_branch(bool is_sec1)
> {
> 	if (is_sec1)
> 		static_branch_enable(&talitos_is_sec1);
> }
> #else
> static __always_inline bool is_sec1(void)
> {
> 	return IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1);
> }
>
> static inline void talitos_init_branch(bool is_sec1)
> {
> 	BUILD_BUG_ON(is_sec1 && !IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1));
> }
> #endif
>

Thanks you for that suggestion.
This was a lack of knowledge about this mechanism.

>>=20
>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>> ---
>>   drivers/crypto/talitos/talitos.c | 88 +++++++++++++++++++-------------=
--------
>>   1 file changed, 41 insertions(+), 47 deletions(-)
>>=20
>> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/t=
alitos.c
>> index b6793d97735e..c4a311a8e7fd 100644
>> --- a/drivers/crypto/talitos/talitos.c
>> +++ b/drivers/crypto/talitos/talitos.c
>> @@ -258,7 +258,6 @@ static int init_device(struct device *dev)
>>   {
>>   	struct talitos_private *priv =3D dev_get_drvdata(dev);
>>   	int ch, err;
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>>  =20
>>   	/*
>>   	 * Master reset
>> @@ -266,35 +265,23 @@ static int init_device(struct device *dev)
>>   	 * are not fully cleared by writing the MCR:SWR bit,
>>   	 * set bit twice to completely reset
>>   	 */
>> -	if (is_sec1)
>> -		err =3D sec1_reset_device(dev);
>> -	else
>> -		err =3D sec2_reset_device(dev);
>> +	err =3D priv->ops->reset_device(dev);
>>  =20
>>   	if (err)
>>   		return err;
>>  =20
>> -	if (is_sec1)
>> -		err =3D sec1_reset_device(dev);
>> -	else
>> -		err =3D sec2_reset_device(dev);
>> +	err =3D priv->ops->reset_device(dev);
>>   	if (err)
>>   		return err;
>>  =20
>>   	/* reset channels */
>>   	for (ch =3D 0; ch < priv->num_channels; ch++) {
>> -		if (is_sec1)
>> -			err =3D sec1_reset_channel(dev, ch);
>> -		else
>> -			err =3D sec2_reset_channel(dev, ch);
>> +		err =3D priv->ops->reset_channel(dev, ch);
>>   		if (err)
>>   			return err;
>>   	}
>>  =20
>> -	if (is_sec1)
>> -		sec1_configure_device(dev);
>> -	else
>> -		sec2_configure_device(dev);
>> +	priv->ops->configure_device(dev);
>>  =20
>>   	return 0;
>>   }
>> @@ -363,7 +350,6 @@ int talitos_submit(struct device *dev, int ch, struc=
t talitos_desc *desc,
>>   	struct talitos_request *request;
>>   	unsigned long flags;
>>   	int head;
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>>  =20
>>   	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
>>  =20
>> @@ -377,10 +363,8 @@ int talitos_submit(struct device *dev, int ch, stru=
ct talitos_desc *desc,
>>   	request =3D &priv->chan[ch].fifo[head];
>>  =20
>>   	/* map descriptor and save caller data */
>> -	if (is_sec1)
>> -		sec1_dma_map_request(dev, request, desc);
>> -	else
>> -		sec2_dma_map_request(dev, request, desc);
>> +	priv->ops->dma_map_request(dev, request, desc);
>> +
>>   	request->callback =3D callback;
>>   	request->context =3D context;
>>  =20
>> @@ -461,7 +445,6 @@ static void flush_channel(struct device *dev, int ch=
, int error, int reset_ch)
>>   	struct talitos_request *request, saved_req;
>>   	unsigned long flags;
>>   	int tail, status;
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>>  =20
>>   	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
>>  =20
>> @@ -473,10 +456,7 @@ static void flush_channel(struct device *dev, int c=
h, int error, int reset_ch)
>>  =20
>>   		/* descriptors with their done bits set don't get the error */
>>   		rmb();
>> -		if (is_sec1)
>> -			hdr =3D sec1_get_request_hdr(dev, request);
>> -		else
>> -			hdr =3D sec2_get_request_hdr(dev, request);
>> +		hdr =3D priv->ops->get_request_hdr(dev, request);
>>  =20
>>   		if ((hdr & DESC_HDR_DONE) =3D=3D DESC_HDR_DONE)
>>   			status =3D 0;
>> @@ -486,10 +466,7 @@ static void flush_channel(struct device *dev, int c=
h, int error, int reset_ch)
>>   			else
>>   				status =3D error;
>>  =20
>> -		if (is_sec1)
>> -			sec1_dma_unmap_request(dev, request);
>> -		else
>> -			sec2_dma_unmap_request(dev, request);
>> +		priv->ops->dma_unmap_request(dev, request);
>>  =20
>>   		/* copy entries so we can call callback outside lock */
>>   		saved_req.desc =3D request->desc;
>> @@ -611,7 +588,6 @@ static __be32 sec2_search_desc_hdr_in_request(struct=
 talitos_request *request,
>>   static __be32 current_desc_hdr(struct device *dev, int ch)
>>   {
>>   	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>>   	struct talitos_request *request;
>>   	int tail, iter;
>>   	dma_addr_t cur_desc;
>> @@ -630,10 +606,7 @@ static __be32 current_desc_hdr(struct device *dev, =
int ch)
>>   	do {
>>   		request =3D &priv->chan[ch].fifo[iter];
>>  =20
>> -		if (is_sec1)
>> -			hdr =3D sec1_search_desc_hdr_in_request(request, cur_desc);
>> -		else
>> -			hdr =3D sec2_search_desc_hdr_in_request(request, cur_desc);
>> +		hdr =3D priv->ops->search_desc_hdr_in_request(request, cur_desc);
>>   		if (hdr)
>>   			break;
>>  =20
>> @@ -833,13 +806,9 @@ static int sec2_talitos_handle_error(struct device =
*dev, u32 isr, u32 isr_lo)
>>   static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
>>   {
>>   	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>>   	int ch, reset_dev;
>>  =20
>> -	if (is_sec1)
>> -		reset_dev =3D sec1_talitos_handle_error(dev, isr, isr_lo);
>> -	else
>> -		reset_dev =3D sec2_talitos_handle_error(dev, isr, isr_lo);
>> +	reset_dev =3D priv->ops->handle_error(dev, isr, isr_lo);
>>  =20
>>   	if (reset_dev) {
>>   		dev_err(dev,
>> @@ -1391,6 +1360,32 @@ static void sec2_init_task(struct device *dev)
>>   	}
>>   }
>>  =20
>> +static const struct talitos_ops sec1_ops =3D {
>> +	.probe_irq =3D sec1_talitos_probe_irq,
>> +	.init_task =3D sec1_init_task,
>> +	.reset_device =3D sec1_reset_device,
>> +	.reset_channel =3D sec1_reset_channel,
>> +	.configure_device =3D sec1_configure_device,
>> +	.dma_map_request =3D sec1_dma_map_request,
>> +	.dma_unmap_request =3D sec1_dma_unmap_request,
>> +	.get_request_hdr =3D sec1_get_request_hdr,
>> +	.search_desc_hdr_in_request =3D sec1_search_desc_hdr_in_request,
>> +	.handle_error =3D sec1_talitos_handle_error,
>> +};
>> +
>> +static const struct talitos_ops sec2_ops =3D {
>> +	.probe_irq =3D sec2_talitos_probe_irq,
>> +	.init_task =3D sec2_init_task,
>> +	.reset_device =3D sec2_reset_device,
>> +	.reset_channel =3D sec2_reset_channel,
>> +	.configure_device =3D sec2_configure_device,
>> +	.dma_map_request =3D sec2_dma_map_request,
>> +	.dma_unmap_request =3D sec2_dma_unmap_request,
>> +	.get_request_hdr =3D sec2_get_request_hdr,
>> +	.search_desc_hdr_in_request =3D sec2_search_desc_hdr_in_request,
>> +	.handle_error =3D sec2_talitos_handle_error,
>> +};
>> +
>>   static int talitos_probe(struct platform_device *ofdev)
>>   {
>>   	struct device *dev =3D &ofdev->dev;
>> @@ -1474,16 +1469,15 @@ static int talitos_probe(struct platform_device =
*ofdev)
>>   	}
>>  =20
>>   	if (has_ftr_sec1(priv))
>> -		err =3D sec1_talitos_probe_irq(ofdev);
>> +		priv->ops =3D &sec1_ops;
>>   	else
>> -		err =3D sec2_talitos_probe_irq(ofdev);
>> +		priv->ops =3D &sec2_ops;
>> +
>> +	err =3D priv->ops->probe_irq(ofdev);
>>   	if (err)
>>   		goto err_out;
>>  =20
>> -	if (has_ftr_sec1(priv))
>> -		sec1_init_task(dev);
>> -	else
>> -		sec2_init_task(dev);
>> +	priv->ops->init_task(dev);
>>  =20
>>   	priv->fifo_len =3D roundup_pow_of_two(priv->chfifo_len);
>>  =20
>>=20




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

