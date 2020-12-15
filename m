Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06493C2BBD4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4E622D0A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgLPABc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:32 -0500
Received: from mail-eopbgr660084.outbound.protection.outlook.com ([40.107.66.84]:30872
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbgLOXcC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:32:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c52zMHA79Au728Ji9aJU33iqQAUnw1vb+e0RZ67pmBh+Pr7rNupFLj3kN1xki8p1ps2fPkSQCcB+toWe2eGZ+RPN0Rh8/b4KdOgH93/IPmycDWmw8cO3AZsAcv/gggd9wqxM2YUXEscDH7+KV/Iz7IUZ1bMaseQIRcNpeAjVqRKzHTrHfvPUjekxBtpRNtjaw2h90cQXzMFMxZFIZ5zbkJuNYrrj6/ysj8dREH+msESR8Ad7pCiR4P07rGCjSkIQr3TxuYcs6B3hnWWHapKDV/i3RpKxsld0SzqL6Bwe3TYdrgTu4zEeL6WDk0QW89ppJpGpPIOVrAHBCIAEF9UpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IZv1hD0gQnJRhaycn6n1+ZOTbRrX7s8yozcob3GdU8=;
 b=UYZu7WzYxORSxK8wVy0QxeL4at0XNl56y6OoHK6XI9j+lLsvy5fh8kfPXo9t0W826fmkCcwvbnVsjRazvAkuYbgRgBeqOliXiBzIv+pvebU4Mn+4y0itmXDwvRrVy5FWGRIQvsWfRdEcb7mkBU5LSvxclueN1rJalOrevY/INVaICFB2fgKo0HEiHI2rXygEgVJBB2PEy81+zkdTc3Q50hEAqeEoUMaQ8O42Xblx/Pdon7zxeBUjE53F7YnFuQaNp6QgtgMuci58KH/hcHMSKyzx0yMdYTwvun2cfwMQBkF2g9Hw+aLW2WrOdzLvte5CeO9nwqhCd1swXNmWpQ/4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IZv1hD0gQnJRhaycn6n1+ZOTbRrX7s8yozcob3GdU8=;
 b=T0mkK3AqyLbCXgEuXrAIIDRv1Z18iBxRzYlTI73nA+z4JjfTn6DOB2MJhc/FqO57n6YoQ7x35ZJzdEun4GfjzJCT+PW8tVSbzkWbychDv8n2vrZuWDQwWIp2x9VkQ9VN5GQ7ZJqpMeGOYtOAIv6M215Pu5XXyHyZ3/7f2koZnh8=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0958.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 23:31:19 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::dd1e:eba1:8e76:470b]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::dd1e:eba1:8e76:470b%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 23:31:19 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "aymen.sghaier@nxp.com" <aymen.sghaier@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: iMX6D CAAM RNG problems in v5.10.1
