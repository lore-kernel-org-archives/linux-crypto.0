From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: Re: [PATCH] crypto: add virtio-crypto driver
Date: Thu, 17 Nov 2016 15:55:48 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031A12767@IRSMSX102.ger.corp.intel.com>
References: <1479106074-32036-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
	"weidong.huang@huawei.com" <weidong.huang@huawei.com>,
	"claudio.fontana@huawei.com" <claudio.fontana@huawei.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"luonengjun@huawei.com" <luonengjun@huawei.com>,
	"hanweidong@huawei.com" <hanweidong@huawei.com>, "Zeng,
	Xin" <xin.zeng@intel.com>,
	"peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>,
	"xuquan8@huawei.com" <xuquan8@huawei.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>,
	"jianjay.zhou@huawei.com" <jianjay.zhou@huawei.com>,
	"cornelia.huck@de.ibm.com" <cornelia.huck@de.ibm.com>,
	"arei.gonglei@hotmail.com" <arei.gonglei@hotmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"wu.wubin@huawei.com" <wu.wubin@huawei.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Gonglei <arei.gonglei@huawei.com>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, "virtio-dev@lists.oasis-open.org"
	<virtio-dev@lists.oasis-open.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1479106074-32036-1-git-send-email-arei.gonglei@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Id: linux-crypto.vger.kernel.org

Hi Gonglei,

...
> +
> +static int virtio_crypto_alg_ablkcipher_init_session(
> +		struct virtio_crypto_ablkcipher_ctx *ctx,
> +		int alg, const uint8_t *key,
> +		unsigned int keylen,
> +		int encrypt)
> +{
> +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
> +	unsigned int tmp;
> +	struct virtio_crypto_session_input input;
> +	struct virtio_crypto_op_ctrl_req ctrl;
> +	struct virtio_crypto *vcrypto =3D ctx->vcrypto;
> +	int op =3D encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT :
> VIRTIO_CRYPTO_OP_DECRYPT;
> +	int err;
> +	unsigned int num_out =3D 0, num_in =3D 0;
> +
> +	memset(&ctrl, 0, sizeof(ctrl));
> +	memset(&input, 0, sizeof(input));
> +	/* Pad ctrl header */
> +	ctrl.header.opcode =3D
> cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
> +	ctrl.header.algo =3D cpu_to_le32((uint32_t)alg);
> +	/* Set the default dataqueue id to 0 */
> +	ctrl.header.queue_id =3D 0;
> +
> +	input.status =3D cpu_to_le32(VIRTIO_CRYPTO_ERR);
> +	/* Pad cipher's parameters */
> +	ctrl.u.sym_create_session.op_type =3D
> +		cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
> +	ctrl.u.sym_create_session.u.cipher.para.algo =3D ctrl.header.algo;
> +	ctrl.u.sym_create_session.u.cipher.para.keylen =3D
> cpu_to_le32(keylen);
> +	ctrl.u.sym_create_session.u.cipher.para.op =3D cpu_to_le32(op);
> +
> +	sg_init_one(&outhdr, &ctrl, sizeof(ctrl));

I believe this won't work when the new virtually-mapped kernel stack (VMAP_=
STACK)
is enabled.

Regards,
Salvatore
