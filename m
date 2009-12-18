From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Fri, 18 Dec 2009 15:17:42 -0700
Message-ID: <e9c3a7c20912181417v2b8155e5w23fb3cee02b9a4c9@mail.gmail.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
	<20091216164144.daff5468.kim.phillips@freescale.com>
	<2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
	<4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
	<4B2A6DFA.6000504@intel.com>
	<3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, "Ira W. Snyder" <iws@ovro.caltech.edu>,
	Suresh Vishnu-B05022 <B05022@freescale.com>,
	Tabi Timur-B04825 <B04825@freescale.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	Gupta Maneesh-B18878 <B18878@freescale.com>,
	Dudhat Dipen-B09055 <B09055@freescale.com>
To: Li Yang-R58472 <r58472@freescale.com>
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
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

On Fri, Dec 18, 2009 at 8:02 AM, Li Yang-R58472 <r58472@freescale.com> wrot=
e:
>
>>Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for
>>Async_tx XOR offload
>>
>>Ira W. Snyder wrote:
>>> Yes, I have used the device_prep_dma_interrupt()
>>functionality quite a
>>> while back. However, I found it to be pretty much useless.
>>
>>The specific case it is needed for Talitos/raid is a channel
>>switch interrupt. =A0The interrupt causes the cleanup operation
>>to be run which will kick off any pending dependent operations
>>on the xor channel. =A0In the raid case we only have callbacks
>>at the end of a chain, so we need the interrupt to kick the
>>engine in an operation chain like
>>xor->copy->xor->callback.
>
> I am wondering if can use more callbacks to kick off pending dependent op=
erations?
> Like xor->callback->copy->callback->xor->callback?
>

No, the callback field is reserved for clients of the api.  What you want i=
s:

xor->cleanupT->copy->cleanupF->xor->cleanupT->callback

Where cleanupT is the Talitos descriptor cleanup routine and cleanupF
is from fsldma.  The assumption is that the interrupt kicks the
cleanup routine and that calls dma_run_dependencies().

--
Dan
