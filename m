Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446C1C4361B
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 14:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F304D23AC1
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 14:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgLHOLl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:11:41 -0500
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:55900 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729564AbgLHOLl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Dec 2020 09:11:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1607436613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BXu0V4t6ivgnHmivmqUZm/vC38B7H6rpY1ftR4Vv25M=;
        b=DMOG2iDItHybpn7OULXShP9PO5g/6rm0Mv9A+AORxQNefc5V3V8ggilh/7/dRI2yqSAmeJ
        noYGul8rLKe/Q7qPkFdK2y+idO1HNUSh+0b1JQnLQ39HHlzzJPE6ybTzbWrDPR3s2wU9Pa
        f+VUVedfG1YRJfVX3B14YeTH+uH0Hbw=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-uIdgjNI3N6uXoocY3YymXA-2; Tue, 08 Dec 2020 09:10:12 -0500
X-MC-Unique: uIdgjNI3N6uXoocY3YymXA-2
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0477.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 8 Dec
 2020 14:10:06 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fd25:5d10:75b:4dc0]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fd25:5d10:75b:4dc0%11]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 14:10:06 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: How do I read kernel audit messages using NETLINK_AUDIT in user space
Thread-Topic: How do I read kernel audit messages using NETLINK_AUDIT in user
 space
Thread-Index: AdbNa0m6lK+NIRfeTgKILQO3WoEFmw==
Date:   Tue, 8 Dec 2020 14:10:06 +0000
Message-ID: <TU4PR8401MB1216414768A3A701B2CA6BDFF6CD0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.219.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f7d1d28-a5ff-478e-673a-08d89b82f716
x-ms-traffictypediagnostic: TU4PR8401MB0477:
x-microsoft-antispam-prvs: <TU4PR8401MB0477A34E65273F6F3FFE4741F6CD0@TU4PR8401MB0477.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1wvKSPrVe8lbm3zsN6fYMFoirgmQlrSwXuLHyrhPwhREuvu6f3Tx6F4WNSGsJi+NCNEH39G0oG3wIwMiJvKMfSgi3DhY2r68+08tjWaAjlUafRmChwi1DCf2IMZIhwBrI1vr3LtUg8JmhFjjPnw/pEo23+2NYJvYOUsWoSfK+Gl/CeM914QHxhl1GF9t3xLNMRDi+tN1mpx1Kz/OfVX4/Ys5Rv+CIpMm7F1LuaieraODTQhZQiRW5b6A8YWkQmvfuM5L1+/Q712BRNHWmPs6T9SC1MNYn7QfHJug/utKwevEx5ds57BKE+fH138b8eHw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(450100002)(15650500001)(52536014)(83380400001)(6506007)(110136005)(55236004)(8676002)(478600001)(66476007)(86362001)(66946007)(33656002)(2906002)(66446008)(9686003)(186003)(71200400001)(5660300002)(55016002)(7696005)(76116006)(66556008)(8936002)(26005)(316002)(64756008);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EAkqEWMA0N/I4Hedd/pr8ei8JrdrkPojhRI8MQ86R0es7Czh+TBSmkTGlP3/?=
 =?us-ascii?Q?gyu5P13cMYr1q6WOdkOZpvv+o3QJQq+/Ddh/jLFKRD2LN/e7XcOR6wYctelt?=
 =?us-ascii?Q?GpaovR+u6TjTydC5eRaN1y6VN4O9aVQPBzs1qmarG6RtCMHqlY7E4zSP47e3?=
 =?us-ascii?Q?RwUdSKimCB9t4WnhhsqZ/qn4IX6/yDk29CPL/701lf7woY+1G4+JF1UNLD32?=
 =?us-ascii?Q?qwfkdFLD3v19SC9DWMrxpu+hJWOnm+96+Z/0aMaeg3x0tffxxylDHozLh1f8?=
 =?us-ascii?Q?mDC7Y1amw8o00gr7nfDt4b9bQBp+zmpbZ090QWccn+1jZKz8Nat+m6G8uPda?=
 =?us-ascii?Q?rVrrad5YK/SnijOOUWto+S121AVfffvY6mL4J19nSAYP/U9O6zUOOjniX2O9?=
 =?us-ascii?Q?ca4w9KxlJVAJEYAlWYM2Z9oxSDlGfIr7i/5SaOnaurRymySl8rCx6uPe0q+R?=
 =?us-ascii?Q?j4D68kklcnESyOG0Xu1vCus2n/Cb3dU/3j7QcjiFhxRVVyhF0z7R4Uc/vybT?=
 =?us-ascii?Q?cL6KFpUJWJjP6VHDtjhcbH4kQDyjm+rKDCbH9NEQ0ghTf8w6yxl+PXxZmmU1?=
 =?us-ascii?Q?tiAhVZ9lzv9qST7uq68wQoK9z1rtzxH16jqjcu5ZtG7o6mF+t5kOMFwEPGty?=
 =?us-ascii?Q?/VQEl8Tc/cg9BUCXcLe6d55QTeikGglF5dpJPOLw22oMqFuG+3aD0Hmrnetf?=
 =?us-ascii?Q?pyyUFEdVph8MvTlO2JXr6khkGYqn4FIS+apu44Gqs2YC1cV1rkfgvaA1ym5r?=
 =?us-ascii?Q?A2QxBbKgFMogNpC/390UeYj/1YkqO8NEgfAWO8yCMQyhe26FYNEjs5U0ZC2j?=
 =?us-ascii?Q?m9Uvr+MO5sH2ZpDdPn3ebQB3f+8cWAEh/e1l8pC+2OdP7nDnUqMaSeHqx8Gg?=
 =?us-ascii?Q?d4q3sNCJNLz6jEr2MC75Tw09W2wIfsQkIY/SMQmGeMqNMz4gNwwXbiLZekzW?=
 =?us-ascii?Q?ShBXF5XB0tmz5Or0OWefyiWNXUdynLE9G5/4qsw1wHY=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7d1d28-a5ff-478e-673a-08d89b82f716
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 14:10:06.5539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mqPyPCQExtQOtQwLb6BSXCvcysLLa+x7/t8HbhG0YhNKnfVQAQvbDUePT0EgkkEnlWugF9ca0CQ3ZY9zv7k3RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0477
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I am trying to read kernel audit messages specially generated by XFRM in us=
er space. I wrote Netlink client stub to read the audit message as below. B=
ut the call recvfrom gets blocked indefinite.
Can any one tell me what am I doing wrong?

