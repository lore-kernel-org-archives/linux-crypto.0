Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5E3126CA;
	Wed, 24 Sep 2025 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758729784; cv=none; b=lucFgIp49s8BdRNWgwTS0BDKOkWZWjGkVZMsphmQtKmB1wW0E6hfXdlii8wmZlD0C8PDC/MzamzrsR4OuY46nLj3n9Ty4h84SriOvjkuijjcmwKEj9I9IJOawBLRbmcdp46CEY/+ZkCjeXqr4wYvGdR4t05qbsOiQanjq7P2nkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758729784; c=relaxed/simple;
	bh=eKQulodK7cgetT+RAOJetBb1IulBjn311zfjQOjdD08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jn5b3RBpB7HK/sQE1cNQh/wznY/nlKayeYhoMQDgg/BLEC75JIxHTAf4VQEBwMV1lN6uJNRilYnRVlxblPjjqdCra3P32vMkthmQxGtm9rZrbdXl9ARO6E/piWADhJsehSIswsrgWu1+kHyx017vEVqYydrQWcmzDcaCN6An7Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=JFkjDXyR; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="JFkjDXyR"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cX1pR4x8Wz9thx;
	Wed, 24 Sep 2025 18:02:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758729775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSXONZxCz30LHcyKJQsjTygNtl1DG+9unBjLuVP0UL4=;
	b=JFkjDXyRVfkiqoFq4KSqmam8JFYjsA9B0ZGeLDWCnt8kByGM7WS+gJBxDFiJ8s6bWTE2g0
	PH9JL/fC+11+P0XhGOrvtEXSIExF1zXCRqYaupJzexqAko9iCHMUvhwUwaWU3lCaT0NSBH
	+9v0B7bu4MfVHzKEn1khk4c2b+ayDHEklJU4KQAP6ox2BF84OrcKOKs11NaVbIY8TZdmbS
	hxW74TJXakpEO/qP1NGoLAfRlCOU46w3G09VpD2vo3I6NeZiJsq4aY130sRT4bjlQZcd2I
	md7tIfWG0DDdstLXn0p7hf6tL1tDEpYTpJA5Ybl8bbYUaMzJrhkfBugv6FyHtg==
Date: Wed, 24 Sep 2025 18:02:42 +0200
From: Kael D'Alcamo <dev@kael-k.io>
To: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT
 schema
Message-ID: <w7mdyj2ehmr4cdexde57ltbdloeffcg5eqylnxve2f2n6ivfsg@6akc3lfh5owi>
References: <20250923103900.136621-1-dev@kael-k.io>
 <175863178219.2880556.9182028457020658311.robh@kernel.org>
 <mg4n2yvox5cwaermssq336ypaci7saio2bkpkuw7pxhjk2lotz@vgbsewsu4vtn>
 <CAL_JsqJy_RRaP-+isBu9Mr-XjDd2ngO7G0ei8Nh1j66r7kvk8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAL_JsqJy_RRaP-+isBu9Mr-XjDd2ngO7G0ei8Nh1j66r7kvk8w@mail.gmail.com>

On 2025-09-24 08:19:15, Rob Herring wrote:
> On Wed, Sep 24, 2025 at 2:25=E2=80=AFAM Kael D'Alcamo <dev@kael-k.io> wro=
te:
> >
> > On 2025-09-23 07:49:42, Rob Herring (Arm) wrote:
> > >
> > > On Tue, 23 Sep 2025 12:38:22 +0200, Kael D'Alcamo wrote:
> > > > Convert the Devicetree binding documentation for:
> > > > * SUNW,n2-rng
> > > > * SUNW,vf-rng
> > > > * SUNW,kt-rng
> > > > * ORCL,m4-rng
> > > > * ORCL,m7-rng
> > > > from plain text to YAML.
> > > >
> > > > Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> > > > ---
> > > >  .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
> > > >  .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++=
++++
> > > >  2 files changed, 61 insertions(+), 30 deletions(-)
> > > >  delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun=
_oracle_rng.txt
> > > >  create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun=
_oracle_rng.yaml
> > > >
> > >
> > > My bot found errors running 'make dt_binding_check' on your patch:
> > >
> > > yamllint warnings/errors:
> > >
> > > dtschema/dtc warnings/errors:
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindin=
gs/rng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m4-rng): 'rng-#units' =
does not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exy=
nos|fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|=
max8952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-sing=
le|PowerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),=
=2E*', '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70m=
ai,.*', '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-=
zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$',=
 '^abb,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,=
