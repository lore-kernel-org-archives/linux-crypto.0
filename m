From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v4 1/1] crypto: add virtio-crypto driver
Date: Thu, 1 Dec 2016 11:58:10 +0000
Message-ID: <20161201115810.GC10441@stefanha-x1.localdomain>
References: <1480423694-41736-1-git-send-email-arei.gonglei@huawei.com>
 <1480423694-41736-2-git-send-email-arei.gonglei@huawei.com>
 <20161130110932.GC2497@stefanha-x1.localdomain>
 <33183CC9F5247A488A2544077AF19020DA14EC02@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>, "mst@redhat.com" <mst@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <virtio-dev-return-1750-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA14EC02@DGGEMA505-MBX.china.huawei.com>
List-Id: linux-crypto.vger.kernel.org

--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2016 at 02:27:19AM +0000, Gonglei (Arei) wrote:
> > On Tue, Nov 29, 2016 at 08:48:14PM +0800, Gonglei wrote:
> > > +static int virtio_crypto_alg_ablkcipher_init_session(
> > > +		struct virtio_crypto_ablkcipher_ctx *ctx,
> > > +		uint32_t alg, const uint8_t *key,
> > > +		unsigned int keylen,
> > > +		int encrypt)
> > > +{
> > > +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
> > > +	unsigned int tmp;
> > > +	struct virtio_crypto *vcrypto =3D ctx->vcrypto;
> > > +	int op =3D encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT :
> > VIRTIO_CRYPTO_OP_DECRYPT;
> > > +	int err;
> > > +	unsigned int num_out =3D 0, num_in =3D 0;
> > > +
> > > +	/*
> > > +	 * Avoid to do DMA from the stack, switch to using
> > > +	 * dynamically-allocated for the key
> > > +	 */
> > > +	uint8_t *cipher_key =3D kmalloc(keylen, GFP_ATOMIC);
> > > +
> > > +	if (!cipher_key)
> > > +		return -ENOMEM;
> > > +
> > > +	memcpy(cipher_key, key, keylen);
> >=20
> > Are there any rules on handling key material in the kernel?  This buffer
> > is just kfreed later.  Do you need to zero it out before freeing it?
> >=20
> Good questions. For kernel crypto core, each cipher request should be fre=
ed
> by skcipher_request_free(): zeroize and free request data structure.
>=20
> I need to use kzfree() for key as well. I'll also check other stuffs. Tha=
nks.=20
>=20
> > > +
> > > +	spin_lock(&vcrypto->ctrl_lock);
> >=20
> > The QAT accelerator driver doesn't spin while talking to the device in
> > virtio_crypto_alg_ablkcipher_init_session().  I didn't find any other
> > driver examples in the kernel tree, but this function seems like a
> > weakness in the virtio-crypto device.
> >=20
> The control queues of virtio-net and virtio-console are also be locked
> Please see:
>  __send_control_msg() in virtio_console.c and virtio-net's control queue
> protected by rtnl lock.
>=20
> I didn't want to protect session creations but the virtqueue's operations
> like what other virtio devices do.
>=20
> > While QEMU is servicing the create session command this vcpu is blocked.
> > The QEMU global mutex is held so no other vcpu can enter QEMU and the
> > QMP monitor is also blocked.
> >=20
> > This is a scalability and performance problem.  Can you look at how QAT
> > avoids this synchronous session setup?
>=20
> For QAT driver, the session creation is synchronous as well because it's a
> plain software operation which can be completed ASAP.

I'm mentioning the vmexit and wait for request completion in a spinlock
because the same type of issue has been a performance bottleneck with
virtio guest driver in the past.

If there is a way to avoid spinning then that would be preferred.  It's
basically a known anti-pattern for virtio guest drivers.

Could you initialize the session on the host side when the first
asynchronous data is submitted for encryption/decryption instead of
during init_session()?

Stefan

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJYQBBSAAoJEJykq7OBq3PIVcUH/2uQbjFXwHo3kDAeJW9IOL24
JbJ1xUPeQQJ6ATQK4JyLVext6aTD7W3Cun0E+MM5P4DsKkWrIB0yH3L7eREVokIJ
1AN1G5mfqgWD5pbLIlUwGdHnmTZZUeWsCpvWDgGypHiHOAXX2SfuPRYh35ozu0+R
62HcqZstZlxi8TdffOHWg1ruKDU5UlSRYJDveHN7Awtb3hcjSdylP0oUVVwvHtK/
75SmfWHG2NZJhS5wBQJ+GeY6HMcAz4T6/ixAw+UwzF91U/U3ByLTVvx9nl4iQ9Ct
P4W0gEgx4jItl8U1NzgdiAly79Fe5ZjmYl1KiNWCc6gVd5z4Wzw+XwunPRZDpPM=
=V+Ck
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
