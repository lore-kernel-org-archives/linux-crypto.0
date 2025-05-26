Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F21078F;
	Mon, 26 May 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748263528; cv=none; b=IecyVhnGqEK1X2MkFepmlHMTG5Qvplgb85lPvZw8UodmRzck0We1A/w61zBunTHiJOYAxSjWpCMdxsKj61iPlW+Ci8CZN5LDBxDiJyGTutbOrbZi/ki0E0jTVp+nki6OsdfXT2RgALwADxIHB7aZ7fIDfAuYkjteit7O2p3cJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748263528; c=relaxed/simple;
	bh=fUMkC54ExXAQDZmKlaWEpzOJeLeyL1swg+GYQX+1OhE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f1jexwXiFrL5YgSqy1LXwpdnHDKT4wKFUFIzz7CKJ2WCoTrS2lhIBVwnHfKQb/jsXwfieyNCjR0bQGbVgztK6bs2LLTSpVRmLn4p3ERvbGkCLIpfj5gpCzc47f2AApfWgOBNdb+dza1JbUo/ZShtxqGTXuxFqE6bWLcPJosXV90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 26 May
 2025 14:45:14 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Mon, 26 May 2025 14:45:14 +0200
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
Subject: Re: [PATCH 1/4] crypto: caam - Prevent crash on suspend with iMX8QM /
 iMX8ULP
Thread-Topic: [PATCH 1/4] crypto: caam - Prevent crash on suspend with iMX8QM
 / iMX8ULP
Thread-Index: AQHby+Uubq4/T0/2xEa3pJeQa3AymLPgGseAgAAHVgCAAAgpgIAElG2A
Date: Mon, 26 May 2025 12:45:14 +0000
Message-ID: <aDRiU45e6s8sgq8y@w447anl.localdomain>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
 <20250523131814.1047662-2-john.ernberg@actia.se>
 <aDB909HDzfUaA3hv@lizhi-Precision-Tower-5810>
 <b62d6620-4c31-41e4-b510-130f0af66c79@actia.se>
 <aDCK00bzc6RDKu5s@lizhi-Precision-Tower-5810>
In-Reply-To: <aDCK00bzc6RDKu5s@lizhi-Precision-Tower-5810>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-esetresult: clean, is OK
x-esetid: 37303A2956B1445360736A
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <C03B5729AFF8504B84163DF7ECF2C804@actia.se>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Frank,

