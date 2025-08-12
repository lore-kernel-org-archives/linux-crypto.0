Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4102EAD0E;
	Tue, 12 Aug 2025 10:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754994119; cv=none; b=n9uzNk/gKnwCnol9McLE6AFPijfS+8twCccU8wN7zXmhLi13hR2RNBnavyuE6idSiqhHgrYfmaWk4Too+Z7wmWybAuGQboZTsVmilp9YXU86yhMCZBDhnBCeiM91FojVoVwIY6yobp0G78PNJ0NJCBydz8lbvlt7Hn1w312WoEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754994119; c=relaxed/simple;
	bh=Dj/MOQ1+urIXNRd/7BWQT3KAk/oGZYIeXl2/1/7+vM8=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cJF2ST7JBmuT4Vegj3L7oy6B0u0Yz2nKyd/NGjkUMPpb89hOVZJeXzvcM1EFU83WbaVXnxnprlpehofflnGFiBlpahJDZMTmf16arJ1ANuMq29iGEYjSgGHXnB8sMCSXn2+8G+RP6BKhpho31YfPWXw4RM7V29Ik/NkJxSzXiho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b78rUotk; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b78rUotk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754994117; x=1786530117;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=Dj/MOQ1+urIXNRd/7BWQT3KAk/oGZYIeXl2/1/7+vM8=;
  b=b78rUotkNeAwqB6aXkJ2GiQwVcfBfT/WtqkBKmYRSqBGPI34Nddgs17u
   1yQWR0/ScqOUz8WXwCL8GTmCrsFH7njyJLcdzP2gi4F9hiVqZkuILbiPg
   SHyvNTWIpKUOt3Hz4pRQz8Zx0zkBu+cD2HT5wLk+zIs3j23NZr0ci+uWU
   6iOtITrxLkxrp2b4qVdxSWSLVLxvJRSvqnkQAz2ftW1HATerbUZPuX5TC
   5MFmz4+qxIli7+Ui+4cMPPABuDbzu9OImwwAm2RO3F2Ha+AL3G/8KBvRL
   sEPNKOMERN9AajYElVGkT9PDVJRy7zQe+OQYNthFeI6FxftwPbdOYr86U
   A==;
X-CSE-ConnectionGUID: 3vR4uffwRn2cTE5IPLZEFA==
X-CSE-MsgGUID: 0YcYYsZ/RUKLhHQrBL+Urg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="67865982"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="67865982"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 03:21:56 -0700
X-CSE-ConnectionGUID: qzXG4LUpSGyCeRGlnMsMcA==
X-CSE-MsgGUID: oqv7yFxKQxSvucXaJGiFiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="170364989"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.96])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 03:21:53 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 12 Aug 2025 13:21:49 +0300 (EEST)
To: Ron Li <xiangrongl@nvidia.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
    Hans de Goede <hdegoede@redhat.com>, Vadim Pasternak <vadimp@nvidia.com>, 
    Khalil Blaiech <kblaiech@nvidia.com>, 
    David Thompson <davthompson@nvidia.com>, 
    "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] platform/mellanox: Add mlxbf_pka driver for BlueField
 Soc
In-Reply-To: <BYAPR12MB30155B51CFA7F8665CAAA504A928A@BYAPR12MB3015.namprd12.prod.outlook.com>
Message-ID: <22f3b2c5-517f-5bcf-157d-3ade74cba548@linux.intel.com>
References: <20250515193234.2436452-1-xiangrongl@nvidia.com> <c85784ee-5f06-6d7a-377e-07db7af8bd35@linux.intel.com> <BYAPR12MB30155B51CFA7F8665CAAA504A928A@BYAPR12MB3015.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1565688773-1754992195=:995"
Content-ID: <15eb6b0a-ad53-2ca1-05f2-f2844dc299ca@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1565688773-1754992195=:995
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <fc783fc7-1d87-04a2-4ce6-cb6a75d5e58a@linux.intel.com>

On Mon, 11 Aug 2025, Ron Li wrote:

> Hi Ilpo,
> I have answers for three of the review questions. You can search for "Ron=
 Answer" to locate them.

Next time if the mail is long, please trim the response to only contain=20
the relevant parts of the exchange so you won't even need to mark them=20
like that. :-)

