Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D188C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6B422B48
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="Ya3WjC1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfLKQqG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:46:06 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:20976 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730276AbfLKQqG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 11:46:06 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 11:46:05 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1576082765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zCqSf8XbppFmIybArOwRKLDPGxmtewhuibNQR4FsSGg=;
        b=Ya3WjC1PODSPI9aC+B/7QHVsx3QDmDcb8ngyQFNk1DQ5U2pQMDaoFqV8LXYD4R0ttAokz8
        KeKykgLk++3ONJ/R6tAOYIBcdjC8FQajUl8tbk33AbHn5dmM3pUqnN9MyL8n6plkfNtull
        mHgCzXrSQccLJiZmapy45GAVN6KK8P0=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-2RYLyOs-NhyGUaqDYrPhvw-1; Wed, 11 Dec 2019 11:39:52 -0500
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com (52.132.97.155) by
 CY4PR0401MB3665.namprd04.prod.outlook.com (52.132.102.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 16:39:50 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::612b:9fda:ab11:2787]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::612b:9fda:ab11:2787%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 16:39:50 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     'linux-crypto' <linux-crypto@vger.kernel.org>
Date:   Wed, 11 Dec 2019 11:39:50 -0500
Subject: duplicate [PATCH x/3] crypto: inside-secure - Made driver work on
 EIP97
Thread-Topic: duplicate [PATCH x/3] crypto: inside-secure - Made driver work
 on EIP97
Thread-Index: AdWwQbwxFkBsUfgITf+jEL1QZK40lg==
Message-ID: <CY4PR0401MB36521A1DC1770173458D15A8C35A0@CY4PR0401MB3652.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@rambus.com;
x-originating-ip: [31.149.181.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f546e35e-e0eb-4ab9-14bc-08d77e58bdf9
x-ms-traffictypediagnostic: CY4PR0401MB3665:
x-microsoft-antispam-prvs: <CY4PR0401MB3665AEEFDB74C5C039DC9EA4C35A0@CY4PR0401MB3665.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39850400004)(396003)(346002)(136003)(199004)(189003)(7696005)(186003)(26005)(6916009)(6506007)(52536014)(2906002)(966005)(316002)(478600001)(5660300002)(55016002)(9686003)(33656002)(66556008)(86362001)(66446008)(8676002)(8936002)(81156014)(81166006)(4744005)(71200400001)(66946007)(76116006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3665;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q4lS/x+K70Mf6Xb5qEOG6eTkYZ1RjIVWYSkuKCCQVbBBQIelKu7dL969kTt87j+XYIgGQ/qWZo7pFIFIzxmP/5plcnUemsNeRpFGG1YoZKq2T2GEy03zecdlasU+++4A5dwI3vwMGzND2wf/tGkT5ickop9iawboWbccrBLXWxR54jiNhJiDMTDJ06/ySSBuymwnf9fQ+XEx5KAmp36z1nOSfzMrvRRvXHfb7JIFVXnNmj4f84svDeQ3mCOHQiirZKaSRd68LOKtejqiv+Xq5Fv7uQkG9h7HsFxhDXy+6eicG1I4TTEsCLqsf+eEEVWgBXdRdB1VqVZ0DcV2UrQvojmgC1wwi7N94gdocv9R89zhYni7pR6bmVahs1gbFWmu/G6SpT8NUSB19SuUfIZMWfdsXUpOdK/gQlzNXW1XHFSY7Y8SNiTeRZYBkNPlIjNOruyVfh0pr3hiwKwFxfkuIsRvg5DhpxGOII1lQLdX46c=
x-ms-exchange-transport-forked: True
x-originatororg: rambus.com
x-ms-exchange-crosstenant-network-message-id: f546e35e-e0eb-4ab9-14bc-08d77e58bdf9
x-ms-exchange-crosstenant-originalarrivaltime: 11 Dec 2019 16:39:50.5354
 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: kKkoFZNa69989G2ahcKxHX1DgQ6L9XYR+VcK4Hu8zsf7Geo3yyjxcKv5oSB6TDCN5BZ46y0inxsWIdvI/tnOxA==
x-ms-exchange-transport-crosstenantheadersstamped: CY4PR0401MB3665
x-mc-unique: 2RYLyOs-NhyGUaqDYrPhvw-1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to some e-mail authentication issues, this patchset accidentally got se=
nt out twice. Please ignore the duplicate.

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines
Rambus Inc.
http://www.rambus.com

Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by=
 Rambus.
Please be so kind to update your e-mail address book with my new e-mail add=
ress.


** This message and any attachments are for the sole use of the intended re=
cipient(s). It may contain information that is confidential and privileged.=
 If you are not the intended recipient of this message, you are prohibited =
from printing, copying, forwarding or saving it. Please delete the message =
and attachments and notify the sender immediately. **

Rambus Inc.<http://www.rambus.com>

