Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7588028DB64;
	Thu, 29 May 2025 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748512307; cv=none; b=pswjRB/iueclrmTZF7UZ84GDZbzQl/fzWrcrBnIv3ZbTXExMksMBpz9PbWjxgve06CvrMjuV0gAJSTbJvnPXKA8nXIRJ8ZAb0YTaVW7BWEwd4e7hBdVV7coVTUHdScJ4AWvP9O3iB69yvJSPqfE13YPA6+H8Czj0NSQLxaky3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748512307; c=relaxed/simple;
	bh=OZsH8F+7jsk2HU7JWPEzcfoDDPzAr/AyR3QL1nKxMCE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lCRq0hTZASXl6wFbWKg05a+XeBtx8oS7P5HPfnalvdYidEwL08JAwN2IoW5rro6SSUcQVfvIrwXazGROH6b1O96ujBLqjWQ+wUHwNpo1vE3vGN6hnwbRI9XBKcWzxILfSWwisBoo5zbEb2OqgYONz2rvnAgrbQXwHzczSWg9KOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 11:51:43 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Thu, 29 May 2025 11:51:43 +0200
From: John Ernberg <john.ernberg@actia.se>
To: Frank Li <Frank.li@nxp.com>
CC: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "stable@kernel.org"
	<stable@kernel.org>
Subject: Re: [PATCH v3 1/4] crypto: caam - Prevent crash on suspend with
 iMX8QM / iMX8ULP
Thread-Topic: [PATCH v3 1/4] crypto: caam - Prevent crash on suspend with
 iMX8QM / iMX8ULP
Thread-Index: AQHbz97TifK0/bkJfUas794AaCBb6bPn/yOAgAE+KIA=
Date: Thu, 29 May 2025 09:51:43 +0000
Message-ID: <aDguL2HynKmYyWnS@w447anl.localdomain>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-2-john.ernberg@actia.se>
 <aDcjS+3ing1W81QY@lizhi-Precision-Tower-5810>
In-Reply-To: <aDcjS+3ing1W81QY@lizhi-Precision-Tower-5810>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453637562
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <BC60B83D8F1AE94D8772162555774B55@actia.se>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Frank,

On Wed, May 28, 2025 at 10:52:59AM -0400, Frank Li wrote:
> On Wed, May 28, 2025 at 02:43:07PM +0000, John Ernberg wrote:
> > Since the CAAM on these SoCs is managed by another ARM core, called the
> > SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, whi=
ch
> > also reserves access to register page 0 suspend operations cannot touch
> > this page.
> >
> > This is similar to when running OPTEE, where OPTEE will reserve page 0.
> >
> > Track this situation using a new state variable no_page0, reflecting if
> > page 0 is reserved elsewhere, either by other management cores in SoC o=
r
> > by OPTEE.
> >
> > Replace the optee_en check in suspend/resume with the new check.
> >
> > optee_en cannot go away as it's needed elsewhere to gate OPTEE specific
> > situations.
> >
> > Fixes the following splat at suspend:
> >
> >     Internal error: synchronous external abort: 0000000096000010 [#1] S=
MP
> >     Hardware name: Freescale i.MX8QXP ACU6C (DT)
> >     pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> >     pc : readl+0x0/0x18
> >     lr : rd_reg32+0x18/0x3c
> >     sp : ffffffc08192ba20
> >     x29: ffffffc08192ba20 x28: ffffff8025190000 x27: 0000000000000000
> >     x26: ffffffc0808ae808 x25: ffffffc080922338 x24: ffffff8020e89090
> >     x23: 0000000000000000 x22: ffffffc080922000 x21: ffffff8020e89010
> >     x20: ffffffc080387ef8 x19: ffffff8020e89010 x18: 000000005d8000d5
> >     x17: 0000000030f35963 x16: 000000008f785f3f x15: 000000003b8ef57c
> >     x14: 00000000c418aef8 x13: 00000000f5fea526 x12: 0000000000000001
> >     x11: 0000000000000002 x10: 0000000000000001 x9 : 0000000000000000
> >     x8 : ffffff8025190870 x7 : ffffff8021726880 x6 : 0000000000000002
> >     x5 : ffffff80217268f0 x4 : ffffff8021726880 x3 : ffffffc081200000
> >     x2 : 0000000000000001 x1 : ffffff8020e89010 x0 : ffffffc081200004
> >     Call trace:
> >      readl+0x0/0x18
> >      caam_ctrl_suspend+0x30/0xdc
> >      dpm_run_callback.constprop.0+0x24/0x5c
> >      device_suspend+0x170/0x2e8
> >      dpm_suspend+0xa0/0x104
> >      dpm_suspend_start+0x48/0x50
> >      suspend_devices_and_enter+0x7c/0x45c
> >      pm_suspend+0x148/0x160
> >      state_store+0xb4/0xf8
> >      kobj_attr_store+0x14/0x24
> >      sysfs_kf_write+0x38/0x48
> >      kernfs_fop_write_iter+0xb4/0x178
> >      vfs_write+0x118/0x178
> >      ksys_write+0x6c/0xd0
> >      __arm64_sys_write+0x14/0x1c
> >      invoke_syscall.constprop.0+0x64/0xb0
> >      do_el0_svc+0x90/0xb0
> >      el0_svc+0x18/0x44
> >      el0t_64_sync_handler+0x88/0x124
> >      el0t_64_sync+0x150/0x154
> >     Code: 88dffc21 88dffc21 5ac00800 d65f03c0 (b9400000)
> >
> > Fixes: d2835701d93c ("crypto: caam - i.MX8ULP donot have CAAM page0 acc=
ess")
> > Fixes: 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")
>=20
> Why need two fixes tags? It should be enough to keep oldest one.

It looked to me to improve clarity in affected supported modules by
highlighting when each module support was added. I'll drop the second one.

Best regards // John Ernberg

>=20
> Frank
> =
