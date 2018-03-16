From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: virtio - remove dependency on CRYPTO_AUTHENC
Date: Fri, 16 Mar 2018 23:56:01 +0800
Message-ID: <20180316155601.GF7095@gondor.apana.org.au>
References: <20180306235315.11550-1-peter@lekensteyn.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: virtualization@lists.linux-foundation.org, linux-crypto@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180306235315.11550-1-peter@lekensteyn.nl>
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

On Wed, Mar 07, 2018 at 12:53:15AM +0100, Peter Wu wrote:
> virtio_crypto does not use function crypto_authenc_extractkeys, remove
> this unnecessary dependency. Compiles fine and passes cryptodev-linux
> cipher and speed tests from https://wiki.qemu.org/Features/VirtioCrypto
> 
> Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
