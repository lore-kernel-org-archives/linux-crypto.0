Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B85D38F233
	for <linux-crypto@vger.kernel.org>; Mon,  6 Apr 2026 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775500037; cv=none; b=YSytClVZcyFPbXeZmqG3JpANloox6imCVbUX5eIbb4rT6jICgTxnwhk4UUUaZ2+srbem6FRBglgLTY851haE9SUFCeJcebGb+0J2Cu8jNEVazdmQEv4VoapACvngMKuNfqzyyK13bCnMW9GIFh1mxGPaE0eW5DCUZcsRHrpR5MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775500037; c=relaxed/simple;
	bh=YK9cQT0xbTU4952/hJ7dWAtop7t6P75xk2v5RgykzB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KR5zvZHiSYBxC7h48JnbjgPAD9apu1Ht96r+a9KpBWDBbiqR4IeXYD1zQeda3z7Av8ttyl9nBfNFhrwWx+Ez9q45gFpOr8q8b4h7xmWelqPRxCVUvFbefSz/o7JEoVY/EPkVZvQCob4yYkKMkoHFac5eSRxPQGNLnzAm3NwOaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7dVOJJF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7dVOJJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775500035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7BsInlarCMN8zA1RQxRw+Ig9z8XXGHcBKSW9n2S1Is=;
	b=E7dVOJJFmr2jpq31aLnc+LKwWS9LOKx2DtgnudNb4DkLxFNW3OBO0v3Udv3iuWjkVqobo4
	rBZ1bXiphBHPr7QQ2Pi7Liw9alUwyIUATjsM0trf1qF61Szrpv+vXU1MQL6rMBt9HU6Gwd
	w2iXF7IBaIP9Xl38YzCAuk6R6Tfkkg0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-r8TzPp-HNKKLa3gfD47CAA-1; Mon,
 06 Apr 2026 14:27:12 -0400
X-MC-Unique: r8TzPp-HNKKLa3gfD47CAA-1
X-Mimecast-MFC-AGG-ID: r8TzPp-HNKKLa3gfD47CAA_1775500030
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AA4618002E5;
	Mon,  6 Apr 2026 18:27:10 +0000 (UTC)
Received: from cleech-thinkpadt14sgen2i.rmtusor.csb (unknown [10.2.16.34])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5B5F7300019F;
	Mon,  6 Apr 2026 18:27:08 +0000 (UTC)
Date: Mon, 6 Apr 2026 11:27:07 -0700
From: Chris Leech <cleech@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ryan Appel <ryan.appel.333@gmail.com>, linux-crypto@vger.kernel.org, 
	wireguard@lists.zx2c4.com, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Kernel ML-KEM implementation plans
Message-ID: <20260406-e1d94afb79556186f06749f4@redhat.com>
References: <5F9ACD7A-F3B8-463A-A00E-28F68819A66C@gmail.com>
 <20260331001358.GA5190@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331001358.GA5190@sol>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Mar 30, 2026 at 05:13:58PM -0700, Eric Biggers wrote:
> On Mon, Mar 30, 2026 at 06:41:46PM -0500, Ryan Appel wrote:
> > Hello all, 
> > 
> > Looking through the mail archives I see no information on an
> > implementation of ML-KEM that has been planned, except for leancrypto
> > attempting to make a Key-Agreement Scheme a Key-Encapsulation
> > Mechanism.
> > 
> > Is there a plan to implement a KEM interface at this point? Is this
> > something that needs support?  How could someone contribute to this?
> 
> We don't add new algorithms preemptively, but rather only when an
> in-kernel user comes along.  Otherwise there's a risk that the code will
> never be used.
> 
> Do you have a specific in-kernel user in mind?  I haven't actually heard
> anyone specifically say they need ML-KEM in the kernel yet.
> 
> I guess the obvious use case would be WireGuard.  But that would require
> a new WireGuard protocol version that replaces X25519 with something
> like X25519MLKEM768.  It's going to be up to the WireGuard author
> (Jason) to decide whether that's in the roadmap for WireGuard.
> 
> Also maybe Bluetooth, though it seems the spec for that is yet to be
> defined?
> 
> Anyway, point is, before it makes sense to consider possible
> implementation strategies, there needs to be a plan to actually use it.

The NVMe fabrics authentication protocol will need a PQC replacement for
it's FFDHE use. There is not a specification update for that yet.

- Chris

