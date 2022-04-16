Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BD7C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 14:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiDPOgj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 10:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiDPOgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 10:36:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5FA496AB
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 07:34:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u18so12920645eda.3
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 07:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqjBkilQU4/PdTDZWQ+UTomQZExWyaCh/YDiUIu/GK4=;
        b=TtJHMZjJUqWZ8runjgNUOpr4dITWJRHLP6WMMarHjVPZWQxReNhtcclP2YlABPMIyk
         oXtf4FrXGTCbYfQgCJWiMvM0x4ahlBy5/6y1FMQPYg854mH6EB64mqhFjnul7TD79fPp
         x7wGMwb8hPRoNmKGgmw9YIH6BXBR/IbnqhhUkPoW0ZBdb30IKunR0hArxGHVAVXwSqKH
         TpHIbpoO7Fyn7QDCO0ViClRDKswUhKNVNwIOEbnkIaK/c7SAqpJtDReTJurlg6V/gijP
         jNLaMlD6o2L4Eem5jOcqQ1K0n0ugzGVoeQ5A1RNvhr3IL3almJBa0y2lutf+34b5WPxq
         Ko4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqjBkilQU4/PdTDZWQ+UTomQZExWyaCh/YDiUIu/GK4=;
        b=1jgZrh2s9r8ngEbvvyHvQqXx97f8pyqzoqsKRbPWO32znc6AO4puDVFoEKrVUqa9gX
         gkku2974G1oPn0Azv0jZwl1Pt899cYsACxAkaNZ2zfH7SpNE9t1RS07VKIKfK/PV5zGQ
         njCAeZixcfjnTfk9UepUL9SE7P5hSPJ6rQKkAWaHEtvK7T5I2XNGc+NPqS4+B9080N9p
         uRs4NB6ApHPx8Pduq5jD4y+/mgo2PStFVwvZ7FG6fZzdRzw0WBpdY9VuiMBrPa8EVUPO
         b6x+GFoDgSh7/awchSpoivP5L7bsT/wNLo3RgeTcPXjljcQLyCp5OIg8LqiAocAv/K50
         SQWg==
X-Gm-Message-State: AOAM533k5C/fzZ/U7/0F3a2XrDRHh3Lg5RraFW3HrQ/xuv9jGpQEOljx
        WSzJa+hjcBx5kde5ZLuoohb18XEg1r+rSp2lN5u1tOXtMrY=
X-Google-Smtp-Source: ABdhPJxHhbxpeh9qaVT9RLKFzkUvwUzINODyQmF/uXNsNS1dU10DTaqrQxkQyw5GhGoMbPLZn20Y6tJtfhz6vyEh8MQ=
X-Received: by 2002:a05:6402:11cf:b0:41c:dbc7:79d2 with SMTP id
 j15-20020a05640211cf00b0041cdbc779d2mr4091457edw.50.1650119643786; Sat, 16
 Apr 2022 07:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220416135412.4109213-1-festevam@gmail.com>
In-Reply-To: <20220416135412.4109213-1-festevam@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 16 Apr 2022 11:33:53 -0300
Message-ID: <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia Geanta Neag <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia and Varun,

On Sat, Apr 16, 2022 at 10:54 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> From: Fabio Estevam <festevam@denx.de>
>
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6SX:
>
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> ...
>
> This error is due to an incorrect entropy delay for i.MX6SX.
>
> Fix it by increasing the minimum entropy delay for i.MX6SX
> as done in U-Boot:
> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/
>
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Change since v1:
> - Align the fix with U-Boot.

Actually, after thinking more about it, I realize that this issue is
not i.MX6SX specific as
I have seen reports of the same failures on i.MX6D as well.

Would it make sense to fix it like this instead?

--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -516,7 +516,7 @@ struct rng4tst {
        };
 #define RTSDCTL_ENT_DLY_SHIFT 16
 #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
-#define RTSDCTL_ENT_DLY_MIN 3200
+#define RTSDCTL_ENT_DLY_MIN 12000
 #define RTSDCTL_ENT_DLY_MAX 12800
        u32 rtsdctl;            /* seed control register */
        union {

Any drawbacks in using this generic approach?

Please advise.
