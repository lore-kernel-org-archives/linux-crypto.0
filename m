Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847431;
	b=YzormqFi2AgOUF3j0PIuCsiuqlR4VJa8xz+U8tXOjeLb53TfAr4ydU8MRxsfgV+Y55SX
	 cxTqNw9FLm5+YzDQ+AH8PpgGj/Q/rFGrjrEIC76pamXKekj+MVnV+/zGw/pfqh1+bVgUG
	 yj9Se8V+jYLQJvTLMZX1aTV2hRn9caJ8q8yi+/BYsgwt6sQxUSnost0DWsHlxWOlARn2N
	 /t1hyn9uiTMs9WCFBLk6L8Nkbbo6G7xjxm3UOdud0yUHXRfVj4ZT8O6cop9Om0nxNGvkI
	 Qa7M1GsVJPAsqGFi7QU/GezTf3xzJY1FHTcbGMZ1VYasTtukJJGkXLC4hNJer9quiuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847431;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=ye/hK2doMI3EoGzSdThmb4Gz7dllWhG/+IfmHJjN0XQ=;
	b=vTvWNyWN46LxtZ9wVXS1dNaXIohVaOVS80ul579cVaO+r0nzNASWFfrapyhMUObfvH60
	 0SDKzdul/+NhVXq5xDA3iIinQ53rgupSRXL8+f2EEm73l4rJwTe4SR/Yf/CEoWapMk6aq
	 vUKiPHj8YhnxyI1dujqnMpdjlSWLbRq1V4iDQVAMqTFRZB1PwvXjJrUyrknlOLu13+6A6
	 49FSdN7p3zmGPuJGgyPmPeekSLW9q0p7Uc2wonyGdxCJyhA4qgDGeXTjEUwbrBQGVp9t1
	 9avIiWBkicOBJnB+l7ZjHHLVhsh7OxHaTPfcYXbaYycPfxPOK6EcR7db/3pYg1r0xgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EnjLPxC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E706606A329;
	Mon, 16 Nov 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EnjLPxC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C031F000CA;
	Mon, 16 Nov 2026 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794847430;
	bh=ye/hK2doMI3EoGzSdThmb4Gz7dllWhG/+IfmHJjN0XQ=;
	h=Date:From:To:Cc:Subject;
	b=EnjLPxC2kOoxVtS1jG4VH2MAc375eHh6qiZ2+hFrjoZ3JfOgoKfAehUEmEJVUM9W3
	 EzyB7g3Z8pcKEedlZKpgnnCkjjqNqHwE4rg2hIyhJB83mPkkvRWFN6cKJaTi1z+3bO
	 m2wWPo6PR4o8YxKR2xdnQhokVSswPWwea7YYuja7Z4NqQBGk+pPzaO5GA9GLtZQXnI
	 PPaRBey61HNxv1lG9mQs67q4GIncu9MebvVQn6FLYnlYVTFyaFbwDoMhlzILFQFXpQ
	 ElmhrmsG5GSiTG34mb2LTK944cHL2asiHeKwIrYYaCaxr56xm+SdSuwhkZ739FcvAN
	 LAYBEtD215Oyw==
Date: Mon, 16 Nov 2026 16:43:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Thorsten Blum <blum@kernel.org>
Subject: linux-next: manual merge of the crypto tree with the origin tree
Message-ID: <avsyw-Q9dfMw45zX@sirena.org.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H927aFy//RcS94+R"
Content-Disposition: inline


--H927aFy//RcS94+R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got a conflict in:

  drivers/char/hw_random/virtio-rng.c

