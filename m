Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B94C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 18:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiDPSHt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 14:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiDPSHt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 14:07:49 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5D31E3DA
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 11:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKe5VCUakikyFtZCCyyp9/VMdc6pYK2XhGV9TkM+8iIvojPXevNIxf47mzx56r1Tum6N4VC9SL4SnyS4FutPSgLcfe9uaRWqn86yczEhBq4gGfrRHSYn4ZWvVnc5UhFCGKmm/nl9cfMuR1+oUKLnCJDzdxrGERAYKiUTkF74pUaL3zw2Oif3uWQSlquJ6+YRtXAv+cDf0JgRgZaaqnhO7tNj5bIWn7Qo2o6rZ1pZaKu4fph2NKaOD3Y+xmVmBiTVguTAL6czWs1/h1aW/IbSgq2QiQ25Fq8Xpc8i0I24mIeaFEXAO85RzgAbCFyjIWtBYg9Uzl8skJ6D7YnfEPUH/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8H7OBOT62TTy3jmQ0qj+dQO049uJWturoCGaVIze8Jc=;
 b=d/w9L2RXcc1OtwWuX6tEeT0okxOqwpxcDvJoP91hfdKtLbcW72pdJ3jGgk3LWhhOiOjd6OvD03vBnJdfH4XuQ2RtjOH1qxReiQ38OVEbCqZZyPH5aexaRHZlTLsHrBCbCbOXFmed2l6I65aK2uZ4NS2u40PUxjQTUj10OihVuG5JMzHlRQ7e14hYRAA5yjFeJMisu7ju6U2Ufk56N66VaMD+27aGzG5fIGqTmWLWfGkIIJMdnz73gyqzg60YkT59+He0YaXYngVO0d8DGNFYHDwlZf5ajZJh7NiuwfFHK82+/FdJFj8l8SSkc9zM5ebjmIi80eSj7vrpX6XnaUVtFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8H7OBOT62TTy3jmQ0qj+dQO049uJWturoCGaVIze8Jc=;
 b=SLuA6EHPODuLQWE6n7+qs3rVJsPTXKm0NNKyj73Sdb7As0VQZ0VY2WjBZ7taV2qI3k+W3N6LdcZVdwxovCjLCed4rqxgxIW0nZ2r9b4UPBVD4xyaYc2wdu8ashm7OSQn+RN/XWGwmy/vpUtyfyAi52F4VbnVh4HVVdKEHOQGiJc=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by AM9PR04MB8571.eurprd04.prod.outlook.com (2603:10a6:20b:436::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sat, 16 Apr
 2022 18:05:13 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e%4]) with mapi id 15.20.5144.032; Sat, 16 Apr 2022
 18:05:13 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Subject: RE: [EXT] Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay
 value
Thread-Topic: [EXT] Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay
 value
Thread-Index: AQHYUZ8HpNXIDc264ki1mBi+NAHyrazy1IzA
Date:   Sat, 16 Apr 2022 18:05:13 +0000
Message-ID: <AM9PR04MB821143E734E6608FCDCC61F1E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
References: <20220416135412.4109213-1-festevam@gmail.com>
 <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
