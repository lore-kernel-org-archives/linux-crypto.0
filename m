From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v3] DH support: add KDF handling support
Date: Tue, 9 Aug 2016 15:38:43 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1608091536470.24354@mjmartin-mac01.local>
References: <2239809.KsND40bFeW@positron.chronox.de> <2313703.12yUpncF2W@positron.chronox.de> <3715151.LOyK4NLlGi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbcHIWj0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 18:39:26 -0400
In-Reply-To: <3715151.LOyK4NLlGi@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Sat, 6 Aug 2016, Stephan Mueller wrote:

> diff --git a/man/keyctl_dh_compute.3 b/man/keyctl_dh_compute.3
> index b06d39e..92d358f 100644
> --- a/man/keyctl_dh_compute.3
> +++ b/man/keyctl_dh_compute.3
> @@ -11,6 +11,8 @@
> .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> .SH NAME
> keyctl_dh_compute \- Compute a Diffie-Hellman shared secret or public key
> +.br
> +keyctl_dh_compute_kdf \- Derive key from a Diffie-Hellman shared secret
> .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> .SH SYNOPSIS
> .nf
> @@ -21,6 +23,10 @@ keyctl_dh_compute \- Compute a Diffie-Hellman shared secret or public key
> .sp
> .BI "long keyctl_dh_compute_alloc(key_serial_t " private,
> .BI "key_serial_t " prime ", key_serial_t " base ", void **" _buffer ");"
> +.sp
> +.BI "long keyctl_dh_compute_kdf(key_serial_t " private ", key_serial_t " prime ,
> +.BI "key_serial_t " base ", char *" kdfname ", char *" otherinfo ",
> +.BI "size_t " otherinfolen ", char *" buffer ", size_t " buflen ");"
> .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> .SH DESCRIPTION
> .BR keyctl_dh_compute ()
> @@ -64,6 +70,49 @@ places the data in it.  If successful, a pointer to the buffer is placed in
> .IR *_buffer .
> The caller must free the buffer.
> .P
> +.BR keyctl_dh_compute_kdf ()
> +derives a key from a Diffie-Hellman shared secret according to the protocol
> +specified in SP800-56A. The Diffie-Hellman computation is based on the same
> +primitives as discussed
> +for
> +.BR keyctl_dy_compute ().

Minor typo: dy->dh


Regards,

--
Mat Martineau
Intel OTC
