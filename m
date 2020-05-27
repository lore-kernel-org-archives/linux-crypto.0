Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27899C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 02:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A55208B6
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 02:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="K4YN/C5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE0CVf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 22:21:35 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:39777 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgE0CVf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 22:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1590546093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KLK2Oe/jMCQ8ofPiExLzIZVQ0W1ifb0bGC3mGUYBoBs=;
        b=K4YN/C5pJvVHTYvq49t7q3E4IsSASuQRG0Yvbk0ZAU2YUhe9nD47uS/CqXjJAzRtjs2QA/
        sEhZ8m97bhafqASJ/CA2o6gNdDjhhu14SNYC3v3F1SaLoU1EJkJFx6cHqym2WHJq/wNNgP
        TfLltbYJJ4Xu4PxzrjOdyLAXkLthlus=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-GK5RoNSZOK-KkkcIQ2u6CQ-1; Tue, 26 May 2020 22:21:32 -0400
X-MC-Unique: GK5RoNSZOK-KkkcIQ2u6CQ-1
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7514::20) by CS1PR8401MB0581.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7514::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 02:21:31 +0000
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd]) by CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd%3]) with mapi id 15.20.3021.020; Wed, 27 May 2020
 02:21:31 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: DRBG CAVS using libkcapi
Thread-Topic: DRBG CAVS using libkcapi
Thread-Index: AdYzhqSqx7KcbJRMT++/PXAsb8So4Q==
Date:   Wed, 27 May 2020 02:21:31 +0000
Message-ID: <CS1PR8401MB0646C32205BFF9D0E8B5CCC2F6B10@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.106.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7e91b78-91a4-41ca-ae29-08d801e4ab51
x-ms-traffictypediagnostic: CS1PR8401MB0581:
x-microsoft-antispam-prvs: <CS1PR8401MB0581FBBE28EB141EE4286DA1F6B10@CS1PR8401MB0581.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8K46QkZvQHzJ6loplGfVHL1kdMTOI4sbU1jvLOkzPuo0lANAsF5ZzPMUGRImDJot6JFAUuFnG0u4rpyrPkcWlxlyQdTX651HOmlC77qXywFJ1zaHi1ThofUuQCCq+//dnfQJclluyJ8N9X8XAPpBZjiV2QZO2GsH8WdyeJc3EDUjuw3DfAOeGwUCus1Z3gTcslQ0sF3FpNvE6ZE57+btHUmSQ/GXfcB6RndWLMucXB43HM20MRTmwToJY2M1YRrryhtm+CMAEDmYRpvLWy0ZPgl+rszAHzNEg9dAww8h+XR2APxE4h60FT0cDWvOWbsRwG7yHDPArYmuYugAlXYlXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(376002)(396003)(346002)(39860400002)(478600001)(3480700007)(316002)(5660300002)(8676002)(2906002)(86362001)(26005)(9686003)(6916009)(52536014)(8936002)(66556008)(64756008)(66476007)(76116006)(66446008)(66946007)(4744005)(186003)(55016002)(6506007)(55236004)(71200400001)(7696005)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ndlPxCOt8JgzbhJTv4SGVtEwGHqOpb++gfF7Ralyagh19BdaHokv09dY4H3k6hwdRn9fG8TIVW8mMGkG2MQbqPM9r3s8lp9+aQY09B7sJNvbTD6Nv0Q5gEzEswsH3z4J1WrhsrMwnywTOsLyxffWHkm6QOTxmhFp3lLF0SlRJ7b0NXd4+VZVJV3Uk7gmqjtWLCdeJaDGak9J3hY3okNXBRAA+L02NfPwo9sVD9rtgo30K1vAfiB/vmgWElA4CvoMiYbGmC1fBTydLYIHH3uFVuNYIBsp0fgmYE0xS5WcpyGTwfgMt0dY02zUMcAG+UUBAiH/TWoqzfg9eRxJ3TeXCHBvuAcQZGJ3jJyk3SQPBPKObLl6bFKAyDNeB9/Uit/Z4DvoZEo0h0W15RMfw2Iv32oEj3Sb6qAqQgIg4R9SQlYMitlMqI9eXVaMo52WQ3gMtZIi9K0q5R2X+Dh1KjWsC2/btLNu8grE804dmTTXfwmi9pvXVLqkQFIXSxvSZ6UZ
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e91b78-91a4-41ca-ae29-08d801e4ab51
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 02:21:31.0383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRWW1QdNK0dHJNZ6eaqDdx5HvlX5iZeXOtUVVBvApAkGcDNNCCAaFsI/GCQliKEOJ1WGZ0O1R7kZQQiSmh7+sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CS1PR8401MB0581
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I was going through libkcapi APIs to see if it can be used for DRBG CAVS va=
lidation. But I am thinking it cannot be.=20
I also found cavs_driver.pl, this seems to depend on some kernel mode drive=
r. Is it like I need to testmgr.c kind of an interface and that should be a=
ccessed by user mode.=20

Please can any confirm if my understandings are correct?

Regards,
Jaya

