Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F780C5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 09:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBFC021850
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 09:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="LPujDspl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfGEJs5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 05:48:57 -0400
Received: from mail-eopbgr690054.outbound.protection.outlook.com ([40.107.69.54]:50564
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727225AbfGEJs4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 05:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTWMgTTf+O5xkMALT+LvaeyK0X7McomLgF+FpVVlm1s=;
 b=LPujDsplbfd5e1qa3uzkGNtnWTP8gyQuKtBdUeCkkhn+7rL9RoWi8n8dFURz9lAOZPmFaYiUrhWGEI94rZi93Y8JvS3DVUgdcgnnMVCpwhTY2Zk+5XiVVRtOszt2b12WtDK/q5AEcF+Nrrf6f465ymWcxzHtL/uDR4+liFuB7YM=
Received: from BY5PR20MB2962.namprd20.prod.outlook.com (52.133.254.94) by
 BY5PR20MB3203.namprd20.prod.outlook.com (52.133.252.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 09:48:53 +0000
Received: from BY5PR20MB2962.namprd20.prod.outlook.com
 ([fe80::cda8:e2df:aa73:4a4e]) by BY5PR20MB2962.namprd20.prod.outlook.com
 ([fe80::cda8:e2df:aa73:4a4e%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 09:48:53 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: skcipher and aead API question
Thread-Topic: skcipher and aead API question
Thread-Index: AdUzFZSC+g/TbhjQSoOcPg+7Aq6e8g==
Date:   Fri, 5 Jul 2019 09:48:53 +0000
Message-ID: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b8a50a1-b2e9-454d-9b49-08d7012dfd6e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR20MB3203;
x-ms-traffictypediagnostic: BY5PR20MB3203:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BY5PR20MB3203B0E9466737B1E9E61FB6CAF50@BY5PR20MB3203.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(376002)(346002)(136003)(396003)(199004)(189003)(99286004)(54906003)(53936002)(8936002)(8676002)(5660300002)(3846002)(6116002)(4326008)(81156014)(9686003)(81166006)(316002)(14454004)(2351001)(2501003)(15974865002)(26005)(186003)(6506007)(2906002)(7696005)(256004)(476003)(102836004)(486006)(55016002)(66446008)(64756008)(76116006)(73956011)(66556008)(66476007)(71200400001)(71190400001)(7736002)(66066001)(478600001)(305945005)(74316002)(86362001)(33656002)(25786009)(52536014)(6916009)(66946007)(6436002)(5640700003)(68736007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR20MB3203;H:BY5PR20MB2962.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hooiVMPBMitNqfVuP6h7G6o0jVR9cK+ZxH1y7OHSTSjLEbpeGrv+HuxtEjcPO8AWm5/8pVSUybIcl7w65/xF/nKcvrtn/5tmB8VuLb6g7YaDcnwpo0HMfnFZ6kg7hsSU2DdrT6MtDnSkdmyelwduzzql1WnD3sQ0KTRzfOg7N1XsbdWN3DFql+pQzP4T2DwGtKhVVOtWZK8y5IORQcrSUfnzsYov8lYautIPY4tHOKCzmaZDZ8QHp5PaTZPMPfRQs7JYVkeMn8ujl/oPeFX6LvpDDmo2CupTeYGd3rHan7o8dPdebFN0PBpbDUPR+nIXPqgJNRcyp6ov4nmZqMwN5xGzwLMcIRPCqBr09/HANVh4UlZGFqErA1sscsyLlYIGcDPtkJBM+SkSRH2d8rK+N1JP2bj0lfqJpOohmWIeByY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8a50a1-b2e9-454d-9b49-08d7012dfd6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 09:48:53.2395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR20MB3203
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Just browsing through include/crypto/skcipher.h and include/crypto/aead.h I=
 noticed that
struct skcipher_alg and struct aead_alg define callbacks named 'init' and '=
exit' as well as a
field called 'chunksize'. The inside-secure driver is currently initializin=
g these fields to NULL
or 0 and that appears to work fine, but the respective heade files mention =
that all fields
should be filled in except for 'ivsize' ...

From the code I deduce that init and exit are not called if they are null p=
ointers, which is
fine for me as I have no need for such callbacks, but can I rely on that go=
ing forward?

I also deduce that if chunksize is set to 0, the chunksize will actually be=
 taken from
cra_blocksize, which is at least fine for block ciphers. Again, can I rely =
on that?
If so, I guess I would  still have to set it for CTR modes which have cra_b=
locksize is 1?

Finally, I noticed that aead.h defines an additional callback 'setauthsize'=
, which the
driver currently also keeps at NULL and that *seems* to work fine with all =
current
testmgr tests ... so I do wonder whether that is a must implement or not?
And if so, which subset of auth sizes MUST be implemented?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