=2E*', '^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-sem=
i,.*', '^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*',=
 '^adi,.*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler=
,.*', '^aesop,.*', '^airoha,.*',
> > >  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,=
=2E*', '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,=
=2E*', '^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*'=
, '^amarula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^a=
mlogic,.*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstao=
s,.*', '^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,=
=2E*', '^aosong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^=
archermind,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ari=
aboard,.*', '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.=
*', '^artesyn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', =
'^asrock,.*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^a=
tmel,.*', '^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^=
avnet,.*', '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,=
=2E*', '^azw,.*', '^baikal,.*', '^ban
> > >  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', =
'^bhf,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', =
'^blutek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmo=
bi,.*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', =
'^bytedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.=
*', '^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*',=
 '^catalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellw=
ise,.*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^c=
hipidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*=
', '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cis=
co,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,=
=2E*', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia=
,.*', '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortin=
a,.*', '^cosmic,.*', '^crane,.*
> > >  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq=
,.*', '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui=
,.*', '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*',=
 '^davicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.=
*', '^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difr=
nce,.*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.=
*', '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*=
', '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', =
'^dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-sys=
tart,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax=
,.*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^e=
ink,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*'=
, '^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', =
'^emmicro,.*', '^empire-elect
> > >  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*',=
 '^endless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*'=
, '^epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', =
'^ettus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*',=
 '^exar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fa=
irchild,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*'=
, '^fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipk=
art,.*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^f=
reebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fuj=
itsu,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^=
gateway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,=
=2E*', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*',=
 '^geniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalsca=
le,.*', '^globaltop,.*', '^gmt,
> > >  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', =
'^goramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*'=
, '^hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.=
*', '^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinli=
nk,.*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.=
*', '^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*'=
, '^hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '=
^hugsun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.=
*', '^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^ic=
plus,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^im=
g,.*', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indie=
droid,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^=
ingrasys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secur=
e,.*', '^insignal,.*', '^insp
> > >  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^invente=
c,.*', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.=
*', '^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*'=
, '^jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesu=
run,.*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^k=
am,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kieback=
peter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*',=
 '^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*'=
, '^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattic=
e,.*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^=
lemaker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^li=
cheepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^link=
sprite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^lio=
ntron,.*', '^liteon,.*', '^li
> > >  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.=
*', '^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,=
=2E*', '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^mac=
nica,.*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^=
maxbotix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '=
^mbvl,.*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachip=
s,.*', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensin=
g,.*', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*',=
 '^methode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron=
,.*', '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mik=
rotik,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,=
=2E*', '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.=
*', '^mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^mot=
orcomm,.*', '^motorola,.*', '^mox
> > >  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', =
'^msi,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^m=
urata,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*=
', '^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*=
', '^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweas=
t,.*', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni=
,.*', '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '=
^nothing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', =
'^nutsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^ocean=
ic,.*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,=
=2E*', '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^o=
palkelly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpand=
ora,.*', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orise=
tech,.*', '^ortustech,.*', '^os
> > >  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^=
oxsemi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', =
'^particle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', =
'^phicomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9=
]+$', '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plath=
ome,.*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^p=
olaroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', =
'^pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^prim=
eview,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^pur=
ism,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodia=
n,.*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*=
', '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumf=
eld,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkabl=
e,.*', '^renesas,.*', '^rervi
> > >  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', =
'^ricoh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^ro=
cktech,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseap=
plepi,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.=
*', '^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*',=
 '^schneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seag=
