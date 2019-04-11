Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA60C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B585217D4
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecsbxL5F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfDKJ6l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:58:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46461 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfDKJ6l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 05:58:41 -0400
Received: by mail-lf1-f68.google.com with SMTP id r25so4186199lfn.13;
        Thu, 11 Apr 2019 02:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcyBxhcS0igGXvUGEN/K4F8ER9bsR/Mpx0jHZhJKY+8=;
        b=ecsbxL5Faw4nftzfj43udFVDpbfHNOjfOFy2iFCEAq3eqghWC58a9h3xUcPK4CZeVI
         oHwDKTBdVOKawBEXH/VqSe1F43j5Vec4U3KTt+2z9Lpdn9QACuJ+Ymh9n9EG7yVFvhC8
         ixxM2YFPxRLR+OOtFT3yXgL3w+HlUJaVC9lUG9KI8QbPQLM4UqXXoLKyhDVjJ4cS/DqR
         8tdnbaUpdJXpUpw8zjM+C3YH6tiEFoYZcvDFAWSApzawOHbXA2AyZNf5c0zVag/oPphh
         rQm6JbHr2fEut8Ze1OmRBv5dwxJIdYMtvGLyH9Q3f7iCWlIoCwu1Rie35ksoPCtwDdco
         BLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcyBxhcS0igGXvUGEN/K4F8ER9bsR/Mpx0jHZhJKY+8=;
        b=blUVgHU2G5mLo5aOro7EKQMcyZo6fR4mpT9+bXN8Jq6mxUT07Wgp7jpYLnq6Fpjzf6
         do8egscJphVzh5yvC3G6rGzyL1QX2IymWtA7CJ2ZEl3p44js7+B67lUW7plzFsND9QmQ
         KgsOZ0Uc/Krzvly44g9UDV0z3liyHa7Fm8FdfCTDZ7oUBBJeIduIQfvDcHxmVjhOk6Oj
         xh8HXLoYAlnHUdpyS7eSmIgrTAuo5oPqCBbFtuscmA0H9K0o5aWLado4Xd9CHnS16nCr
         JKzDPhREmR3HDUPFiqpR5VClXavSf/mP5TgytP83guC4mKqHrtFniQCcZqOWC7wqR6Ko
         GDAQ==
X-Gm-Message-State: APjAAAX6DOx3nYrHSOUS6PYfZlo1ISfHm+Art+Q4MxswMK7jS7eTp1r6
        JomAjH1dfSSYsiIfBOFK6hNtuhAe1XLk/pBekoM=
X-Google-Smtp-Source: APXvYqxlOlEJEvkZXfFQA/tgUo+NLGXir5GMcikHVKi9UjjtN5ymVmPomV0cqlCL8M5St1ZXGk8CAQOoRkbH10AA9R8=
X-Received: by 2002:ac2:51aa:: with SMTP id f10mr25622767lfk.82.1554976718729;
 Thu, 11 Apr 2019 02:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190401124200.17331-1-andrew.shadura@collabora.co.uk> <nycvar.YFH.7.76.1904101400520.9803@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.1904101400520.9803@cbobk.fhfr.pm>
From:   Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date:   Thu, 11 Apr 2019 11:58:26 +0200
Message-ID: <CAN+gG=H6TGtB68-XJ+Pg53EhL_M2m8MG1z33Yenvd9PhXJ=Oqw@mail.gmail.com>
Subject: Re: [PATCH v3] HID: add driver for U2F Zero built-in LED and RNG
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Andrej Shadura <andrew.shadura@collabora.co.uk>,
        linux-input <linux-input@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com, "Theodore Ts'o" <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 3:14 PM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Mon, 1 Apr 2019, Andrej Shadura wrote:
>
> > U2F Zero supports custom commands for blinking the LED and getting data
> > from the internal hardware RNG. Expose the blinking function as a LED
> > device, and the internal hardware RNG as an HWRNG so that it can be used
> > to feed the enthropy pool.
>
> So I still am not really happy about this being wired up into generic HID
> although it's really a USB driver, but we've discussed that already, and I
> don't see any option that'd work substantially better in this case,
> especially from the UX point of view. Oh well. Applied to for-5.2/u2fzero,
> thanks!
>

Hi wish I were CC-ed on these threads.

My CI script now fails because hid-u2fzero.ko needs
devm_hwrng_register and the Kconfig doesn't force pulling the right
dependency.

Also, you probably want to add in .probe() a check for the actual
transport driver (`hid_is_using_ll_driver(hdev, &usb_hid_driver)`) or
you can not use the usbhid functions without crashing the kernel.

Cheers,
Benjamin
