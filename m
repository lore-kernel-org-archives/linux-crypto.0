From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
Date: Sat, 15 Oct 2011 11:28:15 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com> <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:

> +MPI mpi_alloc(unsigned nlimbs)
> +{
> +	MPI a;
> +
> +	a = (MPI) kmalloc(sizeof *a, GFP_KERNEL);

Generally, typedef structs are frowned upon in the kernel.  I'd prefer to 
see this (and any others) changed to a normal type.

Also, kmalloc return values do not need to be cast, they're void *.

> +EXPORT_SYMBOL(mpi_alloc);

New interfaces should be EXPORT_SYMBOL_GPL.


-- 
James Morris
<jmorris@namei.org>