ate,.*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^s=
ensirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmic=
ro,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,=
=2E*', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^sieme=
ns,.*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^=
silabs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', =
'^siliconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinli=
nx,.*', '^sinovoip,.*', '^sinow
> > >  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^sk=
ov,.*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '=
^smi,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun=
,.*', '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.=
*', '^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd=
,.*', '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-erics=
son,.*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^s=
te,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^s=
ummit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', =
'^swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.=
*', '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo=
,.*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^tec=
hstar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^te=
nda,.*', '^terasic,.*', '^tes
> > >  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,=
=2E*', '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^=
tmt,.*', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise=
,.*', '^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', =
'^tpo,.*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^trons=
mart,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u=
-blox,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispa=
ce,.*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upise=
mi,.*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*=
', '^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '=
^via,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^vir=
tual,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^viv=
ax,.*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*=
', '^vxt,.*', '^wacom,.*', '^wa
> > >  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^w=
elltech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora=
,.*', '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winl=
ink,.*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,=
=2E*', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '=
^xes,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xi=
npeng,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.=
*', '^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yimi=
ng,.*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '=
^yuridenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '=
^zidoo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> > >       from schema $id: http://devicetree.org/schemas/vendor-prefixes.=
yaml#
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindin=
gs/rng/sparc_sun_oracle_rng.example.dtb: rng@e (ORCL,m7-rng): 'rng-#units' =
does not match any of the regexes: '^#.*', '^(at25|bm|devbus|dmacap|dsa|exy=
nos|fsi[ab]|gpio-fan|gpio-key|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|=
max8952|max8997|max8998|mpmc),.*', '^(pciclass|pinctrl-single|#pinctrl-sing=
le|PowerPC),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),=
=2E*', '^(simple-audio-card|st-plgpio|st-spics|ts),.*', '^100ask,.*', '^70m=
ai,.*', '^8dev,.*', '^GEFanuc,.*', '^IBM,.*', '^ORCL,.*', '^SUNW,.*', '^[a-=
zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$',=
 '^abb,.*', '^abilis,.*', '^abracon,.*', '^abt,.*', '^acbel,.*', '^acelink,=
=2E*', '^acer,.*', '^acme,.*', '^actions,.*', '^actiontec,.*', '^active-sem=
i,.*', '^ad,.*', '^adafruit,.*', '^adapteva,.*', '^adaptrum,.*', '^adh,.*',=
 '^adi,.*', '^adieng,.*', '^admatec,.*', '^advantech,.*', '^aeroflexgaisler=
,.*', '^aesop,.*', '^airoha,.*',
> > >  '^al,.*', '^alcatel,.*', '^aldec,.*', '^alfa-network,.*', '^allegro,=
=2E*', '^allegromicro,.*', '^alliedtelesis,.*', '^alliedvision,.*', '^allo,=
=2E*', '^allwinner,.*', '^alphascale,.*', '^alps,.*', '^alt,.*', '^altr,.*'=
, '^amarula,.*', '^amazon,.*', '^amcc,.*', '^amd,.*', '^amediatech,.*', '^a=
mlogic,.*', '^ampere,.*', '^amphenol,.*', '^ampire,.*', '^ams,.*', '^amstao=
s,.*', '^analogix,.*', '^anbernic,.*', '^andestech,.*', '^anvo,.*', '^aoly,=
=2E*', '^aosong,.*', '^apm,.*', '^apple,.*', '^aptina,.*', '^arasan,.*', '^=
archermind,.*', '^arcom,.*', '^arctic,.*', '^arcx,.*', '^argon40,.*', '^ari=
aboard,.*', '^aries,.*', '^arm,.*', '^armadeus,.*', '^armsom,.*', '^arrow,.=
*', '^artesyn,.*', '^asahi-kasei,.*', '^asc,.*', '^asix,.*', '^aspeed,.*', =
'^asrock,.*', '^asteralabs,.*', '^asus,.*', '^atheros,.*', '^atlas,.*', '^a=
tmel,.*', '^auo,.*', '^auvidea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^=
avnet,.*', '^awinic,.*', '^axentia,.*', '^axiado,.*', '^axis,.*', '^azoteq,=
=2E*', '^azw,.*', '^baikal,.*', '^ban
> > >  anapi,.*', '^beacon,.*', '^beagle,.*', '^belling,.*', '^bestar,.*', =
'^bhf,.*', '^bigtreetech,.*', '^bitmain,.*', '^blaize,.*', '^bluegiga,.*', =
'^blutek,.*', '^boe,.*', '^bosch,.*', '^boundary,.*', '^brcm,.*', '^broadmo=
bi,.*', '^bsh,.*', '^bticino,.*', '^buffalo,.*', '^buglabs,.*', '^bur,.*', =
'^bytedance,.*', '^calamp,.*', '^calao,.*', '^calaosystems,.*', '^calxeda,.=
*', '^cameo,.*', '^canaan,.*', '^caninos,.*', '^capella,.*', '^cascoda,.*',=
 '^catalyst,.*', '^cavium,.*', '^cct,.*', '^cdns,.*', '^cdtech,.*', '^cellw=
ise,.*', '^ceva,.*', '^chargebyte,.*', '^checkpoint,.*', '^chefree,.*', '^c=
hipidea,.*', '^chipone,.*', '^chipspark,.*', '^chongzhou,.*', '^chrontel,.*=
', '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*', '^cirrus,.*', '^cis=
co,.*', '^cix,.*', '^clockwork,.*', '^cloos,.*', '^cloudengines,.*', '^cnm,=
=2E*', '^cnxt,.*', '^colorfly,.*', '^compal,.*', '^compulab,.*', '^comvetia=
,.*', '^congatec,.*', '^coolpi,.*', '^coreriver,.*', '^corpro,.*', '^cortin=
a,.*', '^cosmic,.*', '^crane,.*
> > >  ', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csot,.*', '^csq=
,.*', '^csr,.*', '^ctera,.*', '^ctu,.*', '^cubietech,.*', '^cudy,.*', '^cui=
,.*', '^cypress,.*', '^cyx,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*',=
 '^davicom,.*', '^deepcomputing,.*', '^dell,.*', '^delta,.*', '^densitron,.=
*', '^denx,.*', '^devantech,.*', '^dfi,.*', '^dfrobot,.*', '^dh,.*', '^difr=
nce,.*', '^digi,.*', '^digilent,.*', '^dimonoff,.*', '^diodes,.*', '^dioo,.=
*', '^djn,.*', '^dlc,.*', '^dlg,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*=
', '^dongwoon,.*', '^dptechnics,.*', '^dragino,.*', '^dream,.*', '^ds,.*', =
'^dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebang,.*', '^ebbg,.*', '^ebs-sys=
tart,.*', '^ebv,.*', '^eckelmann,.*', '^econet,.*', '^edgeble,.*', '^edimax=
,.*', '^edt,.*', '^ees,.*', '^eeti,.*', '^egnite,.*', '^einfochips,.*', '^e=
ink,.*', '^elan,.*', '^element14,.*', '^elgin,.*', '^elida,.*', '^elimo,.*'=
, '^elpida,.*', '^embedfire,.*', '^embest,.*', '^emcraft,.*', '^emlid,.*', =
'^emmicro,.*', '^empire-elect
> > >  ronix,.*', '^emtrion,.*', '^enbw,.*', '^enclustra,.*', '^endian,.*',=
 '^endless,.*', '^ene,.*', '^energymicro,.*', '^engicam,.*', '^engleder,.*'=
, '^epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.*', '^est,.*', '^eswin,.*', =
'^ettus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^evervision,.*',=
 '^exar,.*', '^excito,.*', '^exegin,.*', '^ezchip,.*', '^facebook,.*', '^fa=
irchild,.*', '^fairphone,.*', '^faraday,.*', '^fascontek,.*', '^fastrax,.*'=
, '^fcs,.*', '^feixin,.*', '^feiyang,.*', '^fii,.*', '^firefly,.*', '^flipk=
art,.*', '^focaltech,.*', '^forlinx,.*', '^foursemi,.*', '^foxlink,.*', '^f=
reebox,.*', '^freecom,.*', '^frida,.*', '^friendlyarm,.*', '^fsl,.*', '^fuj=
itsu,.*', '^fxtec,.*', '^galaxycore,.*', '^gameforce,.*', '^gardena,.*', '^=
gateway,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*', '^geekbuying,.*', '^gef,=
=2E*', '^gehc,.*', '^gemei,.*', '^gemtek,.*', '^genesys,.*', '^genexis,.*',=
 '^geniatech,.*', '^giantec,.*', '^giantplus,.*', '^glinet,.*', '^globalsca=
le,.*', '^globaltop,.*', '^gmt,
> > >  .*', '^gocontroll,.*', '^goldelico,.*', '^goodix,.*', '^google,.*', =
'^goramo,.*', '^gplus,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*'=
, '^hannstar,.*', '^haochuangyi,.*', '^haoyu,.*', '^hardkernel,.*', '^hce,.=
*', '^headacoustics,.*', '^hechuang,.*', '^hideep,.*', '^himax,.*', '^hinli=
nk,.*', '^hirschmann,.*', '^hisi,.*', '^hisilicon,.*', '^hit,.*', '^hitex,.=
*', '^holt,.*', '^holtek,.*', '^honestar,.*', '^honeywell,.*', '^hoperf,.*'=
, '^hoperun,.*', '^hp,.*', '^hpe,.*', '^hsg,.*', '^htc,.*', '^huawei,.*', '=
^hugsun,.*', '^huiling,.*', '^hwacom,.*', '^hxt,.*', '^hycon,.*', '^hydis,.=
*', '^hynitron,.*', '^hynix,.*', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^ic=
plus,.*', '^idt,.*', '^iei,.*', '^ifi,.*', '^ilitek,.*', '^imagis,.*', '^im=
g,.*', '^imi,.*', '^inanbo,.*', '^incircuit,.*', '^incostartec,.*', '^indie=
droid,.*', '^inet-tek,.*', '^infineon,.*', '^inforce,.*', '^ingenic,.*', '^=
ingrasys,.*', '^injoinic,.*', '^innocomm,.*', '^innolux,.*', '^inside-secur=
e,.*', '^insignal,.*', '^insp
> > >  ur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^invente=
c,.*', '^inversepath,.*', '^iom,.*', '^irondevice,.*', '^isee,.*', '^isil,.=
*', '^issi,.*', '^ite,.*', '^itead,.*', '^itian,.*', '^ivo,.*', '^iwave,.*'=
, '^jadard,.*', '^jasonic,.*', '^jdi,.*', '^jedec,.*', '^jenson,.*', '^jesu=
run,.*', '^jethome,.*', '^jianda,.*', '^jide,.*', '^joz,.*', '^jty,.*', '^k=
am,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.*', '^kieback=
peter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', '^kionix,.*',=
 '^kobo,.*', '^kobol,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kvg,.*'=
, '^kyo,.*', '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattic=
e,.*', '^lckfb,.*', '^lctech,.*', '^leadtek,.*', '^leez,.*', '^lego,.*', '^=
lemaker,.*', '^lenovo,.*', '^lg,.*', '^lgphilips,.*', '^libretech,.*', '^li=
cheepi,.*', '^linaro,.*', '^lincolntech,.*', '^lineartechnology,.*', '^link=
sprite,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^lio=
ntron,.*', '^liteon,.*', '^li
> > >  tex,.*', '^lltc,.*', '^logicpd,.*', '^logictechno,.*', '^longcheer,.=
*', '^lontium,.*', '^loongmasses,.*', '^loongson,.*', '^lsi,.*', '^luckfox,=
=2E*', '^lunzn,.*', '^luxul,.*', '^lwn,.*', '^lxa,.*', '^m5stack,.*', '^mac=
nica,.*', '^mantix,.*', '^mapleboard,.*', '^marantec,.*', '^marvell,.*', '^=
maxbotix,.*', '^maxim,.*', '^maxlinear,.*', '^maxtor,.*', '^mayqueen,.*', '=
^mbvl,.*', '^mcube,.*', '^meas,.*', '^mecer,.*', '^mediatek,.*', '^megachip=
s,.*', '^mele,.*', '^melexis,.*', '^melfas,.*', '^mellanox,.*', '^memsensin=
g,.*', '^memsic,.*', '^menlo,.*', '^mentor,.*', '^meraki,.*', '^merrii,.*',=
 '^methode,.*', '^micrel,.*', '^microchip,.*', '^microcrystal,.*', '^micron=
,.*', '^microsoft,.*', '^microsys,.*', '^microtips,.*', '^mikroe,.*', '^mik=
rotik,.*', '^milkv,.*', '^miniand,.*', '^minix,.*', '^mips,.*', '^miramems,=
=2E*', '^mitsubishi,.*', '^mitsumi,.*', '^mixel,.*', '^miyoo,.*', '^mntre,.=
*', '^mobileye,.*', '^modtronix,.*', '^moortec,.*', '^mosaixtech,.*', '^mot=
orcomm,.*', '^motorola,.*', '^mox
> > >  a,.*', '^mpl,.*', '^mps,.*', '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', =
'^msi,.*', '^mstar,.*', '^mti,.*', '^multi-inno,.*', '^mundoreader,.*', '^m=
urata,.*', '^mxic,.*', '^mxicy,.*', '^myir,.*', '^national,.*', '^neardi,.*=
', '^nec,.*', '^neofidelity,.*', '^neonode,.*', '^netcube,.*', '^netgear,.*=
', '^netlogic,.*', '^netron-dy,.*', '^netronix,.*', '^netxeon,.*', '^neweas=
t,.*', '^newhaven,.*', '^newvision,.*', '^nexbox,.*', '^nextthing,.*', '^ni=
,.*', '^nicera,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordic,.*', '=
^nothing,.*', '^novatech,.*', '^novatek,.*', '^novtech,.*', '^numonyx,.*', =
'^nutsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.*', '^nxp,.*', '^ocean=
ic,.*', '^ocs,.*', '^oct,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,=
=2E*', '^oneplus,.*', '^onie,.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^o=
palkelly,.*', '^openailab,.*', '^opencores,.*', '^openembed,.*', '^openpand=
ora,.*', '^openrisc,.*', '^openwrt,.*', '^option,.*', '^oranth,.*', '^orise=
tech,.*', '^ortustech,.*', '^os
> > >  ddisplays,.*', '^osmc,.*', '^ouya,.*', '^overkiz,.*', '^ovti,.*', '^=
oxsemi,.*', '^ozzmaker,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', =
'^particle,.*', '^pda,.*', '^pegatron,.*', '^pericom,.*', '^pervasive,.*', =
'^phicomm,.*', '^phontech,.*', '^phytec,.*', '^picochip,.*', '^pinctrl-[0-9=
]+$', '^pine64,.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plath=
ome,.*', '^plda,.*', '^plx,.*', '^ply,.*', '^pni,.*', '^pocketbook,.*', '^p=
olaroid,.*', '^polyhex,.*', '^pool[0-3],.*', '^portwell,.*', '^poslab,.*', =
'^pov,.*', '^powertip,.*', '^powervr,.*', '^powkiddy,.*', '^pri,.*', '^prim=
eview,.*', '^primux,.*', '^probox2,.*', '^prt,.*', '^pulsedlight,.*', '^pur=
ism,.*', '^puya,.*', '^qca,.*', '^qcom,.*', '^qemu,.*', '^qi,.*', '^qiaodia=
n,.*', '^qihua,.*', '^qishenglong,.*', '^qnap,.*', '^quanta,.*', '^radxa,.*=
', '^raidsonic,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raumf=
eld,.*', '^raydium,.*', '^rda,.*', '^realtek,.*', '^relfor,.*', '^remarkabl=
e,.*', '^renesas,.*', '^rervi
> > >  sion,.*', '^retronix,.*', '^revotics,.*', '^rex,.*', '^richtek,.*', =
'^ricoh,.*', '^rikomagic,.*', '^riot,.*', '^riscv,.*', '^rockchip,.*', '^ro=
cktech,.*', '^rohm,.*', '^ronbo,.*', '^ronetix,.*', '^roofull,.*', '^roseap=
plepi,.*', '^rve,.*', '^saef,.*', '^sakurapi,.*', '^samsung,.*', '^samtec,.=
*', '^sancloud,.*', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*',=
 '^schneider,.*', '^schulercontrol,.*', '^sciosense,.*', '^sdmc,.*', '^seag=
