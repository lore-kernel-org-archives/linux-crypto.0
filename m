Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1458FC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 08:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D099E20830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 08:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="HTJ4iHps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbfIMImz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:42:55 -0400
Received: from mail-eopbgr690045.outbound.protection.outlook.com ([40.107.69.45]:59300
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387499AbfIMImz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 04:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKMkgTwZeMNHLcCqXXmZz0L0LTrjtA2HHNMkiBVj/K7zJhJlDbaYdKa8Tv1f9/zxGozwMtmzHb3127a4YQMnqFfR6rjk0pYSNOK0DiB/l99eQ1L1RNQ7wHQ/T8l92MzKgNTVNVd0ftG9DMfuHujWBJFbUKEeiwUMNPLyOb2Pe61dKpUFs0KfmKiRzMzi+oRbpTUTA24gwVz0colUBEfEhiABi3hMaT+tUTKivXSKL2ss4VJRoW1nXiObZb+Km7UJxxJk2jUB4CbuP5whyU2FUFKrTnwTLRqCUnAx+Iy6invz12pakDypotmwsTr970d2OYSdch68cgjp4B9DMwH3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qubas+/+PeSOaNsd/xefJqgurkZCeNtsNgXbGBlQbTM=;
 b=LuXlx1jxddHwui2F9sICrC1x9DOOE+2Xba1K91CeVHKVdE+ymJ5KYvxOmxi7wQLwvVPv2LcaufggV/CC/eGv98h25YnCvhHlt71lmXs5l0Z+uEAAG9vfw8svCfeug8uKDITRmeoDM2rirGgoC4rlj+/a12gaaxay32TkXZCmCnWhHsnM615Q1WzF8u0PwIREWwjdSiX3XolGY2sds/YRo89c4OikkcN/ZATRT1EJKF/G13i8ddzu0zhs8fqOlniaPqqTwcK4FqBPVlGhB19Zh8u9zEWzEvoWDz+txd8x1VnySRxMkIf7oTjiwe3RE94tlmu8zjYB7tfIYK/RvmBE3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qubas+/+PeSOaNsd/xefJqgurkZCeNtsNgXbGBlQbTM=;
 b=HTJ4iHpsADwH1AWmy5fbWtOlTpA34f4nVonAvVHAbt3Y6EBI+YvQ4agQC+rnK+t2ZkttInTnMzYMsH+WG5XiK+jPINETeLrP6P+dafVpSqwQ2m7axMVIKOhw3T+r6fltB+A1CLHOosfibsG3zywpAXSm34HLC6HKJfjM6YQkjp4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2685.namprd20.prod.outlook.com (20.178.252.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Fri, 13 Sep 2019 08:42:51 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 08:42:48 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: testmgr: HMAC-SHA3-224/256 test vector issue
Thread-Topic: testmgr: HMAC-SHA3-224/256 test vector issue
Thread-Index: AdVqDzInrTtXROijQCmQgcanszzQJA==
Date:   Fri, 13 Sep 2019 08:42:48 +0000
Message-ID: <MN2PR20MB2973266A6401986B22A9AAB2CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45b5eaa0-3b29-4068-895b-08d738265b2f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2685;
x-ms-traffictypediagnostic: MN2PR20MB2685:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB26859823E00458862ED7A147CAB30@MN2PR20MB2685.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(189003)(199004)(86362001)(66946007)(71190400001)(66476007)(71200400001)(66446008)(256004)(486006)(26005)(64756008)(9686003)(186003)(25786009)(66556008)(6436002)(76116006)(2501003)(55016002)(53936002)(102836004)(476003)(6506007)(5660300002)(74316002)(66066001)(4744005)(52536014)(8676002)(33656002)(7736002)(305945005)(81166006)(81156014)(2906002)(14454004)(7696005)(15974865002)(110136005)(316002)(99286004)(3846002)(6116002)(478600001)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2685;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4rvALQBxz0Y0qZwPu0bqccVO1CTGp5xbp1Z9mvAi+iInONyLaDcj29sdZjhZVsig/nF/IaKGe2a87gEm9oPfTQRV0Lmfde3Zhu2sUy1PJTfe/vgVEZ7EcVy8LAcISZRsWBSQj6RChZWPCi+Jg+cDBRstcDe46FvqDy3TzXP2Vwki6W4Y9LWZz2EtwhaC22Lh31oWcl/5/1/MNfYo7cDMCI/MszfnVjQF3Sz7YEhtmLuBukKhNBbQYMXmZp0uq+QBoK/qlWr622h+6b1KZ3+YnM2KPGvCJlIaT84xGhrzvIkIUIHvHxH8lGqFEcON++Qu92MLIvduGl2wmLoK5D0WXC/WZeMCwpoD3XUfuFxl53m78JrUF42xlPTt0YIS+WbGKkcybjR6+DeDA/4m9tfM/IbzXUW5hEcyNH1tVc0SMf0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b5eaa0-3b29-4068-895b-08d738265b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 08:42:48.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWG7pNDWXeMbbjgv6WUQOqt24V7CuH5VN0Txb5Yb8dQdRdHiq1eFN7sb3cnaBtPCJ9GLVTg0iCA9lfge+9+dfGRgF3FOhDmL7SDvnukghQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2685
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I just noticed that for HMAC-SHA3-224 and HMAC-SHA3-256, the current
testvectors (and the fuzzing) do NOT test ANY case where the key=20
is larger than the blocksize and thus first needs to be hashed.

The thing is, SHA3-224 has a blocksize of 144 bytes and -256 has a
blocksize of 140 bytes while the largest key used (supposedly "Larger
Than Block-Size" according to the plaintext) is actually 131 bytes.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

