Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2242882A1
	for <linux-crypto@vger.kernel.org>; Tue,  6 Jan 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767709424; cv=none; b=EFfFJS/aXHw9c3YFUKy7iSNzoQbM50Y2t1EjrMjb9RXKUwxnsCxqOr/EYITjHWGTMwLgqSxwopcVySStaSCEXRoVJkjJ4ea7naS9TDnYyZ+cmcqSoOoMVgzl5hzyqkF9dnyTzjA3NRAAtBiJw6JDCsdPiNYjwa/dxOOibmvLx9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767709424; c=relaxed/simple;
	bh=lVULV5GfaJFN2tASGfIP17U8gJhLLwXEwGtmS7IVzcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9xRmbeWp63zsbHMf0Klj07UzmQ41Xo+xPqyq/7+kM1QSykab7o8lf0+Ld1nDd9JU5rVQ2MHe5I/4ZLJ4lBxEiIfXj1laxLp3wHMyd3mdzCVZMaV5BG/+b8BnVQXwmWauiCwUV51Tjcb31BTvLwtQSP+YZ5CZAYWbcMhr1OclZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KgQ2TVFX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KgQ2TVFX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767709421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0OqzwyCKSkjy5BfIhkLbUQnq0t0kB+MbQfPUkbaaRNY=;
	b=KgQ2TVFXG9XBymsZDrHLteM6kvW3U4AEtbf7D9dyRV3tA9Up+eWZIRIzqSH6rMWbgn2NBd
	fUhkxeqVmU/rqC8Xo2oyGuItSv94wcZnVC1trW7x5Mz0OK/E7oU1AZA6xFIKUKWyGuGxwe
	MEgWW8zlNkyPU2uG7aYMPLV2hDGmXwQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-bni8fjkMOieXIdoRKDxuwg-1; Tue,
 06 Jan 2026 09:23:39 -0500
X-MC-Unique: bni8fjkMOieXIdoRKDxuwg-1
X-Mimecast-MFC-AGG-ID: bni8fjkMOieXIdoRKDxuwg_1767709416
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 343971955F3E;
	Tue,  6 Jan 2026 14:23:32 +0000 (UTC)
Received: from localhost (unknown [10.2.16.158])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB52419560AB;
	Tue,  6 Jan 2026 14:23:29 +0000 (UTC)
Date: Mon, 5 Jan 2026 13:19:39 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <20260105181939.GA59391@fedora>
References: <cover.1767601130.git.mst@redhat.com>
 <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TgzbTybhuc4Vbyp1"
Content-Disposition: inline
In-Reply-To: <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--TgzbTybhuc4Vbyp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2026 at 03:23:29AM -0500, Michael S. Tsirkin wrote:
> @@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
> =20
>  struct virtio_scsi_event_node {
>  	struct virtio_scsi *vscsi;
> -	struct virtio_scsi_event event;
> +	struct virtio_scsi_event *event;
>  	struct work_struct work;
>  };
> =20
> @@ -89,6 +90,11 @@ struct virtio_scsi {
> =20
>  	struct virtio_scsi_vq ctrl_vq;
>  	struct virtio_scsi_vq event_vq;
> +
> +	__dma_from_device_group_begin();
> +	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
> +	__dma_from_device_group_end();

If the device emits two events in rapid succession, could the CPU see
stale data for the second event because it already holds the cache line
for reading the first event?

In other words, it's not obvious to me that the DMA warnings are indeed
spurious and should be silenced here.

It seems safer and simpler to align and pad the struct virtio_scsi_event
field in struct virtio_scsi_event_node rather than packing these structs
into a single array here they might share cache lines.

Stefan

--TgzbTybhuc4Vbyp1
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmlcALoACgkQnKSrs4Gr
c8hxKAgAntRCUOkAR5sJ85qdfsRgS5doxT9/NXPvgLJJuioZ7uhZ5gZoJlDI03Jd
hAhz7RZQq0egV90TXQcX+aVTCMEoVFBZs9myLPSn3+P2aJI58FiFGQtA0EmzWkA5
sjTyB+Fn5GvsA5yoatFgYoqr0Fc6xPDTWWkgqMkg2nmMjdbnR9taetiYfcW8FdHu
eZmLE0d8xc2KhR/HMfz11L+fk1oXF94bZyqM98sOXkzqWgXK0vyd4UK/atflMQMv
QInPClb3ErPbr27EQixAwC6yR40bvPArKxVFbJEYWYm1uP4fprxUVZD6VfmeTMZZ
vJCcbmW4I0BK/ICRg+hCVzw3tAAmjg==
=RvL+
-----END PGP SIGNATURE-----

--TgzbTybhuc4Vbyp1--

