Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F03CC83000
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 12:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B34206A1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 12:26:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="OIGlmCk/";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="OIGlmCk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgD1M0u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:26:50 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:19982
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726361AbgD1M0u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 08:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxhR2gOD+0fMy60YrtKy1bzzx4wBCyrNW926XIc/zC4=;
 b=OIGlmCk/Gh9dJH2Y19BkNL0mWCByQ0v5h+s30yu4/QMRWz+Pk/gDcj5yC0CoVfhXBU7BOU9o1kPl/5ZYmBbWIyQAO+Jg/VNLL0vUT/h3ZRdqtJ7n8EF0i0qOQxyl1rG4t/6DGlxb8Q8df61E/NPzqVnPBsv7PVWCut+BhBJvXFA=
Received: from DB6PR0601CA0029.eurprd06.prod.outlook.com (2603:10a6:4:17::15)
 by DBBPR08MB4444.eurprd08.prod.outlook.com (2603:10a6:10:c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 12:26:41 +0000
Received: from DB5EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:17:cafe::a6) by DB6PR0601CA0029.outlook.office365.com
 (2603:10a6:4:17::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Tue, 28 Apr 2020 12:26:41 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT056.mail.protection.outlook.com (10.152.21.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Tue, 28 Apr 2020 12:26:39 +0000
Received: ("Tessian outbound fb9de21a7e90:v54"); Tue, 28 Apr 2020 12:26:39 +0000
X-CR-MTA-TID: 64aa7808
Received: from f1150cc13839.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 435307EB-5FFE-4419-8BE2-B95A2541FEAE.1;
        Tue, 28 Apr 2020 12:26:34 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f1150cc13839.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 28 Apr 2020 12:26:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAQGT3gvtqTQWd1EulYCThpfD8w3+QFidxS0tX1TAMGY8p/yM+BwSgFrRlcA1YgD+MZ0tsSkm+EhyIRxy23eJSbCSB7xMiVrBaYFg2xObUfIDzKaUSS0B8XqzLVDurvvGVCJwxWb4EiuEZj4qv7iAnET2VoR2leUdVM1a/46pbEAn4Fln0Qys0czBL5+QZQo08jvOBVAgrJooS+0Q1ddU8ZFchW4wuT/aKRPhuR6ovJdphWOofNlbMJ8DGrx79mOJLDm4/7+IvgxtwrCIy23WEYN9SAVrmXEipAAHAg+whvEOo1KxSGI20gAeN2BEB3ZXfAadxZLBlYMMrq8Qv8LDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxhR2gOD+0fMy60YrtKy1bzzx4wBCyrNW926XIc/zC4=;
 b=mhy6XAxiw8pRUxJ3JmpTDR5XJtG1kZ+QBH8BdvdqnmT9PcLvVlMWgB9ApIzklPHjm8jcFof16uWE7lWGiFaLbHPJd96RBKe6HKjOnjlfMKke8xK44jGM9pm/UVZbC/UK3g49TptlKxhJIFKVjcxutCRxUt8DqxybVm61iO+5mWdfGqYeakn1sSkHmvygBgsLn+zkJaOyrtcdvQNaYPr9h5Ou+s0XqxcGxKAo23+DXbrCM7OA5+sQpbgopxBdOtpBnKk0omTT5YbVp8foOfRZqa7jaQizGFHersO2h2zcfB9b0gHvnO4Ccw4ZcFCUXVZABHhQCinQCzZOEZQ8NrxdSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxhR2gOD+0fMy60YrtKy1bzzx4wBCyrNW926XIc/zC4=;
 b=OIGlmCk/Gh9dJH2Y19BkNL0mWCByQ0v5h+s30yu4/QMRWz+Pk/gDcj5yC0CoVfhXBU7BOU9o1kPl/5ZYmBbWIyQAO+Jg/VNLL0vUT/h3ZRdqtJ7n8EF0i0qOQxyl1rG4t/6DGlxb8Q8df61E/NPzqVnPBsv7PVWCut+BhBJvXFA=
Received: from DB7PR08MB3003.eurprd08.prod.outlook.com (2603:10a6:5:1b::14) by
 DB7PR08MB3354.eurprd08.prod.outlook.com (2603:10a6:5:1d::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Tue, 28 Apr 2020 12:26:32 +0000
Received: from DB7PR08MB3003.eurprd08.prod.outlook.com
 ([fe80::2cdc:6170:b6f:5853]) by DB7PR08MB3003.eurprd08.prod.outlook.com
 ([fe80::2cdc:6170:b6f:5853%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 12:26:32 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Topic: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Index: AQHWHIgZN7YKol1Tq02g1xaDTWU+daiNEe0AgAFkcMA=
Date:   Tue, 28 Apr 2020 12:26:31 +0000
Message-ID: <DB7PR08MB3003E1459755B853B41490D6E9AC0@DB7PR08MB3003.eurprd08.prod.outlook.com>
References: <1587987364-4566-1-git-send-email-hadar.gat@arm.com>
 <1587987364-4566-2-git-send-email-hadar.gat@arm.com>
 <20200427150658.GA26305@gondor.apana.org.au>
In-Reply-To: <20200427150658.GA26305@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d0e5d884-e4b2-40eb-b1cd-05bc5d22c532.1
x-checkrecipientchecked: true
Authentication-Results-Original: gondor.apana.org.au; dkim=none (message not
 signed) header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79f1ae50-f7e9-4360-342d-08d7eb6f66ee
x-ms-traffictypediagnostic: DB7PR08MB3354:|DB7PR08MB3354:|DBBPR08MB4444:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4444F013A45D02D1B2C86F02E9AC0@DBBPR08MB4444.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2150;OLM:2150;
x-forefront-prvs: 0387D64A71
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(478600001)(66556008)(64756008)(5660300002)(66446008)(7696005)(9686003)(7416002)(55016002)(66476007)(66946007)(54906003)(71200400001)(76116006)(8676002)(6916009)(8936002)(86362001)(316002)(6506007)(2906002)(33656002)(81156014)(4326008)(186003)(4744005)(83080400001)(26005)(966005)(52536014);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RSVca5Rxa88GaFi5QkLUvQIwWiARGbOs64YIpYdtWWzZMjlaQ9r+ZUgTTj+UrigGdWW+uAU6US9IUkB+WLbEJi6yaliYyFtqgJD2AudvXG2Z+0cZD8VMbUahAPDPcncto2ugLmQ6EE4487aOWNo78Pm4JHeqTG9E53Y1dVwwmSF8JFPiwB15WAvCC5BfSuMxlo4ld1hf8S+57iNeDUiKucyAXGJgOQCsjQ2o2PuKqvoxoBXgtB60ncEKhqcngMQmzuktNnA7NigWLSygpQ+nXgi28DVaznkn5kj8pws11hXKuUz+rP96sBrj0xmcZEipIYmiVD8wrQhoIZP1h8ezV6ny08aSNqd5icr+aE+0gTCtcykNHj4XUpNlUHT5nJT+V2oPVHD9Di3hIBS5veSDjOckaBj6kciO0WzCx0t6HvVPB28v2f7lduNHhkcR3v+Fg91O3JZObhVXcIQK48JVcIx134hZfIe/pE7PViRssX7Kp6PPzO5Q1a38m/LoocwAEtb0HJzwpoKFCQwVjvYWkw==
x-ms-exchange-antispam-messagedata: NB7L9lVNPGfR7sjkz/YaPsO3bTChpa/qvATsxFIvQ6+fhM8gTOVT3jbyV/m+1UteJ6rYSNl5YayH/QEHeNiXNheHnnadkZVV3iew/LW2OgQOGok76jBQPKQ4GNRTqGQB6+YN2AqOFNNFSh03Gn91egOoAa9ufDBsi3SawdEILYk+FCKwQ6impZ8iOM5gnwx4+s5n4DbYFuqr+zWFIwSjVmry1bNBPhNjk2mUJLRrX7K5QFwHrsSH0a1aA3Y7M7htLNOH+Mr9wdKUvJfcaK+7zJFyV51CDG9ZrNQfpiI7LWAw7uHCkVKNdCnA1jogR69sz9KW9t1GiuR88tA07jY4gN+nyPO2wxOLJ9QtRT1Z2dbxwCZ8y274Sd9WhMK0CtggewwPVSFuaSFcZufA8NqePLxEifHpJXAi40aOPfdDsKivN0oPBWbxWizNWATnJ3nKjvpYF3tnrVY3SJLBHzUrPq/idQJ8sl5NWjf2rRpuUtydobpq6MdhbXKuYHeKEgoBzCXZjlczRGURZ5nwYfUiv5+8yWokChQc/EqP8pPP2zwWvfgMM0fGY7Imy3CD2IPn7eQj3IQm3h15+aIyosUslLWynyMduLIUrW8DzrHfYCNLqcOv6ONy7lX9kVe/RJbLT/RmLt98K25EhOvaL3RfA82z6Awo15xFjVhHjFZvtWweH9ukejOh3hWfKmI5R9kCnEoPvXo4CgDGT/B3ON5LrEYVjV2VO1CayY/D86clMPhvUAr1YjxPKNN7+vizh6v5R4sv5ETciybkwMRoRucBm6JsLZRbLyVakt4PlhC4R/8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3354
Original-Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966005)(4744005)(5660300002)(6862004)(450100002)(55016002)(4326008)(478600001)(82740400003)(47076004)(9686003)(54906003)(2906002)(966005)(6506007)(316002)(81166007)(186003)(63350400001)(52536014)(81156014)(8676002)(86362001)(83080400001)(33656002)(26005)(70586007)(70206006)(82310400002)(336012)(8936002)(7696005)(356005);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 97d5b583-f555-48f3-04d1-08d7eb6f627e
X-Forefront-PRVS: 0387D64A71
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjZMgLPunl8rlO8JMOKiyFwFg5KuOC05XhvZwGAcWLsOfV3vJoS7q3ewB7+SZcNjFQE0p9BZVwZcJQzraOP7WYACsd4vewQly90BD10pcJQoKzib+YN5MnVUTuAQhq2jEaLGWoLhAlOr338gfnXhE8rWFfBvivm03lY4Dlvf+IwRDfBy8MTvfcw4ZgHJ+0q9iZakKSlrQF3583g9+Lh2Smd6AWklaWkERhlUecTYAxJOmWkrjatUdhjSKLo/2xDk8nUSDfLvkrAb64ChVzj2MOOTsW/j6DG+7meL6HKkwB2XWbcTMP5avwtxZqlvbHCN+4Dl9Amm+9h4S7dm7jtdwqLi93/t0iE2/Nf4hfaF4XJQ+l3wN+RvBeqO7lDRMVJf48E5FKGf/Obcj03mjghnS/PUhECWDIG6VzSl2nc9D9tSQvxpYkXVTIen/X7w0YaM9URnppH8etjGiWbC7wRvHtI20Mvw9o2CZqerIkrVSTaraRn33GIINu2wAsQDaqog8D6eU3g+QkfOBpUbT7sT79bMMlXG8DXLsX7Bh0eYjku6vIsmDGgnn5wg+e9U15HiiQxp1fitblCESZ5Cwn1C/x9L07QFLSJqbzXjcQC/MZE=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 12:26:39.6898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f1ae50-f7e9-4360-342d-08d7eb6f66ee
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4444
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IEZyb206IGxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0
by0NCj4gb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgSGVyYmVydCBYdQ0KPiBT
ZW50OiBNb25kYXksIDI3IEFwcmlsIDIwMjAgMTg6MDcNCj4gDQo+IE9uIE1vbiwgQXByIDI3LCAy
MDIwIGF0IDAyOjM2OjAyUE0gKzAzMDAsIEhhZGFyIEdhdCB3cm90ZToNCj4gPiBUaGUgY2N0cm5n
IGlzIHVudXNhYmxlIG9uIG5vbi1EVCBzeXN0ZW1zIHNvIHdlIHNob3VsZCBkZXBlbmQgb24gaXQu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcgfCAyICstDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gVGhp
cyBzdGlsbCBkb2Vzbid0IHdvcmsgd2l0aCBDT01QSUxFX1RFU1QuDQoNCkhpIEhlcmJlcnQsDQpJ
J3ZlIHNldCBDT01QSUxFX1RFU1QgYnV0IGNvdWxkbid0IHNlZSBhbnkgcHJvYmxlbS4NCldvdWxk
IHlvdSBzaGFyZSB3aGF0IGRvZXNuJ3Qgd29yaz8NClRoYW5rcywNCkhhZGFyDQoNCj4gDQo+IENo
ZWVycywNCj4gLS0NCj4gRW1haWw6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9y
Zy5hdT4gSG9tZSBQYWdlOg0KPiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+aGVyYmVydC8N
Cj4gUEdQIEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvcHVia2V5LnR4
dA0K
