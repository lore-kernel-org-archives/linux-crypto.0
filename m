From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: add buffer overflow checks to testmgr
Date: Fri, 5 Jun 2009 17:02:40 +1000
Message-ID: <20090605070240.GA7650@gondor.apana.org.au>
References: <200905291132.55848.jarod@redhat.com> <20090529221055.GA17957@gondor.apana.org.au> <200906041759.37762.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755805AbZFEHCz@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200906041759.37762.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 04, 2009 at 05:59:36PM -0400, Jarod Wilson wrote:
> 
> One note... This is actually causing some new compile warnings to be
> spit out, varies from arch to arch, dependent on page size... ppc64
> with 64k pages is the worst offender:
> 
> crypto/testmgr.c: In function 'test_nhash':
> crypto/testmgr.c:194: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_aead':
> crypto/testmgr.c:374: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c:375: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_cipher':
> crypto/testmgr.c:676: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_skcipher':
> crypto/testmgr.c:771: warning: comparison is always false due to limited range of data type

Don't worry, this warning will go away as soon as you move to a
more up-to-date gcc :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
