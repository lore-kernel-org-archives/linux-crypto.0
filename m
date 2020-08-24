Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C04C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 501402078D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="j7zqSZqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgHXOlW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 10:41:22 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:23087 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbgHXOlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 10:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1598280077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yyjn5E4SJdXnqeOciEA0KtaSM+uYNwGNRyD6DRrv2k8=;
        b=j7zqSZqFah1g2Khbo0Q0Ju8Q7Ei1p3lVkkweneGzrN+5w4bW+ZdwsGHUSIDv0vy3EL3D66
        7tRsg14iKAKvwhUws+0sQ5CoheoQyIS91kRtC7Kbxs+wWzvjN7ARNNr72AaVqdSxcp+drK
        myBqc9dWqhP9MbwNEQ5vPy5FtxY47kQ=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-BSCmvVHNNdC_MWSSJ_0RtA-1; Mon, 24 Aug 2020 10:41:15 -0400
X-MC-Unique: BSCmvVHNNdC_MWSSJ_0RtA-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB1296.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7709::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Mon, 24 Aug
 2020 14:41:13 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354%8]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 14:41:13 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: HMAC test fails for big key using libkcapi
Thread-Topic: HMAC test fails for big key using libkcapi
Thread-Index: AdZ6JJoFQMwI76Z+R1Spwzgk7TA7Xw==
Date:   Mon, 24 Aug 2020 14:41:13 +0000
Message-ID: <TU4PR8401MB12164EFE831D43A41DDC8EA1F6560@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.201.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e65d1594-9c00-4a98-5564-08d8483bc043
x-ms-traffictypediagnostic: TU4PR8401MB1296:
x-microsoft-antispam-prvs: <TU4PR8401MB129683EA3BE65FDE37E84A20F6560@TU4PR8401MB1296.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJVhDNhYnHfTDMiWFrzl+F6yUuZ4GwhARZqMLJrV/5a82LQf9o1hze3sVF+kCo0puG1kdSpaFZZa/gXNIJRogUNftRaZhSNYSPNeCBG/sKIyZ1Ctq55KLAsAqdENmp8yKX290eTJomwh0D/XjHHy6QEIUg7fLQaoo3lsr3+HjDwBVr+TEssD+FJebJJAG9PiPY66/kBXdYCwrWiWeMEkmVRd9ddvFyLe4V4v5zqg0yGHgnGbaAzsAzVwFs33IrCM7uqtORQFa7uvQ9pDE4hHMVBnoT6kT4iWkQ0dkyOxc99IpFVQgmrXMhsX/w6/GzxbwlG5ypKTndycekbszcNOKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(346002)(366004)(376002)(55236004)(52536014)(6506007)(186003)(26005)(6916009)(55016002)(4744005)(5660300002)(7696005)(33656002)(9686003)(76116006)(316002)(71200400001)(2906002)(8936002)(66446008)(66556008)(66476007)(66946007)(478600001)(64756008)(86362001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xFelKHHM0JAT5LQzqHUYDKxezskwMTgrOZBm1fTxfCmAnmGUjh3qfc1fjQ6h1VAt7b4aZDhzrf9EtzJ1fOxs6yaXZvMlhRhpblcVUE1NONIM00qSU6ipjyCrlOJrWHYr4P+aeliJC6rwmonVBZ+pLOWavNLwc5cErPdrM3cIfKHuj7WMuXMx4RuTXoqWfpcxLnwJRdAf7pmD19hpLgBE3dX/x/M2RaAuM4Tjz2Jnt0WytY3sBRgb0ma5qRk57Rr0p6Pe71mzId6rJAO8SjUwn79NQFwk5HVEFuYlONWMilSpaz0Hu7vGAXQraYPJHIwGUNGQ7uDASCY3wgp6vLXmOALF9tUzzvXm06u8sx7ez3wSY/pjfY75HsqFgO+nuijKp6EtDbTzeuvyUqr9Ik78WvWk4go8G0BwMkEL8PCKCuSPg6MsSQhlKz8+fRPxPeLLCd2cFfjZrdk1P49oOT+eueYDWY2FEJQGcWu1T01kZmZ0Ab3gaRkMa/dmcgOSXDCOKx38MWyFNg66QJBQXWB4YrBorJP10dqCP9IOP7LjiVhxDOIUGUEDj/B4h7ip0mOQeLhJZgjrDqQqIvGCJ7f+aj0J0eDlWWp2e9uiXvEvNzdR/ifKyP3dLVN7Fg7GVp72ulHNlWL3X49hB9sIqtfrlA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e65d1594-9c00-4a98-5564-08d8483bc043
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 14:41:13.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxwZBovK0Dc18NqSA9gUMyEU7HVDVHTfUpr5WRkmDGoucgEoq2ZRsz7dcCCnZ1p4cze4Zg0BRc4i/QkQ/x0mNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1296
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I am using libkcapi to execute HMAC tests. One of key size is 229248 bytes.=
  setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY API fails to set the key.=20
I am not getting an option to set the buffer size to higher value.=20

Can you please provide me inputs on how to set the higher buffer size to so=
cket?

Regards,
Jayalakshmi