ate,.*', '^seeed,.*', '^seirobotics,.*', '^semtech,.*', '^senseair,.*', '^s=
ensirion,.*', '^sensortek,.*', '^sercomm,.*', '^sff,.*', '^sgd,.*', '^sgmic=
ro,.*', '^sgx,.*', '^sharp,.*', '^shift,.*', '^shimafuji,.*', '^shineworld,=
=2E*', '^shiratech,.*', '^si-en,.*', '^si-linux,.*', '^sielaff,.*', '^sieme=
ns,.*', '^sifive,.*', '^siflower,.*', '^sigma,.*', '^sii,.*', '^sil,.*', '^=
silabs,.*', '^silan,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.*', =
'^siliconfile,.*', '^siliconmitus,.*', '^silvaco,.*', '^simtek,.*', '^sinli=
nx,.*', '^sinovoip,.*', '^sinow
> > >  ealth,.*', '^sipeed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^sk=
ov,.*', '^skyworks,.*', '^smartfiber,.*', '^smartlabs,.*', '^smartrg,.*', '=
^smi,.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun=
,.*', '^solomon,.*', '^somfy,.*', '^sony,.*', '^sophgo,.*', '^sourceparts,.=
*', '^spacemit,.*', '^spansion,.*', '^sparkfun,.*', '^spinalhdl,.*', '^sprd=
,.*', '^square,.*', '^ssi,.*', '^sst,.*', '^sstar,.*', '^st,.*', '^st-erics=
son,.*', '^starfive,.*', '^starry,.*', '^startek,.*', '^starterkit,.*', '^s=
te,.*', '^stericsson,.*', '^storlink,.*', '^storm,.*', '^storopack,.*', '^s=
ummit,.*', '^sunchip,.*', '^sundance,.*', '^sunplus,.*', '^supermicro,.*', =
'^swir,.*', '^syna,.*', '^synology,.*', '^synopsys,.*', '^taos,.*', '^tbs,.=
*', '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^tcs,.*', '^tcu,.*', '^tdo=
,.*', '^team-source-display,.*', '^technexion,.*', '^technologic,.*', '^tec=
hstar,.*', '^techwell,.*', '^teejet,.*', '^teltonika,.*', '^tempo,.*', '^te=
nda,.*', '^terasic,.*', '^tes
> > >  la,.*', '^test,.*', '^tfc,.*', '^thead,.*', '^thine,.*', '^thingyjp,=
=2E*', '^thundercomm,.*', '^thwc,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^=
tmt,.*', '^topeet,.*', '^topic,.*', '^topland,.*', '^toppoly,.*', '^topwise=
,.*', '^toradex,.*', '^toshiba,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', =
'^tpo,.*', '^tq,.*', '^transpeed,.*', '^traverse,.*', '^tronfy,.*', '^trons=
mart,.*', '^truly,.*', '^tsd,.*', '^turing,.*', '^tyan,.*', '^tyhx,.*', '^u=
-blox,.*', '^u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ufispa=
ce,.*', '^ugoos,.*', '^ultratronik,.*', '^uni-t,.*', '^uniwest,.*', '^upise=
mi,.*', '^urt,.*', '^usi,.*', '^usr,.*', '^utoo,.*', '^v3,.*', '^vaisala,.*=
', '^valve,.*', '^vamrs,.*', '^variscite,.*', '^vdl,.*', '^vertexcom,.*', '=
^via,.*', '^vialab,.*', '^vicor,.*', '^videostrong,.*', '^virtio,.*', '^vir=
tual,.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^viv=
ax,.*', '^vocore,.*', '^voipac,.*', '^voltafield,.*', '^vot,.*', '^vscom,.*=
', '^vxt,.*', '^wacom,.*', '^wa
> > >  nchanglong,.*', '^wand,.*', '^waveshare,.*', '^wd,.*', '^we,.*', '^w=
elltech,.*', '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^widora=
,.*', '^wiligear,.*', '^willsemi,.*', '^winbond,.*', '^wingtech,.*', '^winl=
ink,.*', '^winsen,.*', '^winstar,.*', '^wirelesstag,.*', '^wits,.*', '^wlf,=
=2E*', '^wm,.*', '^wobo,.*', '^wolfvision,.*', '^x-powers,.*', '^xen,.*', '=
^xes,.*', '^xiaomi,.*', '^xicor,.*', '^xillybus,.*', '^xingbangda,.*', '^xi=
npeng,.*', '^xiphera,.*', '^xlnx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.=
*', '^yadro,.*', '^yamaha,.*', '^yes-optoelectronics,.*', '^yic,.*', '^yimi=
ng,.*', '^ylm,.*', '^yna,.*', '^yones-toptech,.*', '^ys,.*', '^ysoft,.*', '=
^yuridenki,.*', '^yuzukihd,.*', '^zarlink,.*', '^zealz,.*', '^zeitec,.*', '=
^zidoo,.*', '^zii,.*', '^zinitix,.*', '^zkmagic,.*', '^zte,.*', '^zyxel,.*'
> > >       from schema $id: http://devicetree.org/schemas/vendor-prefixes.=
yaml#
> > >
> > > doc reference errors (make refcheckdocs):
> > >
> > > See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20=
250923103900.136621-1-dev@kael-k.io
> > >
> > > The base for the series is generally the latest rc1. A different depe=
ndency
> > > should be noted in *this* patch.
> > >
> > > If you already ran 'make dt_binding_check' and didn't see the above
> > > error(s), then make sure 'yamllint' is installed and dt-schema is up =
to
> > > date:
> > >
> > > pip3 install dtschema --upgrade
> > >
> >
> > I actually ran the check during development and before sending the
> > patch. In the first drafts I wrote, I had the same error, but after a f=
ew
> > days it disappeared. Given the fact that 'make dt_binding_check' wasn't
> > giving me any errors or warnings, I trusted the check and assumed that
> > the vendor list or something in the validation logic had changed after
> > pulling new changes.
> >
> > I tried to run 'make dt_binding_check' again by
> > cloning the repo from scratch and with a new venv.
> >
> > $ which python && pip list
> > /home/kael-k/Projects/linux/.venv/bin/python
> > Package                       Version
> > ----------------------------- -----------
> > alabaster                     1.0.0
> > attrs                         25.3.0
> > babel                         2.17.0
> > certifi                       2025.8.3
> > charset-normalizer            3.4.3
> > docutils                      0.21.2
> > dtschema                      2025.8
> > idna                          3.10
> > imagesize                     1.4.1
> > Jinja2                        3.1.6
> > jsonschema                    4.17.3
> > MarkupSafe                    3.0.2
> > packaging                     25.0
> > pathspec                      0.12.1
> > pip                           25.2
> > Pygments                      2.19.2
> > pylibfdt                      1.7.2.post1
> > pyrsistent                    0.20.0
> > PyYAML                        6.0.2
> > requests                      2.32.5
> > rfc3987                       1.3.8
> > roman-numerals-py             3.1.0
> > ruamel.yaml                   0.18.15
> > ruamel.yaml.clib              0.2.14
> > snowballstemmer               3.0.1
> > Sphinx                        8.2.3
> > sphinxcontrib-applehelp       2.0.0
> > sphinxcontrib-devhelp         2.0.0
> > sphinxcontrib-htmlhelp        2.1.0
> > sphinxcontrib-jsmath          1.0.1
> > sphinxcontrib-qthelp          2.0.0
> > sphinxcontrib-serializinghtml 2.0.0
> > urllib3                       2.5.0
> > yamllint                      1.37.1
> >
> >
> > $ make clean
> > CLEAN   Documentation/devicetree/bindings
> >
> > $ make dt_binding_check DT_SCHEMA_FILES=3Dsparc_sun_oracle_rng.yaml
>=20
> Setting DT_SCHEMA_FILES only checks the examples in the matching
> schema files against those schema files. So it is fine to set
> DT_SCHEMA_FILES as a shortcut for initial testing, you ultimately have
> to test without DT_SCHEMA_FILES set.
>=20
> Rob

Thanks for the clarification, I confirm what you have said, as this morning=
=20
I tried to run 'make dt_binding_check' without DT_SCHEMA_FILES and I=20
correctly got the error you reported.

I double checked the documentation page I looked at:
https://docs.kernel.org/devicetree/bindings/writing-schema.html#running-che=
cks

While it is true that in:
https://docs.kernel.org/devicetree/bindings/submitting-patches.html
It says to run 'make dt_binding_check', it also says to look at the=20
first link I mentioned "for more details about schema and tools setup".

Given what's written in the first link, I inferred that DT_SCHEMA_FILES=20
would only limit the scope of the files that have to be checked. But,
as you've said, it also limits the checks that will run against those files.

I think that it might be a good idea to update the docs in the first=20
link to at least mention that using the DT_SCHEMA_FILES variable will also =
limit=20
the types of checks executed and that, to be more specific,
the dt binding schema check is skipped.

Kael
