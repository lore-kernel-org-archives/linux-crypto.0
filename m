Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8448C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 12:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46EBF20844
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 12:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pN8+WDo9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfAYMnZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:43:25 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:9872
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfAYMnZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 07:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74VSPB/UJEWtDf1eTBJk2uKKFfL3RMXr8mQ7HhCQ/kc=;
 b=pN8+WDo9F/LwQ9uD8AGx/3vNGOZ6iet05Q2aneE062kjUGuh/aJ84K1jQ4osScdrs6e836W/9CEfXrYc7b/g6+WaksIKK9vEQ/kCBWdTbLddA7PyBDHjK/+FlAQquT/Um5bNCLV8yMklz8HZ86h0wIT0zo7GThr1myGITzNkEh8=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3438.eurprd04.prod.outlook.com (52.134.3.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.31; Fri, 25 Jan 2019 12:43:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%5]) with mapi id 15.20.1537.031; Fri, 25 Jan 2019
 12:43:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Roland Hieber <rhi@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Christian Lamparter <chunkeey@gmail.com>
CC:     Roland Hieber <r.hieber@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Topic: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Index: AQHUsmbwIdQhV/qgPk+dqH8znmHDkA==
Date:   Fri, 25 Jan 2019 12:43:21 +0000
Message-ID: <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190122152651.1150-1-rhi@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3438;6:LEx8an3P/9wF4c0KNJHUJd4xKDhB2Wf/8uTU0kLqH5NIQSgDUQSEP1+4epOkLQ9F4OOXeS2Vf4sJBODLaarp284a8nVbxFRnSJ0f4dU4SZwTlC+rmKT46Unn2Xw7Qj9pEtRYsN83x+YhiBajyQm28DROel5VjqmZ/foc+8KdcmQbfHixSj3YlQ7sr+fB46TEv8ilJBOurdK/3T/XYY1F57+Gr5V09VUo2qidFQBMn2ZhiiCTTD6Uw9UDPUKkjc3P9WMrCGdJhZhny4589BVEs6Xra1BThh0JxXwqFI2aVKG3YIUDaXqTY/SluZb80qRJzfKOoTsTVjQRcTZ9RWlUi2gPymPZ4T5Ab97UVNYUbZYOlFpW6N47d0I5/UJzesKApZGbUh4VQSAf6rBNAEUC9Pc5vjZ3Cv5aVThJUakArBWb2cir8UcVMaPcecVjUqZkmVIodiPm0/0lBXy0TebsXQ==;5:VHrU8RatwMi+nGGLo+F4mNrDGDegHIgT+qTusvie2hTmhy8U7f89c7Iv+nk7WdkTf46wF74HW81+Mh9hUOAQtU7qUo4JG8KNCjnsob+5P26Zl+9/31ba2zW03aUBwq2lJywiIs11bUgDG7lxdZPr3jNuxqA7HbKjTN2qUQR0D2n3U5m7ou/8gALkvIorvJr9UyBJl5j3amMM7xqLtbVsjg==;7:wiLhzpDQ1baAeOXs87qvNW6e7axeK4UhFWiRaFcu6ObdztSLqZoDnokZzI6m2Nrr9wHtnPKwAcvPiOSv1Pd6NwGz1pmigLFb5FXi7K4DqH9g5883j5/8VGf9B6zrsJbKgHdEaoxoGOcXerFIV/OCLw==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: f0ac7306-f9f6-4746-077c-08d682c2b041
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3438;
x-ms-traffictypediagnostic: VI1PR0402MB3438:
x-microsoft-antispam-prvs: <VI1PR0402MB34381BD8010EB3C66BE6A870989B0@VI1PR0402MB3438.eurprd04.prod.outlook.com>
x-forefront-prvs: 0928072091
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(39860400002)(136003)(366004)(51914003)(199004)(189003)(14444005)(256004)(25786009)(110136005)(54906003)(26005)(316002)(2906002)(68736007)(66066001)(45080400002)(186003)(44832011)(446003)(86362001)(7736002)(305945005)(476003)(486006)(97736004)(8936002)(39060400002)(53936002)(9686003)(229853002)(106356001)(8676002)(2501003)(6116002)(102836004)(105586002)(81166006)(6436002)(4326008)(14454004)(81156014)(478600001)(71200400001)(76176011)(53546011)(6506007)(55016002)(99286004)(74316002)(33656002)(71190400001)(6246003)(3846002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3438;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tSdNrsXToc4IJQOmcBflvMQmKWRB88LHi8/yscLzWiUsTIMVsct2ssGMRl+4jqV+IEIPejHzqkXpDfAnSdIKOCWu8ns6VS03/fDPrLe6Zm79+KERg2qBbFPPRnBPYcndsRq3sUJvACUoIseZEz+m1hnYpHtWwu6n//nhnm6ghMt1LNvjUbSqs61FsIaARAJXCT37nwhUJLmDQJ2X73Kn8IK2qd/VIsbbk+SzYWSeYRgWPw31qxLmffW8I4sWJ1Gq7UItXfJDuSBvQK8rkKSK3N3kq2Zx27eyEUFybmwXCs/8GSnO9Vb8/RiZOeVz+nCAETfitZ/u0oBJN4iJPIvouN+skYA32YJdCaJlyr7sYC8pUUAMdnzuE3rWD4fOdhmibWZ8H17+8Rk+lVFvZ6o2TFMqm6HhfaD+xB2Q00B8KVw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ac7306-f9f6-4746-077c-08d682c2b041
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2019 12:43:21.0571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3438
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/22/2019 5:27 PM, Roland Hieber wrote:=0A=
> On a v4.19 i.MX6 system with IMA and CONFIG_DMA_API_DEBUG enabled, a=0A=
> warning is generated when accessing files on a filesystem for which IMA=
=0A=
> measurement is enabled:=0A=
> =0A=
>     ------------[ cut here ]------------=0A=
>     WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:1181 check_for_stack.par=
t.9+0xd0/0x120=0A=
>     caam_jr 2101000.jr0: DMA-API: device driver maps memory from stack [a=
ddr=3Db668049e]=0A=
>     Modules linked in:=0A=
>     CPU: 0 PID: 1 Comm: switch_root Not tainted 4.19.0-20181214-1 #2=0A=
>     Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)=0A=
>     Backtrace:=0A=
>     [<c010efb8>] (dump_backtrace) from [<c010f2d0>] (show_stack+0x20/0x24=
)=0A=
>     [<c010f2b0>] (show_stack) from [<c08b04f4>] (dump_stack+0xa0/0xcc)=0A=
>     [<c08b0454>] (dump_stack) from [<c012b610>] (__warn+0xf0/0x108)=0A=
>     [<c012b520>] (__warn) from [<c012b680>] (warn_slowpath_fmt+0x58/0x74)=
=0A=
>     [<c012b62c>] (warn_slowpath_fmt) from [<c0199acc>] (check_for_stack.p=
art.9+0xd0/0x120)=0A=
>     [<c01999fc>] (check_for_stack.part.9) from [<c019a040>] (debug_dma_ma=
p_page+0x144/0x174)=0A=
>     [<c0199efc>] (debug_dma_map_page) from [<c065f7f4>] (ahash_final_ctx+=
0x5b4/0xcf0)=0A=
>     [<c065f240>] (ahash_final_ctx) from [<c065b3c4>] (ahash_final+0x1c/0x=
20)=0A=
>     [<c065b3a8>] (ahash_final) from [<c03fe278>] (crypto_ahash_op+0x38/0x=
80)=0A=
>     [<c03fe240>] (crypto_ahash_op) from [<c03fe2e0>] (crypto_ahash_final+=
0x20/0x24)=0A=
>     [<c03fe2c0>] (crypto_ahash_final) from [<c03f19a8>] (ima_calc_file_ha=
sh+0x29c/0xa40)=0A=
>     [<c03f170c>] (ima_calc_file_hash) from [<c03f2b24>] (ima_collect_meas=
urement+0x1dc/0x240)=0A=
>     [<c03f2948>] (ima_collect_measurement) from [<c03f0a60>] (process_mea=
surement+0x4c4/0x6b8)=0A=
>     [<c03f059c>] (process_measurement) from [<c03f0cdc>] (ima_file_check+=
0x88/0xa4)=0A=
>     [<c03f0c54>] (ima_file_check) from [<c02d8adc>] (path_openat+0x5d8/0x=
1364)=0A=
>     [<c02d8504>] (path_openat) from [<c02dad24>] (do_filp_open+0x84/0xf0)=
=0A=
>     [<c02daca0>] (do_filp_open) from [<c02cf50c>] (do_open_execat+0x84/0x=
1b0)=0A=
>     [<c02cf488>] (do_open_execat) from [<c02d1058>] (__do_execve_file+0x4=
3c/0x890)=0A=
>     [<c02d0c1c>] (__do_execve_file) from [<c02d1770>] (sys_execve+0x44/0x=
4c)=0A=
>     [<c02d172c>] (sys_execve) from [<c0101000>] (ret_fast_syscall+0x0/0x2=
8)=0A=
>     ---[ end trace 3455789a10e3aefd ]---=0A=
> =0A=
> The cause is that the struct ahash_request *req is created as a=0A=
> stack-local variable up in the stack (presumably somewhere in the IMA=0A=
> implementation), then passed down into the CAAM driver, which tries to=0A=
> dma_single_map the req->result (indirectly via map_seq_out_ptr_result)=0A=
> in order to make that buffer available for the CAAM to store the result=
=0A=
> of the following hash operation.=0A=
> =0A=
> The calling code doesn't know how req will be used by the CAAM driver,=0A=
> and there could be other such occurrences where stack memory is passed=0A=
> down to the CAAM driver. Therefore we should rather fix this issue in=0A=
> the CAAM driver where the requirements are known.=0A=
> =0A=
> The problem is solved by introducing a temporary buffer in the auxiliary=
=0A=
> struct ahash_edesc, which is kmalloc'ed and can be DMA-mapped safely to=
=0A=
> receive the result from hardware. Then the result is copied back into=0A=
> req->result in the respective done callbacks that are called when the=0A=
> CAAM has finished the request.=0A=
> =0A=
Roland, thanks for the accurate analysis and the fix!=0A=
=0A=
Instead of adding a new buffer, I would prefer re-using the partial hash bu=
ffer=0A=
(state->caam_ctx) for storing also the final hash.=0A=
I'll shortly send a v2 using this approach.=0A=
=0A=
> Other hardware crypto drivers which use DMA also solve it this way, see=
=0A=
> for example atmel_sha_copy_ready_hash() in drivers/crypto/atmel-sha.c.=0A=
> =0A=
Indeed.=0A=
Unfortunately the crypto API does not guarantee req->result is DMAable (we'=
ve=0A=
gone through this also for the IV).=0A=
=0A=
I've skimmed through the crypto engine drivers (drivers/crypto/*), out of=
=0A=
curiosity - to see how many are affected by this.=0A=
=0A=
At least two other drivers seem to incorrectly DMA map req->result: amcc an=
d axis.=0A=
=0A=
Many other drivers are affected performance-wise - since they are forced to=
=0A=
memcpy the data: atmel-sha.c, ccree, chelsio, img-hash.c, inside-secure,=0A=
marvell, mxs-dcp.c, qce, sahara.c, stm32, ux500.=0A=
=0A=
Herbert, is there something we could do to avoid this?=0A=
=0A=
Thanks,=0A=
Horia=0A=
