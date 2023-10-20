Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C69CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 08:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376494AbjJTIuC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 04:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376497AbjJTIuB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 04:50:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818A4D53
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1697791798; x=1729327798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rVc/kdpqEmkQbZCTf1QnB5cMIFR7RkdpKc3Zx2BU23s=;
  b=OzU5L1CKFu+e+TyeAOKCfxNR3do3aF4MSsFk1iw+NDm9qVE1T55Yc7TR
   bA2uJxLeAzL1qyubligueqQn1i3FPJBXtrTmT03W/JswiMwHRAwWk5g3q
   jJKh0qIxfcThpcnxJGn4JvOmeyuQeMV/QsH3TQ7ILQj5ovTcxYfM6zsiO
   kgZAAY0aypdtJKx3H9zW5SoCyzZQ5aM0iYT+2iIImx1c1GfGvaT8icag8
   njoDl3Tv2nCHb1vbJsDiI4A9O3C6Co67eZheJUsPazE+SpzwBG79ldIJ6
   MgXu2B0ye5/gvl6VR7QcZuuTGgyjoijqIE9WGNjnk4Lt94WbBEF2LT7VV
   g==;
X-CSE-ConnectionGUID: hmgTYCI2RsOiHlIAahapgg==
X-CSE-MsgGUID: cdwtxnjlRYuD7u+pzt81Hg==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="10872060"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2023 01:49:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 20 Oct 2023 01:49:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.250)
 by email.microchip.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 20 Oct 2023 01:49:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp18dgPjW+xbPSNkCnimNNRvFhMB6R2WxN2t3SpimRYc0G54F+LR7TUqlf1ICCEcenqFZ3Uu3PkjpUwjD4A2xDoC9ssE6ZIZYxQJGawYgCPXSfUE4vdXrPosq0+93f38vqYiH2WHPVdtVYFrn2ep0yLbbinQycdWamYUhggfVjZxOVOcVDc/CF0P7/WcNhVILfp6m+H7i2sryWThafQ0TB7BlprmBku4NEXItWVn7tQuxfXPSbwQGgmC3vUlpHjaZiESOTWLCYG0DqDmfr2eXPD4LSV4GFx5/+WWhdMJChH619V0Q6eVEKJgGeWPcqWMt7ZwOf4E/ECoS/kNxCJOrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVc/kdpqEmkQbZCTf1QnB5cMIFR7RkdpKc3Zx2BU23s=;
 b=fTlGLt5Httskz0pRGi5UStYpvHwOAlhly1ycKBQScXr9aJKntLrGSoyvO8+GcGRtPg5lIk8mdGnPhHu+TWlEY3XfV5Xuor5Qx9dwHRDOMV5+6kmvb/NBNZgs7WI6wQSX+JJDhjOPD+9viOT/nD5UJ7ytz2YiaKu0GM6HAbgey3wyxFqLbHO0ksENpmrO5cXb+zUBo7kyz2eZJOKAXqF0VV9n/6Tx9jVtGJyE5UR+oWzmY6sv/HVG7aIUI/xE554hlgieTFcOpv8/VJOZT0QTw6xC/eCYS7DzczcV0F2ANEKfJRIdvXz0u35dqlefLiASTVOtP703kMBLHx1tm0Vapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVc/kdpqEmkQbZCTf1QnB5cMIFR7RkdpKc3Zx2BU23s=;
 b=UFcIVTW+LU+2mToN6QLNcdR6zU0dczABilozTOb+b1v9A+gpD5X59Sn49/cGWzIxosylwFouJCM/vR6cV6TsRfxSRwvrB+ynvbTN2d5/6eoRbJoxMJa50ChPuvLabP7Rz7oDYGEYFW3wDsADHTtXsk6TxCnH8fHd5ipiw1JmjKk=
