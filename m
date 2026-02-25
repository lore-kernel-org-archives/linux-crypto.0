Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E74322749;
	Wed, 25 Feb 2026 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772016474; cv=none; b=oJl2uJ3NPi8a76c8Y7x3yPeHAREVdFAXQB4evonEch1bsx+GL8Deq1DExLheVkG9+dJnKNHHQh/WVVpkzbF06JoADYXhWNMEayduG4yxQJjPYj+rkXSsuMBTbZWTGpXLZZ96Up+F5C5hIN65wL410sUwFgoX/CeOHTn4IcJIDDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772016474; c=relaxed/simple;
	bh=cdNmUmhcmZQBGEU1ipHKoVWvZyXrEYcW7YA/Sr0Ewmw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W037S85q6Dy3LaXefFP2M5/2rM1C5kACovgd8BfQUDOCGDU5G+VSOh/bQ0gjDsS+sfpTHWY5AqTDWc//jQNTHBjGb03yIHpjmThF3kKEOcFB4mO7VwqBDVrKn+/Kq3uwtZppQQRfW6FPwSRba6h/BNGwTo7OWatA0n7HdTTrU1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=POJaZQTX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="POJaZQTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772016473; x=1803552473;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=cdNmUmhcmZQBGEU1ipHKoVWvZyXrEYcW7YA/Sr0Ewmw=;
  b=POJaZQTXrgiCC1pandmiOvs3ivPCmMVgoJLbn8fmrwV8wc5NDZoSj+Mg
   HRlv3g++hID49ptfvs/+ONjpkYLac5gBS5CjyY4bnc1o+VmYRElZ9tr2t
   dxY5WDT7lU2ap2oLMRahTWHlWJN7I8Dg7nWWHLn+ON0tOQrNCQCz7Pdb2
   fhpWAtxDXJKup42URX++UYsnB6RS3Flj5c/XjGf2kzuRbmig39dEXWXEI
   KBV8Y32W00WMdo0DwGo6s3fw+jBo7+nA6Ck3aRg0kY8+HlIwAdBLKMCe5
   mgSwd47h3hXWUVKIpMPSBiq1uQPGAhJYN0CL3dV8RQAFglj5BAXZ7QAsZ
   g==;
X-CSE-ConnectionGUID: ec+fVfpORv+fvOlLDs/OsA==
X-CSE-MsgGUID: 0/p/1LM/S5m0X7HgCFCxrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="83676796"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="83676796"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 02:47:52 -0800
X-CSE-ConnectionGUID: xwD0Tc7jS6ufXYR1F/Sbvg==
X-CSE-MsgGUID: Nuyj1HjKSc6B59UgfCXJuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="246749746"
Received: from amilburn-desk.amilburn-desk (HELO localhost) ([10.245.244.86])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 02:47:44 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 25 Feb 2026 12:47:40 +0200 (EET)
To: Yousef El Bouzidi <elbouzidyyousef@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    "Rafael J. Wysocki" <rafael@kernel.org>, dakr@kernel.org, tglx@kernel.org, 
    herbert@gondor.apana.org.au, davem@davemloft.net, lee@kernel.org, 
    Hans de Goede <hansg@kernel.org>, ansuelsmth@gmail.com, atenart@kernel.org, 
    wens@kernel.org, hauke@hauke-m.de, andrew+netdev@lunn.ch, kuba@kernel.org, 
    david.e.box@linux.intel.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com, 
    jjherne@linux.ibm.com, hca@linux.ibm.com, driver-core@lists.linux.dev, 
    linux-crypto@vger.kernel.org, Netdev <netdev@vger.kernel.org>, 
    platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] treewide: fix duplicated word "the" in comments
In-Reply-To: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Message-ID: <a443446b-709b-804e-8c64-b18c5d63cdaf@linux.intel.com>
References: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1317487302-1772016460=:992"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1317487302-1772016460=:992
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 24 Feb 2026, Yousef El Bouzidi wrote:

