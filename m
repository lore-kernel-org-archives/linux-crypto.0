Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3973264CF;
	Thu,  4 Jun 2026 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780566521; cv=none; b=VdQ5mciUxMKCjuLMp9gpUkZb+cXPcmzNKT8kpuy/fgLU8VuKuZwXQndiog5syGabNssbKwrWrlDnhCUj87Zej7U5sbqc7ERg9gKMlbD3ZGwuPkc4rAuexk4UJgTThBz9xhe3yJu/DZUTLBsLyWKm9cjJgxM4viS540Is/NC0qF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780566521; c=relaxed/simple;
	bh=02d6w3FJAegB5uwwO6RLL3OTn9HyLMgDYWXA1X/OZD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PfCNWjS5enAdTDd9UQqnYJh171TTDosK8E87hckvtggDxa1auRF2YwqRPAh//jMW6L758CPhVUe027GHyiDN7EcO6PuP96qT4aPL2PCHjkNJOxN6ObsoPO1R2CTFFJ1dLXRYJ+eR7OokAq2W2PBIy+P9I3Vpo1MaHA6xlEJWxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GB4JlFvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GB4JlFvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B79B1F00893;
	Thu,  4 Jun 2026 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780566519;
	bh=Z9ULK+lhCxMXaYs6fUNup5GCQZxbreaE4DzqAEDalBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GB4JlFvPeYCKsP5Hq6A3jZDdfBuNFzVFGEEMC8EbIqjLQDWRbVZNnMEQHOiG2p7La
	 1xbthyoKW72lx6btbswQ3CAwRAJd3qwYAv4XnGBAMXOT8eW7kMi+oNpX4LaCm+v0ue
	 RCgPiyyml59GkWIZUGr4uiWmFP/qZonHfukN6yWaUnq7mzlhpEfYKRxhabVLUHRZ3Y
	 5BJOVKNdg4C7jxgPn0p8PiAHOK9zv8uSy9y4NiZorJexy6m53BNZl+h/Lcnfn/6dCV
	 UPFalt8f6gC22LgXi+VViZbkjR/eqlbB6Cma3OpmLDEheHC8i59FLX2EQLuSzjVsHX
	 SQKmEhtit4pPg==
Message-ID: <8c540731-8bd3-4b7d-ad83-428a11297e00@kernel.org>
Date: Thu, 4 Jun 2026 11:48:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/29] crypto: talitos - Introduce per-SEC-version pointer
 helper ops
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-24-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-24-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Introduce struct talitos_ptr_ops to abstract SEC1/SEC2 differences
> in pointer handling behind per-SEC-version ops.  Add ptr_ops to
> struct talitos_private and struct talitos_ctx, and register the
> appropriate SEC1 or SEC2 implementation at probe time.

Those helpers are so small they deserve being inlined not called 
indirectly. You should reconsider them using the is_sec1() helper I 
proposed on patch 20.

00000000 <sec1_to_talitos_ptr>:
    0:	90 83 00 04 	stw     r4,4(r3)
    4:	b0 a3 00 02 	sth     r5,2(r3)
    8:	4e 80 00 20 	blr

0000000c <sec1_copy_talitos_ptr>:
    c:	81 24 00 04 	lwz     r9,4(r4)
   10:	91 23 00 04 	stw     r9,4(r3)
   14:	a1 24 00 02 	lhz     r9,2(r4)
   18:	b1 23 00 02 	sth     r9,2(r3)
   1c:	4e 80 00 20 	blr

00000020 <sec1_from_talitos_ptr_len>:
   20:	a0 63 00 02 	lhz     r3,2(r3)
   24:	4e 80 00 20 	blr

00000028 <sec1_to_talitos_ptr_ext_set>:
   28:	4e 80 00 20 	blr

0000002c <sec1_get_ptr_value>:
   2c:	80 63 00 04 	lwz     r3,4(r3)
   30:	4e 80 00 20 	blr

00000034 <sec1_get_hdr>:
   34:	80 63 00 00 	lwz     r3,0(r3)
   38:	4e 80 00 20 	blr

0000003c <sec1_get_hdr_lo>:
   3c:	38 60 00 00 	li      r3,0
   40:	4e 80 00 20 	blr

00000044 <sec1_set_hdr>:
   44:	90 83 00 00 	stw     r4,0(r3)
   48:	4e 80 00 20 	blr

0000004c <sec1_get_ptr>:
   4c:	54 84 18 38 	slwi    r4,r4,3
   50:	38 84 00 04 	addi    r4,r4,4
   54:	7c 63 22 14 	add     r3,r3,r4
   58:	4e 80 00 20 	blr

00000be8 <sec1_to_talitos_ptr_ext_or>:
  be8:	4e 80 00 20 	blr


> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos-sec1.c | 36 +++++++++++++++++++++++++++++++
>   drivers/crypto/talitos/talitos-sec2.c | 40 +++++++++++++++++++++++++++++++++++
>   drivers/crypto/talitos/talitos.c      |  2 ++
>   drivers/crypto/talitos/talitos.h      | 12 +++++++++++
>   4 files changed, 90 insertions(+)
> 
> diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
> index 695d531aa7f4..ef1bd19b6772 100644
> --- a/drivers/crypto/talitos/talitos-sec1.c
> +++ b/drivers/crypto/talitos/talitos-sec1.c
> @@ -73,6 +73,33 @@ static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
>   
>   DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
>   
> +static void sec1_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> +				unsigned int len)
> +{
> +	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
> +	ptr->len1 = cpu_to_be16(len);
> +}
> +
> +static void sec1_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> +				  struct talitos_ptr *src_ptr)
> +{
> +	dst_ptr->ptr = src_ptr->ptr;
> +	dst_ptr->len1 = src_ptr->len1;
> +}
> +
> +static unsigned short sec1_from_talitos_ptr_len(struct talitos_ptr *ptr)
> +{
> +	return be16_to_cpu(ptr->len1);
> +}
> +
> +static void sec1_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
> +{
> +}
> +
> +static void sec1_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
> +{
> +}
> +
>   static int sec1_reset_device(struct device *dev)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
> @@ -286,6 +313,14 @@ static void sec1_init_task(struct device *dev)
>   			     (unsigned long)dev);
>   }
>   
> +static const struct talitos_ptr_ops sec1_ptr_ops = {
> +	.to_talitos_ptr = sec1_to_talitos_ptr,
> +	.copy_talitos_ptr = sec1_copy_talitos_ptr,
> +	.from_talitos_ptr_len = sec1_from_talitos_ptr_len,
> +	.to_talitos_ptr_ext_set = sec1_to_talitos_ptr_ext_set,
> +	.to_talitos_ptr_ext_or = sec1_to_talitos_ptr_ext_or,
> +};
> +
>   static const struct talitos_ops sec1_ops = {
>   	.probe_irq = sec1_talitos_probe_irq,
>   	.init_task = sec1_init_task,
> @@ -302,4 +337,5 @@ static const struct talitos_ops sec1_ops = {
>   void talitos_register_sec1(struct talitos_private *priv)
>   {
>   	priv->ops = &sec1_ops;
> +	priv->ptr_ops = &sec1_ptr_ops;
>   }
> diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
> index 962e7cd43631..14f0ca13e6e5 100644
> --- a/drivers/crypto/talitos/talitos-sec2.c
> +++ b/drivers/crypto/talitos/talitos-sec2.c
> @@ -79,6 +79,37 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
>   DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
>   DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
>   
> +static void sec2_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> +				unsigned int len)
> +{
> +	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
> +	ptr->len = cpu_to_be16(len);
> +	ptr->eptr = upper_32_bits(dma_addr);
> +}
> +
> +static void sec2_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> +				  struct talitos_ptr *src_ptr)
> +{
> +	dst_ptr->ptr = src_ptr->ptr;
> +	dst_ptr->len = src_ptr->len;
> +	dst_ptr->eptr = src_ptr->eptr;
> +}
> +
> +static unsigned short sec2_from_talitos_ptr_len(struct talitos_ptr *ptr)
> +{
> +	return be16_to_cpu(ptr->len);
> +}
> +
> +static void sec2_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
> +{
> +	ptr->j_extent = val;
> +}
> +
> +static void sec2_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
> +{
> +	ptr->j_extent |= val;
> +}
> +
>   static int sec2_reset_channel(struct device *dev, int ch)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
> @@ -311,6 +342,14 @@ static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
>   	return 0;
>   }
>   
> +static const struct talitos_ptr_ops sec2_ptr_ops = {
> +	.to_talitos_ptr = sec2_to_talitos_ptr,
> +	.copy_talitos_ptr = sec2_copy_talitos_ptr,
> +	.from_talitos_ptr_len = sec2_from_talitos_ptr_len,
> +	.to_talitos_ptr_ext_set = sec2_to_talitos_ptr_ext_set,
> +	.to_talitos_ptr_ext_or = sec2_to_talitos_ptr_ext_or,
> +};
> +
>   static const struct talitos_ops sec2_ops = {
>   	.probe_irq = sec2_talitos_probe_irq,
>   	.init_task = sec2_init_task,
> @@ -327,4 +366,5 @@ static const struct talitos_ops sec2_ops = {
>   void talitos_register_sec2(struct talitos_private *priv)
>   {
>   	priv->ops = &sec2_ops;
> +	priv->ptr_ops = &sec2_ptr_ops;
>   }
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index 152618998819..0e4bd130ac6d 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -668,6 +668,8 @@ int talitos_init_common(struct talitos_ctx *ctx,
>   	/* select done notification */
>   	ctx->desc_hdr_template |= DESC_HDR_DONE_NOTIFY;
>   
> +	ctx->ptr_ops = priv->ptr_ops;
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index ae0bdb2ea78e..09d4e8fb0e62 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -140,6 +140,16 @@ struct talitos_channel {
>   	int tail;
>   };
>   
> +struct talitos_ptr_ops {
> +	void (*to_talitos_ptr)(struct talitos_ptr *ptr, dma_addr_t addr,
> +			       unsigned int len);
> +	void (*copy_talitos_ptr)(struct talitos_ptr *dst_ptr,
> +				 struct talitos_ptr *src_ptr);
> +	unsigned short (*from_talitos_ptr_len)(struct talitos_ptr *ptr);
> +	void (*to_talitos_ptr_ext_set)(struct talitos_ptr *ptr, u8 val);
> +	void (*to_talitos_ptr_ext_or)(struct talitos_ptr *ptr, u8 val);
> +};
> +
>   struct talitos_ops {
>   	int (*probe_irq)(struct platform_device *ofdev);
>   	void (*init_task)(struct device *dev);
> @@ -183,6 +193,7 @@ struct talitos_private {
>   	unsigned int desc_types;
>   
>   	const struct talitos_ops *ops;
> +	const struct talitos_ptr_ops *ptr_ops;
>   
>   	/* SEC Compatibility info */
>   	unsigned long features;
> @@ -213,6 +224,7 @@ struct talitos_private {
>   
>   struct talitos_ctx {
>   	struct device *dev;
> +	const struct talitos_ptr_ops *ptr_ops;
>   	int ch;
>   	__be32 desc_hdr_template;
>   	u8 key[TALITOS_MAX_KEY_SIZE];
> 

