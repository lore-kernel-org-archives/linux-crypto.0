Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F73EC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 09:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277EF2074D
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 09:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="X9mzvtjw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgHMJDE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 05:03:04 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:58323 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgHMJDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 05:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1597309382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HwxWX0R+qbw5o/W4fjz5qyno18KllBl78TSUXwLS2NI=;
        b=X9mzvtjw1VbwUsImzx/tqx8N9qwnLLLSnIUpQbfmULHgP+rTAtD0wHTDZTQWH1+FKaiXG9
        LtHpEBZ4DDnfBu6qoHqdYIZhghq16gFSmk3HXMEevKsq5JFRaopYS25qkXOdvqcEJzlGm1
        hYGJyc92B4tJc42X1JxqZUT3LR5JxTo=
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-mLq8s7FfN3-BjM9jk8gy3A-1; Thu, 13 Aug 2020 05:01:29 -0400
X-MC-Unique: mLq8s7FfN3-BjM9jk8gy3A-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0656.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Thu, 13 Aug
 2020 09:01:27 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354%8]) with mapi id 15.20.3283.015; Thu, 13 Aug 2020
 09:01:27 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Information required on how to provide reseed input to DRBG
Thread-Topic: Information required on how to provide reseed input to DRBG
Thread-Index: AdZxT90HuxgE8CzuQx++WGnAfz8h1A==
Date:   Thu, 13 Aug 2020 09:01:27 +0000
Message-ID: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.105.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 951e1cb8-1b65-40ca-0b6e-08d83f6776ab
x-ms-traffictypediagnostic: TU4PR8401MB0656:
x-microsoft-antispam-prvs: <TU4PR8401MB06563AECB6200F45DC8A4AFCF6430@TU4PR8401MB0656.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BLh7iuEajMEqsnNEA2UUR1Xs+lO1XC6mHWAInZgMuvPAbm8E8yooX2k0vZYWmW4XuBnMIQ01RBkFBJt5I0WyKP6nYbkWD31WQ05zS/EibI7XAzeGTNvO3aKW2JGeImO12Kf1H+u8/4WfMdTSz7OPyUd3KRK8G8DP8td/lFGKkIidycznGfBOjMRSBHTMlq/NBoo2bNC9yGvaz4GTweFc77LePy0yH/mn9xXrmS7jaR1YKiUy+wpmQmtt/RN8j0rKNYmZonAjDDdKwDHCIQxRfRgZzyvLt4pJ6sBtQDtwOyfZ2On0D3keI1makhMKRdU2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(8936002)(8676002)(86362001)(4744005)(33656002)(478600001)(2906002)(9686003)(55016002)(71200400001)(55236004)(6506007)(5660300002)(52536014)(64756008)(66476007)(186003)(66556008)(26005)(66946007)(66446008)(6916009)(316002)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aqa9EOylHQcgwFrfudQ7YfXgdC0fHEmfF14SElyA3pTre9r73Mv47+xlYFcaWipXnS+DVFxrd4iz6t8dp1jxLXlS0zhBmEH7Mi5IouU0cmJKxlB4ndDk6+rYH7V9NDb43bjAEufdWt6CZInxRRpeybj+MhRbnucfor+kYgyF/y8bF27/1SphXvu1CeXQX9jwPDMzNLVf16J5vUurMInx/uXxyyVukR1vktVmuHOXiChwcV7+yasBXgEJfg8DyDDJbznTopT2ETd1FITleaIldvPRrFlUdgAXj64ZOXgQBhajvSURjuJF9YCvFN8T7TffN4GwheybpGkjacx1T29CIiMazlLbB1x6mmPCyZRz/5D7KEaBp7LbwTLPtWKQ6M+kHzZ3G4/xiu0bQYOr14UWMr6JMekTXptcq5F/62kEDMa+d8PuICD3Ku9hc28W7YslBTnqwv766qS4UCP0PBIibbirjkl1E+S3xrhyDGUtI3S7rLsEoofwhCHf7NV5CMUl2RjIna9ndkpGSH4q07kCFlNNzL0hsTVqCmXJC3dMizgxwyX0mb/t/kCLCShR5viAqCMOrmllijRl7JrSvzdZcCU03nyDms5oreGE/LdZZfHVrNskoR13zP7j9HyqER7PS9LKRCjvkTU+mGdra71fvQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 951e1cb8-1b65-40ca-0b6e-08d83f6776ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2020 09:01:27.6628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XgaIqqRCKXhn26tnkzyrIidBsCS+IVB4VIpxfF1spN9nabToeNt88DJkkKldqCJzXVI3Armyzc4AeAQTCY2NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0656
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I could successfully execute the CAVS test for DRBG with  ""predResistanceE=
nabled" : true" reseedImplemented": false.=20

I am trying to execute the tests with "predResistanceEnabled" : false; "res=
eedImplemented" : true. But not successful.

Can anyone please let me know how to provide reseed data to DRBG?

Regards.
Jayalakshmi


