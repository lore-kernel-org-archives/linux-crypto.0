Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E1BC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17EBB619CB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhC3U3S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44509 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhC3U3Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AsBtWOxjVDz2gH38NMvpAo8e1pNHJ51lRkga+dJ2MMg=;
        b=nztWoo8bT12GUJ0Fe2l9oOuM6FKVSxiVR2Nmn+WdcDafAdkKJtUcEzlIyKl06rqfouAwM4
        AUSVJ5Y3uWKQ00Gsk9N06XWR/vsmnQfczM2JsoxxS7T+AYRwd8UUoTxw4TJsb/E+2cUZuR
        Zk7eB7YrirnG5RPoMlgx9c7QGA2UCEM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-rkncsVG3P4qK6rbW8Rp_FQ-1; Tue, 30 Mar 2021 22:29:13 +0200
X-MC-Unique: rkncsVG3P4qK6rbW8Rp_FQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxKiHVgHVLsdATbkRxA/A0I8L5L92b5GLmxx7Dnc1OX/5VykXypoTVlIcczCLTyuwKf6M0gkc4vWKEr2HB73wuYSm3sTLwJtBhCbu6v4YL/v1CAvL/ym2oAXLYDGN9Z4QcTCLZbxEN83HU0iF9rbs80sj7/loE7q+gbfsdvOFMfXCwF8g7hql9LaI3Dc//Y8fs8HllfTRad5dvJrMyGoUrD0Yfn/XXBahJRZO4v1IT1KXQOTLuN/iJw2YUvAN1BPWJP8FpjyhnhtQVg88bnYSxkN5HhCHoz7UcN6dkLdig/tuoyy5ZGgm6SL7CglzGn5sLBmYrVICc5j5X3fQwf1wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sE3Dfo2oa2yW8C7yCeHVYIucFzmvv4WzdRfqQVSxKUE=;
 b=FMRoTI+JUSUVbOJkslvtaXQHfqk8oUVA5q33c4FORwpyTF0PiA5niFxDSntWjtwy8ypJYsRm4bL6wZtZZ9CCeP5lzIIXdFKaSjMpAZr9bycYP7nWiwtqbZ6oG4jKaZdyVM6fsrgw1YwX62o9He5ISvr50CFa6HemAxytbvAtYAmC39ySIqCAzWRTEQbpErgeQQmf6TfPhQIbgA7IuKSAzBbSrr2Bxc5rkr3TDhyoKN5AnP0P64LVu9rw5DBlSQ7PQU049B3jafBigZwc3f5hh4woDk3nMXtTo2RyuDU0Enwn8849Gt3vDeCtFmAjBJZJC29qrHzcM98TygKg7ZOyoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:12 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:12 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>
