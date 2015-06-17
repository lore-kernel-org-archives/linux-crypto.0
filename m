From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v7 2/3] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 19:46:30 -0700
Message-ID: <5580DF86.3010502@intel.com>
References: <20150616173101.1248.55033.stgit@tstruk-mobl1> <20150616173050.1248.21847.stgit@tstruk-mobl1> <18687.1434492657@warthog.procyon.org.uk> <5580DC30.4030301@intel.com> <20150617023630.GA7791@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150617023630.GA7791@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/16/2015 07:36 PM, Herbert Xu wrote:
> The existing crypto/asymmetric_key errno scheme doesn't really
> mesh in with the rest of crypto.  So you'll just have to pick one
> scheme and stick with it.
> 
> I don't really mind either way as long as the error codes are
> unique and meaningful.

So I would use -EINVAL since these are input parameters. Do you agree David?
