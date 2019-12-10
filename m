Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23516C2D0C4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9FF42077B
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tuI/1Guu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLJJfk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 04:35:40 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54144 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJJfj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 04:35:39 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBA9ZXcV101503;
        Tue, 10 Dec 2019 03:35:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575970533;
        bh=5ygSKWQkmwxBnzxSd+F0fjSW26XhUDOfURxxaLa/ekQ=;
        h=To:From:Subject:CC:Date;
        b=tuI/1GuunNkjFmAHZXVIM91/wfQl5eYKsM8l1ki3xkNifb2HZvSQhAOCgQYOxPjNh
         +rXfgc3xylGltdgXNDnyFvr0/7khpJRXjEK7QaY8O2Rk5unO5rbegTOKeqS5oykNHm
         v85lWiP1/LJEU0mOsxJ7mN2AATQvuyg5FU11zCY8=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBA9ZXDA042704;
        Tue, 10 Dec 2019 03:35:33 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 10
 Dec 2019 03:35:32 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 10 Dec 2019 03:35:32 -0600
Received: from [10.24.69.174] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBA9ZU5m019547;
        Tue, 10 Dec 2019 03:35:31 -0600
To:     <linux-crypto@vger.kernel.org>, <ard.biesheuvel@linaro.org>
From:   Keerthy <j-keerthy@ti.com>
Subject: aes_expandkey giving wrong expanded keys over
 crypto_aes_expand_key(older deprecated implementation under aes_generic)
CC:     "Kristo, Tero" <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
X-Pep-Version: 2.0
Message-ID: <de5768f5-8c56-bec0-0c73-04aa4805c749@ti.com>
Date:   Tue, 10 Dec 2019 15:05:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------8D41B722205C0F7E42F01844"
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--------------8D41B722205C0F7E42F01844
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

I am not sure if am the first one to report this. It seems like
aes_expandkey is giving me different expansion over what i get with the
older crypto_aes_expand_key which was removed with the below commit:

commit 5bb12d7825adf0e80b849a273834f3131a6cc4e1
Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue Jul 2 21:41:33 2019 +0200

    crypto: aes-generic - drop key expansion routine in favor of library
version