Received: from DM6PR11MB4185.namprd11.prod.outlook.com (2603:10b6:5:195::29)
 by DM3PR11MB8733.namprd11.prod.outlook.com (2603:10b6:0:40::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Fri, 20 Oct 2023 08:49:13 +0000
Received: from DM6PR11MB4185.namprd11.prod.outlook.com
 ([fe80::adb4:769c:92c4:ad61]) by DM6PR11MB4185.namprd11.prod.outlook.com
 ([fe80::adb4:769c:92c4:ad61%7]) with mapi id 15.20.6886.034; Fri, 20 Oct 2023
 08:49:13 +0000
From:   <Hari.PrasathGE@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
        <linux-crypto@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <Nicolas.Ferre@microchip.com>, <Ryan.Wanner@microchip.com>
Subject: Re: [PATCH 08/42] crypto: atmel-aes - Convert to platform remove
 callback returning void
Thread-Topic: [PATCH 08/42] crypto: atmel-aes - Convert to platform remove
 callback returning void
Thread-Index: AQHaAysZR5iZmS6Ve0q6M0CYpv4Ki7BSXkCA
Date:   Fri, 20 Oct 2023 08:49:13 +0000
Message-ID: <2fe16cff-b8cd-4216-96be-6bc811370d52@microchip.com>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-52-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20231020075521.2121571-52-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4185:EE_|DM3PR11MB8733:EE_
x-ms-office365-filtering-correlation-id: 96128057-fdf6-4ac0-43a3-08dbd1496f82
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GVDims3W6Fczyn5IWSjwR+228Ee2/vPtHqDIF0+ZjdVnavMxfDZw9jtIH3ldqtbiYalp3PDBy1aA1g9/pwTQiw9WBHQtE2I5t08HpNedRryiriWPSgjcQRNdN2abP8kyukOp7J6NnI+eUGS1twGQ732M+KeIvUvKoj/YQDtFFJB3KJ3gT+qpoaGY5DwY4QsqTJap1qhHp2I3CBwa96sK02nbl3lkXdUldSkUyAhSeqRjnNTtbicv35NzAMmmNky+mfdO7peRDrC6vAH2Vgz4hbe2dlgE6PJH8ppUZpLL6d8FbSSO1ojpF6Lx7an0JSqXXqbAElSygIH0qeJWa0iqx3AecsXIyqE42xz3pif4z30ybSAF4xK+c7wQIofNzeRpR8gjsr1BdhyMs2JXfOgHO7VI0/MXtGF5cE2CZVRaaUKjJy8dIhXF9pUi2Ub/b0ns063BFP9WByLni7y/f1xOzrp+LzRJGpwSn5Kiuw36ZzIZRkOdJ+VnM4qG5ixrvuIorOQmjUMwBMS16jlBKVdaJgApGrScJqKa+TNyV20NkvswP/hEcrXSgU9e7VZKOVNaM2vsmkCqhQvkz/bZQNGWIPa7p3N8DAY8+z5opA2PWCOa9K1JnOhYcRfyVG177EyyUhDHeYZzuoxdSyK0EFuApw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4185.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(366004)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(76116006)(66446008)(91956017)(66476007)(66946007)(110136005)(66556008)(54906003)(316002)(64756008)(478600001)(966005)(31686004)(6486002)(41300700001)(5660300002)(53546011)(8936002)(8676002)(4326008)(38070700009)(86362001)(31696002)(71200400001)(83380400001)(107886003)(36756003)(2906002)(6506007)(6512007)(38100700002)(122000001)(2616005)(66574015)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R08vS0pDK3dzMmZJU1JRclJrWHNJM0s5c3plNitKTTlmNTNoZ2kyNE5xb1VS?=
 =?utf-8?B?NmhTVkJDV2pwaFRJZkJ5RTNMS3graEpLK2JOY0lMZC9vTjNLL2N5dlFBaXE0?=
 =?utf-8?B?NXNNbVBCeExIUjJlM1JQeHdXNHJ6MmMxWUNCMVJSVmNWeHVnOVhNTFp0OGRx?=
 =?utf-8?B?dzR4dmZGSEZWaWh3WE9Oa3hyNGo4TzhKY2xvc0pxUUY4dFpsSS9XenZCVU5n?=
 =?utf-8?B?R0VKZUh0aEtmRkpreldYSEZHRjJIK3JCd1k0SGZ5L2cxQ2Z4SWdGK2lGNS9l?=
 =?utf-8?B?K0oyLzNKV2h5NlFBQjg1cHZ2M2VoWU1QaTZUYWkwZGU3V1NWemRpeDYvTmVO?=
 =?utf-8?B?OWNlenF2aVNhY0grNEJoU08vQ1NGTlVUWDFVYlgrTFplV044WVgxdjdNdUVr?=
 =?utf-8?B?ODl5S2RPSTRXVWt5cXRETjMxU1d0Y3czK2l3L2dITm9KM0kwMVJqZUNsRUFU?=
 =?utf-8?B?TktsNCtrMEp3QTZHUTVjVDlHZ0laRUxGSEJ5QlJkQWJKWXk0Zm9wZmFZSnor?=
 =?utf-8?B?N2FXZnRzMm5jMlFLaGZaeVN4aGdON3JxWjRMS3JpeXhMSktkbk1iWmdSR0ZG?=
 =?utf-8?B?RVR4UW9Lam5aK3VxbFZ4SWVNcnBobmcwclhtbUZNQkt4YzZxcm1oT0kxQ0tV?=
 =?utf-8?B?bXhCTUl3Rkk5V0hDeWlvV0hvcFEyT2wra1VWeXVnT05yTWplemVZQ2ZFTUc5?=
 =?utf-8?B?VStsczJzbDQ2Q1RLRmwyZmEyWVo4ZndFNEtpa0xPell4VTVFUGVuZjBQMzdQ?=
 =?utf-8?B?TDZaaUxSWktPTTFqeFJneGdCZXBaelJZTXlxUFF2cnAzQzVjL09qc24vdFFE?=
 =?utf-8?B?WlNkTEVCMGZNSTNLY0tmZW9sbHYydXhpbmlubUM4d0JDSkRtNmNPNThlRzB3?=
 =?utf-8?B?ZWhNQURIRktxMHB0OXU3UDAvL2VjMktDNG52UHIxSWxnMmVhbFRkZlVibFhM?=
 =?utf-8?B?K2NibnUzT2NIcTJFektoK01ZQk1DYzZaWTM0OVJnczdIVys4VGN1VFovempT?=
 =?utf-8?B?TW1GME1kOFdYc08xTHMwUU43STAxYXFVanVYK3pvOXBrYmxBNENLdXNldG9Q?=
 =?utf-8?B?QmhVWVhwNGlqbVJYZ0pMQWkybnRZQnJLL0dVSnVrOVB1QkY0USsxcWxSQzVn?=
 =?utf-8?B?UU94WmdMUGFlSFpTWXZIZGduMzFTaTRYTlg3dWJoNDBOU0pBMHllV3Exd1JO?=
 =?utf-8?B?T3dkQnRQeVJjT3RWUmxxNWlUdUNaTXh2QWdZNzlieG1NdFFtaU9abTFOUlFy?=
 =?utf-8?B?dnBnZG9OS2RmdmhIVWQ0eGp4aWVOSjBuZU0xV0krOWZDV2p4ZjBxMkRhR3lo?=
 =?utf-8?B?Q1ZGYzZPa0I4T0FZZlRwNHR4a2c4SXRNcXZJRXBTTWtkdjMyYVl0d3MyZ2xi?=
 =?utf-8?B?Vng5YjA3RUM5aDhIVmcyYWZpQVA2NGpqNStWUkZvZmlkUGJIckZQUTR0Ti9x?=
 =?utf-8?B?cTBhalVMQmsraUN2clJabGdrR3EydVVOMitJSUFFUHRFVTNmRkFZNGRTSjlN?=
 =?utf-8?B?QURTUEx1OFF6RjVFM05jZ1ZwNTJwVmhaL0ZDcGs4djdHUDRKSnBmazBOVTc4?=
 =?utf-8?B?bHlSL21BV3BydElFbzdNM3lhd3AzOGRoWUhRZlhEYnd4QmtyNG9MZytWYlI0?=
 =?utf-8?B?TmJ4SHJYOU4rWC9MWVhHTitCSk9EM1NqLzJVMjh2OUYrWXpZTGlsUlFZS0xF?=
 =?utf-8?B?cnhIcEFramNuS2lrWXMrekVIV3I4d3VTbWIyZ3p0d2FoZWJlUHp0MmR4OFI4?=
 =?utf-8?B?SlZBV0tYQUNHc0liQkNtYmRNMmtUa2IxNENvdkM2WUNyUnVGQXhFR0wwMG9W?=
 =?utf-8?B?ME9hWHUvRWM1YmpOSnUySDNpN3Fqcmp2QzBMaUZEYnpRNkdObTk1QUZZVFpZ?=
 =?utf-8?B?U2pMRkFneWIzeDc4a2hOeHQrZjVFNHdCSCtQUHF3NnRyRHRPSkp4V0Rva1ZD?=
 =?utf-8?B?cm56VTc0bDlKbEk0L0I3Um1iNHNCSnRSQTM5Z3JyanQ4aGlaSjc4RUhyeTZp?=
 =?utf-8?B?S2x4bzg2eFZ5RmNmWTFkNGZ1aHo2QzZVaGVkWW9pMUZLdStCaDVIZEo1MWU3?=
 =?utf-8?B?VkhFK3crbG5FYjJQUnROY1JmYlpvMHpaa09JL0t2TnZsdFllT1pvWDhGNk9Q?=
 =?utf-8?B?eDBuZ1BjdDdJbEFJQlBBdDFmdmVXeVFZMDUxU3hHa1M2L3dNZW8zdHU0S2RS?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EC7E721F6F996439A50290449B18CC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4185.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96128057-fdf6-4ac0-43a3-08dbd1496f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 08:49:13.6131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQ6QhlLabvlmRoB1C5gHiEbRc+DZwRULGNHJvGn2/wq+2VmlCOYqnjy+cZSkmAuxskKwO1mLLCaXICxaVpryHFexZAJZa1BJxkbc3ZLSQiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8733
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDIwLzEwLzIzIDE6MjUgcG0sIFV3ZSBLbGVpbmUtS8O2bmlnIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFRoZSAucmVtb3ZlKCkgY2FsbGJh
Y2sgZm9yIGEgcGxhdGZvcm0gZHJpdmVyIHJldHVybnMgYW4gaW50IHdoaWNoIG1ha2VzDQo+IG1h
bnkgZHJpdmVyIGF1dGhvcnMgd3JvbmdseSBhc3N1bWUgaXQncyBwb3NzaWJsZSB0byBkbyBlcnJv
ciBoYW5kbGluZyBieQ0KPiByZXR1cm5pbmcgYW4gZXJyb3IgY29kZS4gSG93ZXZlciB0aGUgdmFs
dWUgcmV0dXJuZWQgaXMgaWdub3JlZCAoYXBhcnQNCj4gZnJvbSBlbWl0dGluZyBhIHdhcm5pbmcp
IGFuZCB0aGlzIHR5cGljYWxseSByZXN1bHRzIGluIHJlc291cmNlIGxlYWtzLg0KPiANCj4gVG8g
aW1wcm92ZSBoZXJlIHRoZXJlIGlzIGEgcXVlc3QgdG8gbWFrZSB0aGUgcmVtb3ZlIGNhbGxiYWNr
IHJldHVybg0KPiB2b2lkLiBJbiB0aGUgZmlyc3Qgc3RlcCBvZiB0aGlzIHF1ZXN0IGFsbCBkcml2
ZXJzIGFyZSBjb252ZXJ0ZWQgdG8NCj4gLnJlbW92ZV9uZXcoKSwgd2hpY2ggYWxyZWFkeSByZXR1
cm5zIHZvaWQuIEV2ZW50dWFsbHkgYWZ0ZXIgYWxsIGRyaXZlcnMNCj4gYXJlIGNvbnZlcnRlZCwg
LnJlbW92ZV9uZXcoKSB3aWxsIGJlIHJlbmFtZWQgdG8gLnJlbW92ZSgpLg0KPiANCj4gVHJpdmlh
bGx5IGNvbnZlcnQgdGhpcyBkcml2ZXIgZnJvbSBhbHdheXMgcmV0dXJuaW5nIHplcm8gaW4gdGhl
IHJlbW92ZQ0KPiBjYWxsYmFjayB0byB0aGUgdm9pZCByZXR1cm5pbmcgdmFyaWFudC4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0
cm9uaXguZGU+DQoNClRoaXMgYW5kIHRoZSB0d28gY29uc2VjdXRpdmUgQXRtZWwvTWljcm9jaGlw
IHNwZWNpZmljIHBhdGNoZXMgbG9va3MgZ29vZCANCnRvIG1lLg0KDQpSZXZpZXdlZC1ieTogSGFy
aSBQcmFzYXRoIEd1anVsYW4gRWxhbmdvIDxoYXJpLnByYXNhdGhnZUBtaWNyb2NoaXAuY29tPg0K
DQo+IC0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jIHwgNiArKy0tLS0NCj4gICAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jIGIvZHJpdmVycy9jcnlwdG8vYXRt
ZWwtYWVzLmMNCj4gaW5kZXggNTViNWY1NzdiMDFjLi5kMWQ5M2U4OTc4OTIgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2F0
bWVsLWFlcy5jDQo+IEBAIC0yNjQ4LDcgKzI2NDgsNyBAQCBzdGF0aWMgaW50IGF0bWVsX2Flc19w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgICAgICAgICByZXR1cm4gZXJy
Ow0KPiAgIH0NCj4gDQo+IC1zdGF0aWMgaW50IGF0bWVsX2Flc19yZW1vdmUoc3RydWN0IHBsYXRm
b3JtX2RldmljZSAqcGRldikNCj4gK3N0YXRpYyB2b2lkIGF0bWVsX2Flc19yZW1vdmUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICB7DQo+ICAgICAgICAgIHN0cnVjdCBhdG1lbF9h
ZXNfZGV2ICphZXNfZGQ7DQo+IA0KPiBAQCAtMjY2NywxMyArMjY2NywxMSBAQCBzdGF0aWMgaW50
IGF0bWVsX2Flc19yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgICAg
ICAgYXRtZWxfYWVzX2J1ZmZfY2xlYW51cChhZXNfZGQpOw0KPiANCj4gICAgICAgICAgY2xrX3Vu
cHJlcGFyZShhZXNfZGQtPmljbGspOw0KPiAtDQo+IC0gICAgICAgcmV0dXJuIDA7DQo+ICAgfQ0K
PiANCj4gICBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZlciBhdG1lbF9hZXNfZHJpdmVyID0g
ew0KPiAgICAgICAgICAucHJvYmUgICAgICAgICAgPSBhdG1lbF9hZXNfcHJvYmUsDQo+IC0gICAg
ICAgLnJlbW92ZSAgICAgICAgID0gYXRtZWxfYWVzX3JlbW92ZSwNCj4gKyAgICAgICAucmVtb3Zl
X25ldyAgICAgPSBhdG1lbF9hZXNfcmVtb3ZlLA0KPiAgICAgICAgICAuZHJpdmVyICAgICAgICAg
PSB7DQo+ICAgICAgICAgICAgICAgICAgLm5hbWUgICA9ICJhdG1lbF9hZXMiLA0KPiAgICAgICAg
ICAgICAgICAgIC5vZl9tYXRjaF90YWJsZSA9IGF0bWVsX2Flc19kdF9pZHMsDQo+IC0tDQo+IDIu
NDIuMA0KPiANCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fDQo+IGxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBsaXN0DQo+IGxpbnV4LWFybS1rZXJu
ZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJuZWwNCg==
