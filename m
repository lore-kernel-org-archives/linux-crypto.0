From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH RFC 1/4] crypto: engine - Permit to enqueue all async
	requests
Date: Fri, 22 Dec 2017 10:34:18 +0100
Message-ID: <20171222093418.GB3024@Red>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
	<20171129084121.9385-2-clabbe.montjoie@gmail.com>
	<20171222065724.GA27149@gondor.apana.org.au>
	<20171222084148.GA3024@Red>
	<20171222090603.GB32542@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: alexandre.torgue@st.com, mst@redhat.com, linux-kernel@vger.kernel.org,
	fabien.dessenne@st.com, virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org, mcoquelin.stm32@gmail.com,
	davem@davemloft.net, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20171222090603.GB32542@gondor.apana.org.au>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 22, 2017 at 08:06:03PM +1100, Herbert Xu wrote:
> On Fri, Dec 22, 2017 at 09:41:48AM +0100, Corentin Labbe wrote:
> >
> > It's you that was suggesting using crypto_async_request:
> > https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html
> > "The only wart with this scheme is that the drivers end up seeing
> > struct crypto_async_request and will need to convert that to the
> > respective request types but I couldn't really find a better way."
> > 
> > So I wait for any suggestion.
> 
> The core engine code obviously will use the base type but it should
> not be exposed to the driver authors.  IOW all exposed API should
> take the final types such as aead_request before casting it.
> 

For driver->engine calls(crypto_finalize_request/crypto_transfer_request_to_engine) it's easy.

But I do not see how to do it for crypto_engine_op appart re-introducing the big if/then/else that
you didnt want.
Or do you agree to set the request parameter for crypto_engine_op(prepare_request/unprepare_request/do_one_request) to void * ?

Regards
