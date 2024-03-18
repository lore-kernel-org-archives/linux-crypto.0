Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31491E48A;
	Mon, 18 Mar 2024 16:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779196; cv=none; b=jzlp1uIHYonI0Gy8aDNpwdwfwAGX0yNV4giaIM15PtJOJ/tlFEk+2IOwoAmakAKkSnLOaq1qP/iFNdSxJ7ocrJRjOB65f5EmBVULdr99g1d/GazTzOX1CRVHHvPiifTM9bJIqWItpLTzP1fUPHC23tHn2lMi4pLDiiuYhfd2lXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779196; c=relaxed/simple;
	bh=GzCQ0T/Oj7b3duahAg2sYzIQSmkigW9h7sVVYU92pVQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mIwEHQNn51a14ts+IWhKPog7TbJfsyctW6V/UmQtYNF5HQOvRIuMB/mJLDsVoZBSbWXcd0D54t9KijhwmAuRXEsfzUJRJxpIQ7tGXUkr+b178bLj5roUwenak+nFD3RJk2sAxKpg2YbOHk0Rxk7CEmbCrInP1X4wYTAAKN5rX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTfmaIQo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTfmaIQo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779194; x=1742315194;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=GzCQ0T/Oj7b3duahAg2sYzIQSmkigW9h7sVVYU92pVQ=;
  b=QTfmaIQok5XL/n5tIxlJLbTMym9IBInoTLY8VDliH6xutJTGnyGnvBIJ
   4seTD7+sHes9kxjghZZmxvLm6jXHe2Hf0tAhBSV0jg1oMiRg1+j8kYcav
   dHH4xY8iZnsYvHgvSutEwmmvb1jSug6X2Cm6DtoNzLhvuu3XX1t4CE0qw
   KMzc1dJdlX/JIHMH3K/vM9GUdY39lWnTLOPmFI+iuNQfjDQD/3PRXuOcf
   SBcHdxmvuzMbv97ML1cZV4bR3YIsUZOGHH3Bm0yO39DvT0GdM/+VYGlU6
   e8YKo6CdAriwKGreALIV3taM1xMNyEWJmzgdYOM00El7760hn77CV0soT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="9375047"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="9375047"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13406411"
