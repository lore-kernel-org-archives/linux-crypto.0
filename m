Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623BEECAAA1
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Sep 2022 08:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiILIQV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiILIQU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2022 04:16:20 -0400
Received: from thsbbfxrt01p.thalesgroup.com (thsbbfxrt01p.thalesgroup.com [192.54.144.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC18725EAF
        for <linux-crypto@vger.kernel.org>; Mon, 12 Sep 2022 01:16:19 -0700 (PDT)
Received: from thsbbfxrt01p.thalesgroup.com (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 4MQzvQ4XX8z45SX;
        Mon, 12 Sep 2022 10:16:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thalesgroup.com;
        s=xrt20181201; t=1662970578;
        bh=CDUkufznVUcq+bGXOQSJ4qGZcu/ynfQLFY4lYzAs3OY=;
        h=From:To:Subject:Date:Message-ID:Content-Transfer-Encoding:
         MIME-Version:From;
        b=QctLluNfVJNaQXZITj1bb/1CamUNagWus83RPU50JGivSqzClBk6U5znNTvWOXkpw
         ExsMEapftg0Zeeb6Kiye4SOwcQPX7IwNxnvfCsoxkY6s8rjG4u+8n0uLRor1bRmemf
         +0i2H0ej5E+NY8CHuWc0GR32/30CW3STn1pFAHW5XvQ0QN0Tc0lUf9k8Bo9SyID1M7
         z6U8QaPnhsOCUTH6+ta3L60NPDLrxNKqpYbn4jTdHt3wR8F3UsFFDn5025E9CcRT/q
         QlTRS6c4jI3HUYyUAIVnNizrcxx4qEuTI/SSBrHUdXhn25PJYRz3RA9VrSOQ5Ur0j/
         jma7khNwnAy3w==
From:   GROSSSCHARTNER Benjamin <benjamin.grossschartner@thalesgroup.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "smueller@chronox.de" <smueller@chronox.de>
Subject: drbg using jitterentropy_rng causes huge latencies
Thread-Topic: drbg using jitterentropy_rng causes huge latencies
Thread-Index: AdjGf84ksYXiKWw4SWePZkEAIXXeuQ==
Date:   Mon, 12 Sep 2022 08:16:17 +0000
Message-ID: <a6aff0c118df4497b5e988c42586f4e4@thalesgroup.com>
Accept-Language: en-US, fr-FR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-pmwin-version: 4.0.3, Antivirus-Engine: 3.85.1, Antivirus-Data: 5.95
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello!

On an embedded board based on ARM iMX6UL we observed latencies of over 60ms=
,
during tests using IPsec (strongSwan), that are caused by drbg using jitter=
entropy_rng.

These latencies cause various problems for our system (watchdog is not trig=
gered in time,
loss of synchronization of our communication system,...).

In the past, before commit https://github.com/torvalds/linux/commit/97f2650=
e504033376e8813691cb6eccf73151676
the Jitter RNG was only used if get_random_bytes() did not have sufficient =
entropy available.
Before updating our kernel from 5.4.180 to 5.4.205 (but behavior of current=
 kernel 6.0-rc4 seems to be the same)
we did not notice these latencies caused by the Jitter RNG, because it was =
never actually used by our
system (get_random_bytes() was always ready when seeding drbg).

We need to disable the Jitter RNG, which is not possible because the config=
 option
CRYPTO_JITTERENTROPY is selected by CRYPTO_DRBG. The usage of Jitter RNG in=
 drbg is only enforced in FIPS mode.
So I propose to decouple these config options, as drbg does not need/enforc=
e the usage of the Jitter RNG
if not in FIPS mode. This would enable slower systems to use drbg without t=
he latencies cause by Jitter RNG.

We maintain our own set of kernel patches specific to our needs, but I thin=
k that this change would also be
useful for others to be able to use drbg on slower systems without jitteren=
tropy_rng.

Would there be any chance to get such a patch merged?
Or could the Jitter RNG be optimized to not cause such latencies?

Thanks,
Benjamin
