From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC v4 1/4] MPILIB: add mpi_read_buf(), mpi_copy() and mpi_get_size() helpers
Date: Fri, 12 Jun 2015 18:21:11 +0200
Message-ID: <8104647.vddsXnptAF@tauon.atsec.com>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1> <20150611190538.31826.97258.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150611190538.31826.97258.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 11. Juni 2015, 12:05:38 schrieb Tadeusz Struk:

Hi Tadeusz,

>+ */
>+void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
>+{
>+       uint8_t *buf, *p;
>+       int n, ret;
>+
>+       if (!nbytes)
>+               return NULL;
>+
>+       n = mpi_get_size(a);

Shouldn't n be unsigned int?


Ciao
Stephan
