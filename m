Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2C38E5FB;
	Tue, 20 Jan 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768923791; cv=pass; b=fPNz1ne+alKWfYpvKkRAB8fXltORxEmvkydro4CEN1QRHuLipQcQO4lrm3o2FDB6XeyZ10enj0eTrFuH1DE9se5lRYfF/8FTC+6Edt7TX3wZEVAMXawUaYz7CtvsnYkOD95Ie4v2cPJkrltRaBeX9kuvi/j/NkTdB23T9CrxiDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768923791; c=relaxed/simple;
	bh=hx2vvZMrEltWCKlhhOXO6GQxyjEInyfUEh3ubtofyDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7fmxh8EzT8qIec24p8+ooEVsXiwkhYUM4VM1Jws/sPDOWOPx7wGvL7CaAnmurquuf9nbzemVlUxZun1KMhEMmCc0+l0pcw3wXY/UDk/QSLUUOUE+DkOowLrdKaGTQFxnr8Vh+KZgmRDutldA2XcpkuDiTRQpRCplXC2sWfSyBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=bCzb2rRK; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=jWAayJC6; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="bCzb2rRK";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="jWAayJC6"
ARC-Seal: i=1; a=rsa-sha256; t=1768923769; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hUm5tZY+5WS09L4JjaRYD4Vif0QQsv+cfufGpvB68NIxVV01rAOtnXxinrSFOl5sor
    tJM1v6oh4vVG5HLM8dVcB+9ehC2urNz3DPYn5LsyPlsjAjGoteIPvnzVeARlpc4Z27ql
    g8rq06J6MveiugiSx0e4e7YxOQtKp0HGVEXLsGz74KXKBNF0crA1D7t7RDE/51TWFF0N
    QYZ7sReQpNrsY5q+1K3yYZeNeou6MkE0YdTob4zg4Z0ViQ931nXq4x0+HsDde/BDbGWR
    6JR86Jy2YutPEv/uI0+96HDlQ/TxZRd+G/SaP5poStIh7LCepiC8e4QJOzp4YOXbCVw3
    P4Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1768923769;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hx2vvZMrEltWCKlhhOXO6GQxyjEInyfUEh3ubtofyDA=;
    b=rJS9JFtOdT0UJ6Y2BRqKN24ilb8MfjIxS1vHYLgbN3ZnmkTvSAH03IspzhexN5TQhb
    GoyXxT4DNPg3PRJibhjctMqCYzE7Ep0dcS4B48NxTRtJgVsnDqSYTrA62ThpyjRBpG3V
    y3tLEGMbZUzgMakU8SqY3yw/mCiQOF6DXPog1WfmTSPTwXMCbcTBYwldz9hm4h9Loa9n
    r4TpQboRFV95nbGNa1yR5v2YFhaZ3mZDn6UgPkg8jlqNac/CrTVlF9ry2nh3/vACMQva
    BM3ii+exTDKoneSeGo33ZiAMiacyHcGgRd0CKGNHQCG4tjI7jJHuqhvjIRJMKAr/Fi3A
    g8CA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1768923769;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hx2vvZMrEltWCKlhhOXO6GQxyjEInyfUEh3ubtofyDA=;
    b=bCzb2rRK27nxlVeqq5lnUU8+kZs2xaUNgXabeOqMIoG3vGg+mina6mxyh3e8nDbcpJ
    X+WMRFc+1unvSl4MjhpQS3hTbjTqyJi/lABi9iKyXsyHf6r1RSYUYM55r0Gu89H4/3js
    hlgp2LVtYLODm8X63+n9s/3zJ0PFFb/NdioMgdRii7ZIqoz1RjfqN+GSjVd01DxzdRnL
    z1/kKq75kyd+4bSLf9GD5+L6N7hY1NDESdjSei6I4GfBYUbmR7DCSr3Novzck4iG0Uq/
    NbNDXd/CY6NGe46darjv6z+xyD6KVOwGw26AG9zixbE2w8NL2X3hDbaE9Eg2Pi/Vt42S
    1QKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1768923769;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hx2vvZMrEltWCKlhhOXO6GQxyjEInyfUEh3ubtofyDA=;
    b=jWAayJC6MSRtt/lIy5pVtTe9LNiHSo7tiFr8HMDwe7Er8j1AOztQfLD/qS+3ddKaFZ
    0/MoChpnjqLUi59bolAA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJPSfPhE="
Received: from tauon.localnet
    by smtp.strato.de (RZmta 54.1.0 DYNA|AUTH)
    with ESMTPSA id ffd25f20KFgm26L
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 20 Jan 2026 16:42:48 +0100 (CET)
From: Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>, David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Python script to generate X509/CMS from NIST testcases
Date: Tue, 20 Jan 2026 16:42:47 +0100
Message-ID: <10662580.0AQdONaE2F@tauon>
In-Reply-To: <1176796.1768921455@warthog.procyon.org.uk>
References:
 <20260119185125.GA11957@sol> <1010414.1768841311@warthog.procyon.org.uk>
 <1176796.1768921455@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Dienstag, 20. Januar 2026, 16:04:15 Mitteleurop=C3=A4ische Normalzeit sc=
hrieb=20
David Howells:

Hi David,

> Hi Eric, Stephan,
>=20
> In case it turns out to be useful to you as a template, here's a script t=
hat
> I wrote to package NIST ML-DSA testcases from JSON files into rudimentary
> X.509, message and CMS signature files and also to produce a C file that
> contains those blobs packaged into u8 arrays with a table listing them al=
l.
>=20
> It also tries to verify each testcase with "openssl smime" - except that
> that doesn't work too will for ML-DSA (it did work for RSASSA-PSS, but
> that's another script).
>=20

Thank you very much for this reference.

Also, in case it is useful for you as well: I just completed the work on=20
adopting the sbsigntools to PQC [1]. This would support the adoption of the=
=20
shim bootloader to use PQC algorithms that is started at [2]. The coding in=
=20
[2] is completed to the extend that it compiles as PE/COFF executable. Now =
I=20
am working through the testing and adopt it to use the updated sbsigntools.

[1] https://github.com/smuellerDD/leancrypto/tree/master/apps/src#secure-bo=
ot-signing-tools-supporting-pqc

[2] https://github.com/smuellerDD/shim/tree/leancrypto2

Ciao
Stephan


