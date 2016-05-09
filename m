From: Stephan Mueller <smueller@chronox.de>
Subject: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 09 May 2016 12:24:08 +0200
Message-ID: <5061410.3QzdTXsEjv@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55068 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbcEIKYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 06:24:05 -0400
Received: from positron.chronox.de (rrcs-97-79-174-130.sw.biz.rr.com [97.79.174.130])
	by mail.eperm.de (Postfix) with ESMTPA id 800082A0048
	for <linux-crypto@vger.kernel.org>; Mon,  9 May 2016 12:24:01 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am experimenting with pkcs1pad(rsa-generic) signature verify. The following 
numbers shall serve as examples -- using other valid signatures, similar 
results are visible.

All signatures are correct.

The result of the signature verify operation is the following byte stream:

3021300906052b0e03021a05000414ba3bc9c6fb57dfa3103e5991e8992d4387afa6f2d93e4f478d3cb74138b28cc5d1601f2bc549c2297e5bf76578fbaf5defe617748ac29f825aa974a56b7fdffe21f8d5c6abd7d9050525c60d94a36b3ce7a763af66b1ed501ebd0edd4b686a6bb8afd903c9ab97a60853fa7345fdd28fcc

The hash of the message is:

ba3bc9c6fb57dfa3103e5991e8992d4387afa6f2


The hash of the message is embedded in the data stream returned by the 
signature verify operation.

Looking at the first bytes of the data stream from the signature verify, it 
looks like an ASN.1 sequence.

Looking into the function pkcs1pad_verify_complete, that suspicion is 
confirmed: the padding is removed, but the decoding is not implemented. Shall 
a caller implement the decoding?

If so, what is the purpose of the pkcs1pad implementation when only a part of 
the sig ver is implemented?

Looking into pkcs1pad_sign, I also do not see the BER encoding. Again, shall 
the caller do that?


Ciao
Stephan
