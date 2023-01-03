Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4B4C46467
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 11:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbjACLOL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 06:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237396AbjACLOH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 06:14:07 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB970EE30
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 03:14:05 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230103111400euoutp0246be0c5930617f9c51d078004042534b~2yDS2TBij0724607246euoutp02e;
        Tue,  3 Jan 2023 11:14:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230103111400euoutp0246be0c5930617f9c51d078004042534b~2yDS2TBij0724607246euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1672744440;
        bh=gYFw+zobDjwA98blhx7XUAdlmcOBleS0i6NjCT7cQ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmBGitL5ym9gIZe71SC90dTddUx64dhdSvzI8iUCsLFDTNpft2r6RMK8Pqg6BGzoy
         hvkIpfFPF64LxHhUhAXI+pPiaELLDh2kN6nbfU8qqMh/iF6hsNBgTmxDe+DL+NBcOn
         kC39ZTSJsl5FzTfURkaenCUVdPGVYZkvVTjF/dYY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230103111400eucas1p1285119c05d6ce6c8f5e24733c0e1f11e~2yDStqZgw2027820278eucas1p1P;
        Tue,  3 Jan 2023 11:14:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id B9.36.61936.8FD04B36; Tue,  3
        Jan 2023 11:14:00 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230103111359eucas1p137cb823bdc80d790544de20c3835faf2~2yDSb_NLn0653406534eucas1p1v;
        Tue,  3 Jan 2023 11:13:59 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230103111359eusmtrp29aba65b80eb2e2c49920be768f28a95e~2yDSbbUeZ2966529665eusmtrp25;
        Tue,  3 Jan 2023 11:13:59 +0000 (GMT)
X-AuditID: cbfec7f4-a2dff7000002f1f0-7e-63b40df8d8cc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 34.7B.23420.7FD04B36; Tue,  3
        Jan 2023 11:13:59 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230103111359eusmtip17403fdccab8d63d5d11a9485a0a447d5~2yDSLJ9zF0100001000eusmtip1b;
        Tue,  3 Jan 2023 11:13:59 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: xor_blocks() assumptions
Date:   Tue, 03 Jan 2023 12:13:30 +0100
In-Reply-To: <Y7NizHFsWfMW/cC2@sol.localdomain> (Eric Biggers's message of
        "Mon, 2 Jan 2023 15:03:40 -0800")
