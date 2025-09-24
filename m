Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354434C98;
	Wed, 24 Sep 2025 07:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758698751; cv=none; b=UuX9FgdG4i4P5WPC4RjJqI5dyqjdwAtiwtYuqtFqIFBEbeq34haBdrzesfmLIDB380TzrqTliTFzCYI80CPXqOjT+Ep6NVAAx+tqcgj3cmuDxSF/JiCc4Nr920xyfDUEVbdoKDrG+apHVIO1wv+Im4+WOFMU2+uQxBzBE45Y+0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758698751; c=relaxed/simple;
	bh=qZjwyi22qOR2Qsc1SnABmzmhRP/x3p1MMdp4IPKkplo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOVr7KmRNI3VHHKKQoyDaCtLaiY/MLKTJtDK6v1Z5/D7HsT7upEExrWx51XUkyfVJZjJtV4acXgmcpTMEggN4x/iEGVgFR5Pn0dyg1+nlNifk7JymPu4EGrWn3i9uanTTbLPt1xPz69k/pb04fjkW2eeOzUFqMsODwVBrH6X/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=WZ90i2MQ; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="WZ90i2MQ"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cWpKh1j1Hz9st9;
	Wed, 24 Sep 2025 09:25:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758698744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UsZbVJWNBfJb7wJKnmSOGbrWG2iZdKLLbBwDm5mBQC4=;
	b=WZ90i2MQ+F/UNfmHmZhzVCfXh8MF55gxL5rtuTM1Jj94NehEq3RfmF5NSYHH9Mk79Q8hSD
	QoqI6MppWPygSc6JshyxegDjgtFmPHnpARBSrw1wTJUOVpPQw8DXqprDhttqqw+ZXThkfq
	kzl8u37PVPZLIIOcysQMfzo7gJToJRQg4cUmTokvA8obCL2OUfkPFmW6ml+sguwQSa0h29
	vfV8DRGAKQO4037FKG4pcD5HYzxx+ehmz/R9xp6LZWvBbSZ35taKsf42+BCHJV0xQdxqpZ
	d2h+Ge6RkEUSotTzSEMpS7FsRnynjCNaXhWpwGseHqs9GWFrq8MBD48iETxsag==
Date: Wed, 24 Sep 2025 09:25:29 +0200
From: Kael D'Alcamo <dev@kael-k.io>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT
 schema
Message-ID: <mg4n2yvox5cwaermssq336ypaci7saio2bkpkuw7pxhjk2lotz@vgbsewsu4vtn>
References: <20250923103900.136621-1-dev@kael-k.io>
 <175863178219.2880556.9182028457020658311.robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <175863178219.2880556.9182028457020658311.robh@kernel.org>

On 2025-09-23 07:49:42, Rob Herring (Arm) wrote:
>=20
> On Tue, 23 Sep 2025 12:38:22 +0200, Kael D'Alcamo wrote:
> > Convert the Devicetree binding documentation for:
> > * SUNW,n2-rng
> > * SUNW,vf-rng
> > * SUNW,kt-rng
> > * ORCL,m4-rng
> > * ORCL,m7-rng
> > from plain text to YAML.
> >=20
> > Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> > ---
> >  .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
> >  .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++++++
> >  2 files changed, 61 insertions(+), 30 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_ora=
cle_rng.txt
> >  create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_ora=
cle_rng.yaml
> >=20
>=20
> My bot found errors running 'make dt_binding_check' on your patch:
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/r=
ng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m4-rng): 'rng-#units' does=
 not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exynos|=
fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|max8=
952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-single|P=
owerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),.*',=
 '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70mai,.*'=
, '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-zA-Z0-=
9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$', '^abb=
,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,.*', '=
^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-semi,.*', '=
^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*', '^adi,.=
*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler,.*', '^=
aesop,.*', '^airoha,.*',=20
>  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,.*',=
 '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,.*', '=
^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*', '^amar=
ula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^amlogic,.=
*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstaos,.*', '=
^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,.*', '^a=
osong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^archermind=
,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ariaboard,.*'=
, '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.*', '^arte=
syn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', '^asrock,.=
*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^atmel,.*', =
'^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^avnet,.*',=
 '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,.*', '^azw=
