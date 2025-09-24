Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B02FFDF3
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758719970; cv=none; b=QpFOnHGkiWOEfEHPC1CUxhQq3VTRyzBZwI9AQ3k3QyYCi3u1bWJgt9lLXJCJhozV7N7PRBgqPw+lxI2JKzxaTHca6ZC+mfN0Pnk1GwlRiiHoNQqO0HgEVZwdmNag8Vg/B4KyzsEhmVNYwluuTIaG/ADx/8ARn2IxRJgyPL8glag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758719970; c=relaxed/simple;
	bh=a8+BUXQjnx6o+zENFJpoNKCN44sEAty8DdSxeol1ZrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lCmBZSyYi49NTRXvCyt9gBn14jSSVfRotReokQBranhCva3GU4l5psmWFUu7IaklHjlCRY88E8mn16zfqYVZqRjVLF+Kah9oay9DG+IgthXSY3W5CZSTnPCu2LiwwEKvJJZVRfdklIrNTmd8uJ5s87NfkQWlnAHbZzbuzR1iiDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJVCateX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJVCateX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCB6C4CEF7
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758719969;
	bh=a8+BUXQjnx6o+zENFJpoNKCN44sEAty8DdSxeol1ZrM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eJVCateXofAUEJN4qUgnsrnBr6c+yJDAmfU7S3IAzo1z3kNqvVsoArUD506ZDyhNC
	 bfcDc3LvBddbOJ1RgkzBFp3j/R8D/HlenXa2PeB6psadbfZWEHoMbssLSOALXryBxP
	 rOmy3ASTojjmlRRBbMOVSqTJqV0X9lhRud2P6pnAdRKYqK36Z6n3gd4ak9EyeptWiZ
	 EQhcsSdxOZb/1FWnjWwqU5jDpveoifcT9IdQC76M3LjvdjgSKmltlPwtk4KP88/E6/
	 LWJ6foD67pGEd0C1B4tOmQ1SjdIbA6X9uA1Nifh7CATS6pKsTXYq1oOhNVjNpRmGco
	 LOLvfhTd8yYJw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b00a9989633so200696266b.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 06:19:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVnXeTjNg+a9cHa5CXaHlWiR1pNqvECo3WkedxtNe7v36T7r2GtVKlLvwRuXyEiFBhc3tptw2VmnggCq5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJCHlnh0BDyHj+KOVF6ckqCWkU7k3HxlTYvfjk26AEjwdtX7Xr
	pFV+9Tu6JSc4MDqMii6w4p/VwskFzZ2v2KWP8eS/k9bBmAI8/KLtGpRr15YYCqRam0TY5+2jsbR
	YlHj8IeboQfVg+kVdjew7Ax+JStrwDA==
X-Google-Smtp-Source: AGHT+IHaXrY1EH/I6waKpHApPUrKmdKpLcqxpFAJEwQXcOG0NYf/vM1iFz4FFLQd0Z2Yhv5/S3hWCbPpld1ExKDnvRE=
X-Received: by 2002:a17:907:944c:b0:b2a:657:e733 with SMTP id
 a640c23a62f3a-b32cbe8e4a4mr256187266b.15.1758719967966; Wed, 24 Sep 2025
 06:19:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923103900.136621-1-dev@kael-k.io> <175863178219.2880556.9182028457020658311.robh@kernel.org>
 <mg4n2yvox5cwaermssq336ypaci7saio2bkpkuw7pxhjk2lotz@vgbsewsu4vtn>
