From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] MPI module
Date: Fri, 30 Jan 2009 23:41:10 +1100
Message-ID: <20090130124110.GA6827@gondor.apana.org.au>
References: <20090130081210.GA8157@artemis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Pierre Habouzit <madcoder@debian.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49500 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349AbZA3MlM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2009 07:41:12 -0500
Content-Disposition: inline
In-Reply-To: <20090130081210.GA8157@artemis>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pierre Habouzit <madcoder@debian.org> wrote:
>
> So let me rephrase that to be sure we've understood each other. What you
> suggest is to have an IKE-like daemon dealing with the keys and all the
> handshakes, and that the kernel would only deal with the symmetric
> ciphers used on the data path. Is that right ?

Either a daemon or a library in user-space should handle the
hard work of negotiating the keys.  You can leave the easy work
of encrypting/decrypting the data to the kernel :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
