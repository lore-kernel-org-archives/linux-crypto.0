Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994EAC54EF0
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 16:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjAFQJy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 11:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbjAFQJg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 11:09:36 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0300B6718C
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 08:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673021366; bh=geQ4CHC+i2JlSa2/AOR7CBLBiE50A1JyvQioQ8l7ffY=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=BCVTp9aj5U8Y5X8jhvl7JUpqWJYeJ3iJlI2wtZVOUmOcYmljBdMwE+x6fZ2HZoLgg
         ynQcSUfM/pa1WXOTPmIoeLmedFIKTiUW97oNJM6DNcAEivuhxOzCk0NOyQNSj3tlqd
         R5iREmHSHo6atYpcf7DkpWBIGlyNg3JhvaJWqKyO76yR+vI9Yqv6fHZlXU4veBTwL+
         tzhb64/3f4xVEfLY0KSejNu0ioCrAIfyyrWnR27uxc42iSxwYvPp/jKtSAXYU33zY2
         8RfNAhJl8CXUoO+zTDkiRRzheJkmnykLRz2mpRxefIudbKKpQRD/1T+HAoGqgVV8J9
         3LgISloH+UV7A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.82.22]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWzk3-1pGI871zhZ-00XKY5; Fri, 06
 Jan 2023 17:09:26 +0100
Message-ID: <0d119d3f54eb5decec58b2afcb2119902d8373db.camel@gmx.de>
Subject: Re: [PATCH v3 3/6] crypto/realtek: hash algorithms
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Fri, 06 Jan 2023 17:09:25 +0100
In-Reply-To: <Y7fjfYCQdbP+2MU8@gondor.apana.org.au>
References: <Y7fjfYCQdbP+2MU8@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:CHsjjvWUmCKSpqldgSRvZ5jmt9jDDDZsK9nAZUn/ZzYQwEAXdhw
 tQERAIwWUrzSK2GQJyFz/agiBnPkDlWqqmzzPoqJ4gY7cnuXdMPIvbaqzZz66W7T1FyZFAT
 mIW/F19wCyZGvRBLEb7kH+QyK4DcXcVcfMWSSRsu/lhBylvolejyYlrS0eg1L+HZIKwe6l4
 SHk/cwYE57t8KRcreP2/g==
UI-OutboundReport: notjunk:1;M01:P0:I4M2t67Dz3s=;XU509q3QzChduyyTAPAS8JW1KRl
 +7JhTLnIuP+Gno/P4y3DZE3DezshroJjWda3zGnTOZnfQN6KWECXaH84PC6gFYSGhSg0ulVCh
 PXTK1Gl1V+hMPdOHzBkEAxCiq5M748okMEPPzaGP8UR6kmM9FnfpgEGC5mdMJbgyG1G2e5c/c
 w5xIGHhHutN9b2ABfJ6U1wyGK/6jzr/HdS5WNxeSqSO5LVaj5dXCekU9cgeZTqNoXGlge95tL
 v3G89zjeiUusTOdPhl5P5FH20/5q3E29R4mAXWeP88xUmuRYGlcYdTiW/OyByOinKFq7JDFuW
 T+2IZbIHxccei+ZrmZ32/J/GQEaOv8IqIy4NdJe+Pe+Ik9tJ0g9tKSXRRz4WL4cFSOXCGJjRZ
 1hPtuGhMjcA4krAXwgbuqJPao0VCMCqNmLqbg/hb19r8JDh4RE3Psh5B5e6qHiiZo19l65RdV
 RQTqzgD8ZcwNAYrOouy6J5Zs3DK4uk08x7kzUlI5N83rWw7D5isCqX0/x6kDh9UWltJ9nTPBA
 XlpnEcefi8kZTv8GggLLpmYVKUCvy1tFIhneLLy8f2l07G2xLg/m98AVFgo0xeAttYFYpCrvk
 8OsrlhBu8+U0ovRCCmxUITxUpEF0hQ2ujXuYTtO5ex9G4lMms2HvYLT0iaIdTJN4NeiV2kEtj
 1xcS70UO0vb8oBGQsPoT57RGiwFSn5JwhEwYO1d3nNq+UC2obIGkdBmBnEBn0KTW8fmqtHAYt
 7gtt+PkMHZ5BPxvq5RT7ruG1+TdTY61Lel/CwUandGD3FZvgbxoiZpOCasyseD+6QrYujJaWz
 oNncPA1GEPSCU4tBcs2h6DlxTDe4PIf6RoIHrty3xoYZj8vazri6XNiB7hk9Bc6FB7DCwXGha
 4n7kUESelmrUu+LDlNi23cjrD5X8JRqChroJz2MWKG5XUKA9G5Zev40cflsiWj3nQu83x3Fn/
 oK35lQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 06.01.2023 um 17:01 +0800 schrieb Herbert Xu:
> Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
> >=20
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Off we go */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rtcr_kick_engine(cdev);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rtcr_wait_for_request(cdev, d=
stidx))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return -EINVAL;
>=20
> You cannot sleep in this function because it may be called from
> softirq context.=C2=A0 Instead you should use asynchronous completion.
>=20
> Thanks,

Hm,

I thought that using wait_event() inside the above function should be
sufficient to handle that. Any good example of how to achieve that type
of completion?

Markus

