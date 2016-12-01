From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v4 1/1] crypto: add virtio-crypto driver
Date: Thu, 1 Dec 2016 02:27:19 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14EC02@DGGEMA505-MBX.china.huawei.com>
References: <1480423694-41736-1-git-send-email-arei.gonglei@huawei.com>
 <1480423694-41736-2-git-send-email-arei.gonglei@huawei.com>
 <20161130110932.GC2497@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@h
To: Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg01-dlp ([45.249.212.187]:2301 "EHLO dggrg01-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754688AbcLAC2C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 21:28:02 -0500
In-Reply-To: <20161130110932.GC2497@stefanha-x1.localdomain>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stefan,

> 
> On Tue, Nov 29, 2016 at 08:48:14PM +0800, Gonglei wrote:
> > diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c
> b/drivers/crypto/virtio/virtio_crypto_algs.c
> > new file mode 100644
> > index 0000000..08b077f
> > --- /dev/null
> > +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> > @@ -0,0 +1,518 @@
> > + /* Algorithms supported by virtio crypto device
> > +  *
> > +  * Authors: Gonglei <arei.gonglei@huawei.com>
> > +  *
> > +  * Copyright 2016 HUAWEI TECHNOLOGIES CO., LTD.
> > +  *
> > +  * This program is free software; you can redistribute it and/or modify
> > +  * it under the terms of the GNU General Public License as published by
> > +  * the Free Software Foundation; either version 2 of the License, or
> > +  * (at your option) any later version.
> > +  *
> > +  * This program is distributed in the hope that it will be useful,
> > +  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +  * GNU General Public License for more details.
> > +  *
> > +  * You should have received a copy of the GNU General Public License
> > +  * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > +  */
> > +
> > +#include <linux/scatterlist.h>
> > +#include <crypto/algapi.h>
> > +#include <linux/err.h>
> > +#include <crypto/scatterwalk.h>
> > +#include <linux/atomic.h>
> > +
> > +#include <uapi/linux/virtio_crypto.h>
> > +#include "virtio_crypto_common.h"
> > +
> > +static DEFINE_MUTEX(algs_lock);
> 
> Did you run checkpatch.pl?  I think it encourages you to document what
> the lock protects.
> 
Sure. Basically I run checkpatch.py each time. :)

# ./scripts/checkpatch.pl 0001-crypto-add-virtio-crypto-driver.patch 
total: 0 errors, 0 warnings, 1873 lines checked

0001-crypto-add-virtio-crypto-driver.patch has no obvious style problems and is ready for submission.

> > +static int virtio_crypto_alg_ablkcipher_init_session(
> > +		struct virtio_crypto_ablkcipher_ctx *ctx,
> > +		uint32_t alg, const uint8_t *key,
> > +		unsigned int keylen,
> > +		int encrypt)
> > +{
> > +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
> > +	unsigned int tmp;
> > +	struct virtio_crypto *vcrypto = ctx->vcrypto;
> > +	int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT :
> VIRTIO_CRYPTO_OP_DECRYPT;
> > +	int err;
> > +	unsigned int num_out = 0, num_in = 0;
> > +
> > +	/*
> > +	 * Avoid to do DMA from the stack, switch to using
> > +	 * dynamically-allocated for the key
> > +	 */
> > +	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
> > +
> > +	if (!cipher_key)
> > +		return -ENOMEM;
> > +
> > +	memcpy(cipher_key, key, keylen);
> 
> Are there any rules on handling key material in the kernel?  This buffer
> is just kfreed later.  Do you need to zero it out before freeing it?
> 
Good questions. For kernel crypto core, each cipher request should be freed
by skcipher_request_free(): zeroize and free request data structure.

I need to use kzfree() for key as well. I'll also check other stuffs. Thanks. 

> > +
> > +	spin_lock(&vcrypto->ctrl_lock);
> 
> The QAT accelerator driver doesn't spin while talking to the device in
> virtio_crypto_alg_ablkcipher_init_session().  I didn't find any other
> driver examples in the kernel tree, but this function seems like a
> weakness in the virtio-crypto device.
> 
The control queues of virtio-net and virtio-console are also be locked
Please see:
 __send_control_msg() in virtio_console.c and virtio-net's control queue
protected by rtnl lock.

I didn't want to protect session creations but the virtqueue's operations
like what other virtio devices do.

> While QEMU is servicing the create session command this vcpu is blocked.
> The QEMU global mutex is held so no other vcpu can enter QEMU and the
> QMP monitor is also blocked.
> 
> This is a scalability and performance problem.  Can you look at how QAT
> avoids this synchronous session setup?

For QAT driver, the session creation is synchronous as well because it's a
plain software operation which can be completed ASAP.

Regards,
-Gonglei
