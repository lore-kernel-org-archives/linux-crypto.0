From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Mon, 11 May 2015 14:45:27 +0100
Message-ID: <11243.1431351927@warthog.procyon.org.uk>
References: <20150511062421.GA2266@gondor.apana.org.au> <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150511062421.GA2266@gondor.apana.org.au>
Content-ID: <11242.1431351927.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > + * @capabilities:
> > + *		Specifies what operations are provided by the algorithm
> > + *		implementation.
> 
> Don't do this.  It's a nightmare for the user to have to deal with
> multiple implementations with differing capabilities.
> 
> Make the implementor provide backups/fallbacks.

What if the fallback doesn't exist?  For instance, a H/W contained key is
specifically limited to, say, just sign/verify and the not permitted to be
used for encrypt/decrypt.  How do you provide a fallback given you can't get
at the key?

David
