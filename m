Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A198EC2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 13:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C78F2086A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 13:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Jl2Clsjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgBLNVD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 08:21:03 -0500
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:10820
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728085AbgBLNVC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 08:21:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PsqNJGl4XTff531gr2Qvb55V9oSnR9n4oPx6YvVgqz12y/WDcPKi0qHyW9tauGqvidmZ04scsQgpgWfhMqUe866Hm1iqAZzdAW4D6qHqYiGpgItNNh9Mfg241Uu7xLl1UqtXd8T/5LN6fm/Q3P3R8SuDjEiyk1loq9k/Rcn1/DDoiU27A1U63C3DOS6ZZUYTTVoyuasyypNhR3yLWms5zNaXefx+jD0917c9HuZj2xWJCm81cNXpTMTmwE1eQJp2giohguTI6Rp/jIQXjOWZN/ffbPvvQg5/n5nYXWHT0FVYRQDyRp7ZBBvw+npPhzG9aAQnYYzM90bjlt08Ht7Ykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n22zklQZaNhPdpCsKdzzK1c0/g5Dq8XU6sq36WCWYQ4=;
 b=fX1KktPRbPsw1fHPv9BlhR3ecAqa73L+o8JFd1pbO48LzjKwxGrPJI9AYP3IZSJEe+cjUMugNTtiAgnVbrphv+offgfiCthtf2tkRBGXolHeHOL2em1JScq3VYcAq3Sp5jImMmj/oLSfedOojuPvNHnSlEPNxDP5iZngXJNVdlgRbgkMSIz+45mQLN5shietNbHN6uud5bSozHp1h4AL9yKiO5TNEl+t7ihyNuOYXf+M/MHYIDP53MsqTCXuX5BYOKb/FdXLiFiB3CVwD/aWj5UDXRu2VMck6kag+sKOzZCb+j3Pk9P/Gb/BGC11qiPhhqWZ8f8QbpuhvGSu3/FvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n22zklQZaNhPdpCsKdzzK1c0/g5Dq8XU6sq36WCWYQ4=;
 b=Jl2ClsjcQGMmEH8F/76uAGmZVnZRxw5+Xct/IZpccyyrhmsCZgypzi9KxvPyTkqwksW5wtKCQ0vMlSV8XsKE71tQkl+1ftmB3OvJbjm92N+D2TByImPou3POvOj6vrHusFCjd0UzXy0qPptqIToAYFQ38WZH+81/DTDYdsQ7j9g=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3533.eurprd04.prod.outlook.com (52.134.5.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.27; Wed, 12 Feb 2020 13:20:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 13:20:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 5/9] crypto: caam - simplify RNG implementation
