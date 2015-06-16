From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC v7 2/3] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 23:10:57 +0100
Message-ID: <18687.1434492657@warthog.procyon.org.uk>
References: <20150616173101.1248.55033.stgit@tstruk-mobl1> <20150616173050.1248.21847.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150616173101.1248.55033.stgit@tstruk-mobl1>
Content-ID: <18686.1434492657.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
> +{
> +	/* (1) Validate 0 <= m < n */
> +	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
> +		return -EINVAL;

Why -EINVAL not -EBADMSG?

David
