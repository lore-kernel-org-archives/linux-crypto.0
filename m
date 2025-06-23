Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0725F1E231F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 09:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671655; cv=none; b=JmPu6wZ+PQVc+pwK9RJnnammNMvPRfbbL2TJ1aSZvAY/oZsJeCfNuEbv9Ru6cG1nBiBAZB+Fd4WWewlxSH4wMr1easeHYmdW+di925hlTGzbpYgXnPYMiswT4BHcMD1fs2GukhssA0Hij1U9rnJYTAVCkGV7BlDa4rpBNZcwTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671655; c=relaxed/simple;
	bh=QsRfJW7Cn1yNnUQoM5vDqmBJ7+dd/m17wB+nQYPVX+w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uXbmTnDhiv+aLRizkQgM6PMgpn2vCatNUX7tQxX00w8ATossD2NRNGxhetf0eRE2wDOIBsYTAJl1XFhnjQ2j4brqIy0lG5lHp866txHqZdoqyO82KvO8lu/Y90zWWyMnBazsIGqVXUjqL2lU3gsQQbizWP9pjJuQdhq4Dez+QMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+0zFtSP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+0zFtSP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750671653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RVmNNR/2A8UUO46zI6tZfnHfGxmLMr5i7i5OIacu1uE=;
	b=E+0zFtSPELoMO3F05GWdrmAyeDfNoaABzsOeNzARB+Us0fXijPvebWah2uDi8sXPB8dFcA
	5vvH/IZHM+oV2ici72ebc40gpBW6UvDP0JuVMorX3oZk/3NSRHlOnh1f4PcXiR33zlyG7L
	ZkwRC1ZHgJQFArraSy30Z4YZPsou1B4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-76uELt-lO5-xhrZL6Y-aOQ-1; Mon,
 23 Jun 2025 05:40:47 -0400
X-MC-Unique: 76uELt-lO5-xhrZL6Y-aOQ-1
X-Mimecast-MFC-AGG-ID: 76uELt-lO5-xhrZL6Y-aOQ_1750671646
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25C461800368;
	Mon, 23 Jun 2025 09:40:46 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC85D1956096;
	Mon, 23 Jun 2025 09:40:43 +0000 (UTC)
Date: Mon, 23 Jun 2025 11:40:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
In-Reply-To: <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
Message-ID: <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com> <aFTe3kDZXCAzcwNq@gondor.apana.org.au> <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Fri, 20 Jun 2025, Milan Broz wrote:

> Hi,
> 
> On 6/20/25 6:09 AM, Herbert Xu wrote:
> > The output buffer size of of crypto_shash_export is returned by
> > crypto_shash_statesize.  Alternatively HASH_MAX_STATESIZE may be
> > used for stack buffers.
> > 
> > Fixes: 8cf4c341f193 ("crypto: md5-generic - Use API partial block handling")
> > Reported-by: Milan Broz <gmazyland@gmail.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Yes, that fixes the issue, thanks!
> 
> Tested-by: Milan Broz <gmazyland@gmail.com>
> 
> Mikulas, I think this should go through DM tree, could you send it for 6.16?
> The full patch is here
> https://lore.kernel.org/linux-crypto/aFTe3kDZXCAzcwNq@gondor.apana.org.au/T/#u
> 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 9dfdb63220d7..cb4617df7356 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -517,7 +517,10 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8
> > *iv,
> >   {
> >   	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
> >   	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
> > -	struct md5_state md5state;
> > +	union {
> > +		struct md5_state md5state;
> > +		u8 state[HASH_MAX_STATESIZE];
> > +	} u;

Hi

345 bytes on the stack - I think it's too much, given the fact that it 
already uses 345 bytes (from SHASH_DESC_ON_STACK) and it may be called in 
a tasklet context. I'd prefer a solution that allocates less bytes.

I don't see the beginning of this thread, so I'd like to ask what's the 
problem here, what algorithm other than md5 is used here that causes the 
buffer overflow?

Mikulas

