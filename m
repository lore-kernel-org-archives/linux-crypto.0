From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Wed, 13 May 2015 16:03:55 +0100
Message-ID: <12222.1431529435@warthog.procyon.org.uk>
References: <20150512012158.GA13237@gondor.apana.org.au> <20150511062421.GA2266@gondor.apana.org.au> <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1> <11243.1431351927@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150512012158.GA13237@gondor.apana.org.au>
Content-ID: <12221.1431529435.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > What if the fallback doesn't exist?  For instance, a H/W contained key is
> > specifically limited to, say, just sign/verify and the not permitted to be
> > used for encrypt/decrypt.  How do you provide a fallback given you can't get
> > at the key?
> 
> That's a transform with a specific key.  I don't see why such a
> piece of hardware would even need to be exposed through the crypto
> API which is about generic implementations that can take any
> arbitrary key.

So what if we want to use a key that's stored in a TPM?  I presume then we
can't use the crypto interface, but must rather use the *key* as the primary
interface somehow.

David