Message-ID: <dleftjbknfoopx.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURSFfTPTdqgOjqXiTSUuKFVcoBiUCmpUBBs10R+4rxWGRWghHREk
        MWolqBUiEhdKSCpREcGyCQiWuNRYgyLUBYO4L0EooCLuEpTxaeK/75x377v3vDyalFlECjpO
        v50z6LUJ3mIpVeP43jT9G1MVqXrsEKvzm9MptbW+n1Qfcnmpnz/7TsynNFXnHhGamqs+msri
        g2JNX+WYFdQ66ZwoLiFuB2fwn7dFGmvv+EwmdQenFvZcJvYgp68JudHABkJ1jpkyISktY4sQ
        lFV0i7H4hKDckk9i0Yfg4ZHbEhOi/7RkvZ6F/bMI3rfYRFh0IGh7Uy8SisSsH1itawSUs0pw
        nFkuTCPZFBgwFxCC7cH6gP1chGBTg9ia30UK7MbqofdnFhKYYYPgSVWFROCR7Gzob++VYH8E
        NJjfUPhKHZibu5GwAbBOGhpteSROtggc1+sRZg9w3aySYPaCX3UWAjfsR2B8UCDCIhtB3wEj
        gatC4EnTDzHmBdDSayFxeHdo7RmBJ7tDTs2JvzYDBzJkuHoilB6upzArIMtV9HcHDWRfbEf4
        qYwIPnY9JbPRuLz/AuX9Fyhv8FqS9YWyS/7YngqFBV0k5rlQWvqeOolExWgUl8zrYjh+hp5L
        8eO1Oj5ZH+MXmairRIP/5vbAzU+16Kyr18+OCBrZ0cTB5lflJU6koPSJes5bzuR0VEbKmCjt
        zjTOkLjZkJzA8XY0mqa8RzG51ZZIGRuj3c7Fc1wSZ/h3StBuij1EYNqt3CFxqc1Fomj+UYj0
        VOjXkp1tx23XvhaHa9IW81bJspOuANUmZqSqXKE0tkd4MCVT7V7Dk/rfymUzuI1LtT1hFbty
        MnZ3e4HTNDT4cFi6Zwr97shzZ6hcWjaBOxM2s6GjYW9G0L6tN6pXfOnXWa4NXfiiRyTj1792
        th1jklNbp/nsR/FlRba1pklRw5uC+Yz7WseV8/4LB2y1y+LdC+saY6WNmZO2/Yrr3G0OWdu2
        gZv88u7ooFPWkMzoleOX2j6Pl6tV+1J/dB6dN6wpqS59b6fx0rEP4ZqAUrfMiMfKXQ7+zqzV
        qwLLLyyRK+umn05U/WxRNtw7HkZ7Vox1hd71pvhYbcAU0sBrfwPtIRfZsgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xu7rfebckG+y8rmcx53wLi8XaPX+Y
        LbpfyVjcv/eTyYHFY8vKm0we2w6oemxa1cnm8XmTXABLlJ5NUX5pSapCRn5xia1StKGFkZ6h
        pYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7GoRdfmQveWFUse7uPqYHxgmYXIweHhICJ
        RO9jsy5GLg4hgaWMEisOXGeFiEtJrJyb3sXICWQKS/y51sUGUfOMUWLazeVgNWwCehJr10aA
        mCICahLHlvqDlDMLlEs0nG4CqxAWUJU4tDIEJCwEVHx01gsWEJsFKHxjzmtmEJtTIE/i4+9e
        RhCbV8Bc4s6WjewgtqiApcSfZx/ZIeKCEidnPmGBGJ8t8XX1c+YJjAKzkKRmIUnNAtrMLKAp
        sX6XPkRYW2LZwtfMELatxLp171kWMLKuYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIySbcd+
        bt7BOO/VR71DjEwcjIcYVYA6H21YfYFRiiUvPy9VSYR30otNyUK8KYmVValF+fFFpTmpxYcY
        TYFem8gsJZqcD4zfvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkG
        psCyKW/XmKU+D3+/9rKM1tX7zfsyFrx6E8pWJygRZe8VtnTXu/SH537OWzRfNl717+6D+9L/
        vGW8Lmwfu0a4rfaa4p3XMnMEBXyC1YrikibUfDwZsebyGf93BaXaq6IufPz25X+2S8C/1zkL
        LhRZN84qePc6c5q1wYGanQ99TzhvqmC5cX2JeO2m92K1yz5O+XDC9LDt+2mm6ikqS/l2TnM5
        /WsOs8LcN6+OpV3Q/lS/pzbI0KHM64jmlI3HGNNXGVb8Zp38q1D7Ukb/n6P8on63Z21JnyD8
        1cMh/0nmLJnLn+pMdmmc+yC2qLxkfmfiP+a7t9ZdcajZ6auXPv3n+rN87MlJdYmxUVEXHE44
        aTgosRRnJBpqMRcVJwIAl5aNsycDAAA=
X-CMS-MailID: 20230103111359eucas1p137cb823bdc80d790544de20c3835faf2
X-Msg-Generator: CA
X-RootMTR: 20230103111359eucas1p137cb823bdc80d790544de20c3835faf2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230103111359eucas1p137cb823bdc80d790544de20c3835faf2
References: <Y7NizHFsWfMW/cC2@sol.localdomain>
        <CGME20230103111359eucas1p137cb823bdc80d790544de20c3835faf2@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2023-01-02 pon 15:03>, when Eric Biggers wrote:
