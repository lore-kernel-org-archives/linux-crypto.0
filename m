Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FA8C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 16 May 2022 15:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245461AbiEPPxh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 May 2022 11:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245454AbiEPPxe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 May 2022 11:53:34 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90931286E8
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2022 08:53:29 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id h29so26634243lfj.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2022 08:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EbahZ8s//MhvZATU5N16vyp5s7VaSnO5nIae4gl0gk0=;
        b=ZP4hri7brP1qH58wG7aKs9+/EslXVGswsHOgXd3Rly2rJt/+O76tPfhxL7OwmpIwKG
         6wxQXWKip2N/EbSsEuz8ZCxYCRYXfvipes/E3nYbQNtQdToMtCFZTl+dbTP2aNk37M9M
         gkn5YyTaHT7izE374+uIt7ybmQc99y30uNZ+augubzOaQ7Hme6ZJ8C9uj5dwxNr6yOrv
         itifkK9fRB+fkvL/kQ47zp+yg5CvyBsRLWTxZrPn/3NM3P10rrFzAU7DsLksyzRXTWpQ
         Ze+X+dmzPJiFyVH2T14K1fYnM7qMHdH0cQuOcMtHoY6Rv+G6cu0e6ghaQJ5PT6NS9ayK
         5C/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EbahZ8s//MhvZATU5N16vyp5s7VaSnO5nIae4gl0gk0=;
        b=QTzoCMxPEI0i5iLFFrjQlYn/55fmcAEMdWf3gLwO1j2l+EG0WzCzpzgbkZk34HUzA3
         KFXZXodbKMddsGNPaMQMfG9mzJiml1C3Pg9AdeecVZjeTs/QUUqOtGAQzTX4A5RdAdz0
         0KoM/L6I/fuuyrGgU4qI3fsJZ3cPe2Dwd+2zzsJC3ksK1QVkBW7FTs4xZIU/CBxIV3Y/
         4EWeACOVSjbj0OA0JsxCySvraXka9SIV1Q+EDCLJvGoluOglIpUkVEhUP5p4dFelbRol
         Sk7unZs5L4IU6Xhj83ovJE6pie/PzVcfEn3KFgD1KKCVdwpSeuqiNVQxS8qkaX7OF7OG
         /a5Q==
X-Gm-Message-State: AOAM5307fOLt5lSEN7k8tFYIUxZCa2Qu5+pqzCIx3xRL38cVb5xWgys4
        kp2x4HL5hHy6fYHwjwbZA75d9hWskf2fvQ1D+EgGB3wm/SNQDA==
X-Google-Smtp-Source: ABdhPJxei5pzg/U2wRl0hGmPsf3kjsYStTXCMlzuL0wRt4xbfEY2ZaFF4tA7VhL8sWDgD3KFEkxl9RE8sbSWb/FOMc8=
X-Received: by 2002:a05:6512:234c:b0:473:c3ba:2cf1 with SMTP id
 p12-20020a056512234c00b00473c3ba2cf1mr13694486lfu.402.1652716407646; Mon, 16
 May 2022 08:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220516154512.259759-1-john.allen@amd.com>
In-Reply-To: <20220516154512.259759-1-john.allen@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 16 May 2022 08:53:16 -0700
Message-ID: <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
To:     John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 16, 2022 at 8:46 AM John Allen <john.allen@amd.com> wrote:
>
> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
>
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc.
>
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - Add fixes tags and CC stable@vger.kernel.org
> ---


static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
{
struct sev_user_data_status data;
int ret;

ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
if (ret)
return ret;

if (copy_to_user((void __user *)argp->data, &data, sizeof(data)))
ret = -EFAULT;

return ret;
}

Would it be safer to memset @data here to all zeros too?
