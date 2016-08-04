From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v2] DH support: add KDF handling support
Date: Thu, 4 Aug 2016 13:57:27 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1608041346090.55029@mjmartin-mac01.local>
References: <2239809.KsND40bFeW@positron.chronox.de> <2313703.12yUpncF2W@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965892AbcHDU5a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 16:57:30 -0400
In-Reply-To: <2313703.12yUpncF2W@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Stephan,

On Thu, 4 Aug 2016, Stephan Mueller wrote:

> Hi Mat, David,
>
> this patch covers all comments you raised. I also added a man page
> for the new API calls.
>
> ---8<---
>
> Add the interface logic to support DH with KDF handling support.
>
> The dh_compute code now allows the following options:
>
> - no KDF support / output of raw DH shared secret:
>  dh_compute <private> <prime> <base>
>
> - KDF support without "other information" string:
>  dh_compute_kdf <private> <prime> <base> <output length> <KDF type>
>
> - KDF support with "other information string:
>  dh_compute_kdf_oi <private> <prime> <base> <output length> <KDF type>
>    where the OI string is provided on STDIN.
>
> The test to verify the code is based on a test vector used for the CAVS
> testing of SP800-56A.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
> Makefile                                 |   1 +
> keyctl.c                                 | 125 +++++++++++++++++++++++
> keyutils.c                               |  44 ++++++++
> keyutils.h                               |  15 +++
> man/keyctl_dh_compute_kdf.3              | 143 ++++++++++++++++++++++++++
> tests/keyctl/dh_compute/valid/runtest.sh | 168 +++++++++++++++++++++++++++++++
> tests/toolbox.inc.sh                     |  44 ++++++++
> version.lds                              |   2 +
> 8 files changed, 542 insertions(+)
> create mode 100644 man/keyctl_dh_compute_kdf.3

> diff --git a/keyutils.c b/keyutils.c
> index 2a69304..0da640c 100644
> --- a/keyutils.c
> +++ b/keyutils.c
> @@ -244,6 +244,20 @@ long keyctl_dh_compute(key_serial_t private, key_serial_t prime,
> 	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, 0);
> }
>
> +long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
> +			   key_serial_t base, char *kdfname, char *otherinfo,
> +			   size_t otherinfolen, char *buffer, size_t buflen)
> +{
> +	struct keyctl_dh_params params = { .private = private,
> +					   .prime = prime,
> +					   .base = base };
> +	struct keyctl_kdf_params kdfparams = { .kdfname = kdfname,
> +					       .otherinfo = otherinfo,
> +					       .otherinfolen = otherinfolen };
> +
> +	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, &kdfparams);
> +}
> +
> /*****************************************************************************/
> /*
>  * fetch key description into an allocated buffer
> @@ -386,6 +400,36 @@ int keyctl_dh_compute_alloc(key_serial_t private, key_serial_t prime,
> }
>
> /*
> + * fetch DH computation results processed by a KDF into an
> + * allocated buffer
> + * - resulting buffer has an extra NUL added to the end
> + * - returns count (not including extraneous NUL)
> + */

I don't think this function should be added. Since genlen is known, the 
caller can handle all of the memory management and call 
keyctl_dh_compute_kdf itself. Other _alloc functions do something extra, 
like ask the kernel how big of a buffer is needed.

