Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB06224AF3
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764079341; cv=none; b=Ld/BD4I6RzvelOclWtsKVjyspD47Saw6E0CtemMB4TzagNyNt5sUOVSzHcc8IGO/ApMQW9S1E/qWk7E2OT0abZ32IjHXnc5C4rbPr1gDylgQUrRymI+L+S50rfHeBQttbOXbb+6BAPr5fstj0WUOi4dNulr+WdFd9ZNE9RhXsYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764079341; c=relaxed/simple;
	bh=zwhHwXxKb3Jx2uVwwBc7lJM/sqh709x3dgqxwCTMV68=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cRURNk2GysA7xDbQsXfm8RC3qiZiNmTrrp0cZQxX1ncLWWsIVj4TDzLp+lIpXxuF1dwZKUsu458mXlmdUWsA0yz6Tuffe8mkGVgsXJ5m2hNE36BMbfDPb3R2iCkhA3AblrFFQ5foVojYk8Z+W97aeE7BQm+Uy0akllCyQZITZiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SDJHAYiP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SDJHAYiP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764079338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+mv38gPh6SkK1RX7Cr0xMUdyu6xke7mx9I24tHoVHJs=;
	b=SDJHAYiP39VIcqsuGRtyWh2v5TMsCAEGKGZVaaZXEqZ0C5HcvRiFxYMScn4RI31BHNZ+Nr
	dDgOJo+dloCDdDAQlO/WRoWAM9vbF2ze079U1P0CJfH9nuOzSk7V1M+095lvwT8QIvBMfM
	+2ytN/rqmp5t0D+yc9KONvJ0Rczf5ZQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-Sx0YysXnM0-GSYKMDQsXiQ-1; Tue,
 25 Nov 2025 09:02:15 -0500
X-MC-Unique: Sx0YysXnM0-GSYKMDQsXiQ-1
X-Mimecast-MFC-AGG-ID: Sx0YysXnM0-GSYKMDQsXiQ_1764079333
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0E061955F3C;
	Tue, 25 Nov 2025 14:02:12 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3708230044E8;
	Tue, 25 Nov 2025 14:02:08 +0000 (UTC)
Date: Tue, 25 Nov 2025 15:02:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>, 
    Harald Freudenberger <freude@linux.ibm.com>, 
    Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com, 
    snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>, guazhang@redhat.com
Subject: Re: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the
 hash request
In-Reply-To: <aNK6IMzUgslPVi3x@gondor.apana.org.au>
Message-ID: <7c1b844a-443e-9fd3-3aa9-0dacbc381812@redhat.com>
References: <20250908131642.385445532@debian4.vm> <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com> <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com> <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com> <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com> <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com> <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com> <aNIYTm6neC3lC6dP@gondor.apana.org.au> <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
 <aNK6IMzUgslPVi3x@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Tue, 23 Sep 2025, Herbert Xu wrote:

> On Tue, Sep 23, 2025 at 01:14:10PM +0200, Mikulas Patocka wrote:
> >
> > static void authenc_request_complete(struct aead_request *req, int err)
> > {
> >         if (err != -EINPROGRESS)
> >                 aead_request_complete(req, err);
> > }
> 
> Oh OK.  That was kind of a hack which worked because authenc was
> used by IPsec only, so it didn't expect to be called with MAY_BACKLOG.
> 
> Now that you're calling it with MAY_BACKLOG, we need to fix it to
> distinguish between an EINPROGRESS notification for EBUSY and one
> that's returned directly by an async function.
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Hi Herbert

What's the status of this bugfix? I searched the git history, but didn't 
find it.

We have hit another deadlock in dm-crypt when using the "tegra-se" driver 
(the driver returned -EBUSY, but didn't call the completion routine with 
-EINPROGRESS), and I suspect that it may be this problem again.

Mikulas

