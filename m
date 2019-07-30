Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9B9C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECFA20693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="fpo9XZ4f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfG3QFK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:05:10 -0400
Received: from mail-eopbgr720055.outbound.protection.outlook.com ([40.107.72.55]:29696
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbfG3QFJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SePgVx0KW24MP56sD5p2tfrclsyKuX64mVssZjFI16/IhLVshkhfjjv7uaYNHvPvy7Vr0iuZS32FZFS2pHruTBFL8Hupjf8MvTotrljPZuwSqS34WgfqtkIoer4ERrYC+fL5hZ6MsHA5bOJZuMyMt8oLLdFlgOffNjUvyNbOUTyRStCH7vrbtkJwr5IR/M4+3eAFGBkc70F4ycdeTpNvzkaSHdKKNZdXXVVxAupipSC5TTH9L3b5FF72JvP2dAHSpb8QMumXRAOfQAmUS9RSJnMsV4ihX8+qly7OksOr6HX2JXY4P3oi9F/YKCL93dBxbP2V0WPJOjt1HYII3JGKdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsQm5naWL7WBKGnf5KommxbrwRpFtL9MDcF5N9BAOOE=;
 b=goVCHnJ4+DsNYj3LoGl9/9mK8x8rAS296tBAigojTc98dK21obgMpxb95dmbhxJWJVr4uvjk2/L9fBk1r6IZ9jJ4E5owfSlgcW37PEHwCGho7hdkY9VKZlNqMjI/0nmiGOLZJGLugbsnGyHX39/7WByqipYM3b6+YVwELT6HgQHBGww2rCAeMfYxz8hGemI4JHzRrUF0YvqYRlYyNJHp1bQz2D9HY2MRWRavOupRInujOA77uU3A57DgH4A2pwDuIHHoN/+1qxTUmRsXIIZAopPhr3/oGzLOJRuCAMExtXwV482dvY4hYMKO7E1IGZ3FpcjAbvKNtfiFQDlSgJx+Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsQm5naWL7WBKGnf5KommxbrwRpFtL9MDcF5N9BAOOE=;
 b=fpo9XZ4fBedFNP2Q6w6PzcQxvbaDbfXLnFBFm/J7XrdpiC/lTNaGJ/bw+MqoNYv1wZ/OApdV4ErEzx/PFW2nx7T+Zt6qZ5J/fQcOcBE/IRwwTDse4vXt40paOqGEnEAcN7nPEbEcSTZ623dkvZv28f4pr0xtoqwZOaDuqJpNL6Y=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1292.namprd12.prod.outlook.com (10.168.236.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 16:05:07 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:05:07 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 0/3] AES GCM fixes for the CCP crypto driver
Thread-Topic: [PATCH 0/3] AES GCM fixes for the CCP crypto driver
Thread-Index: AQHVRvCO2D+3N7PooU2EzkinmOTkLg==
Date:   Tue, 30 Jul 2019 16:05:07 +0000
Message-ID: <20190730160454.7617-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:802:20::40) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7404bf6d-734a-44a0-3fa2-08d71507b0a5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1292;
x-ms-traffictypediagnostic: DM5PR12MB1292:
x-microsoft-antispam-prvs: <DM5PR12MB129236329A6E386BE584D85DFDDC0@DM5PR12MB1292.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(199004)(189003)(2501003)(26005)(386003)(8936002)(50226002)(1076003)(2906002)(478600001)(66066001)(6506007)(71200400001)(256004)(486006)(3846002)(186003)(6916009)(81156014)(81166006)(68736007)(71190400001)(476003)(102836004)(14454004)(8676002)(52116002)(86362001)(99286004)(2616005)(6116002)(7736002)(6512007)(53936002)(54906003)(66556008)(66476007)(64756008)(66446008)(2351001)(66946007)(36756003)(6436002)(5640700003)(6486002)(5660300002)(316002)(4326008)(25786009)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1292;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xrNrczdNWzXtYZhH2pA0I6QVlxCeyixBoe47X2UFLF+f2iSvKuKGbzAO9oj1HU+4B1HTOIglXTnn0/h2f99vNj7SXIm7vkx9rAV7ZF5ElQKWfGrEqBv9GijV6Btu8EBxUjVaSNuewYtBbCFFL3Luq22uSzxAbitYY6DsdVweCnOyxTv8BOhUaklfLV4xcVNxKl+30qZToRcGGFB4+oc6pLvEKpuOzCGqgJnjjd4UCPclL48Mpsc4dLmVG1DBHn9X/EAjlO0BUr52YQO+Sll1ni6iO90MhjasEGpYsc8k66DeFsxdGLrlOKeOMfLBg2DeFyc5K4qIV3PioBYUSrabXF7P9rGpJWWKkZTOu/nMntKn33ci32gEZ6qFc9DG4rdzpWcW8mPYjZyE0cHrdK/4dz3Roep/PFupMvyROQ8+bdM=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <44C6B0C41C3D834A9056E0A5020B1EE4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7404bf6d-734a-44a0-3fa2-08d71507b0a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:05:07.2802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1292
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Additional testing features added to the crypto framework (including fuzzy
probing and variations of the lengths of input parameters such as AAD and
authsize) expose some gaps in robustness and function in the CCP driver.
Address these gaps:

Input text is allowed to be zero bytes in length. In this case no
encryption/decryption occurs, and certain data structures are not
allocated. Don't clean up what doesn't exist.

Valid auth tag sizes are 4, 8, 12, 13, 14, 15 or 16 bytes.
Note: since the CCP driver has been designed to be used directly, add
      validation of the authsize parameter at this layer.

AES GCM defines the input text for decryption as the concatenation of
the AAD, the ciphertext, and the tag. Only the cipher text needs to
be decrypted; the tag is simple used for comparison.

Gary R Hook (3):
  crypto: ccp - Fix oops by properly managing allocated structures
  crypto: ccp - Add support for valid authsize values less than 16
  crypto: ccp - Ignore tag length when decrypting GCM ciphertext

 drivers/crypto/ccp/ccp-crypto-aes-galois.c | 14 +++++++++
 drivers/crypto/ccp/ccp-ops.c               | 33 ++++++++++++++++------
 include/linux/ccp.h                        |  2 ++
 3 files changed, 40 insertions(+), 9 deletions(-)

--=20
2.17.1

