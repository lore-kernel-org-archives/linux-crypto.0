From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/4] crypto: engine - Permit to enqueue all async
	requests
Date: Fri, 22 Dec 2017 20:06:03 +1100
Message-ID: <20171222090603.GB32542@gondor.apana.org.au>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
	<20171129084121.9385-2-clabbe.montjoie@gmail.com>
	<20171222065724.GA27149@gondor.apana.org.au>
	<20171222084148.GA3024@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: alexandre.torgue@st.com, mst@redhat.com, linux-kernel@vger.kernel.org,
	fabien.dessenne@st.com, virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org, mcoquelin.stm32@gmail.com,
	davem@davemloft.net, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20171222084148.GA3024@Red>
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

On Fri, Dec 22, 2017 at 09:41:48AM +0100, Corentin Labbe wrote:
>
> It's you that was suggesting using crypto_async_request:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html
> "The only wart with this scheme is that the drivers end up seeing
> struct crypto_async_request and will need to convert that to the
> respective request types but I couldn't really find a better way."
> 
> So I wait for any suggestion.

The core engine code obviously will use the base type but it should
not be exposed to the driver authors.  IOW all exposed API should
take the final types such as aead_request before casting it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
