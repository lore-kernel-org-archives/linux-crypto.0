Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850BE56477;
	Mon, 18 Mar 2024 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788486; cv=none; b=XPxchKNo6eoqXBCZOUIebKT+1Wss5IHGFLPIyXLdVUmsNF6Dn2+P4jcdt5DAmgaBmwwwstTlaWDxOH3huWCW1cY4G7WktLMvrguQCfVXYBvp3BrrIs8yPXkX9uNH6GBHGadxnnm9699NCIgmdegWi4/YkJicAgkyKN3sDo5joWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788486; c=relaxed/simple;
	bh=OxNePLoBIiYfhf7rJ+CsXzbOYzRfOgWeHyoFs3PZ85Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kTHcWaxhDTkB6sBV1Ix5HJoUWvDsgUOgFIBA4IilKBV0miH9WQdpEwf1fuI11hHXZodg3/qgCHARasg9YEiq2Zv62TeXegnPHhCLzCrMxErqWKqpfZTpxMcZt4kr0f1kQWm1N4mzM3iTK+v1R2w0m6vF1/3kqmkfKtW2PmzQpfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfqWyHcd; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfqWyHcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710788485; x=1742324485;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=OxNePLoBIiYfhf7rJ+CsXzbOYzRfOgWeHyoFs3PZ85Y=;
  b=PfqWyHcd8D8UpIYpckAlHjAW4hjhda8QuNhHlRkM9ZwlZxcmWN0lqQc6
   KUOUDF3a8YoXGxzdG0Xckog3dACPrjvWi1NhJhwOTo/OQA/DnHhgf3R9u
   qTXYogbJWVBOIw1EWSyV/arnbnAIPh3q/75fjQakBWgI6kjkkz3oUMPMF
   ex/0ENKll9lAx32j424KQdwblVWjK1UQrpxViN5FSHErV9PAc5VraR2pf
   7M/D5SpRhxebiYWyr+o+Wifyd/Be4Wj/odfzY8BWICwJmYZwS5HzbEh5x
   A6dPK7jbH+dWU8L8KjmrYwyQX130h/HRjz0NsJE+dQUifcSoUQRr8KCaU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5461309"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5461309"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 12:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="18258273"
Received: from lyuan1-desk.amr.corp.intel.com ([10.213.183.196])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 12:01:19 -0700
Message-ID: <64229faa848b78d263a9383f664b0c269ffd65c3.camel@linux.intel.com>
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Date: Mon, 18 Mar 2024 14:01:18 -0500
In-Reply-To: <hdb2l73guzxz2ck5qbkvpmpfiez646t33ocfqawdgxrnemwrpp@izvr4k6b2jft>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
	 <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
	 <f6487dcb03a31c35c272225197af87795df2a409.camel@linux.intel.com>
	 <hdb2l73guzxz2ck5qbkvpmpfiez646t33ocfqawdgxrnemwrpp@izvr4k6b2jft>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-03-18 at 10:58 -0700, Jerry Snitselaar wrote:
> On Mon, Mar 18, 2024 at 11:26:31AM -0500, Tom Zanussi wrote:
> > Hi Jerry,
> >=20
> > On Mon, 2024-03-18 at 00:49 -0700, Jerry Snitselaar wrote:
> > > On Sun, Mar 17, 2024 at 11:44:21PM -0700, Jerry Snitselaar wrote:
> > > > This cleans up the following issues I ran into when trying to use
> > > > the
> > > > scripts and commands in the iaa-crypto.rst document.
> > > >=20
> > > > - Fix incorrect arguments being passed to accel-config
> > > > =C2=A0 config-wq.
> > > > =C2=A0=C2=A0=C2=A0 - Replace --device_name with --driver-name.
> > > > =C2=A0=C2=A0=C2=A0 - Replace --driver_name with --driver-name.
> > > > =C2=A0=C2=A0=C2=A0 - Replace --size with --wq-size.
> > > > =C2=A0=C2=A0=C2=A0 - Add missing --priority argument.
> > > > - Add missing accel-config config-engine command after the
> > > > =C2=A0 config-wq commands.
> > > > - Fix wq name passed to accel-config config-wq.
> > > > - Add rmmod/modprobe of iaa_crypto to script that disables,
> > > > =C2=A0 then enables all devices and workqueues to avoid enable-wq
> > > > =C2=A0 failing with -EEXIST when trying to register to compression
> > > > =C2=A0 algorithm.
> > > > - Fix device name in cases where iaa was used instead of iax.
> > > >=20
> > > > Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> > > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > > Cc: linux-crypto@vger.kernel.org
> > > > Cc: linux-doc@vger.kernel.org
> > > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > > ---
> > > > =C2=A0.../driver-api/crypto/iaa/iaa-crypto.rst=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 22 ++++++++++++++-
> > > > ----
> > > > =C2=A01 file changed, 16 insertions(+), 6 deletions(-)
> > > >=20
> > > > diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > > b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > > index de587cf9cbed..330d35df5f16 100644
> > > > --- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > > +++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > > @@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
> > > > =C2=A0
> > > > =C2=A0=C2=A0 # configure wq1.0
> > > > =C2=A0
> > > > -=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --
> > > > type=3Dkernel --name=3D"iaa_crypto" --device_name=3D"crypto" iax1/w=
q1.0
> > > > +=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --
> > > > type=3Dkernel --priority=3D10 --name=3D"iaa_crypto" --driver-
> > > > name=3D"crypto" iax1/wq1.0
> > > > +
> > > > +=C2=A0 accel-config config-engine iax1/engine1.0 --group-id=3D0
> > > > =C2=A0
> > > > =C2=A0=C2=A0 # enable IAA device iax1
> > > > =C2=A0
> > > > @@ -536,12 +538,20 @@ The below script automatically does that::
> > > > =C2=A0
> > > > =C2=A0=C2=A0 echo "End Disable IAA"
> > > > =C2=A0
> > > > +=C2=A0 echo "Reload iaa_crypto module"
> > > > +
> > > > +=C2=A0 rmmod iaa_crypto
> > > > +=C2=A0 modprobe iaa_crypto
> > > > +
> > > > +=C2=A0 echo "End Reload iaa_crypto module"
> > > > +
> > > > =C2=A0=C2=A0 #
> > > > =C2=A0=C2=A0 # configure iaa wqs and devices
> > > > =C2=A0=C2=A0 #
> > > > =C2=A0=C2=A0 echo "Configure IAA"
> > > > =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=
=3D0 --mode=3Ddedicated --
> > > > size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --
> > > > driver_name=3D"crypto" iax${i}/wq${i}
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=
=3D0 --mode=3Ddedicated --wq-
> > > > size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --=
driver-
> > > > name=3D"crypto" iax${i}/wq${i}.0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-engine iax${i}/=
engine${i}.0 --group-id=3D0
> > > > =C2=A0=C2=A0 done
> > > > =C2=A0
> > > > =C2=A0=C2=A0 echo "End Configure IAA"
> > > > @@ -552,10 +562,10 @@ The below script automatically does that::
> > > > =C2=A0=C2=A0 echo "Enable IAA"
> > > > =C2=A0
> > > > =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iaa${i}
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iaa${i}
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iaa${i}/wq${i}.0
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iaa${i}/wq${=
i}.0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iax${i}
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iax${i}
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iax${i}/wq${i}.0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iax${i}/wq${=
i}.0
> > > > =C2=A0=C2=A0 done
> > > > =C2=A0
> > > > =C2=A0=C2=A0 echo "End Enable IAA"
> > > > --=20
> > > > 2.41.0
> > > >=20
> > >=20
> > > In addition to the above, the sections related to the modes seem
> > > to be off to me.
> > >=20
> > > Legacy mode in the Intel IOMMU context is when the IOMMU does not
> > > have
> > > scalable mode enabled. If you pass intel_iommu=3Doff the Intel IOMMU
> > > will not be initialized, and I think that would correspond to the No
> > > IOMMU
> > > mode instead of Legacy mode. The other suggestion for Legacy mode of
> > > disabling VT-d in the BIOS would also be No IOMMU mode, but in
> > > addition to the dma remapping units being disabled it would disable
> > > interrupt remapping since the DMAR table would no longer be presented
> > > to the OS by the BIOS.
> > >=20
> > > I think the modes should be:
> > >=20
> > > Scalable mode: intel_iommu=3Don,sm_on
> > > Legacy mode: intel_iommu=3Don
> > > No IOMMU mode: intel_iommu=3Doff (or VT-d disabled in BIOS)
> > >=20
> >=20
> > Yes, I think you're correct, those make more sense.
> >=20
> > > Since Intel IOMMU and scabale mode have config options that allow
> > > them
> > > to be enabled by default, there are different parameter variations
> > > that would match the above cases. I don't know if they need to
> > > be detailed here, or if it would just make it more confusing.
> > >=20
> >=20
> > Personally, I think it would be useful to have them detailed and might
> > lessen confusion for people setting things up and/or debugging a setup.
> >=20
> > Thanks,
> >=20
> > Tom
>=20
> Hi Tom,
>=20
> This is what I came up with last night for the kernel parameters when thi=
nking about it:
>=20
>=20
> > mode \ default enable | intel_iommu + /sm + | intel_iommu + / sm - | in=
tel_iommu - / sm +=C2=A0 | intel_iommu - / sm - |
> > -----------------------+---------------------+----------------------+--=
---------------------+----------------------|
> > Scalable Mode=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | nothing=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
intel_iommu=3Dsm_on=C2=A0=C2=A0=C2=A0 | intel_iommu=3Don=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | intel_iommu=3Don,sm_on |
> > Legacy Mode=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | intel_iommu=3Dsm_off=C2=A0 | nothing=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | intel_iommu=3Don,sm_off | inte=
l_iommu=3Don=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > No IOMMU Mode=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | intel_i=
ommu=3Doff=C2=A0=C2=A0=C2=A0=C2=A0 | intel_iommu=3Doff=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | nothing=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | nothing=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>=20

Very nice. I think it would need a little explanation on how to read
the table and mention of how the defaults correspond to actual config
options e.g. sm+ =3D CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=3Dy,
etc...

Thanks,

Tom

>=20
> Regards,
> Jerry
>=20
>=20
>=20
> >=20
> > > Regards,
> > > Jerry
> > >=20
> >=20
>=20

