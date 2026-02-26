Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [144.76.133.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCC92135AD;
	Thu, 26 Feb 2026 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772112485; cv=none; b=Fmb1N+n3CKYjUjM4m8jJhHggb37kReD9PLOE/VIRkdzp2iT46K/we7leIP1Jj/rTl9YPWd/Uoqguy472IZHD2KUkDgwx8Iw0uRWQSO+2mxNaMQuMHUL6Wz6FyRQcZ55p8vWpTwhIEcDr23cKBTEoI7QAuxAPDuHNrkYdvvpXy6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772112485; c=relaxed/simple;
	bh=n0fZlMeLdFTr4OLNB1E08HU8lcvCOjZAjIYfWYUtXFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+06NZOEyap8aHmPGCxKofNBQlrBkNZz8Dzw35N32itbPZDxr/ReTSGCo1X8fy/xAL5Kz9zPStAOe01x1JdUGUH7TuOEoOfctOB1g7OPqOIRbqdAcfIozuZn3hUhSdnLokxcvmBz3ut81zC7utnMFFj59ZY3BJEPxCDFPP9rKu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=144.76.133.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 10DDE20208FF;
	Thu, 26 Feb 2026 14:27:55 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E051D1E6ED; Thu, 26 Feb 2026 14:27:54 +0100 (CET)
Date: Thu, 26 Feb 2026 14:27:54 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aaBKWqY57OSxhx7q@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
 <aZ6vF1CHpcp5d5qk@wunner.de>
 <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
 <aZ_zfnKVnTaG_4bk@wunner.de>
 <1a65ac92579fadb4bfc76b32a3a4f1c6df022801.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a65ac92579fadb4bfc76b32a3a4f1c6df022801.camel@ginzinger.com>

On Thu, Feb 26, 2026 at 11:41:56AM +0000, Kepplinger-Novakovic Martin wrote:
> [    2.272135] PKEY: ==>public_key_verify_signature()
> [    2.272165] CAAM rsa init start
> [    2.272180] CAAM rsa init done
> [    2.272191] caam_rsa_pub_key: free old key in ctx
> [    2.272201] caam_rsa_pub_key: write rsa_key->e
> [    2.272210] caam_rsa_pub_key: write rsa_key->n
> [    2.272220] start rsassa_pkcs1_verify
> [    2.272228] slen: 256
> [    2.272238] child_req address: 1d64b62a full size: 64 + 48 + 256 = 368
> [    2.272274] out_buf1:00000000: 00000000 00000000 00000000 00000000  ................
> [    2.272298] out_buf1:00000010: 00000000 00000000 00000000 00000000  ................
> [    2.272322] SRC BUF in out_buf1 CRC: 969ee858
> [    2.272335] start caam_rsa_enc
> [    2.272352] key:00000000: cf60a600 cf4d1240 00000000 00000000  ..`.@.M.........
> [    2.272377] key:00000010: 00000000 00000000 00000000 00000000  ................
> [    2.272413] edesc:00000000: 00000001 00000001 00000000 00000000  ................
> [    2.272438] edesc:00000010: 00000000 00000000 00000000 cf533d6c  ............l=S.
> [    2.272466] req:00000000: 00000000 00000000 c02e2f68 d083dcb4  ........h/......
> [    2.272491] req:00000010: cf60a540 00000200 d083dc94 d083dca4  @.`.............
> [    2.272509] CAAM: calling caam_jr_enqueue
> [    2.272524] key:00000000: cf60a600 cf4d1240 00000000 00000000  ..`.@.M.........
> [    2.272546] key:00000010: 00000000 00000000 00000000 00000000  ................
> [    2.277444] CAAM: completion callback
> [    2.424765] OUT BUF in out_buf2 CRC: fd0eef11
> [    2.424799] out_buf2:00000000: 00000000 00000000 00000000 00000000  ................
> [    2.424827] out_buf2:00000010: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424853] out_buf2:00000020: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424878] out_buf2:00000030: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424902] out_buf2:00000040: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424926] out_buf2:00000050: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424949] out_buf2:00000060: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424973] out_buf2:00000070: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.424996] out_buf2:00000080: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.425020] out_buf2:00000090: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.425043] out_buf2:000000a0: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.425068] out_buf2:000000b0: ffffffff ffffffff ffffffff ffffffff  ................
> [    2.425095] out_buf2:000000c0: ffffffff ffffffff ffffffff 30313000  .............010
> [    2.425123] out_buf2:000000d0: 6009060d 65014886 01020403 20040005  ...`.H.e....... 
> [    2.425148] out_buf2:000000e0: 6155a84e 7aa089cb 7540e613 f28b9a30  N.Ua...z..@u0...
> [    2.425172] out_buf2:000000f0: 1e98ec34 cecb0e0f 9ee8951a ad8baec3  4...............

There's an endianness issue here:  30313000 is the zero byte prescribed
by EMSA-PKCS1-v1_5 ("in_buf[ps_end] = 0x00;" in rsassa_pkcs1_sign()),
followed by the first three bytes of hash_prefix_sha256[] in reverse order.

Then 6009060d are the next four bytes of hash_prefix_sha256[], again
in reverse order.  And so on until 20040005, which are the last four
bytes of the prefix in reverse order.

How are you generating that hexdump?  What's the CPU's endianness?
Is the caam RSA accelerator using a different endianness?

Thanks,

Lukas