Received: from dnbrink1-mobl.amr.corp.intel.com ([10.213.185.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:33 -0700
Message-ID: <f6487dcb03a31c35c272225197af87795df2a409.camel@linux.intel.com>
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Date: Mon, 18 Mar 2024 11:26:31 -0500
In-Reply-To: <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
	 <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Jerry,

On Mon, 2024-03-18 at 00:49 -0700, Jerry Snitselaar wrote:
> On Sun, Mar 17, 2024 at 11:44:21PM -0700, Jerry Snitselaar wrote:
> > This cleans up the following issues I ran into when trying to use
> > the
> > scripts and commands in the iaa-crypto.rst document.
> >=20
> > - Fix incorrect arguments being passed to accel-config
> > =C2=A0 config-wq.
> > =C2=A0=C2=A0=C2=A0 - Replace --device_name with --driver-name.
> > =C2=A0=C2=A0=C2=A0 - Replace --driver_name with --driver-name.
> > =C2=A0=C2=A0=C2=A0 - Replace --size with --wq-size.
> > =C2=A0=C2=A0=C2=A0 - Add missing --priority argument.
> > - Add missing accel-config config-engine command after the
> > =C2=A0 config-wq commands.
> > - Fix wq name passed to accel-config config-wq.
> > - Add rmmod/modprobe of iaa_crypto to script that disables,
> > =C2=A0 then enables all devices and workqueues to avoid enable-wq
> > =C2=A0 failing with -EEXIST when trying to register to compression
> > =C2=A0 algorithm.
> > - Fix device name in cases where iaa was used instead of iax.
> >=20
> > Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-doc@vger.kernel.org
> > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > ---
> > =C2=A0.../driver-api/crypto/iaa/iaa-crypto.rst=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 22 ++++++++++++++-
> > ----
> > =C2=A01 file changed, 16 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > index de587cf9cbed..330d35df5f16 100644
> > --- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > +++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > @@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
> > =C2=A0
> > =C2=A0=C2=A0 # configure wq1.0
> > =C2=A0
> > -=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --
> > type=3Dkernel --name=3D"iaa_crypto" --device_name=3D"crypto" iax1/wq1.0
> > +=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --
> > type=3Dkernel --priority=3D10 --name=3D"iaa_crypto" --driver-
> > name=3D"crypto" iax1/wq1.0
> > +
> > +=C2=A0 accel-config config-engine iax1/engine1.0 --group-id=3D0
> > =C2=A0
> > =C2=A0=C2=A0 # enable IAA device iax1
> > =C2=A0
> > @@ -536,12 +538,20 @@ The below script automatically does that::
> > =C2=A0
> > =C2=A0=C2=A0 echo "End Disable IAA"
> > =C2=A0
> > +=C2=A0 echo "Reload iaa_crypto module"
> > +
> > +=C2=A0 rmmod iaa_crypto
> > +=C2=A0 modprobe iaa_crypto
> > +
> > +=C2=A0 echo "End Reload iaa_crypto module"
> > +
> > =C2=A0=C2=A0 #
> > =C2=A0=C2=A0 # configure iaa wqs and devices
> > =C2=A0=C2=A0 #
> > =C2=A0=C2=A0 echo "Configure IAA"
> > =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=3D0 -=
-mode=3Ddedicated --
> > size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --
> > driver_name=3D"crypto" iax${i}/wq${i}
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=3D0 -=
-mode=3Ddedicated --wq-
> > size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --driv=
er-
> > name=3D"crypto" iax${i}/wq${i}.0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-engine iax${i}/engi=
ne${i}.0 --group-id=3D0
> > =C2=A0=C2=A0 done
> > =C2=A0
> > =C2=A0=C2=A0 echo "End Configure IAA"
> > @@ -552,10 +562,10 @@ The below script automatically does that::
> > =C2=A0=C2=A0 echo "Enable IAA"
> > =C2=A0
> > =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iaa${i}
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iaa${i}
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iaa${i}/wq${i}.0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iaa${i}/wq${i}.0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iax${i}
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iax${i}
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iax${i}/wq${i}.0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iax${i}/wq${i}.0
> > =C2=A0=C2=A0 done
> > =C2=A0
> > =C2=A0=C2=A0 echo "End Enable IAA"
> > --=20
> > 2.41.0
> >=20
>=20
> In addition to the above, the sections related to the modes seem
> to be off to me.
>=20
> Legacy mode in the Intel IOMMU context is when the IOMMU does not
> have
> scalable mode enabled. If you pass intel_iommu=3Doff the Intel IOMMU
> will not be initialized, and I think that would correspond to the No
> IOMMU
> mode instead of Legacy mode. The other suggestion for Legacy mode of
> disabling VT-d in the BIOS would also be No IOMMU mode, but in
> addition to the dma remapping units being disabled it would disable
> interrupt remapping since the DMAR table would no longer be presented
> to the OS by the BIOS.
>=20
> I think the modes should be:
>=20
> Scalable mode: intel_iommu=3Don,sm_on
> Legacy mode: intel_iommu=3Don
> No IOMMU mode: intel_iommu=3Doff (or VT-d disabled in BIOS)
>=20

Yes, I think you're correct, those make more sense.

> Since Intel IOMMU and scabale mode have config options that allow
> them
> to be enabled by default, there are different parameter variations
> that would match the above cases. I don't know if they need to
> be detailed here, or if it would just make it more confusing.
>=20

Personally, I think it would be useful to have them detailed and might
lessen confusion for people setting things up and/or debugging a setup.

Thanks,

Tom

> Regards,
> Jerry
>=20

