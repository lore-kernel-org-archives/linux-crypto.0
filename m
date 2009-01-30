From: "Loc Ho" <lho@amcc.com>
Subject: RE: [RFC] MPI module
Date: Fri, 30 Jan 2009 10:54:16 -0800
Message-ID: <0CA0A16855646F4FA96D25A158E299D605CBC9A8@SDCEXCHANGE01.ad.amcc.com>
References: <20090130081210.GA8157@artemis> <20090130124110.GA6827@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Pierre Habouzit" <madcoder@debian.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:45989 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZA3SyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2009 13:54:21 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20090130124110.GA6827@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I would like to add that you can even handle the TLS/DTLS/SSL packet formation in the kernel as well if you provide an algorithms that does just that. Right now, most user just use the kernel for the hashing and cipher parts. There is no reason that the current framework cannot handle processing the full packet in hardware. All you need is to create another algorithm name that is aead type. Then, from user space (using Linux CryptoAPI user space interface) creates that algorithms. The underlying CryptoAPI will call the appropriate function that provided by your driver and the result of the operation will be an TLS/DTLS/SSL packet formation. 

We currently does this for testing our hardware for non-IPSec protocol.

-Loc


-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Friday, January 30, 2009 4:41 AM
To: Pierre Habouzit
Cc: linux-crypto@vger.kernel.org
Subject: Re: [RFC] MPI module

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
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
