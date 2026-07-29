Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49774DBD88
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785343812; cv=none; b=Q27w3Ibbf+DK7zB/Th1ebc9sDDK20QHSIy3ehRC/Oc9V5kkYM79EHcXD0NJ4tVzOs4Rwm+Lp/B6/J+FXaito5B/2xiE1JpoIOT6n9ZeZSJ1SBGcG5xv8BiKpHNW4Ebv9a785cFo5EXm0rjTFh1oSR5gndiUB8RkahGMHptzeQOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785343812; c=relaxed/simple;
	bh=hV6UUuqpGd/+pqKjXR4lzBHm51Lzzq+CNVy4hpaMCec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fxcoLs21/C887bzbvzl4JIn3htJ/dBDASW2tJIDCra1d8tmBjn+4V+Uco8yRNX96xug52AeM50iWSmt0YJjCUQYFYlxacsLcJHc1cbngvnGRxFILpAhHQWU/5DKtotCSo7Udgjug+at4U2xWy+OYMi0aQC/yBVxGPssg5QLS/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GtThJPm7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nzMJsgR2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtThJPm7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nzMJsgR2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785343809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hV6UUuqpGd/+pqKjXR4lzBHm51Lzzq+CNVy4hpaMCec=;
	b=GtThJPm7jAxkS8rwYXRNANxXGg6km9t+ic8CDkbovXWaSUSHgDcgz4izJHfRp9EoBFyn+4
	x8funFCv7zC1sydyfi9MejgfQ2QV0mVsh9BFGdgfgdQzUPSkhmdiMmEXMPjWjHLkRZxmWS
	G20+fIPMrypcVS4j8tYkK80B/nqstdU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-K-W1mVnUMiy2B-6ESFm4Ww-1; Wed, 29 Jul 2026 12:50:08 -0400
X-MC-Unique: K-W1mVnUMiy2B-6ESFm4Ww-1
X-Mimecast-MFC-AGG-ID: K-W1mVnUMiy2B-6ESFm4Ww_1785343808
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8efad04d884so21466416d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785343808; x=1785948608; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :organization:references:in-reply-to:date:cc:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hV6UUuqpGd/+pqKjXR4lzBHm51Lzzq+CNVy4hpaMCec=;
        b=nzMJsgR2FQm2Jy3me+CrwgPgc1441GwiJTRDZeqKfIXnflEUyR4hTM4LPrAJIbvRRl
         TqKafjaVCdvcJIhPNGrtooTdMLqvc37hGIvD/IOflKxnQsuDBERLlLDywBZy+kPEffKY
         aVsbjxenodGlJz8LXbQaxfmO6R5DLl+uP8LprjIVl6+3q26xZMGpgd/i732jkhMqYor0
         cDnBhBaC5wE2/UFRt8RERy2mkUSkj+wr4Q6v1FG5FIONZ4MOqonwuSujkcH9q5iljNKu
         hSgYATLohdGh9o3CHk9TkGdVkM9CXd2niCRgjlE+jN1pzfYqxIAcNkcDEgJ2v72ReyVJ
         /gRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785343808; x=1785948608;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :organization:references:in-reply-to:date:cc:to:from:subject
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hV6UUuqpGd/+pqKjXR4lzBHm51Lzzq+CNVy4hpaMCec=;
        b=Ac4GUa12FALZ1FjXzOYnY+AL87lK6djLQNK0G3d/FZrmxv/a2BY1EpAQyHVUpckFbd
         myb674vA31JeTqu3UqWJZfrToNtcvGSe8B6Ba5TLr1onzY8GiGytntOEBFWdLV8JmLpp
         z0upzf2L/Bp21Kbvl7Jh0pK9l0Rm+Rf2kFTgeKN8PoEUVHx5Du6q4F3tnNW9FqSpdfUD
         f+cItnB2MLbTw1NPrZ2vL9OnRwFwFbeEYWXcQ7hYZy81OWqCYhM5wmHMtGEmDh9afCdk
         RkPeyzxkXVw8+Mll+mhDlIQ0LhL8WYVvjuDCCuqujP0Qekclv97QvMsDsOSwZLL2gFeF
         d4bg==
X-Gm-Message-State: AOJu0Yxrt0Yi3IaM2N9nWITkeUzHt8TLYlXPjSrdRWla1Il4mM2eKGM5
	tkQYanB+O2suFLrKovm6zFfGDu56cJ46BEHQU/dDHU4k0/Z+gk/Oq6ryXlagJq1CnUOgteVpRx9
	OkJcoDFs7s7eH8QSxCWzg2xNJQLKrwLDzagHIWwhTbfCPpSDaX2vavvemOb8GCRaiOlUEFMawRw
	==
X-Gm-Gg: AR+sD13a611N/+7P/qFSYAiSQ5tifM9tYz7xo/5A3YyqercwGUm8U2vcFQ+bC1E2EeN
	C8LAksGh4iNCtNQm0UNJJEmuAVDhPdQwSFf9j6Dkbx1ovvtPAGnsbqLvSb9KsPzwBgmsew1MT4h
	jnPlCYlNNIdL6HsL5A2GJktBekJ+L0BdpHvzd8DHXOh7MoOr6AUFLkiEqzKrjeB7mGfQJi+pL5E
	s/oXDdrwMzCkTAe8FnaocvnEi/pid13aFz88h3ttT5aAsfN/tTiDwSb4dX1A5Q8lpdKxKOHQ6xr
	rYkEruIKH8nyz1swE0xjA2/1DTn4PEmDILeqCQQue5XcCYGzbM4tmxDvuwJggAk+lcVtzHU=
X-Received: by 2002:ad4:5c8d:0:b0:907:c0e1:62e4 with SMTP id 6a1803df08f44-908170b6082mr82473606d6.9.1785343807545;
        Wed, 29 Jul 2026 09:50:07 -0700 (PDT)
X-Received: by 2002:ad4:5c8d:0:b0:907:c0e1:62e4 with SMTP id 6a1803df08f44-908170b6082mr82472966d6.9.1785343806932;
        Wed, 29 Jul 2026 09:50:06 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::7a7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc6c862sm28525306d6.14.2026.07.29.09.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 09:50:06 -0700 (PDT)
Message-ID: <c578abd86fc8dbe739af738b787ac67bb23a12fe.camel@redhat.com>
Subject: Re: [PATCH] crypto: ecc - Add NIST P224 curve parameters
From: Simo Sorce <simo@redhat.com>
To: Paul Louvel <paul.louvel@bootlin.com>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin
	 <ignat@linux.win>, Stefan Berger <stefanb@linux.ibm.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas
 Petazzoni <thomas.petazzoni@bootlin.com>
Date: Wed, 29 Jul 2026 12:50:05 -0400
In-Reply-To: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
References: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-29 at 17:51 +0200, Paul Louvel wrote:
> Add the parameters for the NIST P224 curve and define a new curve ID for
> it. Make the curve available in ecc_get_curve().

P224 is very weak and generally a bad idea to start using such keys
now, why is this needed?

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

