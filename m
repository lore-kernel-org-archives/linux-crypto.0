Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88F7C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADA62075E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MngS67pw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732772AbfKTQVz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:21:55 -0500
Received: from mout.gmx.net ([212.227.15.19]:53483 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfKTQVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574266897;
        bh=xu4ircm6Mkplv/efNNMwLAlVPDoRiD2XqhLUOoHy2/A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MngS67pwPM63jyQtp4EXMbU12otqe7fvi924Kf0nZAoy+CvgGUNlS1Ggb82QN6PmD
         oKEoHJ2y9av+yPClYwKaF+tJTSUUPkzCj/xyzmUtn7sh0vfIfLBPxaABUzqtaH+LlU
         UfCnUTc9BbR4pjHGEzHEEpAElR7QjtDb6/9yUYso=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.139]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M8hZD-1iSo1w0NiD-004nuI; Wed, 20
 Nov 2019 17:21:37 +0100
Subject: Re: [PATCH v3 4/4] ARM: dts: bcm2711: Enable HWRNG support
To:     Stephen Brennan <stephen@brennan.io>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
References: <20191120031622.88949-1-stephen@brennan.io>
 <20191120031622.88949-5-stephen@brennan.io>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <e4ad673b-873b-9bef-1f09-3bdeda892780@gmx.net>
Date:   Wed, 20 Nov 2019 17:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120031622.88949-5-stephen@brennan.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:VzjpvITXKrHb4Xmn1iglZyLcPqx/MkTFcBBCSz7GFHyv2VbGGFg
 JO87hRDAEPzECYOWEtjxqyp0XX6hovTWp9pF6RODgKLjej6yQ3y2MrEqwTTxqLqFpi8L6Wa
 j9Rhd+IT2ZgfYYRGXr3eSUZ5Ovh6YTkI0Orh5hAE8ypHqDBuT8e6OJpNfMs1aI2OOA/nvTj
 7MeLzBQFAjSmYqgXaL2XA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hSVLPUrApkI=:cN5zB46U6clgcMSpU3dFrQ
 Xj/szHK7Kf6lkFgKxdlyXpMfbRogwFXsRwTyMhprZmF2XBvJ/PfTko6/wA1UZRPTN2KKvX4qJ
 rdlxP7WXHFgW0fHVLRYacQDFSFRse3P1wjPHmKseXzI0slW6F0b5/fMslyOzm6kE6Gvy+36F/
 2395wk3w/18ftw3/UVkXT1nOvYMtGjnLJUlx0+Go8HC+Vg13dqUkOFKNO9+zUPxXQOu2qYYTq
 enSENd/plVgrj/V6ZfI2ZUrI719zL2evSQ7FEOPDS2eHyEOGLgrZfWXpvnuQ5r9AAKntjhihK
 gq/Ht4KtClB8tGWHmTb8kRXzHUiQPZuwqVHKpb6qptAq9j7HYYgpvXyQoPvF2jRXPwNlEa5qk
 bEPPM6BlAqcRP5fBx9TJZz5TGgaygfgHdXgSWV5IKbR4+SkivVtdlhGS8TLgh7/Kyg0u/oZxw
 mQCdOCr0aZ0vUB2mJoacFJLJ2XjFNSBriuOqhi/UgxoCuYAiiP7I3Cklul5/wtqZQiwB2yBfs
 KdmHYYL++b55a6zU6oDeW7dN7V0ygckf78g5UfXu9F4OUbvMoYNr0C6BXHr4WTPYP0N1SQ4Aw
 RpF+WjM9d1LUfZRQ0OhDovrVYjqM7WBNk2gB1fCjMcLV+N3Kj4zI9VM+KcVteyUKJb6jNQY/E
 ozUb/nG17mFf97nxk42KZQfYYN7YmOepHB06RLGPkRVePXAARmwLqQ8rdKimAwj7GnzZtVGbn
 YWdpAQ7f5ks1C4dE2ftaV/tKkS0gUPO+xFWPomP6DzZ88mt68P4LCCAkIy++g7INx7kurefP9
 +gZ01g6QCGXgumbBJ2pyUBJieBNkqqJMuxniHcpn3Y5BGNMSyF04Y3GJNOlfBq3yHqsohMM4w
 KctOzMuOfSp5VPDdje1ayhIQIZhTcpJs/8z4G3WFe9pi3d0UORlJx+AYW5mKCkhqPo1V8u+5/
 n+xq3DkqSzC1iUDspJOEDyXczFyUCVHLzhAbLd+God/mIupt/oZax6Qeln1yTL/cNq1wq9q3u
 6LCznRCAygp6IhLLbAyXL7jimCRpbkk2Ay7DRD1UUKj/xa+FU+IN4KqEsPt0X9fYS64NvsPqB
 U0g4oxcaz8Fxqd1FPE5kvqnjxlSGVfcUoMzFijc1/oFuTje8FLXGC4Hmo48r8NIRwYdM1G7lR
 FA5sjsqhnwChE4DpzbBxGzo0lPagUMbdhCoPg+Zp7RTj7iKVMIBPg7CbQE470v3tsmo7yOlmF
 ox83VLw4DLZN4gwZp0lW6wyMtNq8DE/NmODRme0+rIso0iD305nS2aCn8vVc=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 20.11.19 um 04:16 schrieb Stephen Brennan:
> This enables hardware random number generator support for the BCM2711
> on the Raspberry Pi 4 board.
>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>

Acked-by: Stefan Wahren <wahrenst@gmx.net>

Thanks