In-Reply-To: <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24ef953d-4c4b-4e93-efd7-08da1fd3a75a
x-ms-traffictypediagnostic: AM9PR04MB8571:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8571FB370E9C966A18CE9246E8F19@AM9PR04MB8571.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymBJD1xyCE2UjsEONAkOCor4YePqcJmdTN0sD9d17q+QLghOppU5jZR4wnh1losAWNEOghxDri5U6y+laKWv1V2Arzf1cLTJDSl0MOeFfG6Ns/fojGzO/8ccBK6hndCNaWm1ROpz9CgR5PENJ0bH1vuiwJ/jpJCJkvo9XmMQ/oZAyvmjqbClltcKH745sFpnbWKp1zzA/pItUqhHqBrNk/l4EOu61e64DlWF0UT6OPptnEdwvTdrmlWBLxE8z6wuH4i7Wbor91oB72z8WENE5vusvnxZaFLuR57K8opmuuNQd6XdMCgxKAargvEEL9q0AduOtFINdnztgj+AKmMKfoLJXkWr/vJD9VHqEBEEleWmyiKv/aRcd80krSLwfKD2YDqSbFBEoY7ldsEssntWMMxpAAlzWSVU6dK7v5A3lNE/PAWczYCrwO+oTIRTI59E+nItdd1jsb3EHR6dV+lADNxLmXEoUvZAnAA4Ca+ElZTLlc+krdRXTSjaLUa00+JaeFfhWFUQ9UHMogHPUiEseJDHRk12u3DICsrcSQltQ58bKhia9eYWkUMtbeUI3ZyOdSgegjdwV7f8szSjO6c2jNZdKd6mGklLQCQKse0dPyWvIBRgq+RM9g+lSVOPHT1T2KTYTD8tYVwGsRPNsmBc/mqIVommJfC3yKIZXWszc3v8ptkL+ObyuazFMfA6YPjKdWfSqFcgX1XVPBpK1dx41FjShstGokTaRV6vUaHy6AyxYNhxJYspo0rclKVBzMLUUI3kN6777H6DvhYxjk2QeJqoDcUAmgBF4wF3+tjFfpYry3So5sY6kVssimW2xHXj/aOceMfYAxECgkLXaG6bHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(45080400002)(54906003)(8936002)(4326008)(508600001)(52536014)(8676002)(7696005)(966005)(83380400001)(5660300002)(38070700005)(86362001)(316002)(110136005)(71200400001)(76116006)(66476007)(66556008)(66446008)(66946007)(64756008)(33656002)(9686003)(122000001)(6506007)(2906002)(26005)(186003)(38100700002)(55236004)(53546011)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yx2c7vimkpU0Lm7oDP3vK1su2giUjMyBoBzF/97Eem89gD8TQ5J7d1R3Rn9B?=
 =?us-ascii?Q?py4OkNhviU4p4GbMKdysPqtEykQ5e1FV1US82r5k9TQiwVDIGx1yhO7DyJu6?=
 =?us-ascii?Q?QghvuPtLXifs4Hthb7GLZ6FKV8k9BwJjTLkIfRL91hiAOPhNcjmOYg2SPd+F?=
 =?us-ascii?Q?r56RwqIhDgLYX95210eqGqpaKjir1wHKUsCchU5F5oWXp1m+s3FdUvlTmlOH?=
 =?us-ascii?Q?Feke7hHph3thjRHfVUlzbNEVjxssyyW8Ky/Y/l4luyUORfqwyNUOF2NvI00W?=
 =?us-ascii?Q?W2INo55t2wTQbxkFPKh2QeJD1Ewb9l/3tixoFdijmN4fnFuviHyyukPOCpPT?=
 =?us-ascii?Q?o+WfT/9CHFYBpSTnnHPD/xOflFYfPdY1QIaUFBMOkT4YcoLg7Bj8taVhlvJU?=
 =?us-ascii?Q?pf+HBAXg3uqI9VA4gmY0eIN4ZoZyJ548tvK1CIAGxVrjVow8hSsNov7/puwj?=
 =?us-ascii?Q?jgSMg+jXgfZG5uGyWtigY/AEcuPjzdcyObxQ87dpPZx9x+tCY0SBqNVtmJAf?=
 =?us-ascii?Q?C4u7PMF8msxHFuc6ZzXKZJK+NPOj0NHRgon7f5RUlYE9dslZb0BD84PLS6Ex?=
 =?us-ascii?Q?CF5X6oKfOxvEpqr1WwPSTjVCJCD9RJnJ9HjefEruc9ZEJPY53z0nnu4XB2sP?=
 =?us-ascii?Q?MH4xjKnad6Td/dpuNPyV/KEJxvNSjqm9ruNjXYMeRnwpuQ7RMoBAlZNAhq4/?=
 =?us-ascii?Q?pzO02MQZdVM5enYxV7alRXzi5bmHrvlnH6E6yZ1LHDv4optVzq7dsZWjNySH?=
 =?us-ascii?Q?pM6aoSUQkSxW6cFoL3qVaaFSpa7Q6DIdTpSLeW2zD/LJQ8RXCDs31ntmq/sH?=
 =?us-ascii?Q?s7MXTWajOhFaO8BtUT1IhoCYVDi/tew4Hl1c+0N7ORiee6bcDmGps2IMDqlt?=
 =?us-ascii?Q?4Tsr71sTVpdGjxYQgFHeioQjDeyQTNAifFDUnVMD48xlWu2It4SDLIS/Li2b?=
 =?us-ascii?Q?0h1nd57yf8jjFK7FjecFyotwgKjBSuLhm2paxXGSIoYaTKp+j0+WUMqjbPw4?=
 =?us-ascii?Q?LNI1JQKJvOGEZNnTjcbS0aeDmDon9t4QLnQvMzytwb6g69jbatCRdWKBExXu?=
 =?us-ascii?Q?mWHNDyj6acGhtEW6/W2G/YdGY5d4FWr2R5d6i5MzVm5Vj/SPAX7Eb1X2pLXs?=
 =?us-ascii?Q?my0ozAHgi4nJvrnWJVPBdCoGCDu9SkXvBXI8fnvLX4MixMHZpR3lK8oWpGEZ?=
 =?us-ascii?Q?u/Vkh12QwIy+MTjdK750FP3NHLRaAD0dQrGeIpfEL2dQYkIRPcioDsvWhvNN?=
 =?us-ascii?Q?ktVQ58vJaOosC6RNHWBZXpd/an1QqKHhE5pZBsY6veeMRXaiS1mRbq2X0swg?=
 =?us-ascii?Q?Yd9aif87iMmB4lplaMgl+l+AnD39CAPS7NPV4ILVs6wyl2hSSktrZNdopvNw?=
 =?us-ascii?Q?wOV7EO2TCM0C3Z+qQU918QMQUtqo5QbrziJDBIuy6JEkYwhdf9Y+ViFjjuwX?=
 =?us-ascii?Q?OXRqvlvE4VWhEe6GOf/Hru+ML6qLUD0XQ/BMdOThroL2R/gWW3qymtNT9wKV?=
 =?us-ascii?Q?g7Irvpba8QFSe0Pctc8YV+VK1f6nk6D8dAikLCppLrQ1rutTgBzapKW4wnSP?=
 =?us-ascii?Q?QgXBuBlHFgfyYVB3AeIYfqeIST8Y20yjoJv+WDQSN5RHs5Yx3aZTcp/h3rtm?=
 =?us-ascii?Q?qgz9yiDBmH9BSd8Zk6/nz3vYgJoYJOOKQeYoYyczpKWil+KuR/rvdiK2lYO+?=
 =?us-ascii?Q?2k/jaiLrQGEGwLk9C6yQHDAHFlFGZZi1P9Dqyg6ummn0HQFs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ef953d-4c4b-4e93-efd7-08da1fd3a75a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 18:05:13.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XOt96e7RgaTDrVbkNOPFzBPW4wtRbBvVGobiXkDsFH8xN41/9L7GDsZCE+tM2hId
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8571
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fabio,
Just responded to the patch posted by you. For i.MX6D I will check with the=
 hardware IP team. As mentioned in the earlier thread we will be passing th=
