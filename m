Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E753CC38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 06:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIGGql (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 02:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIGGqk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 02:46:40 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B88277D
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 23:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662533198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=wENIUjafMmTedK4Vzu4Xa73ZJBaqszSRBjtdYQiBkTI=;
        b=WEHRvTmm/XCgZMhzu8PaqlihWO9hxaA9KEMBlIFzV5in5YfCztra5prIdeTAOGzDujskyF
        qkE0HMN8ad0SNpNlW8/ozyOM2SVlj86TLWAK1J8XXSZeHpqcikaTYKJgzuHghCJmRtZ33T
        oSQ6bMRQnrrazxHZKgsgouFdNajOx4cGFuS5Ieu4eouGyArt+9Gt4xmIBJcHBbkQdHjtPN
        /6GSgze48EXpJQe6zoOaak4dYWYuJuxRDliac+IuudR7melbwIjnyL+TuuuVJBYzJqJsjy
        xdNwrrgbDqFdAev/30QWRj3KzwOiUuFuQ2UinsAVc3d0YxUWnZ2PxMmjlUAi0w==
Received: from NAM02-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-r0WlRcLhMXaaHdlsbfA0JA-2; Wed, 07 Sep 2022 02:46:37 -0400
X-MC-Unique: r0WlRcLhMXaaHdlsbfA0JA-2
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by MN2PR19MB3933.namprd19.prod.outlook.com (2603:10b6:208:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 06:46:32 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::b841:6e14:1257:774a]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::b841:6e14:1257:774a%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 06:46:32 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Subject: Re: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
Thread-Topic: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
Thread-Index: AQHYwZuhJOtFv92MlU2QoKo8a0Nwig==
Date:   Wed, 7 Sep 2022 06:46:32 +0000
Message-ID: <DM6PR19MB31633BFB6AD885E0EAF68F14A1419@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
 <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com>
 <166247313358.3585.5988889047992659412@kwain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1419a4f3-b718-4de2-f872-08da909cb33e
x-ms-traffictypediagnostic: MN2PR19MB3933:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cEPWBuk/X2PxLrj2OiWbr+FFPmnhMowrLSbOF6YKqI9TA0t2h+iWmwiYSfQOMhp7i35zL+HYRGr0ZdR6VNaztIkW4gALHNoSeMRZ3CWjCIA4poUiH+UWiOcNk8Tn191U/kSjlDh7J+G0nxrMhI6MotoScSQ8vbbA5rPIC8daXqcOq73pPW0aEzM7I/GYhNmMMq2gk1nqQkG2i59pz0EmikmTIBEbKi2Gm/XSwy4/KO2a749ewEE5pkX6JeHl7e93pOYCicwBXfXbsuqeKX3pGDQdhtt89pm7OC2TzEDPgbdyjO57zro4Q9rOco75R2ACYks/X1/JF74WSZfC9YCLSayKQ5AzvNshDjh089V9cJ80wSHIUR//49TqADafCZNm9NRxbPhcP/rNdEls2Q2FFJzhK8x2mly7lGHhtEPHmsW5jDZc/A4Ub6g1y9bN+Q2z89RVMlnk03+lYvoz/rdicpyRnxJywBTZQHwXfDGMNVj770KPF1nXTkoKb7ygSpXD/lK0ESrrWB1X/9E5/OVGQv3Ep7X4zTpOwfr1fYmqyEtqZeG3yJVHyg944PgSbfYkmSIjDDRtCdyeAIzygAFLvFo3SISNC/Bc8TrQoekRE6krOTC+eWwH+TGjzpcJ5k9MhXq6Ndfq/hvJscB92mM5TqOM810tIT2W5HruUVjH/H7AYkgG6OEV0uZ9sMv0ESwoq0DDygN1Mi9eaCgn3hUqYtFBzfszOd9xh/KtePUJr8Oz5CMg6hnt53Cdd+5aoLGmhmtgSd0cBaTcp+8mMj5oOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39850400004)(366004)(376002)(38100700002)(122000001)(45080400002)(316002)(4326008)(66556008)(76116006)(66476007)(8676002)(64756008)(66446008)(66946007)(91956017)(86362001)(38070700005)(33656002)(83380400001)(9686003)(107886003)(7696005)(6506007)(41300700001)(71200400001)(478600001)(26005)(53546011)(55016003)(110136005)(54906003)(8936002)(186003)(5660300002)(2906002)(52536014);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5mD2TplFvjA4o6gbYXVt766Nia1LtIaQnq8MkMhG17ys+v3xE/xvQ5JuNEVy?=
 =?us-ascii?Q?zHV5jlTSDCYnOgS0iJ2N5vtk1sg2vtUAEHj2xmYjTDnik0MIERtsFnpOsxen?=
 =?us-ascii?Q?KqBSEo8IWumUjV1G1ZevBZ8U/3vNJHA6otHaGCbhqO8mb5KX3Sn+LUWvtKxn?=
 =?us-ascii?Q?YTJUdI96gv88t5oVqnV4hXrKMsyTQ6m9G9mEKkcC9zGen/pnmW1WS4uggjlU?=
 =?us-ascii?Q?VMhRklMWDkY6Ois5dYJOhGk3Pg2G0tFU9NdiezGDthpMGmJWNqh3GkgHXSvP?=
 =?us-ascii?Q?LkB7rKjfdDEZHG/usHZcY/3/SxRrknm2wbAI49VzJylC4dFcF2WK3IpQeKsd?=
 =?us-ascii?Q?W27O0mToMlpkBNYb5Oce+KGmqfL/QWjn4THQRiIphToBQoCeqdwmmVC2dxwx?=
 =?us-ascii?Q?XbpPXbqtBJJctpHIpiTI4V5WOVg2sBGXwOX0l3B6tarlvsDBF4mLyIpqvpIv?=
 =?us-ascii?Q?TobaG9mDlELv2puEr6rgub5Sk6rcOl6xXqWd5ccOd2eFJ4CMiH/zwX+PFVNr?=
 =?us-ascii?Q?wsVMkBO3WyQf8tVk+djIEf5+6mX6lNjrWKY7onhagHHnT6BVezFTLOS35RU3?=
 =?us-ascii?Q?JP0gzlMW74T0K958tmfiX41nnr0R15/vpgs58H/M4ixYppHtuaG9W91bDGuF?=
 =?us-ascii?Q?SeR5ShTzR4MSFiA2lJc61TtAxmBOLYe+p/tHNaSU3yVXGPWDxbE/yDUdFUXl?=
 =?us-ascii?Q?90Wd0aNf/lgJGx5Gtr+nudoRNUAvYxEYkU5AqvfgxB7jknh1F1bwi/DWw1bF?=
 =?us-ascii?Q?SLkfoTAHcmElpGPeB4Bd2zK5kq0zGdXKVPW0U+xMUAFIv3dB743dE3lprusq?=
 =?us-ascii?Q?gSjM+nstU2QAxcngthH7N5ryBCe1SChig4oStD+vc41t5PNsx4CjrdOIuT10?=
 =?us-ascii?Q?U77R2RlAcM4mTvEaNlZ6dOk8Y5GI3NTk8EroF19tJwkvzpHGElbMej/gXqZ1?=
 =?us-ascii?Q?H/VnptNQvyhHwtlUguHOk4J7yWTwLU5o34H284EPlbWXAxXv1JYIHPB4G2ls?=
 =?us-ascii?Q?qhznqRY7sYjvSbLKsEgw+t03kmOqlxpHi79dwGkIGYGXnDrEUajLwbSrLwJP?=
 =?us-ascii?Q?DA78r6OJrCbp8bFY2hFMm8awH7zBoPXoYfyrhks5C/TD7atJf3IWVe6jOCPi?=
 =?us-ascii?Q?ICaDrVzpJTdeG27EtyMNE31/7l+xQBXA4cLBMIWtmzN6vQX50T8BznSzy9lf?=
 =?us-ascii?Q?sXKMT1lISPLPZLJZku+qpAKy/9RdOAAP7dvxwI6yo+Vh5ABBY3w1Om7UO5vD?=
 =?us-ascii?Q?XWU43lGS2Z/22VWyHSQfbEZvFlV/HtO0Ha02MGUy/XUXnbUt/ef0x2dWX6ly?=
 =?us-ascii?Q?8nKsxpsyNnTCJ0aaR8teL5X6RoNj59xkvcsSP+FIIXavMutbUQ/HelDMSG0r?=
 =?us-ascii?Q?HqfTHfREm6LQjbAwNdCfhYeTWNZYNquzMGANChNljQ14y7aeT+r1nbVHasQ1?=
 =?us-ascii?Q?/v6W28lj+rv6WlaBK0ePXkzhpYnweKVF670TZfls8uT5kN+0O5XMaXta8gll?=
 =?us-ascii?Q?4y9XdN8/TINpToYeCy057/H4BGyDkLLJNWE9HbvIMg5qhl9R9nI2ClZ7/GCK?=
 =?us-ascii?Q?29Ta+NkA9UG/UUGgsAfQOnn+WqWN14BK/y5Ok0rNXYDppXV4phlGKVTXQ6wf?=
 =?us-ascii?Q?mw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1419a4f3-b718-4de2-f872-08da909cb33e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 06:46:32.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3M+q+861D9yYj3DuvWkwbsgc9bon6Ao0/4lfXoriTJ4tovse/1LEYynbMVs84mnKo4ZR+pntWVOGizsmJ+n/cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3933
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/9/2022 10:05 pm, Antoine Tenart wrote:=0A>> CRYPTO_AES is needed for a=
es-related algo (e.g.=0A>> safexcel-gcm-aes, safexcel-xcbc-aes, safexcel-cm=
ac-aes).=0A>> Without it, we observe failures when allocating transform=0A>=
> for those algo.=0A>>=0A>> Fixes: 363a90c2d517 ("crypto: safexcel/aes - sw=
itch to library version of key expansion routine")=0A>=20=0A> The above com=
mit explicitly switched crypto drivers to use the AES=0A> library instead o=
f the generic AES cipher one, which seems like a good=0A> move. What are th=
e issues you're encountering and why the AES lib makes=0A> the driver to fa=
il?=0A=0AIf I load the kernel module (CONFIG_CRYPTO_MANAGER_DISABLE_TESTS i=
s not=0Aset), I am getting failure messages below.=0AIMHO this happens beca=
use some functions in the driver still rely on=0Ageneric AES cipher (e.g. r=
efer to safexcel_aead_gcm_cra_init() or=0Asafexcel_xcbcmac_cra_init()), the=
refore CONFIG_CRYPTO_AES is still needed.=0A=0AMaybe the alternative is to =
switch all of them to use AES lib instead?=0ALet me know if you prefer this=
.=0A=0AThanks!=0A=0A[  157.683462] alg: aead: failed to allocate transform =
for=0Asafexcel-gcm-aes: -2=0A[  157.689054] ------------[ cut here ]-------=
-----=0A[  157.693650] alg: self-tests for safexcel-gcm-aes (gcm(aes)) fail=
ed=0A(rc=3D-2)=0A[  157.693696] WARNING: CPU: 3 PID: 164 at crypto/testmgr.=
c:5804=0Aalg_test.part.0+0xd1/0x2f0 [cryptomgr]=0A[  157.709505] Modules li=
nked in: crypto_safexcel(+) md5 sha512_generic=0Alibdes sha256_generic libs=
ha256 sha1_gene=0Aric libsha1 libaes authenc cryptomgr akcipher crypto_acom=
press kpp rng=0Acrypto_null crypto_hash skcipher aead cryp=0Ato_algapi=0A[ =
 157.729991] CPU: 3 PID: 164 Comm: cryptomgr_test Not tainted=0A6.0.0-rc3+ =
#42=0A[  157.736900] RIP: 0010:alg_test.part.0+0xd1/0x2f0 [cryptomgr]=0A[  =
157.742512] Code: 6c 85 db 0f 84 89 00 00 00 80 3d 59 6c 05 00 00 0f=0A85 0=
8 40 00 00 89 d9 4c 89 f2 48 89 ee 48=0A c7 c7 40 1c 09 a0 e8 cc 17 28 e2 <=
0f> 0b 48 8b 84 24 90 00 00 00 65 48=0A33 04 25 28 00 00 00 0f 85 eb=0A[  1=
57.761177] RSP: 0018:ffffc90000557e40 EFLAGS: 00010246=0A[  157.766359] RAX=
: 0000000000000000 RBX: 00000000fffffffe RCX:=0A0000000000000000=0A[  157.7=
73440] RDX: 0000000000000001 RSI: 00000000ffffdfff RDI:=0A00000000ffffffff=
=0A[  157.780528] RBP: ffff8880046ed200 R08: 0000000000000000 R09:=0Affffc9=
0000557ce8=0A[  157.787610] R10: 0000000000000001 R11: 0000000000000003 R12=
:=0A0000000000011083=0A[  157.794699] R13: 0000000000000400 R14: ffff888004=
6ed280 R15:=0Affffffffffffffff=0A[  157.801780] FS:  0000000000000000(0000)=
 GS:ffff88807a580000(0000)=0AknlGS:0000000000000000=0A[  157.809818] CS:  0=
010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A[  157.815516] CR2: 0000560ce=
ce6c0d8 CR3: 0000000002a0a000 CR4:=0A00000000001006a0=0A[  157.822608] Call=
 Trace:=0A[  157.825018]  <TASK>=0A[  157.827104]  ? _raw_spin_unlock+0xd/0=
x30=0A[  157.830989]  ? finish_task_switch+0x8a/0x260=0A[  157.835221]  ? _=
_schedule+0x27c/0x670=0A[  157.838855]  ? 0xffffffffa004c000=0A[  157.84213=
1]  cryptomgr_test+0x22/0x50 [cryptomgr]=0A[  157.846804]  kthread+0xd0/0x1=
00=0A[  157.849908]  ? kthread_complete_and_exit+0x20/0x20=0A[  157.854664]=
  ret_from_fork+0x1f/0x30=0A[  157.858209]  </TASK>=0A[  157.860346] ---[ e=
nd trace 0000000000000000 ]---=0A[  157.908463] alg: hash: failed to alloca=
te transform for=0Asafexcel-xcbc-aes: -2=0A[  157.914132] ------------[ cut=
 here ]------------=0A=0A

