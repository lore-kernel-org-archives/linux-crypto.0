Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DB5C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 07:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F3620663
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 07:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mW3sQxHr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLJH4R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 02:56:17 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6231
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbfLJH4R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 02:56:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGZlOIQTvcO2GvWk/Ag359FIUyhaO/qJh/gF46Z9Y15PAMc73CK+6mjT5WbCMzLJUiUXf+5zIT8lE/UPG7zLW16thF6WADSSTwkOyIF5kopjlXiobeUA0tNVt/+8wVrFPMO3y+SkGQyEAPE/mbmSmV4E7GrG7h1EIx9GitofPG2JTiVO3678gY6rXVT2JkUZMQNe5sMR2tlM9FWTIR7l7Palw/25nLSHzZPooneZKNSGhn9gd/9P5YR3xWCAIhR8EjJ4SfQ9Mgnj3fTQanP4K81ZVVO+8hunJronPfTQpvbxRw5cVgMLwvtvrvEb/gdzUSq6qC0pnNubvsUffWNM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivKuD0VO4RjzlVM4+Z4wnDsyPr6leurFbvVLFdmvRXw=;
 b=VXmPCw7CSmP6g1vnHnZbHowmrQVc+BjSi6oCEI4Irkjdo7UWRhjOQlfzVzrIPVhMV3ETkT+3cTsbXfm8dYWwHiCoCFG2No9GZQ2EdBUAOWG7fGdmCrxlXQW6ZipPjSF6aWPOB2bOyLz0hyFMC/Ztyq9QXHRrKcV+LWjL/azaqN+7mn8ma4i0tfNBB6cyAVAlnZK/Amje9URWDMzZ/vYZxgMin3lrmXWtALLwhIS1OCRoVlXIqm3C3/ebGmhi8KrlT8BF764nrYJWum6vWwDTiJdyuXFxUTKI5OCaXQOX/SjsTWdTTwDYFO7iaOTV20YqIEJoxltR30KJPC/SVazQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivKuD0VO4RjzlVM4+Z4wnDsyPr6leurFbvVLFdmvRXw=;
 b=mW3sQxHrb1Qj+F7Gaex3qqx0d+KxLnLohNzO6kSwUrEWxv3/2q3rqRZ0cX2Xtt/+KRwmf51xEoIJwY4pjw8lkBrudxdk17O4PFLkC/5XVqSqVTwGZrICWZoTlv9JGmcR8D2VLIQfPKXlTcjwm8Xel3AMRMZPLeeB44JUfq3+8Do=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2814.eurprd04.prod.outlook.com (10.172.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 07:56:09 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 07:56:09 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Adam Ford <aford173@gmail.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Topic: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Index: AQHVp9DLhD4655goh0SoqF8mEBltdw==
Date:   Tue, 10 Dec 2019 07:56:09 +0000
Message-ID: <VI1PR0402MB34857B8C5560B912B34674AB985B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191130225153.30111-1-aford173@gmail.com>
 <e8e429dd-4508-9835-fd01-825d2de8871e@kontron.de>
 <CAHCN7xLkV1WC=9ACj1Mi8+uE8kRCEjCEe+Y36pXwkNeNrgrNVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7de3bd68-2464-4c47-6a37-08d77d466b59
x-ms-traffictypediagnostic: VI1PR0402MB2814:|VI1PR0402MB2814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB281482D0A7ED7FD6E10208A8985B0@VI1PR0402MB2814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:332;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(51444003)(189003)(199004)(8936002)(8676002)(5660300002)(6506007)(81166006)(81156014)(55016002)(305945005)(33656002)(52536014)(7416002)(66556008)(64756008)(66476007)(229853002)(7696005)(186003)(66446008)(91956017)(2906002)(54906003)(71200400001)(66946007)(4326008)(86362001)(71190400001)(478600001)(53546011)(9686003)(26005)(76116006)(316002)(110136005)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2814;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjwf0v/HF7m5b76gwOZIf4LJfctT4j0II6ipyQf07G/rg/mVl6HyEgfg+sMtrrYH7uT2cl43DWKjgoVvZF0cBI2X+oMj7HAUA+jU2drRmYIHNQdKffJuH6vzVxFW5khcQJ9o8Kqokz1rCWtY2vrlxIP8bS7oHfe+hbWwi9WeFCSaEtmd8ZegZOxsOOi5sxOMGbsCJk9l6jFo+dvGnlQhdDhryV4h49sMEcgl3EiY7XxcW6DQNFuRk6wkbHKWIDCQjZzSKwqrcfnzjdLsSsEHth1CSI8iBCJItqh3t4w1qhFV599SOrIP+Oc4FwNRftpiIlLfJclagjESGYNbiiiuYoOPTS9kz/I1vMPpCEvv09f/8UMCmkuEiZi4gG9Pv9Dddw7TQ5ysr3uCkEUaE/H94iON3cp4rw1FHBc83G/VyeRMsUOW8Thec+QEZx4o3n+JPsQCqPRGpnNk0OpDM7F94kibHedU9OjIF796d/FlVvh7X4DCpAxtA1JUbqeWJO7r
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de3bd68-2464-4c47-6a37-08d77d466b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 07:56:09.6700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbJcbrGvW2+1DRqLoh1k2zYbBPPOX7SXXBEu4Fza2IKT0B1S1AFou7RbOI72rpg02kkqp1TCgGe2xEEciB2PMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/6/2019 9:55 PM, Adam Ford wrote:=0A=
> On Wed, Dec 4, 2019 at 5:38 AM Schrempf Frieder=0A=
> <frieder.schrempf@kontron.de> wrote:=0A=
>>=0A=
>> Hi Adam,=0A=
>>=0A=
>> On 30.11.19 23:51, Adam Ford wrote:=0A=
>>> The i.MX8M Mini uses the same crypto engine as the i.MX8MQ, but=0A=
>>> the driver is restricting the check to just the i.MX8MQ.=0A=
>>>=0A=
>>> This patch lets the driver support all i.MX8M Variants if enabled.=0A=
>>>=0A=
>>> Signed-off-by: Adam Ford <aford173@gmail.com>=0A=
>>=0A=
>> What about the following lines in run_descriptor_deco0()? Does this=0A=
>> condition also apply to i.MX8MM?=0A=
> =0A=
> I think that's a question for NXP.  I am not seeing that in the NXP=0A=
> Linux Release, and I don't have an 8MQ to compare.=0A=
> =0A=
IIRC the i.MX BSP releases use the JRI for initializing the RNG,=0A=
and not the DECO register interface.=0A=
=0A=
> I was able to get the driver working on the i.MXMM with the patch.=0A=
> =0A=
You are probably using a newer U-boot, which includes=0A=
commit dfaec76029f2 ("crypto/fsl: instantiate all rng state handles")=0A=
=0A=
> NXP  Team,=0A=
> =0A=
> Do you have any opinions on this?=0A=
> =0A=
Since current U-boot initializes both RNG state handles, practically=0A=
instantiate_rng() is a no-op.=0A=
=0A=
A simple experiment is to "lie" about the state_handle_mask, to exercise=0A=
the DECO acquire code (or, as mentioned above, to run with an older U-boot)=
:=0A=
=0A=
@@ -268,12 +272,19 @@ static int instantiate_rng(struct device *ctrldev, in=
t state_handle_mask,=0A=
        struct caam_ctrl __iomem *ctrl;=0A=
        u32 *desc, status =3D 0, rdsta_val;=0A=
        int ret =3D 0, sh_idx;=0A=
+       static int force_init =3D 1;=0A=
=0A=
        ctrl =3D (struct caam_ctrl __iomem *)ctrlpriv->ctrl;=0A=
        desc =3D kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);=0A=
        if (!desc)=0A=
                return -ENOMEM;=0A=
=0A=
+       if (force_init && (state_handle_mask =3D=3D 0x3)) {=0A=
+               dev_err(ctrldev, "Forcing reinit of RNG state handle 0!\n")=
;=0A=
+               force_init =3D 0;=0A=
+               state_handle_mask =3D 0x2;=0A=
+       }=0A=
+=0A=
        for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
                /*=0A=
                 * If the corresponding bit is set, this state handle=0A=
=0A=
In this case boot log confirms the DECO cannot be acquired:=0A=
[    2.137101] caam 30900000.crypto: Forcing reinit of RNG state handle 0!=
=0A=
[    2.172293] caam 30900000.crypto: failed to acquire DECO 0=0A=
[    2.177786] caam 30900000.crypto: failed to instantiate RNG=0A=
=0A=
To sum up, writing to DECORSR is mandatory.=0A=
=0A=
Horia=0A=
