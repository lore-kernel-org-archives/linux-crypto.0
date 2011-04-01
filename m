From: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Subject: crypto_alg and alignment
Date: Fri, 1 Apr 2011 11:07:27 +0300
Message-ID: <AANLkTinXJP27s54yyPtmGBWADSLRZ6YfOFgcciycYGy=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33513 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1DAIH2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Apr 2011 04:07:28 -0400
Received: by qyk7 with SMTP id 7so152556qyk.19
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2011 01:07:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

I'm trying to implement a driver for one hardware crypto engine, and
on the current stage I work with AES algorithm, and I have a couple of
open questions.

1) What shall be guaranteed from crypto engine by providing
   cra_blocksize and cra_alignmask values in crypto_alg definition? If
   they are provided, can I rely that in ablkcipher request I get
   aligned source and destination, and size of each chunk in sglist is
   aligned to cra_blocksize?

2) I've taken a look at
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04903.html
   and I wonder, is someone working with SOCK_STREAM protocol
   realization for AF_ALG? And is there some planned activities about
   implementing setsockopt support for ALG_SET_IV, ALG_SET_OP etc. in
   algif_skcipher?

Thank you in advance.

With best wishes,
Vladimir