> +int keyctl_dh_compute_kdf_alloc(key_serial_t private, key_serial_t prime,
> +				key_serial_t base, size_t genlen, char *kdfname,
> +				char *otherinfo, size_t otherinfolen,
> +				void **_buffer)
> +{
> +	char *buf;
> +	int ret;
> +
> +	buf = malloc(genlen + 1);
> +	if (!buf)
> +		return -1;
> +
> +	ret = keyctl_dh_compute_kdf(private, prime, base, kdfname, otherinfo,
> +				    otherinfolen, buf, genlen);
> +	if (ret < 0) {
> +		free(buf);
> +		return -1;
> +	}
> +
> +	buf[ret] = 0;
> +	*_buffer = buf;
> +	return ret;
> +}
> +
> +/*
>  * Depth-first recursively apply a function over a keyring tree
>  */
> static int recursive_key_scan_aux(key_serial_t parent, key_serial_t key,
> diff --git a/keyutils.h b/keyutils.h
> index b321aa8..d5abd92 100644
> --- a/keyutils.h
> +++ b/keyutils.h
> @@ -108,6 +108,13 @@ struct keyctl_dh_params {
> 	key_serial_t base;
> };
>
> +struct keyctl_kdf_params {
> +	char *kdfname;
> +	char *otherinfo;
> +	uint32_t otherinfolen;
> +	uint32_t __spare[8];
> +};
> +
> /*
>  * syscall wrappers
>  */
> @@ -163,6 +170,10 @@ extern long keyctl_invalidate(key_serial_t id);
> extern long keyctl_get_persistent(uid_t uid, key_serial_t id);
> extern long keyctl_dh_compute(key_serial_t private, key_serial_t prime,
> 			      key_serial_t base, char *buffer, size_t buflen);
> +extern long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
> +				  key_serial_t base, char *kdfname,
> +				  char *otherinfo, size_t otherinfolen,
> +				  char *buffer, size_t buflen);
>
> /*
>  * utilities
> @@ -172,6 +183,10 @@ extern int keyctl_read_alloc(key_serial_t id, void **_buffer);
> extern int keyctl_get_security_alloc(key_serial_t id, char **_buffer);
> extern int keyctl_dh_compute_alloc(key_serial_t private, key_serial_t prime,
> 				   key_serial_t base, void **_buffer);
> +extern int keyctl_dh_compute_kdf_alloc(key_serial_t private, key_serial_t prime,
> +				       key_serial_t base, size_t genlen,
> +				       char *kdfname, char *otherinfo,
> +				       size_t otherinfolen, void **_buffer);
>
> typedef int (*recursive_key_scanner_t)(key_serial_t parent, key_serial_t key,
> 				       char *desc, int desc_len, void *data);
> diff --git a/man/keyctl_dh_compute_kdf.3 b/man/keyctl_dh_compute_kdf.3
> new file mode 100644
> index 0000000..06e2b29
> --- /dev/null
> +++ b/man/keyctl_dh_compute_kdf.3

My vote is to include this content in keyctl_dh_compute.3 instead of 
adding a separate man page.

> @@ -0,0 +1,143 @@
> +.\"
> +.\" Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
> +.\" Copyright (C) 2016 Intel Corporation. All rights reserved.
> +.\"
> +.\" This program is free software; you can redistribute it and/or
> +.\" modify it under the terms of the GNU General Public License
> +.\" as published by the Free Software Foundation; either version
> +.\" 2 of the License, or (at your option) any later version.
> +.\"
> +.TH KEYCTL_DH_COMPUTE 3 "26 Jul 2016" Linux "Linux Key Management Calls"
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH NAME
> +keyctl_dh_compute_kdf \- Derive key from a Diffie-Hellman shared secret
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH SYNOPSIS
> +.nf
> +.B #include <keyutils.h>
> +.sp
> +.BI "long keyctl_dh_compute_kdf(key_serial_t " private ", key_serial_t " prime ,
> +.BI "key_serial_t " base ", char *" kdfname ", char *" otherinfo ",
> +.BI "size_t " otherinfolen ", char *" buffer ", size_t " buflen ");"
> +.sp
> +.BI "long keyctl_dh_compute_kdf_alloc(key_serial_t " private,
> +.BI "key_serial_t " prime ", key_serial_t " base ", size_t " genlen ",
> +.BI "char *" kdfname ", "char *" otherinfo ", size_t " otherinfolen ",
> +.BI "void **" _buffer ");"
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH DESCRIPTION
> +.BR keyctl_dh_compute_kdf ()
> +derives a key from a Diffie-Hellman shared secret according to the protocol
> +specified in SP800-56A.
> +.P
> +For the Diffie-Hellman computation, the following algorithm is used::
> +.IP
> +.I base
> +^
> +.I private
> +( mod
> +.I prime
> +)
> +.P
> +To implement the protocol of SP800-56A
> +.I base
> +is a key containing the remote public key to compute the Diffie-Hellman
> +shared secret. That shared secret is post-processed with a key derivation
> +function.
> +.P
> +.IR base ", " private ", and " prime
> +must all refer to
> +.BR user -type
> +keys containing the parameters for the computation.  Each of these keys must
> +grant the caller
> +.B read
> +permission in order for them to be used.
> +.P
> +The
> +.I kdfname
> +specifies the Linux kernel crypto API name for a key derivation function
> +using a non-keyed hash, such as kdf_ctr(sha256). Using the counter KDF function
> +specified with kdf_ctr() makes the key derivation compliant to SP800-56A.
> +The
> +.I kdfname
> +must be a NULL terminated string.
> +.P
> +Following the specification of SP800-56A section 5.8.1.2 the
> +.I otherinfo
> +parameter may be provided. The format of the OtherInfo field is defined
> +by the caller. The caller may also specify NULL as a valid argument when
> +no OtherInfo data shall be processed. The length of the
> +.I otherinfo
> +parameter is specified with
> +.I otherinfolen
> +and is restricted to a maximum length by the kernel.
> +.P
> +The KDF returns the requested number of bytes specified with the
> +.I genlen
> +or the
> +.I buflen
> +parameter depending on the invoked function.
> +.P
> +.I buffer
> +and
> +.I buflen
> +specify the buffer into which the computed result will be placed.
> +.P
> +.BR keyctl_dh_compute_kdf_alloc ()
> +is similar to
> +.BR keyctl_dh_compute_kdf ()
> +except that it allocates a buffer with the size of
> +.I genlen
> +to hold the payload data and places the data in it. If successful, a pointer
> +to the buffer is placed in
> +.IR *_buffer .
> +The caller must free the buffer.
> +.P
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH RETURN VALUE
> +On success
> +.BR keyctl_dh_compute_kdf ()
> +returns the amount of data placed into the buffer when
> +.I buflen
> +is non-zero.
> +.P
> +On success
> +.BR keyctl_dh_compute_kdf_alloc ()
> +returns the amount of data in the buffer.
> +.P
> +On error, both functions set errno to an appropriate code and return the value
> +.BR -1 .
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH ERRORS
> +.TP
> +.B ENOKEY
> +One of the keys specified is invalid or not readable.
> +.TP
> +.B EINVAL
> +The buffer pointer is invalid or buflen is too small.
> +.TP
> +.B EOPNOTSUPP
> +One of the keys was not a valid user key.
> +.TP
> +.B EMSGSIZE
> +The size of either
> +.I otherinfolen
> +or
> +.I buflen
> +is too big.
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH LINKING
> +This is a library function that can be found in
> +.IR libkeyutils .
> +When linking,
> +.B -lkeyutils
> +should be specified to the linker.
> +.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> +.SH SEE ALSO
> +.BR keyctl (1),
> +.br
> +.BR keyctl (2),
> +.br
> +.BR keyctl (3),
> +.br
> +.BR keyutils (7)

--
Mat Martineau
Intel OTC