Thread-Topic: iMX6D CAAM RNG problems in v5.10.1
Thread-Index: AQHW0zpjFR0LJiIzBUi6UNkHbuSSeA==
Date:   Tue, 15 Dec 2020 23:31:19 +0000
Message-ID: <00b1daa3cbd4b9eada873e5ef95f89fd2e5cee87.camel@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-14.el8) 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9df15258-1938-4cd0-8dc8-08d8a1518685
x-ms-traffictypediagnostic: YTXPR0101MB0958:
x-microsoft-antispam-prvs: <YTXPR0101MB09586B37788E345F5F5D481FECC60@YTXPR0101MB0958.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: btCE0yN56DoNiIerMum1PIH95sa/jLeMbuH+TvXn+5NQtLNRb3pEp0TVPzVf8vihBX8dGLzuwnfn/IBBKniBOY65odX5amht4RVlokbpzsubHnvT6nx+fpOrgHNPxFFcFTHsgf6UGnhtZBI64kj41lSnlKRcYdPpcE1uLW9Kb48GoNrSpWYxkdluFQLvohTXM4MOUVi1TvckchQ9NYP7Fso1xIp3sv8P420qJZlU5GBVJmnJ/cdMF1GgOcPdjPN8r5hCx+5uV7BMejaFvbG4B63GmMyn/o7P0xFlUZ+PIKWsf9XfZLobRgqmgnaCTKpcIDfoc9wyWWPcQ+WJGMDWnAO3l4iXApI68QWTxmpIfsNjDxweEbCFkf5VgjKDQuQWhJhjxkmswsKErYAHYpoYcyuRNWLn8KmyRAlOqOsG9SFXcMQ+UkbAE9/RVWoeleZij3hCvKJW+2n4/Pq2DOhClE2r0JzWiSN/hhlJEBZFzWi+owhoXX6ZTA9uF+6upgN0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(136003)(396003)(366004)(346002)(376002)(110136005)(6486002)(66446008)(8936002)(2906002)(64756008)(316002)(66476007)(83380400001)(71200400001)(8676002)(86362001)(478600001)(2616005)(186003)(6512007)(6506007)(15974865002)(26005)(4326008)(36756003)(66556008)(76116006)(44832011)(66946007)(5660300002)(99106002)(32563001)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cUl6eXZZdGJzbXczQWZIdGlVQTFGNU1meEZWdElUSU5ncWY2VHJGcHEwTEEx?=
 =?utf-8?B?aDVDY2lUWHN5NTFWNHJ2SGdrcHE2S1JUNHAyc0JhN0U3V0pHdk1HV09VRFAz?=
 =?utf-8?B?YmhBOHRQUm5RV0NFVEt3MUozblo5RnIrU3Y4S3RXeU5LdWU0bU1KVFVya051?=
 =?utf-8?B?Q0hyU0I0Yk5tSUVaUjlqS21wajRQM2ZLZzBBVTBIODM2MHFMRi8yMlN3ZzM2?=
 =?utf-8?B?dVlFcjRMRGNMd2pXY0RWS05LZGxxQUJnL1NQdjN0WkQ2TGpFSG9mTU5wZDlz?=
 =?utf-8?B?V2xGazdrZWJzUkhXeTVyZHRqaXlJVjRkOWt2aDdSTzUvTlovSHY2Y3B0TS9S?=
 =?utf-8?B?OHFhVTY1ckRYYzdieDFCSklDUUQyYjhCdnovS3ZkaGxxdk1Dd3hET2ZWZ28x?=
 =?utf-8?B?UGw1akZodFQvdEFGVFIwUUZzS29HK2pTM0U4S1BZaXRQeDNXbXlTdjA3OWJR?=
 =?utf-8?B?TWNtTnh2OFE3MHhpRzBINkZmVHp1bHpIbEJYS213aWVOOWtFRmhKRTZralpT?=
 =?utf-8?B?c1h2WVF5V1FmNHFUUTlSYUJ6T3RlZHVUSkhweXF1dzlpZStvbHo5R1dTZUZ5?=
 =?utf-8?B?ZmlWUElPMi9UeFF4SHgvNUFBU2NLSHMxVXB6OGtHMnBBc1oxTVhkRHFDNnFy?=
 =?utf-8?B?V1gvdCtsbGpQOUZEZ3BEb09lVUxHTmdZSTdsNURPUmpweEZVTldrQVU3L1Ja?=
 =?utf-8?B?Mi9yN2d4WmtJZVM5MHkrWkloOXdKOHpxcWh1QTB0WFlYSGNnbG5NeFBOWGg5?=
 =?utf-8?B?anNaTVcrR0JNdWQ1UE55aVJrUHRONnJiU21hcGpZTzVCR2JkOCtpK0t1bDhr?=
 =?utf-8?B?Yy9yQWR0bnptbnNGMGlQd0QxWm5EYWNHY1BhZE5RbXUrUnFoUE9jaDVBWDFh?=
 =?utf-8?B?VWhObXI0VlMzajNNK1c0RDEvYkxPUUtJeE9ncW5nOFVmQ0dQL3ZmbG9rMnAr?=
 =?utf-8?B?SC9UbU16SDRaSDNUaFl0cDdqNW5oT2RlcFR0YjJSV1ZNQm9JdkJPbU9YQW81?=
 =?utf-8?B?Mkh1OXRPT21Qb1JDUFRTb2lFbHk0RmUyb3ZvcC8vN29mM24zOUNRMEk0blJw?=
 =?utf-8?B?TkdVd2IyZEpSRUZUSHJRa0E2NGdhQmVnaW9MZ3o4d0p5SVlzeWs0MUR0am1w?=
 =?utf-8?B?NE42Q09odHFTNzNvRkkyQW41aDcrT3RRTUJHM3dVcWo4QUViaGNFR1BOUjgy?=
 =?utf-8?B?SGpRVHNGazNWUkJZd3lYM0FnOEFrQlo5WUVCUUZQT01ZZlhWTWRKRmNvcDNQ?=
 =?utf-8?B?bi9sSjUrTitPNHE1STkyRXBsTUt5a1JDeWNFbzFVT2Z3U3RRbm91M3o5S1Vi?=
 =?utf-8?Q?iDIoIVXIcz2Ei6CmLjoL9vDbQwY59J5yIc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <55781FB8DD808C4A911205DA5E290D91@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df15258-1938-4cd0-8dc8-08d8a1518685
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 23:31:19.3178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9IRKF//ADKH6K6XnLROVL1BlBBD7KF1ainqFOSZBDvs6hT/yL02ceOyE6K7wAyjicXaGl/FCDFNRncPn12aUwKfIgxvVjxYm6b+yuzGOrwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0958
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8sDQoNCldlIGhhdmUgYW4gaU1YNkQtYmFzZWQgYm9hcmQgd2hpY2ggd2FzIHByZXZpb3Vz
bHkgdXNpbmcgNS40Lngga2VybmVscy4NCkkgaGF2ZSByZWNlbnRseSBzdGFydGVkIHRlc3Rpbmcg
djUuMTAuMSBvbiB0aGlzIGJvYXJkIGFuZCBhbSBydW5uaW5nDQppbnRvIGFuIGlzc3VlIHdpdGgg
dGhlIENBQU0gUk5HLiBUaGUgZG1lc2cgaXMgZ2V0dGluZyBvdXRwdXQgbGlrZSB0aGlzDQphbmQg
YWxsIHJlYWRzIGZyb20gL2Rldi9od3JuZyBhcmUgZmFpbGluZyB3aXRoIEVJTlZBTDoNCg0KWyAg
IDE3LjM2ODM2OF0gY2FhbV9qciAyMTAxMDAwLmpyOiAyMDAwMDI1YjogQ0NCOiBkZXNjIGlkeCAy
OiBSTkc6DQpIYXJkd2FyZSBlcnJvcg0KWyAgIDE3LjM3NTcyMV0gaHdybmc6IG5vIGRhdGEgYXZh
aWxhYmxlDQpbICAgMjMuMjAwMjU1XSBjYWFtX2pyIDIxMDEwMDAuanI6IDIwMDAzYzViOiBDQ0I6
IGRlc2MgaWR4IDYwOiBSTkc6DQpIYXJkd2FyZSBlcnJvcg0KWyAgIDIzLjIxNTUwOF0gY2FhbV9q
ciAyMTAxMDAwLmpyOiAyMDAwM2M1YjogQ0NCOiBkZXNjIGlkeCA2MDogUk5HOg0KSGFyZHdhcmUg
ZXJyb3INClsgICAyMy4yMjkyNDldIGNhYW1fanIgMjEwMTAwMC5qcjogMjAwMDNjNWI6IENDQjog
ZGVzYyBpZHggNjA6IFJORzoNCkhhcmR3YXJlIGVycm9yDQpbICAgMjMuMjQzNDE1XSBjYWFtX2py
IDIxMDEwMDAuanI6IDIwMDAzYzViOiBDQ0I6IGRlc2MgaWR4IDYwOiBSTkc6DQpIYXJkd2FyZSBl
cnJvcg0KWyAgIDIzLjI1NzgwOV0gY2FhbV9qciAyMTAxMDAwLmpyOiAyMDAwM2M1YjogQ0NCOiBk
ZXNjIGlkeCA2MDogUk5HOg0KSGFyZHdhcmUgZXJyb3INClsgICAyMy4yNzIxMDldIGNhYW1fanIg
MjEwMTAwMC5qcjogMjAwMDNjNWI6IENDQjogZGVzYyBpZHggNjA6IFJORzoNCkhhcmR3YXJlIGVy
cm9yDQoNCldlIGFyZSBub3QgdXNpbmcgc2VjdXJlIGJvb3QgcHJlc2VudGx5LCBpZiB0aGF0IG1h
dHRlcnMuIE9uIDUuNCwgbm8NCnN1Y2ggaXNzdWVzIGFuZCAvZGV2L2h3cm5nIHNlZW1zIHRvIHdv
cmsgZmluZS4NCg0KSSBzZWUgdGhlcmUgYXJlIHNvbWUgQ0FBTSBSTkcgY2hhbmdlcyBiZXR3ZWVu
IDUuNCBhbmQgNS4xMCBidXQgbm90IHN1cmUNCndoaWNoIG1pZ2h0IGJlIHRoZSBjYXVzZT8NCg0K
VGhlIENBQU0gaW5pdGlhbGl6YXRpb24gb3V0cHV0IG9uIGJvb3QgKHNhbWUgb24gd29ya2luZyA1
LjQgYW5kIG5vbi0NCndvcmtpbmcgNS4xMC4xIGtlcm5lbHMpOg0KDQpbICAgMTYuOTM0MjUzXSBj
YWFtIDIxMDAwMDAuY3J5cHRvOiBFbnRyb3B5IGRlbGF5ID0gMzIwMA0KWyAgIDE3LjAwMDE0Nl0g
Y2FhbSAyMTAwMDAwLmNyeXB0bzogSW5zdGFudGlhdGVkIFJORzQgU0gwDQpbICAgMTcuMDYwOTEx
XSBjYWFtIDIxMDAwMDAuY3J5cHRvOiBJbnN0YW50aWF0ZWQgUk5HNCBTSDENClsgICAxNy4wNjc4
OTFdIGNhYW0gMjEwMDAwMC5jcnlwdG86IGRldmljZSBJRCA9IDB4MGExNjAxMDAwMDAwMDAwMCAo
RXJhDQo0KQ0KWyAgIDE3LjA4MDI4OV0gY2FhbSAyMTAwMDAwLmNyeXB0bzogam9iIHJpbmdzID0g
MiwgcWkgPSAwDQpbICAgMTcuMTEzNDk4XSBjYWFtIGFsZ29yaXRobXMgcmVnaXN0ZXJlZCBpbiAv
cHJvYy9jcnlwdG8NClsgICAxNy4xMjAwOTldIGNhYW0gMjEwMDAwMC5jcnlwdG86IHJlZ2lzdGVy
aW5nIHJuZy1jYWFtDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNp
Z25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