Subject: [PATCH 00/18] Implement RSASSA-PSS signature verification
Date:   Tue, 30 Mar 2021 22:28:11 +0200
Message-ID: <20210330202829.4825-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7a06ad4-a4d7-4a26-feaa-08d8f3ba7a5c
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33930EBC92B79A8C3D0CFD3CE07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCIn2qzWZKjYse9HHE8z2cLmSxVn17UrI5mcVxa1xpkJjQAd+b6zokhuQxZgqhMG/jG4Q4LCIw8V0TkNVr/uV2mA8joYv4xExs8wpje20WcOsVSSgfu+cGdqfS+je0PmdBuF+dZBXAzUjOlF3vHmqbG2S7e0JQoYeRk3YQM2Puu6c3PgxzyLSP2gFzMdW5JioLhzvhQaEOAhD/LWFWZmGrYeAGAU+Cs10U3nJQDVgjJlJCkiWzEeLIzrSFEFfkFwHahZybUX4Atr1Ug51fEMVa/PiL0f0Ah4iZ5690u14YEFDb7QLjbFbPbJgFY3llHxQNLvzOSW5VfDlPwZYgYTJsXj7L3tVgi4PomAU9str1pG2zhrgDX2qQKBJQDHvnlSfMZjxOgY2qrFVSqtax4pcpwQrZZmLPrqdx5VqMRUmlEk2+xKpfagp+NXk5I1ZLjH/X74K7GMvc748Cs6GCFdQ374FCmOlEOJSqU4G+lcFYqS9QsbfodsczN4qW+G9sUbNS5SmI1mZoPzF117t9vWwu4IxiBnKf+PLciwgdj/aKKK//LAN5zcdy1knI5y72yk7ddpXsrxqBJeAwGQzBbNqTyrdFHTyOc1sRWpm6Ei60eIr2hmygjlTDdDC12TUhKhi1ZivFlfDNNb8nNWdxGvkRtHQ69aw7fzEQBZCh9Ry45IxcOmUB8E6nMhB70MnQBCqNuITrdJWI9lbnQ4nvywhbUfuQj4e47miygGVO4hM7eMJcz1zOF1fvQ5RcatjOby
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(66946007)(83380400001)(8936002)(316002)(6506007)(6486002)(966005)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(107886003)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(15650500001)(26005)(44832011)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1Jt8QG0X6snBgGthGx7b7vk14PPgY3zOc1oC6q1fscMi2UUTKY1aOqTIzTBh?=
 =?us-ascii?Q?B/EID+ES/ZCiTA2cQZa7TKyF185p7hZ7HDnkn46GlyfzbM30mtXBIts3FYFG?=
 =?us-ascii?Q?0c9hzV4bT7zG1AGaTprBtMDXIRCu/M6jTvd7A88uq5hdA4alYC9bINSeuXg1?=
 =?us-ascii?Q?0A0EwaZjI1HWlM6r4sdZoBFodmyel2N+0zMZL/x6nAGSw3jBYOZjWxvBSvzh?=
 =?us-ascii?Q?Uaj97eQssfsgYY158gKeCyLBCuKlWadVqzrjE0IagMeN5Lx5ffT1hWwcKxP1?=
 =?us-ascii?Q?s65hd5F1/CtewoTiWK6cBiejDRQohf7ra/tnfBm/h0jvkm6WsZmKLlJqsCIg?=
 =?us-ascii?Q?hnNEXJQWGauZdbb7MaExA3SSe1pj7m4VqfTCtqjPoJxb23P//MyWE5YAtOhW?=
 =?us-ascii?Q?/jVgbfUub2w0usGLRKnFdeQC0WJEXLBoSHy1YL6orzKblv3Rf0dvKj/vGl9Z?=
 =?us-ascii?Q?W0NxkZbk7wr6etSRwPW5E1cRyMJknMPlvmBgNIR+9N9HW1YcRKDefsNdss4J?=
 =?us-ascii?Q?REbYi7feCEaOs4778uHMqmUcpzQB9ZjXkmFCul0SQn3U0a1GWeFo1/sPVa4N?=
 =?us-ascii?Q?AcbpsW5PZF/Cj/wgTXl7EW3v5f/bMr4HQsVbPcswIwmySvvEYm89JlPoypQS?=
 =?us-ascii?Q?h6Z5ipM5sgiyIxgb3NqajjsCBbP+G2cRAqMAvx9UhuKILF9kNRi3cdhNRQTV?=
 =?us-ascii?Q?XGbZoNKzCQWemzb0MITaE0U+XLhhhdLeo8ZzQFEL/LftOvkKPXkWeKdwPGpJ?=
 =?us-ascii?Q?fEjWSObVhp7Av1+9aFFuqiaZPTaN8XsyOxDwLllcktgP05/M9Cd+04t7uiU9?=
 =?us-ascii?Q?FYcRI6x//2lcgSRjcKyE5GAjENA4BaB+OmMDG+XJVI2CMLoRZiTkGilnNSWa?=
 =?us-ascii?Q?wPYPo1u/W7ICNcY4zcDOFI7063IvUJh56WCmy9K3ui1OJPCeifL2IdPPF4UH?=
 =?us-ascii?Q?qaJ4eQ0TImyVOKM4f0CrcAu6HhPf9sljpTk/2MqgKMN4DCxamTOZHlNXY857?=
 =?us-ascii?Q?WAMlDu7AEkttB0nRoaZN+o6MNQb4IdACxdYBh6eFIZ6kIAs4SZPiPLkuOxDu?=
 =?us-ascii?Q?vXVmORkLN8ib/oKKWPXxKslGaq6VNj3YImQ9sdtKsFl0rvktuG91bObgG50P?=
 =?us-ascii?Q?74WM5XY7k+h8kr/ZD+ACbKTKcjC/86IX5oXI9yQwipxxPCjLIPifQBVnVlUC?=
 =?us-ascii?Q?zr+6NxikTdMnzHX1i7VHidzhUjmbjDbIF1+Ev1kw2dqGLR0QZL3lsgWATVxX?=
 =?us-ascii?Q?ibDXHOQ8Wsh72GGts8LltjyoXZ4cOFadvIVaITu21liEwbya2SLQ8UBNnMSh?=
 =?us-ascii?Q?Uik2B/Bq2Gry4IqJGZK7SFXU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a06ad4-a4d7-4a26-feaa-08d8f3ba7a5c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:11.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcmPczkYP8RUA02AB5u67TA0WtbWnUDzCwQCm/oy22cKbqf8QgawwbknftMYfzzX4NZShT+ooilKZxVr4enyeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Linux currently supports RSA PKCSv1.5 encoding scheme for
signing / verification. This adds support for RSASSA PSS signature
verification as described in RFC8017 [1].

Patch 1 extends the x509 certificate parser to unpack PSS signature
  parameters.
Patches 2-8 pull out the common functions / struct definitions from
  rsa-pkcs1pad.c into rsa-common.c, to be shared across RSA encoding
  scheme implementations.
