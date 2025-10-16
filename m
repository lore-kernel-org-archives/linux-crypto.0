Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D24343D93;
	Thu, 16 Oct 2025 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626763; cv=pass; b=WGVcJnVQhAK8sv3NCuhQpORRZMtRIPZFPNj2Q7TF+5OB5vbNxCCWvbuyL2ZOwAked3CcPTMB9e1c4MSodZne2qVWoSzMQLqY4mz6HNQPgPRduiPDkDJtcBkpNbwmu+Vn5SBqp0TS7wbJkLfVnEZ62nmqnLqWXlxtg2s++b08j9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626763; c=relaxed/simple;
	bh=VUvSpcjMJ6LpfbaagWC+IIOu4x5SrZ1/M4Iyktdp7Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZQ6eGOvXAWFce6bK9+LEO5BqSxM2I61kzgDVST0d5dWnWIVrrBVegCd/DRnDIw/uY5uP7qCznHIzsMiFu6vkAXNWzgmHEl/xGLdgdJomPpvKnuitEHF661AYGoNGgTFdlcooALV5maFNvVwQyx0nKCNxWQffgK00rsO7v2Cq6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=KD59eRZ3; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="KD59eRZ3"
ARC-Seal: i=1; a=rsa-sha256; t=1760626571; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=itzjNjpudnno0prCGw6S+DblTrA4WNG35ScX8M05+4VSF1wIFCpjOP7c+EUwbTiwA6
    vBBhWriaaVyychOlBJcFSHumjd7yilUpcsyY37p/t97giLBfNPgNH1Mms4HBr9dbPNk7
    RXQ8rOHLF9uxE4HYRiugISfBjuLyYxDvQ6DpVw5JB8askHEA8uhKR7V8b7HIGzNl3IAO
    XFbo36/nGvBSdZe0X146AhQcNrTA1HTkQkeKV+18oLYoJaQqrsZTQS3yP6FyZlvbF+l5
    CvvvagHmy9AwtFRDRE3Cm4BY7m8W90aZsJvSxC63TNuKsKlI0aHVqm2yz4MyzUcYcres
    2PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1760626571;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fGOMP+OS+GLcPkdX83O8tRNbIO+1sVKZCqRPowenx2o=;
    b=mCMA/M8Wr3lXMWyejjUnMmZphcjWqNvSG33P/w7YsXXTmd9RAkjf5hlZpBon4Mp5fv
    0Y3eTDJT4zBuVIR8uEFqG30XEozeuOcFU08m4AoXIgo7O3Jyxl/t7+o34/vUOBfR7o9q
    rVMPW3lQwm8YhlysakC7dl2cGJRzgE1XdyVKvce2clUlCocQK90o8HW1xQ5Qc4m5eeng
    qklHFG32fE7FYCSMBRJARPfL3eBIrNdYwcMBUJCh3kPFGWjJh902KAyVHnxT59reAT+b
    3vabKOHmQ4Im7sQqB4f9qnnMWETT6Dn9EKqe6WTOWPflZ0J4+NL7ZOBCv1gdr4oGwHB+
    nKsA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1760626571;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fGOMP+OS+GLcPkdX83O8tRNbIO+1sVKZCqRPowenx2o=;
    b=KD59eRZ3H6a3KxPi5UYG+z7pUWAMZ52hBa/wpDU5zRdA0ixc+JmrP/wWe6ngaMOdfM
    /Q2iDObh4efaB1iodl0/1aUeyPqM/f7xPZ7ULyGITno6AJ1RxTucvs9hnEQ6/cjGyV8S
    wmLHm+GnnWfRA2pK5KqMXY9TEedb/QTRyWhRO2BtsJW7WZMLlhP3G+48u2k4BL1nxqWL
    ZygXkxm80K4AA/ONntSl0jMjU6QZqMzCwYPG2zFsxMQeVqgYXBmEX1LNQDcTOuTUlJJ+
    N4R6k+tfq/rsedQByAzw3W/AmveibJb3NueW+2/C0o6pI354KjtEl+ASD23bB0MAWbnH
    FVZA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJfSfvOU3"
Received: from tauon.localnet
    by smtp.strato.de (RZmta 53.4.2 DYNA|AUTH)
    with ESMTPSA id f279ee19GEuAbSv
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 16 Oct 2025 16:56:10 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto,
 lib/crypto: Add SHAKE128/256 support and move SHA3 to lib/crypto
Date: Thu, 16 Oct 2025 16:56:09 +0200
Message-ID: <13446126.ZYm5mLc6kN@tauon>
In-Reply-To: <363389.1760625251@warthog.procyon.org.uk>
References:
 <286100.1760618158@warthog.procyon.org.uk>
 <2636609.1759410884@warthog.procyon.org.uk>
 <363389.1760625251@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Donnerstag, 16. Oktober 2025, 16:34:11 Mitteleurop=C3=A4ische Sommerzeit=
 schrieb=20
David Howells:

Hi David,

> David Howells <dhowells@redhat.com> wrote:
> > I have ML-DSA working as far as being able to load keys and check
> > signatures in the kernel - but hit a minor bump of openssl not apparent=
ly
> > being able to actually generate CMS signatures for it:-/.  It seems the
> > standard is not settled quite yet...
>=20
> Actually, openssl CMS can generate ML-DSA signatures, but only if CMS_NOA=
TTR
> is not specified.

If you want to test it, perhaps the lc_x509_generator or lc_pkcs7_generator=
=20
from leancrypto could be used [1].

[1] https://leancrypto.org/leancrypto/x509_support/index.html
>=20
> David


Ciao
Stephan