> All the other review questions have been fixed in the patch v2.
>
> > -----Original Message-----
> > From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> > Sent: Friday, May 16, 2025 5:20 AM
> > To: Ron Li <xiangrongl@nvidia.com>; Herbert Xu
> > <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>;
> > linux-crypto@vger.kernel.org
> > Cc: Hans de Goede <hdegoede@redhat.com>; Vadim Pasternak
> > <vadimp@nvidia.com>; Khalil Blaiech <kblaiech@nvidia.com>; David
> > Thompson <davthompson@nvidia.com>; platform-driver-
> > x86@vger.kernel.org; LKML <linux-kernel@vger.kernel.org>
> > Subject: Re: [PATCH v1] platform/mellanox: Add mlxbf_pka driver for Blu=
eField
> > Soc
> >=20
> > External email: Use caution opening links or attachments
> >=20
> >=20
> > On Thu, 15 May 2025, Ron Li wrote:
> >=20
> > > Add the mlxbf_pka driver to support the BlueField SoC Public Key
> > > Acceleration (PKA) hardware. The PKA provides a simple, complete
> > > framework for crypto public key hardware offload. It supports direct
> > > access to the public key hardware resources from the user space, and
> > > makes available several arithmetic operations: some basic operations
> > > (e.g., addition and multiplication), some complex operations (e.g.,
> > > modular exponentiation and modular inversion), and high-level
> > > operations such as RSA, Diffie-Hallman, Elliptic Curve Cryptography,
> > > and the Federal Digital Signature Algorithm (DSA as documented in
> > > FIPS-186) public-private key systems.
> > >
> > > The PKA driver initializes the PKA hardware interface and implements
> > > file operations so that user space libraries can bypass the kernel an=
d
> > > have direct access to a specific set of device registers. The Arm cor=
es
> > > interface to the PKA hardware through rings and a 64KB memory known a=
s
> > > Window RAM. There are multiple PKA devices on the BlueField SoC. In
> > > general, each PKA device has 4 rings, 1 window RAM and 1 True Random
> > > Number Generator (TRNG). Thus, the driver has been designed to probe
> > > each PKA and each individual ring inside a given PKA. It also registe=
rs
> > > the TRNG to feed the kernel entropy (i.e., /dev/hwrng). To implement
> > > such design, the driver creates individual device files for each ring
> > > and TRNG module. The ring device files are identified using their ids=
,
> > > i.e., /dev/mlxbf_pka/<ring_id>.
> > >
> > > The main driver logic such as probe() and remove() are implemented in
> > > mlxbf_pka_drv.c. The PKA ring device operations are also implemented =
in
> > > this source file, such as open(), release() and mmap().
> > >
> > > The mlxbf_pka_dev.c source file implements functions to operate the
> > > underlying PKA hardware, such as TRNG operation, PKA hardware I/O
> > > access, PKA memory resource operation, etc.
> > >
> > > The PKA driver is a lighweight driver that implements file operations
> > > and map memory regions of the PKA hardware to user space drivers and
> > > libraries. There is no in-kernel crypto support. Therefore, the PKA
> > > driver is included under drivers/platform/mellanox.
> > >
> > > Testing
> > >
> > > - Successful build of kernel for ARM64.
> > >
> > > - Tested ARM64 build on several Mellanox BlueField 2 and 3 SoC boards
> > > that include the PKA hardware. The testing includes the validation of
> > > the PKA hardware execution, random number generation and public key
> > > acceleration performance.
> >=20
> > Hi,
> >=20
> > We've the in-kernel crypto framework but I don't see any attempt to bui=
ld
> > into that framework AFAICT. Why is that? You brush it off as "The PKA
> > driver is a lightweight driver ..." but lets see if the crypto people
> > agree with that approach (I added them).
> >=20
> > (Please also Cc crypto people in any further submission.)

I don't see crypto people Cc'ed in v2 :-(.

> > > +     ring->ring_info->cmmd_base =3D cmd_desc_ring_base;
> >=20
> > Is cmmd a typo?
> >=20
> Ron Answer: This is from the PKA IP document description:
> Command ring base address control words (RING_CMMD_BASE_0 =E2=80=A6 _n).

Hmm, is that document consistent in shortening "command" to "cmmd"? It=20
feel quite untypical and might be a typo in that document too.

If it looks inconsistent in that document, my suggestion is to use=20
cmd_base and add a comment where you define ring_info's struct to map it=20
into the RING_CMMD_BASE_0 spelling in the document.

> > > +             /* Check test status bits. */
> > > +             csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_r=
eg_base,
> > > +                                                             MLXBF_P=
KA_TRNG_INTACK_ADDR);
> > > +             if (status & MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL) {
> > > +                     mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off=
,
> > > +                                            MLXBF_PKA_TRNG_STATUS_MO=
NOBIT_FAIL);
> > > +                     *monobit_fail_cnt +=3D 1;
> > > +             } else if (status & MLXBF_PKA_TRNG_STATUS_RUN_FAIL) {
> > > +                     mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off=
,
> > > +                                            MLXBF_PKA_TRNG_STATUS_RU=
N_FAIL);
> > > +                     *run_fail_cnt +=3D 1;
> > > +             } else if (status & MLXBF_PKA_TRNG_STATUS_POKER_FAIL) {
> > > +                     mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off=
,
> > > +                                            MLXBF_PKA_TRNG_STATUS_PO=
KER_FAIL);
> > > +                     *poker_fail_cnt +=3D 1;
> > > +             }
> >=20
> > Are these fails prioritized like this so it's should count just into on=
e
> > counter if more than one FAIL is asserted?
> >=20
> Ron Answer: the monobit_fail_cnt, run_fail_cnt and poker_fail_cnt are use=
d to represent different type
> of failure counts. Will be printed separately in debug message.