On Fri, May 23, 2025 at 10:48:51AM -0400, Frank Li wrote:
> On Fri, May 23, 2025 at 02:19:38PM +0000, John Ernberg wrote:
> > Hi Frank,
> >
> > On 5/23/25 3:53 PM, Frank Li wrote:
> > > On Fri, May 23, 2025 at 01:18:32PM +0000, John Ernberg wrote:
> > >> Since the CAAM on these SoCs is managed by another ARM core, called =
the
> > >> SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, =
which
> > >> also reserves access to register page 0 suspend operations cannot to=
uch
> > >> this page.
> > >>
> > >> Introduce a variable to track this situation. Since this is synonymo=
us
> > >> with the optee case in suspend/resume the optee check is replaced wi=
th
> > >> this new check.
> > >>
> > >> Fixes the following splat at suspend:
> > >>
> > >>      Internal error: synchronous external abort: 0000000096000010 [#=
1] SMP
> > >>      Hardware name: Freescale i.MX8QXP ACU6C (DT)
> > >>      pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D-=
-)
> > >>      pc : readl+0x0/0x18
> > >>      lr : rd_reg32+0x18/0x3c
> > >>      sp : ffffffc08192ba20
> > >>      x29: ffffffc08192ba20 x28: ffffff8025190000 x27: 00000000000000=
00
> > >>      x26: ffffffc0808ae808 x25: ffffffc080922338 x24: ffffff8020e890=
90
> > >>      x23: 0000000000000000 x22: ffffffc080922000 x21: ffffff8020e890=
10
> > >>      x20: ffffffc080387ef8 x19: ffffff8020e89010 x18: 000000005d8000=
d5
> > >>      x17: 0000000030f35963 x16: 000000008f785f3f x15: 000000003b8ef5=
7c
> > >>      x14: 00000000c418aef8 x13: 00000000f5fea526 x12: 00000000000000=
01
> > >>      x11: 0000000000000002 x10: 0000000000000001 x9 : 00000000000000=
00
> > >>      x8 : ffffff8025190870 x7 : ffffff8021726880 x6 : 00000000000000=
02
> > >>      x5 : ffffff80217268f0 x4 : ffffff8021726880 x3 : ffffffc0812000=
00
> > >>      x2 : 0000000000000001 x1 : ffffff8020e89010 x0 : ffffffc0812000=
04
> > >>      Call trace:
> > >>       readl+0x0/0x18
> > >>       caam_ctrl_suspend+0x30/0xdc
> > >>       dpm_run_callback.constprop.0+0x24/0x5c
> > >>       device_suspend+0x170/0x2e8
> > >>       dpm_suspend+0xa0/0x104
> > >>       dpm_suspend_start+0x48/0x50
> > >>       suspend_devices_and_enter+0x7c/0x45c
> > >>       pm_suspend+0x148/0x160
> > >>       state_store+0xb4/0xf8
> > >>       kobj_attr_store+0x14/0x24
> > >>       sysfs_kf_write+0x38/0x48
> > >>       kernfs_fop_write_iter+0xb4/0x178
> > >>       vfs_write+0x118/0x178
> > >>       ksys_write+0x6c/0xd0
> > >>       __arm64_sys_write+0x14/0x1c
> > >>       invoke_syscall.constprop.0+0x64/0xb0
> > >>       do_el0_svc+0x90/0xb0
> > >>       el0_svc+0x18/0x44
> > >>       el0t_64_sync_handler+0x88/0x124
> > >>       el0t_64_sync+0x150/0x154
> > >>      Code: 88dffc21 88dffc21 5ac00800 d65f03c0 (b9400000)
> > >>
> > >> Fixes: d2835701d93c ("crypto: caam - i.MX8ULP donot have CAAM page0 =
access")
> > >> Fixes: 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")
> > >> Cc: stable@kernel.org # v6.10+
> > >> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> > >>
> > >> ---
> > >>
> > >> I noticed this when enabling the iMX8QXP support (next patch), hence=
 the
> > >> iMX8QXP backtrace, but the iMX8QM CAAM integration works exactly the=
 same
> > >> and according to the NXP tree [1] the iMX8ULP suffers the same issue=
.
> > >>
> > >> [1]: https://github.com/nxp-imx/linux-imx/commit/653712ffe52dd59f407=
af1b781ce318f3d9e17bb
> > >> ---
> > >>   drivers/crypto/caam/ctrl.c   | 5 +++--
> > >>   drivers/crypto/caam/intern.h | 1 +
> > >>   2 files changed, 4 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > >> index 38ff931059b4..766c447c9cfb 100644
> > >> --- a/drivers/crypto/caam/ctrl.c
> > >> +++ b/drivers/crypto/caam/ctrl.c
> > >> @@ -831,7 +831,7 @@ static int caam_ctrl_suspend(struct device *dev)
> > >>   {
> > >>        const struct caam_drv_private *ctrlpriv =3D dev_get_drvdata(d=
ev);
> > >>
> > >> -     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en)
> > >> +     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0)
> > >>                caam_state_save(dev);
> > >>
> > >>        return 0;
> > >> @@ -842,7 +842,7 @@ static int caam_ctrl_resume(struct device *dev)
> > >>        struct caam_drv_private *ctrlpriv =3D dev_get_drvdata(dev);
> > >>        int ret =3D 0;
> > >>
> > >> -     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en) {
> > >> +     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0) {
> > >>                caam_state_restore(dev);
> > >>
> > >>                /* HW and rng will be reset so deinstantiation can be=
 removed */
> > >> @@ -908,6 +908,7 @@ static int caam_probe(struct platform_device *pd=
ev)
> > >>
> > >>                imx_soc_data =3D imx_soc_match->data;
> > >>                reg_access =3D reg_access && imx_soc_data->page0_acce=
ss;
> > >> +             ctrlpriv->no_page0 =3D !reg_access;
> > >
> > > If you want to use no_page0 to control if call caam_state_save(), you=
'd
> > > better set ctrlpriv->no_page0 also after ctrlpriv->optee_en =3D !!np;
> > >
> > > Frank
> >
> > I'm not sure I understand, I cannot see a code path where no_page0 will
> > be (un)set incorrectly.
> >
> > optee disables the page0 access, so reg_access is already the inverse o=
f
> > optee_en. reg_access =3D=3D false when optee_en =3D=3D true.
> >
> > Thus, if optee is loaded on a SoC that normally has page0_access the
> > `reg_access =3D reg_access && imx_soc_data->page0_access;` statement on
> > the line above setting no_page0 already takes care of it, so:
> > reg_access =3D false && true -> false.
> >
> > Similarly if both reg_access =3D=3D false and page0_access =3D=3D false=
,
> > reg_access will still be false.
>=20
> Okay, I check original code. You are right. You'd better to add descripto=
n
> in commit message about no_page0 is true when optee_en is true.
>=20
> Frank

Thanks for clarifying. I will update the commit message making this clearer=
 in V2,
along with your other comments on 3/4 and 4/4.

Thanks! // John Ernberg=
