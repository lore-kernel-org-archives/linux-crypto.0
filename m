Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36831531AEB;
	Tue, 13 Oct 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914281; cv=none; b=YqNDM6/78MXg/l/FAlL0MLl9O8p8hOc34yNxEdL0aXVJ/1Rt2o9XEVY88k1VhNucOVAqpVcd7/kCpIpVJ2ccJJr28e4/FZt97evthrPU0ISgLtaG1xl2sU4vA/zWNIl0sMQFUroWK38vPK8evwGV70+fMJD0yNdhbwkT72o3EkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914281; c=relaxed/simple;
	bh=GDmMD4sIrmNYBycrF7YP1/QQqlkzc2KhWvyRnBLeZBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtitlUWgmzbMeUlHU8TIa61xM7x2g3ZJzzQNf/XIcqvyhSS7uEtD4UTXB3e3Q1TKgycgg7DgXL9TALQNIa0FAx0QjVwrSgLw7GZMc6i+h/mXS+zc7dk9Et5p+UhQTdbfD2f0YPGt0lVf/FYNBOKlOn6Z+XQJV7AAGmcChwcx7FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIPgPmso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIPgPmso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0051F1F000FF;
	Tue, 13 Oct 2026 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791914279;
	bh=i7AZZq2waiHhton6XVVNaa/s7XNNzzIS0f3JEI3r7co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WIPgPmso+lzJ2fe2IG1tg5UoJDMGR9gFxSgW47cZEriKrbg+R13VP0bOdBImbzQ3F
	 UvkiXhKQk3YJnHftUPtF+4HlwmOxBeZ0oaG4H2RCq21hg/IRellQlU4Fv+shiDfvSO
	 dLZ1ztCcsnypuG2Wzd2uybvLPwW83iga3uB7IwAuGuYefmvS78kOyW4BrzH0DS4nv2
	 LG9FKryw4s/R5vw4ydpESNdjegD0WnQjctz+xicIJ2zRCq8mjQsBa5Tg0dVDE0vgUd
	 tfPt34LrZPJ12bm+gOBTWvW29u/Z4o3xhNdsPAX/GYWcCPvxDk2prBtR+3X7LNTZVS
	 FBt49F+yfsYQg==
Date: Tue, 13 Oct 2026 18:57:55 +0100
From: Conor Dooley <conor@kernel.org>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH 0/5] crypto: cmh - add Rambus CryptoManager Hub core
 driver and AES
Message-ID: <20261013-evoke-coil-60a7037b7a0d@spud>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="svkqgvb3wERjsy4Q"
Content-Disposition: inline
In-Reply-To: <20261013174847.2192609-1-aousherovitch@rambus.com>

--svkqgvb3wERjsy4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 10:48:42AM -0700, Alex Ousherovitch wrote:
> This is the first of a short, incremental set of submissions adding

Maybe you're breaking stuff down, but this is v6, not v1, and shopuld
contain a changelog.

Thanks,
Conor.