,.*', '^baikal,.*', '^ban
>  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', '^bh=
f,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', '^bl=
utek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmobi,.=
*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', '^by=
tedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.*', =
'^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*', '^c=
atalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellwise,=
=2E*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^chi=
pidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*',=
 '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cisco=
,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,.*=
', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia,.*'=
, '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortina,.*=
', '^cosmic,.*', '^crane,.*
>  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq,.*'=
, '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui,.*'=
, '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*', '^d=
avicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.*', =
'^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difrnce,=
=2E*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.*'=
, '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*',=
 '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', '^=
dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-systa=
rt,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax,.=
*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^ein=
k,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*', =
'^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', '^=
emmicro,.*', '^empire-elect
>  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*', '^e=
ndless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*', '^=
epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', '^et=
tus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*', '^e=
xar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fairch=
ild,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*', '^=
fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipkart,=
=2E*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^fre=
ebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fujit=
su,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^ga=
teway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,.*=
', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*', '^g=
eniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalscale,.=
*', '^globaltop,.*', '^gmt,
>  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', '^go=
ramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*', '^=
hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.*', =
'^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinlink,.=
*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.*', =
'^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*', '^=
hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '^hug=
sun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.*', =
'^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^icplus=
,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^img,.*=
', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indiedroi=
d,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^ingr=
asys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secure,.*=
', '^insignal,.*', '^insp
>  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^inventec,.*=
', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.*', =
'^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*', '^=
jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesurun,=
=2E*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^kam=
,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kiebackpe=
ter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*', '=
^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*', =
'^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattice,=
=2E*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^=
lemaker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^li=
cheepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^link=
sprite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^lio=
ntron,.*', '^liteon,.*', '^li
>  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.*', =
'^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,.*',=
 '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^macnica,.=
*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^maxbot=
ix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '^mbvl,=
=2E*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachips,.*=
', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensing,.*=
', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*', '^m=
ethode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron,.*'=
, '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mikroti=
k,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,.*',=
 '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.*', '^=
mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^motorcomm=
,.*', '^motorola,.*', '^mox
>  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', '^ms=
i,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^murat=
a,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*', '=
^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*', '=
^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweast,.*=
', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni,.*'=
, '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '^not=
hing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', '^nu=
tsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^oceanic,.=
*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,.*',=
 '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^opalkel=
ly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpandora,.*=
', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orisetech,.=
*', '^ortustech,.*', '^os
>  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^oxse=
mi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', '^pa=
rticle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', '^ph=
icomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9]+$'=
, '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plathome,=
=2E*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^pol=
aroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', '^=
pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^primev=
iew,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^puris=
m,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodian,=
=2E*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*=
', '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumf=
eld,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkabl=
e,.*', '^renesas,.*', '^rervi
>  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', '^ri=
coh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^rockte=
ch,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseapplep=
i,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.*', =
'^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*', '^s=
chneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seagate,=
=2E*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^sen=
sirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmicro=
,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,.*=
', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^siemens,.=
*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^sila=
bs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', '^si=
liconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinlinx,.=
*', '^sinovoip,.*', '^sinow
>  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^skov,.=
*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '^smi=
,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun,.*'=
, '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.*', =
'^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd,.*'=
, '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-ericsson,=
=2E*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^ste=
,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^sum=
mit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', '^=
swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.*'=
, '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo,.=
*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^techs=
tar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^tend=
a,.*', '^terasic,.*', '^tes
>  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,.*',=
 '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^tmt,.*=
', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise,.*', =
'^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', '^tpo,=
=2E*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^tronsmart=
,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u-blo=
x,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispace,.=
*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upisemi,.=
*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*', '=
^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '^via=
,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^virtual=
,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^vivax,.=
*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*', '=
^vxt,.*', '^wacom,.*', '^wa
>  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^wellt=
ech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora,.*'=
, '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winlink,=
=2E*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,.*=
', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '^xes=
,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xinpen=
g,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.*', =
'^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yiming,.=
*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '^yur=
idenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '^zid=
oo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> 	from schema $id: http://devicetree.org/schemas/vendor-prefixes.yaml#
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/r=
ng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m7-rng): 'rng-#units' does=
 not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exynos|=
fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|max8=
952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-single|P=
owerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),.*',=
 '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70mai,.*'=
, '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-zA-Z0-=
9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$', '^abb=
,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,.*', '=
^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-semi,.*', '=
^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*', '^adi,.=
*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler,.*', '^=
aesop,.*', '^airoha,.*',=20
>  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,.*',=
 '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,.*', '=
^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*', '^amar=
ula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^amlogic,.=
*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstaos,.*', '=
^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,.*', '^a=
osong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^archermind=
,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ariaboard,.*'=
, '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.*', '^arte=
syn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', '^asrock,.=
*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^atmel,.*', =
'^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^avnet,.*',=
 '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,.*', '^azw=
,.*', '^baikal,.*', '^ban
>  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', '^bh=
f,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', '^bl=
utek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmobi,.=
*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', '^by=
tedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.*', =
'^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*', '^c=
atalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellwise,=
=2E*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^chi=
pidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*',=
 '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cisco=
,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,.*=
', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia,.*'=
, '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortina,.*=
', '^cosmic,.*', '^crane,.*
>  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq,.*'=
, '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui,.*'=
, '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*', '^d=
avicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.*', =
'^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difrnce,=
=2E*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.*'=
, '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*',=
 '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', '^=
dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-systa=
rt,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax,.=
*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^ein=
k,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*', =
'^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', '^=
emmicro,.*', '^empire-elect
>  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*', '^e=
ndless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*', '^=
epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', '^et=
tus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*', '^e=
xar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fairch=
ild,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*', '^=
fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipkart,=
=2E*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^fre=
ebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fujit=
su,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^ga=
teway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,.*=
', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*', '^g=
eniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalscale,.=
*', '^globaltop,.*', '^gmt,
>  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', '^go=
ramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*', '^=
hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.*', =
'^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinlink,.=
*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.*', =
'^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*', '^=
hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '^hug=
sun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.*', =
'^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^icplus=
,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^img,.*=
', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indiedroi=
d,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^ingr=
asys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secure,.*=
', '^insignal,.*', '^insp
>  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^inventec,.*=
', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.*', =
'^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*', '^=
jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesurun,=
=2E*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^kam=
,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kiebackpe=
ter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*', '=
^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*', =
'^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattice,=
=2E*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^=
lemaker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^li=
cheepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^link=
sprite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^lio=
ntron,.*', '^liteon,.*', '^li
>  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.*', =
'^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,.*',=
 '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^macnica,.=
*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^maxbot=
ix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '^mbvl,=
=2E*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachips,.*=
', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensing,.*=
', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*', '^m=
ethode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron,.*'=
, '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mikroti=
k,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,.*',=
 '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.*', '^=
mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^motorcomm=
,.*', '^motorola,.*', '^mox
>  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', '^ms=
i,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^murat=
a,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*', '=
^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*', '=
^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweast,.*=
', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni,.*'=
, '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '^not=
hing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', '^nu=
tsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^oceanic,.=
*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,.*',=
 '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^opalkel=
ly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpandora,.*=
', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orisetech,.=
*', '^ortustech,.*', '^os
>  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^oxse=
mi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', '^pa=
rticle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', '^ph=
icomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9]+$'=
, '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plathome,=
=2E*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^pol=
aroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', '^=
pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^primev=
iew,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^puris=
m,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodian,=
=2E*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*=
', '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumf=
eld,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkabl=
e,.*', '^renesas,.*', '^rervi
>  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', '^ri=
coh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^rockte=
ch,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseapplep=
i,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.*', =
'^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*', '^s=
chneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seagate,=
=2E*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^sen=
sirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmicro=
,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,.*=
', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^siemens,.=
*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^sila=
bs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', '^si=
liconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinlinx,.=
*', '^sinovoip,.*', '^sinow
>  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^skov,.=
*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '^smi=
,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun,.*'=
, '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.*', =
'^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd,.*'=
, '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-ericsson,=
=2E*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^ste=
,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^sum=
mit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', '^=
swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.*'=
, '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo,.=
*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^techs=
tar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^tend=
a,.*', '^terasic,.*', '^tes
>  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,.*',=
 '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^tmt,.*=
', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise,.*', =
'^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', '^tpo,=
=2E*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^tronsmart=
,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u-blo=
x,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispace,.=
*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upisemi,.=
*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*', '=
^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '^via=
,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^virtual=
,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^vivax,.=
*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*', '=
^vxt,.*', '^wacom,.*', '^wa
>  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^wellt=
ech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora,.*'=
, '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winlink,=
=2E*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,.*=
', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '^xes=
,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xinpen=
g,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.*', =
'^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yiming,.=
*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '^yur=
idenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '^zid=
oo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> 	from schema $id: http://devicetree.org/schemas/vendor-prefixes.yaml#
>=20
> doc reference errors (make refcheckdocs):
>=20
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/202509=
23103900.136621-1-dev@kael-k.io
>=20
> The base for the series is generally the latest rc1. A different dependen=
cy
> should be noted in *this* patch.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>=20
> pip3 install dtschema --upgrade
>=20

I actually ran the check during development and before sending the=20
patch. In the first drafts I wrote, I had the same error, but after a few=
=20
days it disappeared. Given the fact that 'make dt_binding_check' wasn't=20
giving me any errors or warnings, I trusted the check and assumed that=20
the vendor list or something in the validation logic had changed after=20
pulling new changes.

I tried to run 'make dt_binding_check' again by=20
cloning the repo from scratch and with a new venv.

$ which python && pip list
/home/kael-k/Projects/linux/.venv/bin/python
Package                       Version
----------------------------- -----------
alabaster                     1.0.0
attrs                         25.3.0
babel                         2.17.0
certifi                       2025.8.3
charset-normalizer            3.4.3
docutils                      0.21.2
dtschema                      2025.8
idna                          3.10
imagesize                     1.4.1
Jinja2                        3.1.6
jsonschema                    4.17.3
MarkupSafe                    3.0.2
packaging                     25.0
pathspec                      0.12.1
pip                           25.2
Pygments                      2.19.2
pylibfdt                      1.7.2.post1
pyrsistent                    0.20.0
PyYAML                        6.0.2
requests                      2.32.5
rfc3987                       1.3.8
roman-numerals-py             3.1.0
ruamel.yaml                   0.18.15
ruamel.yaml.clib              0.2.14
snowballstemmer               3.0.1
Sphinx                        8.2.3
sphinxcontrib-applehelp       2.0.0
sphinxcontrib-devhelp         2.0.0
sphinxcontrib-htmlhelp        2.1.0
sphinxcontrib-jsmath          1.0.1
sphinxcontrib-qthelp          2.0.0
sphinxcontrib-serializinghtml 2.0.0
urllib3                       2.5.0
yamllint                      1.37.1


$ make clean
CLEAN   Documentation/devicetree/bindings

$ make dt_binding_check DT_SCHEMA_FILES=3Dsparc_sun_oracle_rng.yaml
  SCHEMA  Documentation/devicetree/bindings/processed-schema.json
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/dtc/dtc.o
  HOSTCC  scripts/dtc/flattree.o
  HOSTCC  scripts/dtc/fstree.o
  HOSTCC  scripts/dtc/data.o
  HOSTCC  scripts/dtc/livetree.o
  HOSTCC  scripts/dtc/treesource.o
  HOSTCC  scripts/dtc/srcpos.o
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/dtc/util.o
  LEX     scripts/dtc/dtc-lexer.lex.c
  YACC    scripts/dtc/dtc-parser.tab.[ch]
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTLD  scripts/dtc/dtc
  CHKDT   ./Documentation/devicetree/bindings
  LINT    ./Documentation/devicetree/bindings
  DTEX    Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.exampl=
e.dts
  DTC [C] Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.exampl=
e.dtb

$ echo $?
0

However, I was able to reproduce the same error you reported by manually
running dt-validate:

$ dt-validate -u ./Documentation/devicetree/bindings \
	-p ./Documentation/devicetree/bindings/processed-schema.json \
	Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.example.dtb

I'll update you if I find out that this is a problem related to the Makefile
rather than a problem with my machine, even if I would guess the latter is =
way=20
more probable.

> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your sch=
ema.
>=20
