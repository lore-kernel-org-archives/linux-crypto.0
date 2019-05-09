Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775E4C04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 20:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36800217D6
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 20:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HI0yY/sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEIUpE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 16:45:04 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37854 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfEIUpE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 16:45:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id h126so2543721lfh.4
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2019 13:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SkBBPXeIB8LW8cuFnZ2MQROYlV60TjMmGBfCT+tOtok=;
        b=HI0yY/svR6KkVqH+UM6r346wXsZSI8JPRk+WfV2nqWPAPmUO62xlVGxqsnRItjYuok
         BHJRVsaK8xjibTpUXCsQwxmdzjEJ5hG8F3el2HJ1St4itGwD8519+EYd2WbUmeRx5eAR
         mTyGRZ/at0SWK+SbQKx7VDI4iuvSe3j1ed0Kh/V8oHRqfeDcB+tPJ+Zwg8Q9dlZJhuOr
         4ccvhD4AwFnTcrPQvOkc+jEgI0pK/1XtxMO91ujJQR+z778HNeSBDQ9Ne7/Yo7CWKHqP
         mWKcmQ3kka3VRKdBhSDHVgrZpfWELOlE7Qf54aen2VrGPd6U+gnJANcf1ezQxafvJ17g
         4+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SkBBPXeIB8LW8cuFnZ2MQROYlV60TjMmGBfCT+tOtok=;
        b=uDCbEgY69vGXKmsgWp4j5fobmLY/8Tl5SG7z4osQn93KH7SZsyt2usuJbvsIZ5+o+V
         MZxUrStPOb1FeIcIvmK8pnsRtOG4h66Dmp+1j5UuNAHwjiID6T/uXbLb5JfpjpboEOBx
         I4aqlxlBJHVLYMe09lG+xciLYQk+9fLnHwz2JeZtVbWOF0hy8FaSYq6h1hlm8O9ipPek
         V8rz5bMyUf5xDYSUA+RvXP7CoVrTE13dbbItMxOvDpbP+mnKDDgY7LjBsFP+Zm9WWNZQ
         Ua8fMnKYtQpSG/TMmQ16V4Iny3hnmZc6CATTzrCX9QxJS2G635dXsu6LuTMXqMKxYST/
         ha/g==
X-Gm-Message-State: APjAAAW9TjIgjCbGypPr8qfJu4CZ5CQSaYor8HVyhMHdf4Ral97UL4sq
        ajPlhbJza4n5wpOooSJ0H51TDNQi4Z9e6huOLtPeqA==
X-Google-Smtp-Source: APXvYqwJ89daYgRA/3X/6OD+ICirWwVWtRBr/yc//fC2OgaJJdviuvByTSwRjP68U1zu32Rbexi14IilIIrOE78Pac8=
X-Received: by 2002:a19:f243:: with SMTP id d3mr3494821lfk.168.1557434702732;
 Thu, 09 May 2019 13:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org> <20190430162910.16771-6-ard.biesheuvel@linaro.org>
In-Reply-To: <20190430162910.16771-6-ard.biesheuvel@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 May 2019 22:44:51 +0200
Message-ID: <CACRpkdYGzOCAecgG=MkFRJyVEK9sfSXHq7g959TzDvXNWqA-Ug@mail.gmail.com>
Subject: Re: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 30, 2019 at 6:29 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

> Add a compatible string for the Atmel SHA204A I2C crypto processor.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
