Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5A2566
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 23:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757978281; cv=none; b=ZnortkzBJOAOBVeyGh5iXsw4vBJNuoell/pQAWuM+ZGGKe0uYmUdRd4//MacJkqu3zvQ0IYxkMfgwnTOdTEuUwu2x4WoYC3n2L+VidfnO4EuT8UrMAGtVgKIyCG8RuqW1A2gbfVCbEAcOczPPPZe97QecctzrDDyhRelPoBkGAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757978281; c=relaxed/simple;
	bh=6Rhz/8AjonCWCOCg1osGfGPwiUTHOLsG0/zRgrPDE50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5A+GxR2+w7zQ2PafxxQ/egeKsI5JIEvrA/zM8Cz+gfVb3H8Hy1TMtILXlf+ejhzN9b/SphNpMbzQwVscZDOuIRseHbLZ4Gl56j0sGFYMPEosJFujMtwYVxhir4JJwUd8xTrOB7AfaRzAWGbsr76sM/595bPy0E+9ckwKJLGm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnKdS+zu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnKdS+zu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757978278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=53Jjui4XqZ/IQp9ciZZrnrpWJSvGUpzV87U1Eh5hxPo=;
	b=QnKdS+zuFhWywSo/G3xmjjFvQdmq/+kMfXFdVTOUjy2hPfjAhHKc71IruoLkSOyQZ25qwy
	SPUt60hDdSu6rySW6jT6p9yf3XRgSHhWYXgCRdnWmaeQ8eaSP8nX6nScJEs7eBgu50eZT3
	TH1O87/xdHs5s4QgajGfT7n9OsTh1Jg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-mW8XYG5YOhSzFtg2P_wzzg-1; Mon,
 15 Sep 2025 19:17:55 -0400
X-MC-Unique: mW8XYG5YOhSzFtg2P_wzzg-1
X-Mimecast-MFC-AGG-ID: mW8XYG5YOhSzFtg2P_wzzg_1757978273
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5531A19775DB;
	Mon, 15 Sep 2025 23:17:53 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.100])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B675F180035E;
	Mon, 15 Sep 2025 23:17:50 +0000 (UTC)
Date: Mon, 15 Sep 2025 16:17:49 -0700
From: Chris Leech <cleech@redhat.com>
To: linux-nvme@lists.infradead.org, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/2] nvme: fixup HKDF-Expand-Label implementation
Message-ID: <20250915-expectant-limb-a1464f3a1076@redhat.com>
References: <20250821204816.2091293-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821204816.2091293-1-cleech@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Bump and a polite review/merge request.
There's been no feedback requiring changes in v2.

Thanks,
- Chris 

On Thu, Aug 21, 2025 at 01:48:14PM -0700, Chris Leech wrote:
> As per RFC 8446 (TLS 1.3) the HKDF-Expand-Label function is using vectors
> for the 'label' and 'context' field, but defines these vectors as a string
> prefixed with the string length (in binary). The implementation in nvme
> is missing the length prefix which was causing interoperability issues
> with spec-conformant implementations.
> 
> This patchset adds a function 'hkdf_expand_label()' to correctly implement
> the HKDF-Expand-Label functionality and modifies the nvme driver to utilize
> this function instead of the open-coded implementation.
> 
> As usual, comments and reviews are welcome.
> 
> Changes from v1:
>  - Moved hkdf_expand_label() from crypto/hkdf.c to nvme/common/auth.c.
>    It's not really an RFC 5869 HKDF function, it's defined for TLS but
>    currently only used by nvme in-kernel.
>  - Fixed kdoc label_len -> labellen
>  - Replaced "static const char []" with "const char *", it's just
>    clearer and generates the same code with a string literal assignment.
> 
> (I've left the crypto emails on this version, mostly to make it known
> that hkdf_expand_label() has been moved as Eric asked.)
> 
> Chris Leech (2):
>   nvme-auth: add hkdf_expand_label()
>   nvme-auth: use hkdf_expand_label()
> 
>  drivers/nvme/common/auth.c | 86 +++++++++++++++++++++++++++++---------
>  1 file changed, 66 insertions(+), 20 deletions(-)
> 
> -- 
> 2.50.1
> 
> 

