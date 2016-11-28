From: Halil Pasic <pasic@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Mon, 28 Nov 2016 18:37:01 +0100
Message-ID: <e49c3cba-2d34-d2d2-28f1-6e192d4ad6b1@linux.vnet.ibm.com>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
	<1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
	<20161128162055.GB11196@stefanha-x1.localdomain>
	<20161128185747-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: virtio-dev@lists.oasis-open.org, xuquan8@huawei.com,
	weidong.huang@huawei.com, claudio.fontana@huawei.com,
	"Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org, hanweidong@huawei.com,
	luonengjun@huawei.com, qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, jianjay.zhou@huawei.com,
	longpeng2@huawei.com, arei.gonglei@hotmail.com,
	davem@davemloft.net, wu.wubin@huawei.com, herbert@gondor.apana.org.au
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20161128185747-mutt-send-email-mst@kernel.org>
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



On 11/28/2016 06:19 PM, Michael S. Tsirkin wrote:
>>> +static int virtio_crypto_alg_ablkcipher_init_session(
>>> > > +		struct virtio_crypto_ablkcipher_ctx *ctx,
>>> > > +		uint32_t alg, const uint8_t *key,
>>> > > +		unsigned int keylen,
>>> > > +		int encrypt)
>>> > > +{
>>> > > +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
>>> > > +	unsigned int tmp;
>>> > > +	struct virtio_crypto *vcrypto = ctx->vcrypto;
>>> > > +	int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT : VIRTIO_CRYPTO_OP_DECRYPT;
>>> > > +	int err;
>>> > > +	unsigned int num_out = 0, num_in = 0;
>>> > > +
>>> > > +	/*
>>> > > +	 * Avoid to do DMA from the stack, switch to using
>>> > > +	 * dynamically-allocated for the key
>>> > > +	 */
>>> > > +	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
>>> > > +
>>> > > +	if (!cipher_key)
>>> > > +		return -ENOMEM;
>>> > > +
>>> > > +	memcpy(cipher_key, key, keylen);
>>> > > +
>>> > > +	spin_lock(&vcrypto->ctrl_lock);
>>> > > +	/* Pad ctrl header */
>>> > > +	vcrypto->ctrl.header.opcode =
>>> > > +		cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
>>> > > +	vcrypto->ctrl.header.algo = cpu_to_le32(alg);
>>> > > +	/* Set the default dataqueue id to 0 */
>>> > > +	vcrypto->ctrl.header.queue_id = 0;
>>> > > +
>>> > > +	vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
>>> > > +	/* Pad cipher's parameters */
>>> > > +	vcrypto->ctrl.u.sym_create_session.op_type =
>>> > > +		cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
>>> > > +	vcrypto->ctrl.u.sym_create_session.u.cipher.para.algo =
>>> > > +		vcrypto->ctrl.header.algo;
>>> > > +	vcrypto->ctrl.u.sym_create_session.u.cipher.para.keylen =
>>> > > +		cpu_to_le32(keylen);
>>> > > +	vcrypto->ctrl.u.sym_create_session.u.cipher.para.op =
>>> > > +		cpu_to_le32(op);
>>> > > +
>>> > > +	sg_init_one(&outhdr, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
>>> > > +	sgs[num_out++] = &outhdr;
>>> > > +
>>> > > +	/* Set key */
>>> > > +	sg_init_one(&key_sg, cipher_key, keylen);
>>> > > +	sgs[num_out++] = &key_sg;
>>> > > +
>>> > > +	/* Return status and session id back */
>>> > > +	sg_init_one(&inhdr, &vcrypto->input, sizeof(vcrypto->input));
>>> > > +	sgs[num_out + num_in++] = &inhdr;
>>> > > +
>>> > > +	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
>>> > > +				num_in, vcrypto, GFP_ATOMIC);
>>> > > +	if (err < 0) {
>>> > > +		spin_unlock(&vcrypto->ctrl_lock);
>>> > > +		kfree(cipher_key);
>>> > > +		return err;
>>> > > +	}
>>> > > +	virtqueue_kick(vcrypto->ctrl_vq);
>>> > > +
>>> > > +	/*
>>> > > +	 * Spin for a response, the kick causes an ioport write, trapping
>>> > > +	 * into the hypervisor, so the request should be handled immediately.
>>> > > +	 */

I have my doubts about this comment (and about the code below too). Is
'kick causes an ioport write' true for every transport/architecture?
If we relay on this property maybe the documentation of notify should
mention it.

I know we have the same message in virtio-net.

>>> > > +	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &tmp) &&
>>> > > +	       !virtqueue_is_broken(vcrypto->ctrl_vq))
>>> > > +		cpu_relax();
> this spin under lock is kind of ugly.
> Why do we need to hold it while spinning?
> to prevent submitting more than one request?
> Isn't there a way to control this within crypto core?
> 
> unlock
> relax
> lock
> 
> would be better.
> 
>>> > > +
>>> > > +	if (le32_to_cpu(vcrypto->input.status) != VIRTIO_CRYPTO_OK) {
>>> > > +		spin_unlock(&vcrypto->ctrl_lock);
>>> > > +		pr_err("virtio_crypto: Create session failed status: %u\n",
>>> > > +			le32_to_cpu(vcrypto->input.status));
>>> > > +		kfree(cipher_key);
>>> > > +		return -EINVAL;
>>> > > +	}
>>> > > +	spin_unlock(&vcrypto->ctrl_lock);
>>> > > +
> You drop lock here. If someone is trying to submit multiple
> requests, then the below will be racy as it might overwrite
> new result with previous data.
> 

Was going to object on this too but Michael was faster.

Halil

>>> > > +	spin_lock(&ctx->lock);
>>> > > +	if (encrypt)
>>> > > +		ctx->enc_sess_info.session_id =
>>> > > +			le64_to_cpu(vcrypto->input.session_id);
>>> > > +	else
>>> > > +		ctx->dec_sess_info.session_id =
>>> > > +			le64_to_cpu(vcrypto->input.session_id);
>>> > > +	spin_unlock(&ctx->lock);
>>> > > +
>>> > > +	kfree(cipher_key);
>>> > > +	return 0;
>>> > > +}
>>> > > +
