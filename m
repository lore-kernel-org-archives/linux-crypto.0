Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470949;
	b=V9cPMlCaLjaa6hJAoNe2Q9QaIK7gfQnavQfSJaS9y0ZWyH4UKuzdgxQchC3+wHf6bA38
	 jQsA6guX+Gxqi2Ue+fqEAkA5BEIXR5ycQMdByO7VHGHNiZ9XnbEG4T4YtMmO9BoXx4Fk6
	 lu6gDo3ZCBoh2Wk5Vt3GE1vzO9LhvPQxZkjZvft20wl5SLuCB24yWcmZCeCsPig0+DoCL
	 NnRtb15oaE09QWJbE1hfDlZNR72n/vUIXmF+X62HO8GIQz1U9bwHUsW9XmLVm5pYGUI5/
	 xHNMZw4ve4Gu0ZimSz+V3+r+X8ptUPfKh7dNff/TTn7C7nSpgW5XT5ClThLuvSrX7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470949;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/aQDjLzqInb6x92F+lJ0iA4jJu+++K2V32UGjVHMNqs=;
	b=3kIeg6KANqTrnAafyACHmVtEeGg9bxlsEdV4l9lHg/ht+qVwnx4By1RtpDJtx3721Ny2
	 zADG4dl7u/brI4X1EOIR/bDW7RXwUIFR7azvL486L32XUDU5UOkyETiNEIA21RbefmuZN
	 6gflhBEdsZRDhfioVgYGepzaxx9+4awck9CExEhet4h5uwezhEGzTb0Hwn89pJlzGWsH+
	 ijGrKnONSt2TAEl5Bq0LiE/OwySuRGvvpzf83rPy6nktWRZ9sqM9GkWhx4Lxat4MVhQvA
	 tQ76Cdhpcp8r36URdd4Pjc9i3fQmiT/FUbexZ7BK7r9BsafBPDGG//Yw8c1s8PWXv2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxmIvUlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89397606A89C;
	Thu, 12 Nov 2026 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxmIvUlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559101F00A05;
	Thu, 12 Nov 2026 08:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794470948;
	bh=/aQDjLzqInb6x92F+lJ0iA4jJu+++K2V32UGjVHMNqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kxmIvUlHKnqe8ql1TEjTfuDwHsCk/BP1kyBqHx3veUnaufXyAVJTrgnEh/fwcrJIk
	 Jl9Vr8E3ziKfq4CKxLIQq4XY7EawZ5gW+lmB0BAT8hhVo/WhDFvGxcyT/CxsEaaEeH
	 VX7MSN6u5LM7CzslkE2v22nDR9aHpf44tSeJTrvOhpJsg7nSEqziT07X+RJqhO05D0
	 qNDmo21V2HumHXEQVOPiaB39yBLbNlIueCNPgqiMVB1uYdgImhuI0C/WV4uk1ufOUp
	 u5HX5837iBgrF0rHxnrXXRBXwb1u+XxP+VakzuPyXRgu7dwtKkgUG//uDHalbeRm/3
	 I2SxhC2ySLQIQ==
Date: Thu, 12 Nov 2026 00:09:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] X.509: Accept a certificate with an empty subject
Message-ID: <20261112080906.GA375698@sol>
References: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
 <20261112074246.99421-2-laveeshb@laveeshbansal.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112074246.99421-2-laveeshb@laveeshbansal.com>

On Wed, Nov 11, 2026 at 11:42:45PM -0800, Laveesh Bansal wrote:
> A certificate with an empty Subject, which RFC 5280 allows, fails to
> load: add_key() returns -EBADMSG. iwd hits this with an eduroam server
> certificate.
> 
> The subject is parsed with the Name rule. The ASN.1 compiler turns a
> SEQUENCE OF into a loop that runs at least once, so the first RDN is
> mandatory and an empty SEQUENCE runs out of data in the decoder.
> 
> Give the subject its own rule, a SEQUENCE OF a one-member CHOICE, so the
> first RDN can be absent. Anything that is not a SET is still rejected.
> The issuer keeps the Name rule, as RFC 5280 requires it to be non-empty.
> 
> Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.509 certificates")
> Cc: stable@vger.kernel.org # v3.7+
> Reported-by: Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>
> Closes: https://lore.kernel.org/r/9b05b89cf296b8a6392bbe6327228c1bc2f05c49.camel@uni-bremen.de
> Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>

This problem (and many others) could also be solved if iwd switched to
use a userspace crypto library instead of misusing the kernel APIs.

- Eric
