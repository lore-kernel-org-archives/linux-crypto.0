Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6886299A8F
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015544; cv=none; b=GdtUM3yMSi6Gm4NFxQxbjrrl3v0uQLeedjwHCtBIfcZVwW8hAwoo0V2ayopIgU13tjwLsjxJDGCe1YqWeZdaplmqSEZzC/2brBTHP/94E/KsvkPtJ9sOFbASKJ9E9fOav5WVDk1VIAYbQsxLFp6c0QscsXo6wWRR7+nHv0yvG8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015544; c=relaxed/simple;
	bh=R0uwPGa83ZpYae4xZ0SduB8kHlb7ZBIMwhpgMLRydbQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XdaCMLOr2nwTqkzLhczU5LjxuwNaBXA5EuB/Y0x3pB7uOe8b9i/MWD8MijD1sKt+gMV6wSqGJeNsVj7ZMrZ/lNByZnLy3/4gLwMNNRLK4HLbtCGHAgKkyTJu/b1fZ0X2NKSjPGPPQTm5cJrL5kVYZ7dIHIyHj/Tb39ZMRxyvyf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RubCNoVL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RubCNoVL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758015541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rSStT8Zp3K/EWMu0sfVLJU+MTJRncyCaOgk0YFgesc0=;
	b=RubCNoVLIMntzhOB9mydK1/aV5PJch49x7VcPau7Fif2VsHu2MDzgjvEXPHnmqJ2APB1wm
	tfsFdBzNDxe47dSuv1ob3jxUv6tOSHT7u/bVHuBkGMCCeN4pkZdRl6vUWbaB5MOxvrk+Dm
	PuwVAKt8h0TaAPFrBRJ/7Ait9vChRWo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-VeM79TzgOTKN1sR3s7qG_g-1; Tue,
 16 Sep 2025 05:38:59 -0400
X-MC-Unique: VeM79TzgOTKN1sR3s7qG_g-1
X-Mimecast-MFC-AGG-ID: VeM79TzgOTKN1sR3s7qG_g_1758015538
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89BED1800577;
	Tue, 16 Sep 2025 09:38:58 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D5E81800447;
	Tue, 16 Sep 2025 09:38:57 +0000 (UTC)
Date: Tue, 16 Sep 2025 11:38:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [v2 PATCH 1/2] crypto: ahash - Allow async stack requests when
 specified
In-Reply-To: <aMjgt0tHK2JZD1B9@gondor.apana.org.au>
Message-ID: <c6255881-b075-1621-4268-ff126ad89576@redhat.com>
References: <cover.1757396389.git.herbert@gondor.apana.org.au> <9d6b10c1405137ab1d09471897536f830649364f.1757396389.git.herbert@gondor.apana.org.au> <f1b90764-b2f4-ff90-f4c4-a3ddc04a15f6@redhat.com> <aMjgt0tHK2JZD1B9@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 16 Sep 2025, Herbert Xu wrote:

> On Mon, Sep 15, 2025 at 05:06:51PM +0200, Mikulas Patocka wrote:
> > 
> > Would it be possible to export the function crypto_ahash_stack_req_ok, so 
> > that I could know up-front whether having a request on the stack will 
> > succeed or not?
> > 
> > Perhaps the function crypto_ahash_stack_req_ok could take "struct 
> > crypto_ahash *" argument rather than "struct ahash_request, *" so that I 
> > would know in advance whether it makes sense to try to build the request 
> > on the stack or not.
> 
> I think the pain point is the use of SG lists.  If we could convert
> them to something like iov's then you should be able to supply stack
> memory unconditionally.
> 
> Cheers,

On architectures without automatic DMA/cache coherency, you must make sure 
that you do not write to a cacheline simultaneously using DMA and CPU. 
This would be hard to guarantee if the crypto request is on the stack 
because it may share a cacheline with many other local variables.

Mikulas

