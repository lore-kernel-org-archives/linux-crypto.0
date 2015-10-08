From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: unaligned access in pkcs7_verify
Date: Thu, 8 Oct 2015 10:43:43 -0400
Message-ID: <20151008144343.GE19655@oracle.com>
References: <20151002140014.GI18263@oracle.com>
 <20151008131519.GA24362@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbbJHOny (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 10:43:54 -0400
Content-Disposition: inline
In-Reply-To: <20151008131519.GA24362@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (10/08/15 21:15), Herbert Xu wrote:
> >         desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > -       sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
> > +       sinfo->sig.digest_size = digest_size = 
> > +               ALIGN(crypto_shash_digestsize(tfm), sizeof (*desc));
  :
> What hash algorithm were you using?

Algorithm is sha1. From printk, crypto_shash_descsize(tfm) comes out
to 0x60, digest_size to 0x14. Stack trace (for each modprobe [-r]) is 

	pkcs7_verify+0x1d0/0x5e0
	system_verify_data+0x54/0xb4
	mod_verify_sig+0xa0/0xc4
	load_module+0x48/0x16a0
	SyS_init_module+0x114/0x128
	linux_sparc_syscall+0x34/0x44

--Sowmini
