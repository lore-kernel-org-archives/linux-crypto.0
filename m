Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75529292F
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051327; cv=none; b=sl3jguNfa4XeJgiXZUICRsebGGJSq12g3vSIsK7THR1TbSiLk/a7sczLuPbyWBoIREc5RNq9jzimMLLrsmkBh1/sbXQnbUAcj9i+BAVmK16DTy1k8naeM0gc/rjVzxLGur8ChuczbYp/uJSidxGHh+nA+yJ7WA3ekNW0819cHGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051327; c=relaxed/simple;
	bh=WJ35cHkcl7EwaoMV/F+cUNOLOdcVeGv+u7h1LoBBmTs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=b2Rnvu5NTpu5WId1spS+NJlyh7Tw6im08fI0Cu/2wlVuw96+f0lsT47fA2oc7BzBug4H52fKoLjQDI1W97xDe/GRIPAGI3+TxUGVNfWQlPHcU7OMI0lnt/nMjAC8p9D+qMk1bA2f7tuWhQI2QDBgelsWfzUwXF4vC+V3YU2dItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MlvM0Vud; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MlvM0Vud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747051324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfNE5qaxwrvkSBrE/hsQSGFkpUc8RFkw9LSWDlgzHno=;
	b=MlvM0VudwjzXJr+xUzqdGm2c0eNcaK4sbVc/ymTb12lVLIoptdN2qDXs68hTPTY0K6PnKh
	O9FGWusRdHtnRf8kvWFpXjremT+nDy73nFflJtEhjEv8mDHeUMAYWrCm4tUiovcKV9lr2/
	wGcQQdPL0fKWLmSIQ+CfnMaulzHyzdQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-NGlyw_0CPeCI5g_Z1cq5Pw-1; Mon,
 12 May 2025 08:02:01 -0400
X-MC-Unique: NGlyw_0CPeCI5g_Z1cq5Pw-1
X-Mimecast-MFC-AGG-ID: NGlyw_0CPeCI5g_Z1cq5Pw_1747051319
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A53EE19560AF;
	Mon, 12 May 2025 12:01:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.188])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 788FE19560AA;
	Mon, 12 May 2025 12:01:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aCHeoSBOLF-mcY7I@kernel.org>
References: <aCHeoSBOLF-mcY7I@kernel.org> <aB3OsMWScE2I9DhG@gondor.apana.org.au> <aBccz2nJs5Asg6cN@gondor.apana.org.au> <202505091721.245cbe78-lkp@intel.com> <1960113.1747041554@warthog.procyon.org.uk>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
    kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
    lkp@intel.com, keyrings@vger.kernel.org,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    "David S. Miller" <davem@davemloft.net>,
    Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    James Bottomley <James.Bottomley@hansenpartnership.com>,
    Mimi Zohar <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
    linux-security-module@vger.kernel.org
Subject: Re: [v3 PATCH] KEYS: Invert FINAL_PUT bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2020394.1747051310.1@warthog.procyon.org.uk>
Date: Mon, 12 May 2025 13:01:50 +0100
Message-ID: <2020395.1747051310@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> > Acked-by: David Howells <dhowells@redhat.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> David, are you going to pick this?

I can do unless Herbert wants to pass it through his tree?

David

