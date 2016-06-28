From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] crypto: SHA512 multibuffer implementation
Date: Tue, 28 Jun 2016 16:37:11 +0800
Message-ID: <20160628083711.GB15985@gondor.apana.org.au>
References: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 27, 2016 at 10:20:03AM -0700, Megha Dey wrote:
> From: Megha Dey <megha.dey@linux.intel.com>
>=20
> In this patch series, we introduce the multi-buffer crypto algorithm =
on
> x86_64 and apply it to SHA512 hash computation.  The multi-buffer tec=
hnique
> takes advantage of the 8 data lanes in the AVX2 registers and allows
> computation to be performed on data from multiple jobs in parallel.
> This allows us to parallelize computations when data inter-dependency=
 in
> a single crypto job prevents us to fully parallelize our computations=
=2E
> The algorithm can be extended to other hashing and encryption schemes
> in the future.
>=20
> On multi-buffer SHA512 computation with AVX2, we see throughput incre=
ase
> up to 2x over the existing x86_64 single buffer AVX2 algorithm.
>=20
> The multi-buffer crypto algorithm is described in the following paper=
:
> Processing Multiple Buffers in Parallel to Increase Performance on
> Intel=AE Architecture Processors
> http://www.intel.com/content/www/us/en/communications/communications-=
ia-multi-buffer-paper.html
>=20
> The outline of the algorithm is sketched below:
> Any driver requesting the crypto service will place an async
> crypto request on the workqueue.  The multi-buffer crypto daemon will
> pull request from work queue and put each request in an empty data la=
ne
> for multi-buffer crypto computation.  When all the empty lanes are fi=
lled,
> computation will commence on the jobs in parallel and the job with th=
e
> shortest remaining buffer will get completed and be returned.  To pre=
vent
> prolonged stall when there is no new jobs arriving, we will flush a c=
rypto
> job if it has not been completed after a maximum allowable delay.
>=20
> The multi-buffer algorithm necessitates mapping multiple scatter gath=
er
> buffers to linear addresses simultaneously. The crypto daemon may nee=
d
> to sleep and yield the cpu to work on something else from time to tim=
e.
> We made a change to not use kmap_atomic to do scatter-gather buffer
> mapping and take advantage of the fact that we can directly translate
> address the buffer's address to its linear address with x86_64.
> To accommodate the fragmented nature of scatter-gather, we will keep
> submitting the next scatter-buffer fragment for a job for multi-buffe=
r
> computation until a job is completed and no more buffer fragments rem=
ain.
> At that time we will pull a new job to fill the now empty data slot.
> We call a get_completed_job function to check whether there are other
> jobs that have been completed when we job when we have no new job arr=
ival
> to prevent extraneous delay in returning any completed jobs.
>=20
> The multi-buffer algorithm should be used for cases where crypto jobs
> submissions are at a reasonable high rate.  For low crypto job submis=
sion
> rate, this algorithm will not be beneficial. The reason is at low rat=
e,
> we do not fill out the data lanes before the maximum allowable latenc=
y,
> we will be flushing the jobs instead of processing them with all the
> data lanes full.  We will miss the benefit of parallel computation,
> and adding delay to the processing of the crypto job at the same time=
=2E
> Some tuning of the maximum latency parameter may be needed to get the
> best performance.
>=20
> Also added, is a new mode in the tcrypt modules to calculate the spee=
d of the
> sha512_mb algorithm.

All applied.  Thanks.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
