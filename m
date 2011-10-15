From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2.1 4/7] crypto: GnuPG based MPI lib - additional sources
 (part 4)
Date: Sat, 15 Oct 2011 11:34:00 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1110151132430.24994@tundra.namei.org>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com> <81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:

> +#if 0				/* not yet ported to MPI */
> +
> +mpi_limb_t
> +mpihelp_udiv_w_sdiv(mpi_limp_t *rp,
> +		    mpi_limp_t *a1, mpi_limp_t *a0, mpi_limp_t *d)

Drop this if it's not working.


-- 
James Morris
<jmorris@namei.org>