Unfortunately, this didn't answer my question. Can those bits be asserted=
=20
at the same time? If they can, is it okay to count the failure into just a=
=20
one of the failure counters?

> > > +static void mlxbf_pka_drv_get_mem_res(struct mlxbf_pka_device
> > *mlxbf_pka_dev,
> > > +                                   struct mlxbf_pka_dev_mem_res *mem=
_res,
> > > +                                   u64 wndw_ram_off_mask)
> > > +{
> > > +     enum mlxbf_pka_mem_res_idx acpi_mem_idx;
> > > +
> > > +     acpi_mem_idx =3D MLXBF_PKA_ACPI_EIP154_IDX;
> > > +     mem_res->wndw_ram_off_mask =3D wndw_ram_off_mask;
> > > +
> > > +     /* PKA EIP154 MMIO base address. */
> > > +     mem_res->eip154_base =3D mlxbf_pka_dev->resource[acpi_mem_idx]-
> > >start;
> > > +     mem_res->eip154_size =3D mlxbf_pka_dev->resource[acpi_mem_idx]-
> > >end -
> > > +                            mem_res->eip154_base + 1;
> >=20
> > resource_size(), please change all of them.
> >=20
> > > +     acpi_mem_idx++;
> > > +
> > > +     /* PKA window RAM base address. */
> > > +     mem_res->wndw_ram_base =3D mlxbf_pka_dev-
> > >resource[acpi_mem_idx]->start;
> > > +     mem_res->wndw_ram_size =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]-
> > >end -
> > > +                              mem_res->wndw_ram_base + 1;
> > > +     acpi_mem_idx++;
> > > +
> > > +     /*
> > > +      * PKA alternate window RAM base address.
> > > +      * Note: the size of all the alt window RAM is the same, depict=
ed by
> > 'alt_wndw_ram_size'
> > > +      * variable. All alt window RAM resources are read here even th=
ough not
> > all of them are used
> > > +      * currently.
> > > +      */
> > > +     mem_res->alt_wndw_ram_0_base =3D mlxbf_pka_dev-
> > >resource[acpi_mem_idx]->start;
> > > +     mem_res->alt_wndw_ram_size   =3D mlxbf_pka_dev-
> > >resource[acpi_mem_idx]->end -
> > > +                                    mem_res->alt_wndw_ram_0_base + 1=
;
> > > +
> > > +     if (mem_res->alt_wndw_ram_size !=3D
> > MLXBF_PKA_WINDOW_RAM_REGION_SIZE)
> > > +             dev_err(mlxbf_pka_dev->device, "alternate Window RAM si=
ze from
> > ACPI is wrong.\n");
> >=20
> > Should this return error and result in failing to register the device?
> >=20
> Ron Answer: if the alternative Window RAM is not properly initialized, th=
e PKA will fall back to contiguous
> Window RAM.
> Also, the alternative Window RAM is not available in BlueField DPU. This =
check will give warning,
> in case the DPU customer manually updated the ACIP table to use alternati=
ve Window RAM.

Please downgrade it into dev_warn() then.

Things like this might be nice to mention also into changelog so that it=20
is permanently recorded somewhere. At least to me, the fallback doesn't=20
look obvious from the code alone and one day it might be that neither of=20
us is around to tell it when a 3rd person comes and has to figure this=20
code out. :-)

> > This is extremely long and it would make reviewing it significantly eas=
ier
> > if it would be split into multiple, logical patches. Mixing two types o=
f
> > devices in a single probe adds to the confusion, can like one of those =
be
> > introduced first and then the other?

I think you might have misunderstood this comment. I didn't mean to=20
address my code style and kernel API comments in separate patches, those=20
should be used right when new code is introduced.

It would be large benefit if this single big change could be split into=20
multiple patches so that you introduce this support in multiple steps.
As noted above, one potential thing would be to add the types in different=
=20
changes (if possible). If there are features which can be separated into=20
own patches, that would also help to bring the lines added per patch down=
=20
helping to review each patch, and allow writing more focused changelog=20
entry for each change, etc.

Please do realize that by posting a large patch like this, you'll place=20
this patch into a very disadvantaged position. Small patches are easy to=20
review quickly, whereas large one like this take considerable time, so the=
=20
chance for me or other reviewers finding time to go through it are much=20
lower than if the series consists smaller patches.


--=20
 i.
--8323328-1565688773-1754992195=:995--
