Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2D1946CA;
	Sat, 12 Oct 2024 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728745699; cv=none; b=nXc4+jvYhlyx6n/q0VKXh4Zn/ymvlvgltl/hlb0wxYSk8yD1mlIc+dY+yKK8zWXhLajSb1gNnO6a6K+843D7BVAJ0VWGFdXvhpFo6tyNndxAf+RuWztl8w0zQybCVLlNW0IpMlvUCYu/P2MUCuHmkHmcQyxpX+w4xK/Ob94qMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728745699; c=relaxed/simple;
	bh=V4yVz6wKBRIKfkbZbcimzf6FMITfCN32tsehdEe570o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NhfX8yadW79ZV9Qz63ByJb9gLqvVsj7COLcT0dd1t7nTvAPsmOSsz0wbw1dNZWEssSbwQhvzIvHsTAGmmr42Ul9+U+9LXrH9zYf9Oj2kSqRZsX4bwB0hQH1u7PIZx06PYq5tD1BjInKwcY1X4bK9T71Tvzm2I6U4rhbxtkCox74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=nPn6CazV; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="nPn6CazV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728745683; x=1729350483; i=markus.elfring@web.de;
	bh=iZAp6vq9/uO0eUWPyUtNjgnNySurb1U0onZR/j8rsxM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nPn6CazV9nXuqgdI8NdSt1yjJPyDi7BW8p0upcYsAfshUs5fTdTobPDpQNSe4QvZ
	 kGZv4zdYJA0VniMu79aJIyZpGHXCb4fhMzpd/NNuLmP0au+pOuBEtibhFe6v1qAGD
	 4k+Rsghj7SrwGdxoxq+6O0T5q3k1xxpkjCYXr7cZhAzuP/4EoshfCgYd+D3yZ8MPV
	 w/4KZ5CcIHpYikIl0z7x3WCxM+jMT5RLTgdE+YDTToiTV2B77dofjSISL55PK6Fu4
	 AC1gjqjDyOWaVygE2rN9wxrDpxIHF5TxofhAj9hAn1ypwHPIZM2/vxl771W3FkGAV
	 o+WrOhD8y61L9Shh0A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.89.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M5QmF-1t11Il4BGP-003yQ3; Sat, 12
 Oct 2024 17:08:03 +0200
Message-ID: <300a0376-f003-4862-bb16-7e004733c9c1@web.de>
Date: Sat, 12 Oct 2024 17:08:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 2/3] lib/digsig: Use scope-based resource management for
 two MPI variables in digsig_verify_rsa()
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
 <ee5f409e-4412-41cd-b8d8-92872770f04d@web.de>
Content-Language: en-GB
In-Reply-To: <ee5f409e-4412-41cd-b8d8-92872770f04d@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:497pF5zuEW/lCuL/zjVIJTipmxMD97VJCGU3NAD1k5gAA67nX9Z
 EtUdySP2LPIzJz+yx2oF7bPsiU0yoW9MdT7u/wrrJ8q0cqwLDXY46VdD0Dd7ZJTIUjlnRI7
 EGdmXl69sUrqM4mrufd2o2ptaliOSCZ0/w7V0pJvIjOa7e9N0zTDoxl+2LwbljnasTJ+1jI
 AAnJsziTw9fStm/xXv/DQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:M9tx4N0BDyE=;KOrI07oC/t+naMduiVaOpUT6/lH
 boC6nxcGggzGxU+4WMsYjm/T4laTLzYrR8UrUytbrO4NRrSpC90W6vVXOWh6qHJHSfZEH04Hx
 0+AYpYgxGpSVghdRM59D1sPsAvrPZ6YwUoIOIie5H/HPu/tPPi2yUqrJFeevkC3mVPN42h1RI
 uudBftq/0EUMjOKsyJynd/ylxViRgmdl5J7vvEvSmhOFJzR2Elp7L3S0JuuCmqz3sWM1ow3Ib
 OBHm47ZK4rJbjrXR6Hguu3yhjayOoVzav6JMBepF0sb/yZRdPAwSYQpLNR+UizISoTQJ20iDa
 rpp9YcfHSEuP7IKsSuunV6u9sHUdVBK5l3fv6vF1Fx/OieB9GKrZylZJ1RpyWVeG0i6MkYWC3
 k/fRKMmLYyIRGMvW6r6AHG5g4XyJlMJxtwISJbuAzksJ3cFUDbEWNYzd0qQtfQnU2MieOtg2G
 YuazczByiG+pxzRS1ZaWHzLw2qvIh6poE2ePrfiJbiiApT6rRTvOXFAhjq4xAg19LJnPKP6DO
 Z9rrjF6IG5b/3XFUO7RFtiR2jmUditGwxNPGeLVPMMFv2JSZ0ZzEkUQvgj9XnTqzMLOBmAKK7
 AH58pXh3YweO1owF6+mYuOcVUF6cV/gRU+fB7d6Fc0DC7+40j5p8AvLm7AYxMJIQo4cLSKkV/
 jH5/Ib5MLAjFNoODJsgsFaFqfK74yzhtEmJ2V7wbb1+hYL3w9D5of0GbmzGAWV8gUsgtCGJBm
 cpAfaylkMnlsdCoVYOwuq1WPXRRKIZs9UfVxBlrkZWlNe8fI0jROw4hhmsZHC9m5w/HUGjKMq
 E8NAxkNFty9IwLslrwRG3UdA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Oct 2024 14:21:28 +0200