In-Reply-To: <mg4n2yvox5cwaermssq336ypaci7saio2bkpkuw7pxhjk2lotz@vgbsewsu4vtn>
From: Rob Herring <robh@kernel.org>
Date: Wed, 24 Sep 2025 08:19:15 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJy_RRaP-+isBu9Mr-XjDd2ngO7G0ei8Nh1j66r7kvk8w@mail.gmail.com>
X-Gm-Features: AS18NWBnVCdz0_vGf5Q5JqHiggL00MGak6rcuHYmFbVZ2O-yaua_r1jZ6NMBLkc
Message-ID: <CAL_JsqJy_RRaP-+isBu9Mr-XjDd2ngO7G0ei8Nh1j66r7kvk8w@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
To: "Kael D'Alcamo" <dev@kael-k.io>
Cc: devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 2:25=E2=80=AFAM Kael D'Alcamo <dev@kael-k.io> wrote=
:
>
> On 2025-09-23 07:49:42, Rob Herring (Arm) wrote:
> >
> > On Tue, 23 Sep 2025 12:38:22 +0200, Kael D'Alcamo wrote:
> > > Convert the Devicetree binding documentation for:
> > > * SUNW,n2-rng
> > > * SUNW,vf-rng
> > > * SUNW,kt-rng
> > > * ORCL,m4-rng
> > > * ORCL,m7-rng
> > > from plain text to YAML.
> > >
> > > Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> > > ---
> > >  .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
> > >  .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++++=
++
> > >  2 files changed, 61 insertions(+), 30 deletions(-)
> > >  delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_o=
racle_rng.txt
> > >  create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_o=
racle_rng.yaml
> > >
> >
> > My bot found errors running 'make dt_binding_check' on your patch:
> >
> > yamllint warnings/errors:
> >
> > dtschema/dtc warnings/errors:
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/rng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m4-rng): 'rng-#units' do=
es not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exyno=
s|fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|ma=
x8952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-single=
|PowerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),.*=
', '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70mai,.=
*', '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-zA-Z=
0-9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$', '^a=
bb,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,.*',=
 '^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-semi,.*',=
 '^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*', '^adi=
,.*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler,.*', =
'^aesop,.*', '^airoha,.*',
> >  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,.*=
', '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,.*',=
 '^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*', '^am=
arula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^amlogic=
,.*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstaos,.*',=
 '^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,.*', '=
^aosong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^archermi=
nd,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ariaboard,.=
*', '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.*', '^ar=
tesyn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', '^asrock=
,.*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^atmel,.*'=
, '^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^avnet,.*=
', '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,.*', '^a=
zw,.*', '^baikal,.*', '^ban
> >  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', '^=
bhf,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', '^=
blutek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmobi=
,.*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', '^=
bytedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.*'=
, '^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*', '=
^catalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellwis=
e,.*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^chi=
pidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*',=
 '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cisco=
,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,.*=
', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia,.*'=
, '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortina,.*=
', '^cosmic,.*', '^crane,.*
> >  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq,.=
*', '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui,.=
*', '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*', '=
^davicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.*'=
, '^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difrnc=
e,.*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.*'=
, '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*',=
 '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', '^=
dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-systa=
rt,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax,.=
*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^ein=
k,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*', =
'^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', '^=
emmicro,.*', '^empire-elect
> >  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*', '=
^endless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*', =
'^epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', '^=
ettus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*', '=
^exar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fair=
child,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*', =
'^fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipkar=
t,.*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^fre=
ebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fujit=
su,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^ga=
teway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,.*=
', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*', '^g=
eniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalscale,.=
*', '^globaltop,.*', '^gmt,
> >  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', '^=
goramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*', =
'^hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.*'=
, '^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinlink=
,.*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.*'=
, '^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*', =
'^hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '^h=
ugsun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.*'=
, '^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^icpl=
us,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^img,=
.*', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indiedr=
oid,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^in=
grasys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secure,=
.*', '^insignal,.*', '^insp
> >  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^inventec,=
.*', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.*'=
, '^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*', =
'^jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesuru=
n,.*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^kam=
,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kiebackpe=
ter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*', '=
^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*', =
'^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattice,=
.*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^le=
maker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^lich=
eepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^linksp=
rite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^liont=
ron,.*', '^liteon,.*', '^li
> >  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.*'=
, '^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,.*=
', '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^macnica=
,.*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^maxb=
otix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '^mbv=
l,.*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachips,.*=
', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensing,.*=
', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*', '^m=
ethode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron,.*'=
, '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mikroti=
k,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,.*',=
 '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.*', '^=
mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^motorcomm=
,.*', '^motorola,.*', '^mox
> >  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', '^=
msi,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^mur=
ata,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*',=
 '^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*',=
 '^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweast,=
.*', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni,.=
*', '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '^n=
othing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', '^=
nutsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^oceanic=
,.*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,.*=
', '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^opalk=
elly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpandora,=
.*', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orisetech=
,.*', '^ortustech,.*', '^os
> >  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^ox=
semi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', '^=
particle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', '^=
phicomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9]+=
$', '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plathom=
e,.*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^pol=
aroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', '^=
pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^primev=
iew,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^puris=
m,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodian,=
.*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*',=
 '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumfel=
