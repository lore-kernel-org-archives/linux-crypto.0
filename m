From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] DH support: add KDF handling support
Date: Fri, 05 Aug 2016 08:10:06 +0200
Message-ID: <2464798.n6WdnD3jRa@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <2313703.12yUpncF2W@positron.chronox.de> <alpine.OSX.2.20.1608041346090.55029@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34012 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030268AbcHEGK5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 02:10:57 -0400
In-Reply-To: <alpine.OSX.2.20.1608041346090.55029@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 4. August 2016, 13:57:27 CEST schrieb Mat Martineau:

Hi Mat,

> Stephan,
> 
> On Thu, 4 Aug 2016, Stephan Mueller wrote:
> > Hi Mat, David,
> > 
> > this patch covers all comments you raised. I also added a man page
> > for the new API calls.
> > 
> > ---8<---
> > 
> > Add the interface logic to support DH with KDF handling support.
> > 
> > The dh_compute code now allows the following options:
> > 
> > - no KDF support / output of raw DH shared secret:
> >  dh_compute <private> <prime> <base>
> > 
> > - KDF support without "other information" string:
> >  dh_compute_kdf <private> <prime> <base> <output length> <KDF type>
> > 
> > - KDF support with "other information string:
> >  dh_compute_kdf_oi <private> <prime> <base> <output length> <KDF type>
> >  
> >    where the OI string is provided on STDIN.
> > 
> > The test to verify the code is based on a test vector used for the CAVS
> > testing of SP800-56A.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> > Makefile                                 |   1 +
> > keyctl.c                                 | 125 +++++++++++++++++++++++
> > keyutils.c                               |  44 ++++++++
> > keyutils.h                               |  15 +++
> > man/keyctl_dh_compute_kdf.3              | 143 ++++++++++++++++++++++++++
> > tests/keyctl/dh_compute/valid/runtest.sh | 168
> > +++++++++++++++++++++++++++++++ tests/toolbox.inc.sh                    
> > |  44 ++++++++
> > version.lds                              |   2 +
> > 8 files changed, 542 insertions(+)
> > create mode 100644 man/keyctl_dh_compute_kdf.3
> > 
> > diff --git a/keyutils.c b/keyutils.c
> > index 2a69304..0da640c 100644
> > --- a/keyutils.c
> > +++ b/keyutils.c
> > @@ -244,6 +244,20 @@ long keyctl_dh_compute(key_serial_t private,
> > key_serial_t prime,> 
> > 	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, 0);
> > 
> > }
> > 
> > +long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
> > +			   key_serial_t base, char *kdfname, char *otherinfo,
> > +			   size_t otherinfolen, char *buffer, size_t buflen)
> > +{
> > +	struct keyctl_dh_params params = { .private = private,
> > +					   .prime = prime,
> > +					   .base = base };
> > +	struct keyctl_kdf_params kdfparams = { .kdfname = kdfname,
> > +					       .otherinfo = otherinfo,
> > +					       .otherinfolen = otherinfolen };
> > +
> > +	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, &kdfparams);
> > +}
> > +
> > /*************************************************************************
> > ****/ /*
> > 
> >  * fetch key description into an allocated buffer
> > 
> > @@ -386,6 +400,36 @@ int keyctl_dh_compute_alloc(key_serial_t private,
> > key_serial_t prime, }
> > 
> > /*
> > + * fetch DH computation results processed by a KDF into an
> > + * allocated buffer
> > + * - resulting buffer has an extra NUL added to the end
> > + * - returns count (not including extraneous NUL)
> > + */
> 
> I don't think this function should be added. Since genlen is known, the
> caller can handle all of the memory management and call
> keyctl_dh_compute_kdf itself. Other _alloc functions do something extra,
> like ask the kernel how big of a buffer is needed.

Ok, I will remove this one.
> 
> > +int keyctl_dh_compute_kdf_alloc(key_serial_t private, key_serial_t prime,
> > +				key_serial_t base, size_t genlen, char *kdfname,
> > +				char *otherinfo, size_t otherinfolen,
> > +				void **_buffer)
> > +{
> > +	char *buf;
> > +	int ret;
> > +
> > +	buf = malloc(genlen + 1);
> > +	if (!buf)
> > +		return -1;
> > +
> > +	ret = keyctl_dh_compute_kdf(private, prime, base, kdfname, otherinfo,
> > +				    otherinfolen, buf, genlen);
> > +	if (ret < 0) {
> > +		free(buf);
> > +		return -1;
> > +	}
> > +
> > +	buf[ret] = 0;
> > +	*_buffer = buf;
> > +	return ret;
> > +}
> > +
> > +/*
> > 
> >  * Depth-first recursively apply a function over a keyring tree
> >  */
> > 
> > static int recursive_key_scan_aux(key_serial_t parent, key_serial_t key,
> > diff --git a/keyutils.h b/keyutils.h
> > index b321aa8..d5abd92 100644
> > --- a/keyutils.h
> > +++ b/keyutils.h
> > @@ -108,6 +108,13 @@ struct keyctl_dh_params {
> > 
> > 	key_serial_t base;
> > 
> > };
> > 
> > +struct keyctl_kdf_params {
> > +	char *kdfname;
> > +	char *otherinfo;
> > +	uint32_t otherinfolen;
> > +	uint32_t __spare[8];
> > +};
> > +
> > /*
> > 
> >  * syscall wrappers
> >  */
> > 
> > @@ -163,6 +170,10 @@ extern long keyctl_invalidate(key_serial_t id);
> > extern long keyctl_get_persistent(uid_t uid, key_serial_t id);
> > extern long keyctl_dh_compute(key_serial_t private, key_serial_t prime,
> > 
> > 			      key_serial_t base, char *buffer, size_t buflen);
> > 
> > +extern long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t
> > prime, +				  key_serial_t base, char *kdfname,
> > +				  char *otherinfo, size_t otherinfolen,
> > +				  char *buffer, size_t buflen);
> > 
> > /*
> > 
> >  * utilities
> > 
> > @@ -172,6 +183,10 @@ extern int keyctl_read_alloc(key_serial_t id, void
> > **_buffer); extern int keyctl_get_security_alloc(key_serial_t id, char
> > **_buffer); extern int keyctl_dh_compute_alloc(key_serial_t private,
> > key_serial_t prime,> 
> > 				   key_serial_t base, void **_buffer);
> > 
> > +extern int keyctl_dh_compute_kdf_alloc(key_serial_t private, key_serial_t
> > prime, +				       key_serial_t base, size_t genlen,
> > +				       char *kdfname, char *otherinfo,
> > +				       size_t otherinfolen, void **_buffer);
> > 
> > typedef int (*recursive_key_scanner_t)(key_serial_t parent, key_serial_t
> > key,> 
> > 				       char *desc, int desc_len, void *data);
> > 
> > diff --git a/man/keyctl_dh_compute_kdf.3 b/man/keyctl_dh_compute_kdf.3
> > new file mode 100644
> > index 0000000..06e2b29
> > --- /dev/null
> > +++ b/man/keyctl_dh_compute_kdf.3
> 
> My vote is to include this content in keyctl_dh_compute.3 instead of
> adding a separate man page.

Ok, I will move that into the existing man page.

Ciao
Stephan