> Remove duplicated word "the" from comments across various subsystems.
> All instances are clear typos where "the" appeared twice in
> succession, often merged with the following word (e.g. "the they",
> "the there", "the these", "the them").
>=20
> Files fixed:
>   - drivers/base/platform.c
>   - drivers/crypto/inside-secure/eip93/eip93-hash.c
>   - drivers/mfd/axp20x.c
>   - drivers/net/ethernet/lantiq_xrx200.c
>   - drivers/platform/x86/intel/chtwc_int33fe.c
>   - drivers/platform/x86/intel/pmt/class.c
>   - drivers/s390/crypto/vfio_ap_ops.c
>   - kernel/irq/migration.c
>=20
> Signed-off-by: Yousef El Bouzidi <elbouzidyyousef@gmail.com>
> ---
>  drivers/base/platform.c                         | 2 +-
>  drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-
>  drivers/mfd/axp20x.c                            | 2 +-
>  drivers/net/ethernet/lantiq_xrx200.c            | 2 +-
>  drivers/platform/x86/intel/chtwc_int33fe.c      | 2 +-
>  drivers/platform/x86/intel/pmt/class.c          | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c               | 2 +-
>  kernel/irq/migration.c                          | 2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b45d41b018ca..3e3b6fcfa194 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -565,7 +565,7 @@ struct platform_object {
>  };
> =20
>  /*
> - * Set up default DMA mask for platform devices if the they weren't
> + * Set up default DMA mask for platform devices if they weren't
>   * previously set by the architecture / DT.
>   */
>  static void setup_pdev_dma_masks(struct platform_device *pdev)
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/cr=
ypto/inside-secure/eip93/eip93-hash.c
> index 2705855475b2..d91a1ac152f0 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> @@ -432,7 +432,7 @@ static int eip93_hash_update(struct ahash_request *re=
q)
> =20
>  /*
>   * With map_data true, we map the sa_record and sa_state. This is needed
> - * for finup() as the they are mapped before calling update()
> + * for finup() as they are mapped before calling update()
>   */
>  static int __eip93_hash_final(struct ahash_request *req, bool map_dma)
>  {
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index 679364189ea5..0c6e93eb3955 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -1417,7 +1417,7 @@ int axp20x_device_probe(struct axp20x_dev *axp20x)
>  =09 * 1 bit customizable at the factory, and 1 bit depending on the
>  =09 * state of an external pin. The latter is writable. The device
>  =09 * will only respond to operations to its other registers when
> -=09 * the these device addressing bits (in the upper 4 bits of the
> +=09 * these device addressing bits (in the upper 4 bits of the
>  =09 * registers) match.
>  =09 *
>  =09 * By default we support an AXP806 chained to an AXP809 in slave
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/=
lantiq_xrx200.c
> index b8766fb7a844..dde651d901c8 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -157,7 +157,7 @@ static int xrx200_open(struct net_device *net_dev)
>  =09/* The boot loader does not always deactivate the receiving of frames
>  =09 * on the ports and then some packets queue up in the PPE buffers.
>  =09 * They already passed the PMAC so they do not have the tags
> -=09 * configured here. Read the these packets here and drop them.
> +=09 * configured here. Read these packets here and drop them.
>  =09 * The HW should have written them into memory after 10us
>  =09 */
>  =09usleep_range(20, 40);
> diff --git a/drivers/platform/x86/intel/chtwc_int33fe.c b/drivers/platfor=
m/x86/intel/chtwc_int33fe.c
> index d183aa53c318..1fca9fdd8f5b 100644
> --- a/drivers/platform/x86/intel/chtwc_int33fe.c
> +++ b/drivers/platform/x86/intel/chtwc_int33fe.c
> @@ -14,7 +14,7 @@
>   *
>   * So this driver is a stub / pseudo driver whose only purpose is to
>   * instantiate I=C2=B2C clients for chips 2 - 4, so that standard I=C2=
=B2C drivers
> - * for these chips can bind to the them.
> + * for these chips can bind to them.
>   */
> =20
>  #include <linux/dmi.h>
> diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x8=
6/intel/pmt/class.c
> index be3c8d9e4fff..99bf7e0afdf1 100644
> --- a/drivers/platform/x86/intel/pmt/class.c
> +++ b/drivers/platform/x86/intel/pmt/class.c
> @@ -239,7 +239,7 @@ static int intel_pmt_populate_entry(struct intel_pmt_=
entry *entry,
> =20
>  =09=09/*
>  =09=09 * Some hardware use a different calculation for the base address
> -=09=09 * when access_type =3D=3D ACCESS_LOCAL. On the these systems
> +=09=09 * when access_type =3D=3D ACCESS_LOCAL. On these systems
>  =09=09 * ACCESS_LOCAL refers to an address in the same BAR as the
>  =09=09 * header but at a fixed offset. But as the header address was
>  =09=09 * supplied to the driver, we don't know which BAR it was in.
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio=
_ap_ops.c
> index 44b3a1dcc1b3..334aaa2d97b2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -610,7 +610,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  =09matrix_mdev =3D container_of(vcpu->kvm->arch.crypto.pqap_hook,
>  =09=09=09=09   struct ap_matrix_mdev, pqap_hook);
> =20
> -=09/* If the there is no guest using the mdev, there is nothing to do */
> +=09/* If there is no guest using the mdev, there is nothing to do */
>  =09if (!matrix_mdev->kvm) {
>  =09=09vfio_ap_le_guid_to_be_uuid(&matrix_mdev->mdev->uuid, uuid);
>  =09=09VFIO_AP_DBF_WARN("%s: mdev %08lx-%04lx-%04lx-%04lx-%04lx%08lx not =
in use: apqn=3D0x%04x\n",
> diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
> index f2b2929986ff..b29d13baee55 100644
> --- a/kernel/irq/migration.c
> +++ b/kernel/irq/migration.c
> @@ -89,7 +89,7 @@ void irq_move_masked_irq(struct irq_data *idata)
> =20
>  =09=09ret =3D irq_do_set_affinity(data, desc->pending_mask, false);
>  =09=09/*
> -=09=09 * If the there is a cleanup pending in the underlying
> +=09=09 * If there is a cleanup pending in the underlying
>  =09=09 * vector management, reschedule the move for the next
>  =09=09 * interrupt. Leave desc->pending_mask intact.
>  =09=09 */
>=20

Acked-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com> # For pdx86

--=20
 i.

--8323328-1317487302-1772016460=:992--