d,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkable,=
.*', '^renesas,.*', '^rervi
> >  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', '^=
ricoh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^rock=
tech,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseappl=
epi,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.*'=
, '^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*', '=
^schneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seagat=
e,.*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^sen=
sirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmicro=
,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,.*=
', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^siemens,.=
*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^sila=
bs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', '^si=
liconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinlinx,.=
*', '^sinovoip,.*', '^sinow
> >  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^skov=
,.*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '^s=
mi,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun,.=
*', '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.*'=
, '^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd,.=
*', '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-ericsso=
n,.*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^ste=
,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^sum=
mit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', '^=
swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.*'=
, '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo,.=
*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^techs=
tar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^tend=
a,.*', '^terasic,.*', '^tes
> >  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,.*=
', '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^tmt,=
.*', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise,.*'=
, '^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', '^tp=
o,.*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^tronsmart=
,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u-blo=
x,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispace,.=
*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upisemi,.=
*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*', '=
^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '^via=
,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^virtual=
,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^vivax,.=
*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*', '=
^vxt,.*', '^wacom,.*', '^wa
> >  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^wel=
ltech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora,.=
*', '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winlin=
k,.*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,.*=
', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '^xes=
,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xinpen=
g,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.*', =
'^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yiming,.=
*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '^yur=
idenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '^zid=
oo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> >       from schema $id: http://devicetree.org/schemas/vendor-prefixes.ya=
ml#
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/rng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m7-rng): 'rng-#units' do=
es not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exyno=
s|fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|ma=
x8952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-single=
|PowerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),.*=
', '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70mai,.=
*', '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-zA-Z=
0-9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$', '^a=
bb,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,.*',=
 '^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-semi,.*',=
 '^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*', '^adi=
,.*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler,.*', =
'^aesop,.*', '^airoha,.*',
> >  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,.*=
', '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,.*',=
 '^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*', '^am=
arula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^amlogic=
,.*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstaos,.*',=
 '^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,.*', '=
^aosong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^archermi=
nd,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ariaboard,.=
*', '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.*', '^ar=
tesyn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', '^asrock=
,.*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^atmel,.*'=
, '^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^avnet,.*=
', '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,.*', '^a=
zw,.*', '^baikal,.*', '^ban
> >  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', '^=
bhf,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', '^=
blutek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmobi=
,.*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', '^=
bytedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.*'=
, '^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*', '=
^catalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellwis=
e,.*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^chi=
pidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*',=
 '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cisco=
,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,.*=
', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia,.*'=
, '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortina,.*=
', '^cosmic,.*', '^crane,.*
> >  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq,.=
*', '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui,.=
*', '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*', '=
^davicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.*'=
, '^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difrnc=
e,.*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.*'=
, '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*',=
 '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', '^=
dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-systa=
rt,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax,.=
*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^ein=
k,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*', =
'^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', '^=
emmicro,.*', '^empire-elect
> >  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*', '=
^endless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*', =
'^epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', '^=
ettus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*', '=
^exar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fair=
child,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*', =
'^fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipkar=
t,.*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^fre=
ebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fujit=
su,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^ga=
teway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,.*=
', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*', '^g=
eniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalscale,.=
*', '^globaltop,.*', '^gmt,
> >  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', '^=
goramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*', =
'^hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.*'=
, '^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinlink=
,.*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.*'=
, '^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*', =
'^hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '^h=
ugsun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.*'=
, '^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^icpl=
us,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^img,=
.*', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indiedr=
oid,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^in=
grasys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secure,=
.*', '^insignal,.*', '^insp
> >  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^inventec,=
.*', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.*'=
, '^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*', =
'^jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesuru=
n,.*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^kam=
,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kiebackpe=
ter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*', '=
^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*', =
'^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattice,=
.*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^le=
maker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^lich=
eepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^linksp=
rite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^liont=
ron,.*', '^liteon,.*', '^li
> >  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.*'=
, '^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,.*=
', '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^macnica=
,.*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^maxb=
otix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '^mbv=
l,.*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachips,.*=
', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensing,.*=
', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*', '^m=
ethode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron,.*'=
, '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mikroti=
k,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,.*',=
 '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.*', '^=
mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^motorcomm=
,.*', '^motorola,.*', '^mox
> >  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', '^=
msi,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^mur=
ata,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*',=
 '^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*',=
 '^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweast,=
