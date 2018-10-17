Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:61767
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727000AbeJQVbZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 17:31:25 -0400
From: Horia Geanta <horia.geanta@nxp.com>
To: Neil Armstrong <narmstrong@baylibre.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: dm-integrity stalls with iMX6q CAAM
Date: Wed, 17 Oct 2018 13:35:37 +0000
Message-ID: <VI1PR0402MB3485278043D883A74ED7AEBD98FF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <fbcca5eb-a301-53f4-3faf-a36a3229300d@baylibre.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/21/2018 3:06 PM, Neil Armstrong wrote:=0A=
> Hi,=0A=
> =0A=
> I recently configured dm-crypt + dm-integrity on an iMX6q platform with C=
AAM Hash functions enabled using the following command lines :=0A=
> =0A=
> Linux 4.14.71=0A=
> =0A=
> cryptsetup luksFormat /dev/mmcblk1p3 --cipher aes-xts-plain64 --type luks=
2 --integrity hmac-sha256 --sector-size 512 --use-urandom=0A=
> cryptsetup open /dev/mmcblk1p3 root=0A=
> mkfs.ext4 -v -F /dev/mapper/root=0A=
> =0A=
> luksFormat and open finishes correctly, luksDump and status reports corre=
ct dm and luks properties.=0A=
> =0A=
> but when trying to access the /dev/mapper/root (mkfs, sha256sum or whatev=
er), it blocks without any warning or errors reported by the kernel.=0A=
> I can see a few (~170) interrupts on the jr0 interrupt then nothing.=0A=
> =0A=
> Is there a particular issue with hmac-sha256 with the linux CAAM driver ?=
=0A=
> =0A=
> When disabling the CAAM hash functions or using another cipher & integrit=
y pair, it works like a charm.=0A=
> =0A=
The issue you are seeing is most probably related to CAAM driver not=0A=
implementing correctly the crypto requests "backlogging".=0A=
See commit c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypto=
=0A=
algorithm returns -EBUSY"") for a detailed description.=0A=
=0A=
Historically, there have been several CAAM backlogging implementations prop=
osed=0A=
- but all were rejected:=0A=
v1: https://patchwork.kernel.org/patch/7144701=0A=
v2: https://patchwork.kernel.org/patch/7199241=0A=
v3: https://patchwork.kernel.org/patch/7221941=0A=
v4: https://patchwork.kernel.org/patch/7230241=0A=
v5: https://patchwork.kernel.org/patch/9033121=0A=
=0A=
Discussion here: https://community.nxp.com/message/1020096=0A=
mentions v2 as solving the issue.=0A=
You could try it while we find a solution that would be accepted upstream.=
=0A=
=0A=
Hope this helps,=0A=
Horia=0A=