between commit:

  0f7bf47f5a0cc ("hwrng: virtio - prevent use-after-free after a failed res=
tore")

=66rom the origin tree and commits:

  a3eaee98eecc4 ("hwrng: virtio - prevent use-after-free after a failed res=
tore")
  277b0dae660c3 ("hwrng: virtio - simplify probe_common()")

=66rom the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --combined drivers/char/hw_random/virtio-rng.c
index 45d87c0614a5e,892720b1ac6f9..0000000000000
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@@ -70,7 -70,7 +70,7 @@@ static void request_entropy(struct virt
  static unsigned int copy_data(struct virtrng_info *vi, void *buf,
  			      unsigned int size)
  {
- 	unsigned int idx, avail;
+ 	unsigned int idx;
 =20
  	/*
  	 * vi->data_avail was set from the device-reported used.len and
@@@ -81,13 -81,13 +81,13 @@@
  	 * steered into adjacent slab memory, including under
  	 * speculation.
  	 */
- 	avail =3D min(vi->data_avail, sizeof(vi->data));
- 	if (vi->data_idx >=3D avail) {
+ 	if (vi->data_idx >=3D sizeof(vi->data)) {
  		vi->data_avail =3D 0;
  		request_entropy(vi);
  		return 0;
  	}
- 	size =3D min(size, avail - vi->data_idx);
+ 	vi->data_avail =3D min(vi->data_avail, sizeof(vi->data) - vi->data_idx);
+ 	size =3D min(size, vi->data_avail);
  	idx =3D array_index_nospec(vi->data_idx, sizeof(vi->data));
  	memcpy(buf, vi->data + idx, size);
  	vi->data_idx +=3D size;
@@@ -150,17 -150,17 +150,17 @@@ static void virtio_cleanup(struct hwrn
 =20
  static int probe_common(struct virtio_device *vdev)
  {
- 	int err, index;
- 	struct virtrng_info *vi =3D NULL;
+ 	int err;
+ 	struct virtrng_info *vi;
 =20
  	vi =3D kzalloc_obj(struct virtrng_info);
  	if (!vi)
  		return -ENOMEM;
 =20
- 	vi->index =3D index =3D ida_alloc(&rng_index_ida, GFP_KERNEL);
- 	if (index < 0) {
- 		err =3D index;
- 		goto err_ida;
+ 	vi->index =3D ida_alloc(&rng_index_ida, GFP_KERNEL);
+ 	if (vi->index < 0) {
+ 		err =3D vi->index;
+ 		goto err;
  	}
  	snprintf(vi->name, sizeof(vi->name), "virtio_rng.%d", vi->index);
  	init_completion(&vi->have_data);
@@@ -177,7 -177,8 +177,8 @@@
  	vi->vq =3D virtio_find_single_vq(vdev, random_recv_done, "input");
  	if (IS_ERR(vi->vq)) {
  		err =3D PTR_ERR(vi->vq);
- 		goto err_find;
+ 		ida_free(&rng_index_ida, vi->index);
+ 		goto err;
  	}
 =20
  	virtio_device_ready(vdev);
@@@ -187,9 -188,7 +188,7 @@@
 =20
  	return 0;
 =20
- err_find:
- 	ida_free(&rng_index_ida, index);
- err_ida:
+ err:
  	vdev->priv =3D NULL;
  	kfree(vi);
  	return err;
@@@ -245,26 -244,27 +244,27 @@@ static int virtrng_freeze(struct virtio
 =20
  static int virtrng_restore(struct virtio_device *vdev)
  {
+ 	struct virtrng_info *vi;
  	int err;
 =20
  	err =3D probe_common(vdev);
- 	if (!err) {
- 		struct virtrng_info *vi =3D vdev->priv;
+ 	if (err)
+ 		return err;
+ 	vi =3D vdev->priv;
 =20
- 		/*
- 		 * Set hwrng_removed to ensure that virtio_read()
- 		 * does not block waiting for data before the
- 		 * registration is complete.
- 		 */
- 		vi->hwrng_removed =3D true;
- 		err =3D hwrng_register(&vi->hwrng);
- 		if (!err) {
- 			vi->hwrng_register_done =3D true;
- 			vi->hwrng_removed =3D false;
- 		}
- 	}
+ 	/*
+ 	 * Set hwrng_removed to ensure that virtio_read()
+ 	 * does not block waiting for data before the
+ 	 * registration is complete.
+ 	 */
+ 	vi->hwrng_removed =3D true;
+ 	err =3D hwrng_register(&vi->hwrng);
+ 	if (err)
+ 		return err;
 =20
- 	return err;
+ 	vi->hwrng_register_done =3D true;
+ 	vi->hwrng_removed =3D false;
+ 	return 0;
  }
 =20
  static const struct virtio_device_id id_table[] =3D {

--H927aFy//RcS94+R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr7MsIACgkQJNaLcl1U
h9CsEgf/UlPOorwfsEeifVQO8HHjdNVNiHmqEzdeU8hgSTdARmqjDx142BIqziF3
jWyZ4I+Gbf3OvE4G65jFs2y7MsO99R+akeHMf+guzW7sntMg7wSY+XlaO34WNaub
XyGFTqI4scfIikuu+u5iJeuAhc1vlQGZpIkceDwqVRtweol2wY394l29uniCCGo7
iXY3Xi7Y+JLnZ4viyJkZq5FAZvQx/HYb2VIHIyouduhCqXPxPagrnBzhlbbn+ovx
LFIGEUYhGtmlkdH7bc4gJ8ctVM1OgnaD6vNgzTEmkhe4AYNcn5CZ6T+4/pmUCB1D
6jQGy0G1c78md8vC1a2Y2vpo0+mkig==
=SlGs
-----END PGP SIGNATURE-----

--H927aFy//RcS94+R--