> On Mon, Jan 02, 2023 at 11:44:35PM +0100, Lukasz Stelmach wrote:
>> I am researching possibility to use xor_blocks() in crypto_xor() and
>> crypto_xor_cpy(). What I've found already is that different architecture
>> dependent xor functions work on different blocks between 16 and 512
>> (Intel AVX) bytes long. There is a hint in the comment for
>> async_xor_offs() that src_cnt (as passed to do_sync_xor_offs()) counts
>> pages. Thus, it is assumed, that the smallest chunk xor_blocks() gets is
>> a single page. Am I right?
>>=20
>> Do you think adding block_len field to struct xor_block_template (and
>> maybe some information about required alignment) and using it to call
>> do_2 from crypto_xor() may work? I am thinking especially about disk
>> encryption where sectors of 512~4096 are handled.
>>=20
>
> Taking a step back, it sounds like you think the word-at-a-time XOR in
> crypto_xor() is not performant enough, so you want to use a SIMD (e.g. NE=
ON,
> SSE, or AVX) implementation instead.

Yes.

> Have you tested that this would actually give a benefit on the input
> sizes in question,

=2D-8<---------------cut here---------------start------------->8---
[    0.938006] xor: measuring software checksum speed
[    0.947383]    crypto          :  1052 MB/sec
[    0.953299]    arm4regs        :  1689 MB/sec
[    0.960674]    8regs           :  1352 MB/sec
[    0.968033]    32regs          :  1352 MB/sec
[    0.972078]    neon            :  2448 MB/sec
=2D-8<---------------cut here---------------end--------------->8---

(Linux 6.2.0-rc1 running on Odroid XU3 board with Arm Cortex-A15)

The patch below copies, adapts and plugs in __crypto_xor() as
xor_block_crypto.do_2. You can see its results labeled "crypto" above.
Disk encryption is comparable to RAID5 checksumming so the results above
should be adequate.

> especially considering that SIMD can only be used in the kernel if
> kernel_fpu_begin() is executed first?

That depends on architecture. As far as I can tell this applies to Intel
only.

> It also would be worth considering just optimizing crypto_xor() by
> unrolling the word-at-a-time loop to 4x or so.

If I understand correctly the generic 8regs and 32regs implementations
in include/asm-generic/xor.h are what you mean. Using xor_blocks() in
crypto_xor() could enable them for free on architectures lacking SIMD or
vector instructions.

