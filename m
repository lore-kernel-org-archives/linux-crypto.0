Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70E2C83F1A
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbjH3SoM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245138AbjH3Oe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 10:34:57 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A9F193
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 07:34:53 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 37UEYqcU068591
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 09:34:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1693406092;
        bh=vo3Q+oTgAa6Q6IY+dbZSOpBcaz7iWaDf3Tmtz5pko+8=;
        h=From:To:CC:Subject:In-Reply-To:References:Date;
        b=OTK3igQOrSfigqI3wr3YFJCzdPqeKNwNNBWSOevvNZGnufpH3Hmj0Y0nG8mKvFciQ
         eJkgyYDSUs6M4NnV3gyMNzBWEpgQz3QQ+pNKHz6BRlS4RKH/V1tpeotTLRsNyjIVyx
         gd/l+T8r8g/iY8SojeCaPsaSbJJAvcRigBNOCD3k=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 37UEYqWF057437
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 09:34:52 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 30
 Aug 2023 09:34:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 30 Aug 2023 09:34:52 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 37UEYpx6081510
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 09:34:51 -0500
From:   Kamlesh Gurudasani <kamlesh@ti.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v2 0/6] Add support for
 Texas Instruments MCRC64 engine
In-Reply-To: <20230822051710.GC1661@sol.localdomain>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230812030116.GF971@sol.localdomain>
 <87h6owen39.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <20230822051710.GC1661@sol.localdomain>
Date:   Wed, 30 Aug 2023 20:04:51 +0530
Message-ID: <87sf80d2es.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Fri, Aug 18, 2023 at 02:36:34PM +0530, Kamlesh Gurudasani wrote:
>> Hi Eric,
>>=20
>> We are more interested in offload than performance, with splice system
>> call and DMA mode in driver(will be implemented after this series gets
>> merged), good amount of cpu cycles will be saved.
>
> So it's for power usage, then?  Or freeing up CPU for other tasks?
>
It's for freeing CPU fpr other tasks
>> There is one more mode(auto mode) in mcrc64 which helps to verify crc64
>> values against pre calculated crc64, saving the efforts of comparing in
>> userspace.
>
> Is there any path forward to actually support this?
>
>>=20
>> Current generic implementation of crc64-iso(part of this series)
>> gives 173 Mb/s of speed as opposed to mcrc64 which gives speed of 812
>> Mb/s when tested with tcrypt.
>
> This doesn't answer my question, which to reiterate was:
>
>     How does performance compare to a properly optimized software CRC
>     implementation on your platform, i.e. an implementation using carryle=
ss
>     multiplication instructions (e.g. ARMv8 CE) if available on your plat=
form,
>     otherwise an implementation using the slice-by-8 or slice-by-16 metho=
d?
>
> The implementation you tested was slice-by-1.  Compared to that, it's com=
mon for
> slice-by-8 to speed up CRCs by about 4 times and for folding with carryle=
ss
> multiplication to speed up CRCs by 10-30 times, sometimes limited only by=
 memory
> bandwidth.  I don't know what specific results you would get on your spec=
ific
> CPU and for this specific CRC, and you could certainly see something diff=
erent
> if you e.g. have some low-end embedded CPU.  But those are the typical re=
sults
> I've seen for other CRCs on different CPUs.  So, a software implementatio=
n may
> be more attractive than you realize.  It could very well be the case that=
 a
> PMULL based CRC implementation actually ends up with less CPU load than y=
our
> "hardware offload", when taking into syscall, algif_hash, and driver over=
head...
>
> - Eric

Hi Eric, thanks for your detailed and valuable inputs.

As per your suggestion, we did some profiling.=20

Use case is to calculate crc32/crc64 for file input from user space.

Instead of directly implementing PMULL based CRC64, we made first compariso=
n between=20
Case 1.
CRC32 (splice() + kernel space SW driver)=20
https://gist.github.com/ti-kamlesh/5be75dbde292e122135ddf795fad9f21

Case 2.
CRC32(mmap() + userspace armv8 crc32 instruction implementation)
(tried read() as well to get contents of file, but that lost to mmap() so n=
ot mentioning number here)
https://gist.github.com/ti-kamlesh/002df094dd522422c6cb62069e15c40d

Case 3.
CRC64 (splice() + MCRC64 HW)
https://gist.github.com/ti-kamlesh/98b1fc36c9a7c3defcc2dced4136b8a0


Overall, overhead of userspace + af_alg + driver in (Case 1) and ( Case 3) =
is ~0.025s, which is constant for any file size.
This is calculated using real time to calculate crc  - driver time (time sp=
end inside init() + update() +final()) =3D overhead ~0.025s=20=20=20=20

Here, if we consider similar numbers for crc64 PMULL implementation as crc3=
2 (case 2) , we save good number of cpu cycles using mcrc64
in case of files bigger than 5-10mb as most of the time is being spent
in HW offload.

=E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A6=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=A6=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A6=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A6=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=97
=E2=95=91                   =E2=95=91                             =E2=95=91=
                       =E2=95=91                        =E2=95=91          =
              =E2=95=91
=E2=95=91 File size         =E2=95=91 120mb(ideal size for us)    =E2=95=91=
 20mb                  =E2=95=91 15mb                   =E2=95=91 5mb      =
              =E2=95=91
=E2=95=A0=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A3
=E2=95=91                   =E2=95=91                             =E2=95=91=
                       =E2=95=91                        =E2=95=91          =
              =E2=95=91
=E2=95=91 CRC32 (Case 1)    =E2=95=91 Driver time 0.155s          =E2=95=91=
 Driver time 0.0325s   =E2=95=91 Driver time 0.019s     =E2=95=91 Driver ti=
me 0.0062s    =E2=95=91
=E2=95=91                   =E2=95=91    real time 0.18s          =E2=95=91=
    real time 0.06s    =E2=95=91    real time 0.04s     =E2=95=91    real t=
ime 0.03s     =E2=95=91
=E2=95=91                   =E2=95=91    overhead 0.025s          =E2=95=91=
    overhead 0.025s    =E2=95=91    overhead 0.021s     =E2=95=91    overhe=
ad ~0.023s    =E2=95=91
=E2=95=A0=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A3
=E2=95=91                   =E2=95=91                             =E2=95=91=
                       =E2=95=91                        =E2=95=91          =
              =E2=95=91
=E2=95=91 CRC32 (Case 2)    =E2=95=91 Real time 0.30s             =E2=95=91=
 Real time 0.05s       =E2=95=91 Real time 0.04s        =E2=95=91 Real time=
 0.02s        =E2=95=91
=E2=95=A0=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=AC=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=AC=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A3
=E2=95=91                   =E2=95=91                             =E2=95=91=
                       =E2=95=91                        =E2=95=91          =
              =E2=95=91
=E2=95=91 CRC64 (Case 3)    =E2=95=91 Driver time   0.385s        =E2=95=91=
 Driver time 0.0665s   =E2=95=91 Driver time 0.0515s    =E2=95=91 Driver ti=
me 0.019s     =E2=95=91
=E2=95=91                   =E2=95=91    real time 0.41s          =E2=95=91=
    real time 0.09s    =E2=95=91    real time 0.08s     =E2=95=91    real t=
ime 0.04s     =E2=95=91
=E2=95=91                   =E2=95=91    overhead 0.025s          =E2=95=91=
    overhead 0.025s    =E2=95=91    overhead ~0.025s    =E2=95=91    overhe=
ad ~0.021s    =E2=95=91
=E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A9=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=A9=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A9=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=A9=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=9D
