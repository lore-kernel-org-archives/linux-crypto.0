Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA37E2040A8
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 06:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268062; cv=none; b=ZVUgcOrRnTObxTUFP9G9Du8WzeZPlqsLAdgRhK5QNn6wmO8JPBIOU3S1QMoyH5RkNcA4kkRnHF2m5w1PSdR9Fcwe77Y04Bsc5mpjAi8RSMEg7YMVn5DZIIO178DzWiV1iGXZgfnaMFekq7OGm3mELu5peuqZB4iLICa5HHzvJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268062; c=relaxed/simple;
	bh=TxrLqC9nYF89a5TnZLBY5qvjm88ALGL/VzZaEHaJi3k=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=G00pod1vdLSPMeJEJdxPvnZuTscbBF3kEuOL66BWpo8+VgHmV9q+oYHmfdsYizzzRWTtMMPUdEIidrQsvKubZGqHDwEp8BsQ2nEzwchj0Ki8802VCKynGAi83+e/nOfel0I0rE3p//bRXGYAO6Y2CEvAehX9wLPOLLtmR0RGYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7hxTsIX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7hxTsIX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744268059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BSsly/zurt18wlsSnRCbFAkcKV3HWi5lt2feE8wbC4=;
	b=H7hxTsIXZdzqHday74V8reApYpj2JyQfnflV3UvWmZ6JbOOtZbgbqQfw7XlFdW5LZlrmmo
	vFpkOoQsjfRP4CCXg9A4miLGkTVq6BfJ8P9Ar8TL1ubG5Zl+7mqwIoBOk7pNgHw98p/lns
	iAtEGna3u6OeC4bY0VdEA3Y4TTDfCac=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-88WP7-plNJCCe5GNVi4wAg-1; Thu,
 10 Apr 2025 02:54:16 -0400
X-MC-Unique: 88WP7-plNJCCe5GNVi4wAg-1
X-Mimecast-MFC-AGG-ID: 88WP7-plNJCCe5GNVi4wAg_1744268054
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07AEB1801A12;
	Thu, 10 Apr 2025 06:54:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF1C719560AD;
	Thu, 10 Apr 2025 06:54:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250409190335.3858426f@kernel.org>
References: <20250409190335.3858426f@kernel.org> <20250407161130.1349147-1-dhowells@redhat.com> <20250407161130.1349147-7-dhowells@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Marc Dionne <marc.dionne@auristor.com>,
    "David S.
 Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Simon Horman <horms@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, linux-afs@lists.infradead.org,
    linux-kernel@vger.kernel.org,
    Herbert Xu <herbert@gondor.apana.org.au>,
    linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/13] rxrpc: rxgk: Provide infrastructure and key derivation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2099211.1744268049.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Apr 2025 07:54:09 +0100
Message-ID: <2099212.1744268049@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon,  7 Apr 2025 17:11:19 +0100 David Howells wrote:
> > +	aead =3D crypto_krb5_prepare_encryption(krb5, &TK, RXGK_CLIENT_ENC_R=
ESPONSE, gfp);
> > +	if (IS_ERR(aead))
> > +		goto aead_error;
> > +	gk->resp_enc =3D aead;
> > +
> > +	if (crypto_aead_blocksize(gk->resp_enc) !=3D krb5->block_len ||
> > +	    crypto_aead_authsize(gk->resp_enc) !=3D krb5->cksum_len) {
> > +		pr_notice("algo inconsistent with krb5 table %u!=3D%u or %u!=3D%u\n=
",
> > +			  crypto_aead_blocksize(gk->resp_enc), krb5->block_len,
> > +			  crypto_aead_authsize(gk->resp_enc), krb5->cksum_len);
> > +		return -EINVAL;
> =

> kfree_sensitive(buffer); missing?

Good catch, thanks.  That path should never trigger, but it should really =
do
"ret =3D -EINVAL; goto out;".

Do you want me to respin the patches or follow up with a fix patch?

David