> support for the Rambus CryptoManager Hub (CMH), a hardware cryptographic
> accelerator accessed through a mailbox-based VCQ (Virtual Command Queue)
> interface.  To keep each posting small and independently reviewable, the
> driver is submitted in self-contained parts; this first series adds the
> core platform driver, the shared key/datastore layer and the AES
> transforms (plus the device-tree binding and the MAINTAINERS entry).  AES
> is the first and least-problematic algorithm family, so the core has a
> user and the VCQ/DMA/completion data path is reviewable end to end.
> Later series add the remaining symmetric ciphers (SM4, ChaCha20-Poly1305)
> and the hwrng, the hashes and MACs, and finally the asymmetric and
> post-quantum algorithms together with the /dev/cmh_mgmt management
> interface.
>=20
> The core driver binds the device, parses its device-tree description,
> sets up DMA, the mailbox queue interface and the transaction manager,
> and exposes sysfs/debugfs instrumentation.  The key/datastore patch adds
> the key provisioning and system-object layer that the AES driver in this
> series, and the algorithm drivers in the following series, build on.
>=20
> The transaction manager runs as a kthread that packs VCQ entries, maps
> DMA, and submits to the least-loaded mailbox; completion is handled by
> per-mailbox threaded IRQs.  The data path is asynchronous: requests
> return -EINPROGRESS and the driver honors CRYPTO_TFM_REQ_MAY_BACKLOG for
> queue-full backpressure.  The CMH eSW is loaded independently by the
> hardware before probe; the driver loads no firmware.
>=20
> The CMH is a platform device matched via device tree (compatible
> "rambus,cmh-v1030").  Following the inside-secure,eip93 binding model
> and the DT maintainer's guidance, the schema requires a SoC-specific
> compatible ahead of the IP fallback and therefore carries no example.
>=20
> Public hardware documentation:
>   Product brief: https://go.rambus.com/ch-7xx-and-cc-7xx-product-brief
>   No public datasheets are currently available.  The driver was
>   developed against the Rambus CryptoManager Hub Hardware Reference
>   Manual (Rambus Inc. confidential).  Detailed hardware reference is
>   available under NDA from Rambus Inc.; contact the maintainers listed
>   in MAINTAINERS for access during review.
>=20
> Developed against Herbert Xu's cryptodev tree.  checkpatch.pl --strict,
> sparse (C=3D2) and a W=3D1 -Werror build are clean, and dtschema's
> dt-doc-validate accepts the binding.  Exercised on riscv64 and arm64 --
> QEMU with the CMH hardware model and a Xilinx VMK180 FPGA with the CMH
> IP -- under lockdep/PROVE_LOCKING, DEBUG_OBJECTS,
> KASAN/UBSAN/KMEMLEAK/KFENCE and (arm64) KCSAN with no findings;
> worst-case stack stays under 1 KB.
>=20
> Alex Ousherovitch (5):
>   dt-bindings: crypto: add Rambus CryptoManager Hub
>   crypto: cmh - add core platform driver
>   crypto: cmh - add key/datastore infrastructure
>   crypto: cmh - add AES skcipher/aead/cmac
>   MAINTAINERS: add Rambus CryptoManager Hub (CMH)
>=20
>  Documentation/ABI/testing/debugfs-driver-cmh  |  171 ++
>  Documentation/ABI/testing/sysfs-driver-cmh    |   67 +
>  Documentation/crypto/device_drivers/cmh.rst   |  340 +++
>  Documentation/crypto/device_drivers/index.rst |    1 +
>  .../bindings/crypto/rambus,cmh-v1030.yaml     |  144 ++
>  .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
>  MAINTAINERS                                   |   13 +
>  drivers/crypto/Kconfig                        |    1 +
>  drivers/crypto/Makefile                       |    1 +
>  drivers/crypto/cmh/Kconfig                    |   62 +
>  drivers/crypto/cmh/Makefile                   |   30 +
>  drivers/crypto/cmh/cmh_aes.c                  |  755 ++++++
>  drivers/crypto/cmh/cmh_aes_aead.c             | 1013 ++++++++
>  drivers/crypto/cmh/cmh_aes_cmac.c             |  476 ++++
>  drivers/crypto/cmh/cmh_config.c               |  619 +++++
>  drivers/crypto/cmh/cmh_debugfs.c              |  307 +++
>  drivers/crypto/cmh/cmh_dma.c                  |  482 ++++
>  drivers/crypto/cmh/cmh_key.c                  |  119 +
>  drivers/crypto/cmh/cmh_main.c                 |  394 +++
>  drivers/crypto/cmh/cmh_mqi.c                  |  344 +++
>  drivers/crypto/cmh/cmh_rh.c                   | 1211 +++++++++
>  drivers/crypto/cmh/cmh_sys.c                  |  376 +++
>  drivers/crypto/cmh/cmh_sysfs.c                |  108 +
>  drivers/crypto/cmh/cmh_txn.c                  | 2235 +++++++++++++++++
>  drivers/crypto/cmh/include/cmh.h              |   24 +
>  drivers/crypto/cmh/include/cmh_aes.h          |   24 +
>  drivers/crypto/cmh/include/cmh_aes_abi.h      |   98 +
>  drivers/crypto/cmh/include/cmh_ccp_abi.h      |  108 +
>  drivers/crypto/cmh/include/cmh_config.h       |  105 +
>  drivers/crypto/cmh/include/cmh_debugfs.h      |   93 +
>  drivers/crypto/cmh/include/cmh_dma.h          |  249 ++
>  drivers/crypto/cmh/include/cmh_drbg_abi.h     |   67 +
>  drivers/crypto/cmh/include/cmh_eac_abi.h      |   44 +
>  drivers/crypto/cmh/include/cmh_hc_abi.h       |  162 ++
>  drivers/crypto/cmh/include/cmh_hcq_abi.h      |  222 ++
>  drivers/crypto/cmh/include/cmh_key.h          |   73 +
>  drivers/crypto/cmh/include/cmh_kic_abi.h      |   77 +
>  drivers/crypto/cmh/include/cmh_mqi.h          |   35 +
>  drivers/crypto/cmh/include/cmh_pke_abi.h      |  272 ++
>  drivers/crypto/cmh/include/cmh_qse_abi.h      |  201 ++
>  drivers/crypto/cmh/include/cmh_registers.h    |  161 ++
>  drivers/crypto/cmh/include/cmh_rh.h           |   93 +
>  drivers/crypto/cmh/include/cmh_sm3_abi.h      |   79 +
>  drivers/crypto/cmh/include/cmh_sm4_abi.h      |  101 +
>  drivers/crypto/cmh/include/cmh_sys.h          |  111 +
>  drivers/crypto/cmh/include/cmh_sys_abi.h      |  148 ++
>  drivers/crypto/cmh/include/cmh_sysfs.h        |   14 +
>  drivers/crypto/cmh/include/cmh_txn.h          |  493 ++++
>  drivers/crypto/cmh/include/cmh_vcq.h          |  288 +++
>  49 files changed, 12613 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-driver-cmh
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-cmh
>  create mode 100644 Documentation/crypto/device_drivers/cmh.rst
>  create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v=
1030.yaml
>  create mode 100644 drivers/crypto/cmh/Kconfig
>  create mode 100644 drivers/crypto/cmh/Makefile
>  create mode 100644 drivers/crypto/cmh/cmh_aes.c
>  create mode 100644 drivers/crypto/cmh/cmh_aes_aead.c
>  create mode 100644 drivers/crypto/cmh/cmh_aes_cmac.c
>  create mode 100644 drivers/crypto/cmh/cmh_config.c
>  create mode 100644 drivers/crypto/cmh/cmh_debugfs.c
>  create mode 100644 drivers/crypto/cmh/cmh_dma.c
>  create mode 100644 drivers/crypto/cmh/cmh_key.c
>  create mode 100644 drivers/crypto/cmh/cmh_main.c
>  create mode 100644 drivers/crypto/cmh/cmh_mqi.c
>  create mode 100644 drivers/crypto/cmh/cmh_rh.c
>  create mode 100644 drivers/crypto/cmh/cmh_sys.c
>  create mode 100644 drivers/crypto/cmh/cmh_sysfs.c
>  create mode 100644 drivers/crypto/cmh/cmh_txn.c
>  create mode 100644 drivers/crypto/cmh/include/cmh.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_aes.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_aes_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_ccp_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_config.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_debugfs.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_dma.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_drbg_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_eac_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_hc_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_hcq_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_key.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_kic_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_mqi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_pke_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_qse_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_registers.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_rh.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_sm3_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_sm4_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_sys.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_sys_abi.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_sysfs.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_txn.h
>  create mode 100644 drivers/crypto/cmh/include/cmh_vcq.h
>=20
>=20
> ---
>=20
> The CMH driver was first posted as a single series; it is now
> split into smaller, independently reviewable series per maintainer
> feedback.  Earlier single-series postings:
>   v1: https://lore.kernel.org/linux-crypto/20260625173328.1140487-1-skris=
hnamoorthy@rambus.com/
>   v2: https://lore.kernel.org/linux-crypto/20260709203037.1884436-1-skris=
hnamoorthy@rambus.com/
>   v3: https://lore.kernel.org/linux-crypto/20260806195519.2703224-1-skris=
hnamoorthy@rambus.com/
>   v4: https://lore.kernel.org/linux-crypto/20260825221539.255951-1-aoushe=
rovitch@rambus.com/
>   v5: https://lore.kernel.org/linux-crypto/20260917225929.2494111-1-aoush=
erovitch@rambus.com/
> base-commit: 9695df3b1db4ac4534274d38ee16e3b9b0bf910e
>=20
> --=20
> 2.43.7
>=20

--svkqgvb3wERjsy4Q
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCas5xIgAKCRB4tDGHoIJi
0p4DAQCsuhJ7uCjrDn+zL9O+OmZw1FIK5NC33gbsGt7Mr2H2dAD+JlSflVPc6YB3
9Tmx7kWjE9jon4co9zStzsBQoLSG3gM=
=LQG7
-----END PGP SIGNATURE-----

--svkqgvb3wERjsy4Q--
