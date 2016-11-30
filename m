From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v4 1/1] crypto: add virtio-crypto driver
Date: Wed, 30 Nov 2016 11:09:32 +0000
Message-ID: <20161130110932.GC2497@stefanha-x1.localdomain>
References: <1480423694-41736-1-git-send-email-arei.gonglei@huawei.com>
	<1480423694-41736-2-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0485022168443710780=="
Cc: virtio-dev@lists.oasis-open.org, weidong.huang@huawei.com,
	claudio.fontana@huawei.com, mst@redhat.com,
	qemu-devel@nongnu.org, hanweidong@huawei.com,
	luonengjun@huawei.com, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	salvatore.benedetto@intel.com, xuquan8@huawei.com,
	linux-crypto@vger.kernel.org, jianjay.zhou@huawei.com,
	longpeng2@huawei.com, arei.gonglei@hotmail.com,
	davem@davemloft.net, wu.wubin@huawei.com, herbert@gondor.apana.org.au
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1480423694-41736-2-git-send-email-arei.gonglei@huawei.com>
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


--===============0485022168443710780==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 29, 2016 at 08:48:14PM +0800, Gonglei wrote:
> diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
> new file mode 100644
> index 0000000..08b077f
> --- /dev/null
> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> @@ -0,0 +1,518 @@
> + /* Algorithms supported by virtio crypto device
> +  *
> +  * Authors: Gonglei <arei.gonglei@huawei.com>
> +  *
> +  * Copyright 2016 HUAWEI TECHNOLOGIES CO., LTD.
> +  *
> +  * This program is free software; you can redistribute it and/or modify
> +  * it under the terms of the GNU General Public License as published by
> +  * the Free Software Foundation; either version 2 of the License, or
> +  * (at your option) any later version.
> +  *
> +  * This program is distributed in the hope that it will be useful,
> +  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  * GNU General Public License for more details.
> +  *
> +  * You should have received a copy of the GNU General Public License
> +  * along with this program; if not, see <http://www.gnu.org/licenses/>.
> +  */
> +
> +#include <linux/scatterlist.h>
> +#include <crypto/algapi.h>
> +#include <linux/err.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/atomic.h>
> +
> +#include <uapi/linux/virtio_crypto.h>
> +#include "virtio_crypto_common.h"
> +
> +static DEFINE_MUTEX(algs_lock);

Did you run checkpatch.pl?  I think it encourages you to document what
the lock protects.

> +static int virtio_crypto_alg_ablkcipher_init_session(
> +		struct virtio_crypto_ablkcipher_ctx *ctx,
> +		uint32_t alg, const uint8_t *key,
> +		unsigned int keylen,
> +		int encrypt)
> +{
> +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
> +	unsigned int tmp;
> +	struct virtio_crypto *vcrypto = ctx->vcrypto;
> +	int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT : VIRTIO_CRYPTO_OP_DECRYPT;
> +	int err;
> +	unsigned int num_out = 0, num_in = 0;
> +
> +	/*
> +	 * Avoid to do DMA from the stack, switch to using
> +	 * dynamically-allocated for the key
> +	 */
> +	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
> +
> +	if (!cipher_key)
> +		return -ENOMEM;
> +
> +	memcpy(cipher_key, key, keylen);

Are there any rules on handling key material in the kernel?  This buffer
is just kfreed later.  Do you need to zero it out before freeing it?

> +
> +	spin_lock(&vcrypto->ctrl_lock);

The QAT accelerator driver doesn't spin while talking to the device in
virtio_crypto_alg_ablkcipher_init_session().  I didn't find any other
driver examples in the kernel tree, but this function seems like a
weakness in the virtio-crypto device.

While QEMU is servicing the create session command this vcpu is blocked.
The QEMU global mutex is held so no other vcpu can enter QEMU and the
QMP monitor is also blocked.

This is a scalability and performance problem.  Can you look at how QAT
avoids this synchronous session setup?

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJYPrNrAAoJEJykq7OBq3PIpTYIAJ+dE1sD0cRA8ULdgETvQ2OR
rxjdwu6KlAzqnh51ntqwMpEOB1zrMwNFsHpxF20Kgq2KHqGqsW53h3g6eBMqQ8zo
8yIinj0TZc921WAvdYcqp//+gcczU4n3gQcnIGk3ZQmO9ql3yF13wYNpt3qGda4k
HoJSOjdNI+p+sx4uFWjc5rOJkBoIDKL/P8jf229PdwpmsCfmGsNd3ZPMgFpQpfYl
OCFvEzJqbnKgBtAtp8UCxDmZTLe6N/KW6cN/nBuTeCX19CQg1zFqrT9c44fF0E+J
bO7lEfZWErh+fa2UPs4jN3STMzHB2Cfj6UUGJIERP+ck9XdhgoQduK4YHMEQ2aQ=
=a9Y4
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--

--===============0485022168443710780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============0485022168443710780==--
