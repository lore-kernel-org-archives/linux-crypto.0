From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 10:29:47 +0800
Message-ID: <20150616022947.GB19040@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
 <20150615235954.GC16562@gondor.apana.org.au>
 <557F883C.5040207@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <557F883C.5040207@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 15, 2015 at 07:21:48PM -0700, Tadeusz Struk wrote:
>
> I thought that the ctx needs to be available for implementations to store private data.
> This way we can allocate and store any type of key in the <alg>_parse_key() helper and still have the cxt
> available for implementations to use for their stuff (e.g. HW context).

No for symmetric key algorithms we always store the key in the
context and never in the tfm proper.

Think about it, the generic tfm doesn't have any idea on what
the key contains so how can it store it? Only the implementation
knows the key format and can store it in a useful way.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