=2D--
diff --git a/arch/arm/include/asm/xor.h b/arch/arm/include/asm/xor.h
index 934b549905f5..ffb67b3cbcfc 100644
=2D-- a/arch/arm/include/asm/xor.h
+++ b/arch/arm/include/asm/xor.h
@@ -142,6 +142,7 @@ static struct xor_block_template xor_block_arm4regs =3D=
 {
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 	do {					\
+		xor_speed(&xor_block_crypto);	\
 		xor_speed(&xor_block_arm4regs);	\
 		xor_speed(&xor_block_8regs);	\
 		xor_speed(&xor_block_32regs);	\
diff --git a/include/asm-generic/xor.h b/include/asm-generic/xor.h
index 44509d48fca2..a04f27607c65 100644
=2D-- a/include/asm-generic/xor.h
+++ b/include/asm-generic/xor.h
@@ -6,6 +6,85 @@
  */
=20
 #include <linux/prefetch.h>
+#include <asm-generic/unaligned.h>
+
+// A.K.A. __crypto_xor()
+static void
+xor_crypto_2(unsigned long bytes, unsigned long * __restrict p1,
+	    const unsigned long * __restrict p2)
+{
+	u8 *dst =3D (u8*)p1;
+	u8 *src1 =3D (u8*)p1;
+	u8 *src2 =3D (u8*)p2;
+        unsigned int len =3D bytes;
+        int relalign =3D 0;
+
+        if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+                int size =3D sizeof(unsigned long);
+                int d =3D (((unsigned long)dst ^ (unsigned long)src1) |
+                         ((unsigned long)dst ^ (unsigned long)src2)) &
+                        (size - 1);
+
+                relalign =3D d ? 1 << __ffs(d) : size;
+
+                /*
+                 * If we care about alignment, process as many bytes as
+                 * needed to advance dst and src to values whose alignments
+                 * equal their relative alignment. This will allow us to
+                 * process the remainder of the input using optimal stride=
s.
+                 */
+                while (((unsigned long)dst & (relalign - 1)) && len > 0) {
+                        *dst++ =3D *src1++ ^ *src2++;
+                        len--;
+                }
+        }
+
+        while (IS_ENABLED(CONFIG_64BIT) && len >=3D 8 && !(relalign & 7)) {
+                if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+                        u64 l =3D get_unaligned((u64 *)src1) ^
+                                get_unaligned((u64 *)src2);
+                        put_unaligned(l, (u64 *)dst);
+                } else {
+                        *(u64 *)dst =3D *(u64 *)src1 ^ *(u64 *)src2;
+                }
+                dst +=3D 8;
+                src1 +=3D 8;
+                src2 +=3D 8;
+                len -=3D 8;
+        }
+
+        while (len >=3D 4 && !(relalign & 3)) {
+                if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+                        u32 l =3D get_unaligned((u32 *)src1) ^
+                                get_unaligned((u32 *)src2);
+                        put_unaligned(l, (u32 *)dst);
+                } else {
+                        *(u32 *)dst =3D *(u32 *)src1 ^ *(u32 *)src2;
+                }
+                dst +=3D 4;
+                src1 +=3D 4;
+                src2 +=3D 4;
+                len -=3D 4;
+        }
+
+        while (len >=3D 2 && !(relalign & 1)) {
+                if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+                        u16 l =3D get_unaligned((u16 *)src1) ^
+                                get_unaligned((u16 *)src2);
+                        put_unaligned(l, (u16 *)dst);
+                } else {
+                        *(u16 *)dst =3D *(u16 *)src1 ^ *(u16 *)src2;
+                }
+                dst +=3D 2;
+                src1 +=3D 2;
+                src2 +=3D 2;
+                len -=3D 2;
+        }
+
+        while (len--)
+                *dst++ =3D *src1++ ^ *src2++;
+}
+
=20
 static void
 xor_8regs_2(unsigned long bytes, unsigned long * __restrict p1,
@@ -697,6 +776,14 @@ xor_32regs_p_5(unsigned long bytes, unsigned long * __=
restrict p1,
 		goto once_more;
 }
=20
+static struct xor_block_template xor_block_crypto =3D {
+	.name =3D "crypto",
+	.do_2 =3D xor_crypto_2,
+	.do_3 =3D NULL,
+	.do_4 =3D NULL,
+	.do_5 =3D NULL,
+};
+
 static struct xor_block_template xor_block_8regs =3D {
 	.name =3D "8regs",
 	.do_2 =3D xor_8regs_2,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmO0DdoACgkQsK4enJil
gBCpvgf+KXrGTM6YtCVZeYHSawHKkMMb0aMhJx/6Uxna1NW7rVJ911VSNi3DMVug
t8JHFsR0wfG6wxhaVuwavJffi2YzTX2O1TsN8SlCrj1FNBQ3Ek7ejMvPtWhdo85H
hKO5SawaSYl8Pspl6KXUmNHh+zEIrjV5zI4hi2PjdKGAJ3c7ufJ3XB2by3PfiETS
G/95BhWWzul1Auk857OPhoU7MIIZ9NgHCFn/ToVFss8r5412bzOyWMkHa+c4VD2/
NJNN/M0KTntx2KZ1XgNvSYw9QFWjQ2qszLDf1LpyQVRaUK/isLd5ZGdMCr/4BqSV
KD7YP9wvJbIpZVUf3dUMi7+Oh8towQ==
=z8mc
-----END PGP SIGNATURE-----
--=-=-=--
