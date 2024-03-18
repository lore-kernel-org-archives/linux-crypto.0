Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C77524A3;
	Mon, 18 Mar 2024 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710776454; cv=none; b=H6H7qP+HiW+6Sr3WCUdHGFYJa0fQ/PKJ5GPBEHInNhknvX/4/rz6nSVLQGGpOBoKOb+rRYu+2x3hAqRHcZNQmF3JwtfdJIZkSXwEkNKca6WOw39KfNl2X6paNTos7Z/COUD5N4hJ6P7S5/kAxrrInqCDl1a/d/HqqzkOqPjdm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710776454; c=relaxed/simple;
	bh=FBrOlJvXFAF+fJLFx9jaQz5Qj+OM+k7M02d3q+6Y+yw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nk/IfAIMD5MRTdW+1HLESIwKtOtdC4c7wrh24fc3mdyiNksJWAN94yVS1CbyaS6WkGWsf5LGHyOJBlIPovSmS5Xv9+sN00KZSbS7oJk59Ly1AVSZLNExfh5nsf8SVy6hhKgRYBiFRUctccRg0PgK14lmDF7gP3FKAAY0mLAlRZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JrDmFBkR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrDmFBkR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710776453; x=1742312453;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FBrOlJvXFAF+fJLFx9jaQz5Qj+OM+k7M02d3q+6Y+yw=;
  b=JrDmFBkRvjzQANw7yC1Zgtivc6arcGTQTcPWU1+Jq4AbB1rLww5RY5Lr
   lCl5hsAvQhstYh6IB2gkvjfkr81UqRbxIBDeKVV9Df3uOzWGwMuIbA12R
   vXN0nw3z0cCxGz+Aeu03QWzXzmTW82O2RCU77DVUBAs5EYQ0wezvgoXVy
   L4xN/JAp0YB2jPYS5msd2XekaplNlzlDS0od6mdRiPfPhoTGYS7btDVvx
   Kqrapw9/IcxHzlBzjGkKRGAmACkwDWzUeOdAV8m/ixB1DK5dqdr2COLVs
   xm4K9jteSVK/UN1W9ffkIajQRMRZGrbv4PRtmYgLgFOEE3NedIvyebwGm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5725167"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5725167"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13973153"
Received: from dnbrink1-mobl.amr.corp.intel.com ([10.213.185.27])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:40:51 -0700
Message-ID: <7c6036e55769033d7a5192e4b698d80f560faf10.camel@linux.intel.com>
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Date: Mon, 18 Mar 2024 10:40:35 -0500
In-Reply-To: <20240318064421.833348-1-jsnitsel@redhat.com>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
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

On Sun, 2024-03-17 at 23:44 -0700, Jerry Snitselaar wrote:
> This cleans up the following issues I ran into when trying to use the
> scripts and commands in the iaa-crypto.rst document.
>=20
> - Fix incorrect arguments being passed to accel-config
> =C2=A0 config-wq.
> =C2=A0=C2=A0=C2=A0 - Replace --device_name with --driver-name.
> =C2=A0=C2=A0=C2=A0 - Replace --driver_name with --driver-name.
> =C2=A0=C2=A0=C2=A0 - Replace --size with --wq-size.
> =C2=A0=C2=A0=C2=A0 - Add missing --priority argument.
> - Add missing accel-config config-engine command after the
> =C2=A0 config-wq commands.
> - Fix wq name passed to accel-config config-wq.
> - Add rmmod/modprobe of iaa_crypto to script that disables,
> =C2=A0 then enables all devices and workqueues to avoid enable-wq
> =C2=A0 failing with -EEXIST when trying to register to compression
> =C2=A0 algorithm.
> - Fix device name in cases where iaa was used instead of iax.
>=20
=20
Yeah, I have these fixes in my own test scripts as well - I thought I
had updated the docs with them but obviously not :-/

Thanks for noticing/testing and fixing them.

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>

> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> ---
> =C2=A0.../driver-api/crypto/iaa/iaa-crypto.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 22 ++++++++++++++---
> --
> =C2=A01 file changed, 16 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> index de587cf9cbed..330d35df5f16 100644
> --- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> +++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> @@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
> =C2=A0
> =C2=A0=C2=A0 # configure wq1.0
> =C2=A0
> -=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --type=
=3Dkernel
> --name=3D"iaa_crypto" --device_name=3D"crypto" iax1/wq1.0
> +=C2=A0 accel-config config-wq --group-id=3D0 --mode=3Ddedicated --type=
=3Dkernel
> --priority=3D10 --name=3D"iaa_crypto" --driver-name=3D"crypto" iax1/wq1.0
> +
> +=C2=A0 accel-config config-engine iax1/engine1.0 --group-id=3D0
> =C2=A0
> =C2=A0=C2=A0 # enable IAA device iax1
> =C2=A0
> @@ -536,12 +538,20 @@ The below script automatically does that::
> =C2=A0
> =C2=A0=C2=A0 echo "End Disable IAA"
> =C2=A0
> +=C2=A0 echo "Reload iaa_crypto module"
> +
> +=C2=A0 rmmod iaa_crypto
> +=C2=A0 modprobe iaa_crypto
> +
> +=C2=A0 echo "End Reload iaa_crypto module"
> +
> =C2=A0=C2=A0 #
> =C2=A0=C2=A0 # configure iaa wqs and devices
> =C2=A0=C2=A0 #
> =C2=A0=C2=A0 echo "Configure IAA"
> =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=3D0 --m=
ode=3Ddedicated --
> size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --
> driver_name=3D"crypto" iax${i}/wq${i}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-wq --group-id=3D0 --m=
ode=3Ddedicated --wq-
> size=3D128 --priority=3D10 --type=3Dkernel --name=3D"iaa_crypto" --driver=
-
> name=3D"crypto" iax${i}/wq${i}.0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config config-engine iax${i}/engine=
${i}.0 --group-id=3D0
> =C2=A0=C2=A0 done
> =C2=A0
> =C2=A0=C2=A0 echo "End Configure IAA"
> @@ -552,10 +562,10 @@ The below script automatically does that::
> =C2=A0=C2=A0 echo "Enable IAA"
> =C2=A0
> =C2=A0=C2=A0 for ((i =3D 1; i < ${num_iaa} * 2; i +=3D 2)); do
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iaa${i}
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iaa${i}
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iaa${i}/wq${i}.0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iaa${i}/wq${i}.0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable iaa iax${i}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-device iax${i}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo enable wq iax${i}/wq${i}.0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 accel-config enable-wq iax${i}/wq${i}.0
> =C2=A0=C2=A0 done
> =C2=A0
> =C2=A0=C2=A0 echo "End Enable IAA"