Thread-Topic: [PATCH v7 5/9] crypto: caam - simplify RNG implementation
Thread-Index: AQHV1TLU8hTlQ3xkmkyrVBnM+/wkUQ==
Date:   Wed, 12 Feb 2020 13:20:57 +0000
Message-ID: <VI1PR0402MB348549DDA8FE2EEB436D3F09981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-6-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fb3bdd5-e166-4cb4-90bf-08d7afbe6529
x-ms-traffictypediagnostic: VI1PR0402MB3533:|VI1PR0402MB3533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3533298F5826B7C83F280CA9981B0@VI1PR0402MB3533.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(199004)(189003)(478600001)(8676002)(81166006)(6506007)(81156014)(55016002)(53546011)(86362001)(7696005)(2906002)(8936002)(9686003)(76116006)(110136005)(316002)(54906003)(186003)(71200400001)(4326008)(44832011)(66476007)(64756008)(5660300002)(52536014)(66446008)(33656002)(26005)(91956017)(66946007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3533;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCqF23VTzsk6VbC1ZHF0ONCXVv9vB1OWXTBYzWpvwnNdN3Sb1zo4a1aMKQHWyqBp70jbMySQ1Wza6NtqVAq0/ogutDpd53crty+WEaWLTbWXswjCqvOlveQ/0Nh2YiDlJxN1aDp3DjMCUoUzrdhLrSY7BPAtc4yBV2xRsMSCZw1e2e7yCN7PrqtQBPRNoJ331R/DqlURvrfJ6lyltebbegHjWoRseo7lgLCuzPj7FibDS/Hb+CCCOkmemr1eR0gytB1GZ1q0bnVB8kLNbvoszDhUHSNWPEGfm42DJ9jkSTxaku5670W9MrKhTFpQ8Hjg8DoNy9Djcj/f6I52h++1+9Iqu0XkLVPW1vWDPy5/Zqh9KCjAbF0UMg72EeNB7KvHVaZto4ehQ7T6YrTkJFL/dMdKwIqUbaWOj5ZvRS7E8K84DU1puxtgPZgxKtU2Bawz
x-ms-exchange-antispam-messagedata: az0xiLrdKTPtRxMC9pv8p+OB/h4LaUxL1wRCtCx6TM/a5qL42TAA8ksUIkuaqh6tCbTO2tMaIZ0DvIS23b/NF24ZJiSAuErh3B+3jTzJRy0s+kqGrN0i0JwAAU6CXetW3mtl4RHRcjGqr/cpFVnRKw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb3bdd5-e166-4cb4-90bf-08d7afbe6529
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 13:20:57.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VU/oSW3tvKOtZsuCIAezERwngorT45BNv4E7twIVzmhJWH5ZFSHxzIr1QxWLL1xwG3v5IO6kTGtc/QMKVA0OWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3533
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> Rework CAAM RNG implementation as follows:=0A=
> =0A=
> - Make use of the fact that HWRNG supports partial reads and will=0A=
> handle such cases gracefully by removing recursion in caam_read()=0A=
> =0A=
> - Convert blocking caam_read() codepath to do a single blocking job=0A=
> read directly into requested buffer, bypassing any intermediary=0A=
> buffers=0A=
> =0A=
> - Convert async caam_read() codepath into a simple single=0A=
> reader/single writer FIFO use-case, thus simplifying concurrency=0A=
> handling and delegating buffer read/write position management to KFIFO=0A=
> subsystem.=0A=
> =0A=
> - Leverage the same low level RNG data extraction code for both async=0A=
> and blocking caam_read() scenarios, get rid of the shared job=0A=
> descriptor and make non-shared one as a simple as possible (just=0A=
> HEADER + ALGORITHM OPERATION + FIFO STORE)=0A=
> =0A=
> - Split private context from DMA related memory, so that the former=0A=
> could be allocated without GFP_DMA.=0A=
> =0A=
> NOTE: On its face value this commit decreased throughput numbers=0A=
> reported by=0A=
> =0A=
>   dd if=3D/dev/hwrng of=3D/dev/null bs=3D1 count=3D100K [iflag=3Dnonblock=
]=0A=
> =0A=
> by about 15%, however commits that enable prediction resistance and=0A=
Running dd as mentioned above, on a i.MX8MM board I see:=0A=
~ 20% decrease in non-blocking case (525 kB/s vs. 662 kB/s)=0A=
~ 75% decrease in blocking case (170 kB/s vs. 657 kB/s)=0A=
=0A=
bs=3D1 is a bit drastic.=0A=
Using bs=3D16 the numbers look better in terms of overall speed,=0A=
however the relative degradation is still there:=0A=
~ 66% decrease in blocking case (3.5 MB/s vs. 10.1 MB/s)=0A=
=0A=
> limit JR total size impact the performance so much and move the=0A=
> bottleneck such as to make this regression irrelevant.=0A=
> =0A=
Yes, performance is greatly impacted by moving from a DRBG configuration=0A=
to a TRNG one.=0A=
=0A=
The speed that I get with this patch set (1.3 kB/s)=0A=
is ~ 20% lower than theoretical output (1.583 kB/s) (see below).=0A=
Seeing this and also the relative decrease in case of DRBG=0A=
makes me wonder whether the SW overhead could be lowered.=0A=
=0A=
Theoretical TRNG output speed in this configuration=0A=
can be computed as:=0A=
Speed =3D (SZ x CAAM_CLK_FREQ) / (RTSDCTL[ENT_DLY] x RTSDCTL[SAMP_SIZE]) [b=
ps]=0A=
=0A=
SZ is sample taken from the DRBG, b/w two consecutive reseedings.=0A=
As previously discussed, this is limited to 128 bits (16 bytes),=0A=
such that the DRBG behaves as a TRNG.=0A=
=0A=
If:=0A=
-CAAM_CLK_FREQ =3D 166 MHz (as for i.MXM*)=0A=
-RTSDCTL[ENT_DLY] =3D 3200 clocks (default / POR value)=0A=
-RTSDCTL[SAMP_SIZE] =3D 512 (recommended; default / POR value is 2500)=0A=
then theoretical speed is 1.583 kB/s.=0A=
=0A=
> @@ -45,38 +22,34 @@=0A=
>  #include "jr.h"=0A=
>  #include "error.h"=0A=
>  =0A=
> +/* length of descriptors */=0A=
This comment is misplaced, length of descriptors (CAAM_RNG_DESC_LEN)=0A=
is further below.=0A=
=0A=
> +#define CAAM_RNG_MAX_FIFO_STORE_SIZE	U16_MAX=0A=
> +=0A=
> +#define CAAM_RNG_FIFO_LEN		SZ_32K /* Must be a multiple of 2 */=0A=
> +=0A=
>  /*=0A=
> - * Maximum buffer size: maximum number of random, cache-aligned bytes th=
at=0A=
> - * will be generated and moved to seq out ptr (extlen not allowed)=0A=
> + * See caam_init_desc()=0A=
>   */=0A=
> -#define RN_BUF_SIZE			(0xffff / L1_CACHE_BYTES * \=0A=
> -					 L1_CACHE_BYTES)=0A=
> +#define CAAM_RNG_DESC_LEN (CAAM_CMD_SZ +				\=0A=
> +			   CAAM_CMD_SZ +				\=0A=
> +			   CAAM_CMD_SZ + CAAM_PTR_SZ_MAX)=0A=
=0A=
> +typedef u8 caam_rng_desc[CAAM_RNG_DESC_LEN];=0A=
Is this really necessary?=0A=
=0A=
> -static int caam_read(struct hwrng *rng, void *data, size_t max, bool wai=
t)=0A=
> +static int caam_rng_read_one(struct device *jrdev,=0A=
> +			     void *dst, int len,=0A=
> +			     void *desc,=0A=
> +			     struct completion *done)=0A=
[...]=0A=
> +	len =3D min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);=0A=
For the blocking case, i.e. caam_read() -> caam_rng_read_one(),=0A=
"len" is at least 32B - cf. include/linux/hw_random.h:=0A=
 * @read:		New API. drivers can fill up to max bytes of data=0A=
 *			into the buffer. The buffer is aligned for any type=0A=
 *			and max is a multiple of 4 and >=3D 32 bytes.=0A=
=0A=
For reducing the SW overhead, it might be worth optimizing this path.=0A=
For example, considering=0A=
min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE) =3D CAAM_RNG_MAX_FIFO_STORE_S=
IZE=0A=
this means length is fixed, thus also ctx->desc[DESC_SYNC] descriptor is fi=
xed=0A=
and its generation could be moved out of the hot path.=0A=
=0A=
Horia=0A=
=0A=
