Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3124BC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CC1213A2
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGfh4y6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfBYORQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:17:16 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:38289 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfBYORQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 09:17:16 -0500
Received: by mail-oi1-f170.google.com with SMTP id q81so7344821oic.5
        for <linux-crypto@vger.kernel.org>; Mon, 25 Feb 2019 06:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98doV2pWrqD1kgakw2grmDQ5HGwSDz328Crt8IIiM1U=;
        b=HGfh4y6CmniG4STIFDkToAjWhNCcBy34QuN0UPfOSeat5MqKU7wcmn7IbOPsc2JEKM
         bfYLXxpBYWcB/qd6l+36Ho8BJVWMaV7Xny1SLBmBDPKCjppJwBrUc3XJ8sfsbx1roeiK
         AOiLW3AZgz66pFqyjAlZG1l+l+f5rlR3eVLss87zOYUn1viQZapa4Q0hf6HbK2Xj5z0v
         MtGi2YSZkTqbT72urFeO5SCrL3+MRCvtRUa+8+Pm6d8V5NISc6VsfTbmkHq1BNljGL8f
         Mo80Sj3p73xVuZHGBoe3kZv9C8kF4IA8BpspDrQ/I+RAjMR0teSmLvP/BZb9OUmUbOEI
         2/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98doV2pWrqD1kgakw2grmDQ5HGwSDz328Crt8IIiM1U=;
        b=qcB1wawkjWIuELwJLa4LMOZeLtThQ3sBQmLam3NfQCtuY1QWQ0TyEGqAQmZH4nu33a
         mvY5C+qEfKSgJeEx11aooHxH7AKfVzwxE+fhwQJpZB15ytWkzAN7EFE6jAhA+6C8yIVn
         f73n7rt29UKqPxRPcL1kP3eAs2nn3e/PucvbrHLeOwgnHIArBmmXHE0WsCg0xIXNq4ci
         FPcrw2U7CsDcrvotdVDV9mKZSLg23nPy+s56EDKk2nllvsglHY6HNkntwncwOzD0/rrP
         FEc9A91NreOB411GF4e8/6doi6gQqB08qgMuDBis3NO1eQvcsctw751FPiW8gifvfBjQ
         n3oA==
X-Gm-Message-State: AHQUAuaw41ORYP7W+Jsw40KN05a7lg1KJqZwLY74fTohmP2BcBxsgAjc
        Wb+KQWwTK5YTrdZ6T9Lh5qEynceQweUp1d+bho0=
X-Google-Smtp-Source: AHgI3IZSju3eZIViWweehxmNONsx7XThEvJmzC9dtM2n1kKOXPMvn8mEX1lCE/t9wC6Pkn4++v7cMMyNGpO1p4RY5nk=
X-Received: by 2002:aca:b886:: with SMTP id i128mr11413453oif.65.1551104235205;
 Mon, 25 Feb 2019 06:17:15 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk> <VI1PR0402MB348578FE91831D11CDCC91D5987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348578FE91831D11CDCC91D5987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Mon, 25 Feb 2019 14:17:03 +0000
Message-ID: <CAGUNXRTe_G91TN-3qP-TAACB6kLXgJn-on5VGCJWbMqrv+rBWw@mail.gmail.com>
Subject: Re: [RFC 0/4] crypto: caam - Add i.MX8MQ support
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 Feb 2019 at 14:03, Horia Geanta <horia.geanta@nxp.com> wrote:
> The code looks *very* similar to what was developed by NXP.
> Why have you stripped off the S-O-Bs?

Hi Horia,

Apologies, I was struggling to find any guidance about what to do with
the tags when upstreaming changes. I will add them in the next
version.

Thanks,
Chris
