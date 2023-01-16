Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A88BC54EBE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Jan 2023 15:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjAPPXr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Jan 2023 10:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjAPPXY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2023 10:23:24 -0500
Received: from mail-40136.proton.ch (mail-40136.proton.ch [185.70.40.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DEB23110
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2023 07:21:07 -0800 (PST)
Date:   Mon, 16 Jan 2023 15:20:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n8pjl.ca;
        s=protonmail; t=1673882466; x=1674141666;
        bh=9ROIcCxSwU24OpoN9yTEGGEsUmOW1HNyhUpmcbioTJg=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=5UBduxfG1gCOkgNJ2vWniOv8muZ9owo/AT8a190wmqu0hVW8kRITBYfIzbb5DNr6d
         pHpmsCxvBRWWXDO6lQ0ZtzXiRBGSAm675HVV5f/s60oTpnoRWXG0cSlX7vefC7SoNU
         BUL/YDAdFB1WgleJxIocfcSkmLaz5MYWGKfOts1ygr3kewS/imolDKQOAT8KR4aR08
         9r9w6tEodCVuRxeT4dsNMQAOFy0x1lJAlIiUbhG2ZFlafWTPvRppLS48ZJJDE4MupQ
         LD6ctfuKCKascrxm9osuYFJ56a2brt+S79yC0wDmGYNb5aaa9pxV8DlK/378B1/T9A
         sYTJlzudusD3Q==
To:     Ard Biesheuvel <ardb@kernel.org>
From:   Peter Lafreniere <peter@n8pjl.ca>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: x86 - exit fpu context earlier in ECB/CBC macros
Message-ID: <T7YG602WaDuPk4rYB6-BwCn0pdxSTJxyOR7-vs59gUu1sXMFtkbjCUd1DZ9xuFy9724II9A1qQWf0hKsLJ04qawtcrfO90FA5eYn5hyLzvw=@n8pjl.ca>
In-Reply-To: <CAMj1kXGjOF7bNCS-v02aTZWmzvM-Ad-VYiNbHEmYf5RMHL57bQ@mail.gmail.com>
References: <IBooTlGWpNE7pOelt0gm21bxW7wBILNYJ1HaoPbbfdEEMwz0Pp92vpd_OUlhNFNAitFThTi27P6q6NvcYMKm-y7tjwiF9YbImWjhgC3UDMk=@n8pjl.ca> <CAMj1kXGjOF7bNCS-v02aTZWmzvM-Ad-VYiNbHEmYf5RMHL57bQ@mail.gmail.com>
Feedback-ID: 53133685:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Please don't send encrypted emails to the mailing list. Plaintext
> only, with the patch in the message body (not as an attachment).
> Please use git send-email if you have trouble configuring your email
> client.

My apologies. I was having difficulties configuring git send-email,
but now I believe that I have the issues resolved. Future patches will
be properly formatted.

- Peter
