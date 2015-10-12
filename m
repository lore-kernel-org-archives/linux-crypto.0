From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: unaligned access in pkcs7_verify
Date: Mon, 12 Oct 2015 21:32:09 +0800
Message-ID: <20151012133209.GA27746@gondor.apana.org.au>
References: <20151002140014.GI18263@oracle.com>
 <20151008131519.GA24362@gondor.apana.org.au>
 <20151008144343.GE19655@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39171 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbJLNcS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 09:32:18 -0400
Content-Disposition: inline
In-Reply-To: <20151008144343.GE19655@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2015 at 10:43:43AM -0400, Sowmini Varadhan wrote:
> On (10/08/15 21:15), Herbert Xu wrote:
> > >         desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > > -       sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
> > > +       sinfo->sig.digest_size = digest_size = 
> > > +               ALIGN(crypto_shash_digestsize(tfm), sizeof (*desc));
>   :
> > What hash algorithm were you using?
> 
> Algorithm is sha1. From printk, crypto_shash_descsize(tfm) comes out
> to 0x60, digest_size to 0x14. Stack trace (for each modprobe [-r]) is 
> 
> 	pkcs7_verify+0x1d0/0x5e0
> 	system_verify_data+0x54/0xb4
> 	mod_verify_sig+0xa0/0xc4
> 	load_module+0x48/0x16a0
> 	SyS_init_module+0x114/0x128
> 	linux_sparc_syscall+0x34/0x44

Thanks.  We have two bugs here.  First of all pkcs7_verify definitely
shouldn't place the structure after the digest without aligning the
pointer.  So something like your patch is needed (but please use
alignof instead of sizeof).  Also don't put in digest_size but
instead align the pointer like

	desc = PTR_ALIGN(digest + digest_size, ...)

The sparc sha algorithms themselves need to declare the alignment
that they require.  Currently they claim to be able to handle any
alignment which appears to not be the case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
