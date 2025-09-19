Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEBB2750E3
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 06:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758262677; cv=none; b=jfxkRSxQrAms4fAaZVazrNDlfQcSh8AZnZripGWqM9AnhtEn8hDwy4j5TRWpUwC/cKxW92AMVUgc4beMt9MbS/b0EXf2wQ5NGxSiLh+PZqXgbuZWurm6CrsrD+BxYPECbrBLbLSwdSG/dzowFM4PkxIX9MbwbYt6ts3ThPvQ8GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758262677; c=relaxed/simple;
	bh=Zu3k/K3mWSrVWZWf/1c9DXzQdLKRbQiCTLWy7TplHVw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=f1r8s5xfAE1NTByrY+4kvVuxD9DVWEl9f2gxKTuaGZ2q76KXpc0uSazS0E9VfQLb/Dj/YGeB3BQV34WA2rCSlhncGRlIxTIRM3o8po21SPQlhuR0on5uArn+KiDKS6McABeAZjVp9HmYiERl+cMthWXvU1Yk1o+1xcDSrd6vxCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3Y2XFIp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3Y2XFIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758262673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zu3k/K3mWSrVWZWf/1c9DXzQdLKRbQiCTLWy7TplHVw=;
	b=B3Y2XFIp3o7++Hlh0NCISQ6D9yb4ifa7ZA27SjYasDtBWs85D2i/gL+86pZOPZJy5pm0T0
	Fof2saffyvWTeDjj8xaB9e2VRvwC9XxPwgH6TjTiGaLuEWm6JrUUO3gFKgQ8kKjHZgIIJQ
	PaPR+4CvVNxfGa8f87zf2mZ+cHV/jlE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-rHSEGkCBM5yVyzsuygZzuw-1; Fri,
 19 Sep 2025 02:17:52 -0400
X-MC-Unique: rHSEGkCBM5yVyzsuygZzuw-1
X-Mimecast-MFC-AGG-ID: rHSEGkCBM5yVyzsuygZzuw_1758262671
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93666180028C;
	Fri, 19 Sep 2025 06:17:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1E7E1955F2D;
	Fri, 19 Sep 2025 06:17:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2952535.lGaqSPkdTl@graviton.chronox.de>
References: <2952535.lGaqSPkdTl@graviton.chronox.de> <3605112.1758233248@warthog.procyon.org.uk>
To: Stephan =?us-ascii?Q?=3D=3FUTF-8=3FB=3FTcO8bGxlcg=3D=3D=3F=3D?= <smueller@chronox.de>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    "Jason A. Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA-512, SHAKE128, SHAKE256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Sep 2025 07:17:46 +0100
Message-ID: <3788819.1758262666@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Stephan M=C3=BCller <smueller@chronox.de> wrote:

> For a multi-stage squeeze, it is perhaps not helpful to zeroize the conte=
xt=20
> here.

Yeah - I've seen this now that I'm starting to trawl through your dilithium
code, so it will need adjusting.

David

