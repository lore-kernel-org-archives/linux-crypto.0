Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792466519;
	b=Dhzn+UQMddmvrXnSJiLEsBQnaMWevx/0SGbsVv8rqFAtBQdQc1wwbZMg5jUB7hA4y2Je
	 tGF4731sG9Y/SKPH3buqo79pI9XwRB9wLa6jLQ72cxKCXBBd3mavrZ/Uto5KU0STtHTI7
	 91HpFYzWmUOh5Ze+MeYEY2zwg0jWoR9UKx60bwy56u0CuoyYFYgIH4desG1sNUJSbIeTB
	 kHUOLoZMBHGZ9y3Bk93JIQqdsCF0kWSctQ4pxEwCqew9R5+JI5qqLwuaw0u1Lptjv0soa
	 41htkvI4j130tUr3ndfSwxKe0WCZXwcPbTidA//a2lIg7T/iBTDwge/n+PVr2ahO4wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792466519;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gnzh+m64uMxXKaq6t/vdpcSaRLdFTK11HDMv+R6rWJw=;
	b=4+S5YfbRKIPv70vPM8Xbj3gQqX9AQ1f6LOwRlDXrWG8veUvNW3LYV680zNni9EBGfFiW
	 1G6RvkgXIH+vypcXn7Q6ZGsIrHdLqi3AxTib8e8DdlkKpkwXQuAz3VaiIQ5Z8tbX9EGDe
	 tjrRdt9vXVwJe32qm6wO6T31+f2Hpq2chSH+77mDT2CNuDw5M9Vnv1t2WciOJ0wrbVVA9
	 wNvLvXJBd7ryKhEVTCyic04JqeVwPLQxFGJrfHz8wxSX504RQ9+r3UyX+IXl2Kqex9H+k
	 /nuU5NKQUn+8TgQyAAMO6acBgMmQ4jr16ER7SabxqCOLUN9mR6isDfQb28HKt3L4Z7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=kDc6S37x;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08408606A319
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 03:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08408606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=kDc6S37x
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1934A3F781
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 03:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792466516;
	bh=gnzh+m64uMxXKaq6t/vdpcSaRLdFTK11HDMv+R6rWJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=kDc6S37xhECSvMudc/RhaZruUmgJQZ59vTHoUlXbAZ8Lpj3OWnewB0PLTXndtT3EQ
	 bP/McniTomXZ2Iz3RlOnsjDv9wNrhQA8M7OoED0xr7AVLQ2s9dTB6MxvJA6r/19JnS
	 WB5PlGu3D/aMbMToo4BKlnGcfiohPNIlz1lwK4PI6uIshR+dDYBiUkFbiKEUQocTY3
	 BX1FHO/akvKAotDM6+ekNUAZAG7iOT5FHa3XFt7t0kJRgl55aUslj627hR2gdyoPnP
	 Nk58zaqrBxKfoWxJSYIpkOgighw9M0Mpd8NWf8I0g1rcWIFwlsivZmyWyxqeLgebHE
	 E+nxINK+aurvuwzx8ttji5xg5lXyagGHfKxfM/mDfBTH/YBrw5KlRVCL2F49DADPsF
	 Sw5mOAZbCgI8rU5hD/7olDWsMA3JIW5UShwhyY7H15IBqMzD6H0xFgQShCnD2tUoPr
	 migebZ6FHKPp/U8KwAk3etew5MzHHOfw/4CPKo62V8YNKh7H7Za7OiU0hZ1gsrPj2p
	 T7oeXrCDggEaCB+sqy7bzsyq41NXwn3LW6ZEzcRm7LJXFkntTnZe1WtjmqETBmFSbz
	 Ucto73ThKs74N3O0s5x/TrIJKK7QqkTBKsRSEF+pSFe9mg4eMtsBebwxf1O+OZOqYx
	 GOIWhjgFLba8O52BEpMtuJuw=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e94b4a6e8dso19478525ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 20:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792466514; x=1793071314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gnzh+m64uMxXKaq6t/vdpcSaRLdFTK11HDMv+R6rWJw=;
        b=haohv5S6ZDI07OOmgRgdtyBTTC5YXnQXyj7hO5uy6ZwnRKdLYu4XQn/PZMTbIJ4RIo
         jDqn2HHCgapmCCRxC+v3NefV8f+ZiOoLJABiWvrPkGKTKkRtnWnucinff9NYMAkPx7YC
         njWFsZQis6RYeOEsboTBM6jvSqnDMY/dMOlEiL+VwzhhGHKO2VzGZiyMMdJa6vINKkek
         kD3FLgItlxufjAix/XRWfWG4NJ4wVQaC7wC0KJ6f75nlR95nWCv1tUIbk20iLXBA5lTY
         18/irl+n0CAEkpd4tfYAUpxVZjtvrJ3Oe1RqZ0n8bspkajVZLJac9owMR4qJNwZ/u+GS
         /3NQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXK8B4lg2EfuVRwmFqalV7qAnG6E0coOMwDACw0uasF3MIhMDQ3rP0MKiCOwHwHQb/dAEKICgEdeWlQD4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLR46enB2icYkuZ/Y3aiaRN/2Bx0Fo5dgeI76pBzuMJ+rVTHaFd
	jdAPnp/IJbEWdmsqU5JUsIcL3BWTC1GXDE5puBO6bt1X0pK9IDF0rlCciVBpS39YT2PQ/qZupHD
	3ZD1WEixOcje2QMUevKwc8NJ16vGthQXMUNu1EBPbg9xSH2UjHC89dPfdXhTLVzBKyo9lTU+4rt
	xYH81wJ+o1N60P6Q==