The support for scope-based resource management was extended.

* Thus use the attribute =E2=80=9C__free(mpi_free)=E2=80=9D.

* Reduce the scopes for the local variables =E2=80=9Cnret=E2=80=9D, =E2=80=
=9Cin=E2=80=9D and =E2=80=9Cres=E2=80=9D.

* Omit two mpi_free() calls accordingly.

* Update jump targets.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

V3:
Applications were added as requested (by Herbert Xu) for the proposed
programming interface extension.


 lib/digsig.c | 80 ++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 37 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 04b5e55ed95f..2481120094ab 100644
=2D-- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -71,11 +71,11 @@ static int digsig_verify_rsa(struct key *key,
 	int err =3D -EINVAL;
 	unsigned long len;
 	unsigned long mlen, mblen;
-	unsigned nret, l;
+	unsigned int l;
 	int head, i;
 	unsigned char *out1 =3D NULL;
 	const char *m;
-	MPI in =3D NULL, res =3D NULL, pkey[2];
+	MPI pkey[2];
 	uint8_t *p, *datap;
 	const uint8_t *endp;
 	const struct user_key_payload *ukp;
@@ -112,7 +112,7 @@ static int digsig_verify_rsa(struct key *key,
 		pkey[i] =3D mpi_read_from_buffer(datap, &remaining);
 		if (IS_ERR(pkey[i])) {
 			err =3D PTR_ERR(pkey[i]);
-			goto err;
+			goto free_keys;
 		}
 		datap +=3D remaining;
 	}
@@ -122,57 +122,63 @@ static int digsig_verify_rsa(struct key *key,

 	if (mlen =3D=3D 0) {
 		err =3D -EINVAL;
-		goto err;
+		goto free_keys;
 	}

 	err =3D -ENOMEM;

 	out1 =3D kzalloc(mlen, GFP_KERNEL);
 	if (!out1)
-		goto err;
+		goto free_keys;

-	nret =3D siglen;
-	in =3D mpi_read_from_buffer(sig, &nret);
-	if (IS_ERR(in)) {
-		err =3D PTR_ERR(in);
-		goto err;
-	}
+	{
+		unsigned int nret =3D siglen;
+		MPI in __free(mpi_free) =3D mpi_read_from_buffer(sig, &nret);

-	res =3D mpi_alloc(mpi_get_nlimbs(in) * 2);
-	if (!res)
-		goto err;
+		if (IS_ERR(in)) {
+			err =3D PTR_ERR(in);
+			goto in_exit;
+		}

-	err =3D mpi_powm(res, in, pkey[1], pkey[0]);
-	if (err)
-		goto err;
+		{
+			MPI res __free(mpi_free) =3D mpi_alloc(mpi_get_nlimbs(in) * 2);

-	if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
-		err =3D -EINVAL;
-		goto err;
-	}
+			if (!res)
+				goto res_exit;

-	p =3D mpi_get_buffer(res, &l, NULL);
-	if (!p) {
-		err =3D -EINVAL;
-		goto err;
-	}
+			err =3D mpi_powm(res, in, pkey[1], pkey[0]);
+			if (err)
+				goto res_exit;

-	len =3D mlen;
-	head =3D len - l;
-	memset(out1, 0, head);
-	memcpy(out1 + head, p, l);
+			if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
+				err =3D -EINVAL;
+				goto res_exit;
+			}

-	kfree(p);
+			p =3D mpi_get_buffer(res, &l, NULL);
+			if (!p) {
+				err =3D -EINVAL;
+				goto res_exit;
+			}

-	m =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
+			len =3D mlen;
+			head =3D len - l;
+			memset(out1, 0, head);
+			memcpy(out1 + head, p, l);

-	if (!m || len !=3D hlen || memcmp(m, h, hlen))
-		err =3D -EINVAL;
+			kfree(p);
+
+			m =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
+
+			if (!m || len !=3D hlen || memcmp(m, h, hlen))
+				err =3D -EINVAL;
+res_exit:
+		}
+in_exit:
+	}

-err:
-	mpi_free(in);
-	mpi_free(res);
 	kfree(out1);
+free_keys:
 	while (--i >=3D 0)
 		mpi_free(pkey[i]);
 err1:
=2D-
2.46.1

