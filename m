Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550E2DCC03
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103173; cv=none; b=BE6m+G0LfEPjZq1ee4AESxYPyAks913d9fEfijuZhLwEp8HXb1dKo/ub6GEVvCyywwEssPHBzF46meFys2GIeJ88tuYv/NE1vqUUaV25blAnBJlJHtLaSZB2c0Jc6IdbMyGaom17wGI7WOwIoIdjalzK47NoG92UTMyoHa6agwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103173; c=relaxed/simple;
	bh=bv1GTzC0binZfIuVJw+35brnRcgtGi+X4MGG9PzSdmM=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=E2IoW1KUc6WL1SoH6QoVJMuer7SdreEq1IzKQ8VN6Jt9yewjvl+bCmne2CKeqi9Q+DACh9p7VeuTzXge95DXdK0WAiYxVMddw/K/nB9U2j1+vk7XA4glYz2yvZKPhz3zgORqFOxQcaAAI5bt4BfZ04rgL5Ap8RNIduooLjrUGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=drQiIaWk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="drQiIaWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764103170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rj3NcZeytoneTgILifDikTjkEll99y7o3jD3RR/sEwk=;
	b=drQiIaWko4pGLgFSN2rlw55+jTVo0dn7PLPHh94iGNrWl8G7JvGunQij5wNleVLmZ4YO2O
	8OtdPH63AbA8f24Ct+I+Bddfpv2s+EN8Oc/GdMNUlCulgWkX0J70yNseRe/ptVBGXOh3xX
	23+DuUE3VHKco39j5Vxy3cQBB6Bwreo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-ExMiZ5BkP8-wKgTCby1XEg-1; Tue,
 25 Nov 2025 15:39:27 -0500
X-MC-Unique: ExMiZ5BkP8-wKgTCby1XEg-1
X-Mimecast-MFC-AGG-ID: ExMiZ5BkP8-wKgTCby1XEg_1764103166
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B18121956080;
	Tue, 25 Nov 2025 20:39:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A936C1800451;
	Tue, 25 Nov 2025 20:39:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251125190256.4034-2-James.Bottomley@HansenPartnership.com>
References: <20251125190256.4034-2-James.Bottomley@HansenPartnership.com> <20251125190256.4034-1-James.Bottomley@HansenPartnership.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH 1/2] crypto: pkcs7: add ability to extract signed attributes by OID
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3954523.1764103163.1@warthog.procyon.org.uk>
Date: Tue, 25 Nov 2025 20:39:23 +0000
Message-ID: <3954524.1764103163@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> +/**
> + * pkcs7_get_authattr - get authenticated attribute by OID
> + *
> + * @pkcs7: The preparsed PKCS#7 message

There shouldn't be a gap between those.

> +		/*
> +		 * Note: authattrs is missing the initial tag for
> +		 * digesting reasons.  Step one back in the stream to
> +		 * point to the initial tag for fully formed ASN.1
> +		 */

That will probably have to change to support ML-DSA.

David

