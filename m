Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4E9C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 12:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3712613BA
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 12:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbhDMM7s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 08:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345923AbhDMM7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 08:59:46 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D9C061756
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 05:59:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FKQfc2M6Cz9sTD;
        Tue, 13 Apr 2021 22:59:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1618318760;
        bh=PQMdde3Q/u/+DhIAdo157u2UL2FmxdhSw43wx/CBgoE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Vst/PGnLBUNUc5kbbYlpN8YQWiGIWYxaIpfuCEQDm+trkRMBUgupmRNnUG63/mTMk
         spK/Ee5FKey2HBkmXg950byJAz3daS1WCmbPDK8KJX9SPUjQ4wVvHK5aVwxWasmhg/
         3ko1rsWW5FQ5bMl5OZtAVyrlvlz/ttOJsMHIU9HJ6FWcdHaA7JohEDqY6XOTDp7MI5
         DiG6JSNSAk0Gvg0Cgl2sWhH65GgPRK7MTwUtCUYPxMs/c+0P8drA/5kTwYdGZk+qqi
         KTiV6EoBRQmyprt8RdPCLXdoHjrtCzq/f2GSpOyITjqfODwqfxYmu131MavzQ70qH1
         HzlbrSR5ZuesA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Haren Myneni <haren@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Subject: Re: [PATCH 02/16] powerpc/vas: Make VAS API powerpc platform
 independent
In-Reply-To: <1804692b-f9d4-964d-bbe4-cb809dad5ee8@csgroup.eu>
References: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
 <d416c7c03dfa20211bf84b760ceaeed307364509.camel@linux.ibm.com>
 <1804692b-f9d4-964d-bbe4-cb809dad5ee8@csgroup.eu>
Date:   Tue, 13 Apr 2021 22:59:15 +1000
Message-ID: <87k0p6s5lo.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> Le 11/04/2021 =C3=A0 02:31, Haren Myneni a =C3=A9crit=C2=A0:
>>=20
>> Using the same /dev/crypto/nx-gzip interface for both powerNV and
>> pseries. So this patcb moves VAS API to powerpc platform indepedent
>> directory. The actual functionality is not changed in this patch.
>
> This patch seems to do a lot more than moving VAS API to independent dire=
ctory. A more detailed=20
> description would help.
>
> And it is not something defined in the powerpc architecture I think, so i=
t should
> remain in some common platform related directory.
>
>>=20
>> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>> ---
>>   arch/powerpc/Kconfig                          | 15 +++++
>>   arch/powerpc/include/asm/vas.h                | 22 ++++++-
>>   arch/powerpc/kernel/Makefile                  |  1 +
>>   .../{platforms/powernv =3D> kernel}/vas-api.c   | 64 ++++++++++--------
>>   arch/powerpc/platforms/powernv/Kconfig        | 14 ----
>>   arch/powerpc/platforms/powernv/Makefile       |  2 +-
>>   arch/powerpc/platforms/powernv/vas-window.c   | 66 +++++++++++++++++++
>>   7 files changed, 140 insertions(+), 44 deletions(-)
>>   rename arch/powerpc/{platforms/powernv =3D> kernel}/vas-api.c (83%)
>>=20
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 386ae12d8523..7aa1fbf7c1dc 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -478,6 +478,21 @@ config PPC_UV
>>=20=20=20
>>   	  If unsure, say "N".
>>=20=20=20
>> +config PPC_VAS
>> +	bool "IBM Virtual Accelerator Switchboard (VAS)"
>> +	depends on PPC_POWERNV && PPC_64K_PAGES
>> +	default y
>> +	help
>> +	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
>
> IIUC is a functionnality in a coprocessor of some IBM processors. Somethi=
ng similar in principle to=20
> the communication coprocessors we find in Freescale processors.

It's not a coprocessor, it's a way you talk to coprocessors.

> It is not a generic functionnality part of the powerpc architecture, I do=
n't think this belongs to=20
> arch/powerpc/Kconfig

But you're right it's not part of the ISA.

> I think it should go in arch/powerpc/platform/Kconfig

The problem with that is it's shared between two existing platforms, ie.
powernv and pseries. We don't want to put it in one or the other.

In the past we have put code like that in arch/powerpc/sysdev, but I am
not a big fan of it, because it's just a bit of a dumping ground.

A while back I created arch/powerpc/platforms/4xx for 40x and 44x
related things, even though there's no actual 4xx platform. I don't
think that's caused any problems.

So I'm inclined to say we should make a arch/powerpc/platforms/book3s
and put VAS in there.

The naming is a bit fishy, because not all book3s CPUs do or will have
VAS. But we would expect any future CPU with VAS to be book3s.

In contrast if we named it platforms/ibm, we could potentially have a
future non-IBM CPU that contains VAS, which would then make the ibm name
confusing.

cheers