Patches 9, 10 provide some more plumbing to export the data needed to
  perform PSS operations (salt length, RSA modulus).
Patches 11-16 set up PSS scaffolding and provide the verification
  operation per RFC8017.
Patches 17, 18 turn the final knobs on to allow lowering PSS signatures
  for verification via keyctl.

The patchset is available as a git tree at [2].

Testing:
The implementation was tested by adding reference public keys to the
kernel's keyring via `keyctl padd` and then verifying a known
message digest / signature against this public key via `keyctl pkey_verify`=
.
The reference vectors were taken from:
- the Wycheproof testsuite [3]
- FIPS 186-2 and 186-4 test vectors [4]

The test harness is available at [5].

Example keyctl usage for PSS verification:
rsa_bits=3D4096 # 2048/3072/4096
hash_algo=3Dsha256 # sha1/sha224/sha256/sha384/sha512
saltlen=3D32
# Generate keys, certificate:
openssl req -x509 -newkey rsa:$rsa_bits -nodes -keyout private.pem -out cer=
t.der \
  -days 100 -outform der -$hash_algo -sigopt rsa_padding_mode:pss \
  -sigopt rsa_pss_saltlen:$saltlen -sigopt rsa_mgf1_md:$hash_algo

# Sign data.txt:
openssl dgst -${hash_algo} -sign private.pem -sigopt rsa_padding_mode:pss \
  -sigopt rsa_pss_saltlen:${saltlen} -out sig.bin data.txt

# Digest data.txt:
openssl dgst -${hash_algo} -binary -out data.${hash_algo}.raw data.txt

# Load pubkey into the kernel's keyring:
kv=3D$(keyctl padd asymmetric "test-key" @u < cert.der)

# Verify with `enc=3Dpss`:
keyctl pkey_verify $kv "0" data.${hash_algo}.raw sig.bin "enc=3Dpss hash=3D=
${hash_algo} slen=3D${saltlen}"

[1] https://tools.ietf.org/html/rfc8017#section-8.1
[2] https://github.com/varadgautam/kernel/tree/rsassa-psspad
[3] https://github.com/google/wycheproof/blob/master/testvectors/
[4] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-progr=
am/digital-signatures#rsavs
[5] https://github.com/varadgautam/keyctl-rsa-tests

Varad Gautam (18):
  X.509: Parse RSASSA-PSS style certificates
  crypto: rsa-pkcs1pad: Rename pkcs1pad-specific functions to rsapad
  crypto: rsa-pkcs1pad: Extract pkcs1pad_create into a generic helper
  crypto: rsa-pkcs1pad: Pull out child req processing code into helpers
  crypto: rsa-pkcs1pad: Rename pkcs1pad_* structs to rsapad_*
  crypto: rsa: Start moving RSA common code to rsa-common
  crypto: rsa: Move more common code to rsa-common
  crypto: rsa: Move rsapad_akcipher_setup_child and callback to
    rsa-common
  crypto: Extend akcipher API to pass signature parameters
  crypto: rsa: Move struct rsa_mpi_key definition to rsa.h
  crypto: Scaffolding for RSA-PSS signature style
  crypto: rsa-psspad: Introduce shash alloc/dealloc helpers
  crypto: rsa-psspad: Get signature salt length from a given signature
  crypto: Implement MGF1 Mask Generation Function for RSASSA-PSS
  crypto: rsa-psspad: Provide PSS signature verify operation
  crypto: rsa-psspad: Implement signature verify callback
  crypto: Accept pss as valid encoding during signature verification
  keyctl_pkey: Add pkey parameter slen to pass in PSS salt length

 crypto/Kconfig                            |   6 +
 crypto/Makefile                           |   2 +
 crypto/asymmetric_keys/Makefile           |   5 +-
 crypto/asymmetric_keys/asymmetric_type.c  |   1 +
 crypto/asymmetric_keys/public_key.c       |  18 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 152 ++++++++
 crypto/asymmetric_keys/x509_rsassa.asn1   |  17 +
 crypto/rsa-common.c                       | 291 ++++++++++++++++
 crypto/rsa-pkcs1pad.c                     | 400 +++-------------------
 crypto/rsa-psspad.c                       | 283 +++++++++++++++
 crypto/rsa.c                              |  26 +-
 include/crypto/akcipher.h                 |  26 ++
 include/crypto/internal/rsa-common.h      |  60 ++++
 include/crypto/internal/rsa.h             |   8 +
 include/crypto/public_key.h               |   4 +
 include/linux/keyctl.h                    |   1 +
 include/linux/oid_registry.h              |   3 +
 security/keys/keyctl_pkey.c               |   6 +
 18 files changed, 945 insertions(+), 364 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_rsassa.asn1
 create mode 100644 crypto/rsa-common.c
 create mode 100644 crypto/rsa-psspad.c
 create mode 100644 include/crypto/internal/rsa-common.h

--=20
2.30.2

