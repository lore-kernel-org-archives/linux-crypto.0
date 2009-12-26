From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Sat, 26 Dec 2009 13:41:46 -0800
Message-ID: <20091226214146.GA4904@ovro.caltech.edu>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
	<20091216164144.daff5468.kim.phillips@freescale.com>
	<2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
	<4B296394.9010709@intel.com>
	<20091217170958.GE18271@ovro.caltech.edu>
	<4B2A6DFA.6000504@intel.com>
	<3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
	<e9c3a7c20912181417v2b8155e5w23fb3cee02b9a4c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, Suresh Vishnu-B05022 <B05022@freescale.com>,
	Tabi Timur-B04825 <B04825@freescale.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	Gupta Maneesh-B18878 <B18878@freescale.com>,
	Dudhat Dipen-B09055 <B09055@freescale.com>,
	Li Yang-R58472 <r58472@freescale.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20912181417v2b8155e5w23fb3cee02b9a4c9@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 18, 2009 at 03:17:42PM -0700, Dan Williams wrote:
> On Fri, Dec 18, 2009 at 8:02 AM, Li Yang-R58472 <r58472@freescale.com> wr=
ote:
> >
> >>Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for
> >>Async_tx XOR offload
> >>
> >>Ira W. Snyder wrote:
> >>> Yes, I have used the device_prep_dma_interrupt()
> >>functionality quite a
> >>> while back. However, I found it to be pretty much useless.
> >>
> >>The specific case it is needed for Talitos/raid is a channel
> >>switch interrupt. =A0The interrupt causes the cleanup operation
> >>to be run which will kick off any pending dependent operations
> >>on the xor channel. =A0In the raid case we only have callbacks
> >>at the end of a chain, so we need the interrupt to kick the
> >>engine in an operation chain like
> >>xor->copy->xor->callback.
> >
> > I am wondering if can use more callbacks to kick off pending dependent =
operations?
> > Like xor->callback->copy->callback->xor->callback?
> >
> =

> No, the callback field is reserved for clients of the api.  What you want=
 is:
> =

> xor->cleanupT->copy->cleanupF->xor->cleanupT->callback
> =

> Where cleanupT is the Talitos descriptor cleanup routine and cleanupF
> is from fsldma.  The assumption is that the interrupt kicks the
> cleanup routine and that calls dma_run_dependencies().
> =


Hello Dan,

I guess it is not clear to driver authors that they should call
dma_run_dependencies() for each dma_async_tx_descriptor that is
processed. Without a careful re-reading of this email, I would not have
known. I guess anyone reviewing the driver missed it too. Judging by the
code in other drivers, it should be called immediately after calling the
callback function. The fsldma driver doesn't even call the function at
the moment.

To the people testing fsldma with talitos: you should probably try
adding a call to dma_run_dependencies() in the fsl_chan_ld_cleanup()
function. Then run your tests again, and see if the interoperability
problems are fixed.

I'm still working through a cleanup patch series. There are some places
where the locking doesn't seem right to me, and I'll be attempting to
fix those as I go through the driver.

Ira
