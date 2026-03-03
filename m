Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704224DCE2
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 01:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772500308; cv=none; b=L5TxOGQ/LEu6PyRw9d9cXFrIgT+8EB2UMNmLgFNeWT/lTMGqFoc1LI/oCa/X1DdGlT6kpuMC/WOZ3r+nxHG83BvvflHECn9VOsO2OHZhXLlKo/7aN5DQTFghwo49gIKctfKWoT5Fw1raDwj/GUK9i55QxHouWvIYrshitN6VMns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772500308; c=relaxed/simple;
	bh=nmt3xUmLwtwFBahp7Xl3AWHNqyNFhTleMGAVi6WPmXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVe+lqOkLgx1nLE2cJ6tPX42CjytWUAPMDRSJbIy2P/Qo9SdYADgy0YnIWjkml5k6coL14TzYGegwoTbGiAf2mHy86NFHaOQRsPYhX6TK0alxbiAy7G6kExyOrb6V2HMGMULDPdW2L/4OpOc3HQC2vLPcbDIRdCdPX+kV7mqU2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNbv/ETA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNbv/ETA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772500306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ah5DDGh7BfQs6F/18En8GMWxi7ztoLX4jw5ciTni7N8=;
	b=jNbv/ETASGivZtmYxehsRfO/C7V1zB1gZXyyE++LnB/YGTKbeW8Hm2fPGtQA+Pkl2BE0ak
	vdNdeTvfzIwAs2ZHZ7npXwGqZhJSgtnFlQabv45lAYi3FdmsiJSbC1Ws1qHKY5nCCWHsNo
	9gqPXl0Qti4YwUWhrrXkFTqLBIga/XM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-42YCB_dJMnaSCfW2gt0wCw-1; Mon,
 02 Mar 2026 20:11:43 -0500
X-MC-Unique: 42YCB_dJMnaSCfW2gt0wCw-1
X-Mimecast-MFC-AGG-ID: 42YCB_dJMnaSCfW2gt0wCw_1772500301
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E410195608D;
	Tue,  3 Mar 2026 01:11:40 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.250])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 14B6719560A2;
	Tue,  3 Mar 2026 01:11:36 +0000 (UTC)
Date: Mon, 2 Mar 2026 17:11:36 -0800
From: Chris Leech <cleech@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, 
	Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/21] nvme-auth: common: add KUnit tests for TLS key
 derivation
Message-ID: <20260302-crewless-multiple-5bd14f68a73a@redhat.com>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-5-ebiggers@kernel.org>
 <1de7ef59-4236-4372-81f6-60d5a4f1e253@suse.de>
 <20260303002649.GE20209@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303002649.GE20209@quark>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Eric, I'm reviewing your patches but just wanted to say thank you for
the details on this comment and respond to them quickly.

On Mon, Mar 02, 2026 at 04:26:49PM -0800, Eric Biggers wrote:
> On Mon, Mar 02, 2026 at 11:04:43AM +0100, Hannes Reinecke wrote:
> > Which discrepancies do you see between the specified algorithm
> > and the implementation?
> 
> I'm looking at the latest NVM Express Base Specification, v2.3.
> 
> First, there's the following:
> 
>     The host computes KS as the hash of the ephemeral DH key resulting
>     from the combination of the random value y selected by the host with
>     the DH exponential (i.e., gx mod p) received from the controller
>     (i.e., KS = H((gx mod p)y mod p) = H(gxy mod p)).
> 
> The actual code skips that step when deriving the PSK, and just
> considers the DH value directly to be "KS" and uses it directly as an
> HMAC key.  That is something that should never be done.  DH values are
> not uniformly distributed and must not be used directly as keys.

We might have an issue with the secure concatantion generated PSK here,
and a shortage of independant implementations to catch this in testing.
I'll take a closer look at it, but at a glance I think I agree.

> Second, the only mention of HKDF is in section 8.3.5.6.2.  Assuming that
> corresponds to what was attempted to be implemented in
> nvme_auth_derive_tls_psk(), it does not match because (at least) the
> specified label does not match the one used in the code.

The AVE stuff in NVMe 8.3.5.6 is _not_ what nvme_auth_derive_tls_psk() is
doing. Most of the TLS handling is specific to TCP as a fabric
transport, and is in the seperate "NVM Express NVMe over TCP Transport
Specification".  In this case, section 3.6.1.3 "TLS PSK and PSK Identity
Derivation".

I'm fairly certain that's sorted now, after some confusion caused by the NVMe
specs calling for HKDF-Expand-Label vs. HKDF-Expand.

- Chris

> Those are just a couple things I noticed in a very quick glance.
> 
> (There's also the key reuse bug I pointed out before.  But it sounds
> like that's a bug in the spec, not the code.)
> 
> - Eric
> 