Regards,
Jayalakshmi

#include <sys/socket.h>
#include <linux/netlink.h>
#include <stdio.h>
#include <malloc.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()=20
{
  int fd =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_AUDIT);

  if (fd < 0) {
    printf("Socket creation failed. try again\n");
  }
  else
  {
=09struct sockaddr_nl src_addr;
=09struct sockaddr_nl dest_addr;
=09struct iovec iov;
=09struct msghdr msg;
=09struct nlmsghdr *nlh =3D(struct nlmsghdr *) malloc(NLMSG_SPACE(1024));
=09
=09memset(nlh, 0, NLMSG_SPACE(1024));
=09memset(&iov, 0, sizeof(iov));

=09nlh->nlmsg_len   =3D NLMSG_SPACE(1024);
=09nlh->nlmsg_pid   =3D getpid();
=09nlh->nlmsg_flags =3D 0;

=09src_addr.nl_family  =3D AF_NETLINK;
=09src_addr.nl_pid     =3D getpid();
=09src_addr.nl_groups  =3D 0;

=09bind(fd, (struct sockaddr *)&src_addr, sizeof(src_addr));

=09iov.iov_base =3D (void *)nlh; =20
=09iov.iov_len =3D nlh->nlmsg_len; =20

=09msg.msg_name =3D (void *)&src_addr;
=09msg.msg_namelen =3D sizeof(src_addr);
=09msg.msg_iov =3D &iov;
=09msg.msg_iovlen =3D 1;
 =20
    recvfrom(fd, &msg,sizeof(msg),0,(struct sockaddr *) &dest_addr,sizeof(d=
est_addr));
    printf("Received message: %s\n", (char *)NLMSG_DATA(nlh));
    close(fd);
}

