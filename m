Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79728C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 05:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A7912073D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 05:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X3oq7lAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbfHBFuW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 01:50:22 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36859 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388195AbfHBFuW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 01:50:22 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so71677399ljj.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2019 22:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vwz8Yfm4Cow2GeEvNxlf9aEZE7OVt1rKT7raAjp8VpA=;
        b=X3oq7lAkHf3gv2MqFLGGzBIFgglHgG5rRPhA3IA/fycv6qEgWi/E/L84U6E0mZJF5k
         HaeRuMoGJlD1AnH/ujS8Un7jZdQyUMaemOE5kq531tVfuOAnjD/LU5AJx52J+CGFad+M
         jFedj9VOB/NnqbRUoJFCIu0uLsAjmh4zr0n2QpQes0qqSw36DYgPoBTlCdlefz4yPDzf
         ZDHoh285WC5GUXxkKWfRJJJ/jy4JL86Kqy8qWDtY1HoxHInqDQbFsced+bOAVZGpUwdZ
         Gcz9jma3dRlxxMCgIJpxiWALuPHaN0nxFpjSnOh3TSquP4VcgUfapw+xPsm/8Iv003js
         NRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vwz8Yfm4Cow2GeEvNxlf9aEZE7OVt1rKT7raAjp8VpA=;
        b=E4tKElPo6IeRU8Lzts2BOQE1yPtLCayR5IuluJ5RmwNeEyy1pnXN8OvPqedysQ6Q3S
         cKTa06Bdy1JP9GmA1LBWfGTz8RkDqKv/1bBeCWdOK0X40Jdt630pEqIlPX1WSddxFqpM
         EIRH84epOtNKNULOBOHSmjxZXvuMJnMVJfQNu33vOSm+QqQaLZz0+6c2ZwrmCLZYx+Ho
         O6/lFATFQitN4xj27O3zsHW1L9s9pq6fLbE/wbteL8GhMye8bqV3kfz6iuqapkVRwNAD
         PFrBeioaqAprVPaA6tBzlq0Ku8IKiMvW6XlXAOJ3JX+SwVa3nI23zoBpSWIK52gtSgme
         /OkQ==
X-Gm-Message-State: APjAAAV0EBenK5klYvSa6i7cgdxr+Hv4tkNfLseGXmjuAP+pf1yL4S4b
        ZlacH30yEBJa8GrSwvZQv2WYyDv+hYhCzux8vI0mCA==
X-Google-Smtp-Source: APXvYqxa1pCtNqv5a9orx+jqYo5gAuz4nI99d0UZk2C8opZTrYtKmFiLmrw+zaVFcZxMgM+dWW013yJe1zTceqVxnvo=
X-Received: by 2002:a2e:301a:: with SMTP id w26mr68823438ljw.76.1564725020734;
 Thu, 01 Aug 2019 22:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <1563449086-13183-1-git-send-email-sumit.garg@linaro.org>
 <1563449086-13183-2-git-send-email-sumit.garg@linaro.org> <20190801172310.cldcftfdoh5vyfjg@linux.intel.com>
In-Reply-To: <20190801172310.cldcftfdoh5vyfjg@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 2 Aug 2019 11:20:09 +0530
Message-ID: <CAFA6WYM+FQuXA9Saj5+ffOGsc-shhiF5Uos4g14Qndvu6w97Sg@mail.gmail.com>
Subject: Re: [RFC/RFT v2 1/2] KEYS: trusted: create trusted keys subsystem
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        jejb@linux.ibm.com, Mimi Zohar <zohar@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Aug 2019 at 22:54, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Thu, Jul 18, 2019 at 04:54:45PM +0530, Sumit Garg wrote:
> > Move existing code to trusted keys subsystem. Also, rename files with
> > "tpm" as suffix which provides the underlying implementation.
> >
> > Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
>
> What about TPM2 trusted keys code?

Isn't TPM2 code located here: "drivers/char/tpm/"? Would you like to
move that code under trusted keys subsystem only?

-Sumit

>
> /Jarkko