The key that is being expanded is from the crypto aes(cbc) testsuite:

  }, { /* From NIST SP800-38A */
                .key    =3D "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
                          "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
                          "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
                .klen   =3D 24,


The older version crypto_aes_expand_key output that passes the cbc(aes)
decryption test:

ctx.key_dec[0] =3D 0x6fa08be9 & ctx.key_enc[0] =3D 0xf7b0738e
ctx.key_dec[1] =3D 0x3c778c44 & ctx.key_enc[1] =3D 0x52640eda
ctx.key_dec[2] =3D 0x472cc8e & ctx.key_enc[2] =3D 0x2bf310c8
ctx.key_dec[3] =3D 0x2220001 & ctx.key_enc[3] =3D 0xe5799080
ctx.key_dec[4] =3D 0x441649ac & ctx.key_enc[4] =3D 0xd2eaf862
ctx.key_dec[5] =3D 0xb71057e5 & ctx.key_enc[5] =3D 0x7b6b2c52
ctx.key_dec[6] =3D 0x758ac046 & ctx.key_enc[6] =3D 0xf7910cfe
ctx.key_dec[7] =3D 0xad2c9bc8 & ctx.key_enc[7] =3D 0xa5f50224
ctx.key_dec[8] =3D 0xc29a97a3 & ctx.key_enc[8] =3D 0x8e0612ec
ctx.key_dec[9] =3D 0xd8a65b8e & ctx.key_enc[9] =3D 0x6b7f826c
ctx.key_dec[10] =3D 0xe6c92ce1 & ctx.key_enc[10] =3D 0xb9957a0e
ctx.key_dec[11] =3D 0xba72b254 & ctx.key_enc[11] =3D 0xc2fe565c
ctx.key_dec[12] =3D 0x5822b4f3 & ctx.key_enc[12] =3D 0xbdb4b74d
ctx.key_dec[13] =3D 0x5cbb9eb5 & ctx.key_enc[13] =3D 0x1841b569
ctx.key_dec[14] =3D 0xfe64fbf8 & ctx.key_enc[14] =3D 0x9647a785
ctx.key_dec[15] =3D 0xf3061e49 & ctx.key_enc[15] =3D 0xfd3825e9
ctx.key_dec[16] =3D 0xa2df654d & ctx.key_enc[16] =3D 0x44ad5fe7
ctx.key_dec[17] =3D 0xd62e5b1 & ctx.key_enc[17] =3D 0x865309bb
ctx.key_dec[18] =3D 0x319c89ea & ctx.key_enc[18] =3D 0x57f05a48
ctx.key_dec[19] =3D 0x1a3ccc2d & ctx.key_enc[19] =3D 0x4fb1ef21
ctx.key_dec[20] =3D 0x3cfe6c5b & ctx.key_enc[20] =3D 0xd9f648a4
ctx.key_dec[21] =3D 0x2ba045c7 & ctx.key_enc[21] =3D 0x24ce6d4d
ctx.key_dec[22] =3D 0x72a5b9f8 & ctx.key_enc[22] =3D 0x606332aa
ctx.key_dec[23] =3D 0x4992a46 & ctx.key_enc[23] =3D 0xe6303b11
ctx.key_dec[24] =3D 0xf8b7ddc5 & ctx.key_enc[24] =3D 0xd57e5ea2
ctx.key_dec[25] =3D 0x763c93be & ctx.key_enc[25] =3D 0x9acfb183
ctx.key_dec[26] =3D 0xa6464f0b & ctx.key_enc[26] =3D 0x4339f927
ctx.key_dec[27] =3D 0xafbd80fc & ctx.key_enc[27] =3D 0x67f7946a
ctx.key_dec[28] =3D 0xd07adcb5 & ctx.key_enc[28] =3D 0x794a6c0
ctx.key_dec[29] =3D 0x9fbcff7 & ctx.key_enc[29] =3D 0xe1a49dd1
ctx.key_dec[30] =3D 0x9343eca7 & ctx.key_enc[30] =3D 0xeb8617ec
ctx.key_dec[31] =3D 0x175e299c & ctx.key_enc[31] =3D 0x7149a66f
ctx.key_dec[32] =3D 0x9ab82350 & ctx.key_enc[32] =3D 0x32705f48
ctx.key_dec[33] =3D 0x841dc53b & ctx.key_enc[33] =3D 0x5587cb22
ctx.key_dec[34] =3D 0x37194bd0 & ctx.key_enc[34] =3D 0x52136de2
ctx.key_dec[35] =3D 0x8e8b4e7b & ctx.key_enc[35] =3D 0xb3b7f033
ctx.key_dec[36] =3D 0x4445b341 & ctx.key_enc[36] =3D 0x28ebbe40
ctx.key_dec[37] =3D 0xb99205ab & ctx.key_enc[37] =3D 0x59a2182f
ctx.key_dec[38] =3D 0x5ef192ce & ctx.key_enc[38] =3D 0x6bd24767
ctx.key_dec[39] =3D 0xd9811342 & ctx.key_enc[39] =3D 0x3e558c45
ctx.key_dec[40] =3D 0xe7639765 & ctx.key_enc[40] =3D 0x6c46e1a7
ctx.key_dec[41] =3D 0x8770818c & ctx.key_enc[41] =3D 0xdff11194
ctx.key_dec[42] =3D 0x43393012 & ctx.key_enc[42] =3D 0xa751f82
ctx.key_dec[43] =3D 0x1ea5e66b & ctx.key_enc[43] =3D 0x53d707ad
ctx.key_dec[44] =3D 0xc449b19e & ctx.key_enc[44] =3D 0x380540ca
ctx.key_dec[45] =3D 0x5d9cd679 & ctx.key_enc[45] =3D 0x650cc8f
ctx.key_dec[46] =3D 0x7ca2b4fe & ctx.key_enc[46] =3D 0x6a162d28
ctx.key_dec[47] =3D 0xfdd7b6ea & ctx.key_enc[47] =3D 0xb5e73cbc
ctx.key_dec[48] =3D 0xf7b0738e & ctx.key_enc[48] =3D 0x6fa08be9
ctx.key_dec[49] =3D 0x52640eda & ctx.key_enc[49] =3D 0x3c778c44
ctx.key_dec[50] =3D 0x2bf310c8 & ctx.key_enc[50] =3D 0x472cc8e
ctx.key_dec[51] =3D 0xe5799080 & ctx.key_enc[51] =3D 0x2220001
ctx.key_dec[52] =3D 0x105127e8 & ctx.key_enc[52] =3D 0x68342d29
ctx.key_dec[53] =3D 0xffff8000 & ctx.key_enc[53] =3D 0xddd31195
ctx.key_dec[54] =3D 0xffffffd0 & ctx.key_enc[54] =3D 0x109bb3b8
ctx.key_dec[55] =3D 0x0 & ctx.key_enc[55] =3D 0xffff8000
ctx.key_dec[56] =3D 0x11053870 & ctx.key_enc[56] =3D 0x13caf9f5
ctx.key_dec[57] =3D 0xffff8000 & ctx.key_enc[57] =3D 0xffff8000
ctx.key_dec[58] =3D 0x5f5e0ff & ctx.key_enc[58] =3D 0x93caf9e7
ctx.key_dec[59] =3D 0x0 & ctx.key_enc[59] =3D 0xffff8000

Newer aes_expandkey is failing the decryption test and the expansion:

ctx.key_dec[0] =3D 0x6fa08be9 & ctx.key_enc[0] =3D 0xf7b0738e
ctx.key_dec[1] =3D 0x3c778c44 & ctx.key_enc[1] =3D 0x52640eda
ctx.key_dec[2] =3D 0x472cc8e & ctx.key_enc[2] =3D 0x2bf310c8
ctx.key_dec[3] =3D 0x2220001 & ctx.key_enc[3] =3D 0xe5799080
ctx.key_dec[4] =3D 0x441649ac & ctx.key_enc[4] =3D 0xd2eaf862
ctx.key_dec[5] =3D 0xb71057e5 & ctx.key_enc[5] =3D 0x7b6b2c52
ctx.key_dec[6] =3D 0x758ac046 & ctx.key_enc[6] =3D 0xf7910cfe
ctx.key_dec[7] =3D 0xad2c9bc8 & ctx.key_enc[7] =3D 0xa5f50224
ctx.key_dec[8] =3D 0xc29a97a3 & ctx.key_enc[8] =3D 0x8e0612ec
ctx.key_dec[9] =3D 0xd8a65b8e & ctx.key_enc[9] =3D 0x6b7f826c
ctx.key_dec[10] =3D 0xe6c92ce1 & ctx.key_enc[10] =3D 0xb9957a0e
ctx.key_dec[11] =3D 0xba72b254 & ctx.key_enc[11] =3D 0xc2fe565c
ctx.key_dec[12] =3D 0x5822b4f3 & ctx.key_enc[12] =3D 0xbdb4b74d
ctx.key_dec[13] =3D 0x5cbb9eb5 & ctx.key_enc[13] =3D 0x1841b569
ctx.key_dec[14] =3D 0xfe64fbf8 & ctx.key_enc[14] =3D 0x9647a785
ctx.key_dec[15] =3D 0xf3061e49 & ctx.key_enc[15] =3D 0xfd3825e9
ctx.key_dec[16] =3D 0xa2df654d & ctx.key_enc[16] =3D 0x44ad5fe7
ctx.key_dec[17] =3D 0xd62e5b1 & ctx.key_enc[17] =3D 0x865309bb
ctx.key_dec[18] =3D 0x319c89ea & ctx.key_enc[18] =3D 0x57f05a48
ctx.key_dec[19] =3D 0x1a3ccc2d & ctx.key_enc[19] =3D 0x4fb1ef21
ctx.key_dec[20] =3D 0x3cfe6c5b & ctx.key_enc[20] =3D 0xd9f648a4
ctx.key_dec[21] =3D 0x2ba045c7 & ctx.key_enc[21] =3D 0x24ce6d4d
ctx.key_dec[22] =3D 0x72a5b9f8 & ctx.key_enc[22] =3D 0x606332aa
ctx.key_dec[23] =3D 0x4992a46 & ctx.key_enc[23] =3D 0xe6303b11
ctx.key_dec[24] =3D 0xf8b7ddc5 & ctx.key_enc[24] =3D 0xd57e5ea2
ctx.key_dec[25] =3D 0x763c93be & ctx.key_enc[25] =3D 0x9acfb183
ctx.key_dec[26] =3D 0xa6464f0b & ctx.key_enc[26] =3D 0x4339f927
ctx.key_dec[27] =3D 0xafbd80fc & ctx.key_enc[27] =3D 0x67f7946a
ctx.key_dec[28] =3D 0xd07adcb5 & ctx.key_enc[28] =3D 0x794a6c0
ctx.key_dec[29] =3D 0x9fbcff7 & ctx.key_enc[29] =3D 0xe1a49dd1
ctx.key_dec[30] =3D 0x9343eca7 & ctx.key_enc[30] =3D 0xeb8617ec
ctx.key_dec[31] =3D 0x175e299c & ctx.key_enc[31] =3D 0x7149a66f
ctx.key_dec[32] =3D 0x9ab82350 & ctx.key_enc[32] =3D 0x32705f48
ctx.key_dec[33] =3D 0x841dc53b & ctx.key_enc[33] =3D 0x5587cb22
ctx.key_dec[34] =3D 0x37194bd0 & ctx.key_enc[34] =3D 0x52136de2
ctx.key_dec[35] =3D 0x8e8b4e7b & ctx.key_enc[35] =3D 0xb3b7f033
ctx.key_dec[36] =3D 0x4445b341 & ctx.key_enc[36] =3D 0x28ebbe40
ctx.key_dec[37] =3D 0xb99205ab & ctx.key_enc[37] =3D 0x59a2182f
ctx.key_dec[38] =3D 0x5ef192ce & ctx.key_enc[38] =3D 0x6bd24767
ctx.key_dec[39] =3D 0xd9811342 & ctx.key_enc[39] =3D 0x3e558c45
ctx.key_dec[40] =3D 0xe7639765 & ctx.key_enc[40] =3D 0x6c46e1a7
ctx.key_dec[41] =3D 0x8770818c & ctx.key_enc[41] =3D 0xdff11194
ctx.key_dec[42] =3D 0x43393012 & ctx.key_enc[42] =3D 0xa751f82
ctx.key_dec[43] =3D 0x1ea5e66b & ctx.key_enc[43] =3D 0x53d707ad
ctx.key_dec[44] =3D 0xc449b19e & ctx.key_enc[44] =3D 0x380540ca
ctx.key_dec[45] =3D 0x5d9cd679 & ctx.key_enc[45] =3D 0x650cc8f
ctx.key_dec[46] =3D 0x7ca2b4fe & ctx.key_enc[46] =3D 0x6a162d28
ctx.key_dec[47] =3D 0xfdd7b6ea & ctx.key_enc[47] =3D 0xb5e73cbc
ctx.key_dec[48] =3D 0xf7b0738e & ctx.key_enc[48] =3D 0x6fa08be9
ctx.key_dec[49] =3D 0x52640eda & ctx.key_enc[49] =3D 0x3c778c44
ctx.key_dec[50] =3D 0x2bf310c8 & ctx.key_enc[50] =3D 0x472cc8e
ctx.key_dec[51] =3D 0xe5799080 & ctx.key_enc[51] =3D 0x2220001
ctx.key_dec[52] =3D 0x13eaf950 & ctx.key_enc[52] =3D 0x13eaf850
ctx.key_dec[53] =3D 0xffff8000 & ctx.key_enc[53] =3D 0xffff8000
ctx.key_dec[54] =3D 0x105146b0 & ctx.key_enc[54] =3D 0x109ba1f8
ctx.key_dec[55] =3D 0xffff8000 & ctx.key_enc[55] =3D 0xffff8000
ctx.key_dec[56] =3D 0x13eaf950 & ctx.key_enc[56] =3D 0x13eaf9f5
ctx.key_dec[57] =3D 0xffff8000 & ctx.key_enc[57] =3D 0xffff8000
ctx.key_dec[58] =3D 0x105146c0 & ctx.key_enc[58] =3D 0x93eaf9e7
ctx.key_dec[59] =3D 0xffff8000 & ctx.key_enc[59] =3D 0xffff8000

The difference is between 52nd index through 59.

Any ideas if this is expected?

Best Regards,
Keerthy

--------------8D41B722205C0F7E42F01844
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
Xpo=3D
=3DNfsW
-----END PGP PUBLIC KEY BLOCK-----

--------------8D41B722205C0F7E42F01844--
