Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C9959B6F
	for <linux-crypto@vger.kernel.org>; Wed,  7 Feb 2024 12:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707310319; cv=none; b=WYSbfRx6qULgSZPxAO4tjR4X63HNB/oYPZ2OX9bGvxkCKfNnFet7FyztHFWLVX9mR/LGWEAbh8VsQD0ZNTid4KC1OoOAJ+FBtkPGoPWX9TNEnVVXDqqZ8ScfBA7194G6Bn8Dz39VgogYnuwbc24LSIzxLXjXcRoKLTjN7u+93sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707310319; c=relaxed/simple;
	bh=FNXI84mmzRVwDhPJEp3EvSeXVASjyT+spfWA2/rlLn0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WeD30zILOUbUHDgRjFOyplu7kTCgCPeT8nM/WYuaiQ+EGG736MbOrBCrUBYbQhmwdW+Z0PjUKkmCswZyKWlX4ll7IuPrlTUahqCBkY7BmwngG1nXfMhxa0Rf0/mLmaGBdzm4c+2GqL3q4tic7nFvlRcOb+GvZClmWFxoXNRSvPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aXQ4sQOG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aXQ4sQOG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707310316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k34FDeRLtzwVnv2etwwcbzwTkIKZsSi/l8+498T6LI=;
	b=aXQ4sQOGcAvbeOoRuRNa2yj5Ug9KIr5HQPhBWbrdu7FFwb51q20kHOzBvL8owgnzeu9oVj
	WO9jTolSbHEBljTLYLd0dTiytsAWH0j+My1t1m8m2TqRYCn0gauR/IZS+L/R/gVQbdoMlp
	Tz9uOoEfOSpmk9CbXejHbIMnkc9wf0A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-SlgGrPIWNGGtBVhFN0hqWg-1; Wed, 07 Feb 2024 07:51:52 -0500
X-MC-Unique: SlgGrPIWNGGtBVhFN0hqWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 691091064DA4;
	Wed,  7 Feb 2024 12:51:52 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DF73C1690E;
	Wed,  7 Feb 2024 12:51:52 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0030C30C1B8F; Wed,  7 Feb 2024 12:51:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id F15B13FFC5;
	Wed,  7 Feb 2024 13:51:51 +0100 (CET)
Date: Wed, 7 Feb 2024 13:51:51 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: Re: A question about modifying the buffer under authenticated
 encryption
In-Reply-To: <20240207004723.GA35324@sol.localdomain>
Message-ID: <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>
References: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com> <20240207004723.GA35324@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8



On Tue, 6 Feb 2024, Eric Biggers wrote:

> On Tue, Feb 06, 2024 at 10:46:59PM +0100, Mikulas Patocka wrote:
> > Hi
> > 
> > I'm trying to fix some problems in dm-crypt that it may report 
> > authentication failures when the user reads data with O_DIRECT and 
> > modifies the read buffer while it is being read.
> > 
> > I'd like to ask you:
> > 
> > 1. If the authenticated encryption encrypts a message, reading from 
> >    buffer1 and writing to buffer2 - and buffer1 changes while reading from 
> >    it - is it possible that it generates invalid authentication tag?
> > 
> > 2. If the authenticated encryption decrypts a message, reading from 
> >    buffer1 and writing to buffer2 - and buffer2 changes while writing to 
> >    it - is is possible that it reports authentication tag mismatch?
> > 
> 
> Yes, both scenarios are possible.  But it depends on the AEAD algorithm and how
> it happens to be implemented, and on whether the data overlaps or not.
> 
> This is very much a "don't do that" sort of thing.
> 
> - Eric

I see. So I will copy the data to a kernel buffer before encryption or 
decryption.

I assume that authenticated encryption or decryption using the same buffer 
as a source and as a destination should be ok. Right?

Mikulas

