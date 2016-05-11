From: David Howells <dhowells@redhat.com>
Subject: Re: RSA/MPI handling issues and keyctl access to public key keyrings
Date: Wed, 11 May 2016 14:55:56 +0100
Message-ID: <2114.1462974956@warthog.procyon.org.uk>
References: <268bb9cd-08ca-aae9-5b12-91d8c0195bc1@intel.com> <7781.1462785198@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com,
	"Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbcEKNz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 09:55:59 -0400
In-Reply-To: <268bb9cd-08ca-aae9-5b12-91d8c0195bc1@intel.com>
Content-ID: <2113.1462974956.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> >  (2) rsa-pkcs1pad needs to indicate what the maximum content size is, given
> >      the minimum possible padding for the specified hash type (ie. a
> >      particular OID).
> 
> The user needs to use crypto_akcipher_maxsize(tfm) to get the required buffer
> size for a given key.
> We do check if the buffer if big enough to accommodate padding and hash info.
> This is needed in sign and encrypt operations, and in both cases we check it,
> sign:
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n434
> and encrypt:
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n252

Can you supply a way to find out the reduced size from the padding?

David
