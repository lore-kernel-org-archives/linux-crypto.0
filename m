Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B76BC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E593206C2
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZKtwATa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfHOFPm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 01:15:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34511 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbfHOFPm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 01:15:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so264054wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2019 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZvl7hZAVmWv/+YDt5+Kq+rIGSJNDblM26jfYGFa+5Y=;
        b=ZKtwATa8tD6O8PODiFtAorn2s4xCi1sj40QhgWI7Dt9ueCHGTqKN3xj40Yhq9VCl0q
         hEJJ0umG9idpPvnyPM70Wy/wu2+ROGl6SdB9XfuMMSE2Bf0kFGRGa4gDLo9+TAE2zzqV
         8i+0tnQ1osbcWmUqXSnskXMbMEMUAluTGaJNOC4M8ZJf1tAkSiZ6vyAvkucEajTeowrJ
         GQV4+H+JZqvPFliqetxOAMtwGwkwBkzTtOx9EuMRqGkgKdjQ7oJS+sXGIXiHTS9GOTIL
         7nqXGPl1bJ8TWGmi4gP+N9GrfAccnzeAPlu/bpAOjh8moZgOrHOo9WL+WB9jOPbPpUlY
         ZPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZvl7hZAVmWv/+YDt5+Kq+rIGSJNDblM26jfYGFa+5Y=;
        b=cwVTgneNyziQ7GhRdBGuC/jGZimH+/tAckpg5WSr8exp0oLT/ZqnbrNtzTcBLRZU9T
         okZ1inBoRGdswPpauL/mfUj4wdsszMOCkp2VaL0J3VatsZs+5l7ujtzuj6GMSJhcv4tX
         QtvVqjx48DA7vPx7L7WGZqwvWM8FPfbHFnuSnMP4DMLUatDkXCzDac8K8x9lBZ3Ky2nQ
         aF1scHG1me15M+WIBCv099y0QwHGE1WjoASjMu8k+l7FQRIiKMelhK4QTuAVLEZ+bA/W
         UgqZ1WXvUzECL1GyOhs7Y77kPxfhXS2FXwot5x8Sp69/fTCQwFl8O+6XG23haZNqjIct
         38tQ==
X-Gm-Message-State: APjAAAXFlSk5cOquGzw3hnlveTyu4JocADEwT8CzNz2lWsmyILbUpeVY
        K08/jTExYjngjk1DUOivn+dXO3B/rf8Wx6Xeuxv4jA==
X-Google-Smtp-Source: APXvYqxSYK1gIzM7UQ19HMpn96OXM4qgebmodWy6UF/z594An7E0XMo09PI+9IgbQarmBDb87ls7X2nJ2fhMb76nvtI=
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr730899wmo.136.1565846139967;
 Wed, 14 Aug 2019 22:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com> <20190815051320.GA24982@gondor.apana.org.au>
In-Reply-To: <20190815051320.GA24982@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 08:15:29 +0300
Message-ID: <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 15 Aug 2019 at 08:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 07:59:34AM +0300, Ard Biesheuvel wrote:
> >
> > So how do I ensure that the cipher and shash are actually loaded at
> > create() time, and that they are still loaded at TFM init time?
>
> If they're not available at TFM init then you just fail the init
> and therefore the TFM allocation.  What is the problem?
>
> IOW the presence of the block cipher and unkeyed hash does not
> affect the creation of the instance object.
>

Right.

So what about checking that the cipher key size matches the shash
digest size, or that the cipher block size matches the skcipher IV
size? This all moves to the TFM init function?

Are there any existing templates that use this approach?