.*', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni,.=
*', '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '^n=
othing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', '^=
nutsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^oceanic=
,.*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,.*=
', '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^opalk=
elly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpandora,=
.*', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orisetech=
,.*', '^ortustech,.*', '^os
> >  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^ox=
semi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', '^=
particle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', '^=
phicomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9]+=
$', '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plathom=
e,.*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^pol=
aroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', '^=
pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^primev=
iew,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^puris=
m,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodian,=
.*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*',=
 '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumfel=
d,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkable,=
.*', '^renesas,.*', '^rervi
> >  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', '^=
ricoh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^rock=
tech,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseappl=
epi,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.*'=
, '^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*', '=
^schneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seagat=
e,.*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^sen=
sirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmicro=
,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,.*=
', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^siemens,.=
*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^sila=
bs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', '^si=
liconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinlinx,.=
*', '^sinovoip,.*', '^sinow
> >  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^skov=
,.*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '^s=
mi,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun,.=
*', '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.*'=
, '^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd,.=
*', '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-ericsso=
n,.*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^ste=
,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^sum=
mit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', '^=
swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.*'=
, '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo,.=
*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^techs=
tar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^tend=
a,.*', '^terasic,.*', '^tes
> >  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,.*=
', '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^tmt,=
.*', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise,.*'=
, '^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', '^tp=
o,.*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^tronsmart=
,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u-blo=
x,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispace,.=
*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upisemi,.=
*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*', '=
^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '^via=
,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^virtual=
,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^vivax,.=
*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*', '=
^vxt,.*', '^wacom,.*', '^wa
> >  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^wel=
ltech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora,.=
*', '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winlin=
k,.*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,.*=
', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '^xes=
,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xinpen=
g,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.*', =
'^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yiming,.=
*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '^yur=
idenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '^zid=
oo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> >       from schema $id: http://devicetree.org/schemas/vendor-prefixes.ya=
ml#
> >
> > doc reference errors (make refcheckdocs):
> >
> > See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/2025=
0923103900.136621-1-dev@kael-k.io
> >
> > The base for the series is generally the latest rc1. A different depend=
ency
> > should be noted in *this* patch.
> >
> > If you already ran 'make dt_binding_check' and didn't see the above
> > error(s), then make sure 'yamllint' is installed and dt-schema is up to
> > date:
> >
> > pip3 install dtschema --upgrade
> >
>
> I actually ran the check during development and before sending the
> patch. In the first drafts I wrote, I had the same error, but after a few
> days it disappeared. Given the fact that 'make dt_binding_check' wasn't
> giving me any errors or warnings, I trusted the check and assumed that
> the vendor list or something in the validation logic had changed after
> pulling new changes.
>
> I tried to run 'make dt_binding_check' again by
> cloning the repo from scratch and with a new venv.
>
> $ which python && pip list
> /home/kael-k/Projects/linux/.venv/bin/python
> Package                       Version
> ----------------------------- -----------
> alabaster                     1.0.0
> attrs                         25.3.0
> babel                         2.17.0
> certifi                       2025.8.3
> charset-normalizer            3.4.3
> docutils                      0.21.2
> dtschema                      2025.8
> idna                          3.10
> imagesize                     1.4.1
> Jinja2                        3.1.6
> jsonschema                    4.17.3
> MarkupSafe                    3.0.2
> packaging                     25.0
> pathspec                      0.12.1
> pip                           25.2
> Pygments                      2.19.2
> pylibfdt                      1.7.2.post1
> pyrsistent                    0.20.0
> PyYAML                        6.0.2
> requests                      2.32.5
> rfc3987                       1.3.8
> roman-numerals-py             3.1.0
> ruamel.yaml                   0.18.15
> ruamel.yaml.clib              0.2.14
> snowballstemmer               3.0.1
> Sphinx                        8.2.3
> sphinxcontrib-applehelp       2.0.0
> sphinxcontrib-devhelp         2.0.0
> sphinxcontrib-htmlhelp        2.1.0
> sphinxcontrib-jsmath          1.0.1
> sphinxcontrib-qthelp          2.0.0
> sphinxcontrib-serializinghtml 2.0.0
> urllib3                       2.5.0
> yamllint                      1.37.1
>
>
> $ make clean
> CLEAN   Documentation/devicetree/bindings
>
> $ make dt_binding_check DT_SCHEMA_FILES=3Dsparc_sun_oracle_rng.yaml

Setting DT_SCHEMA_FILES only checks the examples in the matching
schema files against those schema files. So it is fine to set
DT_SCHEMA_FILES as a shortcut for initial testing, you ultimately have
to test without DT_SCHEMA_FILES set.

Rob
