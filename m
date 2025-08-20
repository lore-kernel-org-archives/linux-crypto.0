Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC568285CBF
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 19:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755719317; cv=none; b=AKgck/EiSSJgjM5DCsPR04f1gvEpXY48VCJqxj8G6AyY0l5mGVYDqV3zL7iN04G8a7zEtHMgzyuEoQ9dYKQXtTMSvaIBIJdV/cF6FVFRSGnX+Q3h98lXa5ELrUrCJaMenBGU5OitZrZ6TlChcjd5LCpNvVMsne1LjIrf3GH1U64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755719317; c=relaxed/simple;
	bh=NfzpI+SMe9ZTxpeL+VOCRjfMcPKGvbbKwrbxQG+wWh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewJiUfnIM3MEvTN3t+ZGfh8t8h6DfndFcBDd2p5J66jYANGjyiZLTrALmOouLzQEADCMJ42EFQjx160xJWLAMu8ZBw6yXiPoGS6rYR86MziN1v+anzHRVbg35M9LvT5agxAkqRCwV8PG0+bQvJg//h55M1gb0v4dyNEgs5pzfuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bXBEpZxw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bXBEpZxw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755719313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oqta/QAQSbFTF1U9PBrhEbnw+rAYvkf7fG5BApOHix4=;
	b=bXBEpZxwjM5skWuzoNZJWGMzB19BfDSR2QVIBrgr6vLOnYLtl1eSyOXZYZTFxsyiht31Yo
	uMuEMONcTjXg9NRtOOIvkc2oDgAkskubpC+umw7d8xtDbjtol6ff/2WlONKMwnc627lpGJ
	1JQWYgKLeBfnMm0Re2GFYMAy9vT1A0Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-8jsqZYneM8inZW7HC5ma9A-1; Wed,
 20 Aug 2025 15:48:32 -0400
X-MC-Unique: 8jsqZYneM8inZW7HC5ma9A-1
X-Mimecast-MFC-AGG-ID: 8jsqZYneM8inZW7HC5ma9A_1755719310
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B5621954236;
	Wed, 20 Aug 2025 19:48:29 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00675180044F;
	Wed, 20 Aug 2025 19:48:25 +0000 (UTC)
Date: Wed, 20 Aug 2025 12:48:22 -0700
From: Chris Leech <cleech@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: hare@kernel.org, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: hkdf: add hkdf_expand_label()
Message-ID: <aKYmhusP6povB_TU@my-developer-toolbox-latest>
References: <20250820091211.25368-1-hare@kernel.org>
 <20250820091211.25368-2-hare@kernel.org>
 <20250820184633.GB1838@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820184633.GB1838@quark>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Aug 20, 2025 at 11:46:33AM -0700, Eric Biggers wrote:
> On Wed, Aug 20, 2025 at 11:12:10AM +0200, hare@kernel.org wrote:
> > From: Chris Leech <cleech@redhat.com>
> > 
> > Provide an implementation of RFC 8446 (TLS 1.3) HKDF-Expand-Label
> > 
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Chris Leech <cleech@redhat.com>
> > Signed-off-by: Hannes Reinecke <hare@kernel.org>
> > ---
> >  crypto/hkdf.c         | 55 +++++++++++++++++++++++++++++++++++++++++++
> >  include/crypto/hkdf.h |  4 ++++
> >  2 files changed, 59 insertions(+)
> > 
> > ...
>
> Does this belong in crypto/hkdf.c?  It seems to be specific to a
> particular user of HKDF.

While this is needed for NVMe/TLS, it's a case of the NVMe
specifications referencing a function defined in the TLS 1.3 RFC to be
used.  I though it would be clearest to fix the open-coded implemenation
by creating an RFC complient function, which is now no-longer specific
to NVMe so I moved it out to crypto/hkdf.c

I don't know that there will be other users, it just seemed to make the
most sense there.

- Chris