e entropy delay value via device tree property.



Regards
Varun

> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Saturday, April 16, 2022 8:04 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; open list:HARDWARE
> RANDOM NUMBER GENERATOR CORE <linux-crypto@vger.kernel.org>; Fabio
> Estevam <festevam@denx.de>
> Subject: [EXT] Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay va=
lue
>=20
> Caution: EXT Email
>=20
> Hi Horia and Varun,
>=20
> On Sat, Apr 16, 2022 at 10:54 AM Fabio Estevam <festevam@gmail.com> wrote=
:
> >
> > From: Fabio Estevam <festevam@denx.de>
> >
> > Since commit 358ba762d9f1 ("crypto: caam - enable prediction
> > resistance in HRWNG") the following CAAM errors can be seen on i.MX6SX:
> >
> > caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> > hwrng: no data available
> > caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> > ...
> >
> > This error is due to an incorrect entropy delay for i.MX6SX.
> >
> > Fix it by increasing the minimum entropy delay for i.MX6SX as done in
> > U-Boot:
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> >
> hwork.ozlabs.org%2Fproject%2Fuboot%2Fpatch%2F20220415111049.2565744-
> 1-
> >
> gaurav.jain%40nxp.com%2F&amp;data=3D04%7C01%7CV.Sethi%40nxp.com%7C9
> 6c829
> >
> a14c394eb5e20508da1fb62811%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0
> %7C1%
> >
> 7C637857164474600314%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQI
> >
> joiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DjKZQyH0q
> Z50
> > rZhRV6%2FtOgkacpQZ9pZnwo6dLEkMUARs%3D&amp;reserved=3D0
> >
> > Signed-off-by: Fabio Estevam <festevam@denx.de>
> > ---
> > Change since v1:
> > - Align the fix with U-Boot.
>=20
> Actually, after thinking more about it, I realize that this issue is not =
i.MX6SX
> specific as I have seen reports of the same failures on i.MX6D as well.
>=20
> Would it make sense to fix it like this instead?
>=20
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -516,7 +516,7 @@ struct rng4tst {
>         };
>  #define RTSDCTL_ENT_DLY_SHIFT 16
>  #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT) -
> #define RTSDCTL_ENT_DLY_MIN 3200
> +#define RTSDCTL_ENT_DLY_MIN 12000
>  #define RTSDCTL_ENT_DLY_MAX 12800
>         u32 rtsdctl;            /* seed control register */
>         union {
>=20
> Any drawbacks in using this generic approach?
>=20
> Please advise.
