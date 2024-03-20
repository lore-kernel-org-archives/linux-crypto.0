Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA04E1DFC6
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958432; cv=none; b=CtCC4qCaEx1tNOW15TiLTl6/IqlGKocCiuqCBAmuc/S7A482cAfCPWgCDndcJIrnJXar3S21N8JUW6gh+4HPkhb5eHD7hZIFcMq+0jl2L551LvnzN9tYVPEqaiduXcjK1TI6ULANIB7vp87bcyKdgVLAZCzdxcGguVGwKbOang8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958432; c=relaxed/simple;
	bh=1IQXI7XkZbPfT38EFmqDXCjPCYkAfzTQ/vAI62h4DZI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bWSN6O2Q8gRnm/GXC22TPfOG8Hh/MTGz/gjDWNaItxCLnvWC9OTk1RMc2FgYsI04bMhTjbfuTKirRQxDzJYcAUUFtqAxAYav9TExHs5U89guXY5gYYkjZu7lcvTq7/hoJsoKEWlmvV2Gq7ZOVNyxE1ve4Rbc8yM/yPD9JO9BoWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DoyI/INu; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DoyI/INu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710958431; x=1742494431;
  h=message-id:subject:from:to:date:in-reply-to:references:
   content-transfer-encoding:mime-version;
  bh=1IQXI7XkZbPfT38EFmqDXCjPCYkAfzTQ/vAI62h4DZI=;
  b=DoyI/INu7w+ZbM3s2Ubo5kK39YfzuKzYiUvKirpABareAk4odp/W9wnf
   GwTwJUslH3Qly0pt4UTYvazmOiggS9DJEb/rU+Qsl61UDgKhqD5If773N
   ETGk9g9dM4TslGPrg+j5sqUMF2pkVtnK3O7hBngJtkszRks/qEeBXOGbm
   e+Esad/bs/sKU3NwELCfU+E16ewYqf7ADSuuI8NmKQ9yDkRJ4PLDwq7BB
   tI7lJ5y9pyKSFbRKXe5p1alhIwPm+aAplLiyIf4Q4JswHPKrzCIyvfyKW
   NodSCoB9vxpHyvRvka3uepK7r6gqZmwAoJ2I07q4gznDvuhTwpeh6E+99
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6514283"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="6514283"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 11:13:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14123513"
Received: from ahentabl-mobl1.amr.corp.intel.com ([10.213.169.123])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 11:13:49 -0700
Message-ID: <4e917f9a299c46c82e1eb206c26e349fb7d810e7.camel@linux.intel.com>
Subject: Re: Divide by zero in iaa_crypto during boot of a kdump kernel
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org
Date: Wed, 20 Mar 2024 13:13:48 -0500
In-Reply-To: <39f73bd559aa96051b4d5c8e42d0ce942194b64f.camel@linux.intel.com>
References: 
	<hyf3fggjvnjjdbkk4hvocmlfhbz2wapxjhmppurthqavgvk23m@j47q5vlzb2om>
	 <39f73bd559aa96051b4d5c8e42d0ce942194b64f.camel@linux.intel.com>
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

On Tue, 2024-03-19 at 17:19 -0500, Tom Zanussi wrote:
> Hi Jerry,
>=20
> On Tue, 2024-03-19 at 13:51 -0700, Jerry Snitselaar wrote:
> > Hi Tom,
> >=20
> > While looking at a different issue on a GNR system I noticed that
> > during the boot of the kdump kernel it crashes when probing
> > iaa_crypto
> > due to a divide by zero in rebalance_wq_table. The problem is that
> > the
> > kdump kernel comes up with a single cpu, and if there are multiple
> > iaa
> > devices cpus_per_iaa is going to be calculated to be 0, and then
> > the
> > 'if ((cpu % cpus_per_iaa) =3D=3D 0)' in rebalance_wq_table results in a
> > divide by zero. I reproduced it with the 6.8 eln kernel, and so far
> > have reproduced it on GNR, EMR, and SRF systems. I'm assuming the
> > same
> > will be the case on and SPR system with IAA devices enabled if I
> > can
> > find one.
> >=20
>=20
> Good catch, I've never tested that before. Thanks for reporting it.
>=20
> > Should save_iaa_wq return an error if the number of iaa devices is
> > greater
> > than the number of cpus?
> >=20
>=20
> No, you should still be able to use the driver with just one cpu,
> maybe
> it just always maps to the same device. I'll take a look and come up
> with a fix.
>=20
> Tom

The patch below fixes it for me. It gets rid of the crash and I was
able to run some basic tests successfully.

Tom=20


From 37dc97831c9e12c103115cb5fc9866b42cad7bc5 Mon Sep 17 00:00:00 2001
From: Tom Zanussi <tom.zanussi@linux.intel.com>
Date: Wed, 20 Mar 2024 05:37:11 -0700
Subject: [PATCH] crypto: iaa - Fix nr_cpus < nr_iaa case

If nr_cpus < nr_iaa, the calculated cpus_per_iaa will be 0, which
causes a divide-by-0 in rebalance_wq_table().

Make sure cpus_per_iaa is 1 in that case, and also in the nr_iaa =3D=3D 0
case, even though cpus_per_iaa is never used if nr_iaa =3D=3D 0, for
paranoia.

Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/in=
tel/iaa/iaa_crypto_main.c
index 1cd304de5388..b2191ade9011 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -806,6 +806,8 @@ static int save_iaa_wq(struct idxd_wq *wq)
 		return -EINVAL;
=20
 	cpus_per_iaa =3D (nr_nodes * nr_cpus_per_node) / nr_iaa;
+	if (!cpus_per_iaa)
+		cpus_per_iaa =3D 1;
 out:
 	return 0;
 }
@@ -821,10 +823,12 @@ static void remove_iaa_wq(struct idxd_wq *wq)
 		}
 	}
=20
-	if (nr_iaa)
+	if (nr_iaa) {
 		cpus_per_iaa =3D (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	else
-		cpus_per_iaa =3D 0;
+		if (!cpus_per_iaa)
+			cpus_per_iaa =3D 1;
+	} else
+		cpus_per_iaa =3D 1;
 }
=20
 static int wq_table_add_wqs(int iaa, int cpu)
--=20
2.34.1


