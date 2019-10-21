Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3D5CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 15:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6AF520B7C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 15:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="PH7K7gG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfJUPhj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:37:39 -0400
Received: from mail-eopbgr700072.outbound.protection.outlook.com ([40.107.70.72]:53472
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfJUPhj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 11:37:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri9jEWXtTW02bCnP0Kg7e+//6dxgmbUl0blFRpJn3OV/YcUPSGhz2kKpvYaV3s8qtEK7NM2o9rf3OVNW7GZUaesSXxyGha6YXTEwoy4BmZjcBDfGjobpQl9Z+JyPgrPTlJ3CKYsL4w9ZNFsJMFU2m76z8GtfZ3jgkiSHArhHMmsqaaNKlB9yPxlKXItR9mBFb4A9FBv5oFWyNGB39Sks4jFf0G3IZoE32H4u5VkrecAX+AwfuYGgA6BNYwW7Hz6Qf5e88ICxOkBZnQPPzAeyFvyttxQEre2W9NxHPXNmr2VasDqZFWuf4ja8c/LnQnHLcF2XNQ/TulSRh1MuGxm71g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDuwJIg3D+EQAeKIMNS2pAbyGWXPDUSvh/oE5Yci+R0=;
 b=K4Mw5YMvFpMv8CBfdV2qqCzOO7GEWp+Wdk9TCM5m0dbdIAWMXmP3v8QTy9DoqI++YwH8jjTy+HVnLS0TaIRH0lwVDBGo4aPggHXnuN25D1ortYXLZoz67Cjc4o1MG43ZiKabTK0zhqwnZVjMMBCJ9cr2MdEY1PyEmFWFy+WtT79JYLRPzZy93vr0psXkdgzaSyvm0znZ6F0HznMgUUqyP3PXI2E58tNTuNEAm2aRYFQKxuTW8dDKE9alV6kSX5SUMYzqRElPdeeubebgjDI/cg+uHSXf67fPCPqSxWgCfHzGXAgrpwYGtdssyEE0LHKnPH6zvUOG4z2LIc72BJu/tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDuwJIg3D+EQAeKIMNS2pAbyGWXPDUSvh/oE5Yci+R0=;
 b=PH7K7gG/uztosjfZ/ClZOVCZqgZSxFQlr1PIXbUC1MoLblbI63DteE0A3VexezqmtxNnwjE9KBsO4T3yhLF9yRl92msHP5+N1Ysu7l+cSfT8v2vWTHfTkCU1W1dl8uf4gZBwNxoO9FCfDZILNQ1tAEh9dR2+RXgKE9k7SjjWqJw=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1932.namprd12.prod.outlook.com (10.175.89.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Mon, 21 Oct 2019 15:37:35 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 15:37:35 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     Mark Salter <msalter@redhat.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - fix uninitialized list head
Thread-Topic: [PATCH] crypto: ccp - fix uninitialized list head
Thread-Index: AQHViCRyu1UoQedhak6p9p8CPd9BXadlOqCA
Date:   Mon, 21 Oct 2019 15:37:35 +0000
Message-ID: <1e373e36-8d7b-51d9-1146-47f8d209af5e@amd.com>
References: <20191021152949.17532-1-msalter@redhat.com>
In-Reply-To: <20191021152949.17532-1-msalter@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0042.namprd05.prod.outlook.com
 (2603:10b6:803:41::19) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70d56870-6152-48d8-3bb4-08d7563c9898
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1932:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1932C9CF8B38748422480F77FD690@DM5PR12MB1932.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(476003)(102836004)(478600001)(81156014)(81166006)(8676002)(4326008)(25786009)(6116002)(3846002)(8936002)(66476007)(66946007)(66556008)(64756008)(66446008)(11346002)(2616005)(31696002)(26005)(6246003)(14454004)(6486002)(446003)(486006)(86362001)(229853002)(31686004)(53546011)(6506007)(386003)(110136005)(6636002)(316002)(186003)(305945005)(7736002)(54906003)(76176011)(66066001)(36756003)(71200400001)(14444005)(52116002)(256004)(71190400001)(99286004)(6512007)(6436002)(5660300002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1932;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 70FWyyXOOXHFydxiuor/6dxi+jy35PvEMhe7lkR/G9VPYdHMHB8mDEw7aokzLbcBDO1b85dqty3lszdATgARsZnlDYet2uBOyToPhqCNH92Jfon2G94q8ozPlV59rD1DUG1IJGZW283/BR2RlxAbsYlizURyi6bUYFMTfg/ErZWiumiF1IRg51uXG8yltA7j/2+p6/ebbN50025zS64oJ8p4odCg6PAolOROcbB4j405JKnVdiLXjsONZkAfNfbrYbZcXccxmN0ZrKDda0u7GnKKZ+IMSyhKtpBhpzzIUW0edHsZs/V/2+JZO+Si7KiThbgxammpoKkASiQLO+0Wfzt9ifgfdK5PtTi6DS61Urd6DMsXRoeH3rzwHXOaK1G8MxzAZqrpY8WkRbgIqPXh1hbvz60VYhlwmzM7IwqRY1OJc0GdEF7yZsXVcrQ5zGli
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <8BF74CC1DD1D784497DF45EA2CEBEAF8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d56870-6152-48d8-3bb4-08d7563c9898
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 15:37:35.7043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vwmg8ScIPzVjRLjc1U7faDoKy7go62vwmdk4xYmynjxs9ijgy3MDWDIDDtunuJ5o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1932
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/21/19 10:29 AM, Mark Salter wrote:
> A NULL-pointer dereference was reported in fedora bz#1762199 while
> reshaping a raid6 array after adding a fifth drive to an existing
> array.
>=20
> [   47.343549] md/raid:md0: raid level 6 active with 3 out of 5 devices, =
algorithm 2
> [   47.804017] md0: detected capacity change from 0 to 7885289422848
> [   47.822083] Unable to handle kernel read from unreadable memory at vir=
tual address 0000000000000000
> ...
> [   47.940477] CPU: 1 PID: 14210 Comm: md0_raid6 Tainted: G        W     =
    5.2.18-200.fc30.aarch64 #1
> [   47.949594] Hardware name: AMD Overdrive/Supercharger/To be filled by =
O.E.M., BIOS ROD1002C 04/08/2016
> [   47.958886] pstate: 00400085 (nzcv daIf +PAN -UAO)
> [   47.963668] pc : __list_del_entry_valid+0x2c/0xa8
> [   47.968366] lr : ccp_tx_submit+0x84/0x168 [ccp]
> [   47.972882] sp : ffff00001369b970
> [   47.976184] x29: ffff00001369b970 x28: ffff00001369bdb8
> [   47.981483] x27: 00000000ffffffff x26: ffff8003b758af70
> [   47.986782] x25: ffff8003b758b2d8 x24: ffff8003e6245818
> [   47.992080] x23: 0000000000000000 x22: ffff8003e62450c0
> [   47.997379] x21: ffff8003dfd6add8 x20: 0000000000000003
> [   48.002678] x19: ffff8003e6245100 x18: 0000000000000000
> [   48.007976] x17: 0000000000000000 x16: 0000000000000000
> [   48.013274] x15: 0000000000000000 x14: 0000000000000000
> [   48.018572] x13: ffff7e000ef83a00 x12: 0000000000000001
> [   48.023870] x11: ffff000010eff998 x10: 00000000000019a0
> [   48.029169] x9 : 0000000000000000 x8 : ffff8003e6245180
> [   48.034467] x7 : 0000000000000000 x6 : 000000000000003f
> [   48.039766] x5 : 0000000000000040 x4 : ffff8003e0145080
> [   48.045064] x3 : dead000000000200 x2 : 0000000000000000
> [   48.050362] x1 : 0000000000000000 x0 : ffff8003e62450c0
> [   48.055660] Call trace:
> [   48.058095]  __list_del_entry_valid+0x2c/0xa8
> [   48.062442]  ccp_tx_submit+0x84/0x168 [ccp]
> [   48.066615]  async_tx_submit+0x224/0x368 [async_tx]
> [   48.071480]  async_trigger_callback+0x68/0xfc [async_tx]
> [   48.076784]  ops_run_biofill+0x178/0x1e8 [raid456]
> [   48.081566]  raid_run_ops+0x248/0x818 [raid456]
> [   48.086086]  handle_stripe+0x864/0x1208 [raid456]
> [   48.090781]  handle_active_stripes.isra.0+0xb0/0x278 [raid456]
> [   48.096604]  raid5d+0x378/0x618 [raid456]
> [   48.100602]  md_thread+0xa0/0x150
> [   48.103905]  kthread+0x104/0x130
> [   48.107122]  ret_from_fork+0x10/0x18
> [   48.110686] Code: d2804003 f2fbd5a3 eb03003f 54000320 (f9400021)
> [   48.116766] ---[ end trace 23f390a527f7ad77 ]---
>=20
> ccp_tx_submit is passed a dma_async_tx_descriptor which is contained in
> a ccp_dma_desc and adds it to a ccp channel's pending list:
>=20
> 	list_del(&desc->entry);
> 	list_add_tail(&desc->entry, &chan->pending);
>=20
> The problem is that desc->entry may be uninitialized in the
> async_trigger_callback path where the descriptor was gotten
> from ccp_prep_dma_interrupt which got it from ccp_alloc_dma_desc
> which doesn't initialize the desc->entry list head. So, just
> initialize the list head to avoid the problem.
>=20
> Reported-by: Sahaj Sarup <sahajsarup@gmail.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/ccp-dmaengine.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-=
dmaengine.c
> index a54f9367a580..0770a83bf1a5 100644
> --- a/drivers/crypto/ccp/ccp-dmaengine.c
> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> @@ -342,6 +342,7 @@ static struct ccp_dma_desc *ccp_alloc_dma_desc(struct=
 ccp_dma_chan *chan,
>   	desc->tx_desc.flags =3D flags;
>   	desc->tx_desc.tx_submit =3D ccp_tx_submit;
>   	desc->ccp =3D chan->ccp;
> +	INIT_LIST_HEAD(&desc->entry);
>   	INIT_LIST_HEAD(&desc->pending);
>   	INIT_LIST_HEAD(&desc->active);
>   	desc->status =3D DMA_IN_PROGRESS;
>=20