X-Gm-Gg: AYBFou39TNPgM1r6OV+9hWtVGogA88Or8H6r6RWYE6g4YqaPXVJuD4vChsq+JQ2328i
	YGeV2oN0xYA0XMW5on3oWr3+OUL/1Sj5i9EuYEuDeYrC3da/pzYyOOlBYb01W6IxSWqQpyVlqXM
	el95CtO9+4fP+A6OjtEmWI8ZiqONlEaCptTt/QViPn2jlQ0VGfAN2AVSw5mzwDzE/jPCU/dEI2S
	5p9Srmkbbp2qbX9JrSqE/FUUD7OmqgU9GJERqLv+Uyxybm9LqPuqh0dMrcWB6le1XocsFcRX9tV
	Be7d6RnAt+zR+ZAFpeZHGCax/dOmzhcXjiDy8+i29EMybZHrv/dG8KJSdWWffzC37hTwz2OUUgl
	2hsYVFqdoGQ==
X-Received: by 2002:a17:903:3884:b0:2e9:6972:54d7 with SMTP id d9443c01a7336-2e9a7058929mr78152855ad.52.1792466514272;
        Mon, 19 Oct 2026 20:21:54 -0700 (PDT)
X-Received: by 2002:a17:903:3884:b0:2e9:6972:54d7 with SMTP id d9443c01a7336-2e9a7058929mr78152665ad.52.1792466513956;
        Mon, 19 Oct 2026 20:21:53 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea14dfb7absm7674745ad.38.2026.10.19.20.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:21:53 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com
Subject: Re: [PATCH v2 0/2] crypto: caam - Fix RSA destination buffer handling
Date: Tue, 20 Oct 2026 14:21:44 +1100
Message-ID: <20261020032144.961571-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <asdIf-bbjjSHRNh7@gondor.apana.org.au>
References: <asdIf-bbjjSHRNh7@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

Thanks for the review.

> If a caller provides an unaligned destination scatterlist where
> req->dst_len is larger than the actual RSA output size (such as
> key->n_sz), the bounce buffer is zero-initialized and sized to
> req->dst_len. [...] Could this corrupt adjacent data by copying zeroes
> over the trailing capacity of the caller's buffer? Should this copy
> only the actual hardware output size instead of the full buffer
> capacity?

There is no out-of-bounds access or adjacent-memory corruption: the
copy-back targets the caller's own dst (orig_dst) and is bounded by
req->dst_len, the buffer length the caller provided. It reads dst_len
bytes from the bounce buffer (sized ALIGN(dst_len, cacheline) >= dst_len)
and writes them into that same dst, so neither buffer is overrun.

That said, copying only the actual output size is a sensible improvement,
and I've applied it in v3: the copy-back is now bounded to the RSA output
size (key->n_sz) instead of req->dst_len. The hardware writes the full
modulus-width (n_sz) output - the RSA PDB has no separate output-length
field - and caam_rsa_enc()/caam_rsa_dec() guarantee dst_len >= n_sz, so
the trailing capacity of the caller's buffer is left untouched.

Another option, if keeping the full dst_len copy is preferred, is to seed
the bounce buffer with the caller's original destination contents before
the operation (rather than zero-initializing it) and copy all dst_len
bytes back afterwards. The hardware overwrites only [0, n_sz) with the
result, so [n_sz, dst_len) still holds the caller's original bytes and the
full copy-back leaves the trailing region unchanged. I went with the
simpler key->n_sz bound for v3, but I'm happy to switch to this if you
prefer.

Kind regards,

Changwei
