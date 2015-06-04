From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v3 2/3] crypto: RSA: KEYS: convert rsa and public
 key to new PKE API
Date: Thu, 04 Jun 2015 10:23:30 -0700
Message-ID: <55708992.4090100@intel.com>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1> <20150603224414.22310.17260.stgit@tstruk-mobl1> <20150604065333.GB22158@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150604065333.GB22158@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/03/2015 11:53 PM, Herbert Xu wrote:
> I'd like to see this split into multiple patches.  First of all
> the new crypto_akcipher implementation should coexist with the
> existing code.  That way the exiting users can be converted over
> one-by-one.
> 
> Also you should implement the crypto_akcipher completely before
> converting anybody over, that means doing encoding/wrapping in
> addition to the crypto.
> 
> That way we don't have to have craziness like converting in and
> out of MPI multiple times.

That's cool. It will make it easier for me. I wanted to convert
one to show that the interface is working.

> 
> Lastly you should consider adding an MPI helper that writes to
> an existing buffer instead of allocating a new one and copying
> it over.

I'll think about something.
